use std::fs::OpenOptions;
use std::io::Write;
use std::os::windows::fs::OpenOptionsExt;
//use std::os::windows::io::AsRawHandle;
use winapi::um::winbase::FILE_FLAG_OVERLAPPED;

fn main() {
    let pipe_name = r"\\.\pipe\bootsector";
    let boot_sector = [0u8; 512]; // Your boot sector data here

    let mut pipe = OpenOptions::new()
        .write(true)
        .custom_flags(FILE_FLAG_OVERLAPPED)
        .open(pipe_name)
        .expect("Failed to open named pipe");

    pipe.write_all(&boot_sector).expect("Failed to write to named pipe");
}
