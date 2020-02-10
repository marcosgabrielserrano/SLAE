#!/bin/bash



if [ -z "$1" ] || [ -z "$2" ]; then
	echo "usage: $0 [shellcode.nasm] [shellcode.c]"
	exit 1
fi

if [ "$1" == "STRIP" ]; then # just for Makefile
	SHELLCODE=`./genshl $2`
	sed -i "s/char shellcode\[\] *= *.*\;/char shellcode\[\] = ${SHELLCODE//'\'/'\\'}\;/g" $3
	exit 0
fi

if [ "$1" == "STRIP2" ]; then # just for Makefile
    SHELLCODE=`./genshl $2`
    sed -i "s/char shellcode2\[\] *= *.*\;/char shellcode2\[\] = ${SHELLCODE//'\'/'\\'}\;/g" $3
    exit 0
fi

clean() {
	rm build.o
	rm shell
}

nasm -f elf32 $1 -o build.o
ld -m elf_i386 -o shell build.o

SHELLCODE=`./genshl shell`
if [ ! -z "$( ./genshl shell | grep "\x00" )" ]; then
	echo "SHELLCODE HAS BAD CHARS!"
	exit 1
fi

echo -e ${SHELLCODE//\"} > RAWSHELL

sed -i "s/char shellcode\[\] *= *.*\;/char shellcode\[\] = ${SHELLCODE//'\'/'\\'}\;/g" $2

if [ ! -z "$3" ]; then
	DEBUG="-g"
fi

gcc ${DEBUG} -m32 -fno-stack-protector -z execstack $2

if [ -z "${DEBUG}" ]; then
	clean
fi
