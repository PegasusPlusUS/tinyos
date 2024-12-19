# panicoverride.nim
proc panic*(message: string) {.noreturn.} =
  asm """
    cli
    hlt
  """

proc rawoutput*(msg: string) =
  discard

