;----------------------------------------------------------------------------
;---    bBasic Multi-sprite kernel - customized for 1942
;---
;----------------------------------------------------------------------------
; Provided under the CC0 license. See the included LICENSE.txt for details.
;----------------------------------------------------------------------------

;---------------------------------------------
;--- Some assumptions:
;---
;---    screenheight = 88       (176 scanlines for playfield)
;---                            (22  scanlines for status and score)
;---                            (198 total scanlines visible)
;---    pfheight = 0, 1, or 3
;--
;---    switch_player_0_color is always active:
;--
;--        COLUP0 starts off with being the bullet color
;--        then is switched to Player0SwitchColor when it's 
;--        time to draw the player plane.


;------- Some variables:

;---- allow multicolor player0 --> loaded right before the kernel executes
player0colorP = $F7
player0colorPlo = $F7
player0colorPhi = $F8


;---- superchip RAM area that appears to not be used: $1001..$1005

;--- cache sorted list of new sprite Y values so that
;---   we don't waste time in the kernel doing the sort lookup
wCacheNewSpriteY = $1001
rCacheNewSpriteY = wCacheNewSpriteY + $80


;----------------------------------------------------------------


FineAdjustTableBegin
    .byte %01100000                ;left 6
    .byte %01010000
    .byte %01000000
    .byte %00110000
    .byte %00100000
    .byte %00010000
    .byte %00000000                ;left 0
    .byte %11110000
    .byte %11100000
    .byte %11010000
    .byte %11000000
    .byte %10110000
    .byte %10100000
    .byte %10010000
    .byte %10000000                ;right 8
FineAdjustTableEnd        =        FineAdjustTableBegin - 241

PFStart
    .byte 87,43,0,21,0,0,0,10
blank_pf
    .byte 0,0,0,0,0,0,0,5

    ;--set initial P1 positions
multisprite_setup
    lda #15
    sta pfheight

    ldx #4
;    stx temp3
SetCopyHeight
;    lda #76
;    sta NewSpriteX,X
;    lda CopyColorData,X
;    sta NewCOLUP1,X
    ;lda SpriteHeightTable,X
;    sta spriteheight,x
    txa
    sta SpriteGfxIndex,X
    sta spritesort,X
    dex
    bpl SetCopyHeight



; since we can't turn off pf, point PF to zeros here
    lda #>blank_pf
    sta PF2pointer+1
    sta PF1pointer+1
    lda #<blank_pf
    sta PF2pointer
    sta PF1pointer
    rts

;--------------------------------------------------------------------------------
;--- player color table needs to be here to avoid causing page crossing issues
plyColorTable:
    .byte $2A,$2F,$24,$2C,$28,$2A,$2C,$28,$24,$24

;=====================================================================
;---------------------------------------------------------------------

drawscreen
  ifconst debugscore
    jsr debugcycles
  endif

WaitForOverscanEnd
    lda INTIM
    bmi WaitForOverscanEnd

    lda #2
    sta WSYNC
    sta VSYNC
    sta WSYNC
    sta WSYNC
    lsr
    sta VDELBL
    sta VDELP0
    sta WSYNC
    sta VSYNC        ;turn off VSYNC
  ifconst overscan_time
    lda #overscan_time+5+128
  else
    lda #42+128
  endif
    sta TIM64T

; run possible vblank bB code
  ifconst vblank_bB_code
    jsr vblank_bB_code
  endif

    jsr setscorepointers
    jsr SetupP1Subroutine

    ;-------------
    ;--position P0, M0, M1, BL

    jsr PrePositionAllObjects

    ;--set up player 0 pointer

    ;---- setup temp7 with position to switch COLUP0
    lda player0y
    adc #2
    sta temp7


    ;------------------------ setup player0 positioning
    dec player0y
    lda player0pointer ; player0: must be run every frame!
    sec
    sbc player0y
    clc
    adc player0height
    sta player0pointer

    ;----- setup color pointer
    lda #<plyColorTable
    sec
    sbc player0y
    clc
    adc player0height
    sta player0colorPlo

    lda #>plyColorTable
    clc
    adc #0
    sta player0colorPhi



    lda player0y
    sta P0Top
    sec
    sbc player0height
    clc
    adc #$80
    sta P0Bottom
    

    ;--some final setup

    ldx #4
    lda #$80
