#include "bootsector.h"

//Define USE_ASM_BIOS_XXX before include common_bios.h
#define USE_ASM_BIOS_CLEAR_SCREEN
#define USE_ASM_BIOS_SET_CURSOR_POS
#define USE_ASM_BIOS_PRINT_CHAR
#define USE_ASM_BIOS_SET_PRINT_COLOR
#include "common_bios.h"

#ifdef USE_C_PRINT_STRING_AT
void c_print_string_at(const char *str, unsigned char row, unsigned char col, unsigned char colour) {
    asm_bios_set_print_color(colour);
    while (*str) {
        asm_bios_set_cursor_pos(row, col++);
        asm_bios_print_char(*str++);
    }
}
#endif

//BEGIN_ASM_BOOTSECTOR;