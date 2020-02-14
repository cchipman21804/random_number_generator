	org 0100h
	use16
; Generates a 5-digit number based on the current date & time
; and displays the least significant digit on the stdout console

; Obtain values from DOS date function & add them up

	mov ah,2ah
	int 21h

; Current day of week is now in register AL
; Current year is now in register CX
; Current month is now in register DH
; Current date is now in register DL

	xor ah,ah
	add ax,cx
	add ax,dx

; Store result in scratchpad
	mov [scratchpad],ax

; Obtain values from DOS time function & add them up

	mov ah,2ch
	int 21h

; Current hour is now in register CH
; Current minute is now in register CL
; Current second is now in register DH
; Current (millisecond / 10) is now in register DL

; Retrieve result from scratchpad & add time values to it
	mov ax,[scratchpad]
	add ax,cx
	add ax,dx

; Store the number for later in scratchpad & archive original value next to it
	mov [scratchpad],ax
	mov [archive],ax

	mov bp,ten_thou_place	   ; Set placeholder pointer
	mov di,0		   ; Set pointer offset
	mov bx,10000		   ; Set register BX to placeholder divisor
	mov cx,5		   ; Set counter to 5 placeholders
    next_decimal_place:
	mov ax,[scratchpad]	   ; Retrieve number from scratchpad
	xor dx,dx		   ; Prepare register DX for division
	div bx			   ; Divide number by placeholder divisor
	add [bp+di],al		   ; Add quotient in al to current placeholder
	mov [scratchpad],dx	   ; Save remainder in dx to scratchpad
	mov ax,bx		   ; Prepare for new placeholder divisor
	xor dx,dx
	mov bx,10
	div bx			   ; Divide old placeholder by 10
	mov bx,ax		   ; Set new placeholder divisor
	inc di			   ; Point to next placeholder
	loop next_decimal_place    ; Until counter = 0

; Now convert placeholder values to ASCII
	mov di,0		   ; Point to placeholder
	mov cx,5		   ; Set counter to 5 placeholders
    convert_next_one:
	mov al,[bp+di]		   ; Retrieve placeholder value
	add al,30h		   ; Convert to ASCII
	mov [bp+di],al		   ; Save ASCII value in placeholder
	inc di			   ; Point to next placeholder
	loop convert_next_one

; Display values as string on the screen & return to DOS
	mov dx,app_name_ver
	mov ax,0900h		   ; Select interrupt to display string
	int 21h 		   ; on the console
	mov dx,ones_place	   ; Set location of ASCII string
	mov ax,0900h		   ; Select interrupt to display string
	int 21h 		   ; on the console
	mov ax,4c00h		   ; Select interrupt to terminate program
	int 21h 		   ; & return to DOS prompt

;	 int 03h		    ; breakpoint

app_name_ver db 'random 1 digit number v1.0',0ah,0dh,24h

scratchpad dw ?
archive dw ?

ten_thou_place db 0
thou_place db 0
hund_place db 0
tens_place db 0
ones_place db 0
end_string db 24h

new_line db 0ah,0dh,24h
digit_zero db "0",24h
digit_one db "1",24h
digit_two db "2",24h
digit_three db "3",24h
digit_four db "4",24h
digit_five db "5",24h
digit_six db "6",24h
digit_seven db "7",24h
digit_eight db "8",24h
digit_nine db "9",24h
colon db ":",24h