cycle74_HMCLR
    sta HMP0,X
    dex
    bpl cycle74_HMCLR
;    sta HMCLR


    lda #0
    sta PF1
    sta PF2
    sta GRP0
    sta GRP1


    jsr KernelSetupSubroutine

WaitForVblankEnd
    lda INTIM
    bmi WaitForVblankEnd
    lda #0
    sta WSYNC
    sta VBLANK        ;turn off VBLANK - it was turned on by overscan
    sta CXCLR


    jmp KernelRoutine   ;3 [9]


PositionASpriteSubroutine        ;call this function with A == horizontal position (0-159)
    ;and X == the object to be positioned (0=P0, 1=P1, 2=M0, etc.)
    ;if you do not wish to write to P1 during this function, make
    ;sure Y==0 before you call it.  This function will change Y, and A
    ;will be the value put into HMxx when returned.
    ;Call this function with at least 11 cycles left in the scanline 
    ;(jsr + sec + sta WSYNC = 11); it will return 9 cycles
    ;into the second scanline
    sec
    sta WSYNC                        ;begin line 1
    sta.w HMCLR                        ;+4         4
DivideBy15Loop
    sbc #15
    bcs DivideBy15Loop                        ;+4/5        8/13.../58

    tay                                ;+2        10/15/...60
    lda FineAdjustTableEnd,Y        ;+5        15/20/...65

    ;        15
    sta HMP0,X        ;+4        19/24/...69
    sta RESP0,X        ;+4        23/28/33/38/43/48/53/58/63/68/73
    sta WSYNC        ;+3         0        begin line 2
    sta HMOVE        ;+3
    rts                ;+6         9

;-------------------------------------------------------------------------

PrePositionAllObjects

    ldx #4
    lda ballx
    jsr PositionASpriteSubroutine
    
    dex
    lda missile1x
    jsr PositionASpriteSubroutine
    
    dex
    lda missile0x
    jsr PositionASpriteSubroutine

    dex
    dex
    lda player0x
    jsr PositionASpriteSubroutine

    rts


;------------------------------------------------------------------------------------------------

KernelSetupSubroutine

    ldx #4
AdjustYValuesUpLoop
    lda NewSpriteY,X
    clc
    adc #2
    sta NewSpriteY,X
    dex
    bpl AdjustYValuesUpLoop


    ldx temp3 ; first sprite displayed

    lda SpriteGfxIndex,x
    tay
    lda NewSpriteY,y
    sta RepoLine

    lda SpriteGfxIndex-1,x
    tay
    lda NewSpriteY,y
    sta temp6

    stx SpriteIndex


    ;------------------------------------------------------------------------
    ;-- preprocess sprite Y coords into proper order and store in a cache
    ;--  to elimatinate need to do that in the main kernel

CacheYcoordsLoop
    lda SpriteGfxIndex-1,x
    tay
    lda NewSpriteY,y
    sta wCacheNewSpriteY,x
    dex
    bpl CacheYcoordsLoop

    ;------------------- initialize other kernel variables
    lda #255
    sta P1Bottom

    lda player0y

    cmp #$59                ;--- screenheight + 1

    bcc nottoohigh
    lda P0Bottom
    sta P0Top                

    

nottoohigh
    rts

;-------------------------------------------------------------------------







;-------------------------------------------------------------------------
;----------------------Kernel Routine-------------------------------------
;-------------------------------------------------------------------------

START_OF_KERNEL_ROUTINES:

;-------------------------------------------------------------------------
; repeat $f147-*
; brk
; repend
;    org $F240

SwitchDrawP0K1                  ;----- enter at 66
    lda P0Bottom                    ;3  [69]
    sta P0Top                       ;3  [72]
    jmp BackFromSwitchDrawP0K1      ;3  [75]

