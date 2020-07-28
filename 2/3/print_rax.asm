; raxレジスタの内容を16進数で表示するプログラム
section .data
codes:
	db '0123456789ABCDEF'		; 16進数の表示に使う文字たち
newline:
	db 0x0a				; 最後に表示する改行文字

section .text
global _start
_start:
	mov	rax, 0x0123456789abcdef
	mov	rdi, 1			; write system callの出力先file descriptor (stdout)
	mov	rdx, 1			; write system callの出力文字数(1桁ずつ出力する)
	mov	rcx, 64			; raxレジスタのrcxビット目からrcx + 3ビット目までの桁を表示する
.loop:
	push	rax			; 表示内容を待避
	sub	rcx, 4			; ひとつ下の桁を表示するためにrcxから4引く
	sar	rax, cl			; rax >>= cl;
	and	rax, 0x000000000000000f	; rax &= 0x000000000000000f;
	lea	rsi, [codes + rax]	; write system callの出力する文字列の先頭アドレスrsi = codes + rax;
	mov	rax, 1			; write system call
	push	rcx			; rcxがwrite system callで書き換わるので待避
	syscall				; write
	pop	rcx			; rcx復活
	pop	rax			; 表示内容復活
	test	rcx, rcx		; rcx & rcxを計算してフラグを立てる
	jnz	.loop			; rcx & rcxが0でない(rcx != 0)限り.loopに飛ぶ
	mov	rax, 1			; 最後に改行文字を出力
	lea	rsi, [newline]
	syscall
	mov	rax, 60			; exit system call
	xor	rdi, rdi		; このプログラムの返り値rdi ^= rdi (rdi = 0);
	syscall				; exit
