#ifndef __BIOS_H__
#define __BIOS_H__

// Colors in BIOS print char
enum {
     COLOR_WHITE = 0x0F,
     COLOR_YELLOW = 0x0E,
     COLOR_CYAN = 0x0D,
//     COLOR_RED = 0x0C,
     COLOR_BLUE = 0x0B,
     COLOR_GREEN = 0x0A,
     COLOR_PURPLE = 0x09,
     COLOR_ORANGE = 0x08,
//     COLOR_BROWN = 0x07,
//     COLOR_GREY = 0x06,
//     COLOR_LIGHT_GREY = 0x05,
//     COLOR_DARK_GREY = 0x04,
//     COLOR_GREY_BLUE = 0x03,
//     COLOR_LIGHT_GREEN = 0x02,
     COLOR_LIGHT_BLUE = 0x01,
//     COLOR_BLACK = 0x00,
};

#ifdef USE_ASM_BIOS_CLEAR_SCREEN
void asm_bios_clear_screen() {
    __asm__ volatile (
        ".code16\n\t"
        "movw $0x0003, %%ax\n\t"
        "int $0x10\n\t"
        :
        :
        : "ax"
    );
}
#endif

#ifdef USE_ASM_BIOS_SET_CURSOR_POS
void asm_bios_set_cursor_pos(unsigned char row, unsigned char col) {
    __asm__ volatile (
        ".code16\n\t"
        "movb %0, %%dh\n\t"
        "movb %1, %%dl\n\t"
        "movb $0x02, %%ah\n\t"
        "int $0x10\n\t"
        :
        : "r"(row), "r"(col)
        : "ah", "dx"
    );
}
#endif

#ifdef USE_ASM_BIOS_SET_PRINT_COLOR
void asm_bios_set_print_color(unsigned char c) {
    __asm__ volatile (
        ".code16\n\t"
        "movb $0x0, %%bh\n\t"
        "movb %0, %%bl\n\t"
        "movb $0x0, %%ah\n\t"
        "int $0x10\n\t"
        :
        : "r"(c)
        : "bx", "ah"
    );
}
#endif

#ifdef USE_ASM_BIOS_PRINT_CHAR
void asm_bios_print_char(unsigned char c) {
    __asm__ volatile (
        ".code16\n\t"
        "movb %0, %%al\n\t"
        "movb $0x09, %%ah\n\t"
        "movw $0x01, %%cx\n\t"
        "int $0x10\n\t"
        :
        : "r"(c)
        : "ax", "cx" 
    );
}
#endif

#ifdef USE_BIOS_PRINT_ADDRESS_AS_HEX
void asm_adddress_to_hex() {
    /* // Define a buffer to hold the hexadecimal string */
    char _hex_buffer_[5] = ":0000";
    const void *_address_=ADV_MSG;
    asm volatile (
        "pushal\n\t"
        "mov _address_, %%ax\n\t"    /* // Move SP to AX */
        "mov %%ax, %%bx\n\t"         /* // Copy AX to BX for manipulation */
        "mov $0x0F, %%cl\n\t"        /* // Mask for lower nibble */
        /* // Convert high byte */
        "mov %%bh, %%al\n\t"         /* // Move high byte of BX to AL */
        "shr $4, %%al\n\t"           /* // Shift right by 4 to get high nibble */
        "and %%cl, %%al\n\t"         /* // Mask lower nibble */
        "add $0x30, %%al\n\t"        /* // Convert to ASCII */
        "cmp $0x39, %%al\n\t"        /* // Check if it's a digit */
        "jbe 1f\n\t"
        "add $0x07, %%al\n\t"        /* // Convert to letter if necessary */
        "1: mov %%al, _hex_buffer_+1\n\t"    /* // Store in buffer */
        "mov %%bh, %%al\n\t"         /* // Move high byte of BX to AL */
        "and %%cl, %%al\n\t"         /* // Mask lower nibble */
        "add $0x30, %%al\n\t"        /* // Convert to ASCII */
        "cmp $0x39, %%al\n\t"        /* // Check if it's a digit */
        "jbe 2f\n\t"
        "add $0x07, %%al\n\t"        /* // Convert to letter if necessary */
        "2: mov %%al, _hex_buffer_+2\n\t"  /* // Store in buffer */
        /* // Convert low byte */
        "mov %%bl, %%al\n\t"         /* // Move low byte of BX to AL */
        "shr $4, %%al\n\t"           /* // Shift right by 4 to get high nibble */
        "and %%cl, %%al\n\t"         /* // Mask lower nibble */
        "add $0x30, %%al\n\t"        /* // Convert to ASCII */
        "cmp $0x39, %%al\n\t"        /* // Check if it's a digit */
        "jbe 3f\n\t"
        "add $0x07, %%al\n\t"        /* // Convert to letter if necessary */
        "3: mov %%al, _hex_buffer_+3\n\t"  /* // Store in buffer */
        "mov %%bl, %%al\n\t"         /* // Move low byte of BX to AL */
        "and %%cl, %%al\n\t"         /* // Mask lower nibble */
        "add $0x30, %%al\n\t"        /* // Convert to ASCII */
        "cmp $0x39, %%al\n\t"        /* // Check if it's a digit */
        "jbe 4f\n\t"
        "add $0x07, %%al\n\t"        /* // Convert to letter if necessary */
        "4: mov %%al, _hex_buffer_+4\n\t"  /* // Store in buffer */
        "movb $0, _hex_buffer_+5\n\t"      /* // Null-terminate the string */
        "popal\n\t"
        :
        :
        : "memory"
    );
    //asm_bios_print_string(_hex_buffer_, COLOR_LIGHT_BLUE);
}
#endif

#define BIOS_GET_ADDRESS_OF_STACK_VAR(stack_var) \
    /* // Get the address of the stack variable and assign it to _address_ */\
    asm volatile (\
        "pushal\n\t"\
        "lea %0, %%ax\n\t" /* // Load the address of tmp into AX */\
        "mov %%ax, _address_\n\t"\
        "popal\n\t"\
        :\
        : "m"(stack_var)\
        :\
        );

#define BIOS_PRINT_ADDRESS_AS_HEX(_) \
    asm_print_address_as_hex()

#endif
