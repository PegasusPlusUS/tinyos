const std = @import("std");

const COM1 = 0x3F8; // Base address of COM1 port (just in case)

const hello_message = "Hello, World!"; // The string to be printed

// The entry point for our bootloader
export fn _start() void {
    // Set video mode (0x03 = 80x25 text mode)
    set_video_mode();

    // Print the message character by character
    var index: usize = 0;
    while (true) {
        const c = hello_message[index];
        if (c == 0) break; // Null-terminator means the end of the string
        print_char(c);
        index += 1;
    }

    // Hang the system after printing (infinite loop)
    while (true) {}
}

// Set video mode using BIOS interrupt (0x10, function 0x00)
fn set_video_mode() void {
    @asm volatile (
        "movb $0x03, %%ah\n\t"  // Set video mode (0x03 = 80x25 text mode)
        "int $0x10\n\t"          // Call BIOS interrupt
        :
        :
        : "ah", "bx", "cx", "dx" // Clobbered registers
    );
}

// Print a character to the screen using BIOS interrupt (0x10, function 0x0E)
fn print_char(c: u8) void {
    @asm volatile (
        "movb $0x0E, %%ah\n\t"  // BIOS function to print character
        "movb $0x07, %%bh\n\t"  // Page number (0)
        "movb %0, %%dl\n\t"      // Load character into DL
        "int $0x10\n\t"          // Call BIOS interrupt
        :
        : "r" (c)                 // Input: the character to print
        : "ah", "bh", "dl"       // Clobbered registers
    );
}
