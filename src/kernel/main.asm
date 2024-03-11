org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start: 
    jmp main
;end start

; prints string to screen
; params: DS:SI points to string
puts:
    push si
    push ax
    push bx
.loop:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0E 
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si    
    ret
;end


main:
    ;setup data segments
    mov ax, 0   ; cant write to ds/es directly
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00 ;stack decrements downward 1000 -> 998 -> 996

    mov si, test_output
    call puts

    hlt
.halt:
    jmp .halt
;end 

test_output: db 'TEST', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h