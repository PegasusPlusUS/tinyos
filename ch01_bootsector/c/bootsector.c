// i686-elf-gcc can't generate 16bit stack operation so that param to 16bit inline asm (GPT said and many AI struggled and failed)
// So we choose using shared data to pass params. EVEN C code function param passing is not working!!!!!! So
// we have to use macro
#define USE_ASM_BIOS_CLEAR_SCREEN
#define USE_ASM_BIOS_SET_CURSOR_POS
#define USE_ASM_BIOS_PRINT_CHAR
#define USE_ASM_BIOS_SET_PRINT_COLOR
//#define USE_ASM_BIOS_PRINT_STRING

#include "bootsector.h"

BEGIN_ASM_BOOTSECTOR;


DATA_BIOS_PARAM;
DATA_ADV_MSG;


#ifdef USE_ASM_BIOS_SET_CURSOR_POS
void asm_bios_set_cursor_pos(unsigned char row, unsigned char col) {
    __asm__ volatile (
        "pushal\n\t"
        "movb %0, %%dh\n\t"
        "movb %1, %%dl\n\t"
        "movb $0x02, %%ah\n\t"
        "int $0x10\n\t"
        "popal\n\t"
        :
        : "r"(row), "r"(col)
        :
    );
}
#endif

// Time get_rtc_time(void);
// void print_time_at(Time time, char row, char col, char color);

#ifdef USE_ASM_BIOS_CLEAR_SCREEN
void asm_bios_clear_screen() {
    __asm__ volatile (
        "pushal\n\t"
        "movw $0x0003, %%ax\n\t"
        "int $0x10\n\t"
        "popal\n\t"
        :
        :
        :
    );
}
#endif

#ifdef USE_ASM_BIOS_SET_PRINT_COLOR
void asm_bios_set_print_color(unsigned char c) {
    __asm__ volatile (
        "pushal\n\t"
        "movb $0x0, %%bh\n\t"
        "movb %0, %%bl\n\t"
        "movb $0x0, %%ah\n\t"
        "int $0x10\n\t"
        "popal\n\t"
        :
        : "r"(c)
        : "memory"
    );
}
#endif

#ifdef USE_ASM_BIOS_PRINT_CHAR
void asm_bios_print_char(unsigned char c) {
    __asm__ volatile (
        "pushal\n\t"
        "movb %0, %%al\n\t"
        "movb $0x09, %%ah\n\t"
        "movw $0x01, %%cx\n\t"
        "int $0x10\n\t"
        "popal\n\t"
        :
        : "r"(c)
        : "memory"
    );
}
#endif

#ifdef USE_ASM_BIOS_PRINT_STRING
void asm_bios_print_string(const char msg[], unsigned char colour) {
    _asm_msg_ = "msg"; 
    _asm_char_1_ = colour;

    __asm__ volatile (
        ".code16\n\t"
        "pushal\n\t"                  // Save all general-purpose registers
        "mov _asm_msg_, %%si\n\t"     // Load the address of the string into SI
    ".loop:\n\t"
        "lodsb\n\t"                    // Load the next byte from [SI] into AL
        "test %%al, %%al\n\t"          // Test AL (check for null terminator)
        "jz .done\n\t"                 // Jump to done if AL is 0 (null terminator)
        "movb 'H', %%al\n\t"            // Load character into AL
        "movb $0x09, %%ah\n\t"         // BIOS teletype (character + attribute)
        "movw $1, %%cx\n\t"            // Print 1 character
        "movb _asm_char_1_, %%bl\n\t"  // Load color attribute into BL
        "xor %%bh, %%bh\n\t"           // Page number 0
        "int $0x10\n\t"                // Call BIOS interrupt to print character
        /* Move cursor forward */
        "movb $0x03, %%ah\n\t"         // BIOS get cursor position, result col in %dl
        "xor %%bh, %%bh\n\t"           // Page number 0
        "int $0x10\n\t"                // Call BIOS interrupt to get cursor position
        "inc %%dl\n\t"                 // Increment column (move cursor forward)
        "movb $0x02, %%ah\n\t"         // BIOS set cursor position
        "int $0x10\n\t"                // Call BIOS interrupt to set cursor position
        "jmp .loop\n\t"                // Repeat loop to print next char
    ".done:\n\t"
        "popal\n\t"                    // Restore all general-purpose registers
        :
        :
        : "memory"                     // Clobbered registers
    );
}
#endif

char HELLO_MSG[] = " Hi, gcc! ";
short _scroll_pos_ = 0;

//FN_BIOS_PRINT_ADDRESS_AS_HEX;

// void test_stack_var() {
//     char stack_var;
//     //Will hang if assign to stack_var or even access address of stack_var
//     //stack_var = 'H';
//     //_address_ = &stack_var;
//     //BIOS_GET_ADDRESS_OF_STACK_VAR(stack_var);
//     //BIOS_PRINT_ADDRESS_AS_HEX();

//     // asm volatile (
//     //     "lea %1, %%ax\n\t" // Load the address of tmp into AX
//     //     "mov %%ax, %0\n\t" // Move the address from AX to pch
//     //     : "=m"(pch) // Output operand: pch
//     //     : "m"(tmp) // Input operand: tmp 
//     //     : "ax" // Clobbered register 
//     //     );
//     // print_address_as_hex();
//     // asm volatile (
//     //     "mov %%ss, %%ax\n\t"
//     //     "mov %%ax, _address_\n\t"
//     //     :
//     //     :
//     //     :
//     //     );
//     // print_address_as_hex();
// }

void print_hi_msg_scroll() {
    asm_bios_print_char('H');
    //asm_bios_print_string(HELLO_MSG + _scroll_pos_, COLOR_GREEN);
    _asm_char_2_ = HELLO_MSG[_scroll_pos_];
    HELLO_MSG[_scroll_pos_] = 0;
    asm_bios_print_char('i');
    //asm_bios_print_string(HELLO_MSG, COLOR_LIGHT_BLUE);
    HELLO_MSG[_scroll_pos_] = _asm_char_2_;
    if (++_scroll_pos_ >= sizeof(HELLO_MSG)) {
        _scroll_pos_ = 0;
    }
}

volatile int delay;

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    asm_bios_clear_screen();
    asm_bios_set_cursor_pos(0, 0);
    asm_bios_set_print_color(COLOR_WHITE);
    asm_bios_print_char('C');
    //asm_bios_print_string(ADV_MSG, COLOR_GREEN);
 
    while (1) {
        delay = 0;
        while (++delay < 32000) {
            __asm__ volatile ("nop");
        }

        //asm_bios_set_cursor_pos(9, 33); // 33 = 40 - sizeof(HI_MSG)/2
        //print_hi_msg_scroll();
        //test_stack_var();
    }
}

END_BOOTSECTOR
