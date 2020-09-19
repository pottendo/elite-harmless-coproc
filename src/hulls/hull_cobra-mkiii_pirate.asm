; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; combra mk-III (pirate)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_MK3_PIRATE         := hull_index                                   ;=$18

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_MK3_PIRATE_KILL    = 298   ;= 1.16

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_mk3_pirate                                         ;$D02E/F

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D059

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_MK3_PIRATE_KILL                                  ;$D07A

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_MK3_PIRATE_KILL                                  ;$D09B

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_mk3_pirate                                                 ;$E50B
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 1 debris:
        .scoop_debris   0, 1                                            ;$E50B
        
        .byte                       $41, $23, $bc, $54                  ;$E50C
        .byte   $9d, $54, $2a, $a8, $26, $af, $00, $34                  ;$E510
        .byte   $32, $96, $1c, $00, $01, $01, $12, $20
        .byte   $00, $4c, $1f, $ff, $ff, $20, $00, $4c                  ;$E520
        .byte   $9f, $ff, $ff, $00, $1a, $18, $1f, $ff
        .byte   $ff, $78, $03, $08, $ff, $73, $aa, $78                  ;$E530
        .byte   $03, $08, $7f, $84, $cc, $58, $10, $28
        .byte   $bf, $ff, $ff, $58, $10, $28, $3f, $ff                  ;$E540
        .byte   $ff, $80, $08, $28, $7f, $98, $cc, $80
        .byte   $08, $28, $ff, $97, $aa, $00, $1a, $28                  ;$E550
        .byte   $3f, $65, $99, $20, $18, $28, $ff, $a9
        .byte   $bb, $20, $18, $28, $7f, $b9, $cc, $24                  ;$E560
        .byte   $08, $28, $b4, $99, $99, $08, $0c, $28
        .byte   $b4, $99, $99, $08, $0c, $28, $34, $99                  ;$E570
        .byte   $99, $24, $08, $28, $34, $99, $99, $24
        .byte   $0c, $28, $74, $99, $99, $08, $10, $28                  ;$E580
        .byte   $74, $99, $99, $08, $10, $28, $f4, $99
        .byte   $99, $24, $0c, $28, $f4, $99, $99, $00                  ;$E590
        .byte   $00, $4c, $06, $b0, $bb, $00, $00, $5a
        .byte   $1f, $b0, $bb, $50, $06, $28, $e8, $99                  ;$E5A0
        .byte   $99, $50, $06, $28, $a8, $99, $99, $58
        .byte   $00, $28, $a6, $99, $99, $50, $06, $28                  ;$E5B0
        .byte   $28, $99, $99, $58, $00, $28, $26, $99
        .byte   $99, $50, $06, $28, $68, $99, $99, $1f                  ;$E5C0
        .byte   $b0, $00, $04, $1f, $c4, $00, $10, $1f
        .byte   $a3, $04, $0c, $1f, $a7, $0c, $20, $1f                  ;$E5D0
        .byte   $c8, $10, $1c, $1f, $98, $18, $1c, $1f
        .byte   $96, $18, $24, $1f, $95, $14, $24, $1f                  ;$E5E0
        .byte   $97, $14, $20, $1f, $51, $08, $14, $1f
        .byte   $62, $08, $18, $1f, $73, $0c, $14, $1f                  ;$E5F0
        .byte   $84, $10, $18, $1f, $10, $04, $08, $1f
        .byte   $20, $00, $08, $1f, $a9, $20, $28, $1f                  ;$E600
        .byte   $b9, $28, $2c, $1f, $c9, $1c, $2c, $1f
        .byte   $ba, $04, $28, $1f, $cb, $00, $2c, $1d                  ;$E610
        .byte   $31, $04, $14, $1d, $42, $00, $18, $06
        .byte   $b0, $50, $54, $14, $99, $30, $34, $14                  ;$E620
        .byte   $99, $48, $4c, $14, $99, $38, $3c, $14
        .byte   $99, $40, $44, $13, $99, $3c, $40, $11                  ;$E630
        .byte   $99, $38, $44, $13, $99, $34, $48, $13
        .byte   $99, $30, $4c, $1e, $65, $08, $24, $06                  ;$E640
        .byte   $99, $58, $60, $06, $99, $5c, $60, $08
        .byte   $99, $58, $5c, $06, $99, $64, $68, $06                  ;$E650
        .byte   $99, $68, $6c, $08, $99, $64, $6c, $1f
        .byte   $00, $3e, $1f, $9f, $12, $37, $10, $1f                  ;$E660
        .byte   $12, $37, $10, $9f, $10, $34, $0e, $1f
        .byte   $10, $34, $0e, $9f, $0e, $2f, $00, $1f                  ;$E670
        .byte   $0e, $2f, $00, $9f, $3d, $66, $00, $1f
        .byte   $3d, $66, $00, $3f, $00, $00, $50, $df                  ;$E680
        .byte   $07, $2a, $09, $5f, $00, $1e, $06, $5f
        .byte   $07, $2a, $09                                           ;$E690

.endproc