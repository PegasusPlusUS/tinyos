BEGIN {
    LANG_SURFIX = ".bas"

    POST_PHONE_STRING = ""

    in_init_global_allocator = 0
    in_bootsector_start = 0
    print "#include \"common_prefix" LANG_SURFIX ".h\"\n"
}
/^init_global_allocator\(\);/ {
    in_init_global_allocator = 1
    next
}
in_init_global_allocator {
    if (/^}/) {
        in_init_global_allocator = 0
    } else if (/_const_bootsector__/) {
        # Replace _const_bootsector__ with string
        gsub("/_const_bootsector__hello_msg/", "string hello_msg")
        while (match($0, /_const_bootsector__/)) {
            # Extract the matched text
            matched = substr($0, RSTART, RLENGTH)
            # Convert the matched text to uppercase
            replacement = "string "
            # Replace the matched text with the uppercase version
            $0 = substr($0, 1, RSTART - 1) replacement substr($0, RSTART + RLENGTH)
        }
        print
    }
}
/__attribute__\(\( constructor \)\) static void fb_ctor__bootsectorzbas\( void \)/ {
    in_bootsector_start = 1
    print "void start()"
    next
}
in_bootsector_start {
    if (/^}/) {
        in_bootsector_start = 0
    } else if (/label\$/) {
        next
    } else if (/FBSTRING MESSAGE\$/) {
        next
    } else if (/__builtin_memset/) {
        next
	# fb_StrAssign( (void*)&MESSAGE$0, -1ll, (void*)"Hello, world of Bare Metal in FreeBASIC!", 41ll, 0 );
    } else if (/fb_StrDelete/) {
        next
    } else {
        while (match($0, /fb_StrAssign\( \(void\*\)\&/)) {
            if (match($0, /fb_StrAssign\( *\(void\*\)&([A-Za-z_][A-Za-z0-9_$]*) *, *-1ll, *\(void\*\)"([^"]*)".*/, matches)) {
                # matches[1] contains the variable name
                # matches[2] contains the string content                
                POST_PHONE_STRING = POST_PHONE_STRING sprintf("\nstring %s = \"%s\";\n", matches[1], matches[2])
            }
            next
        }
        gsub(/\( \&/, "( ")
        gsub(/ \(int8\)/, " ")
    }
    print
}
/static FBSTRING/ {
    # Replace _const_bootsector__ with const char[]
    gsub("static FBSTRING", "string ")
    print
}
END {
    print POST_PHONE_STRING
    print "#include \"common_suffix" LANG_SURFIX ".h\""
}
