; orignial code by AtariAge user homerhomer (https://atariage.com/forums/profile/28656-homerhomer/)
; AA topic: https://atariage.com/forums/topic/176639-1942-wip/

 rem furture work ....
 rem need to add plane flip and counter. I was thinking that if the plane is maxed out on y axis up or down then holding joystick up or down with a fire button will cause flip
 rem my collisioin detect is horrid
 rem plane patterns. 1 staitght down, 2, down and up.  sideways bonus planes angles too ?
 rem create levels, one per 100 planes with percentage of planes shot down
 rem I need sounds and music
 rem possible to put score on top?



 rem wishful thinking - bonuses live, power up ( just mirror the player0 )
 rem wishful thinking - fix flicker
 rem wishful thinking - landing and take off animation

;    
;
  includesfile multisprite_bankswitch.inc
  set kernel multisprite
  set romsize 16k

;  const pfres=31

;#region "Constants"
 rem set up planes and variables 
 dim planex_speed=2
 dim planey_speed=1
 dim attack_speed=4

/*
;#region "NTSC Constants and Colors"
   ; requests 
   const req_load        = 0
   const req_level_up    = 1
   const req_game_over   = 2
   const req_move_left   = 3
   const req_move_up     = 4
   const req_move_right  = 5
   const req_move_down   = 6
   const req_level_reset = 7
   const req_safe_point  = 8
   const req_load_menu   = 9
   ; colors
   const _00 = $00
   const _02 = $02
   const _04 = $04
   const _06 = $06
   const _08 = $08
   const _0A = $0A
   const _0C = $0C
   const _0E = $0E
   const _10 = $10
   const _12 = $12
   const _14 = $14
   const _16 = $16
   const _18 = $18
   const _1A = $1A
   const _1C = $1C
   const _1E = $1E
   const _20 = $20
   const _22 = $22
   const _24 = $24
   const _26 = $26
   const _28 = $28
   const _2A = $2A
   const _2C = $2C
   const _2E = $2E
   const _30 = $30
   const _32 = $32
   const _34 = $34
   const _36 = $36
   const _38 = $38
   const _3A = $3A
   const _3C = $3C
   const _3E = $3E
   const _40 = $40
   const _42 = $42
   const _44 = $44
   const _46 = $46
   const _48 = $48
   const _4A = $4A
   const _4C = $4C
   const _4E = $4E
   const _50 = $50
   const _52 = $52
   const _54 = $54
   const _56 = $56
   const _58 = $58
   const _5A = $5A
   const _5C = $5C
   const _5E = $5E
   const _60 = $60
   const _62 = $62
   const _64 = $64
   const _66 = $66
   const _68 = $68
   const _6A = $6A
   const _6C = $6C
   const _6E = $6E
   const _70 = $70
   const _72 = $72
   const _74 = $74
   const _76 = $76
   const _78 = $78
   const _7A = $7A
   const _7C = $7C
   const _7E = $7E
   const _80 = $80
   const _82 = $82
   const _84 = $84
   const _86 = $86
   const _88 = $88
   const _8A = $8A
   const _8C = $8C
   const _8E = $8E
   const _90 = $90
   const _92 = $92
   const _94 = $94
   const _96 = $96
   const _98 = $98
   const _9A = $9A
   const _9C = $9C
   const _9E = $9E
   const _A0 = $A0
   const _A2 = $A2
   const _A4 = $A4
   const _A6 = $A6
   const _A8 = $A8
   const _AA = $AA
   const _AC = $AC
   const _AE = $AE
   const _B0 = $B0
   const _B2 = $B2
   const _B4 = $B4
   const _B6 = $B6
   const _B8 = $B8
   const _BA = $BA
   const _BC = $BC
   const _BE = $BE
   const _C0 = $C0
   const _C2 = $C2
   const _C4 = $C4
   const _C6 = $C6
   const _C8 = $C8
   const _CA = $CA
   const _CC = $CC
   const _CE = $CE
   const _D0 = $D0
   const _D2 = $D2
   const _D4 = $D4
   const _D6 = $D6
   const _D8 = $D8
   const _DA = $DA
   const _DC = $DC
   const _DE = $DE
   const _E0 = $E0
   const _E2 = $E2
   const _E4 = $E4
   const _E6 = $E6
   const _E8 = $E8
   const _EA = $EA
   const _EC = $EC
   const _EE = $EE
   const _F0 = $F0
   const _F2 = $F2
   const _F4 = $F4
   const _F6 = $F6
   const _F8 = $F8
   const _FA = $FA
   const _FC = $FC
   const _FE = $FE
;#endregion
*/
;#region "PAL Constants and Colors"
   ; requests 
   const req_load        = 128 ; PAL x+128
   const req_level_up    = 129
   const req_game_over   = 130
   const req_move_left   = 131
   const req_move_up     = 132
   const req_move_right  = 133
   const req_move_down   = 134
   const req_level_reset = 135
   const req_safe_point  = 136
   const req_load_menu   = 137
   ; colors
   const _00 = $00
   const _02 = $02
   const _04 = $04
   const _06 = $06
   const _08 = $08
   const _0A = $0A
   const _0C = $0C
   const _0E = $0E
   const _10 = $20
   const _12 = $22
   const _14 = $24
   const _16 = $26
   const _18 = $28
   const _1A = $2A
   const _1C = $2C
   const _1E = $2E
   const _20 = $40
   const _22 = $42
   const _24 = $44
   const _26 = $46
   const _28 = $48
   const _2A = $4A
   const _2C = $4C
   const _2E = $4E
   const _30 = $40
   const _32 = $42
   const _34 = $44
   const _36 = $46
   const _38 = $48
   const _3A = $4A
   const _3C = $4C
   const _3E = $4E
   const _40 = $60
   const _42 = $62
   const _44 = $64
   const _46 = $66
   const _48 = $68
   const _4A = $6A
   const _4C = $6C
   const _4E = $6E
   const _50 = $80
   const _52 = $82
   const _54 = $84
   const _56 = $86
   const _58 = $88
   const _5A = $8A
   const _5C = $8C
   const _5E = $8E
   const _60 = $A0
   const _62 = $A2
   const _64 = $A4
   const _66 = $A6
   const _68 = $A8
   const _6A = $AA
   const _6C = $AC
   const _6E = $AE
   const _70 = $C0
   const _72 = $C2
   const _74 = $C4
   const _76 = $C6
   const _78 = $C8
   const _7A = $CA
   const _7C = $CC
   const _7E = $CE
   const _80 = $D0
   const _82 = $D2
   const _84 = $D4
   const _86 = $D6
   const _88 = $D8
   const _8A = $DA
   const _8C = $DC
   const _8E = $DE
   const _90 = $B0
   const _92 = $B2
   const _94 = $B4
   const _96 = $B6
   const _98 = $B8
   const _9A = $BA
   const _9C = $BC
   const _9E = $BE
   const _A0 = $90
   const _A2 = $92
   const _A4 = $94
   const _A6 = $96
   const _A8 = $98
   const _AA = $9A
   const _AC = $9C
   const _AE = $9E
   const _B0 = $70
   const _B2 = $72
   const _B4 = $74
   const _B6 = $76
   const _B8 = $78
   const _BA = $7A
   const _BC = $7C
   const _BE = $7E
   const _C0 = $50
   const _C2 = $52
   const _C4 = $54
   const _C6 = $56
   const _C8 = $58
   const _CA = $5A
   const _CC = $5C
   const _CE = $5E
   const _D0 = $30
   const _D2 = $32
   const _D4 = $34
   const _D6 = $36
   const _D8 = $38
   const _DA = $3A
   const _DC = $3C
   const _DE = $3E
   const _E0 = $20
   const _E2 = $22
   const _E4 = $24
   const _E6 = $26
   const _E8 = $28
   const _EA = $2A
   const _EC = $2C
   const _EE = $2E
   const _F0 = $20
   const _F2 = $22
   const _F4 = $24
   const _F6 = $26
   const _F8 = $28
   const _FA = $2A
   const _FC = $2C
   const _FE = $2E
;#endregion

;#endregion

;#region "Zeropage Variables"
 dim bmp_96x2_2_index = e
 dim statusbarcolor = t
 dim framecounter = e
;#endregion


  bank 1

 player0x = 75 : player0y = 8

 player1x = rand/2 : player1y = 88

 player2x = rand/2 : player2y = 93

 player3x = rand/2 : player3y = 98

 player4x = rand/2 : player4y = 103

 player5x = rand/2 : player5y = 0

 rem #######################################

 scorecolor = _0E

 goto titlescreen bank2

 rem #######################################



start

 rem initial variables setup
  missile0y=0
  lives = 64
  NUSIZ0 = 16
  NUSIZ1 = 16
  _COLUP1 = _E8


  m=0 : rem Toggle flips every time
  COLUBK = _96
;  lifecolor = 6
 lives = 192
 lifecolor = 234

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Playfield Pacific"

 playfield:
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ........XX......
 ......XXX.......
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ..............XX
 ..............XX
 .............XXX
 ...............X
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 .........XXX....
 .........XX.....
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ............XX..
 ...........XXX..
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ...............X
 ..............XX
 ..............XX
 ...............X
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 .....XX.........
 ....XXXXX.......
 ....XXXX........
 .....XXX........
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 XXX.............
 XXXXX...........
 XXXX............
 XXX.............
 XX..............
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ..............XX
 ..........XXXXXX
 ..........XXXXXX
 ........XXXXXXXX
 ........XXXXXXX.
 ........XXXXXXX.
 .......XXXXXXXXX
 .......XXXXXXXXX
 .......XXXXXXXX.
 .......XXXXXXXX.
 .......XXXXXXXXX
 .......XXXXXXXXX
 .......XXXXXXXX.
 .......XXXXXXXX.
 .......XXXXXXXXX
 .......XXXXXXXXX
 .......XXXXXXXX.
 .......XXXXXXXX.
 ........XXXXXXXX
 ........XXXXXXXX
 ........XXXXXXXX
 ..........XXXXXX
 ..........XXXXXX
 ...........XXXXX
 ..............XX
 ................
 ................
 ................
 ................
 ................
 ................
 ................
 ................
end
;#endregion


 PF1pointer = 10
 PF2pointer = 10

 framecounter = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Mainloop"

main
 if switchreset then reboot ; goto titlescreen bank2

 framecounter = framecounter + 1

 rem  NUSIZ0=$17 
 rem  NUSIZ1=$16
 rem  NUSIZ2=$16 
 rem  NUSIZ3=$16 
 rem  NUSIZ4=$16 
 NUSIZ5 = $07 


  COLUP0 = _EA
  COLUP1 = _D4
  COLUP2 = _D6
  COLUP3 = _D6
  COLUP4 = _D6
  COLUP5 = _D4

 player0:
 %00100100
 %01111110
 %00100100
 %00111100
 %11111111
 %11111111
 %00100100
end
 

 player1:
 %00000000
 %00011000
 %11111111
 %11111111
 %00111100
 %00011000
 %00011000
 %00111100
end


  player2:
 %00011000
 %01111110
 %01111110
 %00011000
 %00111100
end

 player3:
 %00011000
 %01111110
 %01111110
 %00011000
 %00111100
end

 player4:
 %00011000
 %01111110
 %01111110
 %00011000
 %00111100
end

 
 player5:
 %00111100
 %00111100
 %00011000
 %00011000
 %11111111
 %11111111
 %11111111
 %01011010
end


 lives:
 %00011000
 %01111110 
 %01111110
 %00011000
 %00111100
end

  if !collision(player1, missile0) then goto skip3
  score = score + 50
  ; find a flicker free spot for respawning the hit enemy.
  temp1 = 100 : temp2 = player1y + 8
  if temp1 < temp2 then temp1 = player1y + 8
  temp2 = player2y + 8
  if temp1 < temp2 then temp1 = player2y + 8
  temp2 = player3y + 8
  if temp1 < temp2 then temp1 = player3y + 8
  temp2 = player4y + 8
  if temp1 < temp2 then temp1 = player4y + 8

  p = player1y + 5 : q = player1y - 5
  if missile0y > q && missile0y < p then player1x = rand/2 : player1y = temp1 : goto skip2

  p = player2y + 5 : q = player2y - 5
  if missile0y > q && missile0y < p then player2x = rand/2 : player2y = temp1 : goto skip2

  p = player3y + 5 : q = player3y - 5
  if missile0y > q && missile0y < p then player3x = rand/2 : player3y = temp1 : goto skip2

  p = player4y + 5 : q = player4y - 5
  if missile0y > q && missile0y < p then player4x = rand/2 : player4y = temp1 : goto skip2

  p = player5y + 5 : q = player5y - 5 ; Why check player 5? we had a collision and the others have not been hit!
  if missile0y > q && missile0y < p then player5x = rand/2 : player5y = 100

skip2
  missile0y = 0

skip3


 rem ################### movement 
  if joy0up && player0y < 40 then player0y = player0y + 1 : goto jump
  if joy0down && player0y > 8 then player0y = player0y - 1 : goto jump
  if joy0left && player0x > 0 then player0x = player0x - 1 : goto jump
  if joy0right && player0x < 153 then player0x = player0x + 1
jump


  if missile0y > 88 then missile0y = 0
  if missile0y > 1 then skip_new_shot
  if joy0fire then missile0y = player0y + 1 : missile0x = player0x + 5
skip_new_shot
  if ! missile0y then check_enemy_shot
  missile0y = missile0y + 3
  if m then missile0x = missile0x - 2 : m = 0 else missile0x = missile0x + 2 : m = 1

check_enemy_shot
;  if player1x = player0x && n = 0 && player1y < 20 then missile1x = player1x + 5 : missile1y = player1y + 2 :  n = 1


plane_loop


 rem ################### attack speed

; o = o - 1 : if o = 0 then o = attack_speed
; if o > 1 then goto p99
  if framecounter{0} || PF1pointer < 38 then goto p99
 

 rem ###################  the planes

; r = 5

; if r=0 then goto p99
; if r=1 then goto p5
; if r=2 then goto p4
; if r=3 then goto p3
; if r=4 then goto p2
; if r=4 then goto p1

p1
  if player1y < 1 then player1x = rand/2 : player1y = 100
  player1y = player1y - planey_speed 
  if player1y < 71 then skip_horizontal_movement_p1
  if player1x > player0x then player1x = player1x - planex_speed else player1x = player1x + planex_speed
skip_horizontal_movement_p1
 
p2
  if player2y < 1 then player2x = rand/2 : player2y = 100
  player2y = player2y - planey_speed 
  if player2y < 71 then skip_horizontal_movement_p2
  if player2x > player0x then player2x = player2x - planex_speed else player2x = player2x + planex_speed
skip_horizontal_movement_p2

p3
  if player3y < 1 then player3x = rand/2 : player3y = 100
  player3y = player3y - planey_speed
  if player3y < 71 then skip_horizontal_movement_p3
  if player3x > player0x then player3x = player3x - planex_speed else player3x = player3x + planex_speed
skip_horizontal_movement_p3

p4
  if player4y < 1 then player4x = rand/2 : player4y = 100
  player4y = player4y - planey_speed
  if player4y < 71 then skip_horizontal_movement_p4
  if player4x > player0x then player4x = player4x - planex_speed else player4x = player4x + planex_speed
skip_horizontal_movement_p4

p5
  if player5y < 1 then player5x = rand/2 : player5y = 0
  player5y = player5y + planey_speed 
 rem   if player5x > player0x && player5y > 70 then player5x = player5x -planey_speed
 rem   if player5x < player0x && player5y > 70 then player5x = player5x + planey_speed
 
p99

; pfscroll down

 if framecounter < 10 then _skip_scrolling
 if PF1pointer > 34 && framecounter < 30 then _skip_scrolling
 PF1pointer = PF1pointer + 1
 PF2pointer = PF2pointer + 1
 if PF1pointer = 247 then PF1pointer = 0 : PF2pointer = 0
 framecounter = 0

_skip_scrolling

 if PF1pointer < 34 then COLUPF = _04 else COLUPF =  _C8


 drawscreen
 goto main
;#endregion



  bank 2

titlescreen            
   COLUBK = _00

   framecounter = framecounter + 1 ; bmp_96x2_2_color = _0E : else bmp_96x2_2_color = _D6 :
   if framecounter{0} then bmp_96x2_2_index = 25 else  bmp_96x2_2_index = 0

   gosub titledrawscreen

   if joy0fire then goto start bank1
 goto titlescreen

   asm
   include "titlescreen/asm/titlescreen.asm"
end

  bank 3

  bank 4
