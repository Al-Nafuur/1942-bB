
draw_gameselect_display
       lda #0
        sta GRP0
        sta GRP1

        ldy #4
        sty aux2

	lda bmp_gameselect_color
	sta COLUP0
	sta COLUP1

	;change gamenumber to a BCD number and stick it in temp5
	lda gamenumber
	sta temp3 
	lda #0
	sta temp4
	ldx #8
	clc
	sed
converttobcd
	asl temp3
	lda temp4
	adc temp4
	sta temp4
	dex
	bne converttobcd
	cld

	lda temp4
	and #$0f
	sta temp3
	asl
	asl
	clc
	adc temp3 ; *5
	clc
	adc #<(font_gameselect_img)
	sta scorepointers+10

	lda temp4
	and #$f0
	lsr
	lsr
	sta temp3
	lsr
	lsr
	clc
	adc temp3 ; *5
	clc
	adc #<(font_gameselect_img)
	sta scorepointers+8
	

        ;setup score pointers to point at my bitmap slices instead
        lda #<(bmp_gameselect_CHAR0)
        sta scorepointers+0
        lda #>(bmp_gameselect_CHAR0)
        sta scorepointers+1
        lda #<(bmp_gameselect_CHAR1)
        sta scorepointers+2
        lda #>(bmp_gameselect_CHAR1)
        sta scorepointers+3
        lda #<(bmp_gameselect_CHAR2)
        sta scorepointers+4
        lda #>(bmp_gameselect_CHAR2)
        sta scorepointers+5
        lda #<(bmp_gameselect_CHAR3)
        sta scorepointers+6
        lda #>(bmp_gameselect_CHAR3)
        sta scorepointers+7

        lda #>(font_gameselect_img)
        sta scorepointers+9

        lda #>(font_gameselect_img)
        sta scorepointers+11

	jmp draw_bmp_48x1_X
