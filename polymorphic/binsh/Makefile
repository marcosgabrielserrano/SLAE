NASM := nasm -f elf32
LINK := ld -melf_i386

all: original poly clean

original:
	$(NASM) binsh.nasm -o binsh.o
	$(LINK) binsh.o -o binsh

poly:
	$(NASM) poly-binsh.nasm -o poly-binsh.o
	$(LINK) poly-binsh.o -o poly-binsh

clean:
	rm -f *.o
