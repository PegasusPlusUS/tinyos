#!/usr/bin/awk -f

# Filter movzbl, movzwl, pushl, popl, operand type mismatches, as well as previous work
{
    # Handle size reductions, e.g., 8 -> 4, 4 -> 2, etc.
    gsub(/8\s*\$/, "4$");  # 8-byte constants to 4-byte
    gsub(/4\s*\$/, "2$");  # 4-byte constants to 2-byte
    gsub(/2\s*\$/, "1$");  # 2-byte constants to 1-byte

    # Handle movzbl (move zero-extended byte to a 32-bit register)
    gsub(/movzbl\s+%(\w+),\s*(%\w+)/, "movzx %\\1, %\\2");

    # Handle movzwl (move zero-extended word to a 32-bit register)
    gsub(/movzwl\s+%(\w+),\s*(%\w+)/, "movzx %\\1, %\\2");

    # Handle HELLO_MSG usage with register
    gsub(/HELLO_MSG\((%\w+)\)/, "HELLO_MSG");  # Change to simple label addressing

    # Handle mov %eax, [HELLO_MSG(%eax)] or any similar type addressing with 32-bit register
    gsub(/mov\s+%(\w+),\s*HELLO_MSG\((%\w+)\)/, "mov %\\1, HELLO_MSG");

    # Ensure no 32-bit registers (like %eax) are used in 16-bit mode
    gsub(/%eax/, "%ax");
    gsub(/%ebx/, "%bx");
    gsub(/%ecx/, "%cx");
    gsub(/%edx/, "%dx");
    gsub(/%esp/, "%sp");
    gsub(/%ebp/, "%bp");

    # Handle pushl and popl for 16-bit mode (convert %eax to %ax, %ebp to %bp, etc.)
    # //gsub(/pushl\s+%ebp/, "push %bp");
    # //gsub(/pushl\s+%esp/, "push %sp");
    # //gsub(/popl\s+%ebp/, "pop %bp");
    # //gsub(/popl\s+%esp/, "pop %sp");
    # //gsub(/movl\s+%esp, %ebp/, "mov %sp, %bp");
    gsub(/pushl/, "push");
    gsub(/popl/, "pop");
    gsub(/movl/, "movw");
    gsub(/movzbl/, "movzbw");
    gsub(/subl/, "subw");
    gsub(/addl/, "addw");
    gsub(/cwtl/, "cbtw");
    gsub(/movzwl/, "movzx");
    gsub(/cmpl/, "cmpw");
    # Print the transformed line
    print
}
