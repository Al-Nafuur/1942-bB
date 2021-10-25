; Paul Slocum
; http://qotile.net
;
;
; (any text to the right of a semicolon is a comment)
;
;-------------------------------------------------------------
; SONG DATA FILE
;-------------------------------------------------------------
;
; This file contains all the data that makes up a song for
; the song player.  By editing this file, you can write your
; own music on the 2600.  The process involves writing short 
; note patterns. arranging them
; by fours into full patterns, then sequencing those patterns
; into a song.  After you write a pattern, you'll add it to the
; pattern arrays, and then can use it in one or both of the song
; pattern lists.  There are also other parameters you can adjust
; like the auto high hat and tempo.  
; 
; This file contains data for a short demo song and I've
; explained everything that I've done.
;
; To learn how the song file works, I suggest that
; you scroll down to the bottom of this file and 
; look at the patterns first, then work your way up
; to the pattern arrays and then the song pattern
; lists.
;
; This file explains the mechanics of how to create a song,
; but for note tables and lots of tips and tricks you'll
; want to get my 2600 music programming guide off my
; website.
;



;-------------------------------------------------------------
; Tempo
;-------------------------------------------------------------
; TEMPODELAY sets the song tempo.  Higher values mean a slower
; song.  1 is extremely fast and 10 is very slow.  The tempo 
; is currently only adjustable in very large increments.
; Future versions of the software will allow more precise tempo
; settings.  Typically I use a TEMPODELAY or 3 or 4.

TEMPODELAY equ 4



;-------------------------------------------------------------
; Sound Attenuation Array
;-------------------------------------------------------------
; This section allows you to change the volume
; of each sound type globally.  Many times you'll
; have a certain sound that ends up being too loud,
; You can fix that here.  Note that a larger value
; makes the sound quieter.  Set all 8 values to zero
; if you want all sounds at full volume.  10 is probably 
; about the highest amount of attenuation you'll want.
;
; 000=square  001=bass  010=pitfall  011=noise
; 100=buzz    101=lead  110=saw      111=lowbass
soundTurnArray
	byte 7, 4, 0, 3, 7



;-------------------------------------------------------------
; Sound Type Array
;-------------------------------------------------------------
; This array allows you to change the sound types
; that are encoded into the first three bits of
; notes (discusses later.)  I'd suggest leaving
; this array alone until you are pretty comfortable
; writing music for the 2600.  I rarely change these
; settings.
;
; There are only 10 unique sound types on the Atari.
; I've selected the 8 sound types that
; I think are the most useful.  The two that I have not 
; included in the default setup are 2 and 14.  2 is a 
; low rumble engine sound and 14 is a very low bass 
; sound.  In addition to replacing a default sound
; with 2 or 14, you could also use this array to gain
; more precise volume control over a sound.  Say
; you want more control over the Square sound:  Just
; replace a sound you aren't using with another
; Square (4) and then using the Sound Attenuation
; Array, you can have a loud Square sound and a 
; quieter Square. 
;
;
; Default Sound Type Setup:
; 000 0 Square  = 4
; 001 1 Bass    = 6
; 010 2 Pitfall = 7
; 011 3 Noise   = 8
;
; 100 4 Buzz    = 15
; 101 5 Lead    = 12
; 110 6 Saw     = 1
; 111 7 Engine  = 3
;
soundTypeArray
    byte 1,4,6,12,7 ; saw, square, bass, lead, pitfall

audc1 = $00 << 5
audc4 = $01 << 5
audc6 = $02 << 5
audcc = $03 << 5
audc7 = $04 << 5


;-------------------------------------------------------------
; Auto High Hat
;-------------------------------------------------------------
; The latest driver has built-in support to
; play a high-hat sound.  This allows you to have
; a high hat rhythm playing without having to add it to
; your pattern data.  The driver plays the high-hat
; click very short, so often you will barely notice
; any interference with your song.  It plays on
; the same oscillator as the "song2" list of patterns.
; If it is interfering with your music too much,
; just swap song1 and song2.
;
; You specify the high hat pattern in hatPattern.  Each
; bit corresponds to one 32nd note.  Set the bit to one
; to have it play on that beat, or zero to mute the high
; hat on that beat.  The pattern repeats each measure.
;
; You can also specify the measure that the high hat
; starts playing with HATSTART.  You may want to have
; and intro part without the high hat then have it
; come in later.  Or if you don't want to use it at all,
; then set HATSTART to 255.
;
; Finally, you can specify the high hat volume (0-15), the
; pitch (0-31), and the high hat sound type.  Refer to the
; table above for sound type values.  I typically use
; sound type 8 (Noise) and pitch 0 which sounds like a pretty
; good high hat.  But you may find other interesting settings.
;

hatPattern
	;byte %10000010
	;byte %00000010
	;byte %00001000
	;byte %10001010


HATSTART equ 255

HATVOLUME equ 0
HATPITCH equ 0
HATSOUND equ 8


;-------------------------------------------------------------
; Song Data
;-------------------------------------------------------------
; song1 and song2 are lists of four pattern sets to be
; played out of patternArrayH and patternArrayL.
; Both song1 and song2 will be played simlutaneously 
; by the software, one on each of the two oscillators,
; so each song should be exactly the same length or you
; may have some problems!  
;
; Each number (after "byte") refers
; to a four pattern set in the patternArrayH (loud
; patterns) or patternArrayL (softer patterns).  
;
; "song1" and "song2" must be against the left
; edge, and each "byte" statement must have at
; least one space or tab to the left of it.  I
; have only put two pattern numbers on each line
; but you can put as many as you want (each number
; separated by a comma).  A song cannot
; exceed 255 patterns.
;
; You must put a 255 at the end of the pattern list
; to let the driver know that it has reached the end.
; The player will automatically loop back to the beginning
; of the song when it reaches the end.
;
; I suggest that you comment your songs so you can
; remember what's going on where.  (Use a semicolon
; to indicate a comment)


song1
	byte 17,18,19,20,21,22,23,24,25,26,27,28 ; melody
	byte 255 ; end marker


song2
	byte 1,2,3,4,5,3,6,7,8,9,10,8 ; bass
	byte 255 ; end marker


;-------------------------------------------------------------
; Pattern Arrays
;-------------------------------------------------------------
; The pattern arrays contains sets of four patterns. The
; numbers in the song1 and song2 lists reference
; the pattern arrays.
;
; There are two pattern arrays.  Patterns in 
; patternArrayH will play louder, while patterns 
; in patternArrayL will play softer.  This gives you
; a bit more control over volume.  You can even have
; a soft and loud version of the same pattern.
;
; In my original driver, patterns were a full measure
; long.  The reason I've divided the patterns into
; fours is because it results in a lot more reuse of
; pattern data.  You can reuse patterns as much as
; you want.  For example, you may have a drum beat
; and want to add a fill.  You can reuse the first
; three patterns, and create a new fill pattern
; for the end of the measure.  This ends up saving
; a lot of space.
;
; I always put a comment
; to the right with the pattern number so when I'm 
; writing the song (above) I can easily see the number
; of the pattern.  
;
; You'll find data for each of these patterns below.
; Make sure the name in the patternArray matches the
; name below or you'll get an error.  patternArrayL
; and patternArrayH may have a maximum of 64 sets of
; 4 patterns each.
;
; Note that pattern sets in patternArrayH start at
; zero, while pattern sets in patternArrayL start at
; 128.
;


	; Higher volume patterns
