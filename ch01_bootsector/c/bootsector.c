// It's EXTREMELY HARD to REALIABLE pass param to 16bit inline asm (GPT said and many AI struggled and failed)
// So we choose using shared data to pass params. EVEN C code function param passing is not working!!!!!! So
// we have to use macro
// CC = i686-elf-gcc
// CFLAGS = -m16 -ffreestanding -fno-pie \
//          -nostdlib -nostdinc -fno-asynchronous-unwind-tables \
//          -fno-builtin -fno-stack-protector -mno-mmx -mno-sse
////#pragma GCC optimize("O0")

__asm__(
    ".code16\n\t"             // Changed from .code16gcc to .code16
    ".global _start\n\t"
"_start:\n"
    "xor %ax, %ax\n\t"        // Set up segments
    "mov %ax, %ds\n\t"
    "mov %ax, %es\n\t"
    "mov %ax, %ss\n\t"
    "mov $0x7C00, %sp\n\t"
    "jmp $0x0000, $bootsector_main\n"
);  // jump to bootsector_main

// Time get_rtc_time(void);
// void print_time_at(Time time, char row, char col, char color);

// Colors
enum {
    COLOR_WHITE = 0x0F,
    COLOR_YELLOW = 0x0E,
    COLOR_CYAN = 0x0D,
    COLOR_RED = 0x0C,
    COLOR_BLUE = 0x0B,
    COLOR_GREEN = 0x0A,
    COLOR_PURPLE = 0x09,
    COLOR_ORANGE = 0x08,
    COLOR_BROWN = 0x07,
    COLOR_GREY = 0x06,
    COLOR_LIGHT_GREY = 0x05,
    COLOR_DARK_GREY = 0x04,
    COLOR_GREY_BLUE = 0x03,
    COLOR_LIGHT_GREEN = 0x02,
    COLOR_LIGHT_BLUE = 0x01,
    COLOR_BLACK = 0x00,
};

volatile char _asm_char_1_ = 0;
volatile char _asm_char_2_ = 0;
volatile char _asm_color_ = COLOR_YELLOW;

// Messages
const char* HELLO_MSG = "Hello, bootsector in ASM and C by i686-elf-gcc!";
char* ADV_MSG = "TinyOS is an open source tutorial at https://github.com/pegasusplus/tinyos ";
short _scroll_pos_ = 20;
volatile const char* _asm_msg_;

#define SET_PRINT_COLOR(color) \
    do {    \
        _asm_color_ = color;    \
    } while(0)

void asm_set_cursor_position() {
    __asm__ volatile (
        "movb $0x02, %%ah\n\t"          /* Set cursor position */
        "movb $0, %%bh\n\t"             /* Page number = 0 */
        "movb _asm_char_1_, %%dh\n\t"   /* Row (input parameter 1) */
        "movb _asm_char_2_, %%dl\n\t"   /* Column (input parameter 2) */
        "int $0x10\n\t"                 /* BIOS interrupt 0x10 */
        :                               /* No outputs */
        :                               /* Inputs: row -> %0, col -> %1 */
        : "ah", "dh", "dl"//, "bh"        /* Clobbered registers */
    );
}

//void set_cursor_position(short row, short col) {
#define SET_CURSOR_POS(row, col) \
    do { \
        _asm_char_1_ = row; \
        _asm_char_2_ = col; \
\
        asm_set_cursor_position(); \
    } while (0)

// // put ch in _asm_char_ and color in _asm_color_
// void asm_print_char() {
//     __asm__ volatile (
//         // Prolog
//         "push %%ax\n\t"          // Save AX
//         "push %%bx\n\t"          // Save BX
//         "push %%cx\n\t"          // Save CX

//         "movb _asm_char_1_, %%al\n\t"    // Load ch
//         "movb _asm_color_, %%bl\n\t"   // Yellow color into BL
//         "movb $0x09, %%ah\n\t"   // BIOS write character function
//         "movw $1, %%cx\n\t"      // Print one character
//         "int $0x10\n\t"          // Call BIOS interrupt