WaitDrawP0K1                    ;----- enter at 68
    SLEEP 4                         ;4  [72]
    jmp BackFromSwitchDrawP0K1      ;3  [75]

SkipDrawP1K1                    ;----- enter at 5
    lda #0                          ;2  [7]
    sta GRP1                        ;3  [10]        so Ball gets drawn
    jmp BackFromSkipDrawP1          ;3  [13]

;-------------------------------------------------------------------------

KernelRoutine               ;--- enters at cycle 9

    sleep 12                    ;12 [21]

    tsx                         ;2  [23]
    stx stack1                  ;3  [26]
    ldx #ENABL                  ;2  [28]
    txs                         ;2  [30]

    ldx #0                      ;2  [32]
    lda pfheight                ;3  [35] -- scanlines per playfield pixel
    bpl asdhj                   ;2,3  [38]
    .byte $24                   ;3  [40]    -- use 'BIT zp' to skip over TAX
asdhj
    tax                         ;2  [40]    -- skipped if branch not taken

                            ;--- ends at cycle 40

    lda PFStart,x               ;4  [44] get pf pixel resolution for heights 15,7,3,1,0
    sta pfpixelheight           ;3  [47]

    ldy #88                     ;2  [49]  -- screenheight
    sleep 4                     ;4  [53]


    ;---- Actual display kernel starts here

;--- KernelLoopA is hit every '4' scanlines

KernelLoopA                 ;----- enter at 53
    ;SLEEP 7                     ;7  [60]
    
    ;---- this is just some temp code to show where KernelA is hit.
    eor     #$9F
    and     #$97
    sta     COLUBK

;--- KernelLoopB is hit 3 out of 4 scanlines
;-
;--         -- DRAWING line 1 -> player0, player1, playfield

KernelLoopB                 ;----- enter at 60

    cpy P0Top                   ;3  [63]
    beq SwitchDrawP0K1          ;2  [65]
    bpl WaitDrawP0K1            ;2  [67]    -- wait to draw P0
    lda (player0pointer),Y      ;5  [72]
    sta GRP0                    ;3  [75]      VDEL because of repokernel


BackFromSwitchDrawP0K1      ;-- enter at cycle 75

    cpy P1Bottom                ;3  [2]        unless we mean to draw immediately, this should be set
                                ;                to a value greater than maximum Y value initially
    bcc SkipDrawP1K1            ;2  [4]
    lda (P1display),Y           ;5  [9]
    sta.w GRP1                  ;4  [13]

BackFromSkipDrawP1          ;-- enter at cycle 13
       
    sty temp1                   ;3  [16]    -- save sprite Y counter
    
    ldy pfpixelheight           ;3  [19]    -- restore playfield row counter
    
    lax (PF1pointer),y          ;5  [24]    -- load in playfield data
    stx PF1                     ;3  [27]
    lda (PF2pointer),y          ;5  [32]
    sta PF2                     ;3  [35]
    ;sleep 6
    stx PF1temp2                ;3  [38]    -- these need to be saved for the RepoKernel
    sta PF2temp2                ;3  [41]
    
    dey                         ;2  [43]
    bmi pagewraphandler         ;2  [45]
    lda (PF1pointer),y          ;5  [50]    -- load next playfield row
cyclebalance
    sta PF1temp1                ;3  [53]
    lda (PF2pointer),y          ;5  [58]
    sta PF2temp1                ;3  [61]

    ;//----      -- DRAWING line 2 -> ball + 2 missiles,  call repo?, switch player color,
    ;            --                         calc next repo, handle scanline / row counters

    ldy temp1                   ;3  [64]
    ldx #ENABL                  ;2  [66]
    txs                         ;2  [68]
    cpy bally                   ;3  [71]
    php                         ;3  [74]        VDEL ball


    cpy missile1y               ;3  [1]
    php                         ;3  [4]

    cpy missile0y               ;3  [7]
    php                         ;3  [10]
    
    dey                         ;2  [12]

    cpy RepoLine                ;3  [15]
    beq RepoKernel              ;2  [17]        -- If we hit a reposition line, jump to that kernel

    cpy temp7                   ;3  [20]
    bpl SkipSwitchColorP0K1     ;2* [22]        --- not drawing player yet, so preserve the missile color
    
    lda (player0colorP),y       ;5  [27]    -- load in player color
    sta COLUP0                  ;3  [30]


