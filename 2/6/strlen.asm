global _start

section .data

test_string: db "abcdef", 0

section .text

strlen:	; unsigned long strlen(char *rdi);
	xor rax, rax	; (rax ^= rax):(rax = 0);
.loop:
	cmp byte [rdi+rax], 0	; compare rdi[rax] and '\0'
	je .end	; if(rdi[rax] == '\0')goto .end;
	inc rax	; rax++;
	jmp .loop	; goto .loop;
.end:
	ret	; return rax;

_start:	; long main(void);
	mov rdi, test_string	; rdi = test_string:"abcdef";
	call strlen	; rax = strlen(rdi:test_string:"abcdef");
	mov rdi, rax	; rdi = rax:strlen(test_string:"abcdef"):6;
	mov rax, 60	; rax = 60:exit systemcall ID;
	syscall	; return rdi:strlen(test_string:"abcdef"):6;
