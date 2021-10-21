
 ;*** The height of the displayed data...
bmp_48x2_2_window = 5

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x2_2_height = 5

   if >. != >[.+(bmp_48x2_2_height)]
      align 256
   endif
 BYTE 0 ; leave this here!


 ;*** The color of each line in the bitmap, in reverse order...
bmp_48x2_2_colors 
	BYTE $9a
	BYTE $7a
	BYTE $5a
	BYTE $3a
	BYTE $1a

 ifnconst bmp_48x2_2_PF1
bmp_48x2_2_PF1
 endif
        BYTE %00001111
 ifnconst bmp_48x2_2_PF2
bmp_48x2_2_PF2
 endif
        BYTE %11111111
 ifnconst bmp_48x2_2_background
bmp_48x2_2_background
 endif
        BYTE $c2


   if >. != >[.+bmp_48x2_2_height]
      align 256
   endif


bmp_48x2_2_00
 ; *** replace this block with your bimap_00 data block...
	BYTE %11101110
	BYTE %11101010
	BYTE %11101100
	BYTE %11101010
	BYTE %11101110


   if >. != >[.+bmp_48x2_2_height]
      align 256
   endif


bmp_48x2_2_01
 ; *** replace this block with your bimap_01 data block...
	BYTE %10001010
	BYTE %10001010
	BYTE %10101011
	BYTE %11011010
	BYTE %10001011


   if >. != >[.+bmp_48x2_2_height]
      align 256
   endif


bmp_48x2_2_02
 ; *** replace this block with your bimap_02 data block...
	BYTE %01110001
	BYTE %00000001
	BYTE %10000111
	BYTE %10000101
	BYTE %10000101


   if >. != >[.+bmp_48x2_2_height]
      align 256
   endif


bmp_48x2_2_03
 ; *** replace this block with your bimap_03 data block...
	BYTE %01110000
	BYTE %01010101
	BYTE %01110010
	BYTE %01010101
	BYTE %01110000


   if >. != >[.+bmp_48x2_2_height]
      align 256
   endif


bmp_48x2_2_04
 ; *** replace this block with your bimap_04 data block...
	BYTE %01110111
	BYTE %01000000
	BYTE %01110000
	BYTE %00010000
	BYTE %01110000


   if >. != >[.+bmp_48x2_2_height]
      align 256
   endif


bmp_48x2_2_05
 ; *** replace this block with your bimap_05 data block...
	BYTE %01110111
	BYTE %01000111
	BYTE %01110111
	BYTE %00010111
	BYTE %01110111


