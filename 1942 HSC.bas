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
   inline PlusROM_functions.asm

   includesfile multisprite_superchip.inc
   set smartbranching on
   set optimization inlinerand
   set optimization noinlinedata
   set kernel multisprite
   set romsize 16kSC
;   set debug cyclescore

;#region "Constants"

   ; Color constants

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
   ; Kernel and Minikernel constants
   const lives_compact  = 1
   const pfscore = 2

   ; Game constants
   const _Plane_Y_Speed  = 1
   const _Plane_X1_Speed = 1
   const _Plane_X2_Speed = 2

   const _Player0_X_Start =  76
   const _Player0_Y_Start =  25
   const _Player0_X_Max   = 152
   const _Player0_Y_Max   =  55
   const _Player0_X_Min   =   0
   const _Player0_Y_Min   =  10


   const _Screen_Vertical_Resolution = 24
   const _Pf_Pixel_Height            = 4
   const _Map_Length                 = 256
   const _Map_End                    = _Map_Length - _Screen_Vertical_Resolution - 1
   const _Map_Landingzone_Start      = 0
   const _Map_Takeoff_Point          = 25
   const _Map_Takeoff_Point_1        = _Map_Takeoff_Point + 1
   const _Map_Takeoff_Sound_Start    = _Map_Takeoff_Point + 5
   const _Map_Carrier_End            = 61
   const _Map_Attackzone_Start       = _Map_Carrier_End + 10
   const _Map_Boss_Start_up          = 178                   ; boss scrolls up
   const _Map_Boss_Start_dw          = _Map_Carrier_End + 1  ; boss scrolls down
   const _Map_Boss_End_up            = 100
   const _Map_Boss_End_dw            = 130 

   const _Color_Carrier       = _04
   const _Color_Gras_Island   = _C8
   const _Color_Sand_Island   = _EE
   const _Color_Jungle_Island = _C6

   const _Player1_Parking_Point = 200
   const _Player2_Parking_Point = 200
   const _Player3_Parking_Point = 200
   const _Player4_Parking_Point = 200
   const _Player5_Parking_Point = 150

   const _Map_Carrier    = %00001110
   const _Map_Pacific    = %10111111
   const _Map_Boss_up    = %11110001
   const _Map_Boss_down  = %11111001

   rem Playfield pointers
   const _PF1_Carrier_Boss_high    = >PF1_data0
   const _PF1_Carrier_Boss_low     = <PF1_data0
   const _PF2_Carrier_Boss_high    = >PF2_data0
   const _PF2_Carrier_Boss_low     = <PF2_data0

   const _PF1_Pacific_high         = _PF1_Carrier_Boss_high + 1
   const _PF1_Pacific_low          = <PF1_data0
   const _PF2_Pacific_high         = _PF2_Carrier_Boss_high + 1
   const _PF2_Pacific_low          = <PF2_data0

   asm
; this asm section is to prevent a strange bB compiler error!
end

   rem Sprite pointer and height
   const _Small_Plane_down_high    = >_Small_Plane_down
   const _Small_Plane_down_low     = <_Small_Plane_down
   const _Small_Plane_down_height  = _Small_Plane_down_length + 1

   const _Small_Plane_up_high      = >_Small_Plane_up
   const _Small_Plane_up_low       = <_Small_Plane_up
   const _Small_Plane_up_height    = _Small_Plane_up_length + 1

   const _Small_Plane_lr_high      = >_Small_Plane_lr
   const _Small_Plane_lr_low       = <_Small_Plane_lr
   const _Small_Plane_lr_height    = _Small_Plane_lr_length + 1

   const _Middle_Plane_down_high   = >_Middle_Plane_down
   const _Middle_Plane_down_low    = <_Middle_Plane_down
   const _Middle_Plane_down_height = _Middle_Plane_down_length + 1

   const _Middle_Plane_up_high     = >_Middle_Plane_up
   const _Middle_Plane_up_low      = <_Middle_Plane_up
   const _Middle_Plane_up_height   = _Middle_Plane_up_length + 1

   const _Middle_Plane_lr_high     = >_Middle_Plane_lr
   const _Middle_Plane_lr_low      = <_Middle_Plane_lr
   const _Middle_Plane_lr_height   = _Middle_Plane_lr_length + 1

   const _Big_Plane_down_high       = >_Big_Plane_down
   const _Big_Plane_down_low        = <_Big_Plane_down
   const _Big_Plane_down_height     = _Big_Plane_down_length + 1

   const _Big_Plane_up_high        = >_Big_Plane_up
   const _Big_Plane_up_low         = <_Big_Plane_up
   const _Big_Plane_up_height      = _Big_Plane_up_length + 1

   const _Ayako_Missile_high       = >_Ayako_Missile
   const _Ayako_Missile_low        = <_Ayako_Missile
   const _Ayako_Missile_height     = _Ayako_Missile_length + 1

   const _Carrier_88_high          = >_Carrier_88
   const _Carrier_88_low           = <_Carrier_88
   const _Carrier_88_height        = _Carrier_88_length + 1

   const _Carrier_Runway_high      = >_Carrier_Runway
   const _Carrier_Runway_low       = <_Carrier_Runway
   const _Carrier_Runway_height    = _Carrier_Runway_length + 1

   const _Carrier_Tower_high       = >_Carrier_Tower
   const _Carrier_Tower_low        = <_Carrier_Tower
   const _Carrier_Tower_height     = _Carrier_Tower_length + 1

   const _Player0_Plane_up_high    = >_Player0_Plane_up
   const _Player0_Plane_up_low     = <_Player0_Plane_up
   const _Player0_Plane_up_height  = _Player0_Plane_up_length

   const _Player0_Plane_down_high   = >_Player0_Plane_down
   const _Player0_Plane_down_low    = <_Player0_Plane_down
   const _Player0_Plane_down_height = _Player0_Plane_down_length

   const _Player0_Looping_1_high    = >_Player0_Looping_1
   const _Player0_Looping_1_low     = <_Player0_Looping_1
   const _Player0_Looping_1_height  = _Player0_Looping_1_length

   const _Player0_Looping_2_high    = >_Player0_Looping_2
   const _Player0_Looping_2_low     = <_Player0_Looping_2
   const _Player0_Looping_2_height  = _Player0_Looping_2_length

   const _Player0_Explosion_0_high  = >_Player0_Explosion_0
   const _Player0_Explosion_0_low   = <_Player0_Explosion_0
   const _Player0_Explosion_0_height= _Player0_Explosion_0_length

   const _Player0_Explosion_1_high  = >_Player0_Explosion_1
   const _Player0_Explosion_1_low   = <_Player0_Explosion_1
   const _Player0_Explosion_1_height= _Player0_Explosion_1_length

   const _Player0_Explosion_2_high  = >_Player0_Explosion_2
   const _Player0_Explosion_2_low   = <_Player0_Explosion_2
   const _Player0_Explosion_2_height= _Player0_Explosion_2_length

   const _Player0_Explosion_3_high  = >_Player0_Explosion_3
   const _Player0_Explosion_3_low   = <_Player0_Explosion_3
   const _Player0_Explosion_3_height= _Player0_Explosion_3_length

   const _Player0_Explosion_4_high  = >_Player0_Explosion_4
   const _Player0_Explosion_4_low   = <_Player0_Explosion_4
   const _Player0_Explosion_4_height= _Player0_Explosion_4_length

