SRC := src/crypter.c
CC := gcc -fno-stack-protector -z execstack -m32
ENCODER_OUT := bin/crypter

build_crypter:
	$(CC) -g $(SRC) -o $(ENCODER_OUT)

clean:
	rm bin/*

.PHONY: all
