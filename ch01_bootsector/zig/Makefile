

bootsector.asm: src/bootsector.zig Makefile 
	zig build-exe -femit-asm=bootsector.z.asm -target x86_64-freestanding-none -O ReleaseSmall src/bootsector.zig
	copy bootsector.z.asm bootsector.asm

bootsector.bin: bootsector.asm Makefile
	nasm -f elf64 bootsector.asm -o bootsector.bin

build: bootsector.bin Makefile
	echo "Using xxd to dump target file"
	../dump.sh

run: build Makefile
	../test.qemu.sh

clean:
	rm bootsector bootsector.o