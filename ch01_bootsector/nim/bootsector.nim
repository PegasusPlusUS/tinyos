# bootsector.nim

proc moveCursor(row: uint8, col: uint8) =
  asm """
    mov $0x02, %%ah
    xor %%bh, %%bh
    movb %0, %%r8b
    movb %1, %%dl
    int $0x10
    :
    : "r"(row_p0), "r"(col_p1)
    : "ah", "bh", "dh", "dl", "memory"
  """

proc main() =
  # Move the cursor to a specific position (e.g., row 0, column 0)
  moveCursor(10, 10)

  # Hang the system after moving the cursor (infinite loop)
  while true: 
    discard  # Ensure this line is properly indented

proc start() {.noreturn.} =
  # This will not actually run; just to declare the entry point.
  main()
  discard

# Entry point
start()
