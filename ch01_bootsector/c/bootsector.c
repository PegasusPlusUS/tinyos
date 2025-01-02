#define USE_C_PRINT_STRING_AT
#include "common_prefix.h"

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

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    asm_bios_clear_screen();
    c_print_string_at(ADV_MSG, 12, 27, COLOR_GREEN);
 
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

END_ASM_BOOTSECTOR
