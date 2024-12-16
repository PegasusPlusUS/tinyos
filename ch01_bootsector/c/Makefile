.PONEY : build run clean

bootsector.o : bootsector.c
	x86_64-elf-gcc -ffreestanding -nostdlib -c bootsector.c -o bootsector.o

bootsector.bin : bootsector.o linker.ld
	../.pipe/pb_holder/target/release/pb_holder.exe r \\\\.\\pipe\\tinyos_bootsector_holder bootsector.pz
	#x86_64-elf-ld -T linker.ld --oformat binary -s -o bootsector.bin bootsector.o 	
	x86_64-elf-ld -T linker.ld --oformat binary -s -o \\\\.\\pipe\\tinyosbootsector bootsector.o 	

build: bootsector.bin

../.pipe/pb_holder/target/release/pb_holder.exe : ../.pipe/pb_holder/src/main.rs
	cd ../.pipe/pb_holder && cargo b --release

pb_holder: ../.pipe/pb_holder/target/release/pb_holder.exe

run: build pb_holder
	../.pipe/pb_holder/target/release/pb_holder.exe w bootsector.pz \\\\.\\pipe\\tinyos_bootsector_provider
	echo "run bochs to load bootsector.bin as disk image for boot device"
	#qemu-system-x86_64 -drive file=bootsector.bin,format=raw
	qemu-system-x86_64 -drive file=\\\\.\\pipe\\tinyos_bootsector_provider,format=raw

clean:
	rm bootsector.o bootsector.bin