newrepo         ; since we have time here, prep for next repoline and store in a temp var
    ldx.w SpriteIndex           ;4  [34]
    bmi SkipNewSpriteY          ;2  [36]

    nop                         ;2  [38]
    
    lda rCacheNewSpriteY,X      ;4  [42]
    sta temp6                   ;3  [45]

BackFromRepoKernel              ;--- enter at 45
    tya                         ;2  [47]
    bit pfheight                ;3  [50]  -- do AND using BIT because we only care about the CPU flags
    bne KernelLoopA             ;2  [52]
    dec pfpixelheight           ;5  [57] -- next playfield row
    bpl KernelLoopB             ;+3 [60]

donewkernel
    jmp DoneWithKernel          ;3  [62]

pagewraphandler
    jmp cyclebalance

SkipSwitchColorP0K1         ;---- enter at 23
    sleep 4                     ;3  [27]
    jmp newrepo                 ;3  [30]

SkipNewSpriteY:             ;---- enter at 37
    lda #0                      ;2  [39]
    sta temp6                   ;3  [42]
    jmp BackFromRepoKernel      ;3  [45]


;-------------------------------------------------------------------------
;--- TODO::: Add kernel for drawing player plane (to allow multi-color).
;-------------------------------------------------------------------------


;-----------------------------------------------------------
;--- Utility code blocks for Reposition Kernel
;-----------------------------------------------------------

SwitchDrawP0KR                  ;--- entered at cycle 39
    lda P0Bottom                    ;3  [42]
    sta P0Top                       ;3  [45]
    jmp BackFromSwitchDrawP0KR      ;3  [48]

WaitDrawP0KR                    ;--- entered at cycle 41
    SLEEP 4                         ;4  [45]
    jmp BackFromSwitchDrawP0KR      ;3  [48]

noUpdateXKR                     ;--- entered at cycle 27
    ldx #1                          ;2  [29]
    cpy.w P0Top                     ;4  [33]
    JMP retXKR                      ;3  [36]


    ;--------------------------------------------------------------------------
    ;--  Reposition P1 Kernel
    ;--------------------------
    ;
    ;   This kernel takes 4 scanlines:
    ;     - (2b) Prep and load P0, PF1, PF2 for DRAWING Line 1.
    ;     - (1)  Reposition P1
    ;     - (2)  Update M0,M1,BL right before display starts (DRAWING Line 2)
    ;               and then Prep for DRAWING Line 1 and do EARLY HMOVE
    ;     - (1)  Prepare everything for the new P1
    ;            Prep for line 2 (M0,M1,BL)
    ;
    ;--------------------------------------------------------------------------
    ;  This repositioning kernel is entered after the graphics updates for
    ;   DRAWING line 2 have occured
    ;--------------------------------------------------------------------------

RepoKernel                  ;--- enter at 19      -- crosses page boundary
    tya                         ;2  [21]
    and pfheight                ;3  [24]
    bne noUpdateXKR             ;2  [26]
    tax                         ;2  [28]    -- this will always be zero here
    dec pfpixelheight           ;5  [33]
    cpy P0Top                   ;3  [36]

retXKR                      ;--- enter at 36
    beq SwitchDrawP0KR          ;2  [38]
    bpl WaitDrawP0KR            ;2  [40]
    lda (player0pointer),Y      ;5  [45]
    sta GRP0                    ;3  [48]    -- VDEL used to hold update until GRP1 updated on DRAWING line 1

