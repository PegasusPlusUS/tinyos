// i686-elf-gcc can't generate 16bit stack operation so that param to 16bit inline asm (GPT said and many AI struggled and failed)
// So we choose using shared data to pass params. EVEN C code function param passing is not working!!!!!! So
// we have to use macro
#include "bootsector.h"

ASM_EPILOG;

FN_BIOS_SET_CURSOR_POS_P_ROW_COL;

// Time get_rtc_time(void);
// void print_time_at(Time time, char row, char col, char color);

DATA_BIOS_PARAM;
DATA_ADV_MSG;

FN_BIOS_PRINT_STRING__MSG_COLOR;
FN_BIOS_CLEAR_SCREEN;

char HELLO_MSG[] = " Hi, elf-gcc! ";
short _scroll_pos_ = 0;

FN_BIOS_PRINT_ADDRESS_AS_HEX;

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
    BIOS_PRINT_STRING_P_MSG(HELLO_MSG + _scroll_pos_);
    _asm_char_2_ = HELLO_MSG[_scroll_pos_];
    HELLO_MSG[_scroll_pos_] = 0;
    BIOS_PRINT_STRING_P_MSG(HELLO_MSG);
    HELLO_MSG[_scroll_pos_] = _asm_char_2_;
    if (++_scroll_pos_ >= sizeof(HELLO_MSG)) {
        _scroll_pos_ = 0;
    }
}

volatile int delay;

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    BIOS_CLEAR_SCREEN();
    BIOS_SET_CURSOR_POS_P_ROW_COL(12, 27);
    BIOS_BIOS_SET_PRINT_COLOR_P_COLOR(COLOR_GREEN);
    BIOS_PRINT_STRING_P_MSG(ADV_MSG);
 
    while (1) {
        delay = 0;
        while (++delay < 280000) {
            __asm__ volatile ("nop");
        }

        BIOS_SET_CURSOR_POS_P_ROW_COL(9, 33); // 33 = 40 - sizeof(HI_MSG)/2
        BIOS_BIOS_SET_PRINT_COLOR_P_COLOR(COLOR_WHITE);
        print_hi_msg_scroll();
        //test_stack_var();
    }
}

END_BOOTSECTOR