;#endregion

;#region "Zeropage Variables"

   dim playerpointerlo   = player1pointerlo
   dim playerpointerhi   = player1pointerhi
   dim PF1pointerhi      = PF1pointer + 1
   dim PF2pointerhi      = PF2pointer + 1

   dim _Ch0_Counter      = a
   dim _Ch0_Duration     = b
   dim _Ch0_Sound        = c
   dim _Ch1_Duration     = d
   dim _Ch1_Read_Pos_Lo  = e
   dim _Ch1_Read_Pos_Hi  = f

   dim attack_position   = g
   dim player_animation_state = h

   dim playertype        = i
   dim player1type       = i
   dim player2type       = j
   dim player3type       = k
   dim player4type       = l
   dim player5type       = m

   dim playerfullheight  = n
   dim player1fullheight = n
   dim player2fullheight = o
   dim player3fullheight = p
   dim player4fullheight = q
   dim player5fullheight = r

   dim playerhits        = s
   dim player1hits       = s
   dim player2hits       = t
   dim player3hits       = u
   dim player4hits       = v
   dim player5hits       = w

   dim framecounter           = x
   dim map_section            = y
   dim _Bit0_map_speed        = y
   dim _Bit1_map_speed        = y
   dim _Bit2_map_pfheight     = y  ; Playfield pixel height
   dim _Bit3_map_direction    = y  
   dim _Bit4_map_P_moving     = y  ; Player can move
   dim _Bit5_map_E_moving     = y  ; Enemies moving
   dim _Bit6_map_PF_collision = y  ; Playfield collision active
   dim _Bit7_map_E_collsion   = y  ; Enemy collision and player shooting active


   dim game_flags             = z
   dim _Bit0_gf               = z
   dim _Bit1_reset_restrainer = z
   dim _Bit2_looping          = z
   dim _Bit3_mute_bg_music    = z
   dim _Bit4_genesispad       = z
   dim _Bit5_PlusROM          = z
   dim _Bit6_p0_explosion     = z

   ; Slocum Player and titlescreen RAM variables (reuses game loop variables!)
   dim bmp_96x2_2_index = f
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

;#region "SC RAM Variables"
   dim w_NUSIZ0           = w127
   dim r_NUSIZ0           = r127
   dim w_COLUPF           = w126
   dim r_COLUPF           = r126
   dim w_stage            = w125
   dim r_stage            = r125
   dim w_COLUP0           = w124 
   dim r_COLUP0           = r124
   dim w_CTRLPF           = w123
   dim r_CTRLPF           = r123

;#endregion


   bank 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 1 Game Logic"

   scorecolor = _0E

   game_flags = 0
   if INPT1{7} then _Bit4_genesispad{4} = 1
   if ReceiveBufferSize = 0 then _Bit5_PlusROM{5} = 1

   goto titlescreen_start bank2
 

start

   rem initial variables setup
   missile0y = 0 : w_stage = 0 : framecounter = 0 : attack_position = 0 : map_section = _Map_Carrier
   player0x = _Player0_X_Start : player0y = _Player0_Y_Start
   lives = 64 : score = 0
   game_flags = game_flags & %00110000  ; Reset all except genesis controller and PlusROM detection
   game_flags = game_flags | %00001001  ; Set mirrored playfield and mute bg music
   pfheight = 3
   statusbarlength = %10101000

   missile1y = 100 : missile1x = 100 : ballx = 100 : bally = 100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Playfield Pacific"

   playfield:
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ........XX......  ; 
   ......XXX.......  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ..............XX  ; 
   ..............XX  ; 
   .............XXX  ; 
   ...............X  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   .........XX.....  ; 
   ........XXXX....  ; 
   .........XX.....  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ............XX..  ; 
   ...........XXXX.  ; 
   .............X..  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ...............X  ; 
   ..............XX  ; 
   ..............XX  ; 
   ...............X  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   .....XX.........  ; 
   ....XXXXX.......  ; 
   ....XXXX........  ; 
   .....XXX........  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ....XX..........  ; 
   ..XXXXXXXXXXXX..  ; 
   XXXXXXXXXXXXXXXX  ; 
   XXXXXXXXXXXXXX..  ; 
   XXXXXXXXXXXXXX..  ; 
   XXXXXXXXXXXXXXX.  ; 
   XXXXXXXXXXXXXXXX  ; 
   ..XXXXXXX.XXXXXX  ; 
   ............XXXX  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 0 Start of landscape
   ................  ; 255
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 248
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 240
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 232
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 224
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 216
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 208
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 200
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 192
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 184
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 178 Start of boss plane (scrolling up)
   ...............X  ; 
   ................  ; 176
   .........X.X.X.X  ; 
   ...............X  ; 
   .........X.X.X.X  ; 
   .........X.X.X.X  ; 
   .....XXXXXXXXXXX  ; 
   .....XXXXXXXXXXX  ; 
   ......XXXXXXXXX.  ; 
   ........XXXXXXXX  ; 168
   ..........XXXXX.  ; 
   ............XXXX  ; 
   .............XXX  ; 
   ..............XX  ; 
   ..............XX  ; 
   ...............X  ; 
   ...............X  ; 
   ...............X  ; 160
   ...............X  ; 
   ...............X  ; 
   ...............X  ; 
   ...............X  ; 
   ...............X  ; 
   ...............X  ; 
   ..............XX  ; 
   .............XX.  ; 152
   .............XXX  ; 151
   ...............X  ; 150
   ................  ; 149
   ................  ; 148
   ................  ; 147
   ................  ; 146
   ................  ; 145
   ................  ; 144
   ................  ; 143
   ................  ; 142
   ................  ; 141
   ................  ; 140
   ................  ; 139
   ................  ; 138
   ................  ; 137
   ................  ; 136
   ................  ; 135
   ................  ; 134
   ................  ; 133
   ................  ; 132
   ................  ; 131
   ................  ; 130
   ................  ; 129
   ................  ; 128
   ................  ; 127
   ................  ; 126
   ................  ; 125
   ................  ; 124
   ................  ; 123
   ................  ; 122
   ................  ; 121
   ................  ; 120
   ................  ; 119
   ................  ; 118
   ................  ; 117
   ................  ; 116
   ................  ; 115
   ................  ; 114
   ................  ; 113
   ................  ; 112
   ................  ; 111
   ................  ; 110
   ................  ; 109
   ................  ; 108
   ................  ; 107
   ................  ; 106
   ................  ; 105
   ................  ; 104
   ................  ; 103
   ................  ; 102
   ................  ; 101
   ................  ; 100
   ................  ; 99
   ................  ; 98
   ................  ; 97
   ................  ; 96
   ................  ; 95
   ................  ; 94
   ................  ; 93
   ................  ; 92
   ................  ; 91
   ................  ; 90
   ................  ; 89
   ................  ; 88
   ................  ; 87
   ................  ; 86
   ................  ; 85
   ................  ; 84
   ................  ; 83
   ................  ; 82
   ................  ; 81
   ................  ; 80
   ................  ; 79
   ................  ; 78
   ................  ; 77
   ................  ; 76
   ................  ; 75
   ................  ; 74
   ................  ; 73
   ................  ; 72
   ................  ; 71
   ................  ; 70
   ................  ; 69
   ................  ; 68
   ................  ; 67
   ................  ; 66
   ................  ; 65
   ................  ; 64
   ................  ; 63
   ................  ; 62 Start of Boss scrolling down
   ..............XX  ; 61 Carrier end
   ...........XXXXX  ; 60
   ..........XXXXXX  ; 59
   .........XXXXXXX  ; 58
   .........XXXXXXX  ; 57
   .........XXXXXXX  ; 56
   .........XXXXXXX  ; 55
   ........XXXXXXXX  ; 54
   ........XXXXXXXX  ; 53
   ........XXXXXXXX  ; 52
   ........XXXXXXXX  ; 51
   ........XXXXXXXX  ; 50
   .......XXXXXXXXX  ; 49
   .......XXXXXXXXX  ; 48
   .......XXXXXXXXX  ; 47
   .......XXXXXXXXX  ; 46
   .......XXXXXXXXX  ; 45
   .......XXXXXXXXX  ; 44
   .......XXXXXXXXX  ; 43
   .......XXXXXXXXX  ; 42
   .......XXXXXXXXX  ; 41
   .......XXXXXXXXX  ; 40
   .......XXXXXXXXX  ; 39
   .......XXXXXXXXX  ; 38
   .......XXXXXXXXX  ; 37
   .......XXXXXXXXX  ; 36
   .......XXXXXXXXX  ; 35
   .......XXXXXXXXX  ; 34
   .......XXXXXXXXX  ; 33
   .......XXXXXXXXX  ; 32
   .......XXXXXXXXX  ; 31
   ........XXXXXXXX  ; 30
   ........XXXXXXXX  ; 29
   ........XXXXXXXX  ; 28
   ........XXXXXXXX  ; 27
   .........XXXXXXX  ; 26
   .........XXXXXXX  ; 25
   ..........XXXXXX  ; 24
   ................  ; 23
   ................  ; 22
   ................  ; 21
   ................  ; 20
   ................  ; 19
   ................  ; 18
   ................  ; 17
   ................  ; 16
   ................  ; 15
   ................  ; 14
   ................  ; 13
   ................  ; 12
   ................  ; 11
   ................  ; 10
   ................  ; 9
   ................  ; 8
   ................  ; 7
   ................  ; 6
   ................  ; 5
   ................  ; 4
   ................  ; 3
   ................  ; 2
   ................  ; 1
   ................  ; 0 Start landing zone
end
;#endregion

   PF1pointer = _Map_Takeoff_Point
   PF2pointer = _Map_Takeoff_Point

   w_COLUPF = _Color_Carrier
   w_COLUP0 = _EA
   w_CTRLPF = 1

   lives:
   %00111100
   %00011000
   %01111110 
   %01111110
   %00011000
   %00000000
   %00000000
end


   player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height

   goto  __BG_Music_Setup_01 bank3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Mainloop"
main
   if switchreset then goto titlescreen_start bank2

   framecounter = framecounter + 1
   COLUBK = _96
   COLUP0 = r_COLUP0
   CTRLPF = r_CTRLPF

   lifecolor = _EA : COLUPF = r_COLUPF

   if !_Bit6_p0_explosion{6} then _skip_player0_explosion

   if framecounter{0} then _skip_player0_collision

   player_animation_state = player_animation_state + 1
   if player_animation_state = 50 then _player0_animation_end
   if player_animation_state = 1 then w_COLUP0 = _4E : player0pointerlo = _Player0_Explosion_0_low : player0pointerhi = _Player0_Explosion_0_high : player0height = _Player0_Explosion_0_height : goto _skip_player0_collision
   if player_animation_state = 10 then w_COLUP0 = _48 : player0pointerlo = _Player0_Explosion_1_low : player0pointerhi = _Player0_Explosion_1_high : player0height = _Player0_Explosion_1_height : goto _skip_player0_collision
   if player_animation_state = 20 then w_COLUP0 = _46 : player0pointerlo = _Player0_Explosion_2_low : player0pointerhi = _Player0_Explosion_2_high : player0height = _Player0_Explosion_2_height : goto _skip_player0_collision
   if player_animation_state = 30 then w_COLUP0 = _42 : player0pointerlo = _Player0_Explosion_3_low : player0pointerhi = _Player0_Explosion_3_high : player0height = _Player0_Explosion_3_height : goto _skip_player0_collision
   if player_animation_state = 40 then w_COLUP0 = _42 : player0pointerlo = _Player0_Explosion_4_low : player0pointerhi = _Player0_Explosion_4_high : player0height = _Player0_Explosion_4_height

   goto _skip_player0_collision

_player0_animation_end
   player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height : _Bit6_p0_explosion{6} = 0
   if lives < 32 then goto titlescreen_start bank2
   lives = lives - 32 : player0x = _Player0_X_Start : player0y = _Player0_Y_Start
   statusbarlength = %10101000 : w_COLUP0 = _EA
   attack_position = attack_position - 1
   goto build_attack_position
