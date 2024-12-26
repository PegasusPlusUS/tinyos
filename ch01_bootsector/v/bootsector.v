module bootsector
import common_bios

const hello_msg := " Hello, world of Bare Metal in V! "
//const scroll_pos := 0
//const asm_char_1 := 0

fn start() {
    common_bios.bios_clear_screen();
    common_bios.bios_set_cursor_pos_p_row_col(10, 23);
    common_bios.bios_print_string_p_msg(hello_msg.str);

    for {
        //scroll_print_hello()
    } 
}
/*
fn scroll_print_hello() {
    bios_print_string_p_msg(hello_msg.str + scroll_pos);
    asm_char_1 = hello_msg[scroll_pos];
    hello_msg[scroll_pos] = 0;
    bios_print_string_p_msg(hello_msg.str);

    if scroll_pos++ >= hello_msg.size {
        scroll_pos = 0;
    }
}
*/
