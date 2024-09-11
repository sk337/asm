section .rodata
    as db '[as]', 0
    as_len equ $-as

section .text
    global _start

_start:
    ; write(1, as, as_len)
    MOV rax, 1
    MOV rdi, 1
    MOV rsi, as
    MOV rdx, as_len
    SYSCALL

    ; loop forever
    JMP _start