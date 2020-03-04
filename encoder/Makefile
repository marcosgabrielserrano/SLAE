NASM := nasm -f elf32
LINKER := ld -melf_i386
SHELL_IN := src/encode.nasm
SHELL_OBJ := bin/encode.o
SHELL_OUT := bin/shell
C_SHELL_SRC := src/shellcode.c
CC := gcc -fno-stack-protector -z execstack -m32
ENCODER_OUT := bin/encodedshell

all: build_shell strip_shell build_exe

build_shell:
	$(NASM) $(SHELL_IN) -o $(SHELL_OBJ)
	$(LINKER) $(SHELL_OBJ) -o $(SHELL_OUT)

strip_shell:
	./compile.sh STRIP $(SHELL_OUT) $(C_SHELL_SRC)

build_exe:
	$(CC) -o $(ENCODER_OUT) $(C_SHELL_SRC)

clean:
	rm bin/*

.PHONY: all
