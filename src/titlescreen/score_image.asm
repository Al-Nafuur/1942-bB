 ; feel free to modify the score graphics - just keep each digit 8 high
 ; if you're looking to want to modify any one font, pick on the 

 ifnconst scorecolor
scorecolor
 endif
 ; ** change this value for a different scorecolor under DPC+
 ;    for other kernels, just use the scorecolor variable
 .byte $0f

 ifnconst NOFONT
NOFONT = 0
 endif
 ifnconst STOCK
STOCK = 1 	;_FONTNAME
 endif
 ifnconst NEWCENTURY
NEWCENTURY = 2	;_FONTNAME
 endif
 ifnconst WHIMSEY
WHIMSEY = 3	;_FONTNAME
 endif
 ifnconst ALARMCLOCK
ALARMCLOCK = 4	;_FONTNAME
 endif
 ifnconst HANDWRITTEN
HANDWRITTEN = 5 ;_FONTNAME
 endif
 ifnconst INTERRUPTED
INTERRUPTED = 6 ;_FONTNAME
 endif
 ifnconst TINY
TINY = 7	;_FONTNAME
 endif
 ifnconst RETROPUTER
RETROPUTER = 8	;_FONTNAME
 endif
 ifnconst CURVES
CURVES = 9	;_FONTNAME
 endif
 ifnconst HUSKY
HUSKY = 10	;_FONTNAME
 endif
 ifnconst SNAKE
SNAKE = 11	;_FONTNAME
 endif
 ifnconst PLOK
PLOK = 13	;_FONTNAME
 endif

 ifnconst SYMBOLS
SYMBOLS = 0 	;_FONTNAME 
 endif

; ### setup some defaults
 ifnconst fontstyle
fontstyle = STOCK
 endif

 ;fix up the table alignment, if necessary
 if >. != >[.+81]
      align 256
 endif


miniscoretable

 if fontstyle == STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111110 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00111000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00001000 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111110 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %00111100 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00011100 ; STOCK
       .byte %00000110 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00001100 ; STOCK
       .byte %00001100 ; STOCK
       .byte %01111110 ; STOCK
       .byte %01001100 ; STOCK
       .byte %01001100 ; STOCK
       .byte %00101100 ; STOCK
       .byte %00011100 ; STOCK
       .byte %00001100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00111100 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01111110 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01111100 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100010 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00110000 ; STOCK
       .byte %00110000 ; STOCK
       .byte %00110000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00001100 ; STOCK
       .byte %00000110 ; STOCK
       .byte %01000010 ; STOCK
       .byte %00111110 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00111110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

 endif ; STOCK

 if fontstyle == NEWCENTURY
       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00011000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111110 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %00100000 ; NEWCENTURY
       .byte %00011100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00011100 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00011100 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00111110 ; NEWCENTURY
       .byte %00100010 ; NEWCENTURY
       .byte %00100010 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %00110000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00010000 ; NEWCENTURY
       .byte %00010000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00000100 ; NEWCENTURY
       .byte %00000100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00011110 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %00111100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00011000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00001110 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY
       .byte %00001100 ; NEWCENTURY

 endif ; NEWCENTURY

 if fontstyle == WHIMSEY
       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %00011000 ; WHIMSEY
       .byte %00011000 ; WHIMSEY
       .byte %00011000 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %00011000 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %01100110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01101110 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01011100 ; WHIMSEY
       .byte %01011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01101110 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %00111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111000 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00000110 ; WHIMSEY
       .byte %00111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

 endif ; WHIMSEY

 if fontstyle == ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK


 endif ; ALARMCLOCK

 if fontstyle == HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %01110000 ; HANDWRITTEN
       .byte %01001100 ; HANDWRITTEN
       .byte %01000000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00100010 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00100010 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %01111000 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00000010 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00101000 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00000110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00110010 ; HANDWRITTEN
       .byte %00001110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001010 ; HANDWRITTEN
       .byte %00000110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

 endif ; HANDWRITTEN

 if fontstyle == INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00111100 ; INTERRUPTED
       .byte %00000000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00111000 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01101110 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %00110000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00001100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01000110 ; INTERRUPTED
       .byte %00111100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01111100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01110110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01110110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01111100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01111100 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01101110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00101100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01101100 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %00110000 ; INTERRUPTED
       .byte %00011100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011100 ; INTERRUPTED
       .byte %00001110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000000 ; INTERRUPTED
       .byte %01111110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00111000 ; INTERRUPTED
       .byte %00001100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00110110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED

 endif ; INTERRUPTED


 if fontstyle == TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

 endif ; TINY

 if fontstyle == RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00111000 ; RETROPUTER
       .byte %00111000 ; RETROPUTER
       .byte %00111000 ; RETROPUTER
       .byte %00111000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %00111110 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00111110 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000100 ; RETROPUTER
       .byte %01000100 ; RETROPUTER
       .byte %01000100 ; RETROPUTER
       .byte %00000100 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00000100 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

 endif ; RETROPUTER

 if fontstyle == CURVES

       ;byte %00000000 ; CURVES

       .byte %00111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %01111000 ; CURVES
       .byte %01110000 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111100 ; CURVES
       .byte %00111110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00001110 ; CURVES
       .byte %00111100 ; CURVES
       .byte %00111100 ; CURVES
       .byte %00001110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

 endif ; CURVES


 if fontstyle == HUSKY

       ;byte %00000000 ; HUSKY

       .byte %01111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %01111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %00011100 ; HUSKY
       .byte %00011100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11011100 ; HUSKY
       .byte %11011100 ; HUSKY
       .byte %00011100 ; HUSKY
       .byte %00011100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %01111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00011100 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %01111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %01111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY

 endif ; HUSKY


 if fontstyle == SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00111000 ; SNAKE
       .byte %00101000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00111000 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01100010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00001110 ; SNAKE
       .byte %00001010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01100110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01100010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00000110 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01100010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00001110 ; SNAKE
       .byte %00001010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE


 endif ; SNAKE

 if fontstyle == PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %01100100 ; PLOK
       .byte %01100010 ; PLOK
       .byte %01100010 ; PLOK
       .byte %00110110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00010000 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00001110 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00001100 ; PLOK
       .byte %00000110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01101110 ; PLOK
       .byte %00001110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000110 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00011000 ; PLOK
       .byte %01111110 ; PLOK
       .byte %01101100 ; PLOK
       .byte %00100100 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01001110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %01100000 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01000110 ; PLOK
       .byte %01101100 ; PLOK
       .byte %01110000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00010000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00001100 ; PLOK
       .byte %00000110 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01001110 ; PLOK
       .byte %01101110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01100100 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00001100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00100110 ; PLOK
       .byte %01001110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00000000 ; PLOK

 endif ; PLOK

