BITS 16

start:
	mov ax, 07C0h   ; 4k stack space after bootloader

	add ax, 288   ; (4096 + 512) / 16 bytes per paragraph

	mov ss, ax

	mov sp, 4096

	;--;

	mov ax, 07C0h   ; Set data segment to where we're loaded

	mov ds, ax

	;--;

	mov si, intro_string   ; Put string into SI

	call print_string; Call "print_string" routine

	mov si, white_string   ; Put string into SI

	call print_string; Call "print_string" routine

	mov si, other_string   ; Put string into SI

	call print_string; Call "print_string" routine

	jmp $   ; Jump here - infinite loop - noo

	intro_string db 'Welcome to Christo OS Alpha 0.0.2! If you are reading this, you are awesome!!!',0
	white_string db '  ',0
	other_string db 'wo shi xiao he dian, xiao he dian, xiao he dian',0

print_string:   ; Routine: output string in SI to screen
	mov ah, 0Eh   ; into 10h "print char" function

.repeat:
	lodsb   ; Get character from string

	cmp al, 0

	je .done   ; If char is zero, then end string

	int 10h   ; else, print it

	jmp .repeat

.done:
	ret

	times 510-($-$$) db 0   ; Pad remainder of boot sector with 0s
	dw 0xAA55   ; Standard PC boot signature