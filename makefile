CC = g++
ASMBIN = nasm
LDFLAGS = -lGL -lGLU -lglut

all : asm cc link

asm :
	$(ASMBIN) -o mandelbrot.o -f elf64 -g -F dwarf mandelbrot.asm
cc :
	$(CC) -m64 -c -g -O0 main.cpp
link :
	$(CC) -m64 -g -o mandel main.o mandelbrot.o $(LDFLAGS)

clean :
	rm *.o
	rm mandel