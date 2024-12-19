use std::env;
use std::fs::{File, OpenOptions};
use std::io::{Read, Write};
use flate2::write::ZlibEncoder;
use flate2::read::ZlibDecoder;
use flate2::Compression;

#[cfg(windows)]
use std::os::windows::fs::OpenOptionsExt;

#[allow(unused_imports)]
#[cfg(unix)]
use std::os::unix::fs::OpenOptionsExt;

use clap::{Parser, Subcommand};

/// Program that works with named pipes for different purposes
#[derive(Parser)]
#[command(author, version, about)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Create a named pipe
    MkPipe {
        /// The name of the pipe to create
        pipe: String,
    },
    /// Pipe to file: read from pipe, compress, and write to file
    P2F {
        /// The name of the pipe to read from
        pipe: String,
        /// The name of the file to write to
        file: String,
    },
    /// File to pipe: read from file, decompress, and write to pipe
    F2P {
        /// The name of the file to read from
        file: String,
        /// The name of the pipe to write to
        pipe: String,
    },
}

fn main() {
    let cli = Cli::try_parse();

    match cli {
        Ok(cli) => {
            let _ = work(cli.command);
        }
        Err(_) => {
            print_usage();
        }
    }
}

const BUFFER_SIZE: usize = 512;

fn work(cmd: Commands) -> std::io::Result<()> {
    fn create_pipe(pipe: &String, read: bool, write: bool) -> std::io::Result<File> {
        let pipe = OpenOptions::new()
            .read(read)
            .write(write)
            .custom_flags(0x40000000) // FILE_FLAG_FIRST_PIPE_INSTANCE
            .open(format!("{}{}", r"\\.\", pipe))?;
        Ok(pipe)
    }

    fn open_file(file: &String, read_or_write: bool) -> std::io::Result<File> {
        let file = if read_or_write {
            File::open(file)
        } else {
            File::create(file)
        };
        file
    }

    // Extract the pipe name and determine read/write flags
    let (pipe, read, write) = match &cmd {
        Commands::MkPipe { pipe } => (pipe, true, true),
        Commands::P2F { pipe, .. } => (pipe, false, true),
        Commands::F2P { pipe, .. } => (pipe, true, false),
    };

    // Open the named pipe for reading
    let mut pipe = create_pipe(pipe, read, write)?;
    match cmd {
        Commands::MkPipe { .. } => { Ok(()) }
        Commands::P2F { file, .. } => {
            let mut file = open_file(&file, read)?;
            p2f_mode(&mut pipe, &mut file)
        }
        Commands::F2P { file, .. } => {
            let mut file = open_file(&file, read)?;
            f2p_mode(&mut file, &mut pipe)
        }
    }
}

fn p2f_mode(pipe: &mut File, file: &mut File) -> std::io::Result<()> {
    let mut buffer = [0u8; BUFFER_SIZE];
    pipe.read_exact(&mut buffer)?; // Read 512 bytes from the pipe

    // Compress the data
    let mut compressed_data = Vec::new();
    let mut encoder = ZlibEncoder::new(&mut compressed_data, Compression::default());
    encoder.write_all(&buffer)?;
    encoder.finish()?;

    file.write_all(&compressed_data)?;

    println!("Data compressed and saved");
    Ok(())
}

fn f2p_mode(file: &mut File, pipe: &mut File) -> std::io::Result<()> {
    let mut compressed_data = Vec::new();
    file.read_to_end(&mut compressed_data)?;

    // Decompress the data
    let mut decoder = ZlibDecoder::new(&compressed_data[..]);
    let mut buffer = [0u8; BUFFER_SIZE];
    decoder.read_exact(&mut buffer)?;

    pipe.write_all(&buffer)?;
    println!("Data decompressed and written to the pipe");
    Ok(())
}

// Usage:
// 1. mkpipe pipe
// Then compiler write to pipe, zipper read from pipe
// Or zipper write to pipe, VM load image from pipe
// 2. p2f pipe file
// Create pipe, read pipe, compress then write to file
// 3. f2p file pipe
// Create pipe, read file, decompress then write to pipe
fn print_usage() {
    let args: Vec<String> = env::args().collect();

    let executable_base_name = args[0].split(&['/', '\\'][..]).last().unwrap();
    eprintln!("Usage:");
    eprintln!("1. {} mkpipe <pipe_name>", executable_base_name);
    eprintln!("     Create pipe, then compiler write to pipe, zipper read from pipe,");
    eprintln!("     or zipper write to pipe, VM load image from pipe.");
    eprintln!("2. {} p2f <pipe_name> <output_file>", executable_base_name);
    eprintln!("     Create pipe, then compress content written by compiler to file.");
    eprintln!("3. {} f2p <input_file> <pipe_name>", executable_base_name);
    eprintln!("     Create pipe, then decompress file content to pipe for VM loading image from.");
}
