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
    "cli\n\t"
    "xor %ax, %ax\n\t"        // Set up segments
    "mov %ax, %ds\n\t"
    "mov %ax, %es\n\t"
    "mov %ax, %ss\n\t"
    "mov $0x7C00, %sp\n\t"

        "mov $0x0A, %al\n\t"
        "mov %al, _asm_color_\n\t"
        "call print_adv_msg_scroll\n\t"
        //"call asm_clear_screen\n\t"

        "movb $0x36, %al\n\t"       // Channel 0, square wave mode
        "outb %al, $0x43\n\t"       // Send control word to PIT
        "movw $0x04AF, %ax\n\t"     // Load value for 1000 Hz (1193 in decimal)
        "outb %al, $0x40\n\t"       // Send low byte to PIT channel 0
        "movb %ah, %al\n\t"
        "outb %al, $0x40\n\t"       // Send high byte to PIT channel 0

        // Set up ISR for IRQ0
        "xor %ax, %ax\n\t"          // Clear AX (set to zero)
        "mov %ax, %es\n\t"          // Set ES to zero (flat segment)
        "lea ._isr_, %dx\n\t"       // Load the address of _isr_ into DX
        "movw %dx, %es:0x20*4\n\t"  // Set ISR offset for IRQ0
        "movw $0, %es:0x20*4+2\n\t" // Set ISR segment

        "mov $0xFE, %al\n\t"        // Enable IRQ0 only
        "out %al, $0x21\n\t"        // Send command to PIC
        "sti\n\t"

    "jmp $0x0000, $bootsector_main\n"

    "._isr_:\n\t"
        "pushal\n\t"            //PUSH_REGISTERS

        "mov %cs, %ax\n\t"      // Setup data segment
        "mov %ax, %ds\n\t"
        "mov %ax, %es\n\t"

        "mov _asm_color_, %al\n\t"
        "inc %al\n\t"
        "mov %al, _asm_color_\n\t"
        "lea HELLO_MSG, %ax\n\t"
        "mov %ax, _asm_msg_\n\t"
        "call asm_print_string\n\t"

        "movb $0x20, %al\n\t"   // ACK ISR
        "outb %al, $0x20\n\t"

        "popal\n\t"     //POP_REGISTERS
        "iret\n\t"
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
const char* HELLO_MSG = "C in timer mode!";
char* ADV_MSG = "Tutorial at https://github.com/pegasusplus/tinyos ";
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

#define PRINT_STRING(msg)   \
    do {    \
        _asm_msg_ = msg;    \
        asm_print_string(); \
    } while(0)

void asm_print_string() {
    __asm__ volatile (
        // // Prologue: Save registers
        // "push %%ax\n\t"          // Save AX
        // "push %%bx\n\t"          // Save BX
        // "push %%cx\n\t"          // Save CX

        "lea _asm_msg_, %%si\n\t"
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
        // //Epilogue: Restore registers
        // "pop %%cx\n\t"           // Restore CX
        // "pop %%bx\n\t"           // Restore BX
        // "pop %%ax\n\t"           // Restore AX
        :
        :
        : "al", "ah", "dl", "cx", "si", "memory", "bh"// , "bl" Clobbered registers
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
    if (++_scroll_pos_ >= 22) {
        _scroll_pos_ = 0;
    }
}

void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {
    asm_clear_screen();

    PRINT_STRING(HELLO_MSG);
    SET_CURSOR_POS(1, 0);
    print_adv_msg_scroll();
    SET_CURSOR_POS(2, 0);
 
    while (1) {
        __asm__ volatile ("nop");
    }
}

__asm__(".section .boot_signature\n"
        ".byte 0x55, 0xAA\n");
