#include <iostream>
#include <fstream>
#include <GL/glut.h>

#pragma pack(push, 1)
struct BMPHeader {
    char signature[2];
    unsigned int fileSize;
    unsigned short reserved1;
    unsigned short reserved2;
    unsigned int dataOffset;
    unsigned int headerSize;
    int width;
    int height;
    unsigned short planes;
    unsigned short bitsPerPixel;
    unsigned int compression;
    unsigned int imageSize;
    int xPixelsPerMeter;
    int yPixelsPerMeter;
    unsigned int totalColors;
    unsigned int importantColors;
};
#pragma pack(pop)

unsigned char* imageData;
int imageWidth, imageHeight;

void loadBMP(const char* filename) {
    std::ifstream file(filename, std::ios::binary);

    if (!file) {
        std::cerr << "Failed to open BMP file: " << filename << std::endl;
        return;
    }

    BMPHeader header;
    file.read(reinterpret_cast<char*>(&header), sizeof(BMPHeader));

    if (header.signature[0] != 'B' || header.signature[1] != 'M') {
        std::cerr << "Invalid BMP file: " << filename << std::endl;
        return;
    }

    if (header.bitsPerPixel != 24) {
        std::cerr << "Unsupported BMP format: " << filename << std::endl;
        return;
    }

    imageWidth = header.width;
    imageHeight = header.height;

    imageData = new unsigned char[imageWidth * imageHeight * 3];
    file.read(reinterpret_cast<char*>(imageData), imageWidth * imageHeight * 3);
    file.close();

    // Change pixel colors to red
    for (int i = 0; i < imageWidth * imageHeight; ++i) {
        imageData[i * 3] = 255;     // Set red component to maximum
        imageData[i * 3 + 1] = 0;   // Set green component to minimum
        imageData[i * 3 + 2] = 0;   // Set blue component to minimum
    }
}

void renderScene() {
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawPixels(imageWidth, imageHeight, GL_RGB, GL_UNSIGNED_BYTE, imageData);
    glFlush();
}

void initializeOpenGL(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA);
    glutInitWindowSize(imageWidth, imageHeight);
    glutCreateWindow("Mandelbrot set");
    glutDisplayFunc(renderScene);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    gluOrtho2D(0, imageWidth, 0, imageHeight);
    glutMainLoop();
}

int main(int argc, char** argv) {
    const char* filename = "lena.bmp";
    loadBMP(filename);
    initializeOpenGL(argc, argv);
    delete[] imageData;
    return 0;
}
