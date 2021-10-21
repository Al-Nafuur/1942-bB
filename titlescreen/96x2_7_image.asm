
 ;*** The height of the displayed data...
bmp_96x2_7_window = 5

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_96x2_7_height = 5


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif
   BYTE $00 ; leave this here!


  ;*** The color of each line in the bitmap, in reverse order...
bmp_96x2_7_colors 
	BYTE $9a
	BYTE $7a
	BYTE $5a
	BYTE $3a
	BYTE $1a


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_00
 ; *** replace this block with your bimap_00 data block...
	BYTE %11111111
	BYTE %10000000
	BYTE %10000000
	BYTE %10000000
	BYTE %11111111


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_01
 ; *** replace this block with your bimap_01 data block...
	BYTE %11111011
	BYTE %00001010
	BYTE %00001011
	BYTE %00001010
	BYTE %11111011


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_02
 ; *** replace this block with your bimap_02 data block...
	BYTE %10100010
	BYTE %10100010
	BYTE %00101010
	BYTE %10110110
	BYTE %10100010


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_03
 ; *** replace this block with your bimap_03 data block...
	BYTE %10001110
	BYTE %10000000
	BYTE %11100000
	BYTE %10100000
	BYTE %11100000


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_04
 ; *** replace this block with your bimap_04 data block...
	BYTE %00101110
	BYTE %00101010
	BYTE %11101110
	BYTE %10101000
	BYTE %11101000


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_05
 ; *** replace this block with your bimap_05 data block...
	BYTE %00001110
	BYTE %10101000
	BYTE %01001110
	BYTE %10100010
	BYTE %00001110


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_06
 ; *** replace this block with your bimap_06 data block...
	BYTE %11100010
	BYTE %00000010
	BYTE %00000010
	BYTE %00000010
	BYTE %00001110


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_07
 ; *** replace this block with your bimap_07 data block...
	BYTE %11101110
	BYTE %00000100
	BYTE %00000100
	BYTE %00000100
	BYTE %00001110


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_08
 ; *** replace this block with your bimap_08 data block...
	BYTE %10001010
	BYTE %10001010
	BYTE %10101011
	BYTE %11011010
	BYTE %10001011


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_09
 ; *** replace this block with your bimap_09 data block...
	BYTE %10111011
	BYTE %10101010
	BYTE %10111011
	BYTE %10100010
	BYTE %10111011


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_10
 ; *** replace this block with your bimap_10 data block...
	BYTE %10111111
	BYTE %00100000
	BYTE %00100000
	BYTE %00100000
	BYTE %10111111


   if >. != >[.+(bmp_96x2_7_height)]
      align 256
   endif


bmp_96x2_7_11
 ; *** replace this block with your bimap_11 data block...
	BYTE %11111111
	BYTE %00000001
	BYTE %00000001
	BYTE %00000001
	BYTE %11111111



