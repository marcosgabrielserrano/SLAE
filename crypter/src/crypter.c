#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define KEY_SZ 16

unsigned char shellcode[] = "\xAB\xCD";
unsigned char encrypted_shellcode[] = "\xa8\xaa\x01\x67\xf9\xb4\xbd\xb2\x2d\x73\xa2\x13\x14\x35\x53\xb1";

unsigned char key_buf[] = "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA";

void *pad(void *shellcode, unsigned int len, unsigned int *result_sz)
{
	int fd;
	uint16_t shellcode_len = len;
	unsigned int pad_sz = KEY_SZ - ((sizeof(shellcode_len) + len) % KEY_SZ);
	*result_sz = sizeof(shellcode_len) + len + pad_sz;
	void *result = calloc(1, *result_sz);

	memcpy(result, &shellcode_len, sizeof(shellcode_len));
	memcpy(result + sizeof(shellcode_len), shellcode, len);

	fd = open("/dev/urandom", O_RDONLY);
	read(fd, result + sizeof(shellcode_len) + shellcode_len, pad_sz);

	return result;
}

void *xor(unsigned char *plaintext, unsigned char *key, unsigned int len)
{
	int i;
	unsigned char *result = calloc(1, len);

	for(i = 0; i < len; i++)
	{
		result[i] = plaintext[i] ^ key[i % KEY_SZ];
	}

	return result;
}

void encryptor()
{
	int i;
	unsigned int size = 0;
	unsigned char *padded_plaintext = pad((void *)shellcode, sizeof(shellcode) - 1, &size);
	unsigned char *encrypted_text = xor(padded_plaintext, key_buf, size);

	free(padded_plaintext);
	
	for(i = 0; i < size; i++)
	{
		printf("\\x%02x", encrypted_text[i]);
	}
	printf("\n");
	free(encrypted_text);
}

void decryptor(int run)
{
	int i;
	uint16_t len;
	unsigned char *decrypted_shellcode;
	unsigned char *len_buf = xor(encrypted_shellcode, key_buf, sizeof(uint16_t));
	
	memcpy(&len, len_buf, sizeof(len));
	free(len_buf);

	decrypted_shellcode = xor(encrypted_shellcode + sizeof(uint16_t), key_buf, len);

	for(i = 0; i < len; i++)
	{
		printf("\\x%02x", decrypted_shellcode[i]);
	}
	printf("\n");

	if(run)
	{
		void (*sc)() = (void(*)())decrypted_shellcode;
		sc();
	}
	free(decrypted_shellcode);
}

int main(int argc, char *argv[])
{
	char opt = 0;
	int run = 0;

	while((opt = getopt(argc, argv, "r")) != -1)
	{
		switch(opt)
		{
			case 'r':
				run = 1;
				break;
			default:
				printf("Invalid option\n");
				break;
		}
	}

	if(!argv[optind])
	{
		printf("Missing argument!\n");
		_exit(1);
	}

	if(strcmp(argv[optind], "encrypt") == 0)
	{
		encryptor();
		_exit(0);
	}
	if(strcmp(argv[optind], "decrypt") == 0)
	{
		decryptor(run);
		_exit(0);
	}

	printf("Invalid argument\n");
	return 1;
}
