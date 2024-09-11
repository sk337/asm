section .data
    hello db 'Hello, World! Current working dir: %s', 0xA ,0
    cwd_error db 'Error: Could not get cwd', 0xA, 0

section .bss
    cwd_buffer resb 256
    pid resq 1

section .text
    global _start

extern printf, exit, getcwd, perror

_start:

    ; getcwd(cwd_buffer, 256)
    MOV rdi, cwd_buffer
    MOV rsi, 256
    CALL getcwd
    
    ; if (getcwd(cwd_buffer, 256) == NULL) {
    ;   perror("Error: Could nt get cwd");
    ;   exit(1);
    ; }

    CMP rax, 0
    JE handle_error

    
    ; printf("Hello, World! Current working dir: %s\n", cwd_buffer)
    MOV rdi, hello
    MOV rsi, rax
    CALL printf

    ; exit(0)
    MOV rax, 0
    CALL exit

handle_error:
    ; perror("Error: Could not get cwd\n");
    MOV rdi, cwd_error
    CALL perror

    ; exit(1);
    MOV rax, 1
    CALL exit