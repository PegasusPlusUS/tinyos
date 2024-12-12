#![no_std]
#![no_main]

use core::arch::asm;
use core::fmt::Write;
use core::panic::PanicInfo;

#[derive(Clone)]
#[repr(C)]
struct RTCData {
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

struct Buffer {
    buf: [u8; 128],
    pos: usize,
}

impl Buffer {
    fn new() -> Self {
        Buffer {
            buf: [0; 128],
            pos: 0,
        }
    }
}

impl Write for Buffer {
    fn write_str(&mut self, s: &str) -> core::fmt::Result {
        let bytes = s.as_bytes();
        let len = bytes.len();
        if self.pos + len > self.buf.len() {
            return Err(core::fmt::Error);
        }
        self.buf[self.pos..self.pos + len].copy_from_slice(bytes);
        self.pos += len;
        Ok(())
    }
}

fn write_to_vga(buffer: &Buffer) {
    const VGA_BUFFER: *mut u8 = 0xB8000 as *mut u8;
    let vga_buffer = unsafe { core::slice::from_raw_parts_mut(VGA_BUFFER, buffer.buf.len()) };
    for (i, &byte) in buffer.buf.iter().enumerate() {
        vga_buffer[i * 2] = byte; // Character byte
        vga_buffer[i * 2 + 1] = 0x07; // Attribute byte (white on black)
    }
}

fn get_rtc() -> RTCData {
    unsafe {
        asm!(
        "mov ah, 0x1A",       // Load the interrupt number into AH
        "int 0x1A",           // Perform the interrupt call to get RTC
        options(nostack, preserves_flags)
        );
    }

    // Assuming the RTC data is stored at 0x00A00 in real mode
    let rtc: *const RTCData = 0x00A00 as *const RTCData;
    let rtc_data = unsafe { (*rtc).clone() };

    rtc_data
}

fn display_time(rtc: RTCData) {
    let mut time_str_buffer = Buffer::new();
    write!(&mut time_str_buffer, "Time: {:02}:{:02}:{:02} {:02}/{:02}/{:02} It's now safe to turn off your box!", rtc.hours, rtc.minutes, rtc.seconds, rtc.day, rtc.month, rtc.year).unwrap();
    write_to_vga(&time_str_buffer);
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
