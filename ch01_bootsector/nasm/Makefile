bootsector.bin : bootsector.asm common.asm
	nasm bootsector.asm -o bootsector.bin

build : bootsector.bin

run : bootsector.bin
	#echo "run bochs to load bootsector.bin as disk image for boot device"
	#echo "run QEMU to load bootsector.bin as disk image for boot device"
	qemu-system-x86_64 -drive file=bootsector.bin,format=raw

clean :
	rm -f bootsector.bin
