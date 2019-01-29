; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "elite_init.asm" : contains intialisation code and graphics data

.include        "c64/c64.asm"
.include        "elite_consts.asm"

.zeropage

ZP_COPY_TO      := $18
ZP_COPY_FROM    := $1a

.segment        "CODE_INIT"

_75e4:                                                                  ;$75E4
;===============================================================================
.export _75e4

        ; this code will switch the VIC-II bank to $4000..$8000;
        ; all graphics to be displayed (characters, sprites, bitmaps)
        ; must therfore exist within this memory range

        ; the program file on disk uses the bitmap screen area ($4000..$6000)
        ; to store some code & data, which gets relocated during this routine.
        ; this is so that the disk file can be smaller by making use of space
        ; that would otherwise consist mostly of zeroes

        ; copy $4000..$5600 to $0700..$1D00:

        ; oddly, $4000..$4800 would be the character set, however only graphics
        ; for $4400..$4700 are defined, therefore the [used] character graphics
        ; get copied to $0B00..$0E00 (the rest is other data)

.import __GMA4_DATA1A_START__
.import __GMA4_DATA1A_LAST__

        ; number of whole pages to copy. note that the lack of a rounding-up
        ; divide is fixed by adding just shy of one page before dividing,
        ; instead of just adding one to the result. this means that a round
        ; number of bytes, e.g. $1000 would not calculate as one more page
        ; than necessary 
        ldx #< (((__GMA4_DATA1A_LAST__ - __GMA4_DATA1A_START__) + 255) / 256)
        
        ;TODO: this is not ideal as an import        
.import __TEXT_FLIGHT_RUN__

        lda #< __TEXT_FLIGHT_RUN__
        sta ZP_COPY_TO+0
        lda #> __TEXT_FLIGHT_RUN__
        sta ZP_COPY_TO+1

