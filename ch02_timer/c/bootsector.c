// It's EXTREMELY HARD to REALIABLE pass param to 16bit inline asm (GPT said and many AI struggled and failed)
// So we choose using shared data to pass params. EVEN C code function param passing is not working!!!!!! So
// we have to use macro
// CC = i686-elf-gcc
// CFLAGS = -m16 -ffreestanding -fno-pie \
//          -nostdlib -nostdinc -fno-asynchronous-unwind-tables \
//          -fno-builtin -fno-stack-protector -mno-mmx -mno-sse
////#pragma GCC optimize("O0")
#include "../../ch01_bootsector/c/bootsector.h"

ASM_EPILOG;

FN_BIOS_CLEAR_SCREEN;
FN_BIOS_SET_CURSOR_POS__ROW_COL;
FN_BIOS_PRINT_STRING__MSG_COLOR;

// Time get_rtc_time(void);
// void print_time_at(Time time, char row, char col, char color);
DATA_BIOS_PARAM;
DATA_ADV_MSG;

// Messages
char* HELLO_MSG = "C in timer mode!";
short _scroll_pos_ = 0;

void print_hi_msg_scroll() {
    BIOS_PRINT_STRING__MSG(HELLO_MSG + _scroll_pos_);
    _asm_char_2_ = HELLO_MSG[_scroll_pos_];
    HELLO_MSG[_scroll_pos_] = 0;
    BIOS_PRINT_STRING__MSG(HELLO_MSG);
    HELLO_MSG[_scroll_pos_] = _asm_char_2_;
    if (++_scroll_pos_ >= sizeof(HELLO_MSG)) {
        _scroll_pos_ = 0;
    }
}

void __attribute__((no_instrument_function)) timer_handler() {
__asm__(
    ".code16\n\t"             // Changed from .code16gcc to .code16
    ".global _isr_\n\t"
    "_isr_:\n\t"
        "pushal\n\t"            //PUSH_REGISTERS

        "mov %cs, %ax\n\t"      // Setup data segment
        "mov %ax, %ds\n\t"
        "mov %ax, %es\n\t"
);

        BIOS_SET_CURSOR_POS__ROW_COL(8, 33);
        BIOS_SET_PRINT_COLOR__COLOR(COLOR_WHITE);
        print_hi_msg_scroll();

__asm__(
        "movb $0x20, %al\n\t"   // ACK ISR
        "outb %al, $0x20\n\t"

        "popal\n\t"     //POP_REGISTERS
        "iret\n\t"
    );  // jump to bootsector_main
}

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    BIOS_CLEAR_SCREEN();
    BIOS_SET_CURSOR_POS__ROW_COL(12, 27);
    BIOS_SET_PRINT_COLOR__COLOR(COLOR_GREEN);
    BIOS_PRINT_STRING__MSG(ADV_MSG);
 
__asm__(
    "cli\n\t"

        "movb $0x36, %al\n\t"       /* // Channel 0, square wave mode */
        "outb %al, $0x43\n\t"       /* // Send control word to PIT */
        "movw $0x04AF, %ax\n\t"     /* // Load value for 1000 Hz (1193 in decimal) */
        "outb %al, $0x40\n\t"       /* // Send low byte to PIT channel 0 */
        "movb %ah, %al\n\t"
        "outb %al, $0x40\n\t"       /* // Send high byte to PIT channel 0 */

        // Set up ISR for IRQ0
        "xor %ax, %ax\n\t"          /* // Clear AX (set to zero) */
        "mov %ax, %es\n\t"          /* // Set ES to zero (flat segment) */
        "lea _isr_, %dx\n\t"       /* // Load the address of _isr_ into DX */
        "movw %dx, %es:0x20*4\n\t"  // Set ISR offset for IRQ0
        "movw $0, %es:0x20*4+2\n\t" // Set ISR segment

        "mov $0xFE, %al\n\t"        // Enable IRQ0 only
        "out %al, $0x21\n\t"        // Send command to PIC
    "sti\n\t"
);

    while (1) {
        __asm__ volatile ("nop");
    }
}

__asm__(".section .boot_signature\n"
        ".byte 0x55, 0xAA\n");
