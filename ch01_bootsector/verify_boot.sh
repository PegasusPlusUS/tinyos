#!/bin/bash

# Set the target file from the first parameter or default to bootsector.bin
target_file=${1:-bootsector.bin}

# Check if the target file exists
if [ ! -f "$target_file" ]; then
    echo "Error: File '$target_file' does not exist."
    exit 1
fi

# Platform detection
is_windows=0
if [ "$OS" = "Windows_NT" ] || [ "$(uname -o 2>/dev/null)" = "Msys" ]; then
    is_windows=1
fi

# Verify file size
if [ "$is_windows" -eq 1 ]; then
    file_size=$(stat --format="%s" "$target_file" 2>/dev/null)
else
    file_size=$(stat -c%s "$target_file")
fi

if [ "$file_size" -ne 512 ]; then
    echo "# Error: File size is not 512 bytes, but $file_size."
    exit 1
fi

# Verify last two bytes (the boot signature)
if [ "$is_windows" -eq 1 ]; then
    last_two_bytes=$(xxd -p -s -2 -l 2 "$target_file" | tr -d '\n')
else
    last_two_bytes=$(xxd -p -s -2 "$target_file" | tr -d '\n')
fi

if [ "$last_two_bytes" != "55aa" ]; then
    echo "# Error: Last two bytes are not 55 aa, but $last_two_bytes."
    exit 1
fi

# Extract the first 510 bytes and calculate trailing zero count using awk
trailing_zero_count=$(xxd -p -s 0 -l 510 "$target_file" | tr -d '\n' | awk '
{
    count = 0;
    for (i = length($0); i > 0; i -= 2) {
        if (substr($0, i-1, 2) == "00") {
            count++;
        } else {
            break;
        }
    }
    print count;
}')

echo "# Number of continuous zeros before the boot signature: $trailing_zero_count"
echo "# File size and boot signature verification passed successfully!"
