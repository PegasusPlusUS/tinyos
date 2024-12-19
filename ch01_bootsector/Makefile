nasm/bootsector.bin : nasm/bootsector.asm
	cd nasm && make

.pipe/pb_holder/target/release/pb_holder : .pipe/pb_holder/Cargo.toml
	cd .pipe/pb_holder && cargo build --release

build : nasm/bootsector.bin
	echo "run test.qemu.sh to test tinyOS from VM"

run : build
	bash -c "./test.qemu.sh &"

run_with_defender : run .pipe/pb_holder/target/release/pb_holder
	echo "Using pb_holder to brige compiler and VM, avoiding saving bootsetor file"

clean :
	rm -f nasm/bootsector.bin
	rm -rf .pipe/pb_holder/target/