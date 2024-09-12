
extern exit
section .rodata
    msg db 'Please Type (Hi): ', 0
    msg_len equ $ - msg
    success db 'Thanks :)', 0
    success_len equ $ - success
    fail db 'Hey that is mean >:(', 0
    fail_len equ $ - fail
    correct_input db 'Hi'
    correct_input_len equ $ - correct_input
    newLine db 0x0A

section .bss
    byte_in resb 256  ; reserve 256 bytes to hold input (large enough buffer)

section .text
    global _start

_start:
    ; Print prompt message
    mov rax, msg
    mov rdi, msg_len
    call print

    ; Read user input until newline
    mov rsi, byte_in
    call readLine

    ; Compare only the first two characters of input to "Hi"
    mov rsi, byte_in
    mov rdi, correct_input
    call compareInput

    cmp rax, 0  ; if rax == 0, inputs match
    je succfn    ; jump to success function if correct

    jmp failfn   ; otherwise, jump to fail function

succfn:
    ; Print success message
    mov rax, success
    mov rdi, success_len
    call print

    ; Print newline
    mov rax, newLine
    mov rdi, 1
    call print

    call exit

failfn:
    ; Print fail message
    mov rax, fail
    mov rdi, fail_len
    call print

    ; Print newline
    mov rax, newLine
    mov rdi, 1
    call print

    call exit

print:
    ; Print a string to stdout
    mov rsi, rax
    mov rdx, rdi
    mov rdi, 1
    mov rax, 1
    syscall
    retn

readLine:
    ; Read input from stdin until newline or max buffer size
    mov rbx, 0            ; index for the buffer
.read_char:
    mov rax, 0            ; syscall number for sys_read
    mov rdi, 0            ; stdin file descriptor
    lea rsi, [byte_in + rbx] ; load buffer at index
    mov rdx, 1            ; read 1 byte at a time
    syscall

    cmp byte [byte_in + rbx], 0x0A  ; check if the character is newline (\n)
    je .done_reading        ; if newline, stop reading

    inc rbx                 ; move to the next index in buffer
    cmp rbx, 255            ; make sure not to exceed buffer size
    jl .read_char           ; continue reading if within bounds

.done_reading:
    mov byte [byte_in + rbx], 0  ; null-terminate the string
    retn

compareInput:
    ; Compare only the first two characters in rsi with the correct input in rdi
    mov al, [rsi]      ; load first byte from input
    mov bl, [rdi]      ; load first byte from correct input
    cmp al, bl         ; compare first byte
    jne not_equal      ; if not equal, return

    mov al, [rsi + 1]  ; load second byte from input
    mov bl, [rdi + 1]  ; load second byte from correct input
    cmp al, bl         ; compare second byte
    jne not_equal      ; if not equal, return

    xor rax, rax       ; if both bytes match, set rax to 0 (success)
    retn

not_equal:
    mov rax, 1         ; if not equal, set rax to 1 (failure)
    retn
