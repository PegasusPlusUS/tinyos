# Test on Nim 2.0.2
#

BEGIN {
    LANG_SURFIX = ".nim"

    in_string_declaration = 0
    in_bootsector_start = 0
    print "#include \"common_prefix" LANG_SURFIX ".h\"\n"
}
(in_string_declaration == 0) && match($0, /NIM_STRLIT_FLAG,/) {
    in_string_declaration = 1
    match($0, /"([^"]+)"/, arr);
    strcontent = arr[1];  # Store the string literal
    next
}
in_string_declaration {
    in_string_declaration = 0
    # Extract the variable name in the second line between "static const" and "="
    if ($0 ~ /static const/ && $0 ~ /=/) {
        # Extract the variable name between "static const" and "="
        match($0, /static const NimStringV2 ([A-Za-z0-9_]+) =/, arr);
        var_name = arr[1];  # Store the extracted variable name

        # Output the formatted string
        print "string " var_name " = \"" strcontent "\";";
    }
}
/N_LIB_PRIVATE N_NIMCALL\(void, start__bootsector_u7\)\(void\) \{/ {
    in_bootsector_start = 1
    print "void start() {"
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
    } else if (/if \(NIM_UNLIKELY\(\*nimErr_\)\) goto BeforeRet_;/) {
        next
    } else if (/\}BeforeRet_/) {
        next
    } else if (/popFrame\(\);/) {
        next
    } else if (/NIM_BOOL\* nimErr_;/) {
        next
    } else if (/nimfr_\("start", /) {
        next
    } else if (/\{nimErr_ = nimErrorFlag\(\);/) {
        next
    } else {
        #gsub(/\( \&/, "( ")
        gsub(/\(NU8\)/, " ")
        gsub(/nimln_\([0-9]*\);\t/, "")
        gsub(/__bootsector_u[0-9]*/, "")
        #gsub(/_p_/, "__")
    }
    print
}
END {
    print "#include \"common_suffix" LANG_SURFIX ".h\""
}
