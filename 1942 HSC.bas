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

   pfheight = 7

;#region "Constants"
   rem set up planes and variables 
   dim planey_speed   = 1
   dim planex_speed_1 = 1
   dim planex_speed_2 = 2
   dim lives_compact  = 1

   const screen_v_res      = 12
   const map_length        = 256
   const takeoff_point     = 17
   const carrier_end       = 41
   const attackzone_start  = carrier_end + 5
   const map_end           = map_length - screen_v_res - 1

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
/*
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
*/
;#endregion

;#region "Zeropage Variables"

   dim _Ch0_Counter     = a
   dim _Ch0_Duration    = b
   dim _Ch1_Counter     = c
   dim _Ch1_Duration    = d
   dim framecounter     = e
   dim bmp_96x2_2_index = f
   dim attack_position  = g
   dim stage            = h
   dim level            = i

   dim statusbarcolor   = t
;#endregion


   bank 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 1 Game Logic"

   scorecolor = _0E

   goto titlescreen_start bank2
 

start

   rem initial variables setup
   missile0y = 0 : level = 0 : stage = 0 : framecounter = 0
   player0x = 76 : player0y = 8 : attack_position = 8
   lives = 64
   gosub build_attack_position

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
   .........XX.....
   ........XXXX....
   .........XX.....
   ................
   ................
   ................
   ................
   ................
   ................
   ................
   ............XX..
   ...........XXXX.
   .............X..
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
   ....XX..........
   ..XXXXXXXXXXXX..
   XXXXXXXXXXXXXXXX
   XXXXXXXXXXXXXX..
   XXXXXXXXXXXXXX..
   XXXXXXXXXXXXXXX.
   XXXXXXXXXXXXXXXX
   ..XXXXXXX.XXXXXX
   ............XXXX
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
   ........XXXXXXX.
   ..........XXXXX.
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
   ................
   ................
   ................
   ................
   ................
   ................
   ................
end
;#endregion

   PF1pointer = takeoff_point
   PF2pointer = takeoff_point

   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Mainloop"
main
   if switchreset then goto titlescreen_start bank2

   framecounter = framecounter + 1
   COLUBK = _96
   lifecolor = _EA

   COLUP0 = _EA
   player0:
   %00100100
   %01111110
   %00100100
   %00111100
   %11111111
   %11111111
   %00100100
end
   
   on attack_position goto _def_ap0_p1 _def_ap1_p1 _def_ap2_p1 _def_ap3_p1 _def_ap4_p1 _def_ap5_p1

_def_ap0_p1
   player1:
   %00011000
   %01111110
   %01111110
   %00011000
   %00111100
end
   goto _player1_end_def

_def_ap3_p1
_def_ap4_p1
_def_ap5_p1
_def_ap1_p1
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
   goto _player1_end_def

_def_ap2_p1
   player1:
   %0011000
   %0011010
   %0111110
   %0111110
   %0011010
   %0011000
end

_player1_end_def

   on attack_position goto _def_ap0_p2 _def_ap1_p2 _def_ap2_p2 _def_ap3_p2 _def_ap4_p2 _def_ap5_p2

_def_ap0_p2
_def_ap1_p2
_def_ap3_p2
_def_ap4_p2
_def_ap5_p2
   player2:
   %00011000
   %01111110
   %01111110
   %00011000
   %00111100
end
   goto _player2_end_def

_def_ap2_p2
   player2:
   %0011000
   %0011010
   %0111110
   %0111110
   %0011010
   %0011000
end

_player2_end_def

   on attack_position goto _def_ap0_p3 _def_ap1_p3 _def_ap2_p3 _def_ap3_p3 _def_ap4_p3 _def_ap5_p3

_def_ap0_p3
_def_ap1_p3
_def_ap3_p3
_def_ap4_p3
_def_ap5_p3
   player3:
   %00011000
   %01111110
   %01111110
   %00011000
   %00111100
end
   goto _player3_end_def

_def_ap2_p3
   player3:
   %0011000
   %0011010
   %0111110
   %0111110
   %0011010
   %0011000
end

_player3_end_def

   on attack_position goto _def_ap0_p4 _def_ap1_p4 _def_ap2_p4 _def_ap3_p4 _def_ap4_p4 _def_ap5_p4

_def_ap0_p4
_def_ap1_p4
_def_ap3_p4
_def_ap4_p4
_def_ap5_p4
   player4:
   %00011000
   %01111110
   %01111110
   %00011000
   %00111100
end
   goto _player4_end_def

_def_ap2_p4
   player4:
   %0011000
   %0011010
   %0111110
   %0111110
   %0011010
   %0011000
end

_player4_end_def

; on plane_tpye5 goto xxxx, yyy
   
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
   %00111100
   %00011000
   %01111110 
   %01111110
   %00011000
end

   if !collision(player1, missile0) then goto _skip_collision
   
   score = score + 50

   on attack_position goto _collision_ap0 _collision_ap1 _collision_ap2 _collision_ap3 _collision_ap4 _collision_ap5

_collision_ap0
_collision_ap1
_collision_ap2
_collision_ap3
_collision_ap4
_collision_ap5
   temp1 = player1y + 5 : temp2 = player1y - 5
   if missile0y > temp2 && missile0y < temp1 then player1y = 200 : goto _end_collision

   temp1 = player2y + 5 : temp2 = player2y - 5
   if missile0y > temp2 && missile0y < temp1 then player2y = 200 : goto _end_collision

   temp1 = player3y + 5 : temp2 = player3y - 5
   if missile0y > temp2 && missile0y < temp1 then player3y = 200 : goto _end_collision

   temp1 = player4y + 5 : temp2 = player4y - 5
   if missile0y > temp2 && missile0y < temp1 then player4y = 200 : goto _end_collision

   temp1 = player5y + 5 : temp2 = player5y - 5 ; Why check player 5? we had a collision and the others have not been hit!
   if missile0y > temp2 && missile0y < temp1 then player5y = 100

_end_collision

   missile0y = 0

_skip_collision


   rem ################### movement 
   if joy0up && player0y < 40 then player0y = player0y + 1 : goto jump
   if joy0down && player0y > 8 then player0y = player0y - 1 : goto jump
   if joy0left && player0x > 0 then player0x = player0x - 1 : goto jump
   if joy0right && player0x < 152 then player0x = player0x + 1
jump


   if missile0y > 88 then missile0y = 0
   if missile0y > 1 then _skip_new_shot
   if joy0fire then missile0y = player0y + 1 : missile0x = player0x + 5
_skip_new_shot
   if ! missile0y then _check_enemy_shot
   missile0y = missile0y + 3
   if framecounter{0} then missile0x = missile0x - 2 else missile0x = missile0x + 2

_check_enemy_shot
;  if player1x = player0x && n = 0 && player1y < 20 then missile1x = player1x + 5 : missile1y = player1y + 2 :  n = 1


_plane_loop


   rem ################### attack speed

   if framecounter{0} || PF1pointer < attackzone_start then goto _skip_plane_movement
;   goto _skip_plane_movement

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Plane attack movement"
   on attack_position goto _movement_ap_0 _movement_ap_1 _movement_ap_2 _movement_ap_3 _movement_ap_4 _movement_ap_5
   
_movement_ap_0
_movement_ap_1
; attack formation 0 and 1, plane 1
   if player1y < 1 then player1y = 200
   if player1y = 200 then _skip_movement_ap0_p1
   player1y = player1y - planey_speed 
   if player1y < 71 then _skip_movement_ap0_p1
   if player1x > player0x then player1x = player1x - planex_speed_1 : goto _skip_movement_ap0_p1
   if player1x < player0x then player1x = player1x + planex_speed_1
_skip_movement_ap0_p1
   
; attack formation 0, plane 2
   if player2y < 1 then player2y = 200
   if player2y = 200 then _skip_movement_ap0_p2
   player2y = player2y - planey_speed 
   if player2y < 71 then _skip_movement_ap0_p2
   if player2x > player0x then player2x = player2x - planex_speed_1 : goto _skip_movement_ap0_p2
   if player2x < player0x then player2x = player2x + planex_speed_1
_skip_movement_ap0_p2

; attack formation 0, plane 3
   if player3y < 1 then player3y = 200
   if player3y = 200 then _skip_movement_ap0_p3
   player3y = player3y - planey_speed
   if player3y < 71 then _skip_movement_ap0_p3
   if player3x > player0x then player3x = player3x - planex_speed_1 : goto _skip_movement_ap0_p3
   if player3x < player0x then player3x = player3x + planex_speed_1
_skip_movement_ap0_p3

; attack formation 0, plane 4
   if player4y < 1 then player4y = 200
   if player4y = 200 then _skip_movement_ap0_p4
   player4y = player4y - planey_speed
   if player4y < 71 then _skip_movement_ap0_p4
   if player4x > player0x then player4x = player4x - planex_speed_1 : goto _skip_movement_ap0_p4
   if player4x < player0x then player4x = player4x + planex_speed_1
_skip_movement_ap0_p4

; attack formation 0, plane 5
   if player5y < 1 then player5y = 100
   if player5y = 100 then _skip_movement_ap0_p5
   player5y = player5y + planey_speed 
_skip_movement_ap0_p5
   goto _skip_movement_ap


_movement_ap_2
   if framecounter{1} then temp1 = 1 else temp1 = 0

; attack formation 2, plane 1
   if player1x > 160 then player1y = 200
   if player1y = 200 then _skip_movement_ap2_p1
   player1x = player1x + planex_speed_2 : player1y = player1y - temp1
_skip_movement_ap2_p1
   
; attack formation 2, plane 2
   if player2x > 160 then player2y = 200
   if player2y = 200 then _skip_movement_ap2_p2
   player2x = player2x + planex_speed_2 : player2y = player2y - temp1
_skip_movement_ap2_p2

; attack formation 2, plane 3
   if player3x < 2 then player3y = 200
   if player3y = 200 then _skip_movement_ap2_p3
   player3x = player3x - planex_speed_2 : player3y = player3y - temp1
_skip_movement_ap2_p3

; attack formation 2, plane 4
   if player4x < 2 then player4y = 200
   if player4y = 200 then _skip_movement_ap2_p4
   player4x = player4x - planex_speed_2 : player4y = player4y - temp1
_skip_movement_ap2_p4

; attack formation 2, plane 5
   if player5y < 1 then player5y = 100
   if player5y = 100 then _skip_movement_ap2_p5
   player5y = player5y + planey_speed 
_skip_movement_ap2_p5
   goto _skip_movement_ap

_movement_ap_3
_movement_ap_4
_movement_ap_5
; attack formation 0 and 1, plane 1
   if player1y < 1 then player1y = 200
   if player1y = 200 then _skip_movement_ap5_p1
   player1y = player1y - planey_speed 
   if player1y < 71 then _skip_movement_ap5_p1
   if player1x > player0x then player1x = player1x - planex_speed_1 : goto _skip_movement_ap5_p1
   if player1x < player0x then player1x = player1x + planex_speed_1
_skip_movement_ap5_p1
   
; attack formation 0, plane 2
   if player2y < 1 then player2y = 200
   if player2y = 200 then _skip_movement_ap5_p2
   player2y = player2y - planey_speed 
   if player2y < 71 then _skip_movement_ap5_p2
   if player2x > player0x then player2x = player2x - planex_speed_1 : goto _skip_movement_ap5_p2
   if player2x < player0x then player2x = player2x + planex_speed_1
_skip_movement_ap5_p2

; attack formation 0, plane 3
   if player3y < 1 then player3y = 200
   if player3y = 200 then _skip_movement_ap5_p3
   player3y = player3y - planey_speed
   if player3y < 71 then _skip_movement_ap5_p3
   if player3x > player0x then player3x = player3x - planex_speed_1 : goto _skip_movement_ap5_p3
   if player3x < player0x then player3x = player3x + planex_speed_1
_skip_movement_ap5_p3

; attack formation 0, plane 4
   if player4y < 1 then player4y = 200
   if player4y = 200 then _skip_movement_ap5_p4
   player4y = player4y - planey_speed
   if player4y < 71 then _skip_movement_ap5_p4
   if player4x > player0x then player4x = player4x - planex_speed_1 : goto _skip_movement_ap5_p4
   if player4x < player0x then player4x = player4x + planex_speed_1
_skip_movement_ap5_p4

; attack formation 0, plane 5
   if player5y < 1 then player5y = 100
   if player5y = 100 then _skip_movement_ap5_p5
   player5y = player5y + planey_speed 
_skip_movement_ap5_p5


_skip_movement_ap

   ; todo start new attack based on PF1pointer! All previous attacks should have been ended by then!
   if player1y = 200 && player2y = 200 && player3y = 200 && player4y = 200 && player5y = 100 then gosub build_attack_position

_skip_plane_movement
;#endregion

; pfscroll down

   if framecounter < 10 then _skip_scrolling
   if PF1pointer > carrier_end && framecounter < 25 then _skip_scrolling
   PF1pointer = PF1pointer + 1
   PF2pointer = PF2pointer + 1
   if PF1pointer = map_end then PF1pointer = 0 : PF2pointer = 0 : stage = 0 : level = level + 1: gosub build_attack_position ; : player1y = 0 : player2y = 0 : player3y = 0 : player4y = 0 : player5y = 0
   framecounter = 0

_skip_scrolling

   if PF1pointer < carrier_end then COLUPF = _04 else COLUPF =  _C8
; CTRLPF = 0
; PF0 = %11110000

   drawscreen
   goto main
;#endregion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Subroutines and Functions"

build_attack_position
   attack_position = attack_position + 1
   if attack_position > 5 then attack_position = 0 : stage = stage + 1

   on attack_position goto _position_0 _position_1 _position_2 _position_3 _position_4 _position_5

_position_0
   player1x = 40 : player4x = 20 : player3x = 110 : player2x = 110 : player5x = 50
   player1y = 88
   player2y = 98
   player3y = 108
   player4y = 118
   player5y = 100 ; big plane deactivated

   _COLUP1 = _D6
   COLUP2 = _D6
   COLUP3 = _D6
   COLUP4 = _D6
   return

_position_1
   player1x = 40 : player2x = 30 : player3x = 110 : player4x = 20 : player5x = 50
   player1y = 88
   player2y = 98
   player3y = 108
   player4y = 118
   player5y = 100
   _COLUP1 = _D4
   COLUP2 = _D6
   COLUP3 = _D6
   COLUP4 = _D6
   return

_position_2
   player1x = 0 : player2x = 0 : player3x = 160 : player4x = 160 : player5x = 50
   player1y = 75
   player2y = 65
   player3y = 55
   player4y = 45
   player5y = 100
   _COLUP1 = _D6
   COLUP2 = _D6
   COLUP3 = _D6
   COLUP4 = _D6
   if stage > 2 then _NUSIZ1 = %00001011 : NUSIZ2 = %00001011 : NUSIZ3 = %00000011 : NUSIZ4 = %00000011 else _NUSIZ1 = %00001000 : NUSIZ2 = %00001000

   return

_position_3
_position_4
_position_5
   player1x = 110 : player2x = 110 : player3x = 110 : player4x = 110 : player5x = 50
   player1y = 88
   player2y = 98
   player3y = 108
   player4y = 118
   player5y = 1
   _COLUP1 = _D4
   COLUP5 = _D4
   _NUSIZ1 = %00000000
   NUSIZ2  = %00000000
   NUSIZ3  = %00000000
   NUSIZ4  = %00000000
   NUSIZ5 = %00000111

   return

;#endregion

;#endregion

   bank 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 2 Titlescreen"

titlescreen_start
   COLUBK = _00
   _Ch0_Counter = 0 : _Ch1_Counter = 0 : _Ch0_Duration = 1 : _Ch1_Duration = 1

titlescreen            

   framecounter = framecounter + 1
   if framecounter{0} then bmp_96x2_2_index = 25 else  bmp_96x2_2_index = 0

   gosub _Play_Titlescreen_Music bank3

   gosub titledrawscreen

   if joy0fire then _Ch0_Counter = 0 : AUDV0 = 0 : _Ch1_Counter = 0 : AUDV1 = 0 : goto start bank1
   goto titlescreen

   asm
   include "titlescreen/asm/titlescreen.asm"
end
;#endregion

   bank 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 3 Titlescreen Music"

