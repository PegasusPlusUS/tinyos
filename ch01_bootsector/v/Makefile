.PONEY : build run clean
         
bootsector.asm: bootsector.v Makefile
	v -gc none -freestanding -cg -o bootsector.asm bootsector.v

bootsector.bin: bootsector.asm
	echo 'times 510 - ($ - $$) db 0' >> bootsector.asm
	echo 'dw 0xAA55' >> bootsector.asm
	nasm bootsector.asm -o bootsector.bin

build: bootsector.bin Makefile
	echo "build bootsector.bin by v/nasm"

clean:
	rm -f *.o *.bin *.asm

run: build
	echo "run qemu load bootsector.bin as disk image for boot device"
	qemu-system-x86_64 -m 1m -drive file=bootsector.bin,format=raw

run_under_av: build
	#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.pz tinyos_bootsector_provider
	#qemu-system-x86_64 -m 1m -drive file=\\\\.\\pipe\\tinyos_bootsector_provider,format=raw
