#!/usr/bin/env python

"""
Program will move every other byte
to end of shellcode
"""

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x6c\x73\x68"
			 "\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2"
			 "\x53\x89\xe1\xb0\x0b\xcd\x80")

size = len(shellcode)

half_1_shellcode = bytearray("")
half_2_shellcode = bytearray("")

for x in range(0, size):
	if x % 2 == 0:
		half_1_shellcode += bytes(shellcode[x])
	else:
		half_2_shellcode += bytes(shellcode[x])

encoded_shellcode = half_1_shellcode + half_2_shellcode
encoded_str = "\""

for x in encoded_shellcode:
	encoded_str += "\\x%02x" % x

encoded_str += "\""

print "Length: %d" % len(encoded_shellcode)
print encoded_str
