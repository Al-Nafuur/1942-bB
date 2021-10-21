 ifnconst bmp_gameselect_color
bmp_gameselect_color
 endif
	.byte $0f

 if >. != >[.+5]
 	align 256
 endif
bmp_gameselect_CHAR0

        .byte %01111010
        .byte %10001010
        .byte %10111011
        .byte %10000010
        .byte %01111001

 if >. != >[.+5]
 	align 256
 endif
bmp_gameselect_CHAR1

        .byte %01010001
        .byte %01010001
        .byte %11010101
        .byte %01011011
        .byte %10010001

 if >. != >[.+5]
 	align 256
 endif
bmp_gameselect_CHAR2
        .byte %01111000
        .byte %01000000
        .byte %01110000
        .byte %01000000
        .byte %01111000

 if >. != >[.+5]
 	align 256
 endif
bmp_gameselect_CHAR3
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000
        .byte %00000000

 if >. != >[.+80]
 	align 256
 endif

font_gameselect_img
	.byte %00111100
	.byte %01100110
	.byte %01100110
	.byte %01100110
	.byte %00111100

	.byte %00111100
	.byte %00011000
	.byte %00011000
	.byte %00011000
	.byte %00111000

	.byte %01111110
	.byte %01100000
	.byte %00111100
	.byte %00000110
	.byte %01111100

	.byte %01111100
	.byte %00000110
	.byte %00011100
	.byte %00000110
	.byte %01111100

	.byte %00000110
	.byte %00000110
	.byte %01111110
	.byte %01100110
	.byte %01100110

	.byte %01111100
	.byte %00000110
	.byte %01111100
	.byte %01100000
	.byte %01111110

	.byte %00111100
	.byte %01100110
	.byte %01111100
	.byte %01100000
	.byte %00111100

	.byte %00011000
	.byte %00011000
	.byte %00001100
	.byte %00000110
	.byte %01111110

	.byte %00111100
	.byte %01100110
	.byte %00111100
	.byte %01100110
	.byte %00111100

	.byte %00111100
	.byte %00000110
	.byte %00111110
	.byte %01100110
	.byte %00111100

 ifnconst gamenumber
gamenumber
 endif
	.byte 0