BackFromSwitchDrawP0KR      ;--- enter at 48
    sec                         ;2  [50]

    lda PF2temp1,X              ;4  [54]    -- X is always 0 or 1.
    ldy PF1temp1,X              ;4  [58]

    ;------------------------- DRAWING Line 1 -> use GRP1 to trigger GRP0.... then reposition!

    ldx SpriteIndex             ;3  [61]
    sta PF2                     ;3  [64]

    lda SpriteGfxIndex,x        ;4  [68]
    sty PF1                     ;3  [71]        too early?

    tax                         ;2  [73]
    lda #0                      ;2  [75]
    sta GRP1                    ;3  [2] --     to display player 0
    lda NewSpriteX,X            ;4  [6]
 
DivideBy15LoopK                 ;--- first entered at 6        (carry set above)
    sbc #15                     ;2
    bcs DivideBy15LoopK         ;+4/5        10/15.../60

    tax                         ;+2        12/17/...62
    lda FineAdjustTableEnd,X    ;+5        17/22/...67

    sta HMP1                    ;+3        20/25/...70
    sta RESP1                   ;+3        23/28/33/38/43/48/53/58/63/68/73

    ;---------------------- DRAWING Line 2 -> M0, M1, BL

    sta WSYNC                   ;+3         0        begin line 2
    ;sta HMOVE                   ;+3         3

    ldx #ENABL                  ;2  [2]
    txs                         ;2  [4]
    ldy RepoLine                ;3  [7]      restore y
    cpy bally                   ;3  [10]
    php                         ;3  [13]        VDEL ball

    cpy missile1y               ;3  [16]
    php                         ;3  [19]

    cpy missile0y               ;3  [22]
    php                         ;3  [25]

    ;----- determine which cached playfield data to use  (15 cycles + potential page crossing branch)
    ;--- *13* cycles to determine whether if on last scanline of playfield row


    tya                         ;2  [27]
    and pfheight                ;3  [30]
    cmp #1                      ;2  [32] --- sets carry if masked pfheight >= 1
    lda #0                      ;2  [34]
    adc #0                      ;2  [36]
    tax                         ;2  [38]
    nop                         ;2  [40]

    ;----------------------- Early PERP for DRAWING Line 1 -> P0, P1, PF


    dey                         ;2  [42]
    cpy P0Top                   ;3  [45]
    beq SwitchDrawP0KV          ;2  [47]
    bpl WaitDrawP0KV            ;2  [49]

    lda (player0pointer),Y      ;5  [54]
    sta GRP0                    ;3  [57]        VDEL

BackFromSwitchDrawP0KV      ;---- enter at 57
    lda PF2temp1,X              ;4  [61]
    sta PF2                     ;3  [64]
    lda PF1temp1,X              ;4  [68]
    sta PF1                     ;3  [71]
    sta HMOVE                   ;3  *74*  --- EARLY HMOVE

    lda #0                      ;2  [0]
    sta GRP1                    ;3  [3]  --        to display GRP0

    ldx #ENABL                  ;2  [5]
    txs                         ;2  [7]

    ;---------------------------------------------------------------------------
    ;--   now, set all new variables and return to main kernel loop

    ldx SpriteIndex             ;3  [10] --  restore index into new sprite vars
    lda SpriteGfxIndex,X        ;4  [14]
    tax                         ;2  [16]

    lda NewNUSIZ,X              ;4  [20]    -- load in size and color for new sprite
    sta NUSIZ1                  ;3  [23]
    sta REFP1                   ;3  [26]
    lda NewCOLUP1,X             ;4  [30]
    sta COLUP1                  ;3  [33]

    lda NewSpriteY,X            ;4  [37]    -- load in bottom of new sprite
    sec                         ;2  [39]
    sbc spriteheight,X          ;4  [43]
    sta P1Bottom                ;3  [46]

    sleep 6                     ;6  [52]    --- wasting time... hmmmm....

    lda player1pointerlo,X      ;4  [56]
    sbc P1Bottom                ;3  [59]    carry should still be set
    sta P1display               ;3  [62]
    lda player1pointerhi,X      ;4  [66]
    sta P1display+1             ;3  [69]

    ;---------------------------- DRAWING Line 2 -> M0, M1, BL

    cpy bally                   ;3  [72]
    php                         ;3  [75]        VDELed

    cpy missile1y               ;3  [2]
    php                         ;3  [5]

    cpy missile0y               ;3  [8]
    php                         ;3  [11]

    dec SpriteIndex             ;5  [16]


