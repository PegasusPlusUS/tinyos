//Define USE_ASM_BIOS_XXX before include bootsector.h
#define USE_ASM_BIOS_CLEAR_SCREEN
#define USE_ASM_BIOS_SET_CURSOR_POS
#define USE_ASM_BIOS_PRINT_CHAR
#define USE_ASM_BIOS_SET_PRINT_COLOR
//#define USE_ASM_BIOS_PRINT_STRING

#include "bootsector.h"

BEGIN_ASM_BOOTSECTOR;

DATA_ADV_MSG;

char HELLO_MSG[] = " Hi, gcc! ";
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

//void print_hi_msg_scroll() {
//    asm_bios_print_char('H');
//    //asm_bios_print_string(HELLO_MSG + _scroll_pos_, COLOR_GREEN);
//    unsigned char _asm_char_2_ = HELLO_MSG[_scroll_pos_];
//    HELLO_MSG[_scroll_pos_] = 0;
//    asm_bios_print_char('i');
//    //asm_bios_print_string(HELLO_MSG, COLOR_LIGHT_BLUE);
//    HELLO_MSG[_scroll_pos_] = _asm_char_2_;
//    if (++_scroll_pos_ >= sizeof(HELLO_MSG)) {
//        _scroll_pos_ = 0;
//    }
//}

void print_string(const char *str) {
    while (*str) {
        asm_bios_print_char(*str++);
    }
}

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    asm_bios_clear_screen();
    asm_bios_set_cursor_pos(12, 5);
    asm_bios_set_print_color(COLOR_GREEN);
    print_string(ADV_MSG);
 
    volatile int delay;
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
