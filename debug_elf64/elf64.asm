BITS 64
            org     0x3fc000
ehdr:                                               ; Elf32_Ehdr
            db      0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
    times 8 db      0
            dw      2                               ;   e_type
            dw      3eh                               ;   e_machine
            dd      1                               ;   e_version
            dq      _start                          ;   e_entry
            dq      phdr - $$                       ;   e_phoff
            dq      0                               ;   e_shoff
            dd      0                               ;   e_flags
            dw      ehdrsize                        ;   e_ehsize
            dw      phdrsize                        ;   e_phentsize
            dw      1                               ;   e_phnum
            dw      0                               ;   e_shentsize
            dw      0                               ;   e_shnum
            dw      0                               ;   e_shstrndx
ehdrsize    equ     $ - ehdr

phdr:                                               ; Elf32_Phdr
            dd      1                               ;   p_type
            dd      7                               ;   p_flags
            dq      0                               ;   p_offset
            dq      $$                              ;   p_vaddr
            dq      $$                              ;   p_paddr
            dq      filesize                        ;   p_filesz
            dq      0x400000                        ;   p_memsz
            dq      0x1000                          ;   p_align
phdrsize    equ     $ - phdr

mymemcpy:
    push rdx
    push rsi
    push rdi
loop:
    mov al,[rsi]
    mov [rdi],al
    add rdi,1
    add rsi,1
    sub rdx,1
    test rdx,rdx
    jne loop
    pop rdi
    pop rsi
    pop rdx
    retn

printal:
    cmp al,0x9
    ja go_ch
    add al,0x30
    jmp go_print
go_ch:
    add al,0x57
go_print:
    mov [r13],al

    mov rax,1 
    mov rdi,1 
    mov rsi,r13  
    mov rdx,1
    syscall 
    retn

_start:   
    mov r12,0x400000    ;md5 result
    mov r13,r12
    add r13,050h
    mov rax,2 
    mov rdi,filepath    ;__NR_open -- /usr/include/asm/unistd_64.h
    mov rsi,0  
    mov rdx,0
    syscall 
    push rax

    mov rax,0   ;__NR_read -- /usr/include/asm/unistd_64.h
    pop rdi    
    mov rsi,r12  
    mov rdx,0xB000
    syscall 

    ;-----fix
    mov ax,0x07eb
    mov [0x403719],ax
    mov ax,0x09eb
    mov [0x403752],ax
    mov eax,mymemcpy
    mov [0x609130],eax

    ;-----calc md5
    mov rdx,rsi
    mov rsi,filesize
    mov edi,0x3fc000
    call 0x403700 

    ;-----print md5
    mov bl,16
go_print_md5_loop:
    mov al,[r12]
    shr al,4
    call printal
    mov al,[r12]
    and al,0x0f
    call printal
    sub bl,1
    add r12,1
    test bl,bl
    jnz go_print_md5_loop
    
    ;-----exit
    mov rax,60
    mov rdi,0
    syscall

;filepath db "/usr/bin/md5sum"
filepath db "/home/ztj96/Documents/md5sum"
filesize    equ     $ - $$