; 10 cycles below...
    bpl SetNextLine             ;2  [18]
    lda #255                    ;2  [20]
    jmp SetLastLine             ;3  [23]

SetNextLine
    lda.w temp6                 ;4  [23]

SetLastLine             ;---- enter at cycle 23
    sta RepoLine                ;3  [26]

    tya                         ;2  [28]
    and pfheight                ;3  [31]
    bne nodec                   ;2  [33]
    dec pfpixelheight           ;5  [38]
    dey                         ;2  [40]

    sleep 2                     ;2  [42]
    jmp BackFromRepoKernel      ;3  [45]        -->>>  RETURN to main kernel

nodec                       ;-- enter at cycle 34
    sleep 6                     ;6  [40]
    dey                         ;2  [42]
    jmp BackFromRepoKernel      ;3  [45]        -->>>  RETURN to main kernel


SwitchDrawP0KV              ;-- enter at cycle 48
    lda P0Bottom                ;3  [51]
    sta P0Top                   ;3  [54]
    jmp BackFromSwitchDrawP0KV  ;3  [57]

WaitDrawP0KV                ;----- enter at cycle 50
    SLEEP 4                     ;4  [54]
    jmp BackFromSwitchDrawP0KV  ;3  [57]


END_OF_KERNEL_ROUTINES:

    echo "Size of Multi-Sprite kernel(s): ", (END_OF_KERNEL_ROUTINES - START_OF_KERNEL_ROUTINES)


;-------------------------------------------------------------------------

DoneWithKernel

BottomOfKernelLoop

    sta WSYNC
    ldx stack1
    txs
    jsr sixdigscore ; set up score


    sta WSYNC
    ldx #0
    sta HMCLR
    STx GRP0
    STx GRP1 ; seems to be needed because of vdel
    LDY #7
    STy VDELP0
    STy VDELP1
    LDA #$10
    STA HMP1
    LDA scorecolor 
    STA COLUP0
    STA COLUP1
    
    LDA #$03
    STA NUSIZ0
    STA NUSIZ1

    STA RESP0
    STA RESP1

    LDA #$01
    sta CTRLPF

    sleep 4
    lda  (scorepointers),y
    sta  GRP0
  ifconst pfscore
    lda pfscorecolor
    sta COLUPF
  else
    sleep 6
  endif

    STA HMOVE
    lda  (scorepointers+8),y
;    sta WSYNC
    ;sleep 2
    jmp beginscore

 align 256

loop2
    lda  (scorepointers),y     ;+5  68  204
    sta  GRP0            ;+3  71  213      D1     --      --     --
  ifconst pfscore
  if pfscore = 1 || pfscore = 3
    lda.w pfscore1
    sta PF1
  else
    lda #0
    sta PF1
    nop
  endif
  else
    sleep 7
  endif
    ; cycle 0
    lda  (scorepointers+$8),y  ;+5   5   15
beginscore
    sta  GRP1            ;+3   8   24      D1     D1      D2     --
    lda  (scorepointers+$6),y  ;+5  13   39
    sta  GRP0            ;+3  16   48      D3     D1      D2     D2
    lax  (scorepointers+$2),y  ;+5  29   87
    txs
    lax  (scorepointers+$4),y  ;+5  36  108
    sleep 3
  ifconst pfscore
  if pfscore > 1
    lda statusbarlength
    sta PF1
  else
    lda.w #0
    sta PF1
  endif
  else
    sleep 6
  endif
    lda  (scorepointers+$A),y  ;+5  21   63
    stx  GRP1            ;+3  44  132      D3     D3      D4     D2!
    tsx
    stx  GRP0            ;+3  47  141      D5     D3!     D4     D4
    sta  GRP1            ;+3  50  150      D5     D5      D6     D4!
    sty  GRP0            ;+3  53  159      D4*    D5!     D6     D6
    dey
    bpl  loop2           ;+2  60  180
    ldx stack1
    txs


