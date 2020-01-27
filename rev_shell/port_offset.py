import sys
import struct

# prints out offset of first match of some bytes

def string_to_byte(string):
	b_port = struct.pack(">H", int(string))
	print(''.join( [ "%02X" % ord( x ) for x in b_port ] ).strip())
	return b_port

def main(argv):

	f = open(argv[1], "rb")

	while True:
		buf = f.read(1024)
		if not buf:
			break
		b_port = string_to_byte(argv[2])
		if b_port in buf:
			print("found at {}".format(buf.find(b_port)))

	return

if __name__ == '__main__':
	main(sys.argv)

