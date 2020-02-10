NASM := nasm -f elf32
SHELL_IN := src/egghunter.nasm
SHELL_OBJ := bin/eggshell_obj
SHELL_OUT := bin/eggshell
EGG_EXE := bin/egghunter
EGG_IN := src/shellcode.c
LINKER := ld -melf_i386
TEST_IN := src/print.nasm
TEST_OBJ := bin/print.o
TEST_OUT := bin/print
CC := gcc -fno-stack-protector -z execstack -m32

all: build_shell build_test build_exe

build_shell:
	$(NASM) $(SHELL_IN) -o $(SHELL_OBJ)
	$(LINKER) $(SHELL_OBJ) -o $(SHELL_OUT)

build_test:
	$(NASM) $(TEST_IN) -o $(TEST_OBJ)
	$(LINKER) $(TEST_OBJ) -o $(TEST_OUT)

strip_shellcode:
	./compile.sh STRIP $(SHELL_OUT) $(EGG_IN)
	./compile.sh STRIP2 $(TEST_OUT) $(EGG_IN)

compile_only:
	$(CC) -o $(EGG_EXE) $(EGG_IN)

build_exe: strip_shellcode compile_only

clean:
	rm -f $(SHELL_OBJ) $(SHELL_OUT)
