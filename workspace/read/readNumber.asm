.model small
.stack
.data
    msgEntry db 10,13,"Number between [-32768,32767]: ","$"
    flgSign db 0
    accumulator dw 0    
.code
    printmsg proc
        mov ax, @data
        mov ds,ax
        mov dx, offset msgEntry
        mov ah, 09h
        int 21h
    printmsg endp
    clear proc
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov accumulator, 0000h
        mov flgsign, 00h
        ret
    clear endp
    getEntry proc
        mov ah,01h
        int 21h
        ret
    getEntry endp
    
    readSign proc
        call clear
        call getEntry
        cmp al,'-'
         jne positive
        negative:
         mov flgsign, 01h
         mov cx, 0005h
         jmp endRS
        positive:
         mov ah,00h
         sub al,30h
         mov accumulator, ax
         mov cx, 0004h
        endRS:
         ret
    readSign endp
    

    readNumbers proc
        startRN:
         xor ax,ax
         xor bx,bx
         xor dx,dx
         call getEntry
         cmp al, 0ah
          je endRN
         cmp al, 0dh
          je endRN
         sub al, 30h
         mov ch,al
         mov ax,000ah
         mov bx, accumulator
         mul bx
         mov dh,00h
         mov dl,ch
         add ax,dx
         mov ch,00h
         mov accumulator, ax
        loop startRN
        endRN:
         ret
    readNumbers endp
    NumbertoNumberWithSign proc
        mov ax, accumulator
        cmp flgsign,01
         jne complete
        not ax
        add ax, 01h
        complete:
        ret
    NumbertoNumberWithSign endp
    mainRead proc
        call printmsg
        call readSign
        call readNumbers
        call NumbertoNumberWithSign
    mainRead endp

.exit
end mainRead    