; second shellcode to test egghunter success

global _start

section .text

	EGG db "AAAAAAAA"

_start:
	xor eax, eax
	xor ebx, ebx
	xor edx, edx

	mov al, 0x4 ; eax ready
	mov bl, 0x1 ; ebx ready
	mov dl, 0x8 ; edx ready
	
	jmp short success_msg

print_msg:
	pop ecx

	mov dword edi, [ecx+4]
	push edi
	mov dword edi, [ecx]
	push edi

	mov ecx, esp ; ecx ready

	int 0x80 ; print

	xor eax, eax
	xor ebx, ebx

	mov al, 0x1
	
	int 0x80 ; exit
	
success_msg:
	call print_msg
	success db "success", 0x0a