_skip_player0_explosion

   if !_Bit7_map_E_collsion{7} || _Bit2_looping{2} then goto _skip_player0_collision
   if _Bit6_map_PF_collision{6} && collision(missile0, playfield) then _missile0_collision
   if !collision(player1, missile0) then goto _skip_missile0_collision
_missile0_collision   
   _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0

   temp1 = player1y + 1 : temp2 = player1y - player1height
   if missile0y > temp2 && missile0y < temp1 then temp1 = 0 : goto _end_collision_check

   temp1 = player2y + 1 : temp2 = player2y - player2height
   if missile0y > temp2 && missile0y < temp1 then temp1 = 1 : goto _end_collision_check

   temp1 = player3y + 1 : temp2 = player3y - player3height
   if missile0y > temp2 && missile0y < temp1 then temp1 = 2 : goto _end_collision_check

   temp1 = player4y + 1 : temp2 = player4y - player4height
   if missile0y > temp2 && missile0y < temp1 then temp1 = 3 : goto _end_collision_check

   temp1 = 4

_end_collision_check
   temp2 = playerhits[temp1] - 1
   if temp2 then score = score + 100 : goto _end_collision
   player1y[temp1] = _plane_parking_point[temp1]
   score = score + 50
   if _Bit6_map_PF_collision{6} then w_stage = r_stage + 1 : goto set_game_state_landing

_end_collision
   playerhits[temp1] = temp2
   missile0y = 0

_skip_missile0_collision

   if _Bit6_map_PF_collision{6} && collision(player0, playfield) then _player0_collision
   if !_Bit7_map_E_collsion{7} || !collision(player0, player1) then goto _skip_player0_collision
_player0_collision
   _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   _Bit6_p0_explosion{6} = 1 : player_animation_state = 0
   goto _skip_game_action

_skip_player0_collision


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Playfield scrolling"
   temp1 = map_section & %00000011

   if temp1 = 1 && framecounter{0} then _Check_scrolling_direction
   if temp1 = 2 && !( framecounter & %00000111 ) then _Check_scrolling_direction
   if temp1 = 3 && !( framecounter & %00001111 ) then _Check_scrolling_direction
   goto _skip_scrolling

_Check_scrolling_direction
   if _Bit3_map_direction{3} then _Playfield_scrolling_down 
   if PF1pointer > _Map_Boss_End_up then PF1pointer = PF1pointer - 1 : PF2pointer = PF2pointer - 1 else _Bit3_map_direction{3} = 1
 
   goto _skip_scrolling

_Playfield_scrolling_down
   PF1pointer = PF1pointer + 1
   PF2pointer = PF2pointer + 1

   if map_section <> _Map_Carrier then goto _skip_carrier_superstructures

   if PF1pointer > _Map_Carrier_End then goto _skip_carrier_superstructures_scrolling
   for temp1 = 0 to 4
   temp4 = _plane_parking_point[temp1]
   if NewSpriteY[temp1] < temp4 then NewSpriteY[temp1] = NewSpriteY[temp1] - _Pf_Pixel_Height else goto _next_superstructure

   temp3 = NewSpriteY[temp1] - playerfullheight[temp1]
   if spriteheight[temp1] < playerfullheight[temp1]  && temp3 < 85 && NewSpriteY[temp1] > spriteheight[temp1] then spriteheight[temp1] = spriteheight[temp1] + _Pf_Pixel_Height : NewSpriteY[temp1] = 84
   if spriteheight[temp1] > playerfullheight[temp1] then spriteheight[temp1] = playerfullheight[temp1]
   if spriteheight[temp1] > NewSpriteY[temp1] && spriteheight[temp1] > _Pf_Pixel_Height then spriteheight[temp1] = spriteheight[temp1] - _Pf_Pixel_Height : playerpointerlo[temp1] = playerpointerlo[temp1] + _Pf_Pixel_Height

   if NewSpriteY[temp1] < 2 || NewSpriteY[temp1] > temp4 then NewSpriteY[temp1] = temp4

_next_superstructure
   next
_skip_carrier_superstructures_scrolling

   if PF1pointer <> _Map_Takeoff_Point_1 then _skip_carrier_superstructures_init
    _COLUP1 = _0A : COLUP2 = _0A : COLUP3 = _0A : COLUP4 = _0A : COLUP5 = _02 : map_section = _Map_Carrier

    player1pointerlo = _Carrier_88_low     : player1pointerhi = _Carrier_88_high     : player1height =  0 : player1fullheight = _Carrier_88_height     : _NUSIZ1 = 7 : player1x =  69 : player1y = 130 ; 130 ; 170 - 40
    player2pointerlo = _Carrier_Runway_low : player2pointerhi = _Carrier_Runway_high : player2height =  0 : player2fullheight = _Carrier_Runway_height :  NUSIZ2 = 7 : player2x =  71 : player2y = 100 ; 100 ; 135 - 40 ; _Player2_Parking_Point ; 135 - 40
    player3pointerlo = _Carrier_Runway_low : player3pointerhi = _Carrier_Runway_high : player3height =  2 : player3fullheight = _Carrier_Runway_height :  NUSIZ3 = 5 : player3x =  78 : player3y = _Player3_Parking_Point ; 100 - 40
    player4pointerlo = _Carrier_Runway_low : player4pointerhi = _Carrier_Runway_high : player4height =  3 : player4fullheight = _Carrier_Runway_height :  NUSIZ4 = 7 : player4x =  69 : player4y =  20 ;  20 ; _Player4_Parking_Point ; 66 - 40 ;  ;  70 - 40
    player5pointerlo = _Carrier_Tower_low  : player5pointerhi = _Carrier_Tower_high  : player5height = 62 : player5fullheight = _Carrier_Tower_height  :  NUSIZ5 = 5 : player5x = 105 : player5y =  88 ;  88 ; 128 - 40
    
    goto _skip_game_action
_skip_carrier_superstructures_init

   if PF1pointer = _Map_Takeoff_Sound_Start then _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0 : goto _skip_playfield_restart
   if PF1pointer = _Map_Attackzone_Start then map_section = _Map_Pacific : _Bit3_mute_bg_music{3} = 0 : PF1pointerhi = _PF1_Pacific_high : PF2pointerhi = _PF2_Pacific_high : goto _next_playfield_variation

_skip_carrier_superstructures

   if !_Bit6_map_PF_collision{6} then _skip_boss_moving_down
   if PF1pointer > _Map_Boss_End_dw then _Bit3_map_direction{3} = 0
   goto _skip_scrolling
