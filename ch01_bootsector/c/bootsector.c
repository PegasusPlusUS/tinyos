// bootsector.c
char *video_memory = (char *)0xB8000;  // Start of video memory
const int screen_size = 80 * 25;            // Total number of characters on the screen

void clear_screen() {
    for (int i = 0; i < screen_size; i++) {
        video_memory[i * 2] = ' ';   // Write a space character
        video_memory[i * 2 + 1] = 0x07; // Attribute: White text on black
    }
}

__attribute__((naked)) void _start() {
    __asm__(
        "cli\n"                    // Disable interrupts
        "xor %%ax, %%ax\n"         // Zero AX
        "mov %%ax, %%ds\n"         // Set DS to zero
        "mov %%ax, %%es\n"         // Set ES to zero
        "mov $0x7C00, %%sp\n"      // Set stack pointer to 0x7C00

        // Call the C function to clear the screen
        "call clear_screen\n"

        // Halt the CPU
        "hang:\n"
        "hlt\n"
        "jmp hang\n"
        :
        :
        : "ax"
    );
}

// Ensure the boot sector is 512 bytes with a boot signature
__attribute__((section(".boot_signature"))) const unsigned char boot_signature[2] = {0x55, 0xAA};