patternArrayH 						; starts at 0

	word mute,mute,mute,mute ; 0

	word m0ab,m0bb,m1b,m0ab ; 1
	word m0bb,m1b,m4ab,m4bb ; 2
	word m5b,m4ab,m4bb,m5b ; 3
	word m4ab,m4bb,m5b,m4ab ; 4
	word m4bb,m5b,m4ab,m4bb ; 5
	word m16ab,m16bb,m17b,m16ab ; 6
	word m16bb,m17b,m20ab,m20bb ; 7
	word m21b,m20ab,m20bb,m21b ; 8
	word m20ab,m20bb,m21b,m20ab ; 9
	word m20bb,m21b,m20ab,m20bb ; 10
	word mute,mute,mute,mute ; 11
	word mute,mute,mute,mute ; 12
	word mute,mute,mute,mute ; 13
	word mute,mute,mute,mute ; 14
	word mute,mute,mute,mute ; 15
	word mute,mute,mute,mute ; 16

	word m0at,m0bt,m1t,m0at ; 17
	word m0bt,m1t,m4at,m4bt ; 18
	word m5t,m6t,m6t,m7t ; 19
	word m4at,m4bt,m9t,m9t ; 20
	word m9t,m11t,m4at,m4bt ; 21
	word m13t,m14at,m14bt,m15t ; 22
	word m16at,m16bt,m16bt,m16bt ; 23
	word m16bt,m19t,m20at,m20bt ; 24
	word m21t,m22t,m22t,m23t ; 25
	word m20at,m24bt,m25t,m25t ; 26
	word m25t,m27t,m20at,m24bt ; 27
	word m29t,m30at,m30bt,m31t ; 28
	word mute,mute,mute,mute ; 29

	; Lower volume patterns
;patternAttL = 0 ; override attenuation, play this at full volume too
patternArrayL 						; start at 128


;-------------------------------------------------------------
; Pattern Data
;-------------------------------------------------------------
; This is where the note patterns are defined.  Each pattern
; is a quarter note long and is divided into 8 steps (32nd
; notes).  Each step in the pattern specifies the pitch
; and sound type for that pitch.  These patterns are
; arranged by fours into full measure patterns in the
; pattern arrays above.
;
; Way below you'll find data for the patterns listed in the
; pattern arrays above.  Each one has a name and is followed
; by 9 bytes (numbers) of data.  Each of
; the first 8 numbers in the data set represents 
; a 32nd note step.  The byte after that determines
; which 32nd notes are accented (louder).
;
; It is very helpful if you reuse patterns you've written.
; Find one that's similar to what you need, copy it, 
; and modify it.
; 
; Note that the percent sign means that you
; are entering a binary number.
;
;
; Note Encoding
; ----------------------------------------------------------
;
; The 8 note numbers are encoded with sound type and pitch.
; I put two 32nd notes per line like this:
;
;	byte %00111000, %00111000
;
; The first three bits (1's and  0's) determine the 
; sound type according to the following table:
;
; 000 Square  (high square wave)
; 001 Bass    (fat bass sound)
; 010 Pitfall (sound of hitting a lot in pitfall)
; 011 Noise   (white noise)
; 100 Buzz    (hard buzzy sound)
; 101 Lead    (lower square wave)
; 110 Saw     (sounds kind of like a sawtooth wave)
; 111 Engine  (engine sound)
;
;
; The remaining 5 bits determine the pitch.
;
; 11111 is a very low pitch
; 00001 us a very high pitch
; 00100 is somewhere in between
;
; (!) Note that 255 or %11111111 means no sound (a rest)
;
; Some examples:
;
; %00111100 = bass with a low pitch
; %10000010 = buzz sound with a high pitch
; %11100101 = engine sound with a medium pitch
; %11111111 = no sound
;
;
; The pitch on the Atari is not all on a musical scale,
; so you'll end up with some really out-of-tune stuff
; if you aren't careful.  Refer to my 2600 music 
; programming guide for some sets of in-tune notes.
;
;
; Accent Encoding
; ----------------------------------------------------------
;
; There will be ninth number at the end of each pattern like:
;  
;	byte %10001000
;
; This determines which notes are accented.  Good accents can 
; really make a pattern a lot better.  Notice there are 
; 8 bits, and conveniently they correspond to each of the 8
; notes in the pattern!  The way I have it set up above, 
; accents fall on each 8th note.  
;
; 1 = accent (loud), 0 = no accent (no as loud)
; 
; To just make the whole beat quieter, use all zeros:
;
; byte %00000000
;
; To make the whole beat louder:
;
; byte %11111111
;
; Here's an accent pattern I use often:
;
; byte %10001000
;
;
;
; Patterns:
; ----------------------------------------------------------
;
; Here are the patterns for my example song.  
; I try to name them
; meaningful names so I'll remember what they are.  
; You can name then whatever you want, just
; make sure your names start with a letter.


; I always have a muted pattern.
; You'll pretty much always need this.

mute
	byte 255,255,255,255
	byte 255,255,255,255

	byte 255