_skip_boss_moving_down

   if PF1pointer <> _Map_End then _skip_playfield_restart
_next_playfield_variation
   PF1pointer = 0 : PF2pointer = 0
   w_CTRLPF = r_CTRLPF ^ 1
   temp1 = r_stage & %00000011
   if temp1 < 2 then w_COLUPF = _Color_Gras_Island : goto _skip_playfield_restart
   if temp1 = 2 then w_COLUPF = _Color_Sand_Island else w_COLUPF = _Color_Jungle_Island

_skip_playfield_restart



_skip_scrolling
;#endregion
 


_check_player_movement
   if _Bit6_p0_explosion{6} then goto _plane_loop
   if map_section <> _Map_Carrier then _player_movement

   if player0y < _Player0_Y_Start then player0y = player0y + 1
   if player0y > _Player0_Y_Start then player0y = player0y - 1
   if player0x < _Player0_X_Start then player0x = player0x + 1
   if player0x > _Player0_X_Start then player0x = player0x - 1
   
   goto _skip_game_action


_player_movement
   if !_Bit2_looping{2} then goto _check_for_new_looping
   if framecounter{0} then jump_1
   player_animation_state = player_animation_state + 1
   
   if player_animation_state = 5 then player0pointerlo = _Player0_Looping_1_low : player0pointerhi = _Player0_Looping_1_high : player0height = _Player0_Looping_1_height
   if player_animation_state < 10 && player0y < _Player0_Y_Max then player0y = player0y + 1 : goto jump_1
   if player_animation_state = 10 then player0pointerlo = _Player0_Plane_down_low : player0pointerhi = _Player0_Plane_down_high : player0height = _Player0_Plane_down_height : goto jump_1
   if player_animation_state = 25 then player0pointerlo = _Player0_Looping_2_low : player0pointerhi = _Player0_Looping_2_high : player0height = _Player0_Looping_2_height
   if player_animation_state < 30 && player0y > _Player0_Y_Min then player0y = player0y - 1 : COLUP0 = _E6 : goto jump_1
   if player_animation_state = 30 then player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height : goto jump_1
   if player_animation_state < 40 then player0y = player0y + 1 : goto jump_1
   if player_animation_state = 40 then _Bit2_looping{2} = 0
   goto jump_1

_check_for_new_looping
   if !statusbarlength then goto _player_normal_movement
   if _Bit4_genesispad{4} && !INPT1{7} then goto set_game_state_looping
   if switchselect then goto set_game_state_looping


_player_normal_movement
   if joy0up && player0y < _Player0_Y_Max then player0y = player0y + 1 : goto jump_1
   if joy0down && player0y > _Player0_Y_Min then player0y = player0y - 1
jump_1
   if joy0left && player0x > _Player0_X_Min then player0x = player0x - 1 : goto jump
   if joy0right && player0x < _Player0_X_Max then player0x = player0x + 1
jump


   if missile0y > 88 then missile0y = 0
   if missile0y > 1 || !_Bit7_map_E_collsion{7} then _skip_new_shot
   if joy0fire then missile0y = player0y + 1 : missile0x = player0x + 5 : _Ch0_Sound = 2 : _Ch0_Duration = 1 : _Ch0_Counter = 0
_skip_new_shot
   if ! missile0y then _check_enemy_shot
   missile0y = missile0y + 3
   if framecounter{0} then missile0x = missile0x - 2 else missile0x = missile0x + 2

_check_enemy_shot
;  if player1x = player0x && n = 0 && player1y < 20 then missile1x = player1x + 5 : missile1y = player1y + 2 :  n = 1


_plane_loop


   rem ################### attack speed

   if !_Bit5_map_E_moving{5} then goto _skip_plane_movement

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Plane attack movement"

   if player1y = _Player1_Parking_Point && player2y = _Player2_Parking_Point && player3y = _Player3_Parking_Point && player4y = _Player4_Parking_Point && player5y = _Player5_Parking_Point then goto build_attack_position

   if framecounter{1} then temp2 = 1 : temp1 = 2 else temp2 = 0 : temp1 = 0
   if framecounter{0} then temp1 = 2 else temp1 = 0
   
   
_plane_movement_loop_start

   if _Bit6_map_PF_collision{6} then temp3 = 4 else temp3 = playertype[temp1] & %00000011
   temp4 = _plane_parking_point[temp1]
   temp5 = rand

   on temp3 goto _plane_moves_left _plane_moves_right _plane_moves_down _plane_moves_up _plane_is_missile

_plane_moves_right
   if NewSpriteX[temp1] > 153 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then goto _check_next_plane
   NewSpriteX[temp1] = NewSpriteX[temp1] + _Plane_X2_Speed

   if NewSpriteY[temp1] > 10 then NewSpriteY[temp1] = NewSpriteY[temp1] - temp2

   if NewSpriteX[temp1] < 121 then goto _check_next_plane
   if NewNUSIZ[temp1] = %00001011 && NewSpriteX[temp1] > 120 then NewNUSIZ[temp1] = %00001001
   if NewNUSIZ[temp1] = %00001001 && NewSpriteX[temp1] > 136 then NewNUSIZ[temp1] = %00001000
   goto _check_next_plane

_plane_moves_left
   temp3 = NewSpriteX[temp1]
   if !NewNUSIZ[temp1] && temp3 < 2 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then goto _check_next_plane
   NewSpriteX[temp1] = temp3 - _Plane_X2_Speed
   
   if NewSpriteY[temp1] > 10 then NewSpriteY[temp1] = NewSpriteY[temp1] - temp2
   if temp3 = 78 && temp5 < 128 then playertype[temp1] = playertype[temp1] + 1 : NewNUSIZ[temp1] = NewNUSIZ[temp1] ^ %00001000 : goto _check_next_plane

   if temp3 < 254 then goto _check_next_plane
   if NewNUSIZ[temp1] then NewNUSIZ[temp1] = NewNUSIZ[temp1] / 2 : NewSpriteX[temp1] = temp3 + 16

   goto _check_next_plane