//         // Epilogue: Restore registers
//         "pop %%cx\n\t"           // Restore CX
//         "pop %%bx\n\t"           // Restore BX
//         "pop %%ax\n\t"           // Restore AX
//         :
//         :
//         : "ax", "bx", "cx", "dl", "bh", "dh", "si", "memory"       // Clobbered registers
//     );
// }

// #define PRINT_CHAR(ch) \
//     do {    \
//         _asm_char_1_ = ch;  \
//         asm_print_char();   \
//     }  while(0)

#define PRINT_STRING(msg)   \
    do {    \
        _asm_msg_ = msg;    \
        asm_print_string(); \
    } while(0)

void asm_print_string() {
    __asm__ volatile (
        // Prologue: Save registers
        // "push %%ax\n\t"          // Save AX
        // "push %%bx\n\t"          // Save BX
        // "push %%cx\n\t"          // Save CX

        "mov [_asm_msg_], %%si\n\t"
        "movb _asm_color_, %%bl\n\t"  //
    ".loop:\n\t"
        // Load next character
        "lodsb\n\t"              // Load next byte from [ESI] into AL (address of str pointed by ESI)
        "test %%al, %%al\n\t"    // Test AL (check for null terminator)
        "jz .done\n\t"           // Jump to done if AL is 0 (null terminator)
        
        // Print character (BIOS 0x09 teletype function)
        "movb $0x09, %%ah\n\t"   // BIOS teletype (character + attribute)
        "movw $1, %%cx\n\t"      // Print 1 character
        "push %%bx\n\t"          // Save BX
        "movb $0, %%bh\n\t"      // Page number 0
        "int $0x10\n\t"          // Call BIOS interrupt
        
        "pop %%bx\n\t"           // Restore BX
        
        // Move cursor forward
        "movb $0x03, %%ah\n\t"   // BIOS get cursor position
        "movb $0, %%bh\n\t"      // Page number 0
        "int $0x10\n\t"          // Call BIOS interrupt to get cursor position
        
        "inc %%dl\n\t"           // Increment column (move cursor forward)
        "movb $0x02, %%ah\n\t"   // BIOS set cursor position
        "int $0x10\n\t"          // Call BIOS interrupt to set cursor position
        
        "jmp .loop\n\t"          // Repeat loop
        
    ".done:\n\t"
        // Epilogue: Restore registers
        // "pop %%cx\n\t"           // Restore CX
        // "pop %%bx\n\t"           // Restore BX
        // "pop %%ax\n\t"           // Restore AX
        :
        :
        : "ah", "dl", "cx", "si", "memory", "bh"//, "bl" // Clobbered registers
    );
}

void asm_clear_screen() {
    __asm__ volatile (
        "mov $0x0003, %ax\n"
        "int $0x10\n" // Clear screen
    );
}

void print_adv_msg_scroll() {
    PRINT_STRING(ADV_MSG + _scroll_pos_);
    char temp = ADV_MSG[_scroll_pos_];
    ADV_MSG[_scroll_pos_] = 0;
    PRINT_STRING(ADV_MSG);
    ADV_MSG[_scroll_pos_] = temp;
    if (++_scroll_pos_ >= sizeof(ADV_MSG) - 1) {
        _scroll_pos_ = 0;
    }
}

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    asm_clear_screen();

    PRINT_STRING(HELLO_MSG);
    SET_CURSOR_POS(10, 0);
    SET_PRINT_COLOR(COLOR_GREEN);
    print_adv_msg_scroll();
    print_adv_msg_scroll();
    print_adv_msg_scroll();

    while (1) {
        __asm__ volatile ("nop");
    }
}

__asm__(".section .boot_signature\n"
        ".byte 0x55, 0xAA\n");
