bits 16
org 0x7c00

boot:
    jmp main ; jumps over utility functions

print:
    mov ah,0x0e

    .print_loop:
        lodsb
        or al,al
        jz .return
        int 0x10
        jmp .print_loop

    .return:
        ret

main: ; Actual start of program
background_color:
    mov ah,0x0b
    mov bh,0x00
    mov bl,0x01
    int 0x10

write_title:
    ; Write the title, version tagline, and kick off bootstrapping
    mov si, ascii_title_0
    call print

    mov si, ascii_tagline
    call print

    mov si, ascii_newline
    call print

    mov si, ascii_newline
    call print

    mov si, bootloading_str
    call print

    jmp halt

halt:
    cli
    hlt ; halt and catch fire

; string null terminators missing so it is condensed down into multiple lines
ascii_title_0: db "_________                       ________    _________ ",13,10
ascii_title_1: db "\_   ___ \  ____  ______ _____  \_____  \  /   _____/ ",13,10
ascii_title_2: db "/    \  \/ /  _ \/  ___//     \  /   |   \ \_____  \  ",13,10
ascii_title_3: db "\     \___(  <_> )___ \|  Y Y  \/    |    \/        \ ",13,10
ascii_title_4: db " \______  /\____/____  >__|_|  /\_______  /_______  / ",13,10
ascii_title_5: db "        \/           \/      \/         \/        \/  ",13,10,0
ascii_tagline: db "Version: 0.0.1 (Saturn)",0
ascii_newline: db 13,10,0
bootloading_str: db "Going deep into the gopher hole...",0

times 510 - ($-$$) db 0
dw 0xaa55
