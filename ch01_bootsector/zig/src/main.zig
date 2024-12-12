const std = @import("std").builtin;

const VGA_PORT = 0x3D4;
const VGA_DATA_PORT = 0x3D5;
//const VIDEO_MEMORY = 0xB8000;

// New function to get time using BIOS
fn get_rtc_time() struct { hours: u8, minutes: u8, seconds: u8 } {
    var hours: u8 = undefined;
    var minutes: u8 = undefined;
    var seconds: u8 = undefined;

    asm volatile (
        \\movb $0x02, %%ah  # BIOS get real time clock
        \\int $0x1A         # Call BIOS time services
        \\movb %%ch, %[hour]# Hours in CH
        \\movb %%cl, %[min] # Minutes in CL
        \\movb %%dh, %[sec] # Seconds in DH
        : [sec] "=m" (seconds),
          [min] "=m" (minutes),
          [hour] "=m" (hours),
        :
        : "ax", "cx", "dx"
    );

    // Convert from BCD to binary if needed
    seconds = ((seconds >> 4) * 10) + (seconds & 0x0F);
    minutes = ((minutes >> 4) * 10) + (minutes & 0x0F);
    hours = ((hours >> 4) * 10) + (hours & 0x0F);

    return .{ .hours = hours, .minutes = minutes, .seconds = seconds };
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

    // Infinite loop to display the time
    while (true) {
        // Get time using BIOS
        const time = get_rtc_time();

        // Convert time to string format "HH:MM:SS"
        var time_str: [8]u8 = undefined;
        var buf: [4]u8 = undefined;

        int_to_str(time.hours, &buf);
        time_str[0] = buf[0];
        time_str[1] = buf[1];
        time_str[2] = ':';

        int_to_str(time.minutes, &buf);
        time_str[3] = buf[0];
        time_str[4] = buf[1];
        time_str[5] = ':';

        int_to_str(time.seconds, &buf);
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
