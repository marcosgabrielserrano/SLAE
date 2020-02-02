
char shellcode[] = ;

int main()
{
	void (*shell)() = (void(*)())shellcode;
	shell();
	return 0;
}
