section .text
global mandelbrot

mandelbrot:
    push rbp
    mov rbp, rsp

    mov rdi, rdi        ; rdi contains the pointer to the char array
    mov rsi, rsi        ; rsi contains the first integer
    mov rdx, rdx        ; rdx contains the second integer

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
    cvtsi2sd xmm0, r11
    cvtsi2sd xmm1, rsi
    divsd xmm0, xmm1

    mov r12, 1
    cvtsi2sd xmm1, r12

    mov r12, -2
    cvtsi2sd xmm2, r12

    subsd xmm1, xmm2

    mulsd xmm0, xmm1
    addsd xmm0, xmm2

    ; xmm1 = -1 + (r8 / rdx) * (1 - (-1))
    cvtsi2sd xmm1, r8
    cvtsi2sd xmm2, rdx
    divsd xmm1, xmm2

    mov r12, 1
    cvtsi2sd xmm2, r12

    mov r12, -1
    cvtsi2sd xmm3, r12

    subsd xmm2, xmm3

    mulsd xmm1, xmm2
    addsd xmm1, xmm3

mandel:
    xorpd xmm2, xmm2        ; xmm2 - z real part
    xorpd xmm3, xmm3        ; xmm3 - z imaginary part
    mov rax, 0              ; rax - n

mandel_loop:
    ; xmm5 = abs(z)^2 = xmm2^2 + xmm3^2
    movsd xmm5, xmm2
    mulsd xmm5, xmm2

    movsd xmm6, xmm3
    mulsd xmm6, xmm3

    addsd xmm5, xmm6

condidtion_abs:
    ; do mandel_loop while abs(z) <= 2 and n < 80
    mov r12, 4
    cvtsi2sd xmm6, r12
    comisd xmm5, xmm6
    ja end_mandel

condition_max_iter:
    mov r12, 80
    cmp rax, r12
    jge end_mandel

count_new_z:
    ; z = z*z + c
    ; xmm2 = xmm2^2 - xmm3^2 + xmm0
    movsd xmm4, xmm2         ; save old xmm2

    mulsd xmm2, xmm2

    movsd xmm6, xmm3
    mulsd xmm6, xmm3

    subsd xmm2, xmm6
    addsd xmm2, xmm0

    ; xmm3 = 2 * xmm2 * xmm3 + xmm1
    mov r12, 2
    cvtsi2sd xmm6, r12

    mulsd xmm3, xmm6
    mulsd xmm3, xmm4
    addsd xmm3, xmm1

    ; n += 1
    inc rax
    jmp mandel_loop

end_mandel:
    ; grey scale color
	; color = 255 - int(m * 255 / MAX_ITER)
    mov r12, 255
    cvtsi2sd xmm6, r12
    cvtsi2sd xmm4, rax

    mulsd xmm4, xmm6

    mov r10, 80
    cvtsi2sd xmm6, r10
    divsd xmm4, xmm6

    cvtsd2si r10, xmm4

    mov rax, r12
    sub rax, r10

store:
    ; store red
    mov [rdi], rax

    ; store green
    inc rdi
    mov [rdi], rax

    ; store blue
    inc rdi
    mov [rdi], rax

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