#![no_std]
#![no_main]

use core::panic::PanicInfo;

// Constants
// const VIDEO_INT: u8 = 0x10;
// const TIMER_INT: u8 = 0x1A;
const COLOR_YELLOW: u8 = 0x0E;
const COLOR_WHITE: u8 = 0x0F;
const COLOR_GREEN: u8 = 0x0A;

// Messages
static HELLO_MSG: &str = "Hello, bootsector!";
static SAFE_MSG: &str = "Now it is safe to turn off your box.";
static ADV_MSG: &str = "TinyOS is an open source tutorial at https://github.com/pegasusplus/tinyos";

#[repr(C, packed)]
struct Time {
    hours: u8,
    minutes: u8,
    seconds: u8,
}

#[no_mangle]
#[link_section = ".start"]
pub extern "C" fn main() -> ! {
    // Set up segments
    unsafe {
        core::arch::asm!(
            ".code16",
            "xor ax, ax",
            "mov ds, ax",
            "mov es, ax",
            "mov ss, ax",
            "mov sp, 0x7C00",
            "mov ax, 0x0003",
            "int 0x10",
        );
    }

    // Print hello message in yellow
    print_string_at(HELLO_MSG, 0, 0, COLOR_YELLOW);

    // Print safe message in green
    print_string_at(SAFE_MSG, 2, 0, COLOR_GREEN);

    loop {
        let time = get_rtc_time();
        print_time_at(&time, 1, 0, COLOR_WHITE);
        handle_adv_scroll();

        // Simple delay
        for _ in 0..0x2FFF {
            unsafe { core::arch::asm!("nop") };
        }
    }
}

fn print_string_at(s: &str, row: u8, col: u8, color: u8) {
    // Set cursor position
    unsafe {
        core::arch::asm!(
            "mov ah, 0x02",
            "xor bh, bh",
            "int 0x10",
            in("dx") ((row as u16) << 8 | col as u16),
            clobber_abi("C"),
        );
    }

    // Print each character
    for c in s.bytes() {
        unsafe {
            core::arch::asm!(
                "mov ah, 0x09",
                "mov cx, 1",
                "int 0x10",
                "mov ah, 0x03",
                "int 0x10",
                "inc dl",
                "mov ah, 0x02",
                "int 0x10",
                in("al") c,
                in("bl") color,
                clobber_abi("C"),
            );
        }
    }
}

fn get_rtc_time() -> Time {
    let mut time = Time { hours: 0, minutes: 0, seconds: 0 };
    let mut cx: u16;
    let mut dx: u16;
    
    unsafe {
        core::arch::asm!(
            "mov ah, 0x02",
            "int 0x1A",
            out("cx") cx,
            out("dx") dx,
            clobber_abi("C"),
        );
    }

    // Extract high bytes from 16-bit registers
    time.hours = (cx >> 8) as u8;
    time.minutes = cx as u8;
    time.seconds = (dx >> 8) as u8;

    // Convert BCD to binary
    time.hours = (time.hours >> 4) * 10 + (time.hours & 0x0F);
    time.minutes = (time.minutes >> 4) * 10 + (time.minutes & 0x0F);
    time.seconds = (time.seconds >> 4) * 10 + (time.seconds & 0x0F);

    time
}

fn print_time_at(time: &Time, row: u8, col: u8, color: u8) {
    let mut time_str = [0u8; 9];
    
    time_str[0] = b'0' + (time.hours / 10);
    time_str[1] = b'0' + (time.hours % 10);
    time_str[2] = b':';
    time_str[3] = b'0' + (time.minutes / 10);
    time_str[4] = b'0' + (time.minutes % 10);
    time_str[5] = b':';
    time_str[6] = b'0' + (time.seconds / 10);
    time_str[7] = b'0' + (time.seconds % 10);
    time_str[8] = 0;

    print_string_at(core::str::from_utf8(&time_str[..8]).unwrap(), row, col, color);
}

static mut SCROLL_POS: u8 = 0;
static mut ADV_COLOR: u8 = 0x0C;

fn handle_adv_scroll() {
    unsafe {
        let temp = ADV_MSG.as_bytes()[SCROLL_POS as usize];
        let mut_msg = ADV_MSG.as_bytes() as *const _ as *mut u8;
        *mut_msg.add(SCROLL_POS as usize) = 0;

        // Print from scroll_pos + 1
        print_string_at(core::str::from_utf8(&ADV_MSG.as_bytes()[(SCROLL_POS + 1) as usize..]).unwrap(), 6, 0, ADV_COLOR);
        
        // Print from beginning
        print_string_at(ADV_MSG, 6, 0, ADV_COLOR);

        // Restore character
        *mut_msg.add(SCROLL_POS as usize) = temp;

        // Update position and color
        SCROLL_POS += 1;
        if SCROLL_POS >= (ADV_MSG.len() - 1) as u8 {
            SCROLL_POS = 0;
        }
        ADV_COLOR = ADV_COLOR.wrapping_add(1);
    }
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
} 