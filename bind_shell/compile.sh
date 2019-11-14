#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "usage: $0 [shellcode.nasm] [shellcode.c]"
	exit 1
fi

nasm -f elf32 $1 -o build.o
ld -m elf_i386 -o shell build.o

SHELLCODE=`genshl shell`

rm build.o
rm shell


sed -i "s/char shellcode\[\] *= *.*\;/char shellcode\[\] = ${SHELLCODE//'\'/'\\'}\;/g" shellcode.c

gcc -m32 -fno-stack-protector -z execstack $2

./a.out

rm a.out
