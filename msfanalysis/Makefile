CC := gcc -m32
NO_PROTECT := -fno-stack-protector -z execstack

all: chmod

chmod:
	$(CC) $(NO_PROTECT) -g chmod_sc.c -o chmodsc

exec: 
	$(CC) $(NO_PROTECT) -g exec_sc.c -o execsc

read:
	$(CC) $(NO_PROTECT) -g read_file_sc.c -o read_filesc
