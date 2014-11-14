; Christo OS Version 0.0.4
; (C) 2014, Christo Keller


; BOF SEGMENT ;
BITS 16


; CODE SEGMENT ;
start:
	mov ax, 07C0h     ; 4k stack space AFTER bootloader
	add ax, 544       ; ((4096+512)/16) bytes per paragraph
	cli               ; Pause interrupts
	mov ss, ax        ; Move AX into SS
	mov sp, 4096      ; Move 4096 into SP
	sti               ; Restore interrupts

	mov ax, 07C0h     ; Set data segment to where the bootloader is to be loaded
	mov ds, ax	      ; Move AX into DS
; Move AX into DS

	;--;

mov si, os
call pout

mov si, new
call pout

mov si, line
call pout

mov si, new
call pout
	
mov si, prompt
call pout

mov si, new
call pout

mov si, prompt2
call pout

mov si, new
call pout

call menu

	;--;

jmp $                 ; Infinite loop. Wait, what? NOOOOOO!


; ROUTINE SEGMENT ;
pout:
	mov ah, 0Eh       ; Set 10h to "print character"
	.do_pout:
		lodsb         ; Get character from register SI
		cmp al, 0     ; Compare register AL (string from lodsb) and 0
		je .end_pout  ; If AL equals 0, goto end_pout
		int 10h       ; If AL does not equal 0, print out the current character
		jmp .do_pout  ; Loop back to .do_pout
	.end_pout:
		ret           ; ASM "return"  

menu:
	.do_menu:
		mov si, new
		call pout

		mov si, inp
		call pout

		mov ah, 00h
		int 16h

		cmp al, 99
		je .chinese

		cmp al, 115
		je .shutdown

		mov si, ques
		call pout

		mov si, new
		call pout

		mov si, error
		call pout

		jmp .do_menu

	.chinese:
		mov si, char_c
		call pout 

		mov si, new
		call pout

		mov si, chinese
		call pout

		jmp .do_menu

	.shutdown:
		mov si, char_s
		call pout

		mov si, new
		call pout

		mov si, tbc
		call pout

		jmp .do_menu

		

; DATA SEGMENT ;
os db 'Christo OS Alpha 0.0.4',0
new db `\n\r`,0
line db '----------------------',0
prompt db 'To shutdown the system, press [s].',0
prompt2 db 'To view Chinese writing, press [c].',0
chinese db '>> huan ying lei dao gong chan dang',0
char_c db 'c',0
error db '>> command not recognized; please try again.',0
inp db '<< ',0
ques db '?',0
char_s db 's',0
tbc db '<< to be completed... use a hard shutdown for now.'

; EOF SEGMENT ;
times 510-($-$$) db 0 ; Pad the rest of the boot sector with "0"
dw 0xAA55             ; Standard PC boot signature