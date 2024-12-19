SECTIONS
{
    . = 0x7C00;
    .text : {
        *(.text.boot)   /* Boot code first */
        *(.text)        /* Then other code */
        *(.rodata)      /* Read-only data (strings) */
        *(.data)        /* Initialized data */
        *(.bss)         /* Uninitialized data */
    }
    . = 0x7C00 + 510;   /* Position for boot signature */
    .signature : {
        SHORT(0xAA55)   /* Boot signature */
    }
}