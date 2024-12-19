#![no_std]
#![no_main]

use core::arch::asm;

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    let msg = b"Hi!\0";
    unsafe {
        asm!(
            "mov ah, 0x0E
            mov rsi, {0}
            3: lodsb
            cmp al, 0
            je 4f
            int 0x10
            jmp 3b
            4:",
            in(reg) msg.as_ptr(),
            options(nostack)
        );
    }
    loop {}
}
