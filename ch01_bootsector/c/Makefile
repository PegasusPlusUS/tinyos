include ../common.mk

# # EXE_C_COMPILER = i686-elf-gcc
# # CFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
# # 		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
# # 		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
# # ASMFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
# # 		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
# # 		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse -O0 -S 

# # Disable default rules by overriding them with empty rules
# .SUFFIXES:

# all: run

# .PHONY : run build net clean run_under_av check_asm

# SHELL=/usr/bin/bash

# BOOTSECTOR=bootsector
# FILES_BUILD_RULES=Makefile

# # CI_PIPE_LINE_START
# # # 1. C to C
# FILE_SOURCE=$(BOOTSECTOR).c
# FILES_SOURCE_DEPENDENCIES=common_prefix.h bootsector.h common_suffix.h
# #FILE_LANG_TO_C_INITIAL_RESULT=$(FILE_SOURCE).c
# # EXE_LANG_TO_C_COMPILER=v
# # FLAGS_LANG_TO_C=-freestanding
# # $(FILE_LANG_TO_C_INITIAL_RESULT): $(FILE_SOURCE) $(FILES_SOURCE_DEPENDENCIES) $(FILES_BUILD_RULES)
# # 	@echo "# Compile $(FILE_TARGET) by $(EXE_LANG_TO_C_COMPILER)."
# # 	@$(EXE_LANG_TO_C_COMPILER) $(FLAGS_LANG_TO_C) -o $(FILE_LANG_TO_C_INITIAL_RESULT) .

# # # 2. Filter C
# FILE_LANG_TO_C_FINAL_RESULT=$(BOOTSECTOR).c
# # FILTER=awk
# # SCRIPT_FILTER_LANG_TOC=filter_toc_source.awk
# # $(FILE_LANG_TO_C_FINAL_RESULT): $(FILE_LANG_TO_C_INITIAL_RESULT) $(SCRIPT_FILTER_LANG_TOC) $(FILES_BUILD_RULES)
# # 	@echo "# Filter out unneeded code and add necessary reused functions and $(BOOTSECTOR) signature from ../c/$(BOOTSECTOR).h by $(FILTER)."
# # 	@$(FILTER) -f $(SCRIPT_FILTER_LANG_TOC) $(FILE_LANG_TO_C_INITIAL_RESULT) > $(FILE_LANG_TO_C_FINAL_RESULT)

# # 3. C to O
# FILE_OBJ_INTERMIDIATE=$(BOOTSECTOR).o
# FILE_C_TO_ASM_RESULT=$(BOOTSECTOR).s
# EXE_C_COMPILER = i686-elf-gcc
# FLAGS_C_TO_O = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
# 		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
# 		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
# FLAGS_C_TO_ASM = $(FLAGS_C_TO_O) -O0 -S
# C_DEPENDENCIES=common_prefix.h bootsector.h common_suffix.h
# $(FILE_OBJ_INTERMIDIATE): $(FILE_LANG_TO_C_FINAL_RESULT) $(C_DEPENDENCIES) $(FILES_BUILD_RULES)
# 	@echo "# Compile c code to object by $(EXE_C_COMPILER)."
# 	@$(EXE_C_COMPILER) $(FLAGS_C_TO_O) -o $(FILE_OBJ_INTERMIDIATE) -c $(FILE_LANG_TO_C_FINAL_RESULT)
# $(FILE_C_TO_ASM_RESULT): $(FILE_LANG_TO_C_FINAL_RESULT) $(FILES_BUILD_RULES)
# 	@echo "# Generate asm code for checking by $(EXE_C_COMPILER)."
# 	@$(EXE_C_COMPILER) $(FLAGS_C_TO_ASM) -o $(FILE_C_TO_ASM_RESULT) $(FILE_LANG_TO_C_FINAL_RESULT)

# EXE_LINK=i686-elf-ld
# FLAGS_LINK=-T linker.ld --oformat binary -s

# FILE_TARGET=$(BOOTSECTOR).bin
# $(FILE_TARGET): $(FILE_OBJ_INTERMIDIATE) $(FILES_BUILD_RULES)
# 	@echo "# Link object to binary by $(EXE_LINK)."
# 	@$(EXE_LINK) $(FLAGS_LINK) -o $(FILE_TARGET) $(FILE_OBJ_INTERMIDIATE)

# SCRIPT_VERIFY=../verify_boot.sh
# SCRIPT_TEST=../test.qemu.sh

# FILE_TARGET_UNDER_AV=$(FILE_TARGET).pz
# PB_HOLDER=../.pipe/pb_holder/target/release/pb_holder.exe
# $(FILE_TARGET_UNDER_AV): $(FILE_OBJ_INTERMIDIATE) $(FILES_BUILD_RULES)
# 	@echo "# Start $(PB_HOLDER) to pack $(FILE_TARGET) as $(FILE_TARGET_UNDER_AV)."
# 	@$(PB_HOLDER) p2f $(FILE_TARGET) $(FILE_TARGET_UNDER_AV)
# 	@echo "# Link object to binary by $(EXE_LINK)."
# 	@$(EXE_LINK) $(FLAGS_LINK) -o $($(PB_HOLDER) p2f) $(FILE_OBJ_INTERMIDIATE)
# SCRIPT_VERIFY_UNDER_AV=../verify_boot.under_av.sh
# SCRIPT_TEST_UNDER_AV=../test.under_av.qemu.sh
# # CI_PIPE_LINE_END


# check_asm: $(FILE_C_TO_ASM_RESULT) $(FILES_BUILD_RULES)
# 	@echo "# Opening file in Visual Studio Code... "
# 	@code $(FILE_C_TO_ASM_RESULT)
# 	# @ls -l $(FILE_C_TO_ASM_RESULT)

# build: $(FILE_TARGET) $(FILES_BUILD_RULES)
# 	@echo "# Build $(FILE_TARGET) by $(EXE_LANG_TO_C_COMPILER)/$(EXE_C_COMPILER)/$(EXE_LINK) succeeded!"
# 	@echo "# Verify $(FILE_TARGET) is valid $(BOOTSECTOR)."
# 	@$(SHELL) $(SCRIPT_VERIFY)

# build_under_av: $(FILE_TARGET_UNDER_AV) $(FILES_BUILD_RULES)
# 	@echo "# Build $(FILE_TARGET_UNDER_AV) by $(EXE_LANG_TO_C_COMPILER)/$(EXE_C_COMPILER)/$(EXE_LINK)/$(PB_HOLDER) succeeded!"
# 	@echo "# Verify $(FILE_TARGET_UNDER_AV) is valid $(BOOTSECTOR)."
# 	@$(SHELL) $(SCRIPT_VERIFY_UNDER_AV)

# neat:
# 	rm -f *.o *.s

# clean: neat
# 	rm -f $(FILE_TARGET)

# run: build
# 	@echo "# Run QEMU VM with 1M memory to load $(FILE_TARGET) as disk image for boot device"
# 	$(SHELL) $(SCRIPT_TEST)

# run_under_av: build_under_av
# 	@#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.bin.pz tinyos_bootsector_provider
# 	$(SHELL) $(SCRIPT_TEST_UNDER_AV)
