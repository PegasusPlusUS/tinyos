
In IBM PC trandition, boot sector is the first 512 bytes on boot device (floppy, hard disk, network remote start image, etc), the last 2 bytes must be 0x55 0xAA, or the PC will not boot from it.

The task of this tiny program will display some living text (with help from BIOS that already in PC, or write to video memory if ensure there's certain video device and has proper default mode setting) and continue load another more advanced bootloader to load the startup part of a real functional OS.

Reading material about boot sector:
https://kernelx.weebly.com/writing-a-bootsector.html

