const std = @import("std").builtin;

const VGA_PORT = 0x3D4;
const VGA_DATA_PORT = 0x3D5;
//const VIDEO_MEMORY = 0xB8000;

const RTC_PORT = 0x70; // Command port
const RTC_DATA_PORT = 0x71; // Data port

// Constants for RTC registers
const RTC_SECONDS = 0x00;
const RTC_MINUTES = 0x02;
const RTC_HOURS = 0x04;

fn outbx(port: u16, value: u8) void {
    asm volatile ("outb %0, %1"
        : // no output
        : [value] "{ax}" (value),
          [port] "Nd" (port),
    );
}

fn outb(port: u16, value: u8) void {
    asm volatile ("outb %0, %1"
        : // no output
        : [value] "{ax}" (value),
          [port] "Nd" (port),
    );
}

fn inb(port: u16) u8 {
    var value: u8 = 0;
    asm volatile ("inb %1, %0"
        : [value] "=a" (value),
        : [port] "Nd" (port),
    );
    return value;
}

// Function to read a byte from RTC using port 0x70 and 0x71
fn read_rtc_register(register: u8) u8 {
    outb(RTC_PORT, register);
    return inb(RTC_DATA_PORT);
}

const VIDEO_MEMORY: *u16 = @ptrFromInt(0xB8000);

fn write_string(message: []const u8) void {
    var i: u16 = 0;
    while (i < message.len) {
        const char = message[i];
        const offset: *u16 = @ptrFromInt(@intFromPtr(VIDEO_MEMORY) + i * 2);
        offset.* = @as(u16, char) | 0x0F00; // White text on black background
        i += 1;
    }
}

// Convert an integer to a string
fn int_to_str(num: u8, buf: *[4]u8) void {
    const digits = "0123456789";
    buf[0] = digits[(num / 10) % 10];
    buf[1] = digits[num % 10];
    buf[2] = 0; // Null-terminator
}

pub fn main() void {
    // Display initial message
    const greeting: []const u8 = "Hello, bootsector!";
    write_string(greeting);

    // Infinite loop to display the time from RTC
    while (true) {
        // Read RTC time registers
        const seconds = read_rtc_register(RTC_SECONDS);
        const minutes = read_rtc_register(RTC_MINUTES);
        const hours = read_rtc_register(RTC_HOURS);

        // Convert time to string format "HH:MM:SS"
        var time_str: [8]u8 = undefined;
        var buf: [4]u8 = undefined;

        int_to_str(hours, &buf);
        time_str[0] = buf[0];
        time_str[1] = buf[1];
        time_str[2] = ':';

        int_to_str(minutes, &buf);
        time_str[3] = buf[0];
        time_str[4] = buf[1];
        time_str[5] = ':';

        int_to_str(seconds, &buf);
        time_str[6] = buf[0];
        time_str[7] = buf[1];

        // Display the time on the screen
        write_string(&time_str);

        // Simple delay loop (adjust for timing)
        var delay_counter: u32 = 0;
        while (delay_counter < 1000000) {
            delay_counter += 1;
        }
    }
}
