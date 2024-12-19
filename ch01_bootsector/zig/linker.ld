SECTIONS
{
    . = 0x7C00;            /* Boot sector starts at 0x7C00 */
    .text : { *(.text) }    /* Place .text section at the beginning of the boot sector */
    
    /* Fill the remaining space to 510 bytes (0x7E00) with padding (0x00) */
    . = 0x7FE0;
    .padding : { . = . + 0x20; }

    /* Boot signature goes in the last two bytes of the 512-byte sector */
    .boot_signature : {
        .byte 0x55, 0xAA
    }
}
