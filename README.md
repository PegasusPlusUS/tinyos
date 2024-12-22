# tinyos boots, here is the output:
```
Hello, bootsector!

19:48:24

Now it is safe to turn off your box.

an open source tutorial at https://github.com/pegasusplus/tinyos  TinyOS is












```
OS entry: bootsector, ch01 and ch02

# Required toolchain:

1. NASM
2. Make (optional if you like to manually complete build steps)
3. QEMU or other VM such as Bochs, 86Box, VMWare Workstation, PVE, or VirtualBox, Hyper-V, KVM, etc.

Install toolchain:
  Windows:
     You can use Scoop to install the above 3 tools. ("scoop install nasm make qemu")
  MacOS:
     You can use brew to install the above 3 tools. ("brew install nasm make qemu")
  On Ubuntu:
     TODO: test desktop version

# Test and DIY
1. Test:
  Run './test.qemu.sh' or 'test.qemu.cmd' on Windows without Unix-style Bash shell to watch it runs in VM.
  Trouble shouting: If your Windows Defender or other anti-virus utility prevent accessing pre-built bootsector.bin in the repo (any bootable things is potential harmful to current running system, isn't it? Fortunately we will use it for an isolated VM), you can try disable Windows Defender on bootsector.bin or the whole directory for this tutorial. Another way is to run `make` in the root directory of the project, to build a helper tool to hide bootsector.bin from directly storing on file system. This tool will need Rust (Or ... to be adding other implementations) to build.

2. Try learn nasm/bootsector.asm and change text message, color, etc.

PS:
 ch01/ch02 can use NASM only (or it's better only use NASM), higher level languages (even C) usually
 bring trouble struggling on param passing and interacting with inline asm, wasting much time and has little help in bootsector, because it's too small to contain advanced flow control or functional/logical/clousure etc. provided by higher level languages. If you are interesting, you can look at subdirectories of c/nim/pascal/rs/v/zig/ to see how they are using in bootsector. (Now c/v has successfully generate bootsector)

  after that, pure ASM will be hardwork compared to high level languages. It's better using i686-elf-gcc, g++, Rust, Zig, Nim, //or other high level languages, we will try add Swift, C#, Python, Pascal, Ada, Fortran, etc. step by step.

# Other topics, see README.md in each chapter.
