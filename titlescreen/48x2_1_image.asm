
 ;*** The height of the displayed data...
bmp_48x2_1_window = 7

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x2_1_height = 7

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif
 BYTE 0 ; leave this here!


 ;*** The color of each line in the bitmap, in reverse order...
bmp_48x2_1_colors 
	BYTE _0E
	BYTE _0E
	BYTE _0E
	BYTE _0E
	BYTE _0E
	BYTE _0E
	BYTE _0E

 ifnconst bmp_48x2_1_PF1
bmp_48x2_1_PF1
 endif
        BYTE %00000000
 ifnconst bmp_48x2_1_PF2
bmp_48x2_1_PF2
 endif
        BYTE %11111111
 ifnconst bmp_48x2_1_background
bmp_48x2_1_background
 endif
        BYTE _C2

   if >. != >[.+bmp_48x2_1_height]
      align 256
   endif


bmp_48x2_1_00
	BYTE %00000000
	BYTE %00000100
	BYTE %00000100
	BYTE %00000111
	BYTE %00000101
	BYTE %00000111
	BYTE %00000000
	BYTE %00000100

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_01
	BYTE %00000000
	BYTE %01010111
	BYTE %01100100
	BYTE %01110110
	BYTE %01010100
	BYTE %01110111
	BYTE %00000000
	BYTE %01100100

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_02
	BYTE %00000000
	BYTE %01110111
	BYTE %00010001
	BYTE %01110111
	BYTE %01000100
	BYTE %01110111
	BYTE %00000000
	BYTE %00010001

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_03
	BYTE %00000000
	BYTE %00000100
	BYTE %00000100
	BYTE %00000110
	BYTE %00000100
	BYTE %00000111
	BYTE %00000000
	BYTE %00000100

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_04
	BYTE %00000000
	BYTE %01110101
	BYTE %00100110
	BYTE %00100111
	BYTE %00100101
	BYTE %01110111
	BYTE %00000000
	BYTE %00100110

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_05
	BYTE %00000000
	BYTE %01110000
	BYTE %01000000
	BYTE %01100000
	BYTE %01000000
	BYTE %01110000
	BYTE %00000000
	BYTE %01000000

