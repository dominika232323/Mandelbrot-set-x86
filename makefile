CC = g++
CFLAGS = -std=c++11 -Wall -Wextra
LDFLAGS = -lGL -lGLU -lglut

TARGET = bmp_opengl

all: $(TARGET)

$(TARGET): main.o
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

main.o: main.cpp
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(TARGET)
