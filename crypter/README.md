
Basic usage:

1. Open src/shellcode.c and replace shellcode variable contents with your own shellcode.

2. `make`

3. `bin/crypter encrypt`

4. Open src/shellcode.c and replace encrypted_shellcode variable contents with output of previous command

5. `make`

6. `bin/crypter -r decrypt`  will decrypt and run your shellcode, remove -r if you don't want to run

NOTE: 16 BYTE key_buf is the key, and can be replaced with any you choose as long as it is 16 bytes
