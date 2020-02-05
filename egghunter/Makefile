NASM := nasm -f elf32
SHELL_IN := src/egghunter.nasm
SHELL_OBJ := bin/eggshell_obj
SHELL_OUT := bin/eggshell
BIND_EXE := bin/egghunter
BIND_IN := src/shellcode.c
LINKER := ld -melf_i386
CC := gcc -fno-stack-protector -z execstack -m32

all: build_shell

build_shell:
	$(NASM) $(SHELL_IN) -o $(SHELL_OBJ)
	$(LINKER) $(SHELL_OBJ) -o $(SHELL_OUT)

clean:
	rm -f $(SHELL_OBJ) $(SHELL_OUT)
