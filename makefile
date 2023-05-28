CC = g++
ASMBIN = nasm
CFLAGS = -Wall -m64 -no-pie
LDFLAGS = -lGL -lGLU -lglut

all : asm cc link

asm :
	$(ASMBIN) -o mandelbrot.o -f elf64 -g -l mandelbrot.lst mandelbrot.asm

cc :
	$(CC) $(CFLAGS) -c -g -O0 main.cpp -std=c11 -lm

link :
	$(CC) $(CFLAGS) -g -o bezier main.o mandelbrot.o $(LDFLAGS)

gdb :
	gdb bezier

clean:
	rm -f *.o bezier mandelbrot.lst