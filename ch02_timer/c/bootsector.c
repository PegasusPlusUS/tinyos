#include "bootsector.h"

ASM_EPILOG_TIMER_INTERUPT;

// Time get_rtc_time(void);
// void print_time_at(Time time, char row, char col, char color);
DATA_BIOS_PARAM;
DATA_ADV_MSG;
// Messages
char HELLO_MSG[] = " C in timer mode! ";
short _scroll_pos_ = 0;

FN_BIOS_CLEAR_SCREEN;
FN_BIOS_SET_CURSOR_POS_P_ROW_COL;
FN_BIOS_PRINT_STRING__MSG_COLOR;
//FN_BIOS_PRINT_ADDRESS_AS_HEX;

void print_hi_msg_scroll() {
    asm_bios_print_char(HELLO_MSG + _scroll_pos_);
    _asm_char_2_ = HELLO_MSG[_scroll_pos_];
    HELLO_MSG[_scroll_pos_] = 0;
    asm_bios_print_char(HELLO_MSG);
    HELLO_MSG[_scroll_pos_] = _asm_char_2_;
    if (++_scroll_pos_ >= sizeof(HELLO_MSG)) {
        _scroll_pos_ = 0;
    }
}

volatile unsigned char delay = 0;
BEGIN_TIMER_HANDLER;

    if (++delay > 183) {
        delay = 0;
        asm_bios_set_cursor_pos(8, 31);
        asm_bios_set_print_color(COLOR_WHITE);
        print_hi_msg_scroll();
    }

END_TIMER_HANDLER;

END_ASM_BOOTSECTOR