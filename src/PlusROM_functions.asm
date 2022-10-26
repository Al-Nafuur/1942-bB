PlusROM_functions       = 1
WriteToBuffer           = $1ff0
WriteSendBuffer         = $1ff1
ReceiveBuffer           = $1ff2
ReceiveBufferSize       = $1ff3

   MAC SET_PLUSROM_API   ; {1} = path, {2} = domain
OLD_RORG = *
   REND
PlusROM_API
   .byte {1}, 0, {2}, 0
   ECHO "Size of PlusROM API definition: ", [( * - PlusROM_API )]d
   RORG (OLD_RORG + ( * - PlusROM_API ))
   ENDM
   