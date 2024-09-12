section .rodata
    as db '[as]', 0
    as_len equ $-as

section .text
    global _start

_start:
    MOV rax, 1
    MOV rdi, 1
    MOV rsi, as
    MOV rdx, as_len
    SYSCALL

    JMP _start
