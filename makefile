CC = g++
CFLAGS = -std=c++11 -Wall -Wextra
LDFLAGS = -lGL -lGLU -lglut

ASMBIN=nasm

TARGET = bmp_opengl

all: asm $(TARGET)

asm :
	$(ASMBIN) -o mandelbrot.o -f elf64 -g -F dwarf mandelbrot.asm

$(TARGET): main.o mandelbrot.o
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

main.o: main.cpp
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(TARGET)
