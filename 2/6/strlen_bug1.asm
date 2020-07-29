global _start

section .data

test_string: db "abcdef", 0	; char *test_string = "abcdef";

section .text

strlen:				; unsigned long strlen(char *rdi)
				; {
.loop:				; .loop:
	cmp byte [rdi + r13], 0	; 	//compare rdi[r13] and '\0'
	je .end			; 	if(rdi[r13] == '\0')goto .end;
	inc r13			; 	r13++;
	jmp .loop		; 	goto .loop;
.end:				; .end:
	mov rax, r13		; 	rax = r13;
				; }

_start:				; int main(void)
				; {
	mov rdi, test_string	; 	rdi = test_string:"abcdef";
	call strlen		; 	rax = strlen(rdi:test_string:"abcdef"):6;
	mov rdi, rax		; 	rdi = rax:strlen(test_string:"abcdef"):6;
	mov rax, 60		; 	rax = 60:exit system call ID;
	syscall			; 	return rdi:strlen(test_string:"abcdef"):6;
				; }

