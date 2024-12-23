#!/usr/bin/bash

# Set the input file from the first parameter or default to input.c
input_file=${1:-bootsector.bas.c}
output_file=${2:-bootsector.c}

# Use awk to extract the function and rename the prototype
awk '
BEGIN {
 in_function = 0
 print "#include \"../v/common_prefix.h\""
}
/__attribute__\(\( constructor \)\) static void fb_ctor__bootsectorzbas\( void \)/ {
    in_function = 1
    print "void start()"
    next
}
in_function {
    print
    if ($0 ~ /}/) {
        in_function = 0
    }
}
END { print "#include \"../v/common_suffix.h\"" }
' "$input_file" > "$output_file"
