CC=gcc
ASMBIN=nasm

all : asm cc link

asm :
	$(ASMBIN) -o func.o -f elf -g -l func.lst func.asm
cc :
	$(CC) -m32 -c -g -O0 main.c -std=c99
link :
	$(CC) -m32 -g -o program main.o func.o
gdbb :
	gdb program

clean :
	rm *.o
	rm program
	rm func.lst
debug : all gdbb