;    lda scorepointers+1
    ldy temp1
;    sta temp1
    sty scorepointers+1

    LDA #0   
    STA GRP0
    STA GRP1
    sta PF1 
    sta PF0
    STA VDELP0
    STA VDELP1;do we need these
    STA NUSIZ0
    STA NUSIZ1

;    lda scorepointers+3
    ldy temp3
;    sta temp3
    sty scorepointers+3

;    lda scorepointers+5
    ldy temp5
;    sta temp5
    sty scorepointers+5


;-------------------------------------------------------------------------
;------------------------Overscan Routine---------------------------------
;-------------------------------------------------------------------------

OverscanRoutine



skipscore
  ifconst qtcontroller
    lda qtcontroller
    lsr    ; bit 0 in carry
    lda #4
    ror    ; carry into top of A
  else
    lda #2
  endif ; qtcontroller
    sta WSYNC
    sta VBLANK        ;turn on VBLANK

    JMP     KernelCleanupSubroutine

    


;-------------------------------------------------------------------------
;----------------------------End Main Routines----------------------------
;-------------------------------------------------------------------------


;*************************************************************************


;-------------------------------------------------------------------------
;---- Some score code here to prevent branches from crossing pages....


;*************************************************************************

;-------------------------------------------------------------------------
;-------------------------Data Below--------------------------------------
;-------------------------------------------------------------------------

MaskTable
    .byte 1,3,7,15,31

    ; shove 6-digit score routine here

sixdigscore
    lda #0
;    sta COLUBK
    sta PF0
    sta PF1
    sta PF2
    sta ENABL
    sta ENAM0
    sta ENAM1
    ;end of kernel here


    ; 6 digit score routine
;    lda #0
;    sta PF1
;    sta PF2
;    tax

    sta WSYNC;,x

;    STA WSYNC ;first one, need one more
    sta REFP0
    sta REFP1
    STA GRP0
    STA GRP1
    sta HMCLR

    ; restore P0pointer

    lda player0pointer
    clc
    adc player0y
    sec
    sbc player0height
    sta player0pointer
    inc player0y

  ifconst vblank_time
    lda  #vblank_time+9+128
  else
    lda  #52+128
  endif

    sta  TIM64T
  ifconst minikernel
    jsr minikernel
  endif
  ifconst noscore
    pla
    pla
    jmp skipscore
  endif

; score pointers contain:
; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
; swap lo2->temp1
; swap lo4->temp3
; swap lo6->temp5

    lda scorepointers+5
    sta temp5
    lda scorepointers+1
    sta temp1
    lda scorepointers+3
    sta temp3

    lda #>scoretable
    sta scorepointers+1
    sta scorepointers+3
    sta scorepointers+5
    sta temp2
    sta temp4
    sta temp6

    rts


; room here for score?

setscorepointers
    lax score+2
    jsr scorepointerset
    sty scorepointers+5
    stx scorepointers+2
    lax score+1
    jsr scorepointerset
    sty scorepointers+4
    stx scorepointers+1
    lax score
    jsr scorepointerset
    sty scorepointers+3
    stx scorepointers
wastetime
    rts

scorepointerset
    and #$0F
    asl
    asl
    asl
    adc #<scoretable
    tay
    txa
    and #$F0
    lsr
    adc #<scoretable
    tax
    rts
;    align 256


;-------------------------------------------------------------------------
;----------------------Begin Subroutines----------------------------------
;-------------------------------------------------------------------------




KernelCleanupSubroutine

    ldx #4
AdjustYValuesDownLoop
    lda NewSpriteY,X
    sec
    sbc #2
    sta NewSpriteY,X
    dex
    bpl AdjustYValuesDownLoop


    RETURN
    ;rts

