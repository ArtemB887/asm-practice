section .data
    ; тут можна залишити порожньо або додати повідомлення
section .bss
    buffer  resb 20        ; буфер для рядка

section .text
    global _start

; EAX - число, яке конвертуємо
; ESI - адреса буфера
int2str:
    push eax
    mov ecx, 0

.next_digit:
    xor edx, edx
    mov ebx, 10
    div ebx                 ; ділимо EAX на 10, залишок у EDX
    add dl, '0'             ; цифру перетворюємо в ASCII
    push dx                 ; зберігаємо цифру у стек
    inc ecx
    test eax, eax
    jnz .next_digit

.write_digits:
    pop dx
    mov [esi], dl
    inc esi
    loop .write_digits

    mov byte [esi], 0       ; закінчуємо рядок нуль-байтом
    pop eax
    ret

; -----------------------
_start:
    mov eax, 1234567
    mov esi, buffer
    call int2str

    ; sys_write для перевірки
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 20
    int 0x80

    ; завершення програми
    mov eax, 1
    xor ebx, ebx
    int 0x80