_plane_moves_down
   temp3 = NewSpriteY[temp1]
   if temp3 = temp4 then goto _check_next_plane
   if temp3 < 2 then NewSpriteY[temp1] = temp4 : goto _check_next_plane
   if temp3 = 40 && temp5 < 128 then playertype[temp1] = playertype[temp1] + 5 : temp5 = playertype[temp1] / 4 : playerpointerlo[temp1] = _player_pointer_lo[temp5] + 1 - playerfullheight[temp1] : playerpointerhi[temp1] = _player_pointer_hi[temp5] :  goto _check_next_plane
   NewSpriteY[temp1] = temp3 - _Plane_Y_Speed 
   if temp3 < 71 then _check_for_escape_move
   if NewSpriteX[temp1] > player0x then NewSpriteX[temp1] = NewSpriteX[temp1] - _Plane_X1_Speed : goto _check_next_plane
   if NewSpriteX[temp1] < player0x then NewSpriteX[temp1] = NewSpriteX[temp1] + _Plane_X1_Speed : goto _check_next_plane
_check_for_escape_move
   if temp3 > 39 || temp5 < 128 then goto _check_next_plane
   if NewSpriteX[temp1] > player0x && NewSpriteX[temp1] < 153 then NewSpriteX[temp1] = NewSpriteX[temp1] + _Plane_X1_Speed else NewSpriteX[temp1] = NewSpriteX[temp1] - _Plane_X1_Speed

   goto _check_next_plane



_plane_moves_up
   if NewSpriteY[temp1] > 100 && NewSpriteY[temp1] < 240 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then _check_next_plane
   NewSpriteY[temp1] = NewSpriteY[temp1] + _Plane_Y_Speed 
   if NewSpriteY[temp1] > 1 && NewSpriteY[temp1] <= playerfullheight[temp1] then playerpointerlo[temp1] = playerpointerlo[temp1] - _Plane_Y_Speed : spriteheight[temp1] = NewSpriteY[temp1]
;   if NewSpriteY[temp1] > 84 && spriteheight[temp1] then playerpointerlo[temp1] = playerpointerlo[temp1] + spriteheight[temp1] - NewSpriteY[temp1] : spriteheight[temp1] = NewSpriteY[temp1]

   goto _check_next_plane

_plane_is_missile
   if (framecounter & %00000110 ) then _check_next_plane
   if PF1pointer > _Map_Boss_End_dw || PF1pointer < _Map_Boss_End_up then _check_next_plane
   if NewSpriteY[temp1] > temp4 then NewSpriteY[temp1] = PF1pointer - 50 : NewSpriteX[temp1] = temp5 / 2 : goto _check_next_plane
   if NewSpriteY[temp1] > ( player0y + temp1 ) then NewSpriteY[temp1] = NewSpriteY[temp1] - 1
   if NewSpriteY[temp1] < player0y then NewSpriteY[temp1] = NewSpriteY[temp1] + 1
   if NewSpriteX[temp1] > player0x then NewSpriteX[temp1] = NewSpriteX[temp1] - 1
   if NewSpriteX[temp1] < player0x then NewSpriteX[temp1] = NewSpriteX[temp1] + 1

_check_next_plane
   temp1 = temp1 + 1
   if temp1 <> 5 && temp1 <> 2 then goto _plane_movement_loop_start


_skip_plane_movement
;#endregion


_skip_game_action

   goto _Play_In_Game_Music bank3

;#endregion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Subroutines and Functions"
set_game_state_landing
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Landingzone_Start : PF2pointer = _Map_Landingzone_Start
   map_section = _Map_Carrier : _Bit3_mute_bg_music{3} = 1 : w_COLUPF = _Color_Carrier
   _Ch0_Sound = 5 : _Ch0_Duration = 1 : _Ch0_Counter = 0 : missile0y = 0 : pfheight = 3 : w_CTRLPF = %00000001
   goto park_all_planes

set_game_state_looping
   statusbarlength = statusbarlength / 4 & %11111000
   _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0 : player_animation_state = 0 : _Bit2_looping{2} = 1
   goto _player_normal_movement

set_game_state_boss
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   pfheight = 0 : w_CTRLPF = %00000001
   for temp1 = 0 to 4
      NewSpriteY[temp1] = _plane_parking_point[temp1] + 5
      NewNUSIZ[temp1]   = temp3
      NewCOLUP1[temp1]  = _36

      playerpointerlo[temp1]  = _Ayako_Missile_low
      playerpointerhi[temp1]  = _Ayako_Missile_high
      playerfullheight[temp1] = _Ayako_Missile_height
      spriteheight[temp1]     = _Ayako_Missile_height
   next
   goto _skip_game_action

build_attack_position
   temp2 = _attack_position_sequence[attack_position]
   attack_position = attack_position + 1
   if temp2 < 226 then goto _read_attack_data
   if temp2 = 226 then map_section = _Map_Boss_down : player5hits = 25 : temp3 = 0 : PF1pointer = _Map_Boss_Start_dw : PF2pointer = _Map_Boss_Start_dw : w_COLUPF = _D8 : goto set_game_state_boss
   if temp2 = 227 then map_section = _Map_Boss_down : player5hits = 35 : temp3 = 1 : PF1pointer = _Map_Boss_Start_dw : PF2pointer = _Map_Boss_Start_dw : w_COLUPF = _D6 : goto set_game_state_boss
   if temp2 = 228 then map_section = _Map_Boss_up   : player5hits = 55 : temp3 = 2 : PF1pointer = _Map_Boss_Start_up : PF2pointer = _Map_Boss_Start_up : w_COLUPF = _D6 : goto set_game_state_boss
   if temp2 = 229 then map_section = _Map_Boss_up   : player5hits = 70 : temp3 = 3 : PF1pointer = _Map_Boss_Start_up : PF2pointer = _Map_Boss_Start_up : w_COLUPF = _D4 : goto set_game_state_boss
   if temp2 = 254 then w_stage = r_stage + 1 : goto set_game_state_landing
   if temp2 = 255 then attack_position = 0 : goto build_attack_position ; todo game finished screen