_Play_Titlescreen_Music


   _Ch0_Duration = _Ch0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if duration counter is greater
   ;  than zero
   ;
   if _Ch0_Duration then _Skip_Ch0_Sound

   temp4 = _Titlescreen_Music_Ch0[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto _Restart_Titlescreen_Music

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _Titlescreen_Music_Ch0[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _Titlescreen_Music_Ch0[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   _Ch0_Duration = _Titlescreen_Music_Ch0[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

_Skip_Ch0_Sound


   _Ch1_Duration = _Ch1_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if duration counter is greater
   ;  than zero
   ;
   if _Ch1_Duration then return

   temp4 = _Titlescreen_Music_Ch1[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then _Restart_Titlescreen_Music

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _Titlescreen_Music_Ch1[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _Titlescreen_Music_Ch1[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   _Ch1_Duration = _Titlescreen_Music_Ch1[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   return

_Restart_Titlescreen_Music
   _Ch0_Counter = 0 : AUDV0 = 0 : _Ch1_Counter = 0 : AUDV1 = 0 : _Ch0_Duration = 160 : _Ch1_Duration = 160
   return

;#region "Titlescreen Musik Data"

   data _Titlescreen_Music_Ch1
   0, 0, 0
   7
   7, 1, 25
   26
   7, 6, 16
   24
   7, 1, 25
   14
   2, 1, 25
   2
   7, 1, 25
   16
   7, 6, 16
   16
   7, 1, 25
   24
   7, 6, 16
   24
   7, 1, 25
   14
   2, 1, 25
   2
   7, 1, 25
   16
   7, 6, 16
   16
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 25
   16
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   8
   7, 6, 25
   16
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   8
   7, 6, 25
   16
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   8
   7, 6, 25
   16
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   6
   2, 1, 26
   2
   7, 1, 26
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 24
   16
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   6
   2, 1, 25
   2
   7, 1, 25
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 28
   16
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   6
   2, 1, 29
   2
   7, 1, 29
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   6
   2, 1, 22
   2
   7, 1, 22
   8
   7, 6, 21
   16
   7, 1, 22
   6
   255
end

   data _Titlescreen_Music_Ch0
   0, 0, 0
   7
   13, 4, 23
   8
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   14
   2, 4, 23
   2
   13, 4, 23
   14
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   14
   2, 4, 23
   2
   13, 4, 23
   14
   2, 4, 23
   2
   13, 4, 23
   6
   2, 4, 23
   2
   13, 4, 23
   8
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 4, 31
   128
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   144
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 4, 27
   192
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 4, 27
   128
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   144
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 10
   8
   13, 4, 27
   8
   13, 4, 24
   192
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 4, 31
   128
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   144
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 4, 27
   192
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 4, 27
   128
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   144
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 10
   8
   13, 4, 27
   8
   13, 4, 24
   192
   13, 12, 10
   24
   13, 4, 24
   24
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   24
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   16
   13, 4, 24
   8
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   16
   13, 4, 24
   8
   13, 12, 10
   24
   13, 4, 24
   24
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   16
   13, 4, 24
   8
   13, 4, 19
   96
   13, 12, 17
   24
   13, 12, 12
   24
   13, 12, 11
   8
   13, 4, 29
   8
   13, 12, 11
   8
   13, 4, 31
   24
   13, 12, 11
   8
   13, 4, 29
   8
   13, 12, 11
   8
   13, 4, 31
   16
   13, 12, 12
   8
   13, 12, 11
   8
   13, 4, 29
   8
   13, 12, 11
   8
   13, 4, 31
   16
   13, 12, 12
   8
   13, 4, 31
   24
   13, 12, 13
   24
   13, 12, 12
   24
   13, 12, 10
   8
   13, 4, 31
   8
   13, 4, 27
   8
   13, 4, 31
   158
   2, 4, 31
   2
   13, 4, 31
   14
   2, 4, 31
   2
   13, 4, 31
   6
   2, 4, 31
   2
   13, 4, 31
   8
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 4, 31
   128
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   144
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 4, 27
   192
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 4, 27
   128
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   144
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 10
   8
   13, 4, 27
   8
   13, 4, 24
   192
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 4, 31
   128
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   144
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 12, 15
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 4, 27
   192
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 4, 27
   128
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   144
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   6
   2, 12, 18
   2
   13, 12, 18
   8
   13, 12, 13
   8
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 12
   8
   13, 4, 31
   8
   13, 12, 10
   16
   13, 12, 13
   16
   13, 12, 10
   8
   13, 4, 27
   8
   13, 4, 24
   192
   13, 12, 10
   24
   13, 4, 24
   24
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   24
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   16
   13, 4, 24
   8
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   16
   13, 4, 24
   8
   13, 12, 10
   24
   13, 4, 24
   24
   13, 4, 21
   8
   13, 4, 18
   8
   13, 4, 21
   8
   13, 4, 19
   16
   13, 4, 24
   8
   13, 4, 19
   96
   13, 12, 17
   24
   13, 12, 12
   24
   13, 12, 11
   8
   13, 4, 29
   8
   13, 12, 11
   8
   13, 4, 31
   24
   13, 12, 11
   8
   13, 4, 29
   8
   13, 12, 11
   8
   13, 4, 31
   16
   13, 12, 12
   8
   13, 12, 11
   8
   13, 4, 29
   8
   13, 12, 11
   8
   13, 4, 31
   16
   13, 12, 12
   8
   13, 4, 31
   24
   13, 12, 13
   24
   13, 12, 12
   24
   13, 12, 10
   8
   13, 4, 31
   8
   13, 4, 27
   8
   13, 4, 31
   158
   2, 4, 31
   2
   13, 4, 31
   14
   2, 4, 31
   2
   13, 4, 31
   6
   2, 4, 31
   2
   13, 4, 31
   8
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   16
   13, 4, 31
   128
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   6
   2, 12, 20
   2
   13, 12, 20
   8
   13, 12, 15
   8
   13, 12, 13
   8
   13, 12, 11
   8
   13, 12, 12
   144
   13, 12, 20
   6
   255
end

;#endregion

;#endregion

   bank 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 4 bB Drawscreen"

   inline 6lives.asm
;#endregion