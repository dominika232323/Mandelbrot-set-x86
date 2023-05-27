section .text
global mandelbrot

mandelbrot:
    push rbp
    mov rbp, rsp

    ; rdi - pointer to imageData
    ; rsi - imageWidth
    ; rdx - imageHeight

padding:
    mov r8, 0b0011
    mov rax, rsi
    and rax, r8         ; rax = width % 4

    mov r9, 4
    sub rax, r9

    and rax, r8
    mov r9, rax         ; r9 - padding

before_height_loop:
    mov r8, rdx
    dec r8              ; r8 - height iterator

height_loop:
    mov r11, 0          ; r11 - width iterator

    cmp r8, 0
    jl end_loop

width_loop:
    cmp r11, rsi
    jge next_height

    ; complex nums

store:
    ; store blue
    mov byte [rdi], 255

    ; store green
    inc rdi
    mov byte [rdi], 255

    ; store red
    inc rdi
    mov byte [rdi], 255

    inc rdi

    inc r11
    jmp width_loop

next_height:
    dec r8

    mov r12, r9

skip_padding:
    test r12, r12
    jz height_loop

    inc rdi
    dec r12
    jmp skip_padding

end_loop:

end:

    mov rsp, rbp
    pop rbp
    ret