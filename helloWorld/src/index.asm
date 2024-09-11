
section .rodata
    hello db 'Hello, World!', 0xA ,0
    hello_len equ $-hello
section .text
    global _start

_start:
    ; write(1, hello, hello_len)
    MOV rax, 1
    MOV rdi, 1
    MOV rsi, hello
    MOV rdx, hello_len
    SYSCALL

    ; exit(0)
    MOV rax, 60
    XOR rdi, rdi
    SYSCALL