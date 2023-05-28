CC = g++
CFLAGS = -std=c++11 -Wall -Wextra -g
LDFLAGS = -lGL -lGLU -lglut

TARGET = bmp_opengl

all: $(TARGET)

$(TARGET): main.o mandelbrot.o
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

main.o: main.cpp
	$(CC) $(CFLAGS) -c $< -o $@

mandelbrot.o: mandelbrot.asm
	nasm -f elf64 -o $@ $<

clean:
	rm -f *.o $(TARGET)