.PONEY : build run clean

CC = i686-elf-gcc
CFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
ASMFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse -O0 -S 

bootsector.c: bootsector.v Makefile
	v -freestanding -o bootsector.v.c bootsector.v
	#  sed -n '/void main__start(void) {/,/^}/p' bootsector.v.c > bootsector.c
	sed -n -E '/void main__start\(void\) \{/,/^\}/p; /^string _const_main__/p; /^\\s*_const_main__/s/_const_main__/string /p' bootsector.v.c > bootsector.c
	sed -i -E 's/([a-zA-Z_][a-zA-Z0-9_]*)\\.len/sizeof(\\1)/g' bootsector.c
	sed -i -E 's/\\(_const_main__([a-zA-Z0-9][_a-zA-Z0-9]*)\\.str\\)/\\(\\1\\)/g' bootsector.c
	sed -i -E 's/_const_main__//g; s/main__//g; s/\\bbios_([a-z][_a-z0-9_]*)/\\U&/g' bootsector.c
	sed -i "1i #include \"../c/bootsector.h\"\nASM_EPILOG;\nFN_BIOS_CLEAR_SCREEN;\nFN_BIOS_SET_CURSOR_POS__ROW_COL;\nDATA_BIOS_PARAM;\nFN_BIOS_PRINT_STRING__MSG_COLOR;\n#define VV_LOCAL_SYMBOL\n#define u8 unsigned char\ntypedef const char string[];\n#define _SLIT(s) s\n" bootsector.c
	echo -e "void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {\n\tstart();\n\tfor(;;) {}\n}\nEND_BOOTSECTOR\n" >> bootsector.c

bootsector.asm: bootsector.c Makefile
	i686-elf-gcc -ffreestanding -m16 -S -nostdlib -nodefaultlibs -o bootsector.asm bootsector.c
	#sed -i '/^\\t\\.\\(file\\|text\\|globl\\|type\\|size\\|ident\\)/d' bootsector.asm
	#sed -i "1i [org 0x7c00]\n[bits 16]\n%include \"../nasm/common.asm\"" bootsector.asm

bootsector.o: bootsector.c Makefile
	$(CC) $(CFLAGS) -c bootsector.c -o bootsector.o
	$(CC) $(ASMFLAGS) -o bootsector.s bootsector.c

bootsector.bin: bootsector.o Makefile
	i686-elf-ld -T ../c/linker.ld --oformat binary -s -o bootsector.bin bootsector.o

build: bootsector.bin Makefile
	echo "build bootsector.bin by v/nasm"
	../dump.sh

clean:
	rm -f *.o *.bin *.asm *.c

run: build
	echo "run qemu load bootsector.bin as disk image for boot device"
	../test.qemu.sh

run_under_av: build
	#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.pz tinyos_bootsector_provider
	../test.under_av.qemu.sh
