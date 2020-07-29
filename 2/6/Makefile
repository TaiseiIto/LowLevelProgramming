all: strlen

strlen: strlen.o
	ld $^ -o $@

strlen.o: strlen.asm
	nasm $^ -f elf64 -o $@

