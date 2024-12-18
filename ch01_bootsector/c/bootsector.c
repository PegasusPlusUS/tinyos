// It's EXTREMELY HARD to REALIABLE pass param to 16bit inline asm (GPT said and many AI struggled and failed)
// So we choose using shared data to pass params. EVEN C code function param passing is not working!!!!!! So
// we have to use macro
// CC = i686-elf-gcc
// CFLAGS = -m16 -ffreestanding -fno-pie \
//          -nostdlib -nostdinc -fno-asynchronous-unwind-tables \
//          -fno-builtin -fno-stack-protector -mno-mmx -mno-sse
////#pragma GCC optimize("O0")
#include "bootsector.h"

ASM_EPILOG;

FN_BIOS_SET_CURSOR_POS__ROW_COL;

// Time get_rtc_time(void);
// void print_time_at(Time time, char row, char col, char color);

DATA_BIOS_PARAM;

FN_BIOS_PRINT_STRING__MSG_COLOR;
FN_BIOS_CLEAR_SCREEN;

//const char* HELLO_MSG = "Hello, bootsector in ASM and C by i686-elf-gcc!";
const char* HELLO_MSG = "H";
//char ADV_MSG[] = "Tutorial at https://github.com/pegasusplus/tinyos ";
char ADV_MSG[] = "Tutorial ";
short _scroll_pos_ = 0;

FN_BIOS_PRINT_ADDRESS_AS_HEX;

volatile char temp;
void print_adv_msg_scroll() {
    BIOS_PRINT_STRING__MSG(ADV_MSG + _scroll_pos_);
    temp = ADV_MSG[_scroll_pos_];
    ADV_MSG[_scroll_pos_] = 0;
    BIOS_PRINT_STRING__MSG(ADV_MSG);
    ADV_MSG[_scroll_pos_] = temp;
    if (++_scroll_pos_ >= sizeof(ADV_MSG)) {
        _scroll_pos_ = 0;
    }
    char stack_var;
    //Will hang if assign to stack_var or even access address of stack_var
    //stack_var = 'H';
    _address_ = &stack_var;
    //BIOS_GET_ADDRESS_OF_STACK_VAR(stack_var);
    //BIOS_PRINT_ADDRESS_AS_HEX();

    // asm volatile (
    //     "lea %1, %%ax\n\t" // Load the address of tmp into AX
    //     "mov %%ax, %0\n\t" // Move the address from AX to pch
    //     : "=m"(pch) // Output operand: pch
    //     : "m"(tmp) // Input operand: tmp 
    //     : "ax" // Clobbered register 
    //     );
    // print_address_as_hex();
    // asm volatile (
    //     "mov %%ss, %%ax\n\t"
    //     "mov %%ax, _address_\n\t"
    //     :
    //     :
    //     :
    //     );
    // print_address_as_hex();
}

volatile int delay;

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    BIOS_CLEAR_SCREEN();
    BIOS_PRINT_STRING__MSG_COLOR(HELLO_MSG, COLOR_WHITE);
    BIOS_SET_PRINT_COLOR__COLOR(COLOR_GREEN);
 
    while (1) {
        delay = 0;
        while (++delay < 100000) {
            __asm__ volatile ("nop");
        }
        BIOS_SET_CURSOR_POS__ROW_COL(10, 0);
        print_adv_msg_scroll();
    }
}

__asm__(".section .boot_signature\n"
        ".byte 0x55, 0xAA\n");