_read_attack_data
   for temp1 = 0 to 4
      playertype[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewSpriteX[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewSpriteY[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewNUSIZ[temp1]   = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewCOLUP1[temp1]  = _attack_position_data[temp2] : temp2 = temp2 + 1

      temp3 = playertype[temp1] / 4
      playerpointerlo[temp1]  = _player_pointer_lo[temp3]
      playerpointerhi[temp1]  = _player_pointer_hi[temp3]
      playerfullheight[temp1] = _player_full_height[temp3]
      spriteheight[temp1]     = _player_full_height[temp3]
      playerhits[temp1]       = _player_max_hits[temp3]
   next

   goto _skip_game_action 

park_all_planes
   player1y = _Player1_Parking_Point
   player2y = _Player2_Parking_Point
   player3y = _Player3_Parking_Point
   player4y = _Player4_Parking_Point
   player5y = _Player5_Parking_Point
   goto _skip_game_action 

;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Data tables"

   const p1p = _Player1_Parking_Point
   const p2p = _Player2_Parking_Point
   const p3p = _Player3_Parking_Point
   const p4p = _Player4_Parking_Point
   const p5p = _Player5_Parking_Point

   data _attack_position_sequence
   ; 1   2   3   4   5   6   7   8   9  10  11  12
     0,  0, 25, 50,  0, 25, 75, 50,100,254         ; stage 32
     0,125, 25,150, 75, 75,125,  0, 50, 50,254     ; stage 31
    25, 25, 75, 50, 50,100,  0,125, 25,150, 75,254 ; stage 30
     0,125, 25,150, 75, 75,125,  0, 25, 75,254     ; stage 29
    50,100,  0,125, 25,150, 75, 75,125,  0, 254    ; stage 28
    25, 75, 50, 50,100,  0,125, 25,150, 75, 75,254 ; stage 27
     0,  0, 25, 50,100,100,150, 75, 75,125,125,226 ; stage 26 Boss 1
    25, 75, 50, 50,100,  0,125, 25,150,  0,227     ; stage 18
     0,  0, 25, 50,  0, 25, 75, 50, 50,100,228     ; stage 10
    50,100,  0,125, 25,150, 75, 75,125,  0,229     ; stage 2
   255
end

 rem playertype, NewSpriteX, NewSpriteY, NewNUSIZ, NewCOLUP
   data _attack_position_data
      %00000010,         40,         88,       0, _D6  ; 5 small planes from top
      %00000010,        110,         98,       0, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,         20,        118,       0, _D6
      %00000010,         50,        128,       0, _D6

      %00001110,         40,         88,       0, _D4  ; 1 middle + 4 small planes from top
      %00000010,         30,         98,       0, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,         20,        118,       0, _D6
      %00000010,         50,        128,       0, _D6

      %00001001,          0,         84,       9, _D6  ; 2x2 small planes from left 
      %00001001,          0,         74,       9, _D6 
      %00001000,        158,         64,       1, _D6  ; 2x2 small planes from right
      %00001000,        158,         54,       1, _D6
      %00011111,         50,        p5p,       0, _D4

      %00000010,        110,         88,       0, _D6
      %00000010,        110,         98,       0, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,        110,        118,       0, _D6
      %00011111,         50,          1,       7, _D4

      %00001001,          0,         84,       9, _D6
      %00001001,          0,         74,       9, _D6
      %00001000,        158,         64,       1, _D6
      %00001000,        158,         54,       1, _D6
      %00011111,         50,        p5p,       0, _D4

      %00000010,         20,         88,       1, _D4
      %00000010,        110,         98,       1, _D6
      %00000010,         20,        108,       1, _D6
      %00011111,        125,        247,       7, _D4
      %00011111,         75,          1,       7, _D4

      %00000010,         75,         88,      11, _D4
      %00000010,         20,         98,      11, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,         90,        118,       0, _D6
      %00011111,         30,          1,       7, _D4
end

   data _player_pointer_lo
   _Small_Plane_down_low,  (_Small_Plane_up_low  + _Small_Plane_up_height  - 1), _Small_Plane_lr_low
   _Middle_Plane_down_low, (_Middle_Plane_up_low + _Middle_Plane_up_height - 1), _Middle_Plane_lr_low
   _Big_Plane_down_low,    (_Big_Plane_up_low    + _Big_Plane_up_height    - 1)
end

   data _player_pointer_hi
   _Small_Plane_down_high,  _Small_Plane_up_high,  _Small_Plane_lr_high
   _Middle_Plane_down_high, _Middle_Plane_up_high, _Middle_Plane_lr_high
   _Big_Plane_down_high,    _Big_Plane_up_high
end

   data _player_full_height
   _Small_Plane_down_height,  _Small_Plane_up_height,  _Small_Plane_lr_height
   _Middle_Plane_down_height, _Middle_Plane_up_height, _Middle_Plane_lr_height
   _Big_Plane_down_height,    _Big_Plane_up_height
end

   data _player_max_hits
   1, 1, 1
   3, 3, 3
   5, 5
end

   data _plane_parking_point
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end
;#endregion

;#endregion

   bank 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 2 Titlescreen"

titlescreen_start
   COLUBK = _00
   beat = 0 : tempoCount = 0 : measure = 0 : _Bit1_reset_restrainer{1} = 1

titlescreen            

   framecounter = framecounter + 1
   if framecounter{0} then bmp_96x2_2_index = 25 else  bmp_96x2_2_index = 0

   gosub songPlayer bank3

   gosub titledrawscreen

   if !joy0fire then _Bit1_reset_restrainer{1} = 0
   if joy0fire && !_Bit1_reset_restrainer{1} then AUDV0 = 0 : AUDV1 = 0 : goto start bank1
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

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = _SD_Takeoff[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   AUDF0 = _SD_Takeoff[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

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
   temp4 = _SD_Shoot[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = _SD_Shoot[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   AUDF0 = _SD_Shoot[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Shoot[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

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
   temp4 = _SD_Enemy_Destroyed[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = _SD_Enemy_Destroyed[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   AUDF0 = _SD_Enemy_Destroyed[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Enemy_Destroyed[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

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
   temp4 = _SD_Death[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = _SD_Death[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   AUDF0 = _SD_Death[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Death[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_004


   ;***************************************************************
   ;
   ;  Channel 0 sound effect 005.
   ;
   ;  Landing.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 005 isn't on.
   ;
   if _Ch0_Sound <> 5 then goto __Skip_Ch0_Sound_005

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Landing[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = _SD_Landing[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   AUDF0 = _SD_Landing[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Landing[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_005


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
   if !switchleftb || _Bit3_mute_bg_music{3} then AUDV1 = 0 : goto __Skip_Ch_1

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
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = sread(_SD_Music01)
   AUDF1 = sread(_SD_Music01)

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
   4,3,14,15
   3,3,13,12
   2,3,13,12
   1,3,13,12
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shooting.
   ;

   data _SD_Shoot
   15,2,2,1
   3,8,4,4
   2,8,4,8
   1,8,4,11
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shot hitting enemy.
   ;

   data _SD_Enemy_Destroyed
   6,8,2,1
   3,8,2,1
   12,2,3,1
   2,2,3,1
   12,2,3,1
   2,2,3,1
   12,2,3,1
   3,8,5,2
   2,8,6,3
   1,8,7,4
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for touching enemy.
   ;
   data _SD_Death
   8,8,3,1
   5,8,3,2
   2,8,3,5
   8,8,10,1
   2,8,10,1
   10,8,10,1
   2,8,10,1
   12,8,10,1
   2,8,10,1
   12,8,10,1
   2,8,10,1
   12,8,10,1
   2,8,10,1
   12,8,10,1
   2,8,10,1
   10,8,10,1
   2,8,10,1
   8,8,10,1
   2,8,10,1
   5,8,8,1
   3,8,5,4
   2,8,5,4
   1,8,5,6
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Landing
   ;
   data _SD_Landing
   1,3,10,16
   2,3,10,16
   2,3,11,16
   3,3,12,16
   4,3,12,16
   4,3,13,8
   4,3,14,8
   5,3,15,4
   5,3,16,4
   5,3,17,4
   5,3,18,4
   6,3,19,8
   6,3,20,8
   6,3,21,48
   2,3,21,2
   6,3,21,2
   2,3,21,3
   6,3,21,3
   2,3,21,3
   6,3,21,3
   2,3,21,4
   6,3,21,4
   2,3,21,4
   6,3,21,4
   2,3,21,5
   6,3,21,5
   2,3,21,5
   6,3,21,5
   2,3,21,5
   6,3,21,5
   2,3,21,5
   1,3,21,5
   255
end


__BG_Music_Setup_01

  sdata _SD_Music01 = e
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
;#region "Bank 4 bB drawscreen and sprites"

   inline 6lives.asm

   asm
   MAC PAD_BB_SPRITE_DATA
.SPRITE_HEIGHT  SET {1}
      if	(<*) > (<(*+.SPRITE_HEIGHT))
      repeat	($100-<*)
      .byte	0
      repend
      endif
      if (<*) < 90
	   repeat (90-<*)
	   .byte 0
	   repend
	   endif
   ENDM

   PAD_BB_SPRITE_DATA 4
end
  data _Small_Plane_down
   %00011000
   %01111110
   %01111110
   %00011000
   %00111100
end

   asm
   PAD_BB_SPRITE_DATA 4
end
  data _Small_Plane_up
   %00111100
   %00011000
   %01111110
   %01111110
   %00011000
end

   asm
   PAD_BB_SPRITE_DATA 5
end
  data _Small_Plane_lr
   %0011000
   %0011010
   %0111110
   %0111110
   %0011010
   %0011000
end

   asm
   PAD_BB_SPRITE_DATA 6
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

   asm
   PAD_BB_SPRITE_DATA 6
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

   asm
   PAD_BB_SPRITE_DATA 7
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

   asm
   PAD_BB_SPRITE_DATA 27
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

   asm
   PAD_BB_SPRITE_DATA 7
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

   asm
   PAD_BB_SPRITE_DATA 13
end
  data _Carrier_88
   %00100010
   %01110111
   %01010101
   %01010101
   %01010101
   %01010101
   %00100010
   %00100010
   %01010101
   %01010101
   %01010101
   %01010101
   %01110111
   %00100010
end

   asm
   PAD_BB_SPRITE_DATA 1
end
  data _Carrier_Runway
   %11111111
   %11111111
end

   asm
   PAD_BB_SPRITE_DATA 2
end
  data _Ayako_Missile
   %11000000
   %11000011
   %00000011
end

   asm
   PAD_BB_SPRITE_DATA 7
end
   data _Player0_Plane_up
   0
   %00100100
   %01111110
   %00100100
   %00111100
   %11111111
   %11111111
   %00100100
end

   asm
   PAD_BB_SPRITE_DATA 7
end
   data _Player0_Plane_down
   0
   %00100100
   %00111100
   %11111111
   %11111111
   %00100100
   %01111110
   %00100100
end

   asm
   PAD_BB_SPRITE_DATA 2
end
  data _Player0_Looping_1
   0
   %00111100
   %11111111
end

   asm
   PAD_BB_SPRITE_DATA 2
end
  data _Player0_Looping_2
   0
   %11111111
   %00111100
end


   asm
   PAD_BB_SPRITE_DATA 8
end

  data _Player0_Explosion_0
   0
   %00000000
   %01001010
   %00111100
   %00111100
   %00111100
   %00111100
   %01010010
   %00000000
end

   asm
   PAD_BB_SPRITE_DATA 8
end
  data _Player0_Explosion_1
   0
   %01111110
   %11011111
   %11111111
   %11111110
   %11111111
   %11111101
   %11111111
   %01111010
end

   asm
   PAD_BB_SPRITE_DATA 8
end
  data _Player0_Explosion_2
   0
   %00000000
   %00011000
   %00111100
   %00111100
   %00101100
   %00111100
   %00011000
   %00000000
end

   asm
   PAD_BB_SPRITE_DATA 9
end
  data _Player0_Explosion_3
   0
   %00000000
   %00000000
   %00000000
   %00010100
   %00000000
   %00101010
   %00000100
   %00010000
   %00000000
end

   asm
   PAD_BB_SPRITE_DATA 10
end
  data _Player0_Explosion_4
   0
   %00000000
   %00000000
   %00000000
   %00001000
   %00100100
   %01000000
   %10001001
   %01000000
   %01000010
   %00101100
end


   asm
   PAD_BB_SPRITE_DATA 60
end
  data _Carrier_Tower
   %01000000
   %00000000
   %01111100
   %00100010
   %11110001
   %01111011
   %01110101
   %10101111
   %10001111
   %11001011
   %10011111
   %01011111
   %01100111
   %01011011
   %00011011
   %10010111
   %11101111
   %10101111
   %11011111
   %11011100
   %01011101
   %01000111
   %10111101
   %01001110
   %10110110
   %10101011
   %01011101
   %01011101
   %01011101
   %01011101
   %01011101
   %01011101
   %11011101
   %01100011
   %11011101
   %01011101
   %11011101
   %01011101
   %01011101
   %01011101
   %01011101
   %11101011
   %10100011
   %11011101
   %01000011
   %10111111
   %11000011
   %11111101
   %11011101
   %11001001
   %01001101
   %11010101
   %11011101
   %01001001
   %11011001
   %11101101
   %01111101
   %01001010
   %00101100
   %00110100
   %00001000
end

   asm
   ; HSC PlusROM API definition.
   SET_PLUSROM_API "a", "h.firmaplus.de"
   ; just for the detection
   sta WriteSendBuffer
end

;#endregion