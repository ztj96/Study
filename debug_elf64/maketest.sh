nasm elf64.asm -o test
chmod 777 test
./test
echo ''
echo $?
gdb test -tui

<<COMMENT
b *0x400078
layout regs
r
disassemble
COMMENT


<<COMMENT
gdb ./md5sum -tui

set args test
b *0x4025bc
layout asm
layout regs
r
disassemble
COMMENT

<<COMMENT
gdb ./md5sum

set args test
b *0x4028E0
COMMENT