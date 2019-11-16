
NASM := nasm -f elf32
SHELL_IN := src/bind_shell.nasm
SHELL_OBJ := bin/shell_obj
SHELL_OUT := bin/shell
BIND_EXE := bin/bindshell
BIND_IN := src/shellcode.c
LINKER := ld -melf_i386
CC := gcc -fno-stack-protector -z execstack -m32

all: build_shell build_exe

build_obj:
	$(NASM) -o $(SHELL_OBJ) $(SHELL_IN)

build_shell: build_obj
	$(LINKER) -o $(SHELL_OUT) $(SHELL_OBJ)

strip_shellcode:
	./compile.sh STRIP $(SHELL_OUT) $(BIND_IN)

compile_only:
	$(CC) -o $(BIND_EXE) $(BIND_IN)

build_exe: strip_shellcode compile_only

.PHONY: all

