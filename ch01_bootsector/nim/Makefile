bootsector: bootsector.nim
	#nim c -d:noStdLib -d:danger --opt:size --define:release bootsector.nim
	nim c \
	--cpu:amd64 \
	--os:standalone \
  	--mm:none \
  	--noMain \
  	--panics:off \
	--passL:"-Ttext=0x7C00 -nostdlib -nodefaultlibs -S -n -Wl,--oformat=binary -Wl,--no-warn" \
	-o:bootsector.bin bootsector.nim

build: bootsector
	xxd -l 608 -g 1 bootsector

run: bootsector
	./test.qemu.sh

clean:
	rm bootsector bootsector.o
