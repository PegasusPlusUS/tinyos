#!/bin/bash

# Set the target file from the first parameter or default to bootsector.bin
target_file=${1:-bootsector.bin}

# Check if the target file exists
if [ ! -f "$target_file" ]; then
    echo "Error: File '$target_file' does not exist."
    exit 1
fi

# Verify file size
file_size=$(stat --format="%s" "$target_file" 2>/dev/null)
if [ "$file_size" -ne 512 ]; then
    echo "# Error: File size is not 512 bytes, but $file_size."
    exit 1
fi

# Verify last two bytes (the boot signature)
last_two_bytes=$(xxd -p -s -2 "$target_file" | tr -d '\n')
# echo "DEBUG: Last two bytes: $last_two_bytes"
if [ "$last_two_bytes" != "55aa" ]; then
    echo "# Error: Last two bytes are not 55 aa, but $last_two_bytes."
    exit 1
fi

# Extract the first 510 bytes (everything before the boot signature)
content_before_signature=$(xxd -p -s 0 -l 510 "$target_file" | tr -d '\n')
# echo "DEBUG: Content before signature (hex): $content_before_signature"

# Reverse the content using `awk` (emulate `rev`)
reversed_content=$(echo "$content_before_signature" | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1);}END{print x}')
# echo "DEBUG: Reversed content (hex): $reversed_content"

# Remove any unexpected whitespace or newline characters from reversed content
reversed_content=$(echo "$reversed_content" | tr -d '\n\r ')
# echo "DEBUG: Cleaned reversed content (hex): $reversed_content"

# Count leading zeros (now trailing zeros in original content)
leading_zeros=$(echo "$reversed_content" | sed -E 's/^(0+).*$/\1/')
trailing_zero_count=$(echo "$leading_zeros" | wc -c)
trailing_zero_count=$((trailing_zero_count - 1))  # Adjust for the newline from wc -c
# echo "DEBUG: Leading zero count before dividing by 2: $trailing_zero_count"

# Check if the count is even
# if ((trailing_zero_count % 2 != 0)); then
#     echo "Error: Trailing zero count is unexpectedly odd ($trailing_zero_count). Debugging required."
#     exit 1
# fi

# Each zero is represented as "00", so divide the count by 2
trailing_zero_count=$((trailing_zero_count / 2))

echo "# Number of continuous zeros before the boot signature: $trailing_zero_count"
echo "# File size and boot signature verification passed successfully!"
