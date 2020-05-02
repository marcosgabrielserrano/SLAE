NASM := nasm -f elf32
LINK := ld -melf_i386

all: original poly clean

original:
	$(NASM) flush_iptables.nasm -o flush_iptables.o
	$(LINK) flush_iptables.o -o flush_iptables

poly:
	$(NASM) poly-flush_iptables.nasm -o poly-flush_iptables.o
	$(LINK) poly-flush_iptables.o -o poly-flush_iptables

clean:
	rm -f *.o
