# tinyos boots, here is the output:
```
Hello, bootsector!

19:48:24

Now it is safe to turn off your box.

an open source tutorial at https://github.com/pegasusplus/tinyos  TinyOS is












```
# Required toolchain:

1. NASM
2. Make (optional)
3. Bochs or other VM such as QEMU, 86Box, VMWare Workstation, PVE, or VirtualBox, Hyper-V, KVM, etc.

First step DIY test:
0. You can use Scoop to install the above 3 tools.
1. After install NASM, Make and a VM, run `make` in the root directory of the project. Or without make, run `nasm -f bin -o bootsector.bin nasm/bootsector.asm` to compile the bootsector.asm file.
2.1 On Windows, run `bochs` to start the bootsector.bin file in the VM.
2.2 On MacOS, bochs default using terminal tty, it's easy to use QEMU
  'qemu-system-x86_64 -drive file=nasm/bootsector.bin

