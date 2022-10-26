; Original code by AtariAge user homerhomer (https://atariage.com/forums/profile/28656-homerhomer/)
; Additional code by AtariAge user Al_Nafuur (https://atariage.com/forums/profile/41465-al_nafuur/)
; Music and SFX contributed by AtariAge user Pat Brady (https://atariage.com/forums/profile/24906-pat-brady/) 
; AtariAge topic: https://atariage.com/forums/topic/176639-1942-wip/
 
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

   ; TV mode. IS_NTSC = 0 for PAL colors
   const IS_NTSC = 1

   ; Color constants are defined in external ASM file
   inline NTSC_PAL_colors.asm

   ; To use the ASM defined colors in bB assignments they have to be redefined,
   ; otherwise bB is using the ZP memory instead!
   const _Color_Ocean               = _96
   const _Color_Carrier             = _04
   const _Color_Gras_Island         = _C8
   const _Color_Sand_Island         = _EE
   const _Color_Jungle_Island       = _C6
   const _Color_Titlescreen_BG      = _00
   const _Color_Player_Plane_Base   = _2A
   const _Color_Player_Plane_Bottom = _26
   const _Color_Score               = _0E
   const _Color_Player_Bullet       = _40

   ; Kernel and Minikernel constants
   const lives_compact  = 1
   const pfscore = 2
   const switch_player_0_color = 1

   ; Game constants
   const _Plane_Y_Speed  = 1
   const _Plane_X1_Speed = 1
   const _Plane_X2_Speed = 2
   const _Plane_Y_Turnpoint   = 40
   const _Plane_Y_Shootpoint  = _Plane_Y_Turnpoint - 7
   const _Plane_Y_Targetpoint = _Plane_Y_Turnpoint - 2

   const _Player0_X_Start     =  76
   const _Player0_X_Start_WSF =  60
   const _Player0_Y_Start     =  25
   const _Player0_X_Max       = 152
   const _Player0_X_Max_1SF   = 136
   const _Player0_X_Max_2SF   = 120
   const _Player0_Y_Max       =  55
   const _Player0_X_Min       =   0
   const _Player0_Y_Min       =  10

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
   const _Sfx_Victory_Bass      = 14
   const _Sfx_Victory_Bass_1    = 15
   const _Sfx_Boss_Entry_Bass   = 16
   const _Sfx_Boss_Entry_Bass_1 = 17
   const _Sfx_Boss_Entry_Bass_2 = 18
   const _Sfx_Boss_Entry_Bass_3 = 19

   const _Screen_Vertical_Resolution = 42
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

   const _Player1_Parking_Point = 200
   const _Player2_Parking_Point = 200
   const _Player3_Parking_Point = 200
   const _Player4_Parking_Point = 200
   const _Player5_Parking_Point = 150

   const _Map_Landing_w  = %00101100
   const _Map_Landing    = %00101110
   const _Map_Takeoff    = %00001110
   const _Map_Pacific    = %10111010
   const _Map_Boss_up    = %11110001
   const _Map_Boss_down  = %11111001
   const _Map_Boss_expl  = %11111000

   const movesLeft     = %000
   const movesRight    = %001
   const movesDown     = %010
   const movesUp       = %011
   const movesToPlayer = %100
   const followsPlayer = %101
   const noMove        = %110

   const planeSmallD   = %000000
   const planeSmallU   = %001000
   const planeSmallLR  = %010000
   const planeMiddleD  = %011000
   const planeMiddleU  = %100000
   const planeMiddleLR = %101000
   const planeBigD     = %110000
   const planeBigU     = %111000
   const typePowerUp   = %01000000 + noMove
   const typeMissile   = %10000000 + movesToPlayer
   const typeAyMissile = %10000000 + followsPlayer
   const typeMspExpl   = %11000000 + noMove

   const OnePlane          = 0
   const TwoPlanesClose    = 1
   const TwoPlanesMedium   = 2
   const ThreePlanesClose  = 3
   const TwoPlanesWide     = 4
   const WidthPlane        = 5
   const ThreePlanesMedium = 6
   const QuadPlane         = 7

   const mirroredR         = 8

   rem Playfield pointers
   const _PF1_Carrier_Boss_high    = >PF1_data0
   const _PF2_Carrier_Boss_high    = >PF2_data0

   const _PF1_Pacific_a_high       = _PF1_Carrier_Boss_high + 1
   const _PF2_Pacific_a_high       = _PF2_Carrier_Boss_high + 1

   const _PF1_Pacific_b_high       = _PF1_Carrier_Boss_high + 2
   const _PF2_Pacific_b_high       = _PF2_Carrier_Boss_high + 2

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

   const _Player5_Sfighter_up_low  = _Player0_Plane_up_low + _Player0_Plane_up_length
   const _Player5_Sfighter_height  = _Player0_Plane_up_length + 1

   const _Player0_Plane_down_high   = >_Player0_Plane_down
   const _Player0_Plane_down_low    = <_Player0_Plane_down
   const _Player0_Plane_down_height = _Player0_Plane_down_length

   const _Player0_Looping_1_high    = >_Player0_Looping_1
   const _Player0_Looping_1_low     = <_Player0_Looping_1
   const _Player0_Looping_1_height  = _Player0_Looping_1_length

   const _Player0_Looping_2_high    = >_Player0_Looping_2
   const _Player0_Looping_2_low     = <_Player0_Looping_2
   const _Player0_Looping_2_height  = _Player0_Looping_2_length

   const _Player0_Explosion_0_high   = >_Player0_Explosion_0
   const _Player0_Explosion_0_low    = <_Player0_Explosion_0

   const _SD_Respawn_Music01_begin_high = >_SD_Respawn_Music01_begin
   const _SD_Respawn_Music01_begin_low  = <_SD_Respawn_Music01_begin

   ;-----------------------------------------------------------------------------
   ;-- color table indexes into the color table stored in the kernel code area

   const _Power_Up_Dark_Gray_Quad_Gun       = <ct_dkGrey       - <colorTables ; $08 ;orig color = _06
   const _Power_Up_White_Enemy_Crash        = <ct_white        - <colorTables ; $18 ;orig color = _0E
   const _Power_Up_Light_Gray_Side_Fighters = <ct_lgGrey       - <colorTables ; $10 ;orig color = _0A
   const _Power_Up_Black_Extra_Life         = <ct_black        - <colorTables ; $00 ;orig color = _00
   const _Power_Up_Orange_No_Enemy_Bullets  = <ct_bonus_orange - <colorTables ; $68 ;orig color = _FA
   const _Power_Up_Yellow_Extra_Loop        = <ct_bonus_yellow - <colorTables ; $60 ;orig color = _1E
   const _Power_Up_Red_1000_Points          = <ct_bonus_red    - <colorTables ; $70 ;orig color = _42

   const _Carrier_Tower_ColorIdx = <ct_shipCarrierTower - <colorTables ; $00 ;orig color = _02
   const _Carrier_88_ColorIdx    = <ct_white            - <colorTables ; $10 ;orig color = _0A

   const _CI_Black               = <ct_black            - <colorTables ; $00
   const _CI_DkGrey              = <ct_dkGrey           - <colorTables ; $08
   const _CI_LtGrey              = <ct_lgGrey           - <colorTables ; $10
   const _CI_White               = <ct_white            - <colorTables ; $18
   
   const _CI_GreenPlaneHr        = <ct_smallEnemyPlaneHr- <colorTables ; $20
   const _CI_GreenPlane          = <ct_smallEnemyPlane  - <colorTables ; $20
   const _CI_DkGreenPlane        = <ct_smallEnemyPlane  - <colorTables ; $20
   const _CI_RedPlane            = <ct_redPlanes        - <colorTables ; $30
   const _CI_MedGreenPlane       = <ct_medEnemyPlane    - <colorTables ; $40
   const _CI_BigGreenPlane       = <ct_bigEnemyPlane    - <colorTables ; $50

   const _CI_Explosion1          = <ct_bonus_yellow     - <colorTables ; $60
   const _CI_Explosion2          = <ct_bonus_orange     - <colorTables ; $68
   const _CI_Explosion3          = <ct_bonus_red        - <colorTables ; $70
   const _CI_Explosion4          = <ct_AyakoMissle      - <colorTables ; $78

   const _CI_Ayako_Missile       = <ct_AyakoMissle      - <colorTables ; $78 ;orig color = _44

   const _CI_SideFighter         = <ct_SideFighter      - <colorTables ; $80

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
   dim animation_state   = h

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
   dim unused                 = t
   dim unused2                = playfieldpos  ; playfieldpos not used by the multisprite kernel?

   dim enemies_shoot_down     = u
   dim active_multisprites    = v  ; bitmask (bit0 - bit4) for the 5 multisprites
   dim stage                  = w
   dim framecounter           = x
   dim map_section            = y
   dim _Bit0_map_speed        = y  ; 00: no scrolling                     01: scroll every second frame
   dim _Bit1_map_speed        = y  ; 10: scroll every 8th frame           11: scroll every 16th frame
   dim _Bit2_map_pfheight     = y  ;  0: pfheight=0 (1px -> 2 pf rows)     1: pfheight=3 (4px -> 8 pf rows)
   dim _Bit3_map_direction    = y  ;  0: scroll up                         1: scroll down 
   dim _Bit4_map_P_moving     = y  ; Player can move
   dim _Bit5_map_E_moving     = y  ; Enemies moving
   dim _Bit6_map_PF_collision = y  ; Playfield collision active
   dim _Bit7_map_E_collsion   = y  ; Enemy collision and player shooting active


   dim game_flags             = z
   dim _Bit0_stage_intro      = z
   dim _Bit1_reset_restrainer = z
   dim _Bit2_looping          = z
   dim _Bit3_mute_bg_music    = z
   dim _Bit4_genesispad       = z
   dim _Bit5_PlusROM          = z
   dim _Bit6_p0_explosion     = z
   dim _Bit7_hide_sidefighter = z  ; hide sidefighter and Playfield mirrored

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
   dim w_Bit7_Left_Plane_is_SF = w127
   dim r_Bit7_Left_Plane_is_SF = r127
   dim w_COLUPF              = w126
   dim r_COLUPF              = r126
   dim w_stage_bonus_counter = w125
   dim r_stage_bonus_counter = r125
   dim w_COLUP0              = w124 
   dim r_COLUP0              = r124
   dim w_CTRLPF              = w123
   dim r_CTRLPF              = r123
   dim r_total_enemies_BCD1  = r122
   dim w_total_enemies_BCD1  = w122
   dim r_total_enemies_BCD   = r121
   dim w_total_enemies_BCD   = w121

   ; The variables from here on can be overwritten by the text screens.
   ; arrays with status information of the 5 multisprites and their NUSIZ copies
   dim w_playerhits_c       = w115
   dim r_playerhits_c       = r115

   dim w_playerhits_b       = w110
   dim r_playerhits_b       = r110

   dim w_playerhits_a       = w105
   dim r_playerhits_a       = r105

   dim w_error_accumulator  = w100
   dim r_error_accumulator  = r100

   dim w_delta_y            = w095
   dim r_delta_y            = r095

   dim w_delta_x            = w090
   dim r_delta_x            = r090

   dim w_octant             = w085
   dim r_octant             = r085

   dim w_msp5_animation_state = w084
   dim r_msp5_animation_state = r084
   dim w_msp4_animation_state = w083
   dim r_msp4_animation_state = r083
   dim w_msp3_animation_state = w082
   dim r_msp3_animation_state = r082
   dim w_msp2_animation_state = w081
   dim r_msp2_animation_state = r081
   dim w_msp1_animation_state = w080
   dim r_msp1_animation_state = r080
   dim w_msp_animation_state = w080
   dim r_msp_animation_state = r080


;#endregion


   bank 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 1 Game Logic"

   scorecolor = _Color_Score

   game_flags = 0
   if INPT1{7} then _Bit4_genesispad{4} = 1
   if ReceiveBufferSize = 0 then _Bit5_PlusROM{5} = 1

   goto titlescreen_start bank7
 

start

   rem initial variables setup
   missile0y = 0 : framecounter = 0 : attack_position = 0 : active_multisprites = 0 : enemies_shoot_down = 0 : w_total_enemies_BCD = 0 : w_total_enemies_BCD1 = 0 : _sc1 = 0 : _sc2 = 0 : _sc3 = 0
   w_stage_bonus_counter = $ff
   map_section = _Map_Takeoff
   player0x = _Player0_X_Start : player0y = _Player0_Y_Start
   lives = 64 : stage = $20
   game_flags = game_flags & %00110000  ; Reset all except genesis controller and PlusROM detection
   game_flags = game_flags | %10001001  ; Set hide sidefighter(PF mirror), intro and mute bg music
   pfheight = 3
   statusbarlength = %10101000

   missile1y = 100 : missile1x = 100 : _Ch0_Sound = _Sfx_Mute

   PF1pointerhi = _PF1_Carrier_Boss_high
   PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Takeoff_Point_1 : PF2pointer = _Map_Takeoff_Point_1

   w_COLUPF = _Color_Carrier
   w_COLUP0 = _Color_Player_Plane_Base
   w_CTRLPF = %00100001
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
   COLUBK = _Color_Ocean
   COLUP0 = _Color_Player_Bullet
   Player0SwitchColor = r_COLUP0
   
   if _Bit0_stage_intro{0} then goto stage_intro bank2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Player 0 explosion animation"
   if !_Bit6_p0_explosion{6} then _skip_player0_explosion

   if framecounter & %1111 then _skip_player0_collision

   animation_state = animation_state + 1
   if animation_state > 5 then _player0_explosion_animation_end
   w_COLUP0 = _player0_explosion_color_table[animation_state]
   player0pointerlo = _player0_explosion_ptrl_table[animation_state]
   player0pointerhi = _player0_explosion_ptrh_table[animation_state]
   player0height = _player0_explosion_height_table[animation_state]
   goto _skip_player0_collision

_player0_explosion_animation_end
   player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height : _Bit6_p0_explosion{6} = 0 : w_NUSIZ0 = 0
   if lives < 32 then WriteToBuffer = 0 : WriteToBuffer = _sc1 : WriteToBuffer = _sc2 : WriteToBuffer = _sc3 : WriteToBuffer = stage : WriteSendBuffer = HighScoreDB_ID : AUDV0 = 0 : AUDV1 = 0 : goto __Game_Over_Music_Setup_01 bank6
   lives = lives - 32 : player0x = _Player0_X_Start : player0y = _Player0_Y_Start
   statusbarlength = %10101000 : w_COLUP0 = _Color_Player_Plane_Base
   attack_position = attack_position - 1

;   rem  if player explodes, reset bonus for this wave
   if COLUP5 = _CI_Explosion4 then w_stage_bonus_counter = r_stage_bonus_counter - 1
;     ^^^^^^^^^^^^ this only works as long msp 5 hasn't been reused as missile !

   active_multisprites = 0
   if _Bit6_map_PF_collision{6} then goto _Play_In_Game_Music
   goto __Respawn_Music_Setup bank6
_skip_player0_explosion
;#endregion

   if !_Bit7_map_E_collsion{7} then goto _Playfield_scrolling

   if !active_multisprites then goto build_attack_position bank2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Collision check for missile 0"
   if _Bit2_looping{2} then goto _skip_player0_collision
   if !_Bit6_map_PF_collision{6} then goto _skip_m0_pf_collision
   if collision(missile0, playfield) then temp3 = 0 : temp1 = 0 : goto _end_collision_check bank3
   goto _skip_missile0_collision
_skip_m0_pf_collision
   if collision(player1, missile0) then goto _collision_detection bank3

_skip_missile0_collision
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Collision check for player 0"
   if _Ch0_Sound = _Sfx_Respawn_Bass then goto _skip_player0_collision
   if _Bit6_map_PF_collision{6} && collision(player0, playfield) then goto _player0_collision bank3
   if collision(player0, player1) then goto check_sidefighter_collision bank3

_skip_player0_collision
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Playfield scrolling"
_Playfield_scrolling
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

   if _Bit7_map_E_collsion{7} then goto _skip_carrier

   if PF1pointer = _Map_Takeoff_Point_1 then goto set_game_state_intro
   if PF1pointer = _Map_Takeoff_Sound_Start then _Ch0_Sound = _Sfx_Takeoff : _Ch0_Duration = 1 : _Ch0_Counter = 0 : goto _skip_playfield_restart
   if PF1pointer = _Map_Attackzone_Start then goto set_game_state_attack_start
   if PF1pointer > _Map_Carrier_End && player5y > 15 then goto dock_sidefighter

   if map_section <> _Map_Takeoff then goto _skip_carrier_superstructures_scrolling
   if PF1pointer = _Map_Carrier_End then goto set_game_state_sidefighter_takoff
   for temp1 = 0 to 4
   temp4 = _multisprite_parking_point_bank1[temp1]
   if NewSpriteY[temp1] < temp4 then NewSpriteY[temp1] = NewSpriteY[temp1] - _Pf_Pixel_Height else goto _next_superstructure

   temp3 = NewSpriteY[temp1] - playerfullheight[temp1]
   if spriteheight[temp1] < playerfullheight[temp1]  && temp3 < 85 && NewSpriteY[temp1] > spriteheight[temp1] then spriteheight[temp1] = spriteheight[temp1] + _Pf_Pixel_Height : NewSpriteY[temp1] = 84
   if spriteheight[temp1] > playerfullheight[temp1] then spriteheight[temp1] = playerfullheight[temp1]
   if spriteheight[temp1] > NewSpriteY[temp1] && spriteheight[temp1] > _Pf_Pixel_Height then spriteheight[temp1] = spriteheight[temp1] - _Pf_Pixel_Height : playerpointerlo[temp1] = playerpointerlo[temp1] + _Pf_Pixel_Height

   if NewSpriteY[temp1] < 2 || NewSpriteY[temp1] > temp4 then NewSpriteY[temp1] = temp4

_next_superstructure
   next
_skip_carrier_superstructures_scrolling
_skip_carrier

   if !_Bit6_map_PF_collision{6} then _skip_boss_moving_down
   if PF1pointer > _Map_Boss_End_dw then _Bit3_map_direction{3} = 0
   goto _skip_scrolling
_skip_boss_moving_down

   if PF1pointer <> _Map_End then _skip_playfield_restart
_next_playfield_variation
   PF1pointer = 0 : PF2pointer = 0
   temp1 = stage & %00000011
   w_COLUPF = _playfield_color_table[temp1]
   if PF1pointerhi = _PF1_Pacific_b_high then PF1pointerhi = _PF1_Pacific_a_high : PF2pointerhi = _PF2_Pacific_a_high : goto _skip_playfield_restart
   PF1pointerhi = PF1pointerhi + 1
   PF2pointerhi = PF2pointerhi + 1
   w_CTRLPF = r_CTRLPF ^ 1

_skip_playfield_restart



_skip_scrolling
;#endregion
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Player 0 movement and looping animation"
_check_player_movement
   if _Bit6_p0_explosion{6} then goto _multisprite_movement
   if _Bit4_map_P_moving{4} then goto _player_movement

   if framecounter < 30 || framecounter{0} then goto _multisprite_movement

   if player0y < _Player0_Y_Start then player0y = player0y + 1
   if player0y > _Player0_Y_Start then player0y = player0y - 1
   if player0x < _Player0_X_Start then player0x = player0x + 1
   if player0x > _Player0_X_Start then player0x = player0x - 1
   
   goto _multisprite_movement


_player_movement
   if !_Bit2_looping{2} then goto _check_for_new_looping
   if framecounter{0} then _player_horizontal_movement
   animation_state = animation_state + 1
   
   if animation_state = 5 then player0pointerlo = _Player0_Looping_1_low : player0pointerhi = _Player0_Looping_1_high : player0height = _Player0_Looping_1_height
   if animation_state < 10 && player0y < _Player0_Y_Max then player0y = player0y + 1 : goto _player_horizontal_movement
   if animation_state = 10 then player0pointerlo = _Player0_Plane_down_low : player0pointerhi = _Player0_Plane_down_high : player0height = _Player0_Plane_down_height : goto _player_horizontal_movement
   if animation_state = 25 then player0pointerlo = _Player0_Looping_2_low : player0pointerhi = _Player0_Looping_2_high : player0height = _Player0_Looping_2_height
   if animation_state < 30 && player0y > _Player0_Y_Min then player0y = player0y - 1 : COLUP0 = _Color_Player_Plane_Bottom : goto _player_horizontal_movement
   if animation_state = 30 then player0pointerlo = _Player0_Plane_up_low : player0pointerhi = _Player0_Plane_up_high : player0height = _Player0_Plane_up_height : goto _player_horizontal_movement
   if animation_state < 40 then player0y = player0y + 1 : goto _player_horizontal_movement
   if animation_state = 40 then _Bit2_looping{2} = 0
   goto _player_horizontal_movement

_check_for_new_looping
   if !statusbarlength then goto _skip_new_looping
   if _Bit4_genesispad{4} && !INPT1{7} then goto set_game_state_looping
   if switchselect || joy1fire then goto set_game_state_looping
_skip_new_looping

_player_vertical_movement
   if joy0up && player0y < _Player0_Y_Max then player0y = player0y + 1 : goto _player_horizontal_movement
   if joy0down && player0y > _Player0_Y_Min then player0y = player0y - 1
_player_horizontal_movement
   if joy0left && player0x > _Player0_X_Min then player0x = player0x - 1 : goto _skip_player_movement
   if !joy0right then _skip_player_movement
   if _Bit7_hide_sidefighter{7} then _move_right_without_sidefighter
   if player0x >= _Player0_X_Max_2SF && r_NUSIZ0{1} then _skip_player_movement
   if player0x >= _Player0_X_Max_1SF && r_NUSIZ0{0} then _skip_player_movement
_move_right_without_sidefighter
   if player0x >= _Player0_X_Max then _skip_player_movement
   player0x = player0x + 1
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
;#region "Multisprite (Enemies, missiles and PowerUp) movement"
_multisprite_movement

   if !_Bit5_map_E_moving{5} || !active_multisprites then goto _skip_multisprite_movement

   temp1 = ( framecounter & %00000001 ) * 2

_multisprite_movement_loop_start

   temp3 = playertype[temp1] & %00000111
   temp4 = _multisprite_parking_point_bank1[temp1]
   temp5 = rand

   on temp3 goto _msp_moves_left _msp_moves_right _msp_moves_down _msp_moves_up _msp_fixed_dir _msp_follows_p0 _msp_pf_synced

_msp_moves_right
   if NewSpriteY[temp1] = temp4 then goto _check_next_multisprite
   temp3 = NewSpriteX[temp1]
   if temp3 > 158 then goto park_multisprite
   NewSpriteX[temp1] = temp3 + _Plane_X2_Speed

   if temp3 > player0x && temp5 < 128 then goto _msp_switch_to_down

   if NewSpriteX[temp1] < 121 then goto _check_next_multisprite
   if NewNUSIZ[temp1] = %00001011 && NewSpriteX[temp1] > 120 then NewNUSIZ[temp1] = %00001001
   if NewNUSIZ[temp1] = %00001001 && NewSpriteX[temp1] > 136 then NewNUSIZ[temp1] = %00001000
   goto _check_next_multisprite

_msp_moves_left
   if NewSpriteY[temp1] = temp4 then goto _check_next_multisprite
   temp3 = NewSpriteX[temp1]
   if !NewNUSIZ[temp1] && temp3 < 9 then goto park_multisprite
   NewSpriteX[temp1] = temp3 - _Plane_X2_Speed
   
   if temp3 < player0x && temp5 < 128 then goto _msp_switch_to_down

   if temp3 < 11 && NewNUSIZ[temp1] then NewNUSIZ[temp1] = NewNUSIZ[temp1] / 2 : NewSpriteX[temp1] = temp3 + 16

   goto _check_next_multisprite

    rem handle when side-to-side flying planes switch to the down-facing direction
_msp_switch_to_down
    playertype[temp1] = (( playertype[temp1] - 16 ) & %11111000) | movesDown
    temp3 = playertype[temp1] / 8
    playerpointerlo[temp1]  = _player_pointer_lo_bank1[temp3]
    playerpointerhi[temp1]  = _player_pointer_hi_bank1[temp3]

    rem need to switch palettes since graphics has changed
    NewCOLUP1[temp1] = _CI_GreenPlane
    goto _check_next_multisprite

_msp_moves_down
   temp3 = NewSpriteY[temp1]
   if temp3 = temp4 then goto _check_next_multisprite
   if temp3 < 2 then goto park_multisprite
   temp2 = stage * 4
   if temp3 <> _Plane_Y_Turnpoint || temp5 > temp2 then _skip_msp_turns

    rem mask off color
;   NewCOLUP1[temp1] = NewCOLUP1[temp1] & %11110111
   playertype[temp1] = playertype[temp1] + 9
   temp5 = playertype[temp1] / 8 : playerpointerlo[temp1] = _player_pointer_lo_bank1[temp5] + 1 - playerfullheight[temp1]
   playerpointerhi[temp1] = _player_pointer_hi_bank1[temp5]

_fire_new_missile_if_msp_free
   if active_multisprites = 31 then goto _skip_new_missile

   temp2 = 0
   if !active_multisprites{0} then active_multisprites = active_multisprites + 1 : goto _free_multisprite_found
   temp5 = active_multisprites / 2 : temp2 = temp2 + 1
   if !temp5{0} then active_multisprites = active_multisprites | %10 : goto _free_multisprite_found
   temp5 = temp5 / 2 : temp2 = temp2 + 1
   if !temp5{0} then active_multisprites = active_multisprites | %100 : goto _free_multisprite_found
   temp5 = temp5 / 2 : temp2 = temp2 + 1
   if !temp5{0} then active_multisprites = active_multisprites | %1000 : goto _free_multisprite_found
   active_multisprites = active_multisprites | %10000 : temp2 = temp2 + 1
_free_multisprite_found

   NewSpriteY[temp2] = _Plane_Y_Shootpoint : NewSpriteX[temp2] = NewSpriteX[temp1]
   NewNUSIZ[temp2] = 0
   NewCOLUP1[temp2] = _CI_Ayako_Missile
   playertype[temp2] = typeMissile
   playerpointerlo[temp2]  = _Ayako_Missile_low
   playerpointerhi[temp2]  = _Ayako_Missile_high
   playerfullheight[temp2] = _Ayako_Missile_height
   spriteheight[temp2]     = _Ayako_Missile_height

   temp3 = player0x + 8

   if NewSpriteX[temp2] < temp3 then w_octant[temp2] = 4 : w_delta_x[temp2] = temp3 - NewSpriteX[temp2] else w_octant[temp2] = 0 : w_delta_x[temp2] = NewSpriteX[temp2] - temp3
   if _Plane_Y_Targetpoint < player0y then w_octant[temp2] = r_octant[temp2] | %10 : w_delta_y[temp2] = player0y - _Plane_Y_Targetpoint else w_octant[temp2] = r_octant[temp2] & %11111101 : w_delta_y[temp2] = _Plane_Y_Targetpoint - player0y

   if r_delta_x[temp2] < $80 then w_delta_y[temp2] = r_delta_y[temp2] * 2 : w_delta_x[temp2] = r_delta_x[temp2] * 2

   if r_delta_x[temp2] > r_delta_y[temp2] then goto __dx_gt
   w_octant[temp2] = r_octant[temp2] & %11111110
   if r_error_accumulator[temp2] > r_delta_y[temp2] then w_error_accumulator[temp2] = r_delta_y[temp2] / 2
   goto __set_ea

__dx_gt
   w_octant[temp2] = r_octant[temp2] | %00000001
   if r_error_accumulator[temp2] > r_delta_x[temp2] then w_error_accumulator[temp2] = r_delta_x[temp2] / 2

__set_ea
   if (r_octant[temp1] & %1) then w_error_accumulator[temp2] = r_delta_x[temp2] / 2 else w_error_accumulator[temp2] = r_delta_y[temp2] / 2

_skip_new_missile

   goto _check_next_multisprite
_skip_msp_turns
   NewSpriteY[temp1] = temp3 - _Plane_Y_Speed
   if !_Bit7_map_E_collsion{7} then goto _check_next_multisprite 
   if temp3 > 70 || temp5 < 128 then goto _check_next_multisprite
   temp3 = player0x + 8

   if NewSpriteX[temp1] > temp3 then NewSpriteX[temp1] = NewSpriteX[temp1] - _Plane_X1_Speed : goto _check_next_multisprite
   if NewSpriteX[temp1] < temp3 then NewSpriteX[temp1] = NewSpriteX[temp1] + _Plane_X1_Speed

   goto _check_next_multisprite

_msp_moves_up
   NewCOLUP1[temp1] = NewCOLUP1[temp1] | %1000
   temp3 = NewSpriteY[temp1]
   if temp3 = temp4 then _check_next_multisprite
   if temp3 > 100 && temp3 < 140 then goto park_multisprite
   NewSpriteY[temp1] = temp3 + _Plane_Y_Speed 
   if NewSpriteY[temp1] > 1 && NewSpriteY[temp1] <= playerfullheight[temp1] then playerpointerlo[temp1] = playerpointerlo[temp1] - _Plane_Y_Speed : spriteheight[temp1] = NewSpriteY[temp1]
;   if NewSpriteY[temp1] > 84 && spriteheight[temp1] then playerpointerlo[temp1] = playerpointerlo[temp1] + spriteheight[temp1] - NewSpriteY[temp1] : spriteheight[temp1] = NewSpriteY[temp1]
   if NewSpriteY[temp1] > _Plane_Y_Turnpoint && stage < 25 then goto _fire_new_missile_if_msp_free

   goto _check_next_multisprite

_msp_fixed_dir
;   if ( framecounter & %00000010 ) then goto _check_next_multisprite
   if NewSpriteY[temp1] = temp4 then _check_next_multisprite

   if NewSpriteY[temp1] > 1 && NewSpriteY[temp1] < 80 && NewSpriteX[temp1] > 1 && NewSpriteX[temp1] < 154 then _skip_remove_missile
   goto park_multisprite
_skip_remove_missile

   temp3 = r_error_accumulator[temp1]
   temp5 = r_octant[temp1]

   if temp5{0} then goto __Skip_Chase1
   NewSpriteY[temp1] = NewSpriteY[temp1] + _Data_yinc[temp5]
   w_error_accumulator[temp1] = temp3 - r_delta_x[temp1]
   if temp3 < r_error_accumulator[temp1] then w_error_accumulator[temp1] = r_error_accumulator[temp1] + r_delta_y[temp1] : NewSpriteX[temp1] = NewSpriteX[temp1]  + _Data_xinc[temp5]

   goto _check_next_multisprite

__Skip_Chase1

   NewSpriteX[temp1]  = NewSpriteX[temp1] + _Data_xinc[temp5]
   w_error_accumulator[temp1] = temp3 - r_delta_y[temp1]
   if temp3 < r_error_accumulator[temp1] then w_error_accumulator[temp1] = r_error_accumulator[temp1] + r_delta_x[temp1] : NewSpriteY[temp1] = NewSpriteY[temp1] + _Data_yinc[temp5] 

   goto _check_next_multisprite


_msp_follows_p0
   if (framecounter & %00000010 ) then _check_next_multisprite
   if PF1pointer > _Map_Boss_End_dw || PF1pointer < _Map_Boss_End_up then _check_next_multisprite
   if NewSpriteY[temp1] < temp4 then __skip_missile_init
   NewSpriteY[temp1] = _y_init_pos_missile[temp1] - PF1pointer
   NewSpriteX[temp1] = ( temp1 * 16 ) + 50
   goto _check_next_multisprite
__skip_missile_init
   temp3 = temp1 * 2
   temp2 = player0y - temp3
   temp3 = ( temp1 * 4 ) + player0x
   if NewSpriteY[temp1] > temp2 then NewSpriteY[temp1] = NewSpriteY[temp1] - 1
   if NewSpriteY[temp1] < temp2 then NewSpriteY[temp1] = NewSpriteY[temp1] + 1
   if NewSpriteX[temp1] > temp3 then NewSpriteX[temp1] = NewSpriteX[temp1] - 1
   if NewSpriteX[temp1] < temp3 then NewSpriteX[temp1] = NewSpriteX[temp1] + 1

   goto _check_next_multisprite

_msp_pf_synced
   if NewSpriteY[temp1] = temp4 then _check_next_multisprite
   if playertype[temp1] <> typeMspExpl then _skip_explosion_animation
   if ( framecounter & %1110 ) then _check_next_multisprite
   temp2 = r_msp_animation_state[temp1]
   NewCOLUP1[temp1] = _player0_explosion_color_table[temp2]
   player1pointerhi[temp1] = _player0_explosion_ptrh_table[temp2]
   player1pointerlo[temp1] = _player0_explosion_ptrl_table[temp2]
   if temp2 > 5 then goto park_multisprite
   w_msp_animation_state[temp1] = temp2 + 1
_skip_explosion_animation

   temp2 = map_section & %111
   on temp2 goto _check_next_multisprite _move_4px _move_1px _move_0_25px _check_next_multisprite _move_1px _move_0_25px _move_0_125px

_move_4px
   temp2 = 2
   goto _move_msp_pf_synced
_move_1px
   temp2 = ( framecounter & %10 ) / 2
   goto _move_msp_pf_synced
_move_0_25px
   temp2 = ( framecounter & %1110 ) / 8
   goto _move_msp_pf_synced
_move_0_125px
   temp2 = ( framecounter & %11110 ) / 16

_move_msp_pf_synced
   temp3 = NewSpriteY[temp1]
   if temp3 < temp2 then goto park_multisprite
   NewSpriteY[temp1] = temp3 - temp2

_check_next_multisprite
   temp1 = temp1 + 1
   if temp1 <> 5 && temp1 <> 2 then goto _multisprite_movement_loop_start


_skip_multisprite_movement
;#endregion


_skip_game_action

   goto _Play_In_Game_Music bank6

;#endregion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Subroutines and Functions Bank 1"

park_multisprite
   NewSpriteY[temp1] = temp4
   asm
; bB code:   active_multisprites = active_multisprites & inverse_bit_shift_table_bank1[temp1]
; LDX temp1 ; the bB line before this ASM block has already set x to temp1
	LDA active_multisprites
	AND inverse_bit_shift_table_bank1,x
	STA active_multisprites
end
   goto _check_next_multisprite

dock_sidefighter
   if r_Bit7_Left_Plane_is_SF{7} then player0x = _Player0_X_Start_WSF
   active_multisprites = 0 : framecounter = 0
   _Bit7_hide_sidefighter{7} = 0
   player5y = _Player5_Parking_Point
   goto _skip_game_action

set_game_state_attack_start
   map_section = _Map_Pacific : _Bit3_mute_bg_music{3} = 0 : PF1pointerhi = _PF1_Pacific_b_high : PF2pointerhi = _PF2_Pacific_b_high : pfheight = 1
   goto _next_playfield_variation


set_game_state_looping
   statusbarlength = statusbarlength * 4
   callmacro _Set_SFX_By_Prio _Sfx_Looping
   animation_state = 0 : _Bit2_looping{2} = 1
   goto _skip_new_looping

set_game_state_sidefighter_takoff
   map_section = _Map_Landing

   if ! ( r_NUSIZ0 & %11 ) then _Bit7_hide_sidefighter{7} = 0 : goto _skip_game_action 
   NUSIZ5 = r_NUSIZ0 - 1
   player5y = 255
   player5type = movesUp
   COLUP5 = _CI_SideFighter
   player5pointerlo = _Player5_Sfighter_up_low : player5pointerhi = _Player0_Plane_up_high
   player5height = 0 : player5fullheight = _Player5_Sfighter_height
   if r_Bit7_Left_Plane_is_SF{7} then player5x = 68 else player5x = 100
   active_multisprites = %00010000

   goto _skip_game_action

set_game_state_intro
   if stage = 0 then goto _prepare_Endscreen_bank5 bank5
   if statusbarlength < %10101000 then statusbarlength = %10101000
   _Bit0_stage_intro{0} = 1 : framecounter = 0 
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

   data _multisprite_parking_point_bank1
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end

   data _player0_explosion_ptrh_table
   >_Player0_Explosion_0, >_Player0_Explosion_1, >_Player0_Explosion_2, >_Player0_Explosion_3, >_Player0_Explosion_4
end

   data _player0_explosion_ptrl_table
   <_Player0_Explosion_0, <_Player0_Explosion_1, <_Player0_Explosion_2, <_Player0_Explosion_3, <_Player0_Explosion_4
end

   data _player0_explosion_color_table
   ; _4E, _48, _46, _42, _42 -- old colors
   _CI_Explosion1,   _CI_Explosion2,   _CI_Explosion3,   _CI_Explosion4,   _CI_Explosion4
end

   data _player0_explosion_height_table
   _Player0_Explosion_0_length, _Player0_Explosion_1_length, _Player0_Explosion_2_length, _Player0_Explosion_3_length, _Player0_Explosion_4_length, 0
end

   data _playfield_color_table
   _Color_Gras_Island, _Color_Sand_Island, _Color_Jungle_Island, _Color_Gras_Island
end

   data _y_init_pos_missile
   155,145,140,145,155
end
   ;***************************************************************
   ;
   ;  Bresenham-like data.
   ;
   data _Data_yinc
   $FF, $FF, $01, $01, $FF, $FF,$01, $01
end

   data _Data_xinc
   $FF, $FF, $FF, $FF, $01, $01, $01, $01
end

   data inverse_bit_shift_table_bank1
   %11111110, %11111101, %11111011, %11110111, %11101111, %11011111
end

;#endregion

;#endregion

   bank 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 2 Attack Position & Data"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Intro with stage nr"
stage_intro
   if framecounter > 60 then _Bit0_stage_intro{0} = 0 : goto carrier_superstructures_init
   player1x = 80 : player2x = 88
   player1y = 50 : player2y = 50
   _NUSIZ1 = 0 : NUSIZ2 = 0 
   player1height = 9 : player2height = 9
   COLUP2 = _CI_White : _COLUP1 = _CI_White
   player1pointerhi = _Score_Table_High : player2pointerhi = _Score_Table_High
   temp4 = hex_to_bcd[stage]
   temp5 = (temp4 & $0f ) * 8
   player2pointerlo = temp5 + _Score_Table_Low
   temp5 = (temp4 & $f0 ) / 2
   player1pointerlo = temp5 + _Score_Table_Low
   goto _bank_2_code_end
;#endregion


build_attack_position
   if stage > 15 then temp2 = _attack_position_sequence_1[attack_position] else temp2 = _attack_position_sequence_2[attack_position]
   if _Bit7_hide_sidefighter{7} && temp2 < 226 then goto set_game_state_landing_0_after_boss bank3
   attack_position = attack_position + 1
   asm
   LDX enemies_shoot_down
	SED
	CLC
	LDA r_total_enemies_BCD1
	ADC hex_to_bcd,x
   STA w_total_enemies_BCD1
	LDA r_total_enemies_BCD
	ADC #0
	STA w_total_enemies_BCD
	CLD
end

   enemies_shoot_down = 0 : active_multisprites = 31 ; assumes that all sprites are used in every wave !
   if temp2 < 226 then _read_attack_data
   if temp2 > 229 then goto set_game_state_landing
   temp3 = temp2 - 226
   map_section = _boss_stage_map_direction[temp3]
   w_playerhits_a = _boss_stage_hits[temp3]
   PF1pointer = _boss_stage_map_start[temp3] : PF2pointer = PF1pointer
   w_COLUPF = _boss_stage_color[temp3]
   goto set_game_state_boss
_read_attack_data
   for temp1 = 0 to 4
      temp3             = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewSpriteX[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewSpriteY[temp1] = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewNUSIZ[temp1]   = _attack_position_data[temp2] : temp2 = temp2 + 1
      NewCOLUP1[temp1]  = _attack_position_data[temp2] : temp2 = temp2 + 1

      playertype[temp1] = temp3
      temp3 = temp3 / 8

      playerpointerlo[temp1]  = _player_pointer_lo[temp3]
      playerpointerhi[temp1]  = _player_pointer_hi[temp3]
      playerfullheight[temp1] = _player_full_height[temp3]
      spriteheight[temp1]     = _player_full_height[temp3]
      temp5                   = _player_max_hits[temp3]

      w_playerhits_a[temp1] = temp5 : w_playerhits_b[temp1] = temp5 : w_playerhits_c[temp1] = temp5
   next

   rem --- set bonus if red plane group
   if NewCOLUP1 = _CI_RedPlane then w_stage_bonus_counter = r_stage_bonus_counter + 1

_bank_2_code_end
   goto _Play_In_Game_Music bank6


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Subroutines and Functions Bank 2"
set_game_state_landing
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Landingzone_Start : PF2pointer = _Map_Landingzone_Start
   map_section = _Map_Landing : _Bit3_mute_bg_music{3} = 1 : w_COLUPF = _Color_Carrier
   framecounter = 0 : missile0y = 0 : _Ch0_Counter = 0
   _Bit7_hide_sidefighter{7} = 1
   _Ch0_Sound = _Sfx_Landing : _Ch0_Duration = 1 : pfheight = 3
   stage = stage - 1
   if r_Bit7_Left_Plane_is_SF{7} then player0x = player0x + 16 
   if stage = 15 then attack_position = 0
   player1y = _Player1_Parking_Point
   player2y = _Player2_Parking_Point
   player3y = _Player3_Parking_Point
   player4y = _Player4_Parking_Point
   if ! ( r_NUSIZ0 & %11 ) then _no_side_fighters
   NUSIZ5 = r_NUSIZ0 - 1
   player5y = player0y - 8
   player5type = movesDown
   COLUP5 = _CI_SideFighter
   player5pointerlo = _Player0_Plane_up_low : player5pointerhi = _Player0_Plane_up_high
   player5height = _Player5_Sfighter_height : player5fullheight = _Player5_Sfighter_height

   if r_Bit7_Left_Plane_is_SF{7} then player5x = player0x - 8 else  player5x = player0x + 24
   active_multisprites = %00010000
   goto _bank_2_code_end

_no_side_fighters
   player5y = _Player5_Parking_Point
   active_multisprites = 0
   goto _bank_2_code_end

set_game_state_boss
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   pfheight = 0
   if r_Bit7_Left_Plane_is_SF{7} then player0x = player0x + 16 
   _Bit7_hide_sidefighter{7} = 1

   for temp1 = 0 to 4
      NewSpriteY[temp1] = _multisprite_parking_point[temp1]
      NewNUSIZ[temp1]   = temp3
      NewCOLUP1[temp1]  = _CI_Ayako_Missile
      playertype[temp1] = typeAyMissile

      playerpointerlo[temp1]  = _Ayako_Missile_low
      playerpointerhi[temp1]  = _Ayako_Missile_high
      playerfullheight[temp1] = _Ayako_Missile_height
      spriteheight[temp1]     = _Ayako_Missile_height
   next
   goto __Boss_Entry_Music_Setup bank6

carrier_superstructures_init
   _COLUP1 = _Carrier_88_ColorIdx : COLUP2 = _Carrier_88_ColorIdx : COLUP4 = _Carrier_88_ColorIdx
   COLUP3 = _Carrier_Tower_ColorIdx
   map_section = _Map_Takeoff
   player1pointerlo = _Carrier_88_low     : player1pointerhi = _Carrier_88_high     : player1height =  0 : player1fullheight = _Carrier_88_height     : _NUSIZ1 = 7 : player1x =  69 : player1y = 130
   player2pointerlo = _Carrier_Runway_low : player2pointerhi = _Carrier_Runway_high : player2height =  0 : player2fullheight = _Carrier_Runway_height :  NUSIZ2 = 7 : player2x =  71 : player2y = 100
   player3pointerlo = _Carrier_Tower_low  : player3pointerhi = _Carrier_Tower_high  : player3height = 62 : player3fullheight = _Carrier_Tower_height  :  NUSIZ3 = 5 : player3x = 105 : player3y =  88
   player4pointerlo = _Carrier_Runway_low : player4pointerhi = _Carrier_Runway_high : player4height =  3 : player4fullheight = _Carrier_Runway_height :  NUSIZ4 = 7 : player4x =  69 : player4y =  20
   goto _bank_2_code_end
;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Data Tables Bank2"
   data _player_max_hits
   1, 1, 1
   3, 3, 3
   5, 5
end

   ; we might need more values here, because we don't reset "enemies_shoot_down"
   ; when the player gets hit and the attack wave restarts.
   data hex_to_bcd
   $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $11, $12, $13, $14, $15
   $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31
   $32
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

   data _multisprite_parking_point
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end

   data _boss_stage_map_direction
   _Map_Boss_down, _Map_Boss_down, _Map_Boss_up, _Map_Boss_up
end

   data _boss_stage_hits
   75, 125, 175, 250
end

   data _boss_stage_map_start
   _Map_Boss_Start_dw, _Map_Boss_Start_dw, _Map_Boss_Start_up, _Map_Boss_Start_up
end

   data _boss_stage_color
   _D8, _D6, _D6, _D4
end

   asm
   align 256
end
  ;  1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16
   data _attack_position_sequence_1
   0, 25, 200, 50, 0, 25, 75, 200, 50, 254
   0, 125, 200, 150, 75, 75, 125, 0, 205, 50, 254
   25, 25, 75, 205, 50, 100, 0, 125, 200, 150, 75, 254
   0, 125, 200, 150, 75, 75, 125, 0, 25, 210, 150, 160, 165, 254
   50, 100, 205, 125, 25, 150, 75, 75, 125, 0, 215, 125, 125, 100, 254
   25, 75, 50, 50, 205, 0, 125, 25, 150, 75, 75, 200, 75, 125, 254
   0, 0, 25, 50, 100, 225, 150, 75, 75, 125, 75, 75, 220, 125, 100, 226
   25, 75, 50, 210, 100, 0, 125, 25, 150, 50, 210, 25, 0, 100, 100, 254
   0, 0, 25, 210, 0, 125, 75, 50, 50, 100, 200, 75, 150, 160, 175, 254
   50, 100, 0, 125, 215, 150, 125, 75, 150, 160, 175, 215, 75, 125, 0, 254
   0, 0, 25, 50, 0, 215, 75, 50, 50, 0, 25, 75, 205, 175, 100, 254
   25, 75, 50, 0, 215, 75, 50, 125, 50, 100, 0, 125, 215, 150, 0, 254
   0, 0, 25, 215, 125, 25, 150, 75, 75, 0, 25, 75, 200, 50, 100, 254
   50, 100, 205, 25, 75, 150, 160, 175, 125, 25, 150, 75, 225, 125, 0, 254
   215, 0, 0, 25, 50, 100, 100, 150, 175, 125, 75, 75, 215, 125, 0, 80, 227
   50, 100, 0, 200, 25, 150, 75, 75, 125, 25, 150, 215, 75, 125, 0, 85, 254
   0, 0, 25, 50, 125, 25, 150, 215, 75, 0, 25, 220, 50, 50, 100, 95, 254
end

   ; 1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16 17
   data _attack_position_sequence_2
   25, 75, 225, 50, 100, 0, 125, 25, 150, 50, 0, 25, 0, 100, 225, 100, 254
   0, 0, 25, 225, 0, 25, 75, 50, 50, 100, 25, 75, 225, 160, 160, 175, 254
   50, 100, 0, 125, 225, 150, 25, 75, 150, 160, 175, 75, 75, 220, 125, 0, 254
   0, 0, 200, 50, 0, 25, 75, 50, 50, 0, 25, 75, 225, 175, 175, 100, 254
   25, 75, 225, 0, 25, 75, 50, 125, 50, 100, 0, 125, 25, 150, 205, 0, 254
   0, 0, 215, 50, 100, 100, 150, 75, 75, 125, 75, 75, 125, 225, 125, 100, 228
   25, 75, 50, 50, 225, 0, 125, 25, 150, 50, 0, 25, 0, 100, 215, 100, 254
   0, 0, 25, 50, 220, 25, 75, 50, 50, 100, 25, 75, 200, 160, 160, 175, 254
   50, 100, 0, 225, 25, 150, 25, 75, 150, 160, 175, 75, 225, 125, 125, 0, 254
   0, 0, 225, 50, 0, 25, 75, 50, 50, 0, 25, 75, 50, 205, 175, 100, 254
   25, 75, 50, 225, 25, 75, 50, 125, 50, 100, 0, 125, 25, 150, 225, 0, 254
   0, 0, 200, 50, 125, 25, 150, 75, 75, 0, 25, 75, 220, 50, 50, 100, 254
   50, 215, 0, 25, 75, 150, 160, 175, 125, 25, 150, 75, 75, 125, 225, 0, 254
   210, 0, 0, 25, 50, 100, 100, 150, 175, 125, 75, 75, 125, 225, 125, 0, 229
   50, 100, 0, 125, 25, 150, 75, 75, 220, 25, 150, 75, 75, 125, 225, 0, 95, 255
end

 rem playertype, NewSpriteX, NewSpriteY, NewNUSIZ, NewCOLUP
   data _attack_position_data
   planeSmallD + movesDown,  40,  88, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown, 110,  98, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown, 110, 108, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown,  20, 118, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown,  50, 128, OnePlane, _CI_GreenPlane

   planeMiddleD + movesDown, 40,  88, OnePlane, _CI_MedGreenPlane
   planeSmallD + movesDown,  30,  98, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown, 110, 108, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown,  20, 118, OnePlane, _CI_GreenPlane
   planeSmallD + movesDown,  50, 128, OnePlane, _CI_GreenPlane

   planeSmallLR + movesRight, 0,  84, TwoPlanesClose + mirroredR, _CI_GreenPlaneHr
   planeSmallLR + movesRight, 0,  74, TwoPlanesClose + mirroredR, _CI_GreenPlaneHr
   planeSmallLR + movesLeft, 158, 64, TwoPlanesClose,             _CI_GreenPlaneHr
   planeSmallLR + movesLeft, 158, 54, TwoPlanesClose,             _CI_GreenPlaneHr
   planeMiddleU + movesUp,    30,  1, OnePlane,                   _CI_MedGreenPlane

   planeSmallD + movesDown,  20,  88, TwoPlanesClose, _CI_DkGreenPlane
   planeSmallD + movesDown, 110,  98, TwoPlanesClose, _CI_GreenPlane
   planeSmallD + movesDown,  20, 108, TwoPlanesClose, _CI_GreenPlane
   planeBigU + movesUp,     125, 247, QuadPlane,      _CI_BigGreenPlane
   planeBigU + movesUp,      75,   1, QuadPlane,      _CI_BigGreenPlane

   planeSmallD + movesDown,  75,  88, ThreePlanesClose, _CI_DkGreenPlane
   planeSmallD + movesDown,  20,  98, ThreePlanesClose, _CI_GreenPlane
   planeSmallD + movesDown, 110, 108, OnePlane,         _CI_GreenPlane
   planeSmallD + movesDown,  90, 118, OnePlane,         _CI_GreenPlane
   planeBigU + movesUp,      30,   1, QuadPlane,        _CI_BigGreenPlane

   planeSmallD + movesDown, 40,  88, ThreePlanesMedium, _CI_GreenPlane
   planeSmallD + movesDown, 72,  98, ThreePlanesMedium, _CI_GreenPlane
   planeSmallD + movesDown, 40, 108, ThreePlanesMedium, _CI_GreenPlane
   planeSmallD + movesDown, 72, 118, ThreePlanesMedium, _CI_GreenPlane
   planeSmallD + movesDown, 40, 128, ThreePlanesMedium, _CI_GreenPlane

   planeSmallD + movesDown,  20,  88, ThreePlanesClose, _CI_GreenPlane
   planeSmallD + movesDown,  40,  98, ThreePlanesClose, _CI_GreenPlane
   planeSmallD + movesDown,  60, 108, ThreePlanesClose, _CI_GreenPlane
   planeSmallD + movesDown,  80, 118, ThreePlanesClose, _CI_GreenPlane
   planeSmallD + movesDown, 100, 128, ThreePlanesClose, _CI_GreenPlane

   planeBigU + movesUp,   8,   1, QuadPlane, _CI_BigGreenPlane
   planeBigU + movesUp,  40, 244, QuadPlane, _CI_BigGreenPlane
   planeBigU + movesUp,  72, 231, QuadPlane, _CI_BigGreenPlane
   planeBigU + movesUp, 104, 218, QuadPlane, _CI_BigGreenPlane
   planeBigU + movesUp, 136, 205, QuadPlane, _CI_BigGreenPlane

   planeSmallD + movesDown, 40,  88, OnePlane, _CI_RedPlane
   planeSmallD + movesDown, 50,  98, OnePlane, _CI_RedPlane
   planeSmallD + movesDown, 60, 108, OnePlane, _CI_RedPlane
   planeSmallD + movesDown, 70, 118, OnePlane, _CI_RedPlane
   planeSmallD + movesDown, 80, 128, OnePlane, _CI_RedPlane

   planeSmallU + movesUp,  60,   1, OnePlane, _CI_RedPlane
   planeSmallU + movesUp,  70, 246, OnePlane, _CI_RedPlane
   planeSmallU + movesUp,  80, 236, OnePlane, _CI_RedPlane
   planeSmallU + movesUp,  90, 226, OnePlane, _CI_RedPlane
   planeSmallU + movesUp, 100, 216, OnePlane, _CI_RedPlane
end
;#endregion

;#endregion

   bank 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 3 Collsision detection for missile0 and player0 side figther "

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

   if temp3{0} then temp1 = player1y + 1 : temp2 = temp1 - player1height : if missile0y >= temp2 && missile0y <= temp1 then temp1 = 0 : goto multi_collision_check
   
   if temp3{1} then temp1 = player2y + 1 : temp2 = temp1 - player2height : if missile0y >= temp2 && missile0y <= temp1 then temp1 = 1 : goto multi_collision_check
   
   if temp3{2} then temp1 = player3y + 1 : temp2 = temp1 - player3height : if missile0y >= temp2 && missile0y <= temp1 then temp1 = 2 : goto multi_collision_check

   if temp3{3} then temp1 = player4y + 1 : temp2 = temp1 - player4height : if missile0y >= temp2 && missile0y <= temp1 then temp1 = 3 : goto multi_collision_check
 
   temp1 = 4

multi_collision_check
   rem ignore hits on powerUps and enemy missiles
   if playertype[temp1] > %111111 then missile0y = missile0y + 5 : goto _bank_3_code_end

   temp2 = NewNUSIZ[temp1] & %00000111
   temp4 = NewSpriteX[temp1]
   temp5 = (r_NUSIZ0 * 16) + missile0x + 8: if r_NUSIZ0{5} then temp5 = temp5 + 4
   temp3 = 0
   on temp2 goto _end_collision_check _two_copies_close _two_copies_medium _three_copies_close _two_copies_wide _end_collision_check _three_copies_medium _end_collision_check

_two_copies_close
   rem X.X
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp3 = temp3 + 1
   goto _end_collision_check
_two_copies_medium
   rem X...X
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp3 = temp3 + 1
   goto _end_collision_check
_three_copies_close
   rem X.X.X
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp4 = temp4 + 16 : temp3 = temp3 + 1
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp3 = temp3 + 1
   goto _end_collision_check
_two_copies_wide
   rem X.......X
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp3 = temp3 + 1
   goto _end_collision_check
_three_copies_medium
   rem X...X...X
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp4 = temp4 + 32 : temp3 = temp3 + 1
   if temp4 >= missile0x && temp4 <= temp5 then _end_collision_check 
   temp3 = temp3 + 1

_end_collision_check
   temp4 = ( temp3 * 5 ) + temp1
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
   enemies_shoot_down = enemies_shoot_down + 1
   if _Bit6_map_PF_collision{6} then temp6 = _Bonus_Points_10000 : gosub add_scores : goto set_game_state_boss_explosion
   if enemies_shoot_down = 5 && NewCOLUP1[temp1] = _CI_RedPlane then goto set_game_state_powerup

   temp6 = NewNUSIZ[temp1] & %00001000

   on temp2 goto _del_one_copy _del_two_copies_close _del_two_copies_medium _del_three_copies_close _del_two_copies_wide _del_one_copy _del_three_copies_medium _del_one_copy

_del_one_copy
   NewSpriteY[temp1] = _multisprite_parking_point_bank3[temp1]
   asm
; LDX temp1 ; the bB line before this ASM block has already set x to temp1
	LDA active_multisprites
	AND inverse_bit_shift_table_bank3,x
	STA active_multisprites
end
   goto _determine_collision_score

_del_two_copies_close
   NewNUSIZ[temp1] = 0 | temp6
   if temp3 = 0 then NewSpriteX[temp1] = NewSpriteX[temp1] + 16 : gosub swap_a_b_hits
   goto _determine_collision_score
_del_two_copies_medium
   NewNUSIZ[temp1] = 0 | temp6
   if temp3 = 0 then NewSpriteX[temp1] = NewSpriteX[temp1] + 32 : gosub swap_a_b_hits
   goto _determine_collision_score
_del_three_copies_close
   if temp3 = 1 then NewNUSIZ[temp1] = 2 | temp6 : goto _swap_b_c_hits
   NewNUSIZ[temp1] = 1 | temp6
   if temp3 = 0 then NewSpriteX[temp1] = NewSpriteX[temp1] + 16 : gosub swap_a_b_hits : goto _swap_b_c_hits
   goto _determine_collision_score
_del_two_copies_wide 
   NewNUSIZ[temp1] = 0 | temp6
   if temp3 = 0 then NewSpriteX[temp1] = NewSpriteX[temp1] + 64 : gosub swap_a_b_hits
   goto _determine_collision_score
_del_three_copies_medium
   if temp3 = 1 then NewNUSIZ[temp1] = 4 | temp6 : goto _swap_b_c_hits
   NewNUSIZ[temp1] = 2 | temp6
   if temp3 = 0 then NewSpriteX[temp1] = NewSpriteX[temp1] + 32 : gosub swap_a_b_hits : goto _swap_b_c_hits
   goto _determine_collision_score   

_swap_b_c_hits
   w_playerhits_b[temp1] = r_playerhits_c[temp1]

_determine_collision_score
   temp6 = playertype[temp1]
   if temp6 > %111111 then _end_collision
   if temp6 < planeMiddleD then temp6 = _Bonus_Points_50 : goto _add_collision_score
   if temp6 < planeBigD then temp6 = _Bonus_Points_500 else temp6 = _Bonus_Points_1500
_add_collision_score
   gosub add_scores

_end_collision
   missile0y = 0

_bank_3_code_end
   goto _Play_In_Game_Music bank6


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Side Figther collision"

check_sidefighter_collision
  ; basically the same code as for the missile0 detection

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

   if temp3{0} then temp1 = player1y + 11 : temp2 = player1y - player1height : if player0y > temp2 && player0y <= temp1 then temp1 = 0 : goto multi_collision_check_sf
   
   if temp3{1} then temp1 = player2y + 11 : temp2 = player2y - player2height : if player0y > temp2 && player0y <= temp1 then temp1 = 1 : goto multi_collision_check_sf
   
   if temp3{2} then temp1 = player3y + 11 : temp2 = player3y - player3height : if player0y > temp2 && player0y <= temp1 then temp1 = 2 : goto multi_collision_check_sf

   if temp3{3} then temp1 = player4y + 11 : temp2 = player4y - player4height : if player0y > temp2 && player0y <= temp1 then temp1 = 3 : goto multi_collision_check_sf
 
   temp1 = 4

multi_collision_check_sf
   if playertype[temp1] = typePowerUp then goto power_up_bonus
   if !r_NUSIZ0{0} || _Bit6_map_PF_collision{6} then goto _player0_collision

   temp2 = NewNUSIZ[temp1] & %00000111
   temp4 = NewSpriteX[temp1]
   temp5 = (r_NUSIZ0 * 16) + player0x + 8
   temp3 = 0
   on temp2 goto _end_collision_check_sf _two_copies_close_sf _two_copies_medium_sf _three_copies_close_sf _two_copies_wide_sf _one_copy_double_width_sf _three_copies_medium_sf _one_copy_quad_width_sf

_one_copy_double_width_sf
   temp6 = temp4 + 8
   goto _end_collision_check_right_set_sf
_one_copy_quad_width_sf
   temp6 = temp4 + 24
   goto _end_collision_check_right_set_sf
_two_copies_close_sf
   rem X.X
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 16 : temp3 = temp3 + 1
   goto _end_collision_check_sf
_two_copies_medium_sf
   rem X...X
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 32 : temp3 = temp3 + 1
   goto _end_collision_check_sf
_three_copies_close_sf
   rem X.X.X
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 16 : temp3 = temp3 + 1
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 16 : temp3 = temp3 + 1
   goto _end_collision_check_sf
_two_copies_wide_sf
   rem X.......X
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 64 : temp3 = temp3 + 1
   goto _end_collision_check_sf
_three_copies_medium_sf
   rem X...X...X
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 32 : temp3 = temp3 + 1
   if temp4 >= player0x && temp4 <= temp5 then _end_collision_check_sf 
   temp4 = temp4 + 32 : temp3 = temp3 + 1

_end_collision_check_sf
   temp6 = temp4
_end_collision_check_right_set_sf

   ; temp1 = id of player1 that has been hit (0 - 4)
   ; temp2 = NUSIZ of the player1
   ; temp3 = NUSIZ copy thats been hit (0 - 2)
   ; temp4 = x pos of player1 hit (+8 to player0)
   ; temp6 = right side of player1 hit
   ; no need for hitcounter, an enemy hit by a side fighter will always be deleted.

   if !r_Bit7_Left_Plane_is_SF{7} then _only_right_side_fighter

   temp5 = player0x + 16
   if player0x + 32 < temp4 then temp5 = %11110000 : goto _remove_a_side_fighter             ; right SF
   if temp5 > temp6 then player0x = temp5 : temp5 = %01110000 : goto _remove_a_side_fighter  ; left SF
   goto _player0_collision
_only_right_side_fighter
   if temp5 < temp4 then temp5 = %01110000 : goto _remove_a_side_fighter                     ; right SF


_player0_collision
   _Ch0_Sound = _Sfx_Player_Explosion : _Ch0_Duration = 1
   _Ch0_Counter = 0 : animation_state = 0 : missile0y = 0
   _Bit6_p0_explosion{6} = 1
   goto _bank_3_code_end

_remove_a_side_fighter
   temp6 = (r_NUSIZ0 & %00001111 ) / 2
   w_NUSIZ0 = (r_NUSIZ0 & temp5 ) | temp6
   goto _enemy_explosion

;#endregion

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
   return thisbank

swap_a_b_hits
   w_playerhits_a[temp1] = r_playerhits_b[temp1]
   return thisbank

set_game_state_powerup
   COLUP5 = _bonus_list[r_stage_bonus_counter] : NewCOLUP1[temp1] = _bonus_list[r_stage_bonus_counter]
   NewNUSIZ[temp1] = 0
   playerpointerlo[temp1] = _Power_Up_low
   playerpointerhi[temp1] = _Power_Up_high
   player1height[temp1] = _Power_Up_height : player1fullheight[temp1] = _Power_Up_height
   ; Workaround set all (none typeMissile ) msps to typePowerUp, 
   ; so if collision detection fails (somehow?) the PowerUp won't be lethal!
   ; player1type = typePowerUp : player2type = typePowerUp : player3type = typePowerUp : player4type = typePowerUp : player5type = typePowerUp
   player1type = ( player1type & %10000000 ) | typePowerUp
   player2type = ( player2type & %10000000 ) | typePowerUp
   player3type = ( player3type & %10000000 ) | typePowerUp
   player4type = ( player4type & %10000000 ) | typePowerUp
   player5type = ( player5type & %10000000 ) | typePowerUp


   goto _determine_collision_score

power_up_bonus
   if COLUP5 = _Power_Up_Black_Extra_Life && lives < 224 then lives = lives + 32 : goto _end_power_up_bonus
   if COLUP5 = _Power_Up_Yellow_Extra_Loop && statusbarlength < 170 then statusbarlength = ( statusbarlength / 4 ) + %10000000 : goto _end_power_up_bonus
   if COLUP5 = _Power_Up_Dark_Gray_Quad_Gun && !r_NUSIZ0{5} then w_NUSIZ0 = r_NUSIZ0 | %00100000 : goto _end_power_up_bonus
   if COLUP5 = _Power_Up_Light_Gray_Side_Fighters && !r_NUSIZ0{1} then goto switch_on_side_fighters
   if COLUP5 = _Power_Up_White_Enemy_Crash then goto switch_on_invincible_mode
   ; default bonus 1000 points
   temp6 = _Bonus_Points_1000 : gosub add_scores

_end_power_up_bonus
   _Ch0_Sound = _Sfx_Power_Up : _Ch0_Duration = 1 : _Ch0_Counter = 0
_end_power_up_bonus_no_sound
   NewSpriteY[temp1] = _multisprite_parking_point_bank3[temp1]
   active_multisprites = 0
   goto _bank_3_code_end 

switch_on_invincible_mode
   _Ch0_Duration = 1 : _Ch0_Counter = 0 : _Ch0_Sound = _Sfx_Respawn_Bass
   _Ch1_Read_Pos_Lo = _SD_Respawn_Music01_begin_low
   _Ch1_Read_Pos_Hi = _SD_Respawn_Music01_begin_high
   goto _end_power_up_bonus_no_sound

switch_on_side_fighters 
   w_NUSIZ0 = r_NUSIZ0 | %10000011
   if player0x > 16 then player0x = player0x - 16 else player0x = 0
   if player0x > _Player0_X_Max_2SF then player0x = _Player0_X_Max_2SF
   goto _end_power_up_bonus

set_game_state_boss_explosion
   w_msp1_animation_state = 0 : w_msp3_animation_state = 0 : w_msp3_animation_state = 0 : w_msp4_animation_state = 0
   map_section = _Map_Boss_expl : active_multisprites = %00001111
   player1height = 10 : player2height = 10 : player3height = 10 : player4height = 10
   player1x = 52 : player2x = 80 : player3x = 80 : player4x = 84
   _NUSIZ1 = 6
   NUSIZ2 = 5 : NUSIZ3 = 5 : NUSIZ4 = 0

   player1y = 174 - PF1pointer
   player2y = 150 - PF1pointer
   player3y = 162 - PF1pointer
   player4y = 185 - PF1pointer
   player5y = _Player5_Parking_Point

   player1pointerhi = _Player0_Explosion_0_high : player2pointerhi = _Player0_Explosion_0_high : player3pointerhi = _Player0_Explosion_0_high : player4pointerhi = _Player0_Explosion_0_high
   player1pointerlo = _Player0_Explosion_0_low : player2pointerlo = _Player0_Explosion_0_low : player3pointerlo = _Player0_Explosion_0_low : player4pointerlo = _Player0_Explosion_0_low

   player1type = typeMspExpl : player2type = typeMspExpl : player3type = typeMspExpl : player4type = typeMspExpl : player5type = typeMspExpl

   goto __Victory_Music_Setup_01 bank6

set_game_state_landing_0_after_boss
   PF1pointerhi = _PF1_Carrier_Boss_high : PF2pointerhi = _PF2_Carrier_Boss_high
   PF1pointer = _Map_Landingzone_Start : PF2pointer = _Map_Landingzone_Start
   map_section = _Map_Landing_w
   w_COLUPF = _Color_Carrier : pfheight = 3
   stage = stage - 1
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
   %00000001, %00000010, %00000100, %00001000, %00010000, %00100000
end

   data inverse_bit_shift_table_bank3
   %11111110, %11111101, %11111011, %11110111, %11101111, %11011111
end

   data _multisprite_parking_point_bank3
   _Player1_Parking_Point
   _Player2_Parking_Point
   _Player3_Parking_Point
   _Player4_Parking_Point
   _Player5_Parking_Point
end

   data _bonus_list
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 32
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 31
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 30
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 29
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 28
   _Power_Up_Orange_No_Enemy_Bullets,  _Power_Up_Black_Extra_Life ; Stage 27
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 26
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 25
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 24
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 23
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 22
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 21
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Black_Extra_Life ; Stage 20
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 19
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 18
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 17
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 16
   _Power_Up_Orange_No_Enemy_Bullets,  _Power_Up_Black_Extra_Life ; Stage 15
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 14
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 13
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Red_1000_Points  ; Stage 12
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 11
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 10
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 09
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Black_Extra_Life ; Stage 08
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 07
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 06
   _Power_Up_Yellow_Extra_Loop,        _Power_Up_Red_1000_Points  ; Stage 05
   _Power_Up_Dark_Gray_Quad_Gun,       _Power_Up_Black_Extra_Life ; Stage 04
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 03
   _Power_Up_Light_Gray_Side_Fighters, _Power_Up_Red_1000_Points  ; Stage 02
   _Power_Up_White_Enemy_Crash,        _Power_Up_Red_1000_Points  ; Stage 01
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



TEXT=$80   ; 24
BUFF1=$98  ; 42
RESETR=$CA ;  1
CYCLE=$CB  ;  1
TEMP=$CC   ;  1
LOOP=$CD   ;  1
TPTR0=$CE  ;  2
TPTR1=$CF  ;  2
BUFF2=$D0  ; 42


RAM_Messages=r000

ROM_Messages
Message0
  DC.B  __, __, __, __, __, __, __, __, __, __, _1, _9, _4, _2, __, __, __, __, __, __, __, __, __, __
Message1
  DC.B  __, __, _T, _O, _P, __, _5, __, _R, _A, _N, _K, _I, _N, _G, __, _S, _C, _O, _R, _E, __, __, __
Message2
  DC.B  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __
Message3
  DC.B  __, __, __, __, __, __, __, __, _G, _A, _M, _E, __, _O, _V, _E, _R, __, __, __, __, __, __, __

  ; The rows below are not accessible on SC-RAM/ROM mixed Screens
Message4
  DC.B  __, __, __, __, __, __, __, _W, _E, __, _G, _I, _V, _E, __, _U, _P, __, __, __, __, __, __, __
Message5
  DC.B  __, __, __, __, __, __, _S, _P, _E, _C, _I, _A, _L, __, _B, _O, _N, _U, _S, __, __, __, __, __
Message6
  DC.B  __, __, __, __, __, _1, _0, _COMMA, _0, _0, _0, _COMMA, _0, _0, _0, __, _P, _T, _S, __, __, __, __, __
Message7
  DC.B  __, __, __, __, __, _P, _R, _E, _S, _E, _N, _T, _E, _D, __, _B, _Y, __, _N, _N, __, __, __, __

EndMessages
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "HSC Text Screen"

   ;batariBasic entry point to asm bank
_bB_HSC_entry_bank4
   asm


  lda #_0E   ; text color first row
  ldx #_00   ; background color
  jsr _Prepare_Text_Screen

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
  
  ; Set Pointer for First Message
  lda #48
  jsr LoadTextROM
  
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
   STA	w000,x		         ; 5   
   INX					         ; 2   
   LDA	ReceiveBufferSize		; 4
   BNE	.copy_loop			   ; 2/3 
end

_skip_copy_response_to_SC_RAM
   ; we don't need RESETR here, because HSC table is 
   ; accessed via joy0left.
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
OffsetHSC
  DC.B  176, 176, 96, 72, 48, 24, 0, 176, 152, 128
FontColorsHSC
  DC.B  _0E, _0E, _EA, _EA, _EA, _EA, _EA, _0E, _44, _D4, _0E

OffsetEndscreen
  DC.B  48, 48, 168, 72, 48, 144, 120, 48, 96, 48
FontColorsEndscreen
  DC.B  _0E, _08, _8A, _44, _0E, _58, _EA, _0E, _44, _0E, _0E

OffsetGameOver
  DC.B  176, 176, 176, 200, 176, 176, 48, 24, 176, 176
FontColorsGameOver
  DC.B  _0E, _0E, _0E, _44, _0E, _0E, _0E, _0E, _0E, _0E, _0E


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

  lda #_0E   ; text color first row
  ldx #_00   ; background color
  jsr _Prepare_Text_Screen

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

   if !RESETR then _check_resetr_Endscreen
   if joy0right || joy0fire then goto restart_bB bank8

_check_resetr_Endscreen
   if !joy0right && !joy0fire then RESETR = 1

   asm
  ; Finish Overscan
WaitOverscanEndscreenEnd
  lda INTIM
  bne WaitOverscanEndscreenEnd
  
  ; Loop To Beginning
  jmp MainEndscreenLoop

;#endregion



_Prepare_Text_Screen

  ; Set P0/P1 Colours
  sta COLUP0
  sta COLUP1

  ; Set Background
  stx COLUBK

  ; Set 3 sprite copies
  lda #%00000110
  sta NUSIZ0
  sta NUSIZ1

  ; Delay P0 & P1
  lda #%00000001
  sta VDELP0
  sta VDELP1
  

  ; Reflect PF
  lda #1
  sta CTRLPF
  
  lda #_00
  sta COLUPF
  sta PF1
  sta PF2
  lda #$30
  sta PF0
  rts

  ; Include Font Data
  INCLUDE "font.h"
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region rem "Game Over Text Screen"

   ;batariBasic entry point to asm code
_bB_Game_Over_entry_bank4

   asm
  lda #_0E   ; text color first row
  ldx #_Color_Ocean   ; background color
  jsr _Prepare_Text_Screen

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
  jsr LoadText

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

   if !RESETR then _check_resetr_GameOver
   if joy0right || joy0fire then goto restart_bB bank8

_check_resetr_GameOver
   if !joy0right && !joy0fire then RESETR = 1

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 5 prepare SC-RAM for textscreens"

_prepare_HSC_bank5
  asm
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
  lda loading_message-1,x
  sta w033-1,x
  DEX
  bne loading_msg_copy_loop
end
   goto _bB_HSC_entry_bank4 bank4

_prepare_Game_Over_bank5
  asm
  ; right reset restrainer
  lda #0
  sta $CA   

  ; Load Score to first SC-RAM line 
  lda #__
  sta w000
  sta w001

  ldx #5
  jsr _Copy_Score_To_SC_RAM
  
  ; fill two lines of SC-RAM text with space
  lda #__
  ldx #48
clear_zp_ram_loop_game_over
  sta w024-1,x
  DEX
  bne clear_zp_ram_loop_game_over

  ; copy stage as BCD to first SC-RAM text line 
  ldx stage
  lda hex_to_bcd_bank5,x
  sta temp4

_Copy_Stage_To_SC_RAM
  clc
  and #%00001111
  adc #54
  rol
  rol
  sta w046
  lda temp4
  and #%11110000
  lsr
  lsr
  adc #216
  sta w045

  lda #_S
  sta w026
  lda #_T
  sta w027
  lda #_A
  sta w028
  lda #_G
  sta w029
  lda #_E
  sta w030


_Copy_Shooting_Down_To_SC_RAM
  lda r_total_enemies_BCD1
  clc
  and #%00001111
  adc #54
  rol
  rol
  sta w070
  lda r_total_enemies_BCD1
  and #%11110000
  lsr
  lsr
  adc #216
  sta w069

  lda r_total_enemies_BCD
  beq .skip_hundred
  clc
  and #%00001111
  adc #54
  rol
  rol
  sta w068
  lda r_total_enemies_BCD
  and #%11110000
  lsr
  lsr
  adc #216
  sta w067
.skip_hundred

  lda #_S
  sta w050
  lda #_H
  sta w051
  lda #_O
  sta w052
  lda #_O
  sta w053
  lda #_T
  sta w054
  lda #_I
  sta w055
  lda #_N
  sta w056
  lda #_G
  sta w057
  lda #_D
  sta w059
  lda #_O
  sta w060
  lda #_W
  sta w061
  lda #_N
  sta w062
end
   goto _bB_Game_Over_entry_bank4 bank4

_prepare_Endscreen_bank5
  WriteToBuffer = $10
  WriteToBuffer = _sc1
  WriteToBuffer = _sc2
  WriteToBuffer = _sc3
  WriteToBuffer = stage
  WriteSendBuffer = HighScoreDB_ID
  AUDV0 = 0 : AUDV1 = 0
  asm
  ; right reset restrainer
  lda #0
  sta $CA   
  ; Load Score + Bonus to first SC-RAM line
  lda #_1
  sta w000
  lda #_0
  sta w001

  ldx #5
  jsr _Copy_Score_To_SC_RAM
end
   goto _bB_Endscreen_entry_bank4 bank4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Subroutine and data bank 5"
  asm
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
end

   data hex_to_bcd_bank5
   $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $11, $12, $13, $14, $15
   $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31
   $32
end

   data loading_message
   _L, _o, _a, _d, _i, _n, _g
end

;#endregion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Playfield Pacific"
; bB playfield definition can be anywhere.
; We are setting and changing the PF pointer manually in the game loop.
; So the code generated here (16 bytes) don't needs to be execute.

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
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
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
   .............XXX  ; 
   .............XXX  ; 
   .............XXX  ; 
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
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
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
   .......XXXXX....  ; 
   .........XXX....  ; 
   ..........X.....  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ............XX..  ; 
   ...........XXX..  ; 
   ...........XXXX.  ; 
   ...........XXXX.  ; 
   ............XX..  ; 
   .............XX.  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
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
   .............XXX  ; 
   .............XXX  ; 
   .............XXX  ; 
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
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 0 Start of second landscape
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 214 End landscape 1  
   .....XX.........  ; 
   .....XXX........  ; 
   .....XXXX.......  ; 
   ....XXXXXX......  ; 
   ....XXXXX.......  ; 
   ....XXXX........  ; 
   .....XXX........  ; 
   ......XX........  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
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
   ...XXXX.........  ; 
   ..XXXXXXXXXXXX..  ; 
   .XXXXXXXXXXXXXX.  ; 
   XXXXXXXXXXXXXXXX  ; 
   XXXXXXXXXXXXXXXX  ; 
   XXXXXXXXXXXXXXX.  ; 
   XXXXXXXXXXXXXX..  ; 
   XXXXXXXXXXXXXX..  ; 
   XXXXXXXXXXXXXX..  ; 
   XXXXXXXXXXXXXXX.  ; 
   XXXXXXXXXXXXXXX.  ; 
   XXXXXXXXXXXXXXXX  ; 
   .XXXXXXXXXXXXXXX  ; 
   ..XXXXXXXXXXXXXX  ; 
   ....XXXXX.XXXXXX  ; 
   ...........XXXXX  ; 
   ..............XX  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 
   ................  ; 0 Start of first landscape
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

;#endregion

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
   DC.B <_SD_Victory_Bass      ; _Sfx_Victory_Bass
   DC.B <_SD_Victory_Bass_1    ; _Sfx_Victory_Bass_1
   DC.B <_SD_Boss_Entry_Bass   ; _Sfx_Boss_Entry_Bass
   DC.B <_SD_Boss_Entry_Bass   ; _Sfx_Boss_Entry_Bass_1
   DC.B <_SD_Boss_Entry_Bass   ; _Sfx_Boss_Entry_Bass_2
   DC.B <_SD_Boss_Entry_Bass   ; _Sfx_Boss_Entry_Bass_3
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
   DC.B >_SD_Victory_Bass
   DC.B >_SD_Victory_Bass_1
   DC.B >_SD_Boss_Entry_Bass
   DC.B >_SD_Boss_Entry_Bass
   DC.B >_SD_Boss_Entry_Bass
   DC.B >_SD_Boss_Entry_Bass

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
   DC.B _Sfx_Victory_Bass_1    ; _Sfx_Victory_Bass
   DC.B _Sfx_Landing           ; _Sfx_Victory_Bass_1
   DC.B _Sfx_Boss_Entry_Bass_1 ; _Sfx_Boss_Entry_Bass
   DC.B _Sfx_Boss_Entry_Bass_2 ; _Sfx_Boss_Entry_Bass_1
   DC.B _Sfx_Boss_Entry_Bass_3 ; _Sfx_Boss_Entry_Bass_2
   DC.B _Sfx_Mute              ; _Sfx_Boss_Entry_Bass_3

_end_sfx
   sta AUDV0 ; silence channel 0
end
   goto __Skip_Ch_0

_play_game_over_music

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
   if !switchleftb && _Ch0_Sound < _Sfx_Respawn_Bass then goto __Mute_Ch_1

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
   temp4 = sread(_Ch1_Read_Pos_Lo)

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   ; TODO: boss entry should repeat 3x (can check _Ch0_Sound which will automatically go from _Sfx_Boss_Entry_Bass progressively to _Sfx_Boss_Entry_Bass_3) then go to boss BG; boss BG should repeat; maybe can check _Ch1_Read_Pos_Lo, but checking game state might be easier
   if temp4 <> 255 then __Ch1_Get_Note
   if PF1pointerhi <> _PF1_Carrier_Boss_high then goto __BG_Music_Setup_01
   if map_section <> _Map_Landing_w then goto __Boss_BG_Music_Setup
 
   map_section = _Map_Landing
   _Bit3_mute_bg_music{3} = 1
   framecounter = 0 : missile0y = 0 : _Ch0_Counter = 0
   _Ch0_Sound = _Sfx_Landing : _Ch0_Duration = 1
   
   goto __BG_Music_Setup_01



  

   

__Ch1_Get_Note
   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;  Plays channel 1.
   ;
   asm
   ; read note index (similar to bB-generated code for sread) then translate
   ; that to AUDC and AUDF values
   ldx #_Ch1_Read_Pos_Lo
   lda (0,x)
   inc _Ch1_Read_Pos_Lo
   bne __Ch1_Translate_Note
   inc _Ch1_Read_Pos_Lo+1
__Ch1_Translate_Note
   tax
   lda temp4
   sta AUDV1
   lda _Note_Index_to_AUDC,X
   sta AUDC1
   lda _Note_Index_to_AUDF,X
   sta AUDF1
end

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = sread(_Ch1_Read_Pos_Lo)



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

  rem TODO: use this
  data _SD_Level_Complete
  $F,$4,$04,2
  $7,$4,$04,2
  $3,$4,$04,4
  $2,$4,$04,6
  $1,$4,$04,14
  $FF
end

  rem TODO: use this
  data _SD_Bonus_Typewriter
  $4,$3,$6,1
  $1,$3,$6,1
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

  data _SD_Victory_Bass
  $8,$6,$0B, 2
  $3,$6,$0B, 6
  $2,$6,$0B,16
  $8,$6,$0B, 2
  $3,$6,$0B, 6
  $8,$6,$0B, 2
  $3,$6,$0B, 6
  $8,$6,$0B, 2
  $3,$6,$0B, 6

  $8,$6,$0B, 2
  $3,$6,$0B, 6
  $2,$6,$0B,16
  $8,$6,$0B, 2
  $3,$6,$0B, 6
  $3,$1,$13, 2
  $1,$1,$13, 6
  $8,$6,$07, 2
  $3,$6,$07, 6

  $4,$1,$1D, 2
  $2,$1,$1D, 6
  $1,$1,$1D,16
  $4,$1,$1D, 2
  $2,$1,$1D, 6
  $8,$6,$0B, 2
  $3,$6,$0B, 6
  $3,$1,$13, 2
  $1,$1,$13, 6

  $4,$1,$15, 2
  $2,$1,$15, 6
  $1,$1,$15,16
  $4,$1,$15, 2
  $2,$1,$15, 6
  $4,$1,$15, 2
  $2,$1,$15, 6
  $3,$1,$13, 2
  $1,$1,$13, 6

  $8,$6,$08, 2
  $3,$6,$08, 6
  $2,$6,$08,16
  $8,$6,$08, 2
  $3,$6,$08, 6
  $8,$6,$08, 2
  $3,$6,$08, 6
  $8,$6,$08, 2
  $3,$6,$08, 6

  $8,$6,$0F, 2
  $3,$6,$0F, 6
  $2,$6,$0F,16
  $8,$6,$0F, 2
  $3,$6,$0F, 6
  $8,$6,$0C, 2
  $3,$6,$0C, 6
  $4,$1,$15, 2
  $2,$1,$15, 6

  $FF
end

  data _SD_Boss_Entry_Bass
  $8,$C,$16,2
  $1,$C,$16,7
  $8,$C,$16,2
  $1,$C,$16,7
  $8,$C,$14,2
  $1,$C,$14,7
  $8,$C,$13,2
  $1,$C,$13,7
  $8,$C,$12,2
  $1,$C,$12,7
  $8,$C,$11,2
  $1,$C,$11,7
  $FF
end

  data _SD_Victory_Bass_1
  $8,$6,$09, 2
  $3,$6,$09, 6
  $2,$6,$09,16
  $3,$2,$00, 2
  $2,$2,$00, 4
  $1,$2,$00,18

  $8,$6,$07, 2
  $3,$6,$07, 6
  $2,$6,$07,16
  $3,$1,$0D, 2
  $1,$1,$0D, 6
  $3,$1,$0D, 2
  $1,$1,$0D, 6
  $3,$1,$0D, 2
  $1,$1,$0D, 6

  $8,$6,$08, 2
  $3,$6,$08, 6
  $2,$6,$08,16
  $4,$1,$13, 2
  $2,$1,$13, 6
  $1,$1,$13,16

  $8,$6,$07, 2
  $3,$6,$07, 6
  $2,$6,$07,40

  $FF
end

__Respawn_Music_Setup
  sdata _SD_Respawn_Music01 = _Ch1_Read_Pos_Lo
  $C,NOTE_418, 2
  $9,NOTE_418, 4
  $5,NOTE_418, 6
  $3,NOTE_418, 8
  $1,NOTE_418,10
  $0,NOTE_000,20
  $C,NOTE_418, 2
  $9,NOTE_418, 4
  $5,NOTE_418, 4
  $C,NOTE_418, 2
  $9,NOTE_418, 4
  $5,NOTE_418, 4
  $C,NOTE_418, 2
  $9,NOTE_418, 4
  $5,NOTE_418, 4

  $C,NOTE_417, 2
  $9,NOTE_417, 3
  $5,NOTE_417, 4
  $3,NOTE_417, 5
  $1,NOTE_417, 8
  $0,NOTE_000, 8
  $C,NOTE_418, 2
  $9,NOTE_418, 3
  $5,NOTE_418, 4
  $3,NOTE_418, 5
  $1,NOTE_418, 8
  $0,NOTE_000,28

  $C,NOTE_413, 2
  $9,NOTE_413, 3
  $5,NOTE_413, 4
  $3,NOTE_413, 5
  $1,NOTE_413, 8
  $0,NOTE_000, 8
  $C,NOTE_414, 2
  $9,NOTE_414, 3
  $5,NOTE_414, 4
  $3,NOTE_414, 5
  $1,NOTE_414, 8
  $0,NOTE_000, 8
  $9,NOTE_410, 2
  $6,NOTE_410, 3
  $3,NOTE_410, 4
  $2,NOTE_410, 5
  $1,NOTE_410, 6

  $C,NOTE_40D, 2
  $9,NOTE_40D, 3
  $6,NOTE_40D, 4
  $3,NOTE_40D,71

  255
end
   rem handle bass line as sfx for simplicity
   _Ch0_Duration = 1 : _Ch0_Counter = 0 : _Ch0_Sound = _Sfx_Respawn_Bass
   _Ch1_Duration = 1
   goto _Play_In_Game_Music

__Game_Over_Music_Setup_01

  sdata _SD_Game_Over_Music01 = _Ch1_Read_Pos_Lo
  $C,NOTE_C0C, 2
  $6,NOTE_C0C, 4
  $2,NOTE_C0C,12
  $C,NOTE_C0C, 2
  $6,NOTE_C0C, 4
  $C,NOTE_41E, 2
  $6,NOTE_41E, 4
  $2,NOTE_41E, 8
  $1,NOTE_41E,22
  $8,NOTE_C0A, 2
  $2,NOTE_C0A,10
  $8,NOTE_C0B, 2
  $2,NOTE_C0B,10
  $5,NOTE_104, 2
  $1,NOTE_104,10

  $C,NOTE_C0C, 2
  $6,NOTE_C0C, 4
  $2,NOTE_C0C,12
  $C,NOTE_C0C, 2
  $6,NOTE_C0C, 4
  $C,NOTE_41E, 2
  $6,NOTE_41E, 4
  $2,NOTE_41E, 8
  $1,NOTE_41E,22
  $8,NOTE_C0A, 2
  $2,NOTE_C0A,10
  $8,NOTE_C0B, 2
  $2,NOTE_C0B,10
  $5,NOTE_104, 2
  $1,NOTE_104,10

  $0,NOTE_000, 8
  $8,NOTE_41E, 2
  $2,NOTE_41E, 6
  $8,NOTE_41E, 2
  $2,NOTE_41E, 6
  $0,NOTE_000, 8
  $8,NOTE_41C, 2
  $2,NOTE_41C, 6
  $8,NOTE_41C, 2
  $2,NOTE_41C, 6
  $0,NOTE_000, 8
  $8,NOTE_418, 2
  $2,NOTE_418, 6
  $8,NOTE_418, 2
  $2,NOTE_418, 6
  $0,NOTE_000, 8
  $8,NOTE_416, 2
  $2,NOTE_416, 6
  $8,NOTE_416, 2
  $2,NOTE_416, 6

  $8,NOTE_418, 2
  $4,NOTE_418, 4
  $2,NOTE_418, 8
  $1,NOTE_418,82

  $8,NOTE_419, 2
  $4,NOTE_419, 4
  $2,NOTE_419, 8
  $1,NOTE_419,82
  255
end
   rem handle bass line as sfx for simplicity
   _Ch0_Duration = 1 : _Ch0_Counter = 0 : _Ch0_Sound = _Sfx_Game_Over_Bass
   _Ch1_Duration = 1
   goto _prepare_Game_Over_bank5 bank5

  rem TODO: use this, update goto target if necessary
__Boss_Entry_Music_Setup
  rem unlike other music with channel-0 bass part, caller must set _Ch0_Sound,
  rem  _Ch0_Duration, and _Ch0_Counter, since this must be called multiple
  rem times, each corresponding to a different ch0 state
  rem last note is 1 frame short: sfx player (used for bass line) starts next
  rem sound immediately, music player (used for this) does not
  sdata _SD_Boss_Entry_Music01 = _Ch1_Read_Pos_Lo
  $C,NOTE_C0C,2
  $2,NOTE_C0C,7
  $C,NOTE_413,2
  $2,NOTE_413,7
  $C,NOTE_412,2
  $2,NOTE_412,7
  $C,NOTE_411,2
  $2,NOTE_411,7
  $C,NOTE_410,2
  $2,NOTE_410,7
  $C,NOTE_40F,2
  $2,NOTE_40F,6
  $FF
end
   _Ch1_Duration = 1
   goto _Play_In_Game_Music

__Boss_BG_Music_Setup
  sdata _SD_Boss_BG_Music01 = _Ch1_Read_Pos_Lo
  $C,NOTE_C1D, 2
  $5,NOTE_C1D, 6
  $3,NOTE_C1D,18
  $2,NOTE_C1D,10
  $C,NOTE_C1D, 2
  $3,NOTE_C1D,25
  $A,NOTE_C1F, 2
  $3,NOTE_C1F, 7

  $C,NOTE_C1D, 2
  $5,NOTE_C1D,61
  $C,NOTE_C1A, 2
  $3,NOTE_C1A, 7

  $C,NOTE_C1F, 2
  $4,NOTE_C1F, 6
  $2,NOTE_C1F,64

  $5,NOTE_706, 2
  $1,NOTE_706, 7
  $3,NOTE_200, 2
  $1,NOTE_200, 7
  $3,NOTE_10F, 2
  $1,NOTE_10F, 7
  $3,NOTE_110, 2
  $1,NOTE_110, 7
  $5,NOTE_706, 2
  $1,NOTE_706, 7
  $3,NOTE_200, 2
  $1,NOTE_200, 7
  $3,NOTE_10F, 2
  $1,NOTE_10F, 7
  $3,NOTE_110, 2
  $1,NOTE_110, 7

  $C,NOTE_604, 2
  $5,NOTE_604, 6
  $3,NOTE_604,18
  $2,NOTE_604,10
  $C,NOTE_604, 2
  $3,NOTE_604,25
  $C,NOTE_C1A, 2
  $3,NOTE_C1A, 7

  $C,NOTE_604, 2
  $5,NOTE_604,61
  $C,NOTE_C16, 2
  $3,NOTE_C16, 7

  $C,NOTE_C1A, 2
  $4,NOTE_C1A, 6
  $2,NOTE_C1A,64

  $A,NOTE_C1B, 2
  $3,NOTE_C1B, 7
  $3,NOTE_10B, 2
  $1,NOTE_10B, 7
  $3,NOTE_10C, 2
  $1,NOTE_10C, 7
  $3,NOTE_10D, 2
  $1,NOTE_10D, 7
  $A,NOTE_C1B, 2
  $3,NOTE_C1B, 7
  $3,NOTE_10B, 2
  $1,NOTE_10B, 7
  $3,NOTE_10C, 2
  $1,NOTE_10C, 7
  $3,NOTE_10D, 2
  $1,NOTE_10D, 7

  $FF
end
   _Ch1_Duration = 1

   goto __Skip_Ch_1

  rem TODO: use this, update goto target if necessary
__Victory_Music_Setup_01

  rem TODO (Pat Brady) try to do the $C:$0B then $C:$0A oscillation within single frame
  sdata _SD_Victory_Music01 = _Ch1_Read_Pos_Lo
  $C,NOTE_603, 2
  $3,NOTE_603, 6
  $A,NOTE_C12, 2
  $3,NOTE_C12, 6
  $A,NOTE_603, 2
  $3,NOTE_603, 6
  $C,NOTE_603, 2
  $3,NOTE_603, 6
  $1,NOTE_603,10
  $C,NOTE_603, 2
  $3,NOTE_603, 4

  $C,NOTE_602, 2
  $5,NOTE_602, 6
  $3,NOTE_602,18
  $2,NOTE_602,46

  $C,NOTE_602, 2
  $3,NOTE_602, 6
  $A,NOTE_C0D, 2
  $3,NOTE_C0D, 6
  $3,NOTE_104, 2
  $1,NOTE_104, 6

  $C,NOTE_C0B, 2
  $3,NOTE_C0A, 1
  $3,NOTE_C0B, 2
  $2,NOTE_C0A, 1
  $2,NOTE_C0B, 2
  $2,NOTE_C0A, 1
  $2,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $4,NOTE_104, 2
  $1,NOTE_104,22

  $C,NOTE_C0B, 2
  $3,NOTE_C0A, 1
  $3,NOTE_C0B, 2
  $2,NOTE_C0A, 1
  $2,NOTE_C0B, 2
  $2,NOTE_C0A, 1
  $2,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $1,NOTE_C0B, 2
  $1,NOTE_C0A, 1
  $C,NOTE_41B, 2
  $3,NOTE_41B, 6
  $2,NOTE_41B,16

  $C,NOTE_41E, 2
  $3,NOTE_41E, 6
  $2,NOTE_41E,18
  $1,NOTE_41E,22

  $C,NOTE_41E, 2
  $3,NOTE_41E, 6
  $A,NOTE_C0B, 2
  $3,NOTE_C0B, 6
  $3,NOTE_104, 2
  $1,NOTE_104, 6
  $C,NOTE_C0D, 2
  $3,NOTE_C0D, 6
  $3,NOTE_104, 2
  $1,NOTE_104, 6
  $A,NOTE_C0D, 2
  $3,NOTE_C0D, 6

  $C,NOTE_C0C, 2
  $5,NOTE_C0C, 6
  $3,NOTE_C0C,18
  $2,NOTE_C0C,22

  $5,NOTE_104, 2
  $1,NOTE_104, 6
  $A,NOTE_C0B, 2
  $3,NOTE_C0B, 6
  $3,NOTE_104, 2
  $1,NOTE_104, 6
  $C,NOTE_C0D, 2
  $3,NOTE_C0D, 6
  $3,NOTE_104, 2
  $1,NOTE_104, 6
  $A,NOTE_C0D, 2
  $3,NOTE_C0D, 6

  $C,NOTE_602, 2
  $5,NOTE_602, 6
  $3,NOTE_602,18
  $2,NOTE_602,22

  $FF
end
   rem handle bass line as sfx for simplicity
   _Ch0_Duration = 1 : _Ch0_Counter = 0 : _Ch0_Sound = _Sfx_Victory_Bass
   _Ch1_Duration = 1
   goto _Play_In_Game_Music

__BG_Music_Setup_01

  sdata _SD_Music01 = _Ch1_Read_Pos_Lo
  6,NOTE_300,4,  0,NOTE_000,16
  6,NOTE_300,4,  0,NOTE_000,16
  6,NOTE_300,4,  0,NOTE_000,6,  6,NOTE_300,4,  0,NOTE_000,16
                                5,NOTE_300,4,  0,NOTE_000,6
  6,NOTE_300,4,  0,NOTE_000,6,  5,NOTE_300,4,  0,NOTE_000,6
  6,NOTE_300,4,  0,NOTE_000,6,  5,NOTE_300,4,  0,NOTE_000,6
  6,NOTE_300,4,  0,NOTE_000,36

  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,26
                                4,NOTE_804,2,  0,NOTE_000,8
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  5,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5 ; 1 frame slow
  5,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5 ; 1 frame slow
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5 ; 1 frame slow
  5,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5,  4,NOTE_804,2,  0,NOTE_000,5 ; 1 frame slow
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,6,  4,NOTE_804,2,  0,NOTE_000,8
  5,NOTE_804,2,  0,NOTE_000,8,  6,NOTE_300,4,  0,NOTE_000,6
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  4,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,8
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3,  4,NOTE_804,2,  0,NOTE_000,3
  5,NOTE_804,2,  0,NOTE_000,8,  5,NOTE_804,2,  0,NOTE_000,8
  6,NOTE_300,4,  0,NOTE_000,16
  5,NOTE_804,2,  0,NOTE_000,18
  5,NOTE_804,2,  0,NOTE_000,18
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,18
                                4,NOTE_804,2,  0,NOTE_000,8
  5,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,8
  4,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,8
  5,NOTE_804,2,  0,NOTE_000,18
  4,NOTE_804,2,  0,NOTE_000,8,  4,NOTE_804,2,  0,NOTE_000,8
  255
end
   _Ch1_Duration = 1

   goto __Skip_Ch_1

   asm
NUM_NOTES = 44

   ; align to page boundary unless both tables fit on current page anyway
   if [<.]>256-2*NUM_NOTES
   align $100
   endif

_Note_Index_to_AUDC
   .byte $0
   .byte $8
   .byte $1
   .byte $1
   .byte $2
   .byte $7
   .byte $1
   .byte $1
   .byte $C
   .byte $C
   .byte $1
   .byte $C
   .byte $C
   .byte $6
   .byte $C
   .byte $6
   .byte $C
   .byte $6
   .byte $C
   .byte $C
   .byte $1
   .byte $C
   .byte $C
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $3
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   .byte $4
   if .-_Note_Index_to_AUDC != NUM_NOTES
     echo "ERROR: _Note_Index_to_AUDC (", _Note_Index_to_AUDC, ") does not match NUM_NOTES (", NUM_NOTES, ")"
   endif

_Note_Index_to_AUDF
NOTE_000 = .-_Note_Index_to_AUDF
   .byte $00
NOTE_804 = .-_Note_Index_to_AUDF ; snare noise
   .byte $04
NOTE_110 = .-_Note_Index_to_AUDF ; 123.14
   .byte $10
NOTE_10F = .-_Note_Index_to_AUDF ; 130.83
   .byte $0F
NOTE_200 = .-_Note_Index_to_AUDF ; 135.05
   .byte $00
NOTE_706 = .-_Note_Index_to_AUDF ; 144.70
   .byte $06
NOTE_10D = .-_Note_Index_to_AUDF ; 149.52
   .byte $0D
NOTE_10C = .-_Note_Index_to_AUDF ; 161.02
   .byte $0C
NOTE_C1F = .-_Note_Index_to_AUDF ; 163.54
   .byte $1F
NOTE_C1D = .-_Note_Index_to_AUDF ; 174.44
   .byte $1D
NOTE_10B = .-_Note_Index_to_AUDF ; 174.44
   .byte $0B
NOTE_C1B = .-_Note_Index_to_AUDF ; 186.90
   .byte $1B
NOTE_C1A = .-_Note_Index_to_AUDF ; 193.83
   .byte $1A
NOTE_604 = .-_Note_Index_to_AUDF ; 202.58
   .byte $04
NOTE_C16 = .-_Note_Index_to_AUDF ; 227.53
   .byte $16
NOTE_603 = .-_Note_Index_to_AUDF ; 253.22
   .byte $03
NOTE_C12 = .-_Note_Index_to_AUDF ; 275.44
   .byte $12
NOTE_602 = .-_Note_Index_to_AUDF ; 337.63
   .byte $02
NOTE_C0D = .-_Note_Index_to_AUDF ; 373.81
   .byte $0D
NOTE_C0C = .-_Note_Index_to_AUDF ; 402.56
   .byte $0C
NOTE_104 = .-_Note_Index_to_AUDF ; 418.66
   .byte $04
NOTE_C0B = .-_Note_Index_to_AUDF ; 436.11
   .byte $0B
NOTE_C0A = .-_Note_Index_to_AUDF ; 475.75
   .byte $0A
NOTE_41E = .-_Note_Index_to_AUDF ; 506.45
   .byte $1E
NOTE_41C = .-_Note_Index_to_AUDF ; 541.38
   .byte $1C
NOTE_41B = .-_Note_Index_to_AUDF ; 560.71
   .byte $1B
NOTE_419 = .-_Note_Index_to_AUDF ; 603.84
   .byte $19
NOTE_418 = .-_Note_Index_to_AUDF ; 628.00
   .byte $18
NOTE_417 = .-_Note_Index_to_AUDF ; 654.16
   .byte $17
NOTE_416 = .-_Note_Index_to_AUDF ; 682.60
   .byte $16
NOTE_414 = .-_Note_Index_to_AUDF ; 747.61
   .byte $14
NOTE_413 = .-_Note_Index_to_AUDF ; 785.00
   .byte $13
NOTE_412 = .-_Note_Index_to_AUDF ; 826.31
   .byte $12
NOTE_411 = .-_Note_Index_to_AUDF ; 872.22
   .byte $11
NOTE_410 = .-_Note_Index_to_AUDF ; 923.52
   .byte $10
NOTE_40F = .-_Note_Index_to_AUDF ; 981.24
   .byte $0F
NOTE_40E = .-_Note_Index_to_AUDF ; 1046.66
   .byte $0E
NOTE_300 = .-_Note_Index_to_AUDF ; 1080.42
   .byte $00
NOTE_40D = .-_Note_Index_to_AUDF ; 1121.42
   .byte $0D
NOTE_40C = .-_Note_Index_to_AUDF ; 1207.69
   .byte $0C
NOTE_40B = .-_Note_Index_to_AUDF ; 1308.33
   .byte $0B
NOTE_409 = .-_Note_Index_to_AUDF ; 1569.99
   .byte $09
NOTE_408 = .-_Note_Index_to_AUDF ; 1744.43
   .byte $08
NOTE_407 = .-_Note_Index_to_AUDF ; 1962.49
   .byte $07
   if .-_Note_Index_to_AUDF != NUM_NOTES
     echo "ERROR: _Note_Index_to_AUDF (", _Note_Index_to_AUDF, ") does not match NUM_NOTES (", NUM_NOTES, ")"
   endif
end

;#endregion

   bank 7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 7 Titlescreen"
   inline song.h
   inline songplay.h

titlescreen_start
   COLUBK =_Color_Titlescreen_BG
   beat = 0 : tempoCount = 0 : measure = 0 : _Bit1_reset_restrainer{1} = 1

titlescreen            

   framecounter = framecounter + 1
   if framecounter{0} then bmp_96x2_2_index = 25 else  bmp_96x2_2_index = 0

   gosub songPlayer

   gosub titledrawscreen

   if joy0left && _Bit5_PlusROM{5} then gosub _clean_RAM : goto _prepare_HSC_bank5 bank5

   if !joy0fire then _Bit1_reset_restrainer{1} = 0
   if joy0fire && !_Bit1_reset_restrainer{1} then gosub _clean_RAM : goto start bank1
   asm
   lda SWCHA
   lda SWCHB
end
   goto titlescreen

_clean_RAM
   AUDV0 = 0 : AUDV1 = 0
   player1y = _Player1_Parking_Point : player2y = _Player2_Parking_Point : player3y = _Player3_Parking_Point : player4y = _Player4_Parking_Point
   player5y = _Player5_Parking_Point
   return thisbank  

   asm
   include "titlescreen/asm/titlescreen.asm"
end
;#endregion

   bank 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#region "Bank 8 bB drawscreen and sprites"

   asm
;====================================================================================
;--  Color tables used for the shared P1 sprite
;
;-- These tables are accessed using the COLUx variable from each sprite as an index

   align 128
    
   echo "Color tables start at ", *

colorTables:

;-- B&W palettes (dark and light) used by the ship carrier detail sprites
ct_black:               .byte _00,_00,_00,_00,_00,_00,_00,_00
ct_shipCarrierTower:    .byte _02,_02,_02,_02,_02,_02,_02,_02
ct_dkGrey:              .byte _06,_06,_06,_06,_06,_06,_06,_06
ct_lgGrey:              .byte _0A,_0A,_0A,_0A,_0A,_0A,_0A,_0A
ct_white:               .byte _0E,_0E,_0E,_0E,_0E,_0E,_0E,_0E

;-- Small planes
ct_smallEnemyPlaneHr:   .byte _DA,_DA,_D6,_D4,_DA,_DA,  _DA,_D6 ;-- last 2 values are typically not used
ct_smallEnemyPlane:     .byte _DA,_DA,_D8,_D6,_D6,  _D6,_D6,_D6 ;-- last 3 values are typically not used
ct_smallEnemyPlaneUp:   .byte _DA,_DA,_D8,_D6,_D6,  _D6,_D6,_D6 ;-- last 3 values are typically not used

;-- Small Red planes (carrying power-up)
ct_redPlanes:           .byte _4A,_4A,_48,_46,_46,  _46,_46,_46
ct_redPlanesUp:         .byte _4A,_4A,_48,_46,_46,  _46,_46,_46

;-- Medium-sized planes
ct_medEnemyPlane:       .byte _C6,_C6,_CA,_C6,_C6,_C6,_C4,_C2
ct_medEnemyPlaneUp:     .byte _C6,_C8,_C6,_C6,_C6,_CA,_C4,_C4

;-- Big planes (slightly different than the medium-sized ones)
ct_bigEnemyPlane:       .byte _D4,_D4,_D6,_D6,_D6,_DA,_D8,_D8
ct_bigEnemyPlaneUp:     .byte _D8,_D8,_D6,_D6,_D6,_DA,_D4,_D2

ct_bonus_yellow:        .byte _14,_16,_18,_1A,_1E,_1E,_1E,_1E
ct_bonus_orange:        .byte _2A,_28,_26,_24,_22,_22,_22,_22
ct_bonus_red:           .byte _4A,_48,_46,_44,_42,_42,_42,_42
ct_AyakoMissle:         .byte _46,_44,_42,_46,_44,_42,_44,_42

;-- Side fighter uses Multi-sprite for fly-in and out... 
;---   SO data needs to be duplicated to support both up and down movement
ct_SideFighter:         .byte _26,_26,_26,_28,_28,_2C,_2A,_2A
plyColorTable:          .byte _26,_26,_26,_28,_28,_2C,_2A,_2A
ct_plyExplosion:        .byte _38,_2A,_2C,_38,_2A,_2C,_2E,_38
                        .byte _36,_38,_2A,_26,_28,_2A,_38,_36
                        .byte _34,_36,_44,_46,_48,_36,_46,_34

   echo "Color tables end at ", *

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
   0
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
   0
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
   PAD_BB_SPRITE_DATA 7
end
  data _Big_Plane_down
   %01011010
   %11111111
   %11111111
   %01111110
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
   %01111110
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
   PAD_BB_SPRITE_DATA 6
end
  data _Power_Up
   %11010100
   %10111110
   %01101010
   %11000000
   %11110000
   %11011000
   %11111000
end

   inline 6lives.asm

restart_bB
   asm
   sei
   cld
   lda #0
   ldx #$CE
   jmp clearmem
end

   asm
   ; HSC PlusROM API definition.
   SET_PLUSROM_API "a", "h.firmaplus.de"
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

   vblank
   lifecolor = _Color_Player_Plane_Base : COLUPF = r_COLUPF
   if _Bit6_p0_explosion{6} then bally = 100 else bally = player0y - 4
   if framecounter{0} then ballx = player0x + 4 else ballx = player0x + 2
   if _Bit7_hide_sidefighter{7} then _landing_takeoff
   CTRLPF = r_CTRLPF : NUSIZ0 = r_NUSIZ0
   if r_Bit7_Left_Plane_is_SF{7} then ballx = ballx + 16
   return thisbank

_landing_takeoff
   CTRLPF = %00100001
   return thisbank

;#endregion
