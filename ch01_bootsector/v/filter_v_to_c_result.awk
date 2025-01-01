# Test on V 0.4.8 2ab1523
#
BEGIN {
    LANG_SURFIX = ".v"

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
/^VV_LOCAL_SYMBOL void bootsector__start\(void\) \{/ {
    in_bootsector_start = 1
    print "void start() {"
    next
}
in_bootsector_start {
    if (/^}/) {
        in_bootsector_start = 0
    } else if (/([a-z0-9_]*)\.len/) {
        # Replace _const_bootsector__<name>.len with sizeof(<name>)
        gsub(/([a-z0-9_]*)\.len/, "sizeof(\1)")
    } else {
        # sed rule s/\\bcommon_bios__([a-z0-9_]*)/\\U&/g' equivalent
        while (match($0, /common_bios__([_a-z0-9]*)/, matches)) {
            # Extract the matched text
            # How RSTART and RLENGTH Work:
            # match(string, regex):

            # Searches string for the first occurrence of the regular expression regex.
            # Sets RSTART and RLENGTH to the position and length of the match, respectively.
            # Extracting the Match:

            # Use substr(string, RSTART, RLENGTH) to extract the matched substring.
            # No Match:

            # If the regular expression does not match, RSTART is 0 and RLENGTH is -1.
            # matched = substr($0, RSTART + 13, RLENGTH - 13)
            matched = matches[1]        
            # Convert the matched text to uppercase
            #replacement = toupper(matched)
            replacement = matched
            # Replace the matched text with the !uppercase version
            $0 = substr($0, 1, RSTART - 1) replacement substr($0, RSTART + RLENGTH)
        }
        gsub(/_const_bootsector__([a-z0-9_]*).str/, "hello_msg")
        #gsub(/bootsector__/, "")
    }
    print
}
/string _const_bootsector__/ {
    # Replace _const_bootsector__ with const char[]
    gsub("string _const_bootsector__", "string ")
    print
}
END { print "#include \"common_suffix" LANG_SURFIX ".h\"" }
