section .data

codes: db '0123456789ABCDEF'

demo1: dq 0x0123456789abcdef

demo2: db 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef

newline_char: db 0x0a

section .text
global _start

print_newline:				;改行表示関数ssize_t print_newline(void);
	mov	rax, 1			; rax = 1:write system call ID ;
	mov	rdi, 1			; rdi:system callの第一引数 = 1:書き込み先file descriptor(stdout);
	mov	rsi, newline_char	; rsi:system callの第二引数 = 書き込む文字列の先頭アドレス;
	mov	rdx, 1			; rdx:system callの第三引数 = 書き込むバイト数;
	syscall				; write system call
	ret				; return rax:書いたバイト数;

print_hex:				;16進数表示関数unsigned int print_hex(unsigned int n);
	mov	rax, rdi		; rax = n;
	mov	rdi, 1			; rdi:system callの第一引数 = 1:書き込み先file descriptor(stdout)
	mov	rdx, 1			; rdx:system callの第三引数 = 1:書き込むバイト数(1桁)
	mov	rcx, 64			; rcx = 64:nのビット数
iterate:				; 一桁ずつ表示していくループ
	push	rax			; rax:nを退避
	sub	rcx, 4			; rcx/4:表示する桁位置をデクリメント
	sar	rax, cl			; rax:n >>= cl:4*表示する桁数; 表示する桁位置を最下位4ビットに持っていく
	and	rax, 0xf		; rax &= 0xf; 表示する桁の4ビットを残す
	lea	rsi, [codes + rax]	; rsi:system callの第二引数 = (codes + rax:表示する桁の4ビット):表示する文字列のアドレス;
	mov	rax, 1			; rax = 1:write system call ID;
	push	rcx			; syscallは(rcx:4*表示する桁位置)を破壊するので退避
	syscall				; write system call
	pop	rcx			; (rcx:4*表示する桁位置)復活
	pop	rax			; rax:n復活
	test	rcx, rcx		; rcx & rcxを計算しrflagsを立てる
	jnz	iterate			; 計算結果:(rcx & rcx):rcxが0でない限りiterateへ飛ぶ
	ret				; return rax:n;

_start:					;main関数
	mov	rdi, [demo1]		; rdi:print_hexの第一引数:表示する数 = [demo1]
	call	print_hex		; rdiを16進数で表示
	call	print_newline		; 改行出力
	mov	rdi, [demo2]		; rdi:print_hexの第一引数:表示する数 = [demo2]
	call	print_hex		; rdiを16進数で表示
	call	print_newline		; 改行出力
	mov	rax, 60			; rax = 60:system call ID
	xor	rdi, rdi		; (rdi ^= rdi):(rdi:exit system callの第一引数:プログラムの返り値 = 0)
	syscall				; exit system call

