global _start

section .data
message: db 'Hello, World!', 0x0a	; 表示する文字列.0x0aは改行

section .text
_start:
	mov rax, 1			; write system callの番号
	mov rdi, 1			; 書き込み先file descriptor stdout
	mov rsi, message		; 書き込む文字列
	mov rdx, 14			; 書き込むバイト数
	syscall				; write system call
	mov rax, 60			; exit system callの番号
	mov rdi, 0			; このプログラムの返り値
	syscall				; exit system call

