#![no_std]            // Don't use the standard library
#![no_main]           // Disable all Rust-level entry points
//#![feature(asm)]      // Enable inline assembly (nightly feature)

use core::panic::PanicInfo;
use core::arch::asm;

// The bootloader entry point
#[no_mangle]
pub extern "C" fn _start() -> ! {
    print_hello();
    loop {}
}

fn print_hello() {
    let hello: &[u8] = b"Hello!\0"; // Define the string as a byte slice
    unsafe {
        asm!(
            "
            mov ah, 0x0E
            mov rsi, {0}
            2:                  // Changed local label for loop start
            lodsb
            cmp al, 0
            je 3f              // Jump to local label 3
            int 0x10
            jmp 2b             // Jump back to local label 2
            3:                  // Changed local label for done
            ",
            in(reg) hello.as_ptr(), // Pass the pointer to the string
            options(nostack)
        );
    }
}

// Panic handler (required for #[no_std])
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
   loop {}
}
