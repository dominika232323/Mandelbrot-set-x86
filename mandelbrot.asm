section .data
    ONE dq 1.0


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

count_complex_number:
    ; xmm0 = -2 + (r11 / rsi) * (1 - (-2))
    movq xmm0, r11
    movq xmm1, rsi
    divsd xmm0, xmm1

    mov r12, 1
    movq xmm1, r12

    mov r12, -2
    movq xmm2, r12

    subsd xmm1, xmm2

    mulsd xmm0, xmm1
    addsd xmm0, xmm2

    ; xmm1 = -1 + (r8 / rdx) * (1 - (-1))
    movq xmm1, r8
    movq xmm2, rdx
    divsd xmm1, xmm2

    mov r12, 1
    movq xmm2, r12

    mov r12, -1
    movq xmm3, r12

    subsd xmm2, xmm3

    mulsd xmm1, xmm2
    addsd xmm1, xmm3

mandel:
    xorpd xmm2, xmm2        ; xmm2 - z real part
    xorpd xmm3, xmm3        ; xmm3 - z imaginary part
    mov r10, 0              ; r10 - n

mandel_loop:
    ; xmm5 = abs(z)^2 = xmm2^2 + xmm3^2
    movq xmm5, xmm2
    mulsd xmm5, xmm2

    movq xmm6, xmm3
    mulsd xmm6, xmm3

    addsd xmm5, xmm6

    ; do mandel_loop while abs(z) <= 2 and n < 80
    mov r12, 4
    movq xmm6, r12
    ucomisd xmm5, xmm6
    jg end_mandel

    mov r12, 80
    cmp r10, r12
    jge end_mandel

    ; z = z*z + c
    ; xmm2 = xmm2^2 - xmm3^2 + xmm0
    movq xmm4, xmm2         ; save old xmm2

    mulsd xmm2, xmm2

    movq xmm6, xmm3
    mulsd xmm6, xmm3

    subsd xmm2, xmm6
    addsd xmm2, xmm0

    ; xmm3 = 2 * xmm2 * xmm3 + xmm1

end_mandel:

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