; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; this file can be used to assemble a Koala-painter image file,
; containing Elite's default menu screen (no HUD)
;
; a Koala format is essentially a memory-dump of the
; separate graphics/colour components the VIC-II uses:
;
;          2 bytes - PRG header (deafult "$6000")
;       8000 bytes - bitmap data
;       1000 bytes - screen RAM
;       1000 bytes - colour RAM
;          1 byte  - background colour
;
; even though Elite doesn't store its bitmap at $6000, Koala files
; are often recognised by this header, so for compatibility with
; image editors, we stick to $6000
;
        .addr   $6000

; bitmap data                                                     original-addr
;===============================================================================
; ROW 0                                                                 ;$4000
;-------------------------------------------------------------------------------
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  0
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  1
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  2
        .byte   $03, $03, $03, $03, $03, $03, $03, $03  ; COL  3
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL  4
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL  5
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL  6
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL  7
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL  8
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL  9
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 10
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 11
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 12
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 13
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 14
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 15
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 16
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 17
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 18
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 19
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 20
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 21
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 22
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 23
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 24
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 25
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 26
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 27
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 28
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 29
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 30
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 31
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 32
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 33
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 34
        .byte   $ff, $00, $00, $00, $00, $00, $00, $00  ; COL 35
        .byte   $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0  ; COL 36
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 37
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 38
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 39
;-------------------------------------------------------------------------------
; ROWS 1-23
;-------------------------------------------------------------------------------
.repeat 23
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  0
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  1
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  2
        .byte   $03, $03, $03, $03, $03, $03, $03, $03  ; COL  3
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL  4
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL  5
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL  6
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL  7
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL  8
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL  9
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 10
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 11
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 12
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 13
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 14
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 15
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 16
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 17
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 18
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 19
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 20
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 21
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 22
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 23
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 24
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 25
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 26
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 27
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 28
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 29
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 30
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 31
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 32
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 33
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 34
        .byte   $00, $00, $00, $00, $00, $00, $00, $00  ; COL 35
        .byte   $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0  ; COL 36
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 37
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 38
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 39
.endrep
;-------------------------------------------------------------------------------
; ROW 24
;-------------------------------------------------------------------------------
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  0
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  1
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL  2
        .byte   $03, $03, $03, $03, $03, $03, $03, $03  ; COL  3
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL  4
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL  5
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL  6
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL  7
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL  8
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL  9
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 10
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 11
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 12
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 13
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 14
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 15
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 16
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 17
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 18
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 19
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 20
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 21
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 22
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 23
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 24
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 25
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 26
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 27
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 28
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 29
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 30
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 31
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 32
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 33
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 34
        .byte   $00, $00, $00, $00, $00, $00, $00, $ff  ; COL 35
        .byte   $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0  ; COL 36
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 37
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 38
        .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; COL 39
;===============================================================================
; screen RAM                                                            ;$6000
;===============================================================================
; ROW 0
;-------------------------------------------------------------------------------
        .byte   $00, $00, $00, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $00, $00, $00
;-------------------------------------------------------------------------------
; ROWS 1-23
;-------------------------------------------------------------------------------
.repeat 23
        .byte   $00, $00, $00, $70, $10, $10, $10, $10
        .byte   $10, $10, $10, $10, $10, $10, $10, $10
        .byte   $10, $10, $10, $10, $10, $10, $10, $10
        .byte   $10, $10, $10, $10, $10, $10, $10, $10
        .byte   $10, $10, $10, $10, $70, $00, $00, $00
.endrep
;-------------------------------------------------------------------------------
; ROW 24
;-------------------------------------------------------------------------------
        .byte   $00, $00, $00, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $70, $70, $70
        .byte   $70, $70, $70, $70, $70, $00, $00, $00
;===============================================================================
; color RAM                                                             ;$D800
;===============================================================================
; ROW 0
;-------------------------------------------------------------------------------
        .byte   $00, $00, $00, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $00, $00, $00
;-------------------------------------------------------------------------------
; ROWS 1-23
;-------------------------------------------------------------------------------
.repeat 23
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
.endrep
;-------------------------------------------------------------------------------
; ROW 24
;-------------------------------------------------------------------------------
        .byte   $00, $00, $00, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $07, $07, $07
        .byte   $07, $07, $07, $07, $07, $00, $00, $00
;===============================================================================
; background colour:
;===============================================================================
        .byte   $00     ;=black