org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

; 
; FAT12 header
;
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                
bdb_media_descriptor_type:  db 0F0h
bdb_sectors_per_fat:        dw 9
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                 
                            db 0              
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h  
ebr_volume_label:           db 'NANOBYTE OS'        
ebr_system_id:              db 'FAT12   '         

;
; code here
;


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