; ### any characters that aren't font specific follow... 

 ifconst fontcharSPACE
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS
 endif ; fontcharSPACE

 ifconst fontcharDOLLAR
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00010010 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %10010000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00010000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharDOLLAR

 ifconst fontcharPOUND
       ;byte %00000000 ; SYMBOLS

       .byte %01111110 ; SYMBOLS
       .byte %01000000 ; SYMBOLS
       .byte %00100000 ; SYMBOLS
       .byte %00100000 ; SYMBOLS
       .byte %01111000 ; SYMBOLS
       .byte %00100000 ; SYMBOLS
       .byte %00100010 ; SYMBOLS
       .byte %00011100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharPOUND


 ifconst fontcharMRHAPPY
       ;byte %00000000 ; SYMBOLS

       .byte %00111100 ; SYMBOLS
       .byte %01100110 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %00111100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharMRHAPPY

 ifconst fontcharMRSAD
       ;byte %00000000 ; SYMBOLS

       .byte %00111100 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01100110 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %00111100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharMRSAD


 ifconst fontcharCOPYRIGHT
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %01000100 ; SYMBOLS
       .byte %10111010 ; SYMBOLS
       .byte %10100010 ; SYMBOLS
       .byte %10111010 ; SYMBOLS
       .byte %01000100 ; SYMBOLS
       .byte %00111000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharCOPYRIGHT


 ifconst fontcharFUJI

       ;byte %00000000 ; ** these commented-out blanks are for the preview generation program

       .byte %01110000 ; SYMBOLS
       .byte %01111001 ; SYMBOLS
       .byte %00011101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

       .byte %00001110 ; SYMBOLS
       .byte %10011110 ; SYMBOLS
       .byte %10111000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharFUJI


 ifconst fontcharHEART
       ;byte %00000000 ; SYMBOLS

       .byte %00010000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11101110 ; SYMBOLS
       .byte %01000100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharHEART

 ifconst fontcharDIAMOND
       ;byte %00000000 ; SYMBOLS

       .byte %00010000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharDIAMOND

 ifconst fontcharSPADE
       ;byte %00000000 ; SYMBOLS

       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS
       .byte %01010100 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharSPADE

 ifconst fontcharCLUB
       ;byte %00000000 ; SYMBOLS

       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS
       .byte %11010110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11010110 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharCLUB


 ifconst fontcharCOLON
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharCOLON


 ifconst fontcharBLOCK

       ;byte %00000000 ; SYMBOLS

       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharBLOCK

 ifconst fontcharUNDERLINE

       ;byte %00000000 ; SYMBOLS

       .byte %11111111 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharUNDERLINE

 ifconst fontcharARISIDE
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00101010 ; SYMBOLS
       .byte %00101010 ; SYMBOLS
       .byte %00101100 ; SYMBOLS
       .byte %01111111 ; SYMBOLS
       .byte %00110111 ; SYMBOLS
       .byte %00000010 ; SYMBOLS
       .byte %00000001 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 endif ; fontcharARISIDE

 ifconst fontcharARIFACE
       ;byte %00000000 ; SYMBOLS

       .byte %00001000 ; SYMBOLS
       .byte %00011100 ; SYMBOLS
       .byte %00111110 ; SYMBOLS
       .byte %00101010 ; SYMBOLS
       .byte %00011100 ; SYMBOLS
       .byte %01010100 ; SYMBOLS
       .byte %00100100 ; SYMBOLS
       .byte %00000010 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS


 endif ; fontcharARIRACE

