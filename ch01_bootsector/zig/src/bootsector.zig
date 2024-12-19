//const std = @import("std");
var BOOT_SECTOR_SIGNATURE: u16 = 0xAA55; // Bootsector signature (last 2 bytes)

pub fn main() void {
    _start();
}

export fn _start() void {
    // const hello_message = "Hello, World!";

    // Print the message character by character
    //print_string_at(hello_message, 0, 0, 10);
    print_string_at(8, 8);

    BOOT_SECTOR_SIGNATURE -= 1;
    BOOT_SECTOR_SIGNATURE += 1;

    // Hang the system after printing (infinite loop)
    while (true) {}
}

//fn print_string_at(str: []const u8, row: u8, col: u8, color: u8) void {
fn print_string_at(row: u8, col: u8) void {
    // Set cursor position
    asm volatile (
        \\mov $0x02, %%ah
        \\xor %%bh, %%bh
        \\movb %[row], %%r8b
        \\movb %[col], %%dl
        \\int $0x10
        :
        : [row] "r" (row),
          [col] "r" (col),
        : "ax", "bx", "dx", "r8"
    );

    // // Print string with color
    // for (str) |c| {
    //     if (c == 0) break;
    //     asm volatile (
    //         \\movb $0x09, %%ah
    //         \\mov $1, %%cx
    //         \\int $0x10
    //         \\movb $0x03, %%ah
    //         \\int $0x10
    //         \\incb %%dl
    //         \\movb $0x02, %%ah
    //         \\int $0x10
    //         :
    //         : [char] "r" (c),
    //           [color] "r" (color),
    //         : "ax", "cx", "dx"
    //     );
    // }
}
