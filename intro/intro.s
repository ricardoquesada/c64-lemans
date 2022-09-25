;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Lemas                                                                        ;
; Intro                                                                        ;
;                                                                              ;
; by riq / L.I.A                                                               ;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

        * = $0801                       ;
        .WORD (+), 2022                 ;pointer, line number
        .NULL $9E, FORMAT("%4d", start) ;will be "sys ${start}"
+       .WORD 0                         ;basic line end

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
start:
        sei

        ldx #<nmi_handler
        ldy #>nmi_handler
        stx $fffa
        sty $fffb

        lda #$35                        ;RAM/IO/RAM
        sta $01

        lda #$00
        sta $d01a                       ;no raster IRQ

        lda #$7f
        sta $dc0d                       ;turn off cia 1 interrupts
        sta $dd0d                       ;turn off cia 2 interrupts

        lda $dc0d                       ;clear interrupts and ACK irq
        lda $dd0d
        asl $d019

        ; Select Bank $4000-$7fff for VIC
        lda $dd00                       ;CIA 2
        and #%11111100                  ;Mask the first 2 bits
        ora #2                          ;3 for Bank 0
                                        ;2 for Bank 1
                                        ;1 for Bank 2
        sta $dd00                       ;0 for Bank 3

        ; Setup colors
        lda #$00
        sta $d020
        sta $d021

        ldx #$00
        lda #$01
_lp:
        .for step := $0000, step < $0400, step += $0100
        sta $d800 + step,x
        .endfor
        inx
        bne _lp

        lda #%00000100                  ;Screen at BANK + $0000 ($4000)
        sta $d018                       ; Charset at BANK + $1000 ($5000)


        cli

_wait_loop

        lda #$80
_l0     cmp $d012
        bne _l0

        dec _delay_lo                   ;Counter expired?
        bne _l1                         ; Yes, exit
        dec _delay_hi
        beq _exit

_l1
        lda $dc00                       ;User press fired?
        and $dc01                       ; either in joy#1
        and #%00010000                  ; or joy#2
        beq _exit                       ; Yes, exit

        bne _wait_loop

_exit
        jmp end_intro


_delay_lo       .byte $ff
_delay_hi       .byte $03

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
nmi_handler
        rti

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Decruncher routine
decruncher
.logical $0400

decruncher_logical
        dec $01                         ;All RAM
        jsr exod_decrunch               ;jmp to decruncher
        inc $01                         ;RAM/IO/RAM

        ; Restore Bank / VIC / etc.
        lda $dd00                       ;CIA 2
        and #%11111100
        ora #3
        sta $dd00

        lda #%00010100                  ;Default values
        sta $d018

        cli
        jmp $0844                       ;Jump to main game

exod_get_crunched_byte
        ; In forward mode, "LDA" should happen before altering the pointer
_crunched_byte_lo = * + 1
_crunched_byte_hi = * + 2
        lda exo_game_head               ;self-modyfing. needs to be set correctly before
        inc _crunched_byte_lo
        bne _byte_skip_hi
        inc _crunched_byte_hi
_byte_skip_hi:
        inc $01                         ;RAM/IO/RAM
        dec $d020
        inc $d020
        dec $01                         ;All RAM
        rts

        .include "exodecrunch.s"

.endlogical

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
end_intro
        sei

        ldx #0                          ;decrunch table. clean it
_l2     sta $0200,x
        inx
        bne _l2

        ldx #0
_l3     lda decruncher,x                ;copy decruncher to $400
        sta $0400,x
        lda decruncher + $0100,x
        sta $0400 + $0100,x
        lda decruncher + $0200,x
        sta $0400 + $0200,x
        inx
        bne _l3

        ; Restore values
        ldx #$00                        ;Set as Input
        stx $dc03
        dex                             ;Set as Output
        stx $dc02

        jmp decruncher_logical


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Data

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Screen
* = $4000
.binary "title-map.bin"

; Charset
* = $5000
.binary "title-charset.bin"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Uses forward crunch, the closer to the $ffff the better since it decompresses
; up to $ff00
* = $8000
exo_game_head
        .binary "../bin/lemans-lia-non-sfx-exo.prg"
exo_game_tail
