nasm/bootsector.bin : nasm/bootsector.asm nasm/common.asm ../ch01_bootsector/nasm/common.asm ../ch01_bootsector/nasm/bootsector.asm
	cd nasm && make

../ch01_bootsector/.pipe/pb_holder/target/release/pb_holder : ../ch01_bootsector/.pipe/pb_holder/Cargo.toml
	cd ../ch01_bootsector/.pipe/pb_holder && cargo build --release

build : nasm/bootsector.bin ../ch01_bootsector/.pipe/pb_holder/target/release/pb_holder	
	echo "run bochs or test.qemu to test tinyOS from VM"

run : build
	bash -c "./test.bochs.sh & ./test.qemu.sh &"

clean :
	rm -f nasm/bootsector.bin
	rm -rf .pipe/pb_holder/target/