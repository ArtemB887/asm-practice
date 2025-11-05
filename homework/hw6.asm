section .data
    arr db 5, 3, 8, 1, 2
    sorted db 5 dup(0)
    n equ 5

section .text
    global _start

sort_array:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rdx, rcx
.copy_loop:
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rdx
    jnz .copy_loop

    sub rsi, rcx
    sub rdi, rcx

.outer_loop:
    mov rdx, rcx
    dec rdx
    jz .done
.inner_loop:
    mov al, [rdi + rdx - 1]
    mov bl, [rdi + rdx]
    cmp al, bl
    jbe .no_swap
    mov [rdi + rdx - 1], bl
    mov [rdi + rdx], al
.no_swap:
    dec rdx
    jnz .inner_loop
    dec rcx
    jmp .outer_loop

.done:
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

_start:
    lea rsi, [rel arr]
    lea rdi, [rel sorted]
    mov rcx, n
    mov rbx, 1
    call sort_array
    mov rax, 60
    xor rdi, rdi
    syscall
