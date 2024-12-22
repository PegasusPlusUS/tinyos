#may also let defalt test.qemu.sh accept param to work as under av mode.
#start pb holder
#bootsector.bz at current directory, but pb holder is in .pipe/target/release relative to where the test.under_av.qemu.sh is.
#named pipe path reported by ph holder.
#ask pb holder to load bootsector.bz and service at named pipe file name reported to qemu.
qemu-system-x86_64 -m 1m -drive file=path_from_pb_holder,format=raw
