NASM := nasm -f elf32
LINK := ld -melf_i386

all: original poly clean

original:
	$(NASM) kill.nasm -o kill.o
	$(LINK) kill.o -o kill

poly:
	$(NASM) poly-kill.nasm -o poly-kill.o
	$(LINK) poly-kill.o -o poly-kill

clean:
	rm -f *.o
