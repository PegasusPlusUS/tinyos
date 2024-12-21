bootsector: src/bootsector.zig
	#zig build-exe -target x86_64-freestanding-none -T linker.ld -O ReleaseSmall src/bootsector.zig
	zig build-exe -femit-asm=bootsector.asm -target x86_64-freestanding-none -O ReleaseSmall src/bootsector.zig

build: bootsector
	nasm -f elf64 bootsector.asm -o bootsector.bin
	xxd -l 608 -g 1 bootsector.bin

run: bootsector
	./test.qemu.sh

clean:
	rm bootsector bootsector.o
