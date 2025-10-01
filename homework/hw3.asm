section .data
    prime_msg db " is prime", 0xa
    prime_len equ $ - prime_msg

    notprime_msg db " is not prime", 0xa
    notprime_len equ $ - notprime_msg

    MAX_DIGITS equ 5

section .bss
    num_str resb MAX_DIGITS + 1

section .text
    global _start

_start:
    mov ebx, 17
    mov eax, ebx

    mov ecx, num_str + MAX_DIGITS
    mov byte [ecx], 0xA

    mov esi, eax
    mov ebx, 10

.convert_loop:
    xor edx, edx
    mov eax, esi
    div ebx
    mov esi, eax

    add dl, '0'
    dec ecx
    mov [ecx], dl

    cmp esi, 0
    jnz .convert_loop

    inc ecx
    mov eax, 4
    mov ebx, 1
    mov edx, num_str + MAX_DIGITS + 1
    sub edx, ecx
    int 0x80

    mov ebx, 17
    mov eax, ebx

    cmp eax, 1
    jle .notprime

    cmp eax, 2
    je .prime

    test al, 1
    jz .notprime

    mov ecx, 3

.loop_check:
    mov edx, ecx
    imul edx, ecx
    cmp edx, ebx
    jg .prime

    mov edx, 0
    mov eax, ebx
    div ecx

    cmp edx, 0
    je .notprime

    add ecx, 2
    jmp .loop_check

.prime:
    mov eax, 4
    mov ebx, 1
    mov ecx, prime_msg
    mov edx, prime_len
    int 0x80
    jmp .exit

.notprime:
    mov eax, 4
    mov ebx, 1
    mov ecx, notprime_msg
    mov edx, notprime_len
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80