section .data
    INPUT_N equ 8
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

FACT:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    cmp eax, 1
    jle .base_case
    
    push eax
    dec dword [esp]
    call FACT
    
    mov ecx, [ebp + 8]
    imul ecx
    
    jmp .exit_fact
    
.base_case:
    mov eax, 1
    
.exit_fact:
    mov esp, ebp
    pop ebp
    ret 4

_start:
    mov ecx, msg_input
    call print_string
    
    mov eax, INPUT_N
    call int2str_eax
    
    push dword INPUT_N
    call FACT
    
    mov ecx, msg_result
    call print_string
    
    call int2str_eax
    
    mov eax, 1
    xor ebx, ebx
    int 0x80