SetupP1Subroutine
; flickersort algorithm
; count 4-0
; table2=table1 (?)
; detect overlap of sprites in table 2
; if overlap, do regular sort in table2, then place one sprite at top of table 1, decrement # displayed
; if no overlap, do regular sort in table 2 and table 1
fsstart
    ldx #255
copytable
    inx
    lda spritesort,x
    sta SpriteGfxIndex,x
    cpx #4
    bne copytable

    stx temp3 ; highest displayed sprite
    dex
    stx temp2
sortloop
    ldx temp2
    lda spritesort,x
    tax
    lda NewSpriteY,x
    sta temp1

    ldx temp2
    lda spritesort+1,x
    tax
    lda NewSpriteY,x
    sec
    clc
    sbc temp1
    bcc largerXislower

; larger x is higher (A>=temp1)
    cmp spriteheight,x
    bcs countdown
; overlap with x+1>x
;    
; stick x at end of gfxtable, dec counter
overlapping
    dec temp3
    ldx temp2
;    inx
    jsr shiftnumbers
    jmp skipswapGfxtable

largerXislower ; (temp1>A)
    tay
    ldx temp2
    lda spritesort,x
    tax
    tya
    eor #$FF
    sbc #1
    bcc overlapping
    cmp spriteheight,x
    bcs notoverlapping

    dec temp3
    ldx temp2
;    inx
    jsr shiftnumbers
    jmp skipswapGfxtable 
notoverlapping
;    ldx temp2 ; swap display table
;    ldy SpriteGfxIndex+1,x
;    lda SpriteGfxIndex,x
;    sty SpriteGfxIndex,x
;    sta SpriteGfxIndex+1,x 

skipswapGfxtable
    ldx temp2 ; swap sort table
    ldy spritesort+1,x
    lda spritesort,x
    sty spritesort,x
    sta spritesort+1,x 

countdown
    dec temp2
    bpl sortloop

checktoohigh
    ldx temp3
    lda SpriteGfxIndex,x
    tax
    lda NewSpriteY,x
    cmp #$55            ; screenheight-3
    bcc nonetoohigh
    dec temp3
    bne checktoohigh

nonetoohigh
    rts


shiftnumbers
 ; stick current x at end, shift others down
 ; if x=4: don't do anything
 ; if x=3: swap 3 and 4
 ; if x=2: 2=3, 3=4, 4=2
 ; if x=1: 1=2, 2=3, 3=4, 4=1
 ; if x=0: 0=1, 1=2, 2=3, 3=4, 4=0
;    ldy SpriteGfxIndex,x
swaploop
    cpx #4
    beq shiftdone 
    lda SpriteGfxIndex+1,x
    sta SpriteGfxIndex,x
    inx
    jmp swaploop
shiftdone
;    sty SpriteGfxIndex,x
    rts

  ifconst debugscore
debugcycles
    ldx #14
    lda INTIM ; display # cycles left in the score

  ifconst mincycles
    lda mincycles 
    cmp INTIM
    lda mincycles
    bcc nochange
    lda INTIM
    sta mincycles
nochange
  endif

;    cmp #$2B
;    bcs no_cycles_left
    bmi cycles_left
    ldx #64
    eor #$ff ;make negative
cycles_left
    stx scorecolor
    and #$7f ; clear sign bit
    tax
    lda scorebcd,x
    sta score+2
    lda scorebcd1,x
    sta score+1
    rts
scorebcd
    .byte $00, $64, $28, $92, $56, $20, $84, $48, $12, $76, $40
    .byte $04, $68, $32, $96, $60, $24, $88, $52, $16, $80, $44
    .byte $08, $72, $36, $00, $64, $28, $92, $56, $20, $84, $48
    .byte $12, $76, $40, $04, $68, $32, $96, $60, $24, $88
scorebcd1
    .byte 0, 0, 1, 1, 2, 3, 3, 4, 5, 5, 6
    .byte 7, 7, 8, 8, 9, $10, $10, $11, $12, $12, $13
    .byte $14, $14, $15, $16, $16, $17, $17, $18, $19, $19, $20
    .byte $21, $21, $22, $23, $23, $24, $24, $25, $26, $26
  endif
