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
   set romsize 32kSC
;   set debug cyclescore

;#region "Macros"

   macro _Set_SFX_By_Prio_bB
   if _Ch0_Sound <= {1} then _Ch0_Sound = {1} : _Ch0_Duration = 1 : _Ch0_Counter = 0
end

   macro _Set_SFX_By_Prio
   asm
   LDA {1}
	CMP _Ch0_Sound
   BCC .skip_Set_SFX
	STA _Ch0_Sound
	LDX #1
	STX _Ch0_Duration
	DEX
	STX _Ch0_Counter
.skip_Set_SFX
end
end

;#endregion

;#region "Constants"

   ; PlusROM HSC Id (https://highscore.firmaplus.de/index.php?game_id=49)
   const HighScoreDB_ID = 49

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
   const switch_player_0_color = 1

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

   const _Bonus_Points_50    = 2
   const _Bonus_Points_100   = 5
   const _Bonus_Points_500   = 8
   const _Bonus_Points_1000  = 11
   const _Bonus_Points_1500  = 14
   const _Bonus_Points_5000  = 17
   const _Bonus_Points_10000 = 20

   const _Sfx_Mute              = 0
   const _Sfx_Enemy_Down_1      = 1
   const _Sfx_Player_Shot       = 2
   const _Sfx_Enemy_Hit         = 3
   const _Sfx_Enemy_Down        = 4
   const _Sfx_Power_Up          = 5
   const _Sfx_Bonus_Life        = 6
   const _Sfx_Looping           = 7
   const _Sfx_Looping_1         = 8
   const _Sfx_Player_Explosion  = 9
   const _Sfx_Respawn_Bass      = 10
   const _Sfx_Takeoff           = 11
   const _Sfx_Landing           = 12
   const _Sfx_Game_Over_Bass    = 13

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

   const _Power_Up_Dark_Gray_Quad_Gun       = _06
   const _Power_Up_White_Enemy_Crash        = _0E
   const _Power_Up_Light_Gray_Side_Fighters = _0A
   const _Power_Up_Black_Extra_Life         = _00
   const _Power_Up_Orange_No_Enemy_Bullets  = _FA
   const _Power_Up_Yellow_Extra_Loop        = _1E
   const _Power_Up_Red_1000_Points          = _42

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
   const _Score_Table_High         = >scoretable
   const _Score_Table_Low          = <scoretable

   const _Power_Up_high            = >_Power_Up
   const _Power_Up_low             = <_Power_Up
   const _Power_Up_height          = _Power_Up_length + 1

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

;#endregion

;#region "Zeropage Variables"

   dim playerpointerlo   = player1pointerlo
   dim playerpointerhi   = player1pointerhi
   dim PF1pointerhi      = PF1pointer + 1
   dim PF2pointerhi      = PF2pointer + 1
   dim SpriteGfxIndex1   = SpriteGfxIndex
   dim SpriteGfxIndex2   = SpriteGfxIndex + 1
   dim SpriteGfxIndex3   = SpriteGfxIndex + 2
   dim SpriteGfxIndex4   = SpriteGfxIndex + 3
   dim SpriteGfxIndex5   = SpriteGfxIndex + 4

   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2

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

   dim Player0SwitchColor     = s
   dim unused2        = t

   dim enemies_shoot_down     = u
   dim enemies_in_park_pos    = v
   dim stage                  = w
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
   dim _Bit0_intro            = z
   dim _Bit1_reset_restrainer = z
   dim _Bit2_looping          = z
   dim _Bit3_mute_bg_music    = z
   dim _Bit4_genesispad       = z
   dim _Bit5_PlusROM          = z
   dim _Bit6_p0_explosion     = z
   dim _Bit7_powerup          = z

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
   dim w_NUSIZ0              = w127
   dim r_NUSIZ0              = r127
   dim w_COLUPF              = w126
   dim r_COLUPF              = r126
   dim w_stage_bonus_counter = w125
   dim r_stage_bonus_counter = r125
   dim w_COLUP0              = w124 
   dim r_COLUP0              = r124
   dim w_CTRLPF              = w123
   dim r_CTRLPF              = r123

   dim w_player5hits_c      = w119
   dim r_player5hits_c      = r119
   dim w_player4hits_c      = w118
   dim r_player4hits_c      = r118
   dim w_player3hits_c      = w117
   dim r_player3hits_c      = r117
   dim w_player2hits_c      = w116
   dim r_player2hits_c      = r116
   dim w_player1hits_c      = w115
   dim r_player1hits_c      = r115
   dim w_playerhits_c       = w115
   dim r_playerhits_c       = r115

   dim w_player5hits_b      = w114
   dim r_player5hits_b      = r114
   dim w_player4hits_b      = w113
   dim r_player4hits_b      = r113
   dim w_player3hits_b      = w112
   dim r_player3hits_b      = r112
   dim w_player2hits_b      = w111
   dim r_player2hits_b      = r111
   dim w_player1hits_b      = w110
   dim r_player1hits_b      = r110
   dim w_playerhits_b       = w110
   dim r_playerhits_b       = r110

   dim w_player5hits_a      = w109
   dim r_player5hits_a      = r109
   dim w_player4hits_a      = w108
   dim r_player4hits_a      = r108
   dim w_player3hits_a      = w107
   dim r_player3hits_a      = r107
   dim w_player2hits_a      = w106
   dim r_player2hits_a      = r106
   dim w_player1hits_a      = w105
   dim r_player1hits_a      = r105
   dim w_playerhits_a       = w105
   dim r_playerhits_a       = r105

;#endregion


   bank 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 1 Game Logic"

   scorecolor = _0E

   game_flags = 0
   if INPT1{7} then _Bit4_genesispad{4} = 1
   if ReceiveBufferSize = 0 then _Bit5_PlusROM{5} = 1

   goto titlescreen_start bank7
 

start

   rem initial variables setup
   missile0y = 0 : framecounter = 0 : attack_position = 0 : enemies_in_park_pos = 0 : w_stage_bonus_counter = 0
   map_section = _Map_Carrier
   player0x = _Player0_X_Start : player0y = _Player0_Y_Start
   lives = 64 : score = 0 : stage = $20
   game_flags = game_flags & %00110000  ; Reset all except genesis controller and PlusROM detection
   game_flags = game_flags | %00001001  ; Set intro and mute bg music
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
   w_NUSIZ0 = 0

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

   goto __BG_Music_Setup_01 bank6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Mainloop"
main
   if switchreset then goto titlescreen_start bank7

   framecounter = framecounter + 1
   COLUBK = _96
   COLUP0 = _40 
   Player0SwitchColor = r_COLUP0
   
   lifecolor = _EA : COLUPF = r_COLUPF
   if PF1pointerhi = _PF1_Pacific_high then CTRLPF = r_CTRLPF : NUSIZ0 = r_NUSIZ0

   if _Bit0_intro{0} then goto stage_intro bank2

   ;if _Ch0_Sound = _Sfx_Respawn_Bass then goto _skip_game_action

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Player 0 explosion animation"
   if !_Bit6_p0_explosion{6} then _skip_player0_explosion

   if framecounter{0} then _skip_player0_collision

   player_animation_state = player_animation_state + 1
   if player_animation_state = 48 then _player0_animation_end
   temp1 = player_animation_state / 8
   w_COLUP0 = _player0_explosion_color_table[temp1]
   player0pointerlo = _player0_explosion_pointerlo_table[temp1]
   player0pointerhi = _player0_explosion_pointerhi_table[temp1]
   player0height = _player0_explosion_height_table[temp1]
   goto _skip_player0_collision

_player0_animation_end
   player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height : _Bit6_p0_explosion{6} = 0
   if lives < 32 then WriteToBuffer = _sc1 : WriteToBuffer = _sc2 : WriteToBuffer = _sc3 : WriteToBuffer = stage : WriteSendBuffer = HighScoreDB_ID : AUDV0 = 0 : AUDV1 = 0 : goto __Game_Over_Music_Setup_01 bank6
   lives = lives - 32 : player0x = _Player0_X_Start : player0y = _Player0_Y_Start
   statusbarlength = %10101000 : w_COLUP0 = _EA
   attack_position = attack_position - 1
   enemies_in_park_pos = 1 : goto __Respawn_Music_Setup bank6
_skip_player0_explosion
;#endregion

   if enemies_in_park_pos then enemies_in_park_pos = 0 : goto build_attack_position bank2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Collision check for missile 0"
   if !_Bit7_map_E_collsion{7} || _Bit2_looping{2} then goto _skip_player0_collision
   if !_Bit6_map_PF_collision{6} then goto _skip_m0_pf_collision
   if collision(missile0, playfield) then temp3 = 0 : temp1 = 4 : goto _end_collision_check bank3 else goto _skip_missile0_collision
_skip_m0_pf_collision
   if !collision(player1, missile0) then goto _skip_missile0_collision
   if _Bit7_powerup{7} then goto _skip_missile0_collision

   goto _collision_detection bank3

_skip_missile0_collision
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Collision check for player 0"
   if _Bit6_map_PF_collision{6} && collision(player0, playfield) then _player0_collision
   if !_Bit7_map_E_collsion{7} || !collision(player0, player1) then goto _skip_player0_collision
   if _Bit7_powerup{7} then goto power_up_bonus
_player0_collision
   _Ch0_Sound = _Sfx_Player_Explosion : _Ch0_Duration = 1
   _Ch0_Counter = 0 : player_animation_state = 0 : missile0y = 0 : w_NUSIZ0 = 0
   _Bit6_p0_explosion{6} = 1
   goto _skip_game_action

_skip_player0_collision
;#endregion

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
   temp4 = _plane_parking_point_bank1[temp1]
   if NewSpriteY[temp1] < temp4 then NewSpriteY[temp1] = NewSpriteY[temp1] - _Pf_Pixel_Height else goto _next_superstructure

   temp3 = NewSpriteY[temp1] - playerfullheight[temp1]
   if spriteheight[temp1] < playerfullheight[temp1]  && temp3 < 85 && NewSpriteY[temp1] > spriteheight[temp1] then spriteheight[temp1] = spriteheight[temp1] + _Pf_Pixel_Height : NewSpriteY[temp1] = 84
   if spriteheight[temp1] > playerfullheight[temp1] then spriteheight[temp1] = playerfullheight[temp1]
   if spriteheight[temp1] > NewSpriteY[temp1] && spriteheight[temp1] > _Pf_Pixel_Height then spriteheight[temp1] = spriteheight[temp1] - _Pf_Pixel_Height : playerpointerlo[temp1] = playerpointerlo[temp1] + _Pf_Pixel_Height

   if NewSpriteY[temp1] < 2 || NewSpriteY[temp1] > temp4 then NewSpriteY[temp1] = temp4

_next_superstructure
   next
_skip_carrier_superstructures_scrolling

   if PF1pointer = _Map_Takeoff_Point_1 then _Bit0_intro{0} = 1 : framecounter = 0 : goto _skip_game_action
   if PF1pointer = _Map_Takeoff_Sound_Start then _Ch0_Sound = _Sfx_Takeoff : _Ch0_Duration = 1 : _Ch0_Counter = 0 : goto _skip_playfield_restart
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
   temp1 = stage & %00000011
   w_COLUPF = _playfield_color_table[temp1]

_skip_playfield_restart



_skip_scrolling
;#endregion
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Player 0 movement and looping animation"
_check_player_movement
   if _Bit6_p0_explosion{6} then goto _enemies_movement
   if map_section <> _Map_Carrier then _player_movement

   if player0y < _Player0_Y_Start then player0y = player0y + 1
   if player0y > _Player0_Y_Start then player0y = player0y - 1
   if player0x < _Player0_X_Start then player0x = player0x + 1
   if player0x > _Player0_X_Start then player0x = player0x - 1
   
   goto _skip_game_action


_player_movement
   if !_Bit2_looping{2} then goto _check_for_new_looping
   if framecounter{0} then _player_vertical_movement
   player_animation_state = player_animation_state + 1
   
   if player_animation_state = 5 then player0pointerlo = _Player0_Looping_1_low : player0pointerhi = _Player0_Looping_1_high : player0height = _Player0_Looping_1_height
   if player_animation_state < 10 && player0y < _Player0_Y_Max then player0y = player0y + 1 : goto _player_vertical_movement
   if player_animation_state = 10 then player0pointerlo = _Player0_Plane_down_low : player0pointerhi = _Player0_Plane_down_high : player0height = _Player0_Plane_down_height : goto _player_vertical_movement
   if player_animation_state = 25 then player0pointerlo = _Player0_Looping_2_low : player0pointerhi = _Player0_Looping_2_high : player0height = _Player0_Looping_2_height
   if player_animation_state < 30 && player0y > _Player0_Y_Min then player0y = player0y - 1 : COLUP0 = _E6 : goto _player_vertical_movement
   if player_animation_state = 30 then player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height : goto _player_vertical_movement
   if player_animation_state < 40 then player0y = player0y + 1 : goto _player_vertical_movement
   if player_animation_state = 40 then _Bit2_looping{2} = 0
   goto _player_vertical_movement

_check_for_new_looping
   if !statusbarlength then goto _skip_new_looping
   if _Bit4_genesispad{4} && !INPT1{7} then goto set_game_state_looping
   if switchselect || joy1fire then goto set_game_state_looping
_skip_new_looping

_player_horizontal_movement
   if joy0up && player0y < _Player0_Y_Max then player0y = player0y + 1 : goto _player_vertical_movement
   if joy0down && player0y > _Player0_Y_Min then player0y = player0y - 1
_player_vertical_movement
   if joy0left && player0x > _Player0_X_Min then player0x = player0x - 1 : goto _skip_player_movement
   if joy0right && player0x < _Player0_X_Max then player0x = player0x + 1
_skip_player_movement
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Missile 0 movement and animation"
   if missile0y > 88 then missile0y = 0
   if missile0y > 1 || !_Bit7_map_E_collsion{7} then _skip_new_shot
   if _Bit2_looping{2} then _skip_new_shot
   if !joy0fire then _skip_new_shot
   missile0y = player0y + 1
   if r_NUSIZ0{5} then temp1 = 4 else temp1 = 5  ;    temp1 = 5 - ( r_NUSIZ0 / 32)
   missile0x = player0x + temp1
   callmacro _Set_SFX_By_Prio _Sfx_Player_Shot
_skip_new_shot
   if ! missile0y then _skip_missile0_movement
   missile0y = missile0y + 3
   if r_NUSIZ0{5} then temp1 = 3 else temp1 = 2
   if framecounter{0} then missile0x = missile0x - temp1 else missile0x = missile0x + temp1
_skip_missile0_movement
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Missile 1 movement and animation"
_check_enemy_shot
;  if player1x = player0x && n = 0 && player1y < 20 then missile1x = player1x + 5 : missile1y = player1y + 2 :  n = 1
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Enemies and PowerUp movement"
_enemies_movement

   if !_Bit5_map_E_moving{5} then goto _skip_plane_movement

   if player1y = _Player1_Parking_Point && player2y = _Player2_Parking_Point && player3y = _Player3_Parking_Point && player4y = _Player4_Parking_Point && player5y = _Player5_Parking_Point then enemies_in_park_pos = 1 : goto _skip_plane_movement

   if framecounter{1} then temp2 = 1 : temp1 = 2 else temp2 = 0 : temp1 = 0
   if framecounter{0} then temp1 = 2 else temp1 = 0
   
_plane_movement_loop_start

   if _Bit6_map_PF_collision{6} then temp3 = 4 else temp3 = playertype[temp1] & %00000011
   if _Bit7_powerup{7} then temp3 = 5
   temp4 = _plane_parking_point_bank1[temp1]
   temp5 = rand

   on temp3 goto _plane_moves_left _plane_moves_right _plane_moves_down _plane_moves_up _plane_is_missile _plane_is_powerup

_plane_moves_right
   temp3 = NewSpriteX[temp1]
   if NewSpriteX[temp1] > 153 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then goto _check_next_plane
   NewSpriteX[temp1] = temp3 + _Plane_X2_Speed

   if temp3 > player0x && temp5 < 128 then playertype[temp1] = ( playertype[temp1] - 8 ) ^ %00000011 : temp3 = playertype[temp1] / 4 : playerpointerlo[temp1]  = _player_pointer_lo_bank1[temp3] : playerpointerhi[temp1]  = _player_pointer_hi_bank1[temp3] : goto _check_next_plane

   if NewSpriteX[temp1] < 121 then goto _check_next_plane
   if NewNUSIZ[temp1] = %00001011 && NewSpriteX[temp1] > 120 then NewNUSIZ[temp1] = %00001001
   if NewNUSIZ[temp1] = %00001001 && NewSpriteX[temp1] > 136 then NewNUSIZ[temp1] = %00001000
   goto _check_next_plane

_plane_moves_left
   temp3 = NewSpriteX[temp1]
   if !NewNUSIZ[temp1] && temp3 < 2 then NewSpriteY[temp1] = temp4
   if NewSpriteY[temp1] = temp4 then goto _check_next_plane
   NewSpriteX[temp1] = temp3 - _Plane_X2_Speed
   
   if temp3 < player0x && temp5 < 128 then playertype[temp1] = ( playertype[temp1] - 8 ) ^ %00000010 : temp3 = playertype[temp1] / 4 : playerpointerlo[temp1]  = _player_pointer_lo_bank1[temp3] : playerpointerhi[temp1]  = _player_pointer_hi_bank1[temp3] : goto _check_next_plane

   if temp3 < 254 then goto _check_next_plane
   if NewNUSIZ[temp1] then NewNUSIZ[temp1] = NewNUSIZ[temp1] / 2 : NewSpriteX[temp1] = temp3 + 16

   goto _check_next_plane

_plane_moves_down
   temp3 = NewSpriteY[temp1]
   if temp3 = temp4 then goto _check_next_plane
   if temp3 < 2 then NewSpriteY[temp1] = temp4 : goto _check_next_plane
   if temp3 = 40 && temp5 < 128 then playertype[temp1] = playertype[temp1] + 5 : temp5 = playertype[temp1] / 4 : playerpointerlo[temp1] = _player_pointer_lo_bank1[temp5] + 1 - playerfullheight[temp1] : playerpointerhi[temp1] = _player_pointer_hi_bank1[temp5] :  goto _check_next_plane
   NewSpriteY[temp1] = temp3 - _Plane_Y_Speed 
   if temp3 > 70 || temp5 < 128 then goto _check_next_plane
   temp3 = player0x + 8

   if NewSpriteX[temp1] > temp3 then NewSpriteX[temp1] = NewSpriteX[temp1] - _Plane_X1_Speed : goto _check_next_plane
   if NewSpriteX[temp1] < temp3 then NewSpriteX[temp1] = NewSpriteX[temp1] + _Plane_X1_Speed

   goto _check_next_plane

_plane_moves_up
   if NewSpriteY[temp1] > 100 && NewSpriteY[temp1] < 140 then NewSpriteY[temp1] = temp4
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

   goto _check_next_plane

_plane_is_powerup
   if (framecounter & %00000110 ) then _check_next_plane
   temp3 = NewSpriteY[temp1]
   if temp3 < 2 then _Bit7_powerup{7} = 0 : goto park_all_planes
   NewSpriteY[temp1] = temp3 - _Plane_Y_Speed 

_check_next_plane
   temp1 = temp1 + 1
   if temp1 <> 5 && temp1 <> 2 then goto _plane_movement_loop_start


_skip_plane_movement
;#endregion


_skip_game_action

   goto _Play_In_Game_Music bank6

;#endregion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Subroutines and Functions Bank 1"

add_scores_bank1
   temp5 = _sc1
   asm
   LDX temp6
	SED
	CLC
	LDA score+2
	ADC _bonus_points,X
	STA score+2
   DEX
	LDA score+1
	ADC _bonus_points,X
	STA score+1
   DEX
	LDA score
	ADC _bonus_points,X
	STA score
	CLD
end
   if _sc1 < $10 && _sc1 > temp5 && lives < 224 then lives = lives + 32 : _Ch0_Sound = _Sfx_Bonus_Life : _Ch0_Duration = 1 : _Ch0_Counter = 0
   asm
   rts   ; we are not using bB "return" here, because we are using this subroutine only in this bank!
end

power_up_bonus
   _Bit7_powerup{7} = 0
   _Ch0_Sound = _Sfx_Power_Up : _Ch0_Duration = 1 : _Ch0_Counter = 0
   if NewCOLUP1 = _Power_Up_Black_Extra_Life && lives < 224 then lives = lives + 32 : goto _end_power_up_bonus
   if NewCOLUP1 = _Power_Up_Yellow_Extra_Loop && statusbarlength < 170 then statusbarlength = ( statusbarlength / 4 ) + %10000000 : goto _end_power_up_bonus
   if NewCOLUP1 = _Power_Up_Dark_Gray_Quad_Gun then w_NUSIZ0 = r_NUSIZ0 | %00100000 : goto _end_power_up_bonus
   if NewCOLUP1 = _Power_Up_Light_Gray_Side_Fighters then w_NUSIZ0 = r_NUSIZ0 | %00000011 : goto _end_power_up_bonus 
   ; default bonus
   temp6 = _Bonus_Points_1000 : gosub add_scores_bank1

_end_power_up_bonus
   goto park_all_planes
 

set_game_state_looping
   statusbarlength = statusbarlength * 4
   callmacro _Set_SFX_By_Prio _Sfx_Looping
   player_animation_state = 0 : _Bit2_looping{2} = 1
   goto _skip_new_looping

set_game_state_landing_bank1
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Landingzone_Start : PF2pointer = _Map_Landingzone_Start
   map_section = _Map_Carrier : _Bit3_mute_bg_music{3} = 1 : w_COLUPF = _Color_Carrier : NUSIZ0 = 0
   _Ch0_Sound = _Sfx_Landing : _Ch0_Duration = 1 : _Ch0_Counter = 0 : missile0y = 0 : w_stage_bonus_counter = 0 : pfheight = 3
   stage = stage - 1
   if stage = 15 then attack_position = 0

park_all_planes
   player1y = _Player1_Parking_Point
   player2y = _Player2_Parking_Point
   player3y = _Player3_Parking_Point
   player4y = _Player4_Parking_Point
   player5y = _Player5_Parking_Point
   goto _skip_game_action 

;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Data Tables Bank 1"

   data _bonus_points
   $00, $00, $50  ;  +    50 points
   $00, $01, $00  ;  +   100 points
   $00, $05, $00  ;  +   500 points
   $00, $10, $00  ;  +  1000 points
   $00, $15, $00  ;  +  1500 points
   $00, $50, $00  ;  +  5000 points
   $01, $00, $00  ;  + 10000 points
end

   data _player_pointer_lo_bank1
   <_Small_Plane_down,  ( <_Small_Plane_up  + _Small_Plane_up_length  ), <_Small_Plane_lr
   <_Middle_Plane_down, ( <_Middle_Plane_up + _Middle_Plane_up_length ), <_Middle_Plane_lr
   <_Big_Plane_down,    ( <_Big_Plane_up    + _Big_Plane_up_length    )
end

   data _player_pointer_hi_bank1
   >_Small_Plane_down,  >_Small_Plane_up,  >_Small_Plane_lr
   >_Middle_Plane_down, >_Middle_Plane_up, >_Middle_Plane_lr
   >_Big_Plane_down,    >_Big_Plane_up
end

   data _plane_parking_point_bank1
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end

   data _player0_explosion_pointerhi_table
   >_Player0_Explosion_0, >_Player0_Explosion_1, >_Player0_Explosion_2, >_Player0_Explosion_3, >_Player0_Explosion_4
end

   data _player0_explosion_pointerlo_table
   <_Player0_Explosion_0, <_Player0_Explosion_1, <_Player0_Explosion_2, <_Player0_Explosion_3, <_Player0_Explosion_4
end

   data _player0_explosion_color_table
   _4E, _48, _46, _42, _42
end

   data _player0_explosion_height_table
   _Player0_Explosion_0_length, _Player0_Explosion_1_length, _Player0_Explosion_2_length, _Player0_Explosion_3_length, _Player0_Explosion_4_length, 0
end

   data _playfield_color_table
   _Color_Gras_Island, _Color_Sand_Island, _Color_Jungle_Island, _Color_Gras_Island
end

;#endregion

;#endregion

   bank 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 2 Attack Position & Data"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Intro with stage nr"
stage_intro
   if framecounter > 60 then _Bit0_intro{0} = 0 : goto carrier_superstructures_init
   player1x = 80 : player2x = 88
   player1y = 50 : player2y = 50
   _NUSIZ1 = 0 : NUSIZ2 = 0 
   player3y = _Player3_Parking_Point : player4y = _Player4_Parking_Point : player5y = _Player5_Parking_Point  
   player1height = 9 : player2height = 9
   COLUP2 = _0E : _COLUP1 = _0E
   player1pointerhi = _Score_Table_High : player2pointerhi = _Score_Table_High
   temp4 = stage
   if stage > 29 then temp4 = temp4 + 6
   if stage > 19 then temp4 = temp4 + 6
   if stage > 9 then temp4 = temp4 + 6
   temp5 = (temp4 & $0f ) * 8
   player2pointerlo = temp5 + _Score_Table_Low
   temp5 = (temp4 & $f0 ) / 2
   player1pointerlo = temp5 + _Score_Table_Low
   goto _bank_2_code_end
;#endregion


build_attack_position
   if stage > 15 then temp2 = _attack_position_sequence_1[attack_position] else temp2 = _attack_position_sequence_2[attack_position]
   attack_position = attack_position + 1
   enemies_shoot_down = 0
   if temp2 < 226 then goto _read_attack_data
   if temp2 = 226 then map_section = _Map_Boss_down : w_player5hits_a = 25 : temp3 = 0 : PF1pointer = _Map_Boss_Start_dw : PF2pointer = _Map_Boss_Start_dw : w_COLUPF = _D8 : goto set_game_state_boss
   if temp2 = 227 then map_section = _Map_Boss_down : w_player5hits_a = 35 : temp3 = 1 : PF1pointer = _Map_Boss_Start_dw : PF2pointer = _Map_Boss_Start_dw : w_COLUPF = _D6 : goto set_game_state_boss
   if temp2 = 228 then map_section = _Map_Boss_up   : w_player5hits_a = 55 : temp3 = 2 : PF1pointer = _Map_Boss_Start_up : PF2pointer = _Map_Boss_Start_up : w_COLUPF = _D6 : goto set_game_state_boss
   if temp2 = 229 then map_section = _Map_Boss_up   : w_player5hits_a = 70 : temp3 = 3 : PF1pointer = _Map_Boss_Start_up : PF2pointer = _Map_Boss_Start_up : w_COLUPF = _D4 : goto set_game_state_boss
   if temp2 = 254 then goto set_game_state_landing
   if temp2 = 255 then  WriteToBuffer = _sc1 : WriteToBuffer = _sc2 : WriteToBuffer = _sc3 : WriteToBuffer = stage : WriteSendBuffer = HighScoreDB_ID : AUDV0 = 0 : AUDV1 = 0 : goto _bB_Endscreen_entry_bank4 bank4
_read_attack_data
   for temp1 = 0 to 4
      temp3             = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewSpriteX[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewSpriteY[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewNUSIZ[temp1]   = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewCOLUP1[temp1]  = _attack_position_data[temp2] : temp2 = temp2 + 1

      playertype[temp1] = temp3
      temp3 = temp3 / 4

      playerpointerlo[temp1]  = _player_pointer_lo[temp3]
      playerpointerhi[temp1]  = _player_pointer_hi[temp3]
      playerfullheight[temp1] = _player_full_height[temp3]
      spriteheight[temp1]     = _player_full_height[temp3]
      temp5                   = _player_max_hits[temp3]

      w_playerhits_a[temp1]   = temp5
      w_playerhits_b[temp1]   = temp5
      w_playerhits_c[temp1]   = temp5

   next


_bank_2_code_end
   goto _Play_In_Game_Music bank6


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Subroutines and Functions Bank 2"
set_game_state_landing
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Landingzone_Start : PF2pointer = _Map_Landingzone_Start
   map_section = _Map_Carrier : _Bit3_mute_bg_music{3} = 1 : w_COLUPF = _Color_Carrier : NUSIZ0 = 0
   _Ch0_Sound = _Sfx_Landing : _Ch0_Duration = 1 : _Ch0_Counter = 0 : missile0y = 0 : w_stage_bonus_counter = 0 : pfheight = 3
   stage = stage - 1
   if stage = 15 then attack_position = 0
   player1y = _Player1_Parking_Point
   player2y = _Player2_Parking_Point
   player3y = _Player3_Parking_Point
   player4y = _Player4_Parking_Point
   player5y = _Player5_Parking_Point
   goto _bank_2_code_end

set_game_state_boss
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   pfheight = 0
   for temp1 = 0 to 4
      NewSpriteY[temp1] = _plane_parking_point[temp1] + 5
      NewNUSIZ[temp1]   = temp3
      NewCOLUP1[temp1]  = _36

      playerpointerlo[temp1]  = _Ayako_Missile_low
      playerpointerhi[temp1]  = _Ayako_Missile_high
      playerfullheight[temp1] = _Ayako_Missile_height
      spriteheight[temp1]     = _Ayako_Missile_height
   next
   goto _bank_2_code_end

carrier_superstructures_init
   _COLUP1 = _0A : COLUP2 = _0A : COLUP3 = _0A : COLUP4 = _0A : COLUP5 = _02 : map_section = _Map_Carrier
   player1pointerlo = _Carrier_88_low     : player1pointerhi = _Carrier_88_high     : player1height =  0 : player1fullheight = _Carrier_88_height     : _NUSIZ1 = 7 : player1x =  69 : player1y = 130
   player2pointerlo = _Carrier_Runway_low : player2pointerhi = _Carrier_Runway_high : player2height =  0 : player2fullheight = _Carrier_Runway_height :  NUSIZ2 = 7 : player2x =  71 : player2y = 100
   player3pointerlo = _Carrier_Runway_low : player3pointerhi = _Carrier_Runway_high : player3height =  2 : player3fullheight = _Carrier_Runway_height :  NUSIZ3 = 5 : player3x =  78 : player3y = _Player3_Parking_Point
   player4pointerlo = _Carrier_Runway_low : player4pointerhi = _Carrier_Runway_high : player4height =  3 : player4fullheight = _Carrier_Runway_height :  NUSIZ4 = 7 : player4x =  69 : player4y =  20
   player5pointerlo = _Carrier_Tower_low  : player5pointerhi = _Carrier_Tower_high  : player5height = 62 : player5fullheight = _Carrier_Tower_height  :  NUSIZ5 = 5 : player5x = 105 : player5y =  88
   goto _bank_2_code_end
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Data Tables Bank2"
   data _player_max_hits
   1, 1, 1
   3, 3, 3
   5, 5
end

   data _player_pointer_lo
   <_Small_Plane_down,  ( <_Small_Plane_up  + _Small_Plane_up_length  ), <_Small_Plane_lr
   <_Middle_Plane_down, ( <_Middle_Plane_up + _Middle_Plane_up_length ), <_Middle_Plane_lr
   <_Big_Plane_down,    ( <_Big_Plane_up    + _Big_Plane_up_length    )
end

   data _player_pointer_hi
   >_Small_Plane_down,  >_Small_Plane_up,  >_Small_Plane_lr
   >_Middle_Plane_down, >_Middle_Plane_up, >_Middle_Plane_lr
   >_Big_Plane_down,    >_Big_Plane_up
end

   data _player_full_height
   _Small_Plane_down_length + 1,  _Small_Plane_up_length + 1,  _Small_Plane_lr_length + 1
   _Middle_Plane_down_length + 1, _Middle_Plane_up_length + 1, _Middle_Plane_lr_length + 1
   _Big_Plane_down_length + 1,    _Big_Plane_up_length + 1
end

   data _plane_parking_point
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end

   const p1p = _Player1_Parking_Point
   const p2p = _Player2_Parking_Point
   const p3p = _Player3_Parking_Point
   const p4p = _Player4_Parking_Point
   const p5p = _Player5_Parking_Point

  ;  1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16
  ;225,175,180,185,190,195,200, 50,225,254                         ; test stage 
   data _attack_position_sequence_1
     0, 25, 225, 50,  0,25, 75, 50,225,254                         ; stage 32
     0,125,225,150, 75, 75,125,  0,225, 50,254                     ; stage 31
    25, 25, 75,225, 50,100,  0,125,225,150, 75,254                 ; stage 30
     0,125,225,150, 75, 75,125,  0, 25,225,150,175,200,254         ; stage 29
    50,100,225,125, 25,150, 75, 75,125,  0,225,125,125,100,254     ; stage 28
    25, 75, 50, 50,225,  0,125, 25,150, 75, 75,225, 75,125,254     ; stage 27
     0,  0, 25, 50,100,225,150, 75, 75,125, 75, 75,225,125,100,226 ; stage 26 Boss 1
    25, 75, 50,225,100,  0,125, 25,150, 50,225, 25,  0,100,100,254 ; stage 25
     0,  0, 25,225,  0,125, 75, 50, 50,100,225, 75,150,175,200,254 ; stage 24
    50,100,  0,125,225,150,125, 75,150,175,200,225, 75,125,  0,254 ; stage 23
     0,  0, 25, 50,  0,225, 75, 50, 50,  0, 25, 75,225,200,100,254 ; stage 22
    25, 75, 50,  0,225, 75, 50,125, 50,100,  0,125,225,150,  0,254 ; stage 21
     0,  0, 25,225,125, 25,150, 75, 75,  0, 25, 75,225, 50,100,254 ; stage 20
    50,100,225, 25, 75,150,175,200,125, 25,150, 75,225,125,  0,254 ; stage 19
   225,  0,  0, 25, 50,100,100,150,200,125, 75, 75,225,125,  0,227 ; stage 18 Boss 2
    50,100,  0,225, 25,150, 75, 75,125, 25,150,225, 75,125,  0,254 ; stage 17
     0,  0, 25, 50,125, 25,150,225, 75,  0, 25,225, 50, 50,100,254 ; stage 16
end

   ; 1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16 17
   data _attack_position_sequence_2
    25, 75,225, 50,100,  0,125, 25,150, 50,  0, 25,  0,100,225,100,254 ; stage 15
     0,  0, 25,225,  0, 25, 75, 50, 50,100, 25, 75,225,175,175,200,254 ; stage 14
    50,100,  0,125,225,150, 25, 75,150,175,200, 75, 75,225,125,  0,254 ; stage 13
     0,  0,225, 50,  0, 25, 75, 50, 50,  0, 25, 75,225,200,200,100,254 ; stage 12
    25, 75,225,  0, 25, 75, 50,125, 50,100,  0,125, 25,150,225,  0,254 ; stage 11
     0,  0,225, 50,100,100,150, 75, 75,125, 75, 75,125,225,125,100,228 ; stage 10 Boss 3
    25, 75, 50, 50,225,  0,125, 25,150, 50,  0, 25,  0,100,225,100,254 ; stage 09
     0,  0, 25, 50,225, 25, 75, 50, 50,100, 25, 75,225,175,175,200,254 ; stage 08
    50,100,  0,225, 25,150, 25, 75,150,175,200, 75,225,125,125,  0,254 ; stage 07
     0,  0,225, 50,  0, 25, 75, 50, 50,  0, 25, 75, 50,225,200,100,254 ; stage 06
    25, 75, 50,225, 25, 75, 50,125, 50,100,  0,125, 25,150,225,  0,254 ; stage 05
     0,  0,225, 50,125, 25,150, 75, 75,  0, 25, 75,225, 50, 50,100,254 ; stage 04
    50,225,  0, 25, 75,150,175,200,125, 25,150, 75, 75,125,225,  0,254 ; stage 03
   225,  0,  0, 25, 50,100,100,150,200,125, 75, 75,125,225,125,  0,229 ; stage 02 Boss 4
    50,100,  0,125, 25,150, 75, 75,225, 25,150, 75, 75,125,225,  0,255 ; stage 01
end

 rem playertype, NewSpriteX, NewSpriteY, NewNUSIZ, NewCOLUP
   data _attack_position_data
      %00000010,         40,         88,       0, _D6  ; (0) 5 small planes from top
      %00000010,        110,         98,       0, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,         20,        118,       0, _D6
      %00000010,         50,        128,       0, _D6

      %00001110,         40,         88,       0, _D4  ; (25) 1 middle + 4 small planes from top
      %00000010,         30,         98,       0, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,         20,        118,       0, _D6
      %00000010,         50,        128,       0, _D6

      %00001001,          0,         84,       9, _D6  ; (50) 2x2 small planes from left 
      %00001001,          0,         74,       9, _D6 
      %00001000,        158,         64,       1, _D6  ; 2x2 small planes from right
      %00001000,        158,         54,       1, _D6
      %00011111,         50,        p5p,       0, _D4

      %00001001,          0,         84,       9, _D6  ; (75)
      %00001001,          0,         74,       9, _D6
      %00001000,        158,         64,       1, _D6
      %00001000,        158,         54,       1, _D6
      %00011111,         50,        p5p,       0, _D4

      %00000010,         20,         88,       1, _D4  ; (100)
      %00000010,        110,         98,       1, _D6
      %00000010,         20,        108,       1, _D6
      %00011111,        125,        247,       7, _D4
      %00011111,         75,          1,       7, _D4

      %00000010,         75,         88,      11, _D4
      %00000010,         20,         98,      11, _D6
      %00000010,        110,        108,       0, _D6
      %00000010,         90,        118,       0, _D6
      %00011111,         30,          1,       7, _D4

      %00000010,         40,         88,       6, _D6  ; (150) 5x 3 Small planes distance medium from top
      %00000010,         72,         98,       6, _D6
      %00000010,         40,        108,       6, _D6
      %00000010,         72,        118,       6, _D6
      %00000010,         40,        128,       6, _D6

      %00000010,         20,         88,       3, _D6  ; (175)
      %00000010,         40,         98,       3, _D6
      %00000010,         60,        108,       3, _D6
      %00000010,         80,        118,       3, _D6
      %00000010,        100,        128,       3, _D6

      %00011111,          8,          1,       7, _D4  ; (200)
      %00011111,         40,        244,       7, _D4
      %00011111,         72,        231,       7, _D4
      %00011111,        104,        218,       7, _D4
      %00011111,        136,        205,       7, _D4

      %00000010,         40,         88,       0, _42  ; (225) 5 small red planes (power up) from top
      %00000010,         50,         98,       0, _42
      %00000010,         60,        108,       0, _42
      %00000010,         70,        118,       0, _42
      %00000010,         80,        128,       0, _42
end
;#endregion

;#endregion

   bank 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 3 Collsision detection for missile 0"

_collision_detection
   ; temp3 = bit_shift_table[SpriteGfxIndex1] | bit_shift_table[SpriteGfxIndex2] | bit_shift_table[SpriteGfxIndex3] | bit_shift_table[SpriteGfxIndex4] | bit_shift_table[SpriteGfxIndex5]
   ; this assembly block is doing the same than the bB line above, but faster and less ROM space.
   ; We set a bit flag in temp3 for each player1 sprite that was displayed in the last frame.
   ; Sprites that overlap and were omitted due to the kernel's flicker management may not have collided
   ; with the missile and need not be considered for our detection later.
   asm
 	LDX SpriteGfxIndex
	LDA bit_shift_table,x
	LDX SpriteGfxIndex+1
	ORA bit_shift_table,x
	LDX SpriteGfxIndex+2
	ORA bit_shift_table,x
	LDX SpriteGfxIndex+3
	ORA bit_shift_table,x
	LDX SpriteGfxIndex+4
	ORA bit_shift_table,x
	STA temp3
end

   if temp3{0} then temp1 = player1y + 1 : temp2 = player1y - player1height : if missile0y > temp2 && missile0y < temp1 then temp1 = 0 : goto multi_collision_check
   
   if temp3{1} then temp1 = player2y + 1 : temp2 = player2y - player2height : if missile0y > temp2 && missile0y < temp1 then temp1 = 1 : goto multi_collision_check
   
   if temp3{2} then temp1 = player3y + 1 : temp2 = player3y - player3height : if missile0y > temp2 && missile0y < temp1 then temp1 = 2 : goto multi_collision_check

   if temp3{3} then temp1 = player4y + 1 : temp2 = player4y - player4height : if missile0y > temp2 && missile0y < temp1 then temp1 = 3 : goto multi_collision_check
 
   temp1 = 4

multi_collision_check
   temp2 = NewNUSIZ[temp1] & %00000111
   temp4 = NewSpriteX[temp1]
   temp5 = temp4 - 8
   temp3 = 0
   on temp2 goto _end_collision_check _two_copies_close _two_copies_medium _three_copies_close _two_copies_wide _end_collision_check _three_copies_medium _end_collision_check

_two_copies_close
   rem X.X
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 0 : goto _end_collision_check 
   temp4 = temp4 + 16 : temp5 = temp5 + 16
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 1
   goto _end_collision_check
_two_copies_medium
   rem X...X
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 0 : goto _end_collision_check 
   temp4 = temp4 + 32 : temp5 = temp4 - 8
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 1
   goto _end_collision_check
_three_copies_close
   rem X.X.X
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 0 : goto _end_collision_check 
   temp4 = temp4 + 16 : temp5 = temp4 - 8
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 1 : goto _end_collision_check 
   temp4 = temp4 + 16 : temp5 = temp4 - 8
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 2
   goto _end_collision_check
_two_copies_wide
   rem X.......X
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 0 : goto _end_collision_check 
   temp4 = temp4 + 64 : temp5 = temp4 - 8
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 1
   goto _end_collision_check
_three_copies_medium
   rem X...X...X
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 0 : goto _end_collision_check 
   temp4 = temp4 + 32 : temp5 = temp4 - 8
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 1 : goto _end_collision_check 
   temp4 = temp4 + 32 : temp5 = temp4 - 8
   if missile0x <= temp4 && missile0x >= temp5 then temp3 = 2

_end_collision_check
   temp4 = temp1 + ( temp3 * 5 )
   temp5 = r_playerhits_a[temp4] - 1
   w_playerhits_a[temp4] = temp5

   ; temp1 = id of player1 that has been hit (0 - 4)
   ; temp2 = NUSIZ of the player1
   ; temp3 = NUSIZ copy thats been hit (0 - 2)
   ; temp4 = hitcounter id of this copy
   ; temp5 = hitcounter

   if !temp5 then goto _enemy_explosion
   callmacro _Set_SFX_By_Prio _Sfx_Enemy_Hit
   temp6 = _Bonus_Points_100
   goto _add_collision_score
_enemy_explosion
   callmacro _Set_SFX_By_Prio _Sfx_Enemy_Down
   if _Bit6_map_PF_collision{6} then temp6 = _Bonus_Points_10000 : gosub add_scores : goto set_game_state_landing_bank3
   enemies_shoot_down = enemies_shoot_down + 1
   if enemies_shoot_down = 5 && COLUP2 = _42 then goto set_game_state_powerup

   on temp2 goto _del_one_copy _del_two_copies_close _del_two_copies_medium _del_three_copies_close _del_two_copies_wide _del_one_copy _del_three_copies_medium _del_one_copy

_del_one_copy
   player1y[temp1] = _plane_parking_point_bank3[temp1]
   goto _determine_collision_score

_del_two_copies_close
   NewNUSIZ[temp1] = 0
   if temp3 = 0 then player1x[temp1] = player1x[temp1] + 16 : gosub swap_a_b_hits
   goto _determine_collision_score
_del_two_copies_medium
   NewNUSIZ[temp1] = 0
   if temp3 = 0 then player1x[temp1] = player1x[temp1] + 32 : gosub swap_a_b_hits
   goto _determine_collision_score
_del_three_copies_close
   if temp3 = 1 then NewNUSIZ[temp1] = 2 : goto _swap_b_c_hits
   NewNUSIZ[temp1] = 1
   if temp3 = 0 then player1x[temp1] = player1x[temp1] + 16 : gosub swap_a_b_hits : goto _swap_b_c_hits
   goto _determine_collision_score
_del_two_copies_wide 
   NewNUSIZ[temp1] = 0
   if temp3 = 0 then player1x[temp1] = player1x[temp1] + 64 : gosub swap_a_b_hits
   goto _determine_collision_score
_del_three_copies_medium
   if temp3 = 1 then NewNUSIZ[temp1] = 4 : goto _swap_b_c_hits
   NewNUSIZ[temp1] = 2
   if temp3 = 0 then player1x[temp1] = player1x[temp1] + 32 : gosub swap_a_b_hits : goto _swap_b_c_hits
   goto _determine_collision_score   

_swap_b_c_hits
   w_playerhits_b[temp1] = r_playerhits_c[temp1]

_determine_collision_score
   if playertype[temp1] < 3 then temp6 = _Bonus_Points_50 : goto _add_collision_score
   if playertype[temp1] < 6 then temp6 = _Bonus_Points_500 else temp6 = _Bonus_Points_1500
_add_collision_score
   gosub add_scores

_end_collision
   missile0y = 0

_bank_3_code_end
   goto _Play_In_Game_Music bank6



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Subroutines and Functions Bank 3"

add_scores
   temp5 = _sc1
   asm
   LDX temp6
	SED
	CLC
	LDA score+2
	ADC _bonus_points_bank3,X
	STA score+2
   DEX
	LDA score+1
	ADC _bonus_points_bank3,X
	STA score+1
   DEX
	LDA score
	ADC _bonus_points_bank3,X
	STA score
	CLD
end
   if _sc1 < $10 && _sc1 > temp5 && lives < 224 then lives = lives + 32 : _Ch0_Sound = _Sfx_Bonus_Life : _Ch0_Duration = 1 : _Ch0_Counter = 0
   asm
   rts   ; we are not using bB "return" here, because we are using this subroutine only in this bank!
end

swap_a_b_hits
   w_playerhits_a[temp1] = r_playerhits_b[temp1]
   asm
   rts   ; we are not using bB "return" here, because we are using this subroutine only in this bank!
end

set_game_state_powerup
   temp2 = (stage - 1 ) * 2   +  r_stage_bonus_counter
   NewCOLUP1 = _bonus_list[temp2] : NewCOLUP1[temp1] = _bonus_list[temp2] : NewNUSIZ[temp1] = 0
   playerpointerlo[temp1] = _Power_Up_low
   playerpointerhi[temp1] = _Power_Up_high
   player1height[temp1] = _Power_Up_height
   player1fullheight[temp1] = _Power_Up_height
   _Bit7_powerup{7} = 1 :  w_stage_bonus_counter = r_stage_bonus_counter + 1
   goto _determine_collision_score



set_game_state_landing_bank3
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Landingzone_Start : PF2pointer = _Map_Landingzone_Start
   map_section = _Map_Carrier : _Bit3_mute_bg_music{3} = 1 : w_COLUPF = _Color_Carrier : NUSIZ0 = 0
   _Ch0_Sound = _Sfx_Landing : _Ch0_Duration = 1 : _Ch0_Counter = 0 : missile0y = 0 : w_stage_bonus_counter = 0 : pfheight = 3
   stage = stage - 1
   if stage = 15 then attack_position = 0

   player1y = _Player1_Parking_Point
   player2y = _Player2_Parking_Point
   player3y = _Player3_Parking_Point
   player4y = _Player4_Parking_Point
   player5y = _Player5_Parking_Point
   goto _bank_3_code_end 

;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Data Tables Bank 3"

   data _bonus_points_bank3
   $00, $00, $50  ;  +    50 points
   $00, $01, $00  ;  +   100 points
   $00, $05, $00  ;  +   500 points
   $00, $10, $00  ;  +  1000 points
   $00, $15, $00  ;  +  1500 points
   $00, $50, $00  ;  +  5000 points
   $01, $00, $00  ;  + 10000 points
end

   data bit_shift_table
   1, 2, 4, 8, 16
end

   data _plane_parking_point_bank3
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end

   data _bonus_list
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 01
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 02
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 03
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Black_Extra_Life ; Stage 04
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 05
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 06
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 07
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Black_Extra_Life ; Stage 08
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 09
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 10
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 11
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 12
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 13
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 14
   _Power_Up_Orange_No_Enemy_Bullets,  _Power_Up_Black_Extra_Life ; Stage 15
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 16
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 17
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 18
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 19
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Black_Extra_Life ; Stage 20
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 21
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 22
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 23
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 24
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 25
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 26
   _Power_Up_Orange_No_Enemy_Bullets,  _Power_Up_Black_Extra_Life ; Stage 27
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 28
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 29
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 30
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 31
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 32
end

;#endregion

;#endregion

   bank 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 4 Text Screens"

   asm
  ; 24 Char textkernel by AtariAge member c-dw
  ; https://atariage.com/forums/blogs/entry/4523-13-lines/

NO_ILLEGAL_OPCODES = 0
TEXTHEIGHT  = 4

  ; Alphabet Constants
_COMMA  = 0
_DOT    = 1
__      = (1 * TEXTHEIGHT)
_A      = (2 * TEXTHEIGHT)
_B      = (3 * TEXTHEIGHT)
_C      = (4 * TEXTHEIGHT)
_D      = (5 * TEXTHEIGHT)
_E      = (6 * TEXTHEIGHT)
_F      = (7 * TEXTHEIGHT)
_G      = (8 * TEXTHEIGHT)
_H      = (9 * TEXTHEIGHT)
_I      = (10 * TEXTHEIGHT)
_J      = (11 * TEXTHEIGHT)
_K      = (12 * TEXTHEIGHT)
_L      = (13 * TEXTHEIGHT)
_M      = (14 * TEXTHEIGHT)
_N      = (15 * TEXTHEIGHT)
_O      = (16 * TEXTHEIGHT)
_P      = (17 * TEXTHEIGHT)
_Q      = (18 * TEXTHEIGHT)
_R      = (19 * TEXTHEIGHT)
_S      = (20 * TEXTHEIGHT)
_T      = (21 * TEXTHEIGHT)
_U      = (22 * TEXTHEIGHT)
_V      = (23 * TEXTHEIGHT)
_W      = (24 * TEXTHEIGHT)
_X      = (25 * TEXTHEIGHT)
_Y      = (26 * TEXTHEIGHT)
_Z      = (27 * TEXTHEIGHT)
_a      = (28 * TEXTHEIGHT)
_b      = (29 * TEXTHEIGHT)
_c      = (30 * TEXTHEIGHT)
_d      = (31 * TEXTHEIGHT)
_e      = (32 * TEXTHEIGHT)
_f      = (33 * TEXTHEIGHT)
_g      = (34 * TEXTHEIGHT)
_h      = (35 * TEXTHEIGHT)
_i      = (36 * TEXTHEIGHT)
_j      = (37 * TEXTHEIGHT)
_k      = (38 * TEXTHEIGHT)
_l      = (39 * TEXTHEIGHT)
_m      = (40 * TEXTHEIGHT)
_n      = (41 * TEXTHEIGHT)
_o      = (42 * TEXTHEIGHT)
_p      = (43 * TEXTHEIGHT)
_q      = (44 * TEXTHEIGHT)
_r      = (45 * TEXTHEIGHT)
_s      = (46 * TEXTHEIGHT)
_t      = (47 * TEXTHEIGHT)
_u      = (48 * TEXTHEIGHT)
_v      = (49 * TEXTHEIGHT)
_w      = (50 * TEXTHEIGHT)
_x      = (51 * TEXTHEIGHT)
_y      = (52 * TEXTHEIGHT)
_z      = (53 * TEXTHEIGHT)
_0      = (54 * TEXTHEIGHT)
_1      = (55 * TEXTHEIGHT)
_2      = (56 * TEXTHEIGHT)
_3      = (57 * TEXTHEIGHT)
_4      = (58 * TEXTHEIGHT)
_5      = (59 * TEXTHEIGHT)
_6      = (60 * TEXTHEIGHT)
_7      = (61 * TEXTHEIGHT)
_8      = (62 * TEXTHEIGHT)
_9      = (63 * TEXTHEIGHT)
;_BANG   = (64 * TEXTHEIGHT)
;_QMARK  = (65 * TEXTHEIGHT)
;_DASH   = (66 * TEXTHEIGHT)
;_COLON  = (67 * TEXTHEIGHT)


CYCLE=$80
TEMP=$81
LOOP=$82
TPTR0=$83
TPTR1=$85

TEXT=$86
BUFF1=$9e
BUFF2=$C8


RAM_Messages=r000

ROM_Messages
Message0
  DC.B  __, __, __, __, __, __, __, __, __, __, _1, _9, _4, _2, __, __, __, __, __, __, __, __, __, __
Message1
  DC.B  __, __, _T, _O, _P, __, _5, __, _R, _A, _N, _K, _I, _N, _G, __, _S, _C, _O, _R, _E, __, __, __
Message2
  DC.B  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __
Message3
  DC.B  __, __, __, __, __, __, __, _W, _E, __, _G, _I, _V, _E, __, _U, _P, __, __, __, __, __, __, __
Message4
  DC.B  __, __, __, __, __, __, _S, _P, _E, _C, _I, _A, _L, __, _B, _O, _N, _U, _S, __, __, __, __, __
Message5
  DC.B  __, __, __, __, __, _1, _0, _COMMA, _0, _0, _0, _COMMA, _0, _0, _0, __, _P, _T, _S, __, __, __, __, __
Message6
  DC.B  __, __, __, __, __, __, __, __, _G, _A, _M, _E, __, _O, _V, _E, _R, __, __, __, __, __, __, __
Message7
  DC.B  __, __, __, __, __, _P, _R, _E, _S, _E, _N, _T, _E, _D, __, _B, _Y, __, _A, _A, __, __, __, __
Loading_Messages
  DC.B  _L, _o, _a, _d, _i, _n, _g
Shooting_Down_Messages
  DC.B  _S, _H, _O, _O, _T, _I, _N, _G, __, _D, _O, _W, _N

EndMessages
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "HSC Text Screen"

   ;batariBasic entry point to asm bank
_bB_HSC_entry_bank4
   asm

Start_HSC
  ; Wipe Registers & Memory
  ; CLEAN_START

  ; Send request for 1942 HSC table
  lda #0
  sta WriteToBuffer
  lda #HighScoreDB_ID
  sta WriteSendBuffer 

  ; Copy loading message to SC-RAM
  lda #__
  ldx #120
clear_zp_ram_loop
  sta w000-1,x
  DEX
  bne clear_zp_ram_loop

  ldx #7
loading_msg_copy_loop
  lda Loading_Messages-1,x
  sta w033-1,x
  DEX
  bne loading_msg_copy_loop

  ; Set 3 sprite copies
  lda #%00000110
  sta NUSIZ0
  sta NUSIZ1

  ; Delay P0 & P1
  lda #%00000001
  sta VDELP0
  sta VDELP1
  
  ; Set P0/P1 Colours
  lda #_0E
  sta COLUP0
  sta COLUP1

  ; Reflect PF
  lda #1
  sta CTRLPF
  
  ; Set Background _96
  lda #_00
  sta COLUPF
  lda #$C0
  sta PF0
  lda #$FF
  sta PF1
  sta PF2

MainHSCLoop
  ; Do Vertical Sync (VSync Routine by Manuel Polik)
  lda #2
  sta WSYNC
  sta VSYNC
  sta WSYNC
  sta WSYNC
  lsr
  sta WSYNC
  sta VSYNC

  ; Set Vertical Blank Timer 
  ldy #43
  sty TIM64T
  
  ; Update Game Cycle
  dec CYCLE

  ; Clear Sprites
  lda #0
  sta GRP0
  sta GRP1
  sta GRP0
  sta GRP1
  
  ; Set Loop Iterations
  lda #9
  sta LOOP
  
  ; Set Pointer for Forst Message
  lda #176
  jsr LoadText
  
  ; Set Sprite Positions and Preload First Text Line
  jsr TextPosition
  jsr TextCopy

  ; Wait for Vertical Blank End
WaitVblank
  lda INTIM
  bne WaitVblank
  sta WSYNC
  sta VBLANK
  sta WSYNC

  ; Display First Line
  jsr TextKernel

TextLoop
  
  ; Clear Sprite Data
  lda #0
  sta GRP1
  sta GRP0
  sta GRP1
  
  ; Set Next Message Pointer
  ldx LOOP
  lda FontColorsHSC,X
  sta COLUP0
  sta COLUP1
  lda OffsetHSC,X
  jsr LoadText
  
  ; Copy and Display Message
  jsr TextCopy
  jsr TextKernel
  
  ; Decrement Loop
  dec LOOP
  bpl TextLoop
EndKernel


  ; Start Vertical Blank
  lda #2
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta VBLANK
  
  ; Set Timer for Overscan
  ldy #35
  sty TIM64T
end

   if ReceiveBufferSize < 120 then _skip_copy_response_to_SC_RAM

   asm
   LDX #0
.copy_loop
   LDA	ReceiveBuffer   		; 4
   STA	w000,x		   ; 5   
   INX					         ; 2   
   LDA	ReceiveBufferSize		; 4
   BNE	.copy_loop			   ; 2/3 
end

_skip_copy_response_to_SC_RAM
   if joy0right then goto restart_bB bank8


   asm
  ; Finish Overscan
WaitOverscanEnd
  lda INTIM
  bne WaitOverscanEnd
  
  ; Loop To Beginning
  jmp MainHSCLoop
;#endregion


; Colors and rows tables  
FontColorsHSC
  DC.B  _0E, _0E, _EA, _EA, _EA, _EA, _EA, _0E, _44, _D4, _0E
OffsetHSC
  DC.B  176, 176, 96, 72, 48, 24, 0, 176, 152, 128

OffsetEndscreen
  DC.B  48, 48, 168, 144, 48, 120, 96, 48, 72, 48
FontColorsEndscreen
  DC.B  _0E, _08, _8A, _44, _0E, _58, _EA, _0E, _44, _0E, _0E

OffsetGameOver
  DC.B  48, 48, 48, 144, 48, 48, 48, 48, 48, 48
FontColorsGameOver
  DC.B  _0E, _08, _8A, _EA, _0E, _58, _EA, _0E, _44, _0E, _0E


  ALIGN 256
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Text Screen Kernel"

TextKernel
  ; Alternate each frame
  lda CYCLE
  lsr
  bcs Kernel1A
  jmp Kernel2A
Kernel1A
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+6                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+13                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+20                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 6                       ; [21] + 6
  lda #0                        ; [27] + 2
  sta HMP0                      ; [29] + 3
  sta HMP1                      ; [32] + 3
  lda BUFF1+27                  ; [35] + 3
  sta GRP1                      ; [38] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+34                  ; [41] + 3
  sta GRP0                      ; [44] + 3      5 7 9 -   > 44 < 52 
  lda BUFF1+41                  ; [47] + 3
  sta GRP1                      ; [50] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [53] + 3      9 11 - -  > 54 < 63
  SLEEP 15                      ; [56] + 15
  sta HMOVE                     ; [71] + 3      = 74!
  lda BUFF1+2                   ; [74] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [1] + 3       - - 0 -
  lda BUFF1+9                   ; [4] + 3
  sta GRP1                      ; [7] + 3       0 - - 2   < 34
  lda BUFF1+16                  ; [10] + 3
  sta GRP0                      ; [13] + 3      0 2 4 -   < 39
  SLEEP 9                       ; [16] + 9
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+23                  ; [33] + 3      
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+30                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+37                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
  ; SPARE 22 CYCLES
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+5                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+12                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+19                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 6                       ; [21] + 6
  lda #0                        ; [27] + 2
  sta HMP0                      ; [29] + 3
  sta HMP1                      ; [32] + 3
  lda BUFF1+26                  ; [35] + 3
  sta GRP1                      ; [38] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+33                  ; [41] + 3
  sta GRP0                      ; [44] + 3      5 7 9 -   > 44 < 52 
  lda BUFF1+40                  ; [47] + 3
  sta GRP1                      ; [50] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [53] + 3      9 11 - -  > 54 < 63
  SLEEP 15                      ; [56] + 15
  sta HMOVE                     ; [71] + 3      = 74!
  lda BUFF1+1                   ; [74] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [1] + 3       - - 0 -
  lda BUFF1+8                   ; [4] + 3
  sta GRP1                      ; [7] + 3       0 - - 2   < 34
  lda BUFF1+15                  ; [10] + 3
  sta GRP0                      ; [13] + 3      0 2 4 -   < 39
  SLEEP 9                       ; [16] + 9
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+22                  ; [33] + 3      
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+29                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+36                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+4                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+11                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+18                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 6                       ; [21] + 6
  lda #0                        ; [27] + 2
  sta HMP0                      ; [29] + 3
  sta HMP1                      ; [32] + 3
  lda BUFF1+25                  ; [35] + 3
  sta GRP1                      ; [38] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+32                  ; [41] + 3
  sta GRP0                      ; [44] + 3      5 7 9 -   > 44 < 52 
  lda BUFF1+39                  ; [47] + 3
  sta GRP1                      ; [50] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [53] + 3      9 11 - -  > 54 < 63
  SLEEP 15                      ; [56] + 15
  sta HMOVE                     ; [71] + 3      = 74!
  lda BUFF1+0                   ; [74] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [1] + 3       - - 0 -
  lda BUFF1+7                   ; [4] + 3
  sta GRP1                      ; [7] + 3       0 - - 2   < 34
  lda BUFF1+14                  ; [10] + 3
  sta GRP0                      ; [13] + 3      0 2 4 -   < 39
  SLEEP 6                       ; [16] + 6
  jmp Kernel1B                  ; [22] + 3
EndKernel1A

  if (>TextKernel != >EndKernel1A)
    echo "WARNING: Kernel1A Crosses Page Boundary!"
  endif

  ALIGN 256
  
Kernel1B
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+21                  ; [33] + 3      
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+28                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+35                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
  ; SPARE 22 CYCLES
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+3                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+10                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+17                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 6                       ; [21] + 6
  lda #0                        ; [27] + 2
  sta HMP0                      ; [29] + 3
  sta HMP1                      ; [32] + 3
  lda BUFF1+24                  ; [35] + 3
  sta GRP1                      ; [38] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+31                  ; [41] + 3
  sta GRP0                      ; [44] + 3      5 7 9 -   > 44 < 52 
  lda BUFF1+38                  ; [47] + 3
  sta GRP1                      ; [50] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [53] + 3      9 11 - -  > 54 < 63
EndKernel1B
  rts
  
Kernel2A
  sta WSYNC                     ; [0]
  lda BUFF1+3                   ; [0] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [3] + 3       - - 0 -
  lda BUFF1+10                  ; [6] + 3
  sta GRP1                      ; [9] + 3       0 - - 2   < 34
  lda BUFF1+17                  ; [12] + 3
  sta GRP0                      ; [15] + 3      0 2 4 -   < 39
  SLEEP 7                       ; [18] + 7
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+24                  ; [33] + 3
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+31                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+38                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+6                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+13                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+20                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 15                      ; [21] + 15
  lda BUFF1+27                  ; [36] + 3
  sta GRP1                      ; [39] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+34                  ; [42] + 3
  sta GRP0                      ; [45] + 3      5 7 9 -   > 44 < 52
  lda BUFF1+41                  ; [48] + 3
  sta GRP1                      ; [51] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [54] + 3      9 11 - -  > 54 < 63
  lda #0                        ; [57] + 2
  sta HMP0                      ; [59] + 3
  sta HMP1                      ; [62] + 3
  SLEEP 6                       ; [65] + 6
  sta HMOVE                     ; [71] + 3      = 74!   
  lda BUFF1+2                   ; [74] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [1] + 3       - - 0 -
  lda BUFF1+9                   ; [4] + 3
  sta GRP1                      ; [7] + 3       0 - - 2   < 34
  lda BUFF1+16                  ; [10] + 3
  sta GRP0                      ; [13] + 3      0 2 4 -   < 39
  SLEEP 9                       ; [16] + 9
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+23                  ; [33] + 3
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+30                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+37                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+5                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+12                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+19                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 15                      ; [21] + 15
  lda BUFF1+26                  ; [36] + 3
  sta GRP1                      ; [39] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+33                  ; [42] + 3
  sta GRP0                      ; [45] + 3      5 7 9 -   > 44 < 52
  lda BUFF1+40                  ; [48] + 3
  sta GRP1                      ; [51] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [54] + 3      9 11 - -  > 54 < 63
  lda #0                        ; [57] + 2
  sta HMP0                      ; [59] + 3
  sta HMP1                      ; [62] + 3
  SLEEP 3                       ; [65] + 3
  jmp Kernel2B                  ; [68] + 3
EndKernel2A
  
  if (>Kernel1B != >EndKernel2A)
    echo "WARNING: Kernel1B/2A Crosses Page Boundary!"
  endif

  ALIGN 256

Kernel2B
  sta HMOVE                     ; [71] + 3      = 74!   
  lda BUFF1+1                   ; [74] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [1] + 3       - - 0 -
  lda BUFF1+8                   ; [4] + 3
  sta GRP1                      ; [7] + 3       0 - - 2   < 34
  lda BUFF1+15                  ; [10] + 3
  sta GRP0                      ; [13] + 3      0 2 4 -   < 39
  SLEEP 9                       ; [16] + 9
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+22                  ; [33] + 3
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+29                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+36                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
  sta WSYNC                     ; [0]
  sta HMOVE                     ; [0] + 3       P0A P1A P0B P1B
  lda BUFF1+4                   ; [3] + 3
  sta GRP0                      ; [6] + 3       - - 0 -
  lda BUFF1+11                  ; [9] + 3
  sta GRP1                      ; [12] + 3      0 - - 3   < 36
  lda BUFF1+18                  ; [15] + 3
  sta GRP0                      ; [18] + 3      0 3 5 -   < 42
  SLEEP 15                      ; [21] + 15
  lda BUFF1+25                  ; [36] + 3
  sta GRP1                      ; [39] + 3      5 3 - 7   > 38 < 47
  lda BUFF1+32                  ; [42] + 3
  sta GRP0                      ; [45] + 3      5 7 9 -   > 44 < 52
  lda BUFF1+39                  ; [48] + 3
  sta GRP1                      ; [51] + 3      9 7 - 11  > 49 < 58
  sta GRP0                      ; [54] + 3      9 11 - -  > 54 < 63
  lda #0                        ; [57] + 2
  sta HMP0                      ; [59] + 3
  sta HMP1                      ; [62] + 3
  SLEEP 6                       ; [65] + 6
  sta HMOVE                     ; [71] + 3      = 74!   
  lda BUFF1+0                   ; [74] + 3      P0A P1A P0B P1B 
  sta GRP0                      ; [1] + 3       - - 0 -
  lda BUFF1+7                   ; [4] + 3
  sta GRP1                      ; [7] + 3       0 - - 2   < 34
  lda BUFF1+14                  ; [10] + 3
  sta GRP0                      ; [13] + 3      0 2 4 -   < 39
  SLEEP 9                       ; [16] + 9
  lda #%10000000                ; [25] + 2
  sta HMP0                      ; [27] + 3
  sta HMP1                      ; [30] + 3
  lda BUFF1+21                  ; [33] + 3
  sta GRP1                      ; [36] + 3      4 2 - 6   > 36 < 44
  lda BUFF1+28                  ; [39] + 3
  sta GRP0                      ; [42] + 3      4 6 8 -   > 41 < 50 
  lda BUFF1+35                  ; [45] + 3
  sta GRP1                      ; [48] + 3      8 6 - 10  > 47 < 55
  sta GRP0                      ; [51] + 3      8 11 - -  > 52 < 60
EndKernel2B
  rts
  
  ; Set Initial Sprite Positions
TextPosition
  lda CYCLE
  lsr
  bcs Position1
  jmp Position2
Position1
  sta WSYNC
  lda #%10010000                ; [0] + 2
  sta HMP0                      ; [2] + 3
  lda #%10000000                ; [5] + 2
  sta HMP1                      ; [7] + 3
  SLEEP 19                      ; [10] + 19
  sta RESP0                     ; [29] + 3 = 32
  nop                           ; [32] + 2
  sta RESP1                     ; [34] + 3 = 37
  rts
Position2
  sta WSYNC
  SLEEP 29                      ; [0] + 29
  sta RESP0                     ; [29] + 3 = 32
  nop                           ; [32] + 2
  sta RESP1                     ; [34] + 3 = 37
  lda #%10010000                ; [37] + 2
  sta HMP0                      ; [39] + 3
  lda #%10000000                ; [42] + 2
  sta HMP1                      ; [44] + 3 
  SLEEP 24                      ; [47] + 21
  sta HMOVE                     ; [71] + 3
  rts
EndPosition

  if (>Kernel2B != >EndPosition)
    echo "WARNING: Kernel2B Crosses Page Boundary!"
  endif

  ALIGN 256

  ; Copy Text Into Buffer
TextCopy
  lda CYCLE
  lsr
  bcs TextCopy1
  jmp TextCopy2
TextCopy1
  ldx TEXT+23         ; [0] + 3
  ldy TEXT+22         ; [3] + 3
  lda L2CHARS+3,Y     ; [6] + 4
  ora R2CHARS+3,X     ; [10] + 4
  sta BUFF1+41        ; [14] + 3
  lda L2CHARS+2,Y     ; [17] + 4
  ora R2CHARS+2,X     ; [21] + 4
  sta BUFF1+40        ; [25] + 3
  lda L2CHARS+1,Y     ; [28] + 4
  ora R2CHARS+1,X     ; [32] + 4
  sta BUFF1+39        ; [36] + 3
  lda L2CHARS+0,Y     ; [39] + 4
  ora R2CHARS+0,X     ; [43] + 4
  sta BUFF1+38        ; [47] + 3 = 50
  ldx TEXT+21
  ldy TEXT+20
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+37
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+36
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+35
  ldx TEXT+19
  ldy TEXT+18
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+34
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+33
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+32
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+31
  ldx TEXT+17
  ldy TEXT+16
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+30
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+29
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+28
  ldx TEXT+15
  ldy TEXT+14
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+27
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+26
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+25
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+24
  ldx TEXT+13
  ldy TEXT+12
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+23
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+22
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+21
  ldx TEXT+11
  ldy TEXT+10
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+20
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+19
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+18
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+17
  ldx TEXT+9
  ldy TEXT+8
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+16
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+15
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+14
  ldx TEXT+7
  ldy TEXT+6
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+13
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+12
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+11
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+10
  ldx TEXT+5
  ldy TEXT+4
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+9
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+8
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+7
  ldx TEXT+3
  ldy TEXT+2
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+6
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+5
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+4
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+3
  ldx TEXT+1
  ldy TEXT+0
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+2
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+1
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+0
  rts
EndTextCopy1

TextCopy2
  ldx TEXT+23       ; [0] + 3
  ldy TEXT+22       ; [3] + 3
  lda L1CHARS+3,Y   ; [6] + 4
  ora R1CHARS+3,X   ; [10] + 4
  sta BUFF1+41      ; [14] + 3
  lda L1CHARS+2,Y   ; [17] + 4
  ora R1CHARS+2,X   ; [21] + 4
  sta BUFF1+40      ; [25] + 3
  lda L1CHARS+1,Y   ; [28] + 4
  ora R1CHARS+1,X   ; [32] + 4
  sta BUFF1+39      ; [36] + 3 = 39
  ldx TEXT+21
  ldy TEXT+20
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+38
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+37
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+36
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+35
  ldx TEXT+19
  ldy TEXT+18
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+34
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+33
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+32
  ldx TEXT+17
  ldy TEXT+16
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+31
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+30
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+29
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+28
  ldx TEXT+15
  ldy TEXT+14
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+27
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+26
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+25
  ldx TEXT+13
  ldy TEXT+12
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+24
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+23
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+22
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+21
  ldx TEXT+11
  ldy TEXT+10
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+20
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+19
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+18
  ldx TEXT+9
  ldy TEXT+8
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+17
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+16
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+15
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+14
  ldx TEXT+7
  ldy TEXT+6
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+13
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+12
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+11
  ldx TEXT+5
  ldy TEXT+4
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+10
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+9
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+8
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+7
  ldx TEXT+3
  ldy TEXT+2
  lda L1CHARS+3,Y
  ora R1CHARS+3,X
  sta BUFF1+6
  lda L1CHARS+2,Y
  ora R1CHARS+2,X
  sta BUFF1+5
  lda L1CHARS+1,Y
  ora R1CHARS+1,X
  sta BUFF1+4
  ldx TEXT+1
  ldy TEXT+0
  lda L2CHARS+3,Y
  ora R2CHARS+3,X
  sta BUFF1+3
  lda L2CHARS+2,Y
  ora R2CHARS+2,X
  sta BUFF1+2 
  lda L2CHARS+1,Y
  ora R2CHARS+1,X
  sta BUFF1+1
  lda L2CHARS+0,Y
  ora R2CHARS+0,X
  sta BUFF1+0
  rts
EndTextCopy2
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Text Kernel Subroutines"
LoadText
  bpl	LoadTextRAM
  and #%01111111
LoadTextROM
  tay
  lda ROM_Messages+23,Y
  sta TEXT+23
  lda ROM_Messages+22,Y
  sta TEXT+22
  lda ROM_Messages+21,Y
  sta TEXT+21
  lda ROM_Messages+20,Y
  sta TEXT+20
  lda ROM_Messages+19,Y
  sta TEXT+19
  lda ROM_Messages+18,Y
  sta TEXT+18
  lda ROM_Messages+17,Y
  sta TEXT+17
  lda ROM_Messages+16,Y
  sta TEXT+16
  lda ROM_Messages+15,Y
  sta TEXT+15
  lda ROM_Messages+14,Y
  sta TEXT+14
  lda ROM_Messages+13,Y
  sta TEXT+13
  lda ROM_Messages+12,Y
  sta TEXT+12
  lda ROM_Messages+11,Y
  sta TEXT+11
  lda ROM_Messages+10,Y
  sta TEXT+10
  lda ROM_Messages+9,Y
  sta TEXT+9
  lda ROM_Messages+8,Y
  sta TEXT+8
  lda ROM_Messages+7,Y
  sta TEXT+7
  lda ROM_Messages+6,Y
  sta TEXT+6
  lda ROM_Messages+5,Y
  sta TEXT+5
  lda ROM_Messages+4,Y
  sta TEXT+4
  lda ROM_Messages+3,Y
  sta TEXT+3
  lda ROM_Messages+2,Y
  sta TEXT+2
  lda ROM_Messages+1,Y
  sta TEXT+1
  lda ROM_Messages+0,Y
  sta TEXT+0
  rts

LoadTextRAM
  tay
  lda RAM_Messages+23,Y
  sta TEXT+23
  lda RAM_Messages+22,Y
  sta TEXT+22
  lda RAM_Messages+21,Y
  sta TEXT+21
  lda RAM_Messages+20,Y
  sta TEXT+20
  lda RAM_Messages+19,Y
  sta TEXT+19
  lda RAM_Messages+18,Y
  sta TEXT+18
  lda RAM_Messages+17,Y
  sta TEXT+17
  lda RAM_Messages+16,Y
  sta TEXT+16
  lda RAM_Messages+15,Y
  sta TEXT+15
  lda RAM_Messages+14,Y
  sta TEXT+14
  lda RAM_Messages+13,Y
  sta TEXT+13
  lda RAM_Messages+12,Y
  sta TEXT+12
  lda RAM_Messages+11,Y
  sta TEXT+11
  lda RAM_Messages+10,Y
  sta TEXT+10
  lda RAM_Messages+9,Y
  sta TEXT+9
  lda RAM_Messages+8,Y
  sta TEXT+8
  lda RAM_Messages+7,Y
  sta TEXT+7
  lda RAM_Messages+6,Y
  sta TEXT+6
  lda RAM_Messages+5,Y
  sta TEXT+5
  lda RAM_Messages+4,Y
  sta TEXT+4
  lda RAM_Messages+3,Y
  sta TEXT+3
  lda RAM_Messages+2,Y
  sta TEXT+2
  lda RAM_Messages+1,Y
  sta TEXT+1
  lda RAM_Messages+0,Y
  sta TEXT+0
  rts
end
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Endscreen Text"

   ;batariBasic entry point to asm code
_bB_Endscreen_entry_bank4


   asm
  ; Load Score + Bonus to first SC-RAM line 
  lda #_1
  sta w000
  lda #_0
  sta w001


  ldx #5
  jsr _Copy_Score_To_SC_RAM

  ; Set 3 sprite copies
  lda #%00000110
  sta NUSIZ0
  sta NUSIZ1

  ; Delay P0 & P1
  lda #%00000001
  sta VDELP0
  sta VDELP1
  
  ; Set P0/P1 Colours
  lda #_0E
  sta COLUP0
  sta COLUP1

  ; Reflect PF
  lda #1
  sta CTRLPF
  
  ; Set Background _96
  lda #_00
  sta COLUPF
  lda #$F0
  sta PF0
  lda #$FF
  sta PF1
  sta PF2

MainEndscreenLoop
  ; Do Vertical Sync (VSync Routine by Manuel Polik)
  lda #2
  sta WSYNC
  sta VSYNC
  sta WSYNC
  sta WSYNC
  lsr
  sta WSYNC
  sta VSYNC

  ; Set Vertical Blank Timer 
  ldy #43
  sty TIM64T
  
  ; Update Game Cycle
  dec CYCLE

  ; Clear Sprites
  lda #0
  sta GRP0
  sta GRP1
  sta GRP0
  sta GRP1
  
  ; Set Pointer for First Message
  jsr LoadTextRAM

  ; Set Loop Iterations
  lda #9
  sta LOOP
  
  ; Set Sprite Positions and Preload First Text Line
  jsr TextPosition
  jsr TextCopy

  ; Wait for Vertical Blank End
WaitVblank2
  lda INTIM
  bne WaitVblank2
  sta WSYNC
  sta VBLANK
  sta WSYNC

  ; Display First Line
  jsr TextKernel

EndscreenTextLoop
  
  ; Clear Sprite Data
  lda #0
  sta GRP1
  sta GRP0
  sta GRP1
  
  ; Set Next Message Pointer
  ldx LOOP
  lda FontColorsEndscreen,X
  sta COLUP0
  sta COLUP1
  lda OffsetEndscreen,X
  jsr LoadTextROM
  
  ; Copy and Display Message
  jsr TextCopy
  jsr TextKernel
  
  ; Decrement Loop
  dec LOOP
  bpl EndscreenTextLoop
EndEndscreenKernel


  ; Start Vertical Blank
  lda #2
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta VBLANK
  
  ; Set Timer for Overscan
  ldy #35
  sty TIM64T
end

   if joy0right then goto restart_bB bank8

   asm
  ; Finish Overscan
WaitOverscanEndscreenEnd
  lda INTIM
  bne WaitOverscanEndscreenEnd
  
  ; Loop To Beginning
  jmp MainEndscreenLoop

;#endregion

_Copy_Score_To_SC_RAM
  ldy #3
  clc
copy_score_to_text_loop
  lda score-1,y
  and #%00001111
  adc #54
  rol
  rol
  sta w002,X
  dex
  lda score-1,y
  and #%11110000
  lsr
  lsr
  adc #216
  sta w002,x
  dex
  dey
  bne copy_score_to_text_loop


  lda #__
  ldx #16
clear_zp_ram_loop_bonus
  sta w008-1,x
  DEX
  bne clear_zp_ram_loop_bonus
  rts


  ; Include Font Data
  INCLUDE "font.h"
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Game Over Text Screen"

   ;batariBasic entry point to asm code
_bB_Game_Over_entry_bank4


   asm
  ; Load Score to first SC-RAM line 
  lda #__
  sta w000
  sta w001

  ldx #5
  jsr _Copy_Score_To_SC_RAM

  ; Set 3 sprite copies
  lda #%00000110
  sta NUSIZ0
  sta NUSIZ1

  ; Delay P0 & P1
  lda #%00000001
  sta VDELP0
  sta VDELP1
  
  ; Set P0/P1 Colours
  lda #_0E
  sta COLUP0
  sta COLUP1

  ; Reflect PF
  lda #1
  sta CTRLPF
  
  ; Set Background _96
  lda #_96
  sta COLUBK
  lda #_00
  sta COLUPF
  sta PF1
  sta PF2
  lda #$30
  sta PF0

MainGameOverLoop
  ; Do Vertical Sync (VSync Routine by Manuel Polik)
  lda #2
  sta WSYNC
  sta VSYNC
  sta WSYNC
  sta WSYNC
  lsr
  sta WSYNC
  sta VSYNC

  ; Set Vertical Blank Timer 
  ldy #43
  sty TIM64T
  
  ; Update Game Cycle
  dec CYCLE

  ; Clear Sprites
  lda #0
  sta GRP0
  sta GRP1
  sta GRP0
  sta GRP1
  ; Set Pointer for First Message
  jsr LoadTextRAM

  ; Set Loop Iterations
  lda #9
  sta LOOP
  
  ; Set Sprite Positions and Preload First Text Line
  jsr TextPosition
  jsr TextCopy

  ; Wait for Vertical Blank End
WaitVblank3
  lda INTIM
  bne WaitVblank3
  sta WSYNC
  sta VBLANK
  sta WSYNC

  ; Display First Line
  jsr TextKernel

GameOverTextLoop
  
  ; Clear Sprite Data
  lda #0
  sta GRP1
  sta GRP0
  sta GRP1
  
  ; Set Next Message Pointer
  ldx LOOP
  lda FontColorsGameOver,X
  sta COLUP0
  sta COLUP1
  lda OffsetGameOver,X
  jsr LoadTextROM
  
  ; Copy and Display Message
  jsr TextCopy
  jsr TextKernel
  
  ; Decrement Loop
  dec LOOP
  bpl GameOverTextLoop
EndGameOverKernel


  ; Start Vertical Blank
  lda #2
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta WSYNC
  sta VBLANK
  
  ; Set Timer for Overscan
  ldy #35
  sty TIM64T
end

   goto _play_game_over_music bank6
_return_from_game_over_music

   asm
  ; Finish Overscan
WaitOverscanGameOverEnd
  lda INTIM
  bne WaitOverscanGameOverEnd
  
  ; Loop To Beginning
  jmp MainGameOverLoop

;#endregion




end

;#endregion

   bank 5
   bank 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 6 Music and Sound effects"

_game_over_music_check_and_return
   if _Ch0_Sound <> _Sfx_Game_Over_Bass then AUDV1 = 0
_game_over_music_return
   goto _return_from_game_over_music bank4

   asm
_Sfx_to_SD_Addr_Lo
   DC.B <_SD_Enemy_Destroyed_1 ; _Sfx_Enemy_Down_1
   DC.B <_SD_Shoot             ; _Sfx_Player_Shot
   DC.B <_SD_Large_Enemy_Hit   ; _Sfx_Enemy_Hit
   DC.B <_SD_Enemy_Destroyed_0 ; _Sfx_Enemy_Down
   DC.B <_SD_Power_Up          ; _Sfx_Power_Up
   DC.B <_SD_Bonus_Life        ; _Sfx_Bonus_Life
   DC.B <_SD_Looping_0         ; _Sfx_Looping
   DC.B <_SD_Looping_1         ; _Sfx_Looping_1
   DC.B <_SD_Death             ; _Sfx_Player_Explosion
   DC.B <_SD_Respawn_Bass      ; _Sfx_Respawn_Bass
   DC.B <_SD_Takeoff           ; _Sfx_Takeoff
   DC.B <_SD_Landing           ; _Sfx_Landing
   DC.B <_SD_Game_Over_Bass    ; _Sfx_Game_Over_Bass
_Sfx_to_SD_Addr_Hi
   DC.B >_SD_Enemy_Destroyed_1
   DC.B >_SD_Shoot
   DC.B >_SD_Large_Enemy_Hit
   DC.B >_SD_Enemy_Destroyed_0
   DC.B >_SD_Power_Up
   DC.B >_SD_Bonus_Life
   DC.B >_SD_Looping_0
   DC.B >_SD_Looping_1
   DC.B >_SD_Death
   DC.B >_SD_Respawn_Bass
   DC.B >_SD_Takeoff
   DC.B >_SD_Landing
   DC.B >_SD_Game_Over_Bass

_Sfx_to_Next_Sfx
   DC.B _Sfx_Mute              ; _Sfx_Enemy_Down_1
   DC.B _Sfx_Mute              ; _Sfx_Player_Shot
   DC.B _Sfx_Mute              ; _Sfx_Enemy_Hit
   DC.B _Sfx_Enemy_Down_1      ; _Sfx_Enemy_Down
   DC.B _Sfx_Mute              ; _Sfx_Power_Up
   DC.B _Sfx_Mute              ; _Sfx_Bonus_Life
   DC.B _Sfx_Looping_1         ; _Sfx_Looping
   DC.B _Sfx_Mute              ; _Sfx_Looping_1
   DC.B _Sfx_Mute              ; _Sfx_Player_Explosion
   DC.B _Sfx_Mute              ; _Sfx_Respawn_Bass
   DC.B _Sfx_Mute              ; _Sfx_Takeoff
   DC.B _Sfx_Mute              ; _Sfx_Landing
   DC.B _Sfx_Mute              ; _Sfx_Game_Over_Bass

_end_sfx
   sta AUDV0 ; silence channel 0
end
   goto __Skip_Ch_0

_play_game_over_music
   ; check joystick here to free up space in bank 4
   if joy0right then goto restart_bB bank8

   if _Ch0_Sound <> _Sfx_Game_Over_Bass then goto _game_over_music_return

_Play_In_Game_Music

   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   asm
   ldx _Ch0_Sound
   stx temp1
   beq __Skip_Ch_0_asm ; assume _Sfx_Mute == 0

   dec _Ch0_Duration
   bne __Skip_Ch_0_asm ; branch if current note is not over

   ldy _Ch0_Counter

_load_sd_addr
   lda _Sfx_to_SD_Addr_Lo-1,X ; -1: 0 (mute) bypasses this code
   sta temp2
   lda _Sfx_to_SD_Addr_Hi-1,X
   sta temp3

   lda (temp2),Y
   sta temp4
   cmp #255
   bne __Ch0_Not_End
   lda _Sfx_to_Next_Sfx-1,X
   sta _Ch0_Sound
   beq _end_sfx
   tax
   ldy #0
   jmp _load_sd_addr ; start follow-up sfx
end

   goto __Skip_Ch_0

   asm
__Ch0_Not_End
   iny
   sta AUDV0
   lda (temp2),Y
   sta AUDC0
   iny
   lda (temp2),Y
   sta AUDF0
   iny
   lda (temp2),Y
   sta _Ch0_Duration
   iny
   sty _Ch0_Counter

__Skip_Ch_0_asm
end


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
   ;  Skips all music in landing-takeoff sequence
   ;  Skips background music (but not respawn melody) if left difficulty switch
   ;  is set to A.
   ;
   if _Bit3_mute_bg_music{3} then goto __Mute_Ch_1
   if !switchleftb && _Ch0_Sound <> _Sfx_Respawn_Bass && _Ch0_Sound <> _Sfx_Game_Over_Bass then goto __Mute_Ch_1

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

   if temp1 = _Sfx_Game_Over_Bass then goto _game_over_music_check_and_return

   drawscreen
   goto main bank1

__Mute_Ch_1
  AUDV1 = 0 : goto __Skip_Ch_1

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
   4,3,14,36
   3,3,13,44
   2,3,13,52
   1,3,13,60
   1,6,12,2
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
   ;  Sound data for shot hitting but not destroying larger enemy.
   ;

   data _SD_Large_Enemy_Hit
   3,1,1,1
   1,1,1,3
   255
end

   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shot hitting enemy.
   ;  Split into two segments, first (explosion) loud and medium-priority,
   ;  second (falling) quiet and low-priority
   ;

   data _SD_Enemy_Destroyed_0
   4,8,2,1
   2,8,2,1
   8,2,3,1
   2,2,3,1
   8,2,3,1
   2,2,3,1
   8,2,3,1
   255
end

   data _SD_Enemy_Destroyed_1
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


  data _SD_Power_Up
  $6,$4,$1D, 2
  $6,$4,$1A, 2
  $6,$4,$18, 2
  $6,$4,$13, 2
  $6,$4,$0E, 2
  $6,$4,$1D, 2
  $6,$4,$1A, 2
  $6,$4,$18, 2
  $6,$4,$13, 2
  $6,$4,$0E, 2
  $FF ; end
end


  data _SD_Bonus_Life
  $6,$C,$0E, 5
  $0,$0,$00, 5
  $6,$C,$13, 5
  $6,$C,$0E, 5
  $6,$C,$0B, 8
  $FF ; end
end


  ; looping: 10 frames forward-horizontal, 10 frames vertical, 32 frames inverted (hit max volume for distortion 3 and pitch $19 for distortion 4 at start of inversion), 30 frames vertical and forward
  ; alternate between 3:0C and C:1x
  ; split into 2 tables: bBasic data tables must be <=256 bytes
  data _SD_Looping_0
  $1,$3,$0C, 1, $C,$C,$17, 1
  $3,$3,$0C, 1, $C,$C,$17, 1
  $5,$3,$0C, 1, $C,$C,$17, 1
  $7,$3,$0C, 1, $C,$C,$17, 1
  $9,$3,$0C, 1, $C,$C,$17, 1
  $A,$3,$0C, 1, $C,$C,$17, 1
  $B,$3,$0C, 1, $C,$C,$18, 1
  $C,$3,$0C, 1, $C,$C,$18, 1
  $D,$3,$0C, 1, $C,$C,$18, 1
  $E,$3,$0C, 1, $C,$C,$18, 1
  $FF
end

  data _SD_Looping_1
  $F,$3,$0C, 1, $B,$C,$19, 1
  $F,$3,$0C, 1, $B,$C,$19, 1
  $F,$3,$0C, 1, $A,$C,$19, 1
  $F,$3,$0C, 1, $A,$C,$19, 1
  $F,$3,$0C, 1, $9,$C,$1A, 1
  $F,$3,$0C, 1, $9,$C,$1A, 1
  $F,$3,$0C, 1, $8,$C,$1A, 1
  $F,$3,$0C, 1, $8,$C,$1A, 1
  $E,$3,$0C, 1, $8,$C,$1B, 1
  $E,$3,$0C, 1, $8,$C,$1B, 1
  $E,$3,$0C, 1, $7,$C,$1B, 1
  $E,$3,$0C, 1, $7,$C,$1B, 1
  $E,$3,$0C, 1, $7,$C,$1C, 1
  $D,$3,$0C, 1, $7,$C,$1C, 1
  $D,$3,$0C, 1, $7,$C,$1C, 1
  $D,$3,$0C, 1, $7,$C,$1C, 1
  $C,$3,$0C, 1, $7,$C,$1D, 1
  $C,$3,$0C, 1, $7,$C,$1D, 1
  $B,$3,$0C, 1, $7,$C,$1D, 1
  $B,$3,$0C, 1, $7,$C,$1D, 1
  $A,$3,$0C, 1, $7,$C,$1E, 1
  $A,$3,$0C, 1, $7,$C,$1E, 1
  $9,$3,$0C, 1, $7,$C,$1E, 1
  $8,$3,$0C, 1, $7,$C,$1E, 1
  $7,$3,$0C, 1, $7,$C,$1F, 1
  $6,$3,$0C, 1, $7,$C,$1F, 1
  $5,$3,$0C, 1, $7,$C,$1F, 1
  $4,$3,$0C, 1, $7,$C,$1F, 1
  $3,$3,$0C, 1, $7,$C,$1F, 1
  $2,$3,$0C, 1, $7,$C,$1F, 1
  $1,$3,$0C, 1, $7,$C,$1F, 1
  $FF
end


  data _SD_Respawn_Bass
  $6,$C,$18, 4
  $3,$C,$18,16
  $6,$C,$1A, 4
  $3,$C,$1A,16
  $6,$C,$1B, 4
  $3,$C,$1B,16
  $6,$C,$1D, 4
  $3,$C,$1D,16
  $6,$C,$1F, 4
  $3,$C,$1F,16
  $6,$C,$1A, 4
  $3,$C,$1A,16
  $6,$C,$18, 4
  $3,$C,$18,16
  $6,$C,$15, 4
  $3,$C,$15,16
  $6,$C,$0F, 4
  $3,$C,$0F,16
  $6,$C,$11, 4
  $3,$C,$11,16
  $6,$C,$12, 4
  $3,$C,$12,16
  $6,$C,$15, 4
  $3,$C,$15,16
  $6,$C,$1B, 4
  $3,$C,$1B,16
  $6,$C,$15, 4
  $3,$C,$15,16
  $6,$C,$0F, 4
  $3,$C,$0F,16
  $6,$C,$0D, 4
  $3,$C,$0D,16
  $FF ; end
end

  data _SD_Game_Over_Bass
  $8,$6,$0B, 4
  $4,$6,$0B,44
  $8,$6,$07, 4
  $4,$6,$07,44

  $8,$6,$0B, 4
  $4,$6,$0B,44
  $8,$6,$07, 4
  $4,$6,$07,44

  $8,$6,$0B, 4
  $4,$6,$0B,20
  $8,$6,$0B, 4
  $4,$6,$0B,20
  $8,$6,$0A, 4
  $4,$6,$0A,20
  $8,$6,$09, 4
  $4,$6,$09,20

  $8,$6,$09, 4
  $3,$6,$09, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$09, 4
  $3,$6,$09, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$09, 4
  $3,$6,$09, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$09, 4
  $3,$6,$09, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4
  $8,$6,$0E, 4
  $3,$6,$0E, 4

  $8,$6,$09, 4
  $4,$6,$09,92
  $FF
end

__Respawn_Music_Setup
  sdata _SD_Respawn_Music01 = e
  $C,$4,$18, 2
  $9,$4,$18, 4
  $5,$4,$18, 6
  $3,$4,$18, 8
  $1,$4,$18,10
  $0,$0,$00,20
  $C,$4,$18, 2
  $9,$4,$18, 4
  $5,$4,$18, 4
  $C,$4,$18, 2
  $9,$4,$18, 4
  $5,$4,$18, 4
  $C,$4,$18, 2
  $9,$4,$18, 4
  $5,$4,$18, 4

  $C,$4,$17, 2
  $9,$4,$17, 3
  $5,$4,$17, 4
  $3,$4,$17, 5
  $1,$4,$17, 8
  $0,$0,$00, 8
  $C,$4,$18, 2
  $9,$4,$18, 3
  $5,$4,$18, 4
  $3,$4,$18, 5
  $1,$4,$18, 8
  $0,$0,$00,28

  $C,$4,$13, 2
  $9,$4,$13, 3
  $5,$4,$13, 4
  $3,$4,$13, 5
  $1,$4,$13, 8
  $0,$0,$00, 8
  $C,$4,$14, 2
  $9,$4,$14, 3
  $5,$4,$14, 4
  $3,$4,$14, 5
  $1,$4,$14, 8
  $0,$0,$00, 8
  $9,$4,$10, 2
  $6,$4,$10, 3
  $3,$4,$10, 4
  $2,$4,$10, 5
  $1,$4,$10, 6

  $C,$4,$0D, 2
  $9,$4,$0D, 3
  $6,$4,$0D, 4
  $3,$4,$0D,71

  255
end
   rem handle bass line as sfx for simplicity
   _Ch0_Duration = 1 : _Ch0_Counter = 0 : _Ch0_Sound = _Sfx_Respawn_Bass
   _Ch1_Duration = 1
   goto _Play_In_Game_Music

__Game_Over_Music_Setup_01

  sdata _SD_Game_Over_Music01 = e
  $C,$C,$0C, 2
  $6,$C,$0C, 4
  $2,$C,$0C,12
  $C,$C,$0C, 2
  $6,$C,$0C, 4
  $C,$4,$1E, 2
  $6,$4,$1E, 4
  $2,$4,$1E, 8
  $1,$4,$1E,22
  $8,$C,$0A, 2
  $2,$C,$0A,10
  $8,$C,$0B, 2
  $2,$C,$0B,10
  $5,$1,$04, 2
  $1,$1,$04,10

  $C,$C,$0C, 2
  $6,$C,$0C, 4
  $2,$C,$0C,12
  $C,$C,$0C, 2
  $6,$C,$0C, 4
  $C,$4,$1E, 2
  $6,$4,$1E, 4
  $2,$4,$1E, 8
  $1,$4,$1E,22
  $8,$C,$0A, 2
  $2,$C,$0A,10
  $8,$C,$0B, 2
  $2,$C,$0B,10
  $5,$1,$04, 2
  $1,$1,$04,10

  $0,$0,$00, 8
  $8,$4,$1E, 2
  $2,$4,$1E, 6
  $8,$4,$1E, 2
  $2,$4,$1E, 6
  $0,$0,$00, 8
  $8,$4,$1C, 2
  $2,$4,$1C, 6
  $8,$4,$1C, 2
  $2,$4,$1C, 6
  $0,$0,$00, 8
  $8,$4,$18, 2
  $2,$4,$18, 6
  $8,$4,$18, 2
  $2,$4,$18, 6
  $0,$0,$00, 8
  $8,$4,$16, 2
  $2,$4,$16, 6
  $8,$4,$16, 2
  $2,$4,$16, 6

  $8,$4,$18, 2
  $4,$4,$18, 4
  $2,$4,$18, 8
  $1,$4,$18,82

  $8,$4,$19, 2
  $4,$4,$19, 4
  $2,$4,$19, 8
  $1,$4,$19,82
  255
end
   rem handle bass line as sfx for simplicity
   _Ch0_Duration = 1 : _Ch0_Counter = 0 : _Ch0_Sound = _Sfx_Game_Over_Bass
   _Ch1_Duration = 1
   goto _bB_Game_Over_entry_bank4 bank4

__BG_Music_Setup_01

  sdata _SD_Music01 = e
  6,3,0,4,  0,0,0,16
  6,3,0,4,  0,0,0,16
  6,3,0,4,  0,0,0,6,  6,3,0,4,  0,0,0,16
                      5,3,0,4,  0,0,0,6
  6,3,0,4,  0,0,0,6,  5,3,0,4,  0,0,0,6
  6,3,0,4,  0,0,0,6,  5,3,0,4,  0,0,0,6
  6,3,0,4,  0,0,0,36

  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,26
                      4,8,4,2,  0,0,0,8
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  5,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5 ; 1 frame slow
  5,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5 ; 1 frame slow
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5 ; 1 frame slow
  5,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5,  4,8,4,2,  0,0,0,5 ; 1 frame slow
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,6,  4,8,4,2,  0,0,0,8
  5,8,4,2,  0,0,0,8,  6,3, 0,4, 0,0,0,6
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  4,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,8
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3,  4,8,4,2,  0,0,0,3
  5,8,4,2,  0,0,0,8,  5,8,4,2,  0,0,0,8
  6,3,0,4,  0,0,0,16
  5,8,4,2,  0,0,0,18
  5,8,4,2,  0,0,0,18
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,18
                      4,8,4,2,  0,0,0,8
  5,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,8
  4,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,8
  5,8,4,2,  0,0,0,18
  4,8,4,2,  0,0,0,8,  4,8,4,2,  0,0,0,8
  255
end
   _Ch1_Duration = 1

   goto __Skip_Ch_1

;#endregion

   bank 7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 7 Titlescreen"
   inline song.h
   inline songplay.h

titlescreen_start
   COLUBK = _00
   beat = 0 : tempoCount = 0 : measure = 0 : _Bit1_reset_restrainer{1} = 1

titlescreen            

   framecounter = framecounter + 1
   if framecounter{0} then bmp_96x2_2_index = 25 else  bmp_96x2_2_index = 0

   gosub songPlayer

   gosub titledrawscreen

   if joy0left && _Bit5_PlusROM{5} then AUDV0 = 0 : AUDV1 = 0 : goto _bB_HSC_entry_bank4 bank4

   if !joy0fire then _Bit1_reset_restrainer{1} = 0
   if joy0fire && !_Bit1_reset_restrainer{1} then AUDV0 = 0 : AUDV1 = 0 : goto start bank1
   asm
   lda SWCHA
   lda SWCHB
end
   goto titlescreen

   asm
   include "titlescreen/asm/titlescreen.asm"
end
;#endregion

   bank 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 8 bB drawscreen and sprites"

   inline 6lives.asm

restart_bB
   asm
   jmp start
end

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
   PAD_BB_SPRITE_DATA 8
end
  data _Power_Up
   0
   %11010100
   %10111110
   %01101010
   %11000000
   %11110000
   %11011000
   %11111000
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
end

;#endregion
