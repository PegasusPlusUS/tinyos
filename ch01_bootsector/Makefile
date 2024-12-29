# TODO enumrate each language, compile target, or select one language to compile target and run
.PHONY=clean neat neat-subdirs check

SUBDIRS = asm c v bas nim

# Define the target for each bootsector.bin in the subdirectories
BOOTSECTORS = $(patsubst %, dir/%/bootsector.bin, $(SUBDIRS))

all: $(BOOTSECTORS)

# Rule to build each bootsector.bin directly from each subdirectory
dir/%/bootsector.bin:
	@$(MAKE) -C $* bootsector.bin

# New target to perform neat operations in the main directory
neat:
	@echo "Running neat operations in the main directory..."
	# Example: Remove temporary files (customize as needed)
	@rm -f *.o *.tmp
	@echo "Neat operations completed."

# New target to run 'make neat' in each subdirectory
neat-subdirs:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir neat; \
	done

# New target to check for the existence of dir/bootsector.bin
check:
	@if [ -f dir/bootsector.bin ]; then \
		echo "dir/bootsector.bin exists."; \
	else \
		echo "dir/bootsector.bin does not exist."; \
	fi

clean:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done