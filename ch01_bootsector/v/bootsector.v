fn main() {
    message := "Hello, World!"

    for c in message {
        mut m_c := c;
        asm x86 {
            mov ah, 0x0e
            mov al, c
            int 0x10
           ; r (m_c) as c
        }
    }

    // Infinite loop to keep the program running
    for {}
}