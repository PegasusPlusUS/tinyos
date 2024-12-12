#![no_std]
#![no_main]

use core::arch::asm;
use core::panic::PanicInfo;

#[repr(C)]
struct Rtc {
    seconds: u8,
    minutes: u8,
    hours: u8,
    day: u8,
    month: u8,
    year: u8,
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    let msg = b"Hello, Tiny OS!";
    let vga_buffer = 0xb8000 as *mut u8;

    for (i, &byte) in msg.iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = 0x07;
        }
    }

    loop {
        let rtc = get_rtc();
        display_time(rtc);
    }
}

fn get_rtc() -> Rtc {
    unsafe {
        let mut rtc = Rtc {
            seconds: 0,
            minutes: 0,
            hours: 0,
            day: 0,
            month: 0,
            year: 0,
        };

        asm!("int 0x1A", in("ah") 0x02, out("cx") _, out("dx") _, out("al") rtc.seconds, out("ah") rtc.minutes, out("ch") rtc.hours, out("cl") rtc.day, out("dh") rtc.month, out("dl") rtc.year);

        rtc
    }
}

fn display_time(rtc: Rtc) {
    let vga_buffer = 0xb8000 as *mut u8;
    let time_msg = format!("Time: {:02}:{:02}:{:02} {:02}/{:02}/{:02} It's now safe to turn off your box!", rtc.hours, rtc.minutes, rtc.seconds, rtc.day, rtc.month, rtc.year);

    for (i, &byte) in time_msg.as_bytes().iter().enumerate() {
        unsafe {
            *vga_buffer.offset((80 + i) as isize * 2) = byte;
            *vga_buffer.offset((80 + i) as isize * 2 + 1) = 0x07;
        }
    }
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