.import __GMA4_DATA1A_START__

        lda #< __GMA4_DATA1A_START__
        sta ZP_COPY_FROM+0
        lda #> __GMA4_DATA1A_START__
        jsr copy_bytes

        ;-----------------------------------------------------------------------

        ; disable interrupts:
        ; (we'll be configuring screen & sprites)
        sei
    
        ; change the C64's memory layout:
        ; bits 0-2 of the processor port ($01) control the memory banks,
        ; a value of of %xxxxx100 turns off all ROM shadows (KERNAL, BASIC,
        ; and character ROM) enabling all 64 KB RAM for use
        lda CPU_CONTROL         ; get the current processor port value
        and # %11111000         ; reset bottom 3 bits and keep top 5 unchanged
        ora # MEM_64K           ; turn all ROM shadows off, gives 64K of RAM
        sta CPU_CONTROL

        ; relocate part of the binary payload in "gma4.prg" --
        ; copy $5600..$7F00 to $D000..$F900 -- note that includes this code!

        ;TODO: this is very difficult to calculate!
        ldx # $29               ; size of block-copy -- 41 x 256 = 10'496 bytes

        ;TODO: use HIDATA memory segment address instead?
.import __HULL_TABLE_RUN__

        lda #< __HULL_TABLE_RUN__
        sta ZP_COPY_TO+0
        lda #> __HULL_TABLE_RUN__
        sta ZP_COPY_TO+1

.import __GMA4_DATA1B_START__

        lda #< __GMA4_DATA1B_START__
        sta ZP_COPY_FROM+0
        lda #> __GMA4_DATA1B_START__
        jsr copy_bytes

        ; switch the I/O area back on:
        lda CPU_CONTROL         ; get the current processor port value
        and # %11111000         ; reset bottom 3 bits, top 5 unchanged 
        ora # MEM_IO_ONLY       ; switch I/O on, BASIC & KERNAL ROM off
        sta CPU_CONTROL

        lda CIA2_PORTA_DDR      ; read Port A ($DD00) data-direction register
        ora # %00000011         ; set bits 0/1 to R+W, all others read-only
        sta CIA2_PORTA_DDR

        ; set the VIC-II to get screen / sprite
        ; data from the zone $4000-$7FFF
        ;
        ; the lower two-bits of register $DD00 controls the VIC-II bank.
        ; (the binary value is inverted compared to the canonical bank numbers
        ; and you should retain the top 6 bits)
        ;
        lda CIA2_PORTA          ; read the serial bus / VIC-II bank state
        and # %11111100         ; keep current value except bits 0-1 (VIC bank)
        
        ; set bits 0-1 to %10: bank 1, $4000..$8000
        ora # .vic_bank_bits(ELITE_VIC_BANK)  
        sta CIA2_PORTA

        ; enable interrupts and non-maskable interrupts generated by the A/B
        ; system timers. the bottom two bits control CIA timers A & B, and
        ; writes to $DC0D control normal interrupts, and writes to $DD0D
        ; control non-maskable interrupts
        lda # %00000011
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

        ; disable all sprites
        lda # %00000000
        sta VIC_SPRITE_ENABLE

        ; set sprite 2 colour to brown
        lda # BROWN
        sta VIC_SPRITE2_COLOR
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

        ; set sprite multi-colour 1 to orange
        lda # ORANGE
        sta VIC_SPRITE_EXTRA1
        ; set sprite multi-colour 2 to yellow
        lda # YELLOW
        sta VIC_SPRITE_EXTRA2

        ; set all sprites to single-colour
        ; (the trumbles are actually multi-colour,
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

        ; set sprite priority: only sprite 1 is behind screen
        lda # %0000010
        sta VIC_SPRITE_PRIORITY

        ; clear the bitmap screen:
        ;-----------------------------------------------------------------------
        ; erase $4000-$6000

.import ELITE_BITMAP_ADDR

        lda # $00
        sta ZP_COPY_TO+0
        tay 
        ldx #> ELITE_BITMAP_ADDR

_76d8:  stx ZP_COPY_TO+1
:       sta [ZP_COPY_TO], y
        iny 
        bne :-
        ldx ZP_COPY_TO+1
        inx 
        cpx # $60
        bne _76d8

        ; erase $6000-$6800 (the two colour maps)
        ;-----------------------------------------------------------------------

        lda # $10
_76e8:  stx ZP_COPY_TO+1
:       sta [ZP_COPY_TO], y
        iny 
        bne :-
        ldx ZP_COPY_TO+1
        inx 
        cpx #> $6800
        bne _76e8

        ; copy 279 bytes of data to $66d0-$67E7
        ;-----------------------------------------------------------------------

.import __HUD_COLORSCR_LOAD__
.import __HUD_COLORSCR_SIZE__

        lda #< (ELITE_MAINSCR_ADDR + ($400 - __HUD_COLORSCR_SIZE__) - $10)
        sta ZP_COPY_TO+0
        lda #> (ELITE_MAINSCR_ADDR + ($400 - __HUD_COLORSCR_SIZE__) - $10)
        sta ZP_COPY_TO+1

        lda #< __HUD_COLORSCR_LOAD__
        sta ZP_COPY_FROM+0
        lda #> __HUD_COLORSCR_LOAD__
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

        ; yellow fore / black back colour
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

        ldx # $12               ; 18 rows

_7745:  lda # .color_nybble( YELLOW, BLACK )
        ldy # 36
        sta [ZP_COPY_TO], y
        ldy # 3
        sta [ZP_COPY_TO], y
        dey 
        lda # $00

_7752:  sta [ZP_COPY_TO], y
        dey 
        bpl _7752
        ldy # $25
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

        ; set yellow colour across the bottom row of the menu-screen
        ; write $70 from $63e4 to $63c4
        lda # .color_nybble( YELLOW, BLACK )
        ldy # $1f               ; we'll write 31 chars (colour-cells)
:       sta ELITE_MENUSCR_ADDR + (24 * 40) + 4, y
        dey 
        bpl :-

        ; set screen colours for the mult-colour bitmap
        ;-----------------------------------------------------------------------

        ; set $D800..$DC00 (colour RAM) to black
        lda # BLACK
        sta ZP_COPY_TO+0
        tay 
        ldx #> $d800
        stx ZP_COPY_TO+1

        ldx # $04               ; 4 x 256 = 1'024 bytes
_7784:  sta [ZP_COPY_TO], y
        iny 
        bne _7784
        inc ZP_COPY_TO+1
        dex 
        bne _7784

        ; colour the HUD:
        ;-----------------------------------------------------------------------
        ; copy 279? bytes from $795a to $dada
        ; multi-colour bitmap colour nybbles

.import __HUD_COLORRAM_LOAD__   ;=$795A

        lda #< $dad0
        sta ZP_COPY_TO+0
        lda #> $dad0
        sta ZP_COPY_TO+1
        lda #< __HUD_COLORRAM_LOAD__
        sta ZP_COPY_FROM+0
        lda #> __HUD_COLORRAM_LOAD__
        jsr _7827

        ; write $07 to $d802-$d824

        ldy # $22
        lda # $07
_77a3:  sta $d802,y
        dey 
        bne _77a3

.import ELITE_SPRITES_INDEX:direct

        ; sprite indicies
        ; TODO: define these indicies based on the acutal sprite patterns order
        lda # ELITE_SPRITES_INDEX + 0
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE0_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE0_PTR
        lda # ELITE_SPRITES_INDEX + 4
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE1_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE1_PTR

        ; each of the Trumbles™ alternate patterns
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

        ;-----------------------------------------------------------------------

        lda CPU_CONTROL         ; get processor port state
        and # %11111000         ; retain everything except bits 0-2 
        ora # MEM_IO_KERNAL     ; I/O & KERNAL ON, BASIC OFF
        sta CPU_CONTROL

        ;-----------------------------------------------------------------------

        ; copy $7D7A..$867A to $EF90-$F890 (under the KERNAL ROM)
        ; -- HUD (backup?)

        cli 

        ; get the location of the HUD data from the linker configuration
.import __HUD_DATA_LOAD__, __HUD_DATA_SIZE__

        ; number of whole pages to copy. note that, the lack of a rounding-up
        ; divide is fixed by adding just shy of one page before dividing,
        ; instead of just adding one to the result. this means that a round
        ; number of bytes, e.g. $1000 would not calculate as one more page
        ; than necessary 
        ldx #< ((__HUD_DATA_SIZE__ + 255) / 256)

        ; get the location where the HUD data is to be copied to
.import __HUD_DATA_LOAD__
.import __HUD_DATA_RUN__

        lda #< __HUD_DATA_RUN__
        sta ZP_COPY_TO+0
        lda #> __HUD_DATA_RUN__
        sta ZP_COPY_TO+1
        
        lda #< __HUD_DATA_LOAD__
        sta ZP_COPY_FROM+0
        lda #> __HUD_DATA_LOAD__
        jsr copy_bytes

        ;-----------------------------------------------------------------------

.import __GFX_SPRITES_LOAD__    ;=$7A7A
.import __GFX_SPRITES_RUN__     ;=$6800

        ; copy $7A7A..$7B7A to $6800..$6900
        ; SPRITES!

        ldy # $00
_77ff:  lda __GFX_SPRITES_LOAD__, y
        sta __GFX_SPRITES_RUN__, y
        dey 
        bne _77ff

        ; copy $7B7A..$7C7A to $6900..$6A00
        ; two sprites, plus a bunch of unknown data

_7808:  lda __GFX_SPRITES_LOAD__ + $100, y
        sta __GFX_SPRITES_RUN__  + $100, y
        dey 
        bne _7808

        ;-----------------------------------------------------------------------

        ; NOTE: this memory address has been modified to say `jmp $038a`
        ; (part of 'loader/stage1.asm', GMA1.PRG)
        jmp $ce0e


.proc   copy_bytes                                                      ;$7814
        ;=======================================================================
        ; copies bytes from one address to another in 256 byte blocks
        ;
        ; $18/$19 = pointer to address to copy to
        ;     $1a = low-byte of address to copy from
        ;       A = high-byte of address to copy from (gets placed into $1b)
        ;       X = number of 265-byte blocks to copy

        sta ZP_COPY_FROM+1
        ldy # $00

:       lda [ZP_COPY_FROM], y                                           ;$7818
        sta [ZP_COPY_TO], y
        dey 
        bne :-
        inc ZP_COPY_FROM+1
        inc ZP_COPY_TO+1
        dex 
        bne :-
        rts

.endproc

.proc   _7827                                                           ;$7827
        ;=======================================================================
        ; copy 256-bytes using current parameters
        ldx # $01
        jsr copy_bytes

        ; copy a further 22 bytes
        ldy # $17
        ldx # $01
:       lda [ZP_COPY_FROM], y                                           ;$7830
        sta [ZP_COPY_TO], y
        dey 
        bpl :-
        ldx # $00
        rts

.endproc