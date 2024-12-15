ch01_bootsector/nasm/bootsector.bin : ch01_bootsector/nasm/bootsector.asm
	cd ch01_bootsector && make

ch01_bootsector/.pipe/pb_holder/target/release/pb_holder : ch01_bootsector/.pipe/pb_holder/Cargo.toml
	cd ch01_bootsector/.pipe/pb_holder && cargo build --release

ch02_timer/nasm/bootsector.bin : ch02_timer/nasm/bootsector.asm
	cd ch02_timer && make

build : ch02_timer/nasm/bootsector.bin ch01_bootsector/.pipe/pb_holder/target/release/pb_holder	
	echo "run bochs or test.qemu to test tinyOS from VM"

run : build
	bash -c "./test.bochs.sh & ./test.qemu.sh &"

clean :
	cd ch01_bootsector && make clean
	cd ch02_timer && make clean
