# MAIN
.text 0x0000
.data 0x2000
.global _dat
_dat:
.word 15
.word 240
.word 3840 
.word 61440
.word 983040 
.word 15728640 
.word 251658240 
.word 268435456
.word 536870912 

.text
.proc _fsum
.global _fsum
_fsum:
    xor r0, r0, r0
    xor r4, r4, r4
    xor r6, r6, r6
    movi2fp f1, r6
    cvti2f f2, f1
    cvti2f f3, f1
    addi r6, r0, 32

_loop:
    lw r4, _dat(r6)
    movi2fp f1, r4
    cvti2f f2, f1
    nop
    addf f3, f2, f3 
    subi r6, r6, 4
    bnez r6, _loop
    cvtf2i f1, f3
    nop
    movfp2i r4, f1
    sw _dat(r0), r4
.endproc _fsum

