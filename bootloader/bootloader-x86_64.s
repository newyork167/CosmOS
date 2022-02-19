bits 16
org 0x7c00

boot:
    mov si,hello
    mov ah,0x0e

color:
    mov ah,0x0b
    mov bh,0x00
    mov bl,0x01
    int 0x10

scroll_up:
    mov ah,0x06
    mov al,0x00
    int 0x10

    mov bx,0x10 ; 0x10 loops
.write_pixel:
    mov ah,0x0c
    mov al,0x05
    mov cx,bx
    mov dx,bx
    dec bx
    int 0x10
    or bx,bx
    jnz .write_pixel

write_char:
    mov ah,0x0a
    mov al,0x40
    mov cx,0x20
    int 0x10

load_hello:
    mov si,hello
    mov ah,0x0e

.loop:
    lodsb
    or al,al
    jz halt
    int 0x10
    jmp .loop

halt:
    cli
    hlt

hello: db "Hello x86_64!",0

times 510 - ($-$$) db 0
dw 0xaa55
