#ifndef _BOOT_SECTOR_H_
#define _BOOT_SECTOR_H_

#define BEGIN_ASM_BOOTSECTOR \
__asm__(    \
    ".code16\n\t"           \
    ".global _start\n\t"    \
"_start:\n" \
    "xor %ax, %ax\n\t"      \
    "mov %ax, %ds\n\t"      \
    "mov %ax, %es\n\t"      \
    "mov %ax, %ss\n\t"      \
    "mov $0x7BFF, %sp\n\t"  \
    "jmp $0x0000, $bootsector_main\n\t" \
)

#define DATA_ADV_MSG \
const char ADV_MSG[] = "GH:PegasusPlus/tinyos"

#define END_ASM_BOOTSECTOR \
__asm__(".section .boot_signature\n"\
        ".byte 0x55, 0xAA\n");

#endif
