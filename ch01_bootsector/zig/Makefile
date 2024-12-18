bootsector: src/bootsector.zig
	#zig build-exe -target x86_64-freestanding-none -T linker.ld -O ReleaseSmall src/bootsector.zig
	zig build-exe -target x86_64-freestanding-none -O ReleaseSmall src/bootsector.zig

build: bootsector
	xxd -l 608 -g 1 bootsector

run: bootsector
	./test.qemu.sh

clean:
	rm bootsector bootsector.o
