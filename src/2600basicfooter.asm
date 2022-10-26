; Provided under the CC0 license. See the included LICENSE.txt for details.

 ifconst bankswitch
   if bankswitch == 8
    ifconst PlusROM_functions
     ORG $2FF0
     RORG $FFF0
     .byte 0   ; WriteToBuffer
     .byte 0   ; WriteSendBuffer
     .byte 0   ; ReceiveBuffer
     .byte $ff ; ReceiveBufferSize (none zero for detection of PlusROM support)
     ORG $2FFA
     RORG $FFFA
     .word (PlusROM_API)
    else
     ORG $2FFC
     RORG $FFFC
    endif   
   endif
   if bankswitch == 16
    ifconst PlusROM_functions
     ORG $4FF0
     RORG $FFF0
     .byte 0   ; WriteToBuffer
     .byte 0   ; WriteSendBuffer
     .byte 0   ; ReceiveBuffer
     .byte $ff ; ReceiveBufferSize (none zero for detection of PlusROM support)
     ORG $4FFA
     RORG $FFFA
     .word (PlusROM_API)
    else
     ORG $4FFC
     RORG $FFFC
    endif   
   endif
   if bankswitch == 32
    ifconst PlusROM_functions
     ORG $8FF0
     RORG $FFF0
     .byte 0   ; WriteToBuffer
     .byte 0   ; WriteSendBuffer
     .byte 0   ; ReceiveBuffer
     .byte $ff ; ReceiveBufferSize (none zero for detection of PlusROM support)
     ORG $8FFA
     RORG $FFFA
     .word (PlusROM_API)
    else
     ORG $8FFC
     RORG $FFFC
    endif   
   endif
   if bankswitch == 64
     ORG  $10FF0
     RORG $1FFF0
     lda $ffe0 ; we use wasted space to assist stella with EF format auto-detection
     ORG  $10FF8
     RORG $1FFF8
     ifconst superchip 
       .byte "E","F","S","C"
     else
       .byte "E","F","E","F"
     endif
     ORG  $10FFC
     RORG $1FFFC
   endif
 else
   ifconst ROM2k
    ifconst PlusROM_functions
     ORG $F7FA
     .word (PlusROM_API)
    else
     ORG $F7FC
    endif   
   else
    ifconst PlusROM_functions
     ORG $FFFA
     .word (PlusROM_API)
    else
     ORG $FFFC
    endif   
   endif
 endif
 .word (start & $ffff)
 .word (start & $ffff)
