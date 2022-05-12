
 ; To use a minikernel, just list it below. They'll be drawn on the screen in
 ; in the order they were listed.
 ;
 ; If a minikernel isn't listed, it won't be compiled into your program, and
 ; it won't use any rom space.

 MAC titlescreenlayout
;	draw_96x2_1
	draw_score
	draw_space 10
	draw_96x2_2
	draw_space 10
	draw_48x2_1
	draw_space 10
	lda _Bit5_PlusROM
	and #32
	beq _Skip_HSC_Logo
	draw_48x1_1
	jmp _Skip_Space_1
_Skip_HSC_Logo
	draw_space 19
_Skip_Space_1


	lda	_Bit4_genesispad
	and	#16
	beq	_Skip_Genesispad_Logo
	draw_48x1_2
	jmp _Skip_Space_2
_Skip_Genesispad_Logo
	draw_space 19
_Skip_Space_2


;	draw_96x2_3
;	draw_48x1_2
;	draw_48x1_3
;	draw_48x2_1
;	draw_48x2_2
;	draw_48x2_3
;	draw_player
;	draw_gameselect


 ENDM

 ; minikernel choices are:
 ; 
 ; draw_48x1_1, draw_48x1_2, draw_48x1_3 
 ; 	The first, second, and third 48-wide single-line bitmap minikernels
 ;
 ; draw_48x2_1, draw_48x2_2, draw_48x2_3 
 ; 	The first, second, and third 48-wide double-line bitmap minikernels
 ;
 ; draw_96x2_1, draw_96x2_2, draw_96x2_3 
 ; 	The first, second, and third 96-wide double-line bitmap minikernels
 ;
 ; draw_gameselect
 ; 	The game selection display minikernel
 ;
 ; draw_score
 ;	A minikernel that draws the score
 ;
 ; draw_space 10
 ;	A minikernel used to add blank space between other minikernels
