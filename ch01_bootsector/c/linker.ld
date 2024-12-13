SECTIONS
{
    . = 0x7C00;
    .text : {
        *(.text*)
    }
    .rodata : {
        *(.rodata*)
    }
    .data : {
        *(.data*)
    }
    .boot_signature : {
        *(.boot_signature)
    }
    . = 0x7C00 + 510;
    .fill : {
        BYTE(0)
        BYTE(0xAA55)
    }
    /DISCARD/ : {
        *(.note*)
        *(.comment*)
    }
}
