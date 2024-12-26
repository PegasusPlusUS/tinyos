
In IBM PC trandition, boot sector is the first 512 bytes on boot device (floppy, hard disk, network remote start image, etc), the last 2 bytes must be 0x55 0xAA, or the PC will not boot from it.

The task of this tiny program will display some living text (with help from BIOS that already in PC, or write to video memory if ensure there's certain video device and has proper default mode setting) and continue load another more advanced bootloader to load the startup part of a real functional OS.

Reading material about boot sector:
https://kernelx.weebly.com/writing-a-bootsector.html

At the beginning we use nasm to write simple bootsector that show Hello, world, display real time clock, scroll bar.

Then we use inline asm of i686-elf-gcc to construct framework, then use pure C to write dynamic logic, get our first bootsector that can use high level language for dynamic content.

Other high level languages are struggling with size of generated executable, oftern too big to fit in bootsector. Zig can be as minimum as 608 bytes, Rust can generate 1312 bytes.
V might be the 2nd high level language that can generate bootsector directly. However, the current V compiler has bug on -ffreestanding, which cause incompatible size_t definition.

To go around this, we let V generate c code in default mode, which output over 500K c source. Then we use sed to filter out not used advanced functionalities, we got 654 bytes c code! (Though it will reuse a 6931 bytes header file shared by our c implementation of bootsector), i686-elf-gcc generates about 140 bytes executable, padding to 512 bytes! Will try adding simple dynamic display in V code.

With the help of sed, generally a filter to remove no need code and add needed asm or C code shared by our nasm and C implementation for bootsector, usually if any high level programming language that can output C code or asm code, we will finally construct framework for routing bootsector work, and let the high level language do dynamic work. Now V,FreeBasic,Nim is OK.

Will continue try this way to let Zig, Nim, Rust, FreePascal, TinyGo or Go, Moonbit, Ada, Fortran, Swift, Ocaml, Dart, Java?.

Hope at bootloader, almost all high language can either do itself, or be driven by Rust or C to write dynamic logic to load kernel. And kernel might also be frameworked by C/Rust, and drive other high level language to do decision logic.
