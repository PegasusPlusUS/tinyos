#include "bootsector.h"

//Define USE_ASM_BIOS_XXX before include common_bios.h
#define USE_ASM_BIOS_CLEAR_SCREEN
#define USE_ASM_BIOS_SET_CURSOR_POS
#define USE_ASM_BIOS_PRINT_CHAR
#define USE_ASM_BIOS_SET_PRINT_COLOR
#include "common_bios.h"

//BEGIN_ASM_BOOTSECTOR;