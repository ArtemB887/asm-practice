section .bss
    char_buffer resb 1

section .text
    global _start

print_char:
    push eax
    push ebx
    push ecx
    push edx

    mov [char_buffer], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buffer
    mov edx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

_start:
    mov ah, 30
    mov al, 15

    movzx ecx, ah
    movzx ebp, al

    mov eax, ecx
    xor edx, edx
    div ebp
    mov edi, eax

    xor esi, esi
outer_loop:
    cmp esi, ebp
    jge exit

    xor edx, edx
inner_loop:
    cmp edx, ecx
    jge end_row

    cmp esi, 0
    je draw_star

    mov eax, ebp
    dec eax
    cmp esi, eax
    je draw_star

    cmp edx, 0
    je draw_star

    mov eax, ecx
    dec eax
    cmp edx, eax
    je draw_star

    mov eax, ebp
    dec eax
    sub eax, esi
    mov ebx, esi

    cmp ebx, eax
    jle .use_y
    mov ebx, eax
.use_y:

    mov eax, ebx
    imul eax, edi

    cmp edx, eax
    je draw_star

    mov ebx, ecx
    dec ebx
    sub ebx, eax
    cmp edx, ebx
    je draw_star

    mov al, ' '
    call print_char
    jmp next_char

draw_star:
    mov al, '*'
    call print_char

next_char:
    inc edx
    jmp inner_loop

end_row:
    mov al, 10
    call print_char
    inc esi
    jmp outer_loop

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
