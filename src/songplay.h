

; Pat Brady added patternAttH and patternAttL
    ifnconst patternAttH
patternAttH = 0 ; full volume
    endif
    ifnconst patternAttL
patternAttL = 6 ; attenuation for low
    endif

bitMaskArray
    byte #%10000000
    byte #%01000000
    byte #%00100000
    byte #%00010000
    byte #%00001000
    byte #%00000100
    byte #%00000010
    byte #%00000001


;--------------------------------------------------------------------------
; playPattern
;--------------------------------------------------------------------------
; Plays a pattern
;
; - ACC should contain the offset in the patternArray of the pattern to play
; - X should contain the oscillator to be used (0 or 1)
;
;--------------------------------------------------------------------------
playPattern

    ; save unaltered patternArray offset
    sta temp16L

    ; save patternArray offset
    asl
    asl
    asl
    sta temp

    ; custom code to allow 1 quarter note per measure (Thrust):
    ; use beat to determine extra offset within patternArray
    lda beat
    and #%00011000
    lsr
    lsr

    ; add in original offset
    adc temp

    ; save osc number
    stx temp

    tax

    ; This mod allows for high and low volume patterns.
    ; Patterns of offset greater than 128 read from a different
    ; array and play lower.
    lda temp16L
    bmi lowPattern

    ; Loud version
    ; Get address of selected pattern
    lda patternArrayH,x
    ldy patternArrayH+1,x

    ; Set attenuation
    ldx #patternAttH
    beq endGetPattern

lowPattern
    ; Soft version
    ; Get address of selected pattern
    lda patternArrayL,x
    ldy patternArrayL+1,x

    ; Set attenuation
    ldx #patternAttL

endGetPattern
    sta temp16L
    sty temp16H
    stx atten

    ; The variable, beat, contains the 32nd note
    ; that the beat is currently on.
    lda beat

    ; modification for 1 quarter per measure (Thrust)
    and #%00000111
    tay

    ; Get sound/note data
    lda (temp16L),y
    eor #255
    beq muteNote
    eor #255

;--------------------------------------------------------------------------
; Extract Pattern Data
;--------------------------------------------------------------------------
; Each byte of pattern data contains the frequency and
; sound type data.  This function separates and decodes them.
;
; The encoding is: the 3 high bits contain the encoded sound
; type and the lower 5 bits contain the freq data.
;
; - ACC must contain pattern byte
;
; = ACC will return the freq
; = X will return the sound type
;
; changes ACC,X
;--------------------------------------------------------------------------
    tax

    ; Extract freq data and push it
    and #%00011111
    pha

    txa
    lsr
    lsr
    lsr
    lsr
    lsr
    tax

;-----------------------
    lda atten
    clc
    adc soundTurnArray,x
    sta atten
;-----------------------

    lda soundTypeArray,x
;--------------------------------------------------------------------------

    ; Get the osc number again
    ldx temp
;	bne noPhase

;	sta AUDF0
;	nop
;	nop
;	nop
;	nop


noPhase


    ; REMOVE IN FINAL VERSION
    sta sound1,x

    sta AUDC0,x
    pla
    sta AUDF0,x


    ; REMOVE IN FINAL VERSION
    sta note1,x

    ; restore beat & #%111
    tya
    tax

;--------------------------------------------------------------------------
; Accent Reader
;--------------------------------------------------------------------------
; Each set of pattern data is followed by 4 accept bytes.
; Each bit in order represents the accent (on or off)
; of its corresponding 32nd note.  This function
; returns the attenuation of a note in a pattern.
;
; - temp16 must contain an indirect pointer to the pattern data
; - X must contain the beat && %00000111
;
; = will return the volume in ACC
;
; changes X,Y,ACC
;--------------------------------------------------------------------------
    ; Accent offset is always 8 for Thrust mod
    ldy #8

    lda (temp16L),y
    and bitMaskArray,x
    beq noAccent

    ; It's an Accent, so don't attenuate
    lda #15

noAccent
    ; No accent, so use a lower volume
    ora #13
;--------------------------------------------------------------------------

    sbc atten                   ; carry flag???
muteNote
    ldy temp                    ; Get the osc number again
    sta AUDV0,y

	; REMOVE IN FINAL VERSION
	sta vol1,y


	;--------------------------------------------------------------------------
	; Super High Hat (TM)
	;--------------------------------------------------------------------------
	; This plays the high hat sound on the first frame of each beat indicated
	; in hatPattern
	;--------------------------------------------------------------------------
	; disabled by Pat Brady for now: setting HATSTART to 255 doesn't work
	;ldy temp
	;beq noHat

	; Reat high hat pattern
	;lda measure
	;cmp #HATSTART
	;bmi noHat

	;lda beat
	;and #%00000111
	;tax
	;lda beat
	;lsr
	;lsr
	;lsr
	;tay
	;lda hatPattern,y
	;and bitMaskArray,x
	;beq noHat

	; Only play had on first frame
	;lda tempoCount
	;bne noHat

	; Play hat
	;lda #HATPITCH
	;sta AUDF1
	;lda #HATSOUND
	;sta AUDC1
	;lda #HATVOLUME
	;sta AUDV1
noHat
	;--------------------------------------------------------------------------

	;--------------------------------------------------------------------------
	; Percussion cutter
	;--------------------------------------------------------------------------
	; This code cuts off the sound for better percussive sounds.  You
	; can set it to start working at a certain measure.
	;--------------------------------------------------------------------------
;	lda measure
;	cmp #111	; start measure
;	bmi noCut

;	lda tempoCount
;	and #%11111110
;	beq noCut

;	lda #0
;	sta AUDV0

noCut



    rts ; playPattern OTHER RTS IN FUNCTION



;--------------------------------------------------------------------------
; songPlayer
;--------------------------------------------------------------------------
; Plays up to two pre-programmed patterns simlutaneously.
;
; Call this once per screen-draw.
;--------------------------------------------------------------------------
.songPlayer

;--------------------------------------------------------------------------
; Generates tempo based on TEMPODELAY
;--------------------------------------------------------------------------
    inc tempoCount
    lda tempoCount
    eor #TEMPODELAY
    bne quitTempo
    sta tempoCount

    inc beat
    lda beat
    eor #32
    bne quitTempo
    sta beat

    inc measure

quitTempo
;--------------------------------------------------------------------------

    ; set the volume to zero
    ldx #0
    stx vol1
    stx vol2

    ldy measure
    lda song1,y

    ; Check to see if the end of the song was reached
    cmp #255
    bne notEndOfSong

    ; Go back to the first measure
    stx measure
    lda song1,x

notEndOfSong
    jsr playPattern

    ldy measure
    lda song2,y

    ldx #1
    jsr playPattern

    rts ; since song player is now in bank 7 along with its caller

    ; songPlayer
;--------------------------------------------------------------------------
