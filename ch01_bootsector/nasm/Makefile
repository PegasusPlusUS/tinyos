.SUFFIXES:

all: run

.PHONY : run build neat clean run_under_av check_asm

SHELL=/usr/bin/bash

BOOTSECTOR=bootsector
FILE_TARGET=$(BOOTSECTOR).bin
FILE_SOURCE=$(BOOTSECTOR).asm
FILE_SOURCE_DEPENDENCY=common.asm
FILE_SOURCE_ADDITIONAL_DEPENDENCY=common_bios.asm
FILE_THIS=Makefile
COMPILER=nasm
COMPILER2TARGET_FLAGS=-o
SCRIPT_VERIFY=../verify_boot.sh
SCRIPT_TEST=../test.qemu.sh

$(FILE_TARGET) : $(FILE_SOURCE) $(FILE_SOURCE_DEPENDENCY) $(FILE_SOURCE_ADDITIONAL_DEPENDENCY) $(FILE_THIS)
	@echo "\# Compile $(FILE_SOURCE) to $(FILE_TARGET) by $(COMPILER)"
	@$(COMPILER) $(COMPILER2TARGET_FLAGS) $(FILE_TARGET) $(FILE_SOURCE)
	
build : $(FILE_TARGET) $(FILE_THIS)
	@echo "\# Verify target is bootable"
	@$(SHELL) $(SCRIPT_VERIFY)

run : build
	@echo "run QEMU with 1M memory to load $(FILE_TARGET) as disk image for boot device"
	@$(SHELL) $(SCRIPT_TEST)

clean :
	rm -f $(FILE_TARGET)
