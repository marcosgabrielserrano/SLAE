#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define KEY_SZ 16

unsigned char shellcode[] = "\xAB\xCD";

unsigned char key[] = "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA";

void *pad(void *shellcode, unsigned int len, unsigned int *result_sz)
{
	int fd;
	uint32_t shellcode_len = len;
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
	unsigned char *encrypted_text = xor(padded_plaintext, key, size);

	free(padded_plaintext);
	
	for(i = 0; i < size; i++)
	{
		printf("\\x%02x", encrypted_text[i]);
	}
	printf("\n");
	free(encrypted_text);
}

int main()
{
	encryptor();
	return 0;
}
