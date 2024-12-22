bootsector.bin : bootsector.asm common.asm
	nasm bootsector.asm -o bootsector.bin

build : bootsector.bin
	../dump.sh

run : bootsector.bin
	#echo "run bochs to load bootsector.bin as disk image for boot device"
	echo "run QEMU to load bootsector.bin as disk image for boot device"
	../test.qemu.sh

clean :
	rm -f bootsector.bin
