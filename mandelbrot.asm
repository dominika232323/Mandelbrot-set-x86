section .text
global mandelbrot

mandelbrot:
    push rbp
    mov rbp, rsp

    ; rdi - pointer to imageData
    ; rsi - imageWidth
    ; rdx - imageHeight

padding:
    mov rax, rsi
    imul rax, rdi
    imul rax, 3
    mov r10, rax        ; r10 - imageSize

    mov r8, 0b0011
    mov rax, r10
    and rax, r8

    mov r9, 4
    sub rax, r9
    imul rax, -1

    and rax, r8
    mov r9, rax         ; r9 - padding

end:

    mov rsp, rbp
    pop rbp
    ret