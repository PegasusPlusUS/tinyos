#Please help using awk to convert the 2 lines:
#} TM__tLjJdorKZn78lBy9aS4V6Wg_4 = { 28 | NIM_STRLIT_FLAG, "Hi, bare-metal world by Nim!" };
#static const NimStringV2 TM__tLjJdorKZn78lBy9aS4V6Wg_5 = {28, (NimStrPayload*)&TM__tLjJdorKZn78lBy9aS4V6Wg_4};
#to one line:
#string TM__tLjJdorKZn78lBy9aS4V6Wg_5 = "Hi, bare-metal world by Nim!";
#
#static const struct {
#  NI cap; NIM_CHAR data[1+1];
#} TM__tLjJdorKZn78lBy9aS4V6Wg_2 = { 1 | NIM_STRLIT_FLAG, "!" };
#static const NimStringV2 TM__tLjJdorKZn78lBy9aS4V6Wg_3 = {1, (NimStrPayload*)&TM__tLjJdorKZn78lBy9aS4V6Wg_2};
#static const struct {
#  NI cap; NIM_CHAR data[28+1];
#} TM__tLjJdorKZn78lBy9aS4V6Wg_4 = { 28 | NIM_STRLIT_FLAG, "Hi, bare-metal world by Nim!" };
#static const NimStringV2 TM__tLjJdorKZn78lBy9aS4V6Wg_5 = {28, (NimStrPayload*)&TM__tLjJdorKZn78lBy9aS4V6Wg_4};
#
#N_LIB_PRIVATE N_NIMCALL(void, start__bootsector_u7)(void) {
#NIM_BOOL* nimErr_;
#	nimfr_("start", "C:\\Export\\tinyos\\ch01_bootsector\\nim\\bootsector.nim");
#{nimErr_ = nimErrorFlag();
#	nimln_(4);	BIOS_CLEAR_SCREEN__bootsector_u3();
#	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;
#	nimln_(5);	BIOS_SET_CURSOR_POS_ROW_COL__bootsector_u4(((NU8)10), ((NU8)30));
#	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;
#	nimln_(6);	BIOS_PRINT_STRING_MSG__bootsector_u1(TM__tLjJdorKZn78lBy9aS4V6Wg_5);
#	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;
#	}BeforeRet_: ;
#	popFrame();
#}

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
        gsub(/_1_/, "__")
    }
    print
}
END {
    print "#include \"common_suffix" LANG_SURFIX ".h\""
}
