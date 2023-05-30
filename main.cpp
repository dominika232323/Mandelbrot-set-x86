#include <iostream>
#include <fstream>
#include <stdio.h>
#include <GL/glut.h>

#pragma pack(push, 1)
struct BMPHeader
{
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


extern "C" void mandelbrot(unsigned char* imageData, int imageWidth, int imageHeight);


unsigned char* imageData;
int imageWidth, imageHeight;
float zoomFactor = 1.0;


void loadBMP(const char* filename)
{
    std::ifstream file(filename, std::ios::binary);

    if (!file)
    {
        std::cerr << "Failed to open BMP file: " << filename << std::endl;
        return;
    }

    BMPHeader header;
    file.read(reinterpret_cast<char*>(&header), sizeof(BMPHeader));

    if (header.signature[0] != 'B' || header.signature[1] != 'M')
    {
        std::cerr << "Invalid BMP file: " << filename << std::endl;
        return;
    }

    if (header.bitsPerPixel != 24)
    {
        std::cerr << "Unsupported BMP format: " << filename << std::endl;
        return;
    }

    imageWidth = header.width;
    imageHeight = header.height;

    imageData = new unsigned char[imageWidth * imageHeight * 3];
    file.read(reinterpret_cast<char*>(imageData), imageWidth * imageHeight * 3);
    file.close();

    mandelbrot(imageData, imageWidth, imageHeight);
}


void display()
{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0, zoomFactor * imageWidth, 0, zoomFactor * imageHeight);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glRasterPos2i(0, 0);
    glPixelZoom(zoomFactor, zoomFactor);
    glDrawPixels(imageWidth, imageHeight, GL_BGR_EXT, GL_UNSIGNED_BYTE, imageData);

    glFlush();
}


void keyboard(unsigned char key, int x, int y)
{
    switch (key)
    {
        case '+':  // Zoom in
            {
                zoomFactor += 0.1;
                glutPostRedisplay();
                break;
            }
        case '-':  // Zoom out
            {
                zoomFactor -= 0.1;
                if (zoomFactor < 0.1)
                    zoomFactor = 0.1;
                glutPostRedisplay();
                break;
            }
    }
}


int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(imageWidth, imageHeight);
    glutCreateWindow("Mandelbrot set");

    // char filename[100];
    const char* filename = "lena.bmp";
    // /mnt/c/Users/domin/Desktop/studia/sem2_23L/ARKO/x86/Mandelbrot-set-x86/lena.bmp

    // printf("Welcome to mandelbrot set generator!\n");
    // printf("Give the absolute path to the bmp file that you want to change to mandelbrot set: ");
    // scanf("%s", filename);

    loadBMP(filename);

    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);

    glutMainLoop();

    delete[] imageData;
    return 0;
}
