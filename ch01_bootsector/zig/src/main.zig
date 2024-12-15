const BOOTLOADER_ORG = 0x7C00;

const HelloMsg = "Hello, bootsector!\x00";
const SafeMsg = "Now it is safe to turn off your box.\x00";
const AdvMsg = "TinyOS is an open source tutorial at https://github.com/pegasusplus/tinyos\x00";
const TimeStr = "00:00:00\x00";

const Color = struct {
    const Yellow = 0x0E;
    const White = 0x0F;
    const Green = 0x0A;
};

const Time = struct {
    hours: u8,
    minutes: u8,
    seconds: u8,
};

pub fn _start() noreturn {
    // Set up segments
    asm volatile (
        \\.code16
        \\xor %ax, %ax
        \\mov %ax, %ds
        \\mov %ax, %es
        \\mov %ax, %ss
        \\mov $0x7C00, %sp
        \\mov $0x0003, %ax
        \\int $0x10
    );

    // Print hello message in yellow
    print_string_at(HelloMsg, 0, 0, Color.Yellow);

    // Print safe message in green
    print_string_at(SafeMsg, 2, 0, Color.Green);

    while (true) {
        // Get and display time
        const time = get_rtc_time();
        print_time_at(time, 1, 0, Color.White);

        // Handle scrolling advertisement
        handle_adv_scroll();

        // Simple delay
        var i: u16 = 0;
        while (i < 0x2FFF) : (i += 1) {
            asm volatile ("nop");
        }
    }
}

fn print_string_at(str: []const u8, row: u8, col: u8, color: u8) void {
    // Set cursor position
    asm volatile (
        \\movb $0x02, %ah
        \\xor %bh, %bh
        \\int $0x10
        :
        : [row] "{dh}" (row),
          [col] "{dl}" (col),
        : "ax", "bx"
    );

    // Print string with color
    for (str) |c| {
        if (c == 0) break;
        asm volatile (
            \\movb $0x09, %%ah
            \\mov $1, %%cx
            \\int $0x10
            \\movb $0x03, %%ah
            \\int $0x10
            \\incb %%dl
            \\movb $0x02, %%ah
            \\int $0x10
            :
            : [char] "{al}" (c),
              [color] "{bl}" (color),
            : "ax", "cx"
        );
    }
}

fn get_rtc_time() Time {
    var hours: u8 = undefined;
    var minutes: u8 = undefined;
    var seconds: u8 = undefined;

    asm volatile (
        \\movb $0x02, %%ah
        \\int $0x1A
        \\movb %%ch, %[hour]
        \\movb %%cl, %[min]
        \\movb %%dh, %[sec]
        : [hour] "=m" (hours),
          [min] "=m" (minutes),
          [sec] "=m" (seconds),
        :
        : "ax", "cx", "dx"
    );

    // Convert BCD to binary
    hours = ((hours >> 4) * 10) + (hours & 0x0F);
    minutes = ((minutes >> 4) * 10) + (minutes & 0x0F);
    seconds = ((seconds >> 4) * 10) + (seconds & 0x0F);

    return .{ .hours = hours, .minutes = minutes, .seconds = seconds };
}

fn print_time_at(time: Time, row: u8, col: u8, color: u8) void {
    // Convert time to string
    var time_str: [9]u8 = undefined;

    // Hours
    time_str[0] = '0' + (time.hours / 10);
    time_str[1] = '0' + (time.hours % 10);
    time_str[2] = ':';

    // Minutes
    time_str[3] = '0' + (time.minutes / 10);
    time_str[4] = '0' + (time.minutes % 10);
    time_str[5] = ':';

    // Seconds
    time_str[6] = '0' + (time.seconds / 10);
    time_str[7] = '0' + (time.seconds % 10);
    time_str[8] = 0;

    // Print the formatted time
    print_string_at(&time_str, row, col, color);
}

var scroll_pos: u8 = 0;
var adv_color: u8 = 0x0C;
fn handle_adv_scroll() void {
    // Save char at scroll position and put null terminator
    const msg_ptr: [*]const u8 = @ptrCast(&AdvMsg[0]);
    const char_at_scroll_pos = msg_ptr[scroll_pos];
    const mut_msg_ptr: [*]u8 = @ptrFromInt(@intFromPtr(msg_ptr));
    mut_msg_ptr[scroll_pos] = 0;

    // Print from scroll_pos + 1
    print_string_at(msg_ptr[scroll_pos + 1 .. AdvMsg.len], 6, 0, adv_color);

    // Print from beginning
    print_string_at(msg_ptr[0 .. scroll_pos + 1], 6, 0, adv_color);

    // Restore char at scroll position
    mut_msg_ptr[scroll_pos] = char_at_scroll_pos;

    // Update scroll position
    scroll_pos +%= 1;
    if (scroll_pos >= AdvMsg.len - 1) {
        scroll_pos = 0;
    }

    // Update color
    adv_color +%= 1;
}

// Add boot signature
export const boot_signature linksection(".boot_signature") = [2]u8{ 0x55, 0xAA };
