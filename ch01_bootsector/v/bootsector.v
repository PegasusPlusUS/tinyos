module bootsector
import common_bios

const hello_msg := " Hello, world of Bare Metal in V! "
//const scroll_pos := 0
//const asm_char_1 := 0

fn bootsector_start() {
    common_bios.asm_bios_clear_screen();
    common_bios.asm_bios_set_cursor_pos(10, 23);
    common_bios.asm_bios_set_print_color(12);
    for c in hello_msg {
        common_bios.asm_bios_print_char(c);
    }

    for {
        //scroll_print_hello()
    } 
}
/*
fn scroll_print_hello() {
    asm_bios_print_string(hello_msg.str + scroll_pos);
    asm_char_1 = hello_msg[scroll_pos];
    hello_msg[scroll_pos] = 0;
    print_string_at(hello_msg.str);

    if scroll_pos++ >= hello_msg.size {
        scroll_pos = 0;
    }
}
*/
