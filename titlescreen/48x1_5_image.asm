
 ;*** The height of the displayed data...
bmp_48x1_5_window = 5

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x1_5_height = 5

 ifnconst bmp_48x1_5_PF1
bmp_48x1_5_PF1
 endif
        BYTE %00001111
 ifnconst bmp_48x1_5_PF2
bmp_48x1_5_PF2
 endif
        BYTE %11111111
 ifnconst bmp_48x1_5_background
bmp_48x1_5_background
 endif
        BYTE $c2

 ifnconst bmp_48x1_5_color
bmp_48x1_5_color
 endif
 ; *** this is the bitmap color. If you want to change it in a 
 ; *** variable instead, dim one in bB called "bmp_48x1_5_color"
	.byte $0f


   if >. != >[.+bmp_48x1_5_height]
	align 256
   endif

bmp_48x1_5_00
 ; *** replace this block with your bimap_00 data block...
	BYTE %11101110
	BYTE %11101010
	BYTE %11101100
	BYTE %11101010
	BYTE %11101110


   if >. != >[.+bmp_48x1_5_height]
	align 256
   endif


bmp_48x1_5_01
 ; *** replace this block with your bimap_01 data block...
	BYTE %10001010
	BYTE %10001010
	BYTE %10101011
	BYTE %11011010
	BYTE %10001011


   if >. != >[.+bmp_48x1_5_height]
	align 256
   endif


bmp_48x1_5_02
 ; *** replace this block with your bimap_02 data block...
	BYTE %01110001
	BYTE %00000001
	BYTE %10000111
	BYTE %10000101
	BYTE %10000101


   if >. != >[.+bmp_48x1_5_height]
	align 256
   endif


bmp_48x1_5_03
 ; *** replace this block with your bimap_03 data block...
	BYTE %01110000
	BYTE %01010101
	BYTE %01110010
	BYTE %01010101
	BYTE %01110000


   if >. != >[.+bmp_48x1_5_height]
	align 256
   endif


bmp_48x1_5_04
 ; *** replace this block with your bimap_04 data block...
	BYTE %01110111
	BYTE %00100000
	BYTE %00100000
	BYTE %00100000
	BYTE %01100000


   if >. != >[.+bmp_48x1_5_height]
	align 256
   endif


bmp_48x1_5_05
 ; *** replace this block with your bimap_05 data block...
	BYTE %01100111
	BYTE %00010111
	BYTE %01100111
	BYTE %01000111
	BYTE %01110111



