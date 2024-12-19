proc fatal*(msg: string) {.noreturn.} =
  asm """
    cli
    hlt
  """
