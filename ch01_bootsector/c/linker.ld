/* linker.ld */
SECTIONS {
    . = 0x7C00;                 /* Start address of the bootloader */
    .text : {
        *(.text*)               /* Include all .text sections */
    }
    .rodata : {
        *(.rodata*)             /* Include all .rodata sections */
    }
    .bss : {
        *(.bss*)                /* Include all .bss sections */
    }
    . = 0x7DFE;                 /* Ensure boot signature is at the end */
    .boot_signature : {
        *(.boot_signature)
    }
}
