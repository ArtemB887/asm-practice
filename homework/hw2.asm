section .data
section .bss
    buffer  resb 20

section .text
    global _start

int2str:
    push eax
    mov ecx, 0

.next_digit:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz .next_digit

.write_digits:
    pop dx
    mov [esi], dl
    inc esi
    loop .write_digits

    mov byte [esi], 0
    pop eax
    ret

_start:
    mov eax, 1234567
    mov esi, buffer
    call int2str

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 20
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
