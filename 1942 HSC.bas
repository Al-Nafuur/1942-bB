; Orignial code by AtariAge user homerhomer (https://atariage.com/forums/profile/28656-homerhomer/)
; AA topic: https://atariage.com/forums/topic/176639-1942-wip/
; Titlescreen Music contributed by AtariAge user Pat Brady (https://atariage.com/forums/profile/24906-pat-brady/) 

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
   set smartbranching on
   set optimization inlinerand
   set optimization noinlinedata
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
   const takeoff_sound_s   = takeoff_point  + 5
   const carrier_end       = 41
   const attackzone_start  = carrier_end + 5
   const map_end           = map_length - screen_v_res - 1

   const carrier_color       = _04
   const island_gras_color   = _C8
   const island_sand_color   = _EE
   const island_jungle_color = _C6

   const plane_1_parking_point = 200
   const plane_2_parking_point = 200
   const plane_3_parking_point = 200
   const plane_4_parking_point = 200
   const plane_5_parking_point = 150


   ; sprite pointer
   const _Small_Plane_down_high  = >Small_Plane_down
   const _Small_Plane_down_low   = <Small_Plane_down

   const _Small_Plane_up_high    = >Small_Plane_up
   const _Small_Plane_up_low     = <Small_Plane_up

   const _Small_Plane_lr_high    = >_Small_Plane_lr
   const _Small_Plane_lr_low     = <_Small_Plane_lr

   const _Middle_Plane_down_high = >_Middle_Plane_down
   const _Middle_Plane_down_low  = <_Middle_Plane_down

   const _Middle_Plane_up_high   = >_Middle_Plane_up
   const _Middle_Plane_up_low    = <_Middle_Plane_up

   const _Middle_Plane_lr_high   = >_Middle_Plane_lr
   const _Middle_Plane_lr_low    = <_Middle_Plane_lr

   const _Big_Plane_down_high    = >_Big_Plane_down
   const _Big_Plane_down_low     = <_Big_Plane_down

   const _Big_Plane_up_high      = >_Big_Plane_up
   const _Big_Plane_up_low       = <_Big_Plane_up

   const _Carrier_88_high        = >_Carrier_88
   const _Carrier_88_low         = <_Carrier_88

   const _Carrier_Runway_high    = >_Carrier_Runway
   const _Carrier_Runway_low     = <_Carrier_Runway

   const _Carrier_Tower_high    = >_Carrier_Tower
   const _Carrier_Tower_low     = <_Carrier_Tower
   

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

   dim playerpointerlo  = player1pointerlo
   dim playerpointerhi  = player1pointerhi

   dim _Ch0_Counter     = a
   dim _Ch0_Duration    = b
   dim _Ch0_Sound       = c
   dim _Ch1_Duration    = d

   dim framecounter     = e
   dim bmp_96x2_2_index = f
   dim attack_position  = g
   dim stage            = h
   dim level            = i
   dim plane_type       = j
   dim plane_type2      = k
   dim plane_type3      = l
   dim plane_type4      = m
   dim plane_type5      = n
   dim _NUSIZ0          = o

   dim game_flags       = z
   dim _Bit0_mirror_pf  = z

   ; Slocum Player RAM variables (reuses game loop variables!)
   dim temp             = temp1
   dim temp16L          = temp2   ; 16 bit temp
   dim temp16H          = temp3
   dim note1            = j
   dim note2            = k
   dim vol1             = l
   dim vol2             = m
   dim sound1           = n
   dim sound2           = o
   dim beat             = p       ; Metrenome stuff
   dim tempoCount       = q
   dim measure          = r       ; Special attenuation
   dim atten            = s

;#endregion


   bank 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 1 Game Logic"

   scorecolor = _0E

   goto titlescreen_start bank2
 

start

   rem initial variables setup
   missile0y = 0 : level = 0 : stage = 0 : framecounter = 0 : attack_position = 0
   player0x = 76 : player0y = 10
   lives = 64 : score = 0
   game_flags = 1

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
   .............XXX
   ..........XXXXXX
   ..........XXXXXX
   ........XXXXXXXX
   ........XXXXXXXX
   ........XXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   .......XXXXXXXXX
   ........XXXXXXXX
   ........XXXXXXXX
   ........XXXXXXXX
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

   COLUPF = carrier_color

   _NUSIZ0 = %00000000


   goto  __BG_Music_Setup_01 bank3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Mainloop"
main
   if switchreset then goto titlescreen_start bank2

   NUSIZ0 = _NUSIZ0


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
 
   lives:
   %00111100
   %00011000
   %01111110 
   %01111110
   %00011000
end

   if PF1pointer < carrier_end then _Ch1_Duration = 30 : AUDV0 = 0 : AUDV1 = 0 : goto _skip_player0_collision

   if !collision(player1, missile0) then goto _skip_missile0_collision
   
   score = score + 50 :  _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0

   temp1 = player1y + 5 : temp2 = player1y - 5
   if missile0y > temp2 && missile0y < temp1 then player1y = plane_1_parking_point : goto _end_collision

   temp1 = player2y + 5 : temp2 = player2y - 5
   if missile0y > temp2 && missile0y < temp1 then player2y = plane_2_parking_point : goto _end_collision

   temp1 = player3y + 5 : temp2 = player3y - 5
   if missile0y > temp2 && missile0y < temp1 then player3y = plane_3_parking_point : goto _end_collision

   temp1 = player4y + 5 : temp2 = player4y - 5
   if missile0y > temp2 && missile0y < temp1 then player4y = plane_4_parking_point : goto _end_collision

   temp1 = player5y + 5 : temp2 = player5y - 5 ; Why check player 5? we had a collision and the others have not been hit!
   if missile0y > temp2 && missile0y < temp1 then player5y = plane_5_parking_point

_end_collision

   missile0y = 0

_skip_missile0_collision

   if !collision(player0, player1) then goto _skip_player0_collision
   _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   ; set game state to player0 explosion, skip game loop and switch back to titlescreen when lives are empty
   if lives < 32 then goto titlescreen_start bank2 else lives = lives - 32 : player0x = 76 : player0y = 10 : gosub build_attack_position

_skip_player0_collision


   if PF1pointer > carrier_end then _select_planes

   if PF1pointer = takeoff_sound_s && framecounter = 5 then _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   
   if PF1pointer <> takeoff_point then _skip_carrier_superstructures

   if framecounter > 1 then goto _skip_select_planes
   
    _COLUP1 = _0E : COLUP2 = _0E : COLUP3 = _0E : COLUP4 = _0E : COLUP5 = _02

    player1pointerlo = _Carrier_88_low     : player1pointerhi = _Carrier_88_high     : player1height  = 12 : _NUSIZ1 = 7 : player1x = 69 : player1y = 165
    player2pointerlo = _Carrier_Runway_low : player2pointerhi = _Carrier_Runway_high : player2height  = 15  : NUSIZ2 = 5 : player2x = 78 : player2y = 135
    player3pointerlo = _Carrier_Runway_low : player3pointerhi = _Carrier_Runway_high : player3height  = 15  : NUSIZ3 = 5 : player3x = 78 : player3y = 100
    player4pointerlo = _Carrier_Runway_low : player4pointerhi = _Carrier_Runway_high : player4height  = 15  : NUSIZ4 = 5 : player4x = 78 : player4y =  70
    player5pointerlo = _Carrier_Tower_low  : player5pointerhi = _Carrier_Tower_high  : player5height  = 29  : NUSIZ5 = 5 : player5x = 105 : player5y = 110
    
    goto _skip_select_planes

_skip_carrier_superstructures
   if PF1pointer = carrier_end then player1y = plane_1_parking_point : player2y = plane_2_parking_point : player3y = plane_3_parking_point : player4y = plane_4_parking_point : player5y = plane_5_parking_point

   goto _skip_select_planes

_select_planes
   for temp1 = 0 to 4
      temp2 = plane_type[temp1] / 4

      on temp2 goto _small_plane_down _small_plane_up _small_plane_lr _middle_plane_down  _middle_plane_up _middle_plane_lr _big_plane_down _big_plane_up

_small_plane_down
      playerpointerlo[temp1] = _Small_Plane_down_low
      playerpointerhi[temp1] = _Small_Plane_down_high
      spriteheight[temp1]    = 6
      goto _next_plane_type

_small_plane_up
      playerpointerlo[temp1] = _Small_Plane_up_low
      playerpointerhi[temp1] = _Small_Plane_up_high
      spriteheight[temp1]    = 6
      goto _next_plane_type

_small_plane_lr
      playerpointerlo[temp1] = _Small_Plane_lr_low
      playerpointerhi[temp1] = _Small_Plane_lr_high
      spriteheight[temp1]    = 7
      goto _next_plane_type

_middle_plane_down
      playerpointerlo[temp1] = _Middle_Plane_down_low
      playerpointerhi[temp1] = _Middle_Plane_down_high
      spriteheight[temp1]    = 8
      goto _next_plane_type

_middle_plane_up
      playerpointerlo[temp1] = _Middle_Plane_down_low
      playerpointerhi[temp1] = _Middle_Plane_down_high
      spriteheight[temp1]    = 8
      goto _next_plane_type

_middle_plane_lr
      playerpointerlo[temp1] = _Middle_Plane_lr_low
      playerpointerhi[temp1] = _Middle_Plane_lr_high
      spriteheight[temp1]    = 9
      goto _next_plane_type

_big_plane_down
      playerpointerlo[temp1] = _Big_Plane_down_low
      playerpointerhi[temp1] = _Big_Plane_down_high
      spriteheight[temp1]    = 9
      goto _next_plane_type

_big_plane_up
      playerpointerlo[temp1] = _Big_Plane_up_low
      playerpointerhi[temp1] = _Big_Plane_up_high
      spriteheight[temp1]    = 9


_next_plane_type
   next

_skip_select_planes

   rem ################### movement 
   if joy0up && player0y < 40 then player0y = player0y + 1 : goto jump
   if joy0down && player0y > 10 then player0y = player0y - 1 : goto jump
   if joy0left && player0x > 0 then player0x = player0x - 1 : goto jump
   if joy0right && player0x < 152 then player0x = player0x + 1
   
jump


   if missile0y > 88 then missile0y = 0
   if missile0y > 1 || PF1pointer < carrier_end then _skip_new_shot
   if joy0fire then missile0y = player0y + 1 : missile0x = player0x + 5 : if _Ch0_Sound = 0 then _Ch0_Sound = 2 : _Ch0_Duration = 1 : _Ch0_Counter = 0
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

   ; todo start new attack based on PF1pointer and framecounter! All previous attacks should have been ended by then!
   if player1y = plane_1_parking_point && player2y = plane_2_parking_point && player3y = plane_3_parking_point && player4y = plane_4_parking_point && player5y = plane_5_parking_point then gosub build_attack_position : goto _skip_plane_movement

   if framecounter{1} then temp2 = 1 else temp2 = 0

   temp1 = 0
   
_plane_movement_loop_start
   temp3 = plane_type[temp1] & %00000011
   temp4 = plane_parking_point[temp1]

   on temp3 goto _plane_moves_left _plane_moves_right _plane_moves_down _plane_moves_up

_plane_moves_right
   if NewSpriteX[temp1] > 153 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then goto _check_next_plane
   NewSpriteX[temp1] = NewSpriteX[temp1] + planex_speed_2 : NewSpriteY[temp1] = NewSpriteY[temp1] - temp2

   if NewSpriteX[temp1] < 121 then goto _check_next_plane
   if NewNUSIZ[temp1] = %00001011 && NewSpriteX[temp1] > 120 then NewNUSIZ[temp1] = %00001001
   if NewNUSIZ[temp1] = %00001001 && NewSpriteX[temp1] > 136 then NewNUSIZ[temp1] = %00001000
   goto _check_next_plane

_plane_moves_left
   if !NewNUSIZ[temp1] && NewSpriteX[temp1] < 2 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then goto _check_next_plane
   NewSpriteX[temp1] = NewSpriteX[temp1] - planex_speed_2 : NewSpriteY[temp1] = NewSpriteY[temp1] - temp2

   if NewSpriteX[temp1] < 254 then goto _check_next_plane
   if NewNUSIZ[temp1] then NewNUSIZ[temp1] = NewNUSIZ[temp1] / 2 : NewSpriteX[temp1] = NewSpriteX[temp1] + 16

   goto _check_next_plane

_plane_moves_down
   temp3 = NewSpriteY[temp1] : temp5 = rand
   if temp3 = temp4 then _check_next_plane
   if temp3 < 2 then NewSpriteY[temp1] = temp4 : goto _check_next_plane
   if temp3 = 40 && temp5 < 128 then plane_type[temp1] = plane_type[temp1] + 5 : goto _check_next_plane
   NewSpriteY[temp1] = temp3 - planey_speed 
   if temp3 < 71 then _check_for_escape_move
   if NewSpriteX[temp1] > player0x then NewSpriteX[temp1] = NewSpriteX[temp1] - planex_speed_1 : goto _check_next_plane
   if NewSpriteX[temp1] < player0x then NewSpriteX[temp1] = NewSpriteX[temp1] + planex_speed_1 : goto _check_next_plane
_check_for_escape_move
   if temp3 > 39 || temp5 < 128 then _check_next_plane
   if NewSpriteX[temp1] > player0x && NewSpriteX[temp1] < 153 then NewSpriteX[temp1] = NewSpriteX[temp1] + planex_speed_1 else NewSpriteX[temp1] = NewSpriteX[temp1] - planex_speed_1

   goto _check_next_plane



_plane_moves_up
   if NewSpriteY[temp1] > 100 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then _check_next_plane
   NewSpriteY[temp1] = NewSpriteY[temp1] + planey_speed 


_check_next_plane
   temp1 = temp1 + 1
   if temp1 < 5 then goto _plane_movement_loop_start



_skip_plane_movement
;#endregion

; pfscroll down

   if framecounter < 10 then _skip_scrolling
   if PF1pointer > carrier_end && framecounter < 25 then _skip_scrolling
   if PF1pointer > carrier_end then _skip_carrier_superstructures_scrolling
   _Ch1_Duration = 30 : AUDV0 = 0 : AUDV1 = 0
   for temp1 = 0 to 4
   temp4 = plane_parking_point[temp1]
   if NewSpriteY[temp1] < temp4 then NewSpriteY[temp1] = NewSpriteY[temp1] - 8
   if player1height[temp1] > 8 && player1height[temp1] > NewSpriteY[temp1] then  NewSpriteY[temp1] = NewSpriteY[temp1] + 8 : player1height[temp1] = player1height[temp1] - 8 : playerpointerlo[temp1] = playerpointerlo[temp1] + 8
   if NewSpriteY[temp1] < 2 || NewSpriteY[temp1] > temp4 then NewSpriteY[temp1] = temp4
   next

_skip_carrier_superstructures_scrolling
   PF1pointer = PF1pointer + 1
   PF2pointer = PF2pointer + 1
   if PF1pointer <> map_end then _skip_playfield_end
   if level && _Bit0_mirror_pf{0} then CTRLPF = %00000000 : game_flags = game_flags ^ 1 : PF1pointer = attackzone_start : PF2pointer = attackzone_start : COLUPF = island_sand_color : goto _skip_playfield_end
   PF1pointer = 0 : PF2pointer = 0 : stage = 0 : level = level + 1 : game_flags = game_flags ^ 1 : CTRLPF = %00000001 : COLUPF = carrier_color
   
   player1y = plane_1_parking_point : player2y = plane_2_parking_point : player3y = plane_3_parking_point : player4y = plane_4_parking_point : player5y = plane_5_parking_point

_skip_playfield_end
   framecounter = 0
   if PF1pointer = carrier_end then COLUPF = island_gras_color


_skip_scrolling

; CTRLPF = 0
; PF0 = %11110000
   goto _Play_In_Game_Music bank3

;#endregion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Subroutines and Functions"

build_attack_position
   temp1 = _attack_position_data[attack_position]
   if temp1 = 255 then attack_position = 0 : stage = stage + 1

   for temp1 = 0 to 4
      plane_type[temp1] = _attack_position_data[attack_position]
      attack_position = attack_position + 1
   next
   for temp1 = 0 to 4
      NewSpriteX[temp1] = _attack_position_data[attack_position]
      attack_position = attack_position + 1
   next
   for temp1 = 0 to 14  ; fill NewSpriteY, NewNUSIZ and  NewCOLUP1
      NewSpriteY[temp1] = _attack_position_data[attack_position]
      attack_position = attack_position + 1
   next

   return

;#endregion

 rem plane_type                                          NewSpriteX          NewSpriteY          NewNUSIZ       NewCOLUP
   data _attack_position_data
   %00000010, %00000010, %00000010, %00000010, %00011111, 40,110,110, 20, 50, 88, 98,108,118,100, 0, 0, 0, 0, 0,_D6,_D6,_D6,_D6,_D2
   %00001110, %00000010, %00000010, %00000010, %00011111, 40, 30,110, 20, 50, 88, 98,108,118,100, 0, 0, 0, 0, 0,_D4,_D6,_D6,_D6,_D2
   %00001001, %00001001, %00001000, %00001000, %00011111,  0,  0,153,153, 50, 75, 65, 55, 45,100, 8, 8, 0, 0, 0,_D6,_D6,_D6,_D6,_D4
   %00000010, %00000010, %00000010, %00000010, %00011111,110,110,110,110, 50, 88, 98,108,118,  1, 0, 0, 0, 0, 7,_D6,_D6,_D6,_D6,_D4
   %00001001, %00001001, %00001000, %00001000, %00011111,  0,  0,153,153, 50, 75, 65, 55, 45,100, 9, 9, 1, 1, 0,_D6,_D6,_D6,_D6,_D4
   %00000010, %00000010, %00000010, %00000010, %00011111, 20,110, 20,110, 50, 88, 98,108,118,  1, 1, 1, 1, 0, 7,_D4,_D6,_D6,_D6,_D4
   %00000010, %00000010, %00000010, %00000010, %00011111, 75, 20,110, 90, 50, 88, 98,108,118,  1,11,11, 0, 0, 7,_D4,_D6,_D6,_D6,_D4

   255
end

   data plane_parking_point
   plane_1_parking_point
   plane_2_parking_point
   plane_3_parking_point
   plane_4_parking_point
   plane_5_parking_point
end

;#endregion

   bank 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 2 Titlescreen"

titlescreen_start
   COLUBK = _00

titlescreen            

   framecounter = framecounter + 1
   if framecounter{0} then bmp_96x2_2_index = 25 else  bmp_96x2_2_index = 0

   gosub _Play_Titlescreen_Music bank3

   gosub titledrawscreen

   if joy0fire then AUDV0 = 0 : AUDV1 = 0 : goto start bank1
   goto titlescreen

   asm
   include "titlescreen/asm/titlescreen.asm"
end
;#endregion

   bank 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 3 Music and Sound effects"

   inline song.h
   inline songplay.h

_Play_Titlescreen_Music
   asm
   jsr songPlayer
end
   return

_Play_In_Game_Music

   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if sounds are off.
   ;
   if !_Ch0_Sound then goto __Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if duration counter is greater
   ;  than zero
   ;
   if _Ch0_Duration then goto __Skip_Ch_0



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 001.
   ;
   ;  Up sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 001 isn't on.
   ;
   if _Ch0_Sound <> 1 then goto __Skip_Ch0_Sound_001

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Takeoff[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Takeoff[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Takeoff[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Takeoff[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_001

   ;***************************************************************
   ;
   ;  Channel 0 sound effect 002.
   ;
   ;  Shoot missile sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 002 isn't on.
   ;
   if _Ch0_Sound <> 2 then goto __Skip_Ch0_Sound_002

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Shoot_Miss[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_002


   ;***************************************************************
   ;
   ;  Channel 0 sound effect 003.
   ;
   ;  Up sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 003 isn't on.
   ;
   if _Ch0_Sound <> 3 then goto __Skip_Ch0_Sound_003

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Shot_Enemy[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Shot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_003

   ;***************************************************************
   ;
   ;  Channel 0 sound effect 004.
   ;
   ;  Touch enemy.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 004 isn't on.
   ;
   if _Ch0_Sound <> 4 then goto __Skip_Ch0_Sound_004

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Hit_By_Enemy[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Hit_By_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Hit_By_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Hit_By_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_004


   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Other channel 0 sound effects go here.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (This catches any mistakes.)
   ;
   goto __Skip_Ch_0



   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__Clear_Ch_0
   
   _Ch0_Sound = 0 : AUDV0 = 0



   ;***************************************************************
   ;
   ;  End of channel 0 area.
   ;
__Skip_Ch_0





   ;***************************************************************
   ;
   ;  Channel 1 background music check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips music if left difficulty switch is set to A.
   ;
   if !switchleftb then AUDV1 = 0 : goto __Skip_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 1 duration counter.
   ;
   _Ch1_Duration = _Ch1_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 1 if duration counter is greater than zero.
   ;
   if _Ch1_Duration then goto __Skip_Ch_1



   ;***************************************************************
   ;
   ;  Channel 1 background music.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = sread(_SD_Music01)

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __BG_Music_Setup_01

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   temp5 = sread(_SD_Music01)
   temp6 = sread(_SD_Music01)

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = sread(_SD_Music01)



   ;***************************************************************
   ;
   ;  End of channel 1 area.
   ;
__Skip_Ch_1

   drawscreen
   goto main bank1

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for takeoff.
   ;
   data _SD_Takeoff
   8,3,19,2
   2,3,19,1
   8,3,19,2
   2,3,19,1
   8,3,19,2
   2,3,19,1
   8,3,19,2
   2,3,19,1
   8,3,19,2
   2,3,19,1
   8,3,19,2
   2,3,19,1
   6,3,19,2
   2,3,19,1
   6,3,19,2
   2,3,19,1
   6,3,19,2
   2,3,19,1
   6,3,19,2
   2,3,19,1
   6,3,19,2
   2,3,19,1
   6,3,19,2
   2,3,19,1
   6,3,20,2
   2,3,20,1
   6,3,20,2
   2,3,18,1
   6,3,18,2
   2,3,18,1
   6,3,16,2
   2,3,16,1
   6,3,15,2
   2,3,15,1
   6,3,15,2
   2,3,15,1
   6,3,15,2
   2,3,15,1
   6,3,15,2
   4,3,15,4
   4,3,14,16
   3,3,13,12
   2,3,13,12
   1,3,13,12
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shooting missile.
   ;
   data _SD_Shoot_Miss
   6,15,0
   1
   10,15,1
   1
   6,7,20
   1
   8,15,3
   1
   6,7,22
   1
   8,15,5
   1
   6,15,6
   1
   8,7,24
   1
   6,15,8
   1
   7,7,27
   1
   6,15,10
   1
   5,14,11
   1
   4,15,12
   1
   3,6,13
   1
   2,15,14
   1
   1,6,27
   1
   1,6,30
   8
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shot hitting enemy.
   ;
   data _SD_Shot_Enemy
   8,8,0
   1
   8,8,1
   1
   8,14,1
   1
   8,8,0
   1
   8,8,2
   1
   8,14,2
   1
   8,8,1
   1
   7,8,3
   1
   6,8,2
   1
   5,8,4
   1
   4,8,3
   1
   3,8,5
   1
   2,14,4
   4
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for touching enemy.
   ;
   data _SD_Hit_By_Enemy
   2,7,11
   2
   10,7,12
   2
   8,7,13
   2
   8,7,14
   2
   8,7,21
   8
   4,7,22
   2
   2,7,23
   1
   255
end


__BG_Music_Setup_01

  sdata _SD_Music01 = u
  9,3,0,4,  0,0,0,16
  9,3,0,4,  0,0,0,16
  9,3,0,4,  0,0,0,6,  7,3,0,4,  0,0,0,16
                      7,3,0,4,  0,0,0,6,
  9,3,0,4,  0,0,0,6,  7,3,0,4,  0,0,0,6
  9,3,0,4,  0,0,0,6,  7,3,0,4,  0,0,0,6
  9,3,0,4,  0,0,0,36

  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,26
                      6,8,4,2,  0,0,0,8
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  7,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5 ; 1 frame slow
  7,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5 ; 1 frame slow
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5 ; 1 frame slow
  7,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5,  6,8,4,2,  0,0,0,5 ; 1 frame slow
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,6,  6,8,4,2,  0,0,0,8
  7,8,4,2,  0,0,0,8,  9,3, 0,4, 0,0,0,6
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  6,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,8
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3,  6,8,4,2,  0,0,0,3
  7,8,4,2,  0,0,0,8,  7,8,4,2,  0,0,0,8
  9,3,0,4,  0,0,0,16
  7,8,4,2,  0,0,0,18
  7,8,4,2,  0,0,0,18
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,18
                      6,8,4,2,  0,0,0,8
  7,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,8
  6,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,8
  7,8,4,2,  0,0,0,18
  6,8,4,2,  0,0,0,8,  6,8,4,2,  0,0,0,8
  255
end
   _Ch1_Duration = 1

   goto __Skip_Ch_1

;#endregion

   bank 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 4 bB Drawscreen and sprites"

   inline 6lives.asm

   asm
;   align 256
end

  data Small_Plane_down
   %00011000
   %01111110
   %01111110
   %00011000
   %00111100
end

  data Small_Plane_up
   %00111100
   %00011000
   %01111110
   %01111110
   %00011000
end

  data _Small_Plane_lr
   %0011000
   %0011010
   %0111110
   %0111110
   %0011010
   %0011000
end

  data _Middle_Plane_down
   %00011000
   %11111111
   %11111111
   %00111100
   %00011000
   %00011000
   %00111100
end

  data _Middle_Plane_up
   %00111100
   %00011000
   %00011000
   %00111100
   %11111111
   %11111111
   %00011000
end

  data _Middle_Plane_lr 
   %01100000
   %01100000
   %01110001
   %11111111
   %11111111
   %01110001
   %01100000
   %01100000
end

  data _Big_Plane_down
   %01011010
   %11111111
   %11111111
   %11111111
   %00011000
   %00011000
   %00111100
   %00111100
end

  data _Big_Plane_up
   %00111100
   %00111100
   %00011000
   %00011000
   %11111111
   %11111111
   %11111111
   %01011010
end

  data _Carrier_88
   %00100010
   %01010101
   %01010101
   %01010101
   %01010101
   %00100010
   %01010101
   %01010101
   %01010101
   %01010101
   %00100010
end

  data _Carrier_Runway
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
   %00001000
end

  data _Carrier_Tower
   %01111110
   %10001001
   %11111001
   %10001001
   %10001001
   %11111001
   %10001001
   %11111111
   %11111111
   %11111111
   %11111111
   %11111111
   %11111111
   %11100111
   %11100111
   %11111111
   %11111111
   %11111111
   %11111111
   %11111111
   %11111111
   %10100101
   %10100101
   %10100101
   %10100101
   %10100101
   %10100101
   %01111110
end


;#endregion