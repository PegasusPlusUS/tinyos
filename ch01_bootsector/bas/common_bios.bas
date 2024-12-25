Sub BIOS_CLEAR_SCREEN()
    ' Clear the screen
    Cls
End Sub 

Sub BIOS_SET_CURSOR_POS_P_ROW_COL(ByVal row As Byte, ByVal col As Byte)
    ' Set the cursor position
    Locate row, col
End Sub

Sub BIOS_BIOS_SET_PRINT_COLOR_P_COLOR(ByVal colour As Byte)
    ' Set the print color
    Color colour
End Sub

' Define the BIOS_PRINT_STRING__MAG procedure
Sub BIOS_PRINT_STRING_P_MSG(ByRef msg As String)
    ' Print the message
    Print msg
End Sub
