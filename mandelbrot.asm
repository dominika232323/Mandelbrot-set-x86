section .text
global mandelbrot

mandelbrot:
    push rbp
    mov rbp, rsp

    ; rdi - pointer to imageData
    ; rsi - imageWidth
    ; rdx - imageHeight

    mov al, 255

loopm:
    test rsi, rsi
    jz end

    mov byte [rdi], al
    inc rdi
    mov byte [rdi], al
    inc rdi
    mov byte [rdi], al
    inc rdi
    dec rsi
    jmp loopm

end:

    mov rsp, rbp
    pop rbp
    ret