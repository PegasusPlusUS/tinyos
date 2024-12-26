# Makefile for nim
# Specific rules and variables for Makefile 2
LANG_SUFFIX=go
FILE_SOURCE=$(BOOTSECTOR).$(LANG_SUFFIX)
FILE_LANG_TO_C_INITIAL_RESULT=$(FILE_SOURCE).c
EXE_LANG_COMPILER=nim
FLAGS_LANG_TO_C=c --genScript --cc:gcc --compileOnly --out:
LANG_TOC_POST_PROCESSING=cp ~/nimcache/$(BOOTSECTOR)_d/@m$(FILE_LANG_TO_C_INITIAL_RESULT) $(FILE_LANG_TO_C_INITIAL_RESULT)
FILES_SOURCE_ADDITIONAL_DEPENDENCIES=

include ../common.mk

test: $(FILE_SOURCE)
	go build -o lib$(BOOTSECTOR).a -buildmode=c-archive $(FILE_SOURCE) main.go

# bootsector.bin: bootsector.c
# 	#nim c -d:noStdLib -d:danger --opt:size --define:release bootsector.nim
# 	nim c \
# 	--cpu:amd64 \
# 	--os:standalone \
#   	--mm:none \
#   	--noMain \
#   	--panics:off \
# 	--passL:"-Ttext=0x7C00 -nostdlib -nodefaultlibs -S -n -Wl,--oformat=binary -Wl,--no-warn" \
# 	-o:bootsector.bin bootsector.nim

# build: bootsector.bin Makefile
# 	xxd -l 512 -g 1 bootsector

# run: bootsector
# 	../test.qemu.sh

# clean:
# 	rm *.o *.s *.asm bootsector.o
