bootsector.bin : bootsector.asm
	nasm bootsector.asm -o bootsector.bin

run : bootsector.bin
	echo "run bochs to load bootsector.bin as disk image for boot device"

clean :
	rm -f bootsector.bin
