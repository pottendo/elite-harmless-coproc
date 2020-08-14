; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; cobra mk-III
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_COBRAMK3           := hull_index                                   ;=$0B

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_COBRAMK3_KILL      = 234   ;= 0.91

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_cobramk3                                           ;$D014/5

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $a0                                                     ;$D04C

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_COBRAMK3_KILL                                    ;$D06D

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_COBRAMK3_KILL                                    ;$D08E

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_cobramk3                                                   ;$D8C3
        ;-----------------------------------------------------------------------
        .byte                  $03, $41, $23, $bc, $54                  ;$D8C3
        .byte   $9d, $54, $2a, $a8, $26, $00, $00, $34
        .byte   $32, $96, $1c, $00, $01, $01, $13, $20                  ;$D8D0
        .byte   $00, $4c, $1f, $ff, $ff, $20, $00, $4c
        .byte   $9f, $ff, $ff, $00, $1a, $18, $1f, $ff                  ;$D8E0
        .byte   $ff, $78, $03, $08, $ff, $73, $aa, $78
        .byte   $03, $08, $7f, $84, $cc, $58, $10, $28                  ;$D8F0
        .byte   $bf, $ff, $ff, $58, $10, $28, $3f, $ff
        .byte   $ff, $80, $08, $28, $7f, $98, $cc, $80                  ;$D900
        .byte   $08, $28, $ff, $97, $aa, $00, $1a, $28
        .byte   $3f, $65, $99, $20, $18, $28, $ff, $a9                  ;$D910
        .byte   $bb, $20, $18, $28, $7f, $b9, $cc, $24
        .byte   $08, $28, $b4, $99, $99, $08, $0c, $28                  ;$D920
        .byte   $b4, $99, $99, $08, $0c, $28, $34, $99
        .byte   $99, $24, $08, $28, $34, $99, $99, $24                  ;$D930
        .byte   $0c, $28, $74, $99, $99, $08, $10, $28
        .byte   $74, $99, $99, $08, $10, $28, $f4, $99                  ;$D940
        .byte   $99, $24, $0c, $28, $f4, $99, $99, $00
        .byte   $00, $4c, $06, $b0, $bb, $00, $00, $5a                  ;$D950
        .byte   $1f, $b0, $bb, $50, $06, $28, $e8, $99
        .byte   $99, $50, $06, $28, $a8, $99, $99, $58                  ;$D960
        .byte   $00, $28, $a6, $99, $99, $50, $06, $28
        .byte   $28, $99, $99, $58, $00, $28, $26, $99                  ;$D970
        .byte   $99, $50, $06, $28, $68, $99, $99, $1f
        .byte   $b0, $00, $04, $1f, $c4, $00, $10, $1f                  ;$D980
        .byte   $a3, $04, $0c, $1f, $a7, $0c, $20, $1f
        .byte   $c8, $10, $1c, $1f, $98, $18, $1c, $1f                  ;$D990
        .byte   $96, $18, $24, $1f, $95, $14, $24, $1f
        .byte   $97, $14, $20, $1f, $51, $08, $14, $1f                  ;$D9A0
        .byte   $62, $08, $18, $1f, $73, $0c, $14, $1f
        .byte   $84, $10, $18, $1f, $10, $04, $08, $1f                  ;$D9B0
        .byte   $20, $00, $08, $1f, $a9, $20, $28, $1f
        .byte   $b9, $28, $2c, $1f, $c9, $1c, $2c, $1f                  ;$D9C0
        .byte   $ba, $04, $28, $1f, $cb, $00, $2c, $1d
        .byte   $31, $04, $14, $1d, $42, $00, $18, $06                  ;$D9D0
        .byte   $b0, $50, $54, $14, $99, $30, $34, $14
        .byte   $99, $48, $4c, $14, $99, $38, $3c, $14                  ;$D9E0
        .byte   $99, $40, $44, $13, $99, $3c, $40, $11
        .byte   $99, $38, $44, $13, $99, $34, $48, $13                  ;$D9F0
        .byte   $99, $30, $4c, $1e, $65, $08, $24, $06
        .byte   $99, $58, $60, $06, $99, $5c, $60, $08                  ;$DA00
        .byte   $99, $58, $5c, $06, $99, $64, $68, $06
        .byte   $99, $68, $6c, $08, $99, $64, $6c, $1f                  ;$DA10
        .byte   $00, $3e, $1f, $9f, $12, $37, $10, $1f
        .byte   $12, $37, $10, $9f, $10, $34, $0e, $1f                  ;$DA20
        .byte   $10, $34, $0e, $9f, $0e, $2f, $00, $1f
        .byte   $0e, $2f, $00, $9f, $3d, $66, $00, $1f                  ;$DA30
        .byte   $3d, $66, $00, $3f, $00, $00, $50, $df
        .byte   $07, $2a, $09, $5f, $00, $1e, $06, $5f                  ;$DA40
        .byte   $07, $2a, $09

.endproc