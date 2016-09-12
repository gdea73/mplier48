        .equ __P24FJ64GA002,1
        .include "p24Fxxxx.inc"

#include "xc.inc"

        config __CONFIG2, POSCMOD_EC & I2C1SEL_SEC & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSECME & FNOSC_FRCPLL & SOSCSEL_LPSOSC & WUTSEL_FST & IESO_OFF
        config __CONFIG1, WDTPS_PS1 & FWPSA_PR32 & WINDIS_OFF & FWDTEN_OFF & COE_ON & BKBUG_ON & GWRP_ON & GCP_ON & JTAGEN_OFF

    .bss
mplier:     .space  6
mcand:	    .space  6
product:    .space 12
    
placeholder: .space 2
    .text
    .global _main
values48:
    .WORD   0xffff, 0xffff, 0xffff
a:
    .WORD   0x0005, 0xDEEc, 0xE66D
    
; 48-bit multiplier subroutine; can be implemented by placing the 48-bit numbers in W0-W5 (beginning with most significant byte)
mply48:
    mov #mplier,W14	; W0	AH
    mov [W14++],W0	; W1	AM
    mov [W14++],W1	; W2	AL
    mov [W14],W2	; W3	BH
    mov #mcand,W14	; W4	BM
    mov [W14++],W3	; W5	BL
    mov [W14++],W4
    mov [W14++],W5
    mov #product,W14
    add #10,W14
    mul.uu W5,W2,W6	; BL * AL
    mul.uu W5,W1,W8	; BL * AM
    mul.uu W5,W0,W10	; BL * AH
    mov W6,[W14]	; ALBL (L) --> LSB
    dec2 WREG14
    add W7,W8,[W14--]	; ALBL (H) + BLAM (L)
    addc W9,W10,[W14]	; BLAM (H) + BLAH (L) + (C)
    addc W11,#0,W11	; BLAH (H) + (C)
    dec2 WREG14
    mov W11,[W14]	; BLAH (H) + (C) --> prod
    add #4,W14
    mul.uu W4,W2,W6	; BM * AL
    mul.uu W4,W1,W8	; BM * AM
    mul.uu W4,W0,W10	; BM * AH
    add W6,[W14],[W14--]	; BMAL (L)
    addc W7,W8,W12
    addc W9,#0,W9
    addc W12,[W14],[W14--]
    addc W9,#0,W9
    addc W9,W10,W12
    addc W11,#0,W11
    addc W12,[W14],[W14--]
    addc W11,#0,W11
    mov W11,[W14]
    add #4,W14
    mul.uu W3,W2,W6	; BH * AL
    mul.uu W3,W1,W8	; BH * AM
    mul.uu W3,W0,W10	; BH * AH
    add W6,[W14],[W14--]	; BMAL (L)
    addc W7,W8,W12
    addc W9,#0,W9
    addc W12,[W14],[W14--]
    addc W9,#0,W9
    addc W9,W10,W12
    addc W11,#0,W11
    addc W12,[W14],[W14--]
    addc W11,#0,W11
    mov W11,[W14]
