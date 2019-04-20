; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "code_init.asm" -- contains once-off intialisation code for elite-harmless;
; original Elite uses "orig_init.asm". this code is loaded into the variable
; space the game uses, so once executed it is erased! 

.include        "c64/c64.asm"
.include        "elite_consts.asm"
.include        "math_3d.asm"

.zeropage

ZP_COPY_TO      := $18
ZP_COPY_FROM    := $1a

.segment        "CODE_INIT"

init:
;===============================================================================
.export init

        ; change the address of STOP key routine from $F6ED, to $FFED,
        ; the SCREEN routine which returns row/col count, i.e. does
        ; nothing of use -- this effectively disables the STOP key
        lda # > KERNAL_SCREEN
        sta KERNAL_VECTOR_STOP + 1

        ; disable interrupts:
        ; (we'll be configuring screen & sprites)
        sei
        
        ; switch the I/O area on:
        lda CPU_CONTROL         ; get the current processor port value
        and # %11111000         ; reset bottom 3 bits, top 5 unchanged 
        ora # C64_MEM::IO_ONLY  ; switch I/O on, BASIC & KERNAL ROM off
        sta CPU_CONTROL

        lda CIA2_PORTA_DDR      ; read Port A ($DD00) data-direction register
        ora # %00000011         ; set bits 0/1 to R+W, all others read-only
        sta CIA2_PORTA_DDR

        ; set the VIC-II bank:
        ; the lower two-bits of register $DD00 controls the VIC-II bank.
        ; (the binary value is inverted compared to the canonical bank
        ; numbers and you should retain the top 6 bits)
        ;
        lda CIA2_PORTA          ; read the serial bus / VIC-II bank state
        and # %11111100         ; keep current value except bits 0-1 (VIC bank)

        ; set the bits according to the bank defined by the linker script, e.g.
        ; "/link/elite-harmless-d64.cfg", and imported by "elite_consts.asm"
        ora # .vic_bank_bits(ELITE_VIC_BANK)  
        sta CIA2_PORTA

        ; enable interrupts and non-maskable interrupts generated by the A/B
        ; system timers. the bottom two bits control CIA timers A & B, and
        ; writes to $DC0D control normal interrupts, and writes to $DD0D
        ; control non-maskable interrupts
        lda # CIA::TIMER_A | CIA::TIMER_B        ;=%00000011
        sta CIA1_INTERRUPT      ; interrupt control / status register
        sta CIA2_INTERRUPT      ; non-maskable interrupt register

        ; set up VIC-II memory:
        ; NOTE: during loading, the bitmap screen is not set at the same
        ;       location as it will be when the game begins?
        ;
        ; %1000xxxx = set text/colour screen to VIC+$2000,
        ;             colour map    @ $6000..$6400
        ; %xxxx000x = set character set to VIC+$0000
        ;             bitmap screen @ $4000..$6000
        ; %xxxxxxx1 = N/A! (but included in the original source)
        ;
        lda # ELITE_TXTSCR_D018 | %00000001
        sta VIC_MEMORY

        ; black screen:
        lda # BLACK
        sta VIC_BORDER          ; set border colour black
        lda # BLACK
        sta VIC_BACKGROUND      ; set background colour black

        ; set up the bitmap screen:
        ; - bit 0-2: vertical scroll offset (set to 3, why?)
        ; - bit   3: 25 rows
        ; - bit   4: screen on
        ; - bit   5: bitmap mode on
        ; - bit 6-7: extended mode off / raster interrupt off
        lda # 3 | screen_ctl1::rows \
                | screen_ctl1::display \
                | screen_ctl1::bitmap
        sta VIC_SCREEN_CTL1

        ; further screen setup:
        ; - bit 0-2: horizontal scroll (0)
        ; - bit   3: 38 columns (borders inset)
        ; - bit   4: multi-color mode off
        lda # %11000000         ; undocumented bits? default?
        sta VIC_SCREEN_CTL2

        ; sprites:
        ;=======================================================================
        ; disable all sprites
        lda # %00000000
        sta VIC_SPRITE_ENABLE

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; set sprite 3 colour to medium-grey
        lda # GREY
        sta VIC_SPRITE3_COLOR
        ; set sprite 4 colour to blue
        lda # BLUE
        sta VIC_SPRITE4_COLOR
        ; set sprite 5 colour to white
        lda # WHITE
        sta VIC_SPRITE5_COLOR
        ; set sprite 6 colour to green
        lda # GREEN
        sta VIC_SPRITE6_COLOR
        ; set sprite 7 colour to brown
        lda # BROWN
        sta VIC_SPRITE7_COLOR
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set sprite 2 colour to brown
        ; (this is the explosion sprite)
        lda # BROWN
        sta VIC_SPRITE2_COLOR
        ; extra colours for the explosion sprite:
        ; set sprite multi-colour 1 to orange
        lda # ORANGE
        sta VIC_SPRITE_EXTRA1
        ; set sprite multi-colour 2 to yellow
        lda # YELLOW
        sta VIC_SPRITE_EXTRA2

        ; set all sprites to single-colour
        ; (the Trumbles™ are actually multi-colour,
        ;  so this must be changed at some point)
        lda # %00000000
        sta VIC_SPRITE_MULTICOLOR

        ; set all sprites to double-width, double-height
        lda # %11111111
        sta VIC_SPRITE_DBLHEIGHT
        sta VIC_SPRITE_DBLWIDTH

        ; set sprites' X 8th bit to 0;
        ; i.e all X-positions are < 256
        lda # $00
        sta VIC_SPRITES_X

        ; roughly centre sprite 0 on screen
        ; (crosshair?)
        ldx # 161
        ldy # 101
        stx VIC_SPRITE0_X
        sty VIC_SPRITE0_Y
        
        ; setup (but don't display) the trumbles
        lda # 18
        ldy # 12
        sta VIC_SPRITE1_X
        sty VIC_SPRITE1_Y
        asl                     ; double x-position (=36)
        sta VIC_SPRITE2_X
        sty VIC_SPRITE2_Y
        asl                     ; double x-position (=72)
        sta VIC_SPRITE3_X
        sty VIC_SPRITE3_Y
        asl                     ; double x-position (=144)
        sta VIC_SPRITE4_X
        sty VIC_SPRITE4_Y
        lda # 14
        sta VIC_SPRITE5_X
        sty VIC_SPRITE5_Y
        asl                     ; double x-position (=28)
        sta VIC_SPRITE6_X
        sty VIC_SPRITE6_Y
        asl                     ; double x-position (=56)
        sta VIC_SPRITE7_X
        sty VIC_SPRITE7_Y

        ; set sprite priority:
        ; only sprite 1 (explosion) is behind screen
        lda # %0000010
        sta VIC_SPRITE_PRIORITY

        ; sprite indicies
        lda # ELITE_SPRITES_INDEX + 0
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE0_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE0_PTR
        lda # ELITE_SPRITES_INDEX + 4
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE1_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE1_PTR

        ; each of the Trumbles™ alternate patterns
.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        lda # ELITE_SPRITES_INDEX + 5
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE2_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE2_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE4_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE4_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE6_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE6_PTR
        lda # ELITE_SPRITES_INDEX + 6
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE3_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE3_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE5_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE5_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE7_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE7_PTR
.endif  ;///////////////////////////////////////////////////////////////////////

        ; erase the two text screens
        ;-----------------------------------------------------------------------
        ; even though these two screens typically follow each other in memory,
        ; we'll erase them individually to allow for future flexibility
        ;
        ldy #> ELITE_MENUSCR_ADDR
        ldx # .page_count( 1024 )
        lda # .color_nybble( WHITE, BLACK )
        jsr set_bytes
        
        ldy #> ELITE_MAINSCR_ADDR
        ldx # .page_count( 1024 )
        lda # .color_nybble( WHITE, BLACK )
        jsr set_bytes

        ; copy 279 bytes of data to $66D0-$67E7
        ;-----------------------------------------------------------------------
.import ELITE_HUD_COLORSCR_ADDR
.import _783a

        lda #< ELITE_HUD_COLORSCR_ADDR
        sta ZP_COPY_TO+0
        lda #> ELITE_HUD_COLORSCR_ADDR
        sta ZP_COPY_TO+1

        lda #< _783a
        sta ZP_COPY_FROM+0
        lda #> _783a
        jsr _7827

        ; set the screen-colours for the menu-screen:
        ; (high-resolution section only, no HUD)
        ;-----------------------------------------------------------------------
.import ELITE_MENUSCR_ADDR

        lda #< ELITE_MENUSCR_ADDR
        sta ZP_COPY_TO+0
        lda #> ELITE_MENUSCR_ADDR
        sta ZP_COPY_TO+1

        ldx # 25                ; 25-rows

        ; colour the borders yellow down the sides of the view-port:
_7711:  lda # .color_nybble( YELLOW, BLACK )
        ldy # 36                ; set the colour on column 37
        sta [ZP_COPY_TO], y
        ldy # 3                 ; set the colour on column 4
        sta [ZP_COPY_TO], y
        dey

        ; colour the area outside the viewport black
        lda # .color_nybble( BLACK, BLACK )
:       sta [ZP_COPY_TO], y     ; set columns 2, 1 & 0 to black
        dey 
        bpl :-

        ldy # 37                ; begin at column 38
        sta [ZP_COPY_TO], y     ; set column 38 black
        iny 
        sta [ZP_COPY_TO], y     ; and column 39
        iny 
        sta [ZP_COPY_TO], y     ; and column 40
    
        ; move to the next row
        ; (add 40 columns)
        lda ZP_COPY_TO+0
        clc 
        adc # 40
        sta ZP_COPY_TO+0
        bcc :+
        inc ZP_COPY_TO+1
:       dex                     ; repeat for 25 rows
        bne _7711

        ; set the screen-colours for the high-resolution
        ; bitmap portion of the main flight-screen
        ;-----------------------------------------------------------------------
.import ELITE_MAINSCR_ADDR

        lda #< ELITE_MAINSCR_ADDR
        sta ZP_COPY_TO+0
        lda #> ELITE_MAINSCR_ADDR
        sta ZP_COPY_TO+1

        ldx # ELITE_VIEWPORT_ROWS

_7745:  lda # .color_nybble( YELLOW, BLACK )
        ldy # 36
        sta [ZP_COPY_TO], y
        ldy # 3
        sta [ZP_COPY_TO], y
        dey 
        
        lda # .color_nybble( BLACK, BLACK )

_7752:  sta [ZP_COPY_TO], y
        dey 
        bpl _7752
        ldy # 37
        sta [ZP_COPY_TO], y
        iny 
        sta [ZP_COPY_TO], y
        iny 
        sta [ZP_COPY_TO], y
        lda ZP_COPY_TO+0
        clc 
        adc # 40
        sta ZP_COPY_TO+0
        bcc _776c
        inc ZP_COPY_TO+1
_776c:
        dex 
        bne _7745

        ; set yellow colour across the bottom row of
        ; the menu-screen. write $70 from $63E4 to $63C4
        lda # .color_nybble( YELLOW, BLACK )
        ldy # ELITE_VIEWPORT_COLS - 1
:       sta ELITE_MENUSCR_ADDR + .scrpos( 24, 4 ), y
        dey 
        bpl :-

        ; set screen colours for the mult-colour bitmap
        ;-----------------------------------------------------------------------
        ; set $D800-$DC00 (colour RAM) to black
        ;
        lda # BLACK
        sta ZP_COPY_TO+0
        tay 
        ldx #> $d800
        stx ZP_COPY_TO+1
        ldx # .page_count(1024)
:       sta [ZP_COPY_TO], y
        iny 
        bne :-
        inc ZP_COPY_TO+1
        dex 
        bne :-

        ; colour the HUD:
        ;-----------------------------------------------------------------------
        ; copy 279? bytes from $795A to $DADA
        ; multi-colour bitmap colour nybbles
        ;
.import __HUD_COLORRAM_LOAD__

        lda #< $dad0
        sta ZP_COPY_TO+0
        lda #> $dad0
        sta ZP_COPY_TO+1
        
        lda #< __HUD_COLORRAM_LOAD__
        sta ZP_COPY_FROM+0
        lda #> __HUD_COLORRAM_LOAD__
        jsr _7827

        ; write $07 to $D802-$D824

        ldy # $22
        lda # YELLOW
_77a3:  sta $d802, y
        dey 
        bne _77a3
        
        ; clear the bitmap screen:
        ;-----------------------------------------------------------------------
        ldy #> ELITE_BITMAP_ADDR        ; starting address hi-byte
        ldx # .page_count( $2000 )      ; number of pages
        lda # $00                       ; set value
        jsr set_bytes

        ;-----------------------------------------------------------------------
        lda CPU_CONTROL                 ; get processor port state
        and # %11111000                 ; retain everything except bits 0-2 
        ora # C64_MEM::IO_KERNAL        ; I/O & KERNAL ON, BASIC OFF
        sta CPU_CONTROL

        cli 

        ;-----------------------------------------------------------------------

.import init_mem
.import _8863
        
        ; NOTE: calling `init_mem` clears variable storage from $0400..$0700
        ; *THIS VERY CODE IS WITHIN THAT REGION* -- ergo, we cannot return
        ; from a subroutine here but we will still need to send execution to
        ; `_8863` after clearing variable storage. we do this by pushing the
        ; address we want to jump to (`_8863`) on to the stack and then jump
        ; (*NOT* `jsr`) to the subroutine. when it hits `rts`, execution will
        ; move to the address we inserted into the stack!
        ;
        lda #> (_8863 - 1)
        pha 
        lda #< (_8863 - 1)
        pha 

        jmp init_mem

set_bytes:
        ;=======================================================================
        ; write a value to a block of memory (page-aligned)
        ;
        ;       X = number of pages to write
        ;       Y = hi-byte of starting address
        ;       A = value to write
        ;
        ; set the starting address:
        sty @addr+2             ; hi-byte of starting address
        ldy # $00               ; and write $00 --
        sty @addr+1             ; to the lo-byte
        
@addr:  sta $FF00               ; this is a dummy address, gets overwritten
        inc @addr+1             ; move to the next byte
        bne @addr               ; keep going until $FF->$00
        inc @addr+2             ; move to the next page
        dex                     ; one less page to do
       .bnz @addr               ; have we reached the end?

        rts 

.proc   copy_bytes
        ;=======================================================================
        ; copies bytes from one address to another in 256 byte blocks
        ;
        ; $18/$19 = pointer to address to copy to
        ;     $1a = low-byte of address to copy from
        ;       A = high-byte of address to copy from (gets placed into $1b)
        ;       X = number of 265-byte blocks to copy

        sta ZP_COPY_FROM+1
        ldy # $00

:       lda [ZP_COPY_FROM], y
        sta [ZP_COPY_TO], y
        dey 
        bne :-
        inc ZP_COPY_FROM+1
        inc ZP_COPY_TO+1
        dex 
        bne :-
        rts

.endproc

.proc   _7827
        ;=======================================================================
        ; copy 256-bytes using current parameters
        ldx # $01
        jsr copy_bytes

        ; copy a further 22 bytes
        ldy # $17
        ldx # $01
:       lda [ZP_COPY_FROM], y
        sta [ZP_COPY_TO], y
        dey 
        bpl :-
        ldx # $00
        rts

.endproc

.ifdef  OPTION_MATHTABLES
;///////////////////////////////////////////////////////////////////////////////
; insert the multiplication tables (2K) in "math_3d.asm"
.multiply_tables
;///////////////////////////////////////////////////////////////////////////////
.endif