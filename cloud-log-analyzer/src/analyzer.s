// Practica 4.2 - Variante B
// Codigo HTTP mas frecuente
// ARM64 Assembly GNU Assembler

    .section .bss
    .align 4
buf:    .space 4096
freq:   .space 2000

    .section .data
    .align 4
msg:        .ascii "Most frequent status code: "
msg_len  =  . - msg

    .section .text
    .global _start

_start:
    adrp x0, freq
    add  x0, x0, :lo12:freq
    mov  x1, #500
init_loop:
    cbz  x1, init_done
    str  wzr, [x0], #4
    sub  x1, x1, #1
    b    init_loop
init_done:

read_loop:
    mov  x0, #0
    adrp x1, buf
    add  x1, x1, :lo12:buf
    mov  x2, #4096
    mov  x8, #63
    svc  #0
    cmp  x0, #0
    ble  find_max
    mov  x19, x0
    adrp x20, buf
    add  x20, x20, :lo12:buf

parse_loop:
    cbz  x19, read_loop
    ldrb w1, [x20], #1
    sub  x19, x19, #1
    cmp  w1, #48
    blt  parse_loop
    cmp  w1, #57
    bgt  parse_loop
    sub  w21, w1, #48
    cbz  x19, read_loop
    ldrb w2, [x20], #1
    sub  x19, x19, #1
    cmp  w2, #48
    blt  parse_loop
    cmp  w2, #57
    bgt  parse_loop
    sub  w2, w2, #48
    mov  w3, #10
    mul  w21, w21, w3
    add  w21, w21, w2
    cbz  x19, read_loop
    ldrb w2, [x20], #1
    sub  x19, x19, #1
    cmp  w2, #48
    blt  parse_loop
    cmp  w2, #57
    bgt  parse_loop
    sub  w2, w2, #48
    mul  w21, w21, w3
    add  w21, w21, w2
    cmp  w21, #100
    blt  parse_loop
    cmp  w21, #599
    bgt  parse_loop
    adrp x0, freq
    add  x0, x0, :lo12:freq
    sub  w22, w21, #100
    lsl  w22, w22, #2
    uxtw x22, w22
    ldr  w3, [x0, x22]
    add  w3, w3, #1
    str  w3, [x0, x22]
    b    parse_loop

find_max:
    adrp x0, freq
    add  x0, x0, :lo12:freq
    mov  w23, #0
    mov  w24, #0
    mov  w25, #0
scan_loop:
    cmp  w25, #500
    bge  print_result
    lsl  w26, w25, #2
    uxtw x26, w26
    ldr  w1, [x0, x26]
    cmp  w1, w23
    ble  scan_next
    mov  w23, w1
    mov  w24, w25
scan_next:
    add  w25, w25, #1
    b    scan_loop

print_result:
    mov  x0, #1
    adrp x1, msg
    add  x1, x1, :lo12:msg
    mov  x2, #msg_len
    mov  x8, #64
    svc  #0
    add  w24, w24, #100
    adrp x1, buf
    add  x1, x1, :lo12:buf
    mov  w0, w24
    mov  w3, #100
    udiv w4, w0, w3
    msub w0, w4, w3, w0
    add  w4, w4, #48
    strb w4, [x1]
    mov  w3, #10
    udiv w4, w0, w3
    msub w0, w4, w3, w0
    add  w4, w4, #48
    strb w4, [x1, #1]
    add  w0, w0, #48
    strb w0, [x1, #2]
    mov  w0, #10
    strb w0, [x1, #3]
    mov  x0, #1
    mov  x2, #4
    mov  x8, #64
    svc  #0
    mov  x0, #0
    mov  x8, #93
    svc  #0
