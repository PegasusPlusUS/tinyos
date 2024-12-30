def convert_ndisasm_to_nasm(input_file, output_file):
    """
    Convert ndisasm output to NASM-compatible assembly with proper operand size.
    Rewrite `add` and `mov` instructions for operand size (8-bit/16-bit).
    
    Parameters:
        input_file (str): Input disassembly file.
        output_file (str): Output NASM-compatible assembly file.
    """
    asm_code = []

    try:
        with open(input_file, 'r') as infile:
            for line in infile:
                # Split the line into parts
                parts = line.split(maxsplit=2)

                # Check if the line has at least 3 parts (address, opcode, instruction)
                if len(parts) == 3:
                    instruction = parts[2].strip()  # Extract the instruction part
                    
                    # Rewrite `add` instructions based on operand size
                    if instruction.startswith("add "):
                        operands = instruction[4:]  # Get the operands
                        if operands.endswith(",al"):
                            instruction = f"add {operands}"
                        elif operands.endswith(",ax"):
                            instruction = f"addw {operands}"
                        elif operands.startswith("[bx+si]"):
                            instruction = f"addw {operands}"
                        elif operands.startswith("[si]"):
                            instruction = f"add {operands}"
                        elif operands.startswith("[bp+di]"):
                            instruction = f"add {operands}"
                        elif operands.startswith("[bx+di]"):
                            instruction = f"add {operands}"
                        else:
                            instruction = f"add {operands}"

                    # Rewrite `mov` instructions based on operand size
                    elif instruction.startswith("mov "):
                        operands = instruction[4:]  # Get the operands
                        if operands.endswith(",al"):
                            instruction = f"movb {operands}"
                        elif operands.endswith(",ax"):
                            instruction = f"movw {operands}"
                        elif operands.startswith("[bp+0x8]") or operands.startswith("[bp+0xc]"):
                            instruction = f"movb {operands}"
                        else:
                            instruction = f"mov {operands}"

                    # Append rewritten instruction
                    asm_code.append(instruction)
                else:
                    # Append the line as-is if it doesn't have the expected format
                    asm_code.append(line.strip())

        # Write the processed lines to the output file
        with open(output_file, 'w') as outfile:
            outfile.write('\n'.join(asm_code) + '\n')

        print(f"Conversion completed: {input_file} -> {output_file}")

    except FileNotFoundError:
        print(f"Error: The file {input_file} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
convert_ndisasm_to_nasm('bootsector.disasm.asm', 'bootsector.asm')
