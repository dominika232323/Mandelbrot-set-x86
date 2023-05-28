CC = g++
ASMBIN = nasm
CFLAGS = -std=c++11 -Wall -m64 -no-pie
LDFLAGS = -lGL -lGLU -lglut

all : asm cc link

asm :
	$(ASMBIN) -o mandelbrot.o -f elf64 -g -l mandelbrot.lst mandelbrot.asm

cc :
	$(CC) $(CFLAGS) -c -g -O0 main.cpp -lm

link :
	$(CC) $(CFLAGS) -g -o mandel_set main.o mandelbrot.o $(LDFLAGS)

gdb :
	gdb mandel_set

clean:
	rm -f *.o mandel_set mandelbrot.lst