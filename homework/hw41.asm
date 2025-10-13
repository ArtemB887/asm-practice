section .data
    INPUT_N equ 12
    msg_input db "Input N: ", 0
    msg_result db 0xA, "Factorial (DX:AX): ", 0
    
section .bss
    buffer resb 20

section .text
    global _start

int2str_eax:
    push eax
    push ecx
    push edx
    push ebx
    push esi
    
    mov esi, buffer + 19
    mov byte [esi], 0
    dec esi
    mov byte [esi], 0xA
    dec esi
    
    mov ecx, 0
    mov ebx, 10
    
.next_digit:
    xor edx, edx
    div ebx
    
    add dl, '0'
    mov [esi], dl
    dec esi
    inc ecx
    
    test eax, eax
    jnz .next_digit
    
    inc esi
    
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    add edx, 2
    mov ecx, esi
    int 0x80
    
    pop esi
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret

print_string:
    push eax
    push ebx
    push ecx
    push edx
    
    mov edx, 0
    mov ebx, ecx
.find_len:
    cmp byte [ebx], 0
    je .done_len
    inc edx
    inc ebx
    jmp .find_len
.done_len:
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

_start:
    mov ecx, msg_input
    call print_string
    
    mov eax, INPUT_N
    call int2str_eax
    
    mov ecx, INPUT_N
    mov eax, 1
    
.factorial_loop:
    cmp ecx, 1
    jle .end_factorial_loop
    
    imul ecx
    
    dec ecx
    jmp .factorial_loop

.end_factorial_loop:
    
    mov ecx, msg_result
    call print_string
    
    push ecx
    mov ecx, eax
    mov eax, ecx
    pop ecx
    
    call int2str_eax
    
    mov eax, 1
    xor ebx, ebx
    int 0x80
