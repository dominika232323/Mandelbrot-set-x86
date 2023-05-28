CC = g++
CFLAGS = -g
LDFLAGS = -lGL -lGLU -lglut

TARGET = bmp_opengl

all: $(TARGET)

$(TARGET): main.o mandelbrot.o
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

main.o: main.cpp
	$(CC) $(CFLAGS) -c -m64 $< -o $@

mandelbrot.o: mandelbrot.asm
	nasm -f elf64 -g -F dwarf -o $@ $<

clean:
	rm -f *.o $(TARGET)