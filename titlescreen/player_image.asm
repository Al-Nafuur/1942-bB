

 ;*** the height of this mini-kernel.
bmp_player_window = 10

 ;*** how many scanlines per pixel. 
bmp_player_kernellines = 1

 ;*** the height of each player.
bmp_player0_height = 10
bmp_player1_height = 10

 ;*** NUSIZ0 value. If you want to change it in a variable
 ;*** instead, dim on in bB called "bmp_player0_nusiz"
 ifnconst bmp_player0_nusiz
bmp_player0_nusiz
 endif
 BYTE 0

 ;*** NUSIZ1 value. If you want to change it in a variable
 ;*** instead, dim on in bB called "bmp_player1_nusiz"
 ifnconst bmp_player1_nusiz
bmp_player1_nusiz
 endif
 BYTE 0

 ;*** REFP0 value. If you want to change it in a variable
 ;*** instead, dim on in bB called "bmp_player0_refp"
 ifnconst bmp_player0_refp
bmp_player0_refp
 endif
 BYTE 3

 ;*** REFP1 value. If you want to change it in a variable
 ;*** instead, dim on in bB called "bmp_player1_refp"
 ifnconst bmp_player1_refp
bmp_player1_refp
 endif
 BYTE 3

 ;*** the bitmap data for player0
bmp_player0
	BYTE %11111111
	BYTE %11000011
	BYTE %10011001
	BYTE %10111101
	BYTE %10111101
	BYTE %10111101
	BYTE %10111101
	BYTE %10011001
	BYTE %11000011
	BYTE %11111111

 ;*** the color data for player0
bmp_color_player0
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 
	BYTE $86 

 ;*** the bitmap data for player1
bmp_player1
	BYTE %11111111
	BYTE %11000011
	BYTE %11100111
	BYTE %11100111
	BYTE %11100111
	BYTE %11100111
	BYTE %11100111
	BYTE %11100111
	BYTE %11000111
	BYTE %11111111

 ;*** the color data for player1
bmp_color_player1
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
	BYTE $FA