; 1942/C64 title music

rst= $ff
e5 = audc4 | $16 ; tonic, +18.72
e4 = audc6 | $02 ; tonic
b3 = audc6 | $03 ; 5th
a3 = audcc | $16 ; 4th, +18.72
gs3= audcc | $18 ; major 3rd, -13.91
fs3= audcc | $1b ; major 2nd, -6.19
e3 = audcc | $1e ; tonic
b2 = audc6 | $07 ; 5th
e2 = audc6 | $0b ; tonic
b1 = audc6 | $0f ; 5th
e1 = audc6 | $17 ; tonic
b0 = audc6 | $1f ; 5th

; used in both: fs3 gs3 b3

; notes used only after modulation to F#
cs4= audc1 | $0e ; 5th, -13.91
;as3= audcc | $15 ; major 3rd, +3.49
as3= audc1 | $08 ; major 3rd, -35.41
cs3= audc1 | $0e ; 5th, -13.91
;cs3= audcc | $12 ; 5th, -36.84
as2= audc1 | $11 ; major 3rd, -35.41
fs2= audc6 | $0a ; tonic, -31.77
cs2= audc1 | $1d ; 5th, -13.91
fs1= audc6 | $15 ; tonic, -31.77
cs1= audc6 | $1c ; 5th, -11.98

; TODO: shift notes for pattern sharing if possible
; in 3/4 (or 6/8) time, each entry here is a 16th note
m0ab ; measure 0 part 1 bass
	byte e2 ,e2 ,e2 ,e2 ,e2 ,e2 ,b1 ,b1 
	byte %10000010

m0bb ; measure 0-1 bass
	byte b1 ,b1 ,b1 ,b1 ,e2 ,e2 ,rst,rst
	byte %00001000

m1b ; measure 1 part 2 bass
	byte e2 ,e2 ,rst,rst,b1 ,b1 ,rst,rst
	byte %10001000

m4ab ; measure 4 part 1 bass
	byte e1 ,e1 ,e1 ,e1 ,e2 ,rst,e2 ,rst
	byte %10001010

m4bb ; measure 4-5 bass
	byte e2 ,rst,e2 ,rst,e1 ,e1 ,e1 ,e1 
	byte %10101000

m5b ; measure 5 part 2 bass
	byte e2 ,rst,e2 ,rst,e2 ,rst,e2 ,rst
	byte %10101010

m16ab ; measure 16 part 1 bass
	byte cs1,cs1,cs1,cs1,cs2,rst,cs2,rst
	byte %10001010

m16bb ; measure 16-17 bass
	byte cs2,rst,cs2,rst,cs1,cs1,cs1,cs1
	byte %10101000

m20ab ; measure 20 part 1 bass
	byte fs1,fs1,fs1,fs1,fs2,rst,fs2,rst
	byte %10001010

m20bb ; measure 20-21 bass
	byte fs2,rst,fs2,rst,fs1,fs1,fs1,fs1
	byte %10101000

m21b ; measure 21 part 2 bass
	byte fs2,rst,fs2,rst,fs2,rst,fs2,rst
	byte %10101010

m17b ; measure 17 part 2 bass
	byte cs2,rst,cs2,rst,cs2,rst,cs2,rst
	byte %10101010

m0at ; measure 0 part 1 treble
	byte e5 ,rst,e5 ,rst,e5 ,rst,e5 ,rst
	byte %10101010

m0bt ; measure 0-1 treble
	byte e5 ,rst,e5 ,rst,e5 ,e5 ,e5 ,rst
	byte %10101000

m1t ; measure 1 part 2 treble
	byte e5 ,e5 ,e5 ,rst,e5 ,rst,e5 ,rst
	byte %10001010

m4at ; measure 4 part 1 treble
	byte b2 ,rst,b2 ,rst,b2 ,rst,e3 ,rst
	byte %10101010

m4bt ; measure 4-5 treble
	byte fs3,rst,a3 ,rst,gs3,gs3,gs3,gs3
	byte %10101000

; if run low on space, substitute m6t for this
m5t ; measure 5 part 2 treble
	byte b3 ,b3 ,b3 ,b3 ,b3 ,b3 ,b3 ,b3 
	byte %10000000

