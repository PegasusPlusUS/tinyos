#define USE_ASM_BIOS_PRINT_STRING
#define USE_C_PRINT_STRING_AT
#include "../c/common_prefix.h"
typedef char string[];
#define ASM_BIOS_CLEAR_SCREEN asm_bios_clear_screen
#define	ASM_BIOS_SET_CURSOR_POS asm_bios_set_cursor_pos
#define ASM_BIOS_SET_PRINT_COLOR asm_bios_set_print_color
#define	ASM_BIOS_PRINT_STRING asm_bios_print_string
#define C_PRINT_STRING_AT c_print_string_at

BEGIN_ASM_BOOTSECTOR;
