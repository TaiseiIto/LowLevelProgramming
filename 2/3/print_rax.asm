; raxレジスタの内容を16進数で表示するプログラム
section .data

codes:
	db '0123456789ABCDEF'		; 

newline:
	db 0x0a				; 

section .text

global _start

_start:
	mov rax, 0x0123456789abcdef
	mov rdi, 1
	mov rdx, 1
	mov rcx, 64
.loop:
	push rax
	sub rcx, 4
	sar rax, cl
	and rax, 0x000000000000000f
	lea rsi, [codes + rax]
	mov rax, 1
	push rcx
	syscall
	pop rcx
	pop rax
	test rcx, rcx
	jnz .loop
	mov rax, 1
	lea rsi, [newline]
	syscall
	mov rax, 60
	xor rdi, rdi
	syscall