m6t ; measure 6 part 1, 6-7 treble
	byte b3 ,b3 ,b3 ,b3 ,b3 ,b3 ,b3 ,b3 
	byte %00000000

; if run low on space, substitute m6t for this
m7t ; measure 7 part 2 treble
	byte b3 ,b3 ,b3 ,b3 ,b3 ,b3 ,b3 ,rst
	byte %00000000

m9t ; measure 9 part 2 treble
	byte gs3,gs3,gs3,gs3,gs3,gs3,gs3,gs3
	byte %00000000

; if run low on space, substitute m9t for this
m11t ; measure 11 part 2 treble
	byte gs3,gs3,gs3,gs3,gs3,gs3,gs3,rst
	byte %00000000

m13t ; measure 13 part 2 treble
	byte e3 ,e3 ,e3 ,e3 ,fs3,rst,a3 ,rst
	byte %10001010

m14at ; measure 14 part 1 treble
	byte gs3,gs3,gs3,gs3,e3 ,e3 ,e3 ,e3 
	byte %10001000

m14bt ; measure 14-15 treble
	byte fs3,rst,a3 ,rst,gs3,gs3,gs3,gs3
	byte %10101000

m15t ; measure 15 part 2 treble
	byte e3 ,e3 ,e3 ,e3 ,gs3,rst,b3 ,rst
	byte %10001010

; if run low on space, substitute m16bt for this
m16at ; measure 16 part 1 treble
	byte cs4,cs4,cs4,cs4,cs4,cs4,cs4,cs4
	byte %10000000

m16bt ; measure 16-17 treble
	byte cs4,cs4,cs4,cs4,cs4,cs4,cs4,cs4
	byte %00000000

; if run low on space, substitute m16bt for this
m19t ; measure 19 part 2 treble
	byte cs4,cs4,cs4,cs4,cs4,cs4,cs4,rst
	byte %00000000

m20at ; measure 20 part 1 treble
	byte cs2,rst,cs2,rst,cs2,rst,fs3,rst
	byte %10101010

m20bt ; measure 20-21 treble
	byte gs3,rst,b3 ,rst,as2,as2,as2,as2
	byte %10101000

; if run low on space, substitute m22t for this
m21t ; measure 21 part 2 treble
	byte cs3,cs3,cs3,cs3,cs3,cs3,cs3,cs3
	byte %10000000

m22t ; measure 22 part 1, 22-23 treble
	byte cs3,cs3,cs3,cs3,cs3,cs3,cs3,cs3
	byte %00000000

; if run low on space, substitute m22t for this
m23t ; measure 23 part 2 treble
	byte cs3,cs3,cs3,cs3,cs3,cs3,cs3,rst
	byte %00000000

; if run low on space, substitute m20bt for this and update m25t and m27t
m24bt ; measure 24-25 treble
	byte gs3,rst,b3 ,rst,as3,as3,as3,as3
	byte %10100000 ; no accent for as3

m25t ; measure 25 part 2 treble
	byte as3,as3,as3,as3,as3,as3,as3,as3
	byte %00000000

; if run low on space, substitute m25t for this
m27t ; measure 27 part 2 treble
	byte as3,as3,as3,as3,as3,as3,as3,rst
	byte %00000000

m29t ; measure 29 part 2 treble
	byte fs3,fs3,fs3,fs3,gs3,rst,b3 ,rst
	byte %10001010

m30at ; measure 30 part 1 treble
	byte as3,as3,as3,as3,fs3,fs3,fs3,fs3
	byte %00001000 ; no accent for as3

m30bt ; measure 30-31 treble
	byte gs3,rst,b3 ,rst,as3,as3,as3,as3
	byte %10100000 ; no accent for as3

m31t ; measure 31 part 2 treble
	byte fs3,fs3,fs3,fs3,gs3,rst,as3,rst
	byte %10001000 ; no accent for as3

; after modulation:
; cs3 cs3 cs3 fs3 gs3 b3 as3 cs4
; cs3 cs3 cs3 fs3 gs3 b3 as3
; cs3 cs3 cs3 fs3 gs3 b3 as3 fs4 gs3 b3 as3 fs4 gs3 b3 as3 fs4...
