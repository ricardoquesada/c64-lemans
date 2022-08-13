;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; LeMans for Commodore 64                                                      ;
; Disassembled + fully commented                                               ;
; Added some improvements. See compile-time variables below                    ;
;                                                                              ;
; by riq / L.I.A                                                               ;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

; Compile-time variables
; To compile the unmodified original game, all values must be 0
USE_JOYSTICK            .VAR 0          ;Set it to 1 to use Joystick  instead of Paddle
                                        ; By enabling Joystick support, it also enables
                                        ; Gamepad Rumble support
USE_PRG                 .VAR 0          ;Generate a .prg instead of a .crt
                                        ; Original is cartridge
USE_FIX_MISSPELL        .VAR 0          ;Fix "BOUNS" -> "BONUS"

;
; **** ZP ABSOLUTE ADRESSES ****
;
ZP_IRQ_LO = $02
ZP_IRQ_HI = $03
ZP_TMP_PTR_LO = $04
ZP_TMP_PTR_HI = $05
ZP_SCREEN_PTR_LO = $06
ZP_SCREEN_PTR_HI = $07
ZP_RANDOM_NUMBER = $08
ZP_RANDOM_NUMBER_SEED = $09
ZP_SCORE_01 = $0A
ZP_SCORE_02 = $0B
ZP_SCORE_03 = $0C
ZP_ZERO_IS_ZERO = $0D                   ;If 1, print "0" as "0", otherwise as " "
ZP_HI_SCORE_01 = $0E
ZP_HI_SCORE_02 = $0F
ZP_HI_SCORE_03 = $10
ZP_SOUND_ENABLED = $11
ZP_IS_GAME_OVER = $12
ZP_GAME_OVER_STATE = $13
ZP_TIMER0_CNT = $14
ZP_TIMER0_TRIGGERED = $15
ZP_TIME = $16
ZP_TICK_COUNTER = $17                   ;Current number of ticks.
ZP_TICKS_PER_SECOND = $18               ;How many ticks are in a second
ZP_TIMER1_TRIGGERED = $19
ZP_ROAD_STATE = $1A
ZP_ROAD_STATE_DELAY = $1B
ZP_ROAD_TURN_TBL_IDX = $1C
a1D = $1D                               ;Related to color index when printing shoulders
ZP_SHOULDER_LEFT_IDX = $1E
ZP_SHOULDER_RIGHT_IDX = $1F
ZP_SHOULDER_PATTERN_CHOOSER = $20       ;Valid values: 0,1,2,3
ZP_DIGIT_TO_PRINT = $21                 ;Digit to print. Values from 0 to 9
ZP_BCD_TO_PRINT = $22                   ;Encoded in BCD
ZP_LEVEL_IDX = $23                      ;When ZP_LEVEL_TICK reaches 250,
                                        ; it gets increased by one.
                                        ; Although sometimes used as tmp var
ZP_LEVEL_TICK = $24                     ;Ticks once per IRQ. Used to keep track
                                        ; the ROAD_STATE "life"
                                        ; Although sometimes used as tmp var
ZP_HEADLIGHT_DURATION = $25
ZP_UNUSED_26 = $26
ZP_SPEED_LO = $27
ZP_SPEED_HI = $28
ZP_UNUSED_29 = $29
ZP_CONSTANT_368_LO = $2A                ;It is alwasy 112 (1 * 256 + 112 = 368)
ZP_CONSTANT_368_HI = $2B                ;It is always 1 (1 * 256 + 112 = 368)
ZP_CAR_RESISTANCE_LO = $2C
ZP_CAR_RESISTANCE_HI = $2D              ;Also used for Enemy Car Delta Y
ZP_MOTOR_SOUND_FREQ_LO = $2E            ;ZP_MOTOR_SOUND_FREQ ~= CAR_RESISTANCE * 20
ZP_MOTOR_SOUND_FREQ_HI = $2F
ZP_ENABLE_ENEMY_CAR0 = $30
f34 = $34                               ;Not used, but related to the enemy speed/direction
ZP_PADDLE_1_VALUE_INV = $38
ZP_PADDLE_1_VALUE = $39
ZP_CAR_MOVEMENT_DELAY_LO = $3A
ZP_CAR_MOVEMENT_DELAY_HI = $3B
ZP_CAR_Y_OFFSET = $3C
ZP_TMP_3D = $3D
ZP_TMP_3E = $3E
ZP_PIXELS_TO_MOVE_CAR = $41
ZP_BRAKE_FORCE = $42
ZP_FRAME_PTR_IDX = $43
ZP_CAR_ANIM_DELAY = $44
ZP_FLAME_ANIM_DELAY = $45
ZP_FLAME_FRAME_IDX = $46
ZP_SPLIT_ROAD_SPRITE_DELAY = $47
ZP_SPLIT_ROAD_SPRITE_TOGGLE = $48
ZP_TMP_49 = $49
ZP_TMP_4A = $4A
ZP_ENEMY_CAR_ANIM_DELAY = $4B
ZP_ENEMY_CAR_FRAME_IDX = $4C
ZP_ENEMY_CAR_VERTICAL_DIR = $4D
ZP_ENEMY_CAR_DELTA_X_TBL = $4E          ;$4E, $4F, $50, $51
ZP_LEFT_SHOULDER_ENABLED = $52
ZP_LIVES = $53
ZP_LIVES_USED = $54
ZP_TIMES_TO_DISPLAY_EXTENDED_TIME = $55
ZP_TMP_REG_Y = $56
ZP_TMP_REG_X = $57
ZP_COLLISION_DETECTED = $58
ZP_PLAY_CRASH_SOUND = $59
a5A = $5A                               ;Temporal sprite counter
ZP_TMP_5B = $5B
ZP_TMP_5C = $5C
ZP_ENEMY_CAR_X_IS_FIXED_TBL = $5D
ZP_SID_FREQ_LO = $61
ZP_SID_FREQ_HI = $62
ZP_SOUND_EFFECT_01_DELAY = $63
ZP_SOUND_EFFECT_TO_PLAY = $64
ZP_PLAY_SPLIT_ROAD_SOUND = $65
ZP_PLAY_PASS_CAR_SOUND = $66
ZP_PLAY_EXTENDED_TIME_SOUND = $67
ZP_TMP_68 = $68
ZP_TMP_69 = $69
ZP_PRINT_SPEED_DELAY = $6A
ZP_ENEMY_CAR_PASSED_TBL = $6B
ZP_PASSED_CARS_TOTAL = $6F
ZP_ADD_1000_PTS = $70
ZP_DISPLAY_1000_PTS_DURATION = $71
a72 = $72                               ;Used in play sound effect routine
a73 = $73                               ;ditto above
a74 = $74                               ;ditto above
a75 = $75                               ;ditto above
ZP_SID_CUTOFF_FREQ_HI = $76
ZP_SID_VOICE_FILTER_MASK = $77
ZP_DISPLAY_PIT_DELAY = $78
ZP_ROAD_X_LEFT_ROW_TBL = $79            ;25 elements (height of screen)
ZP_ROAD_X_RIGHT_ROW_TBL = $92           ;25 elements (height of screen)
ZP_ROAD_STATE_ROW_TBL = $AB             ;25 elements (height of screen)
;
; **** FIELDS ****
;
SCREEN_RAM = $0400
COLOR_RAM = $D800
;
; **** ABSOLUTE ADRESSES ****
;
SPR_FRAME_PTR_00 = $07F8
SPR_FRAME_PTR_04 = $07FC
SPR_FRAME_PTR_05 = $07FD
SPR_FRAME_PTR_06 = $07FE
SPR_FRAME_PTR_07 = $07FF
;
; **** POINTERS ****
;
SCORE_OFFSET = SCREEN_RAM + 40 * 2 + 32
TIME_OFFSET = SCREEN_RAM + 40 * 5 + 35
HI_SCORE_OFFSET = SCREEN_RAM + 40 * 8 + 32


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Notes
; Sprite frames:
; $e6 = ???
; $e7 = ???
; $f3 = PIT
; $f4 = Hero Car 00
; $f5 = Hero Car 01, simil 00 but with tires moving
; $f6 = Enemy Car 00
; $f7 = Enemy Car 01, simil 02 but with tires moving
; $f8 = Flames 1 (overlay sprite)
; $f9 = Flames 2 (overlay sprite)
; $fa = Car mask (?)
; $fb = Split road ahead
; $fc = Headlights top-left
; $fd = Headlights top-right
; $fe = Headlights center
;
; Sprites:
; 0-3: Enemy cars
; 4: PIT / Top-Left Headlight
; 5: Top-Right Headlight / Flame 01
; 6: Split road ahead / Central Headlight / Flame 02
; 7: Hero car
;
; Road states (ZP_ROAD_STATE)
; $00 = Green
; $01 = White, Ice
; $02 = Black, Night
; $03 = Green
; $04 = Green, Show Split Screen sprite
; $05 = Brown, turns
; $06 = Split screen
; $07 = Purple, shoulder on left (initial state)
; $08 = Purple, shoulder on left


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; It is an 8Kb Ultimax cartridge.
; Starting address:
.IF USE_PRG == 0
        * = $E000
.ELSE
        * = $0801
        .WORD (+), 2019                 ;pointer, line number
        .NULL $9E, FORMAT("%d", START)  ;will be sys START
+       .WORD 0                         ;basic line end
.ENDIF


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
IRQ_HANDLER
        PHA
        TXA
        PHA
        TYA
        PHA
        JMP (ZP_IRQ_LO)

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Interrupt is triggered by Timer A
IRQ_HANDLER_MAIN
        LDA ZP_SOUND_ENABLED
        BEQ _L00

        JSR PLAY_SOUND_EFFECT

_L00    INC ZP_TIMER0_CNT
        INC ZP_TIMER0_CNT
        LDA ZP_TIMER0_CNT
        CMP #60
        BCC _L01

        LDY #$00
        STY ZP_TIMER0_CNT
        INY
        STY ZP_TIMER0_TRIGGERED

_L01    LDA #$01
        STA ZP_TIMER1_TRIGGERED

        LDA $DC0D                       ;CIA1: CIA Interrupt Control Register

        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
VIC_VALUES
        .BYTE $10                       ;$D011 - Text, 24-rows
        .BYTE $00                       ;$D012 - Raster
        .BYTE $00                       ;$D013 - Latch X
        .BYTE $00                       ;$D014 - Latch Y
        .BYTE $00                       ;$D015 - All sprites disabled
        .BYTE $18                       ;$D016 - 40 Cols, Multicolor mode
        .BYTE $00                       ;$D017 - Y-expanded sprites: None
        .BYTE $1E                       ;$D018 - Charset : 0x3800 / Screen RAM: 0x0400
        .BYTE $00                       ;$D019 - VIC Interrupts (ACK)
        .BYTE $00                       ;$D01A - Request VIC Interrupts: None

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Starting address
START
        SEI
.IF USE_PRG == 1
        ; Needed to set them manually since the cartridge sets them
        ; by overriding their address
        LDX #<NMI_HANDLER               ;Setup NMI Handler
        LDY #>NMI_HANDLER
        STX $FFFC
        STY $FFFD

        LDX #<IRQ_HANDLER               ;Setup IRQ Handler
        LDY #>IRQ_HANDLER
        STX $FFFE
        STY $FFFF
.ENDIF
        LDA #$00
        STA ZP_HI_SCORE_01
        STA ZP_HI_SCORE_02
        STA ZP_HI_SCORE_03

        LDX #$FA                        ;Stack size
        TXS

        ; Init VIC
        CLD
        LDX #$09
_L00    LDA VIC_VALUES,X
        STA $D011,X                     ;VIC Control Register 1
        DEX
        BPL _L00

        ; Init CIA
        LDA #$7F                        ;Clear interrupt flags
        STA $DC0D                       ;CIA1: CIA Interrupt Control Register
        LDA #$08                        ;Set Timer A and B for One-shot
        STA $DC0E                       ;CIA1: CIA Control Register A
        STA $DC0F                       ;CIA1: CIA Control Register B
        LDX #$00                        ;Set as Input
        STX $DC03                       ;CIA1: Data Direction Register B
        DEX                             ;Set as Output
        STX $DC02                       ;CIA1: Data Direction Register A

        LDA #$E5                        ;$8000-$BFFF=RAM, $D000-$DFFF=I/O, $E000-$FFFF=RAM
        STA $01
        LDA #$2F                        ;Default value
        STA $00

        ; Total cycles in C64:
        ;  PAL      = 19656 (312 * 63)
        ;  PAL-N    = 20280 (312 * 65)
        ;  NTSC     = 17095 (263 * 65)
        ;  NTSC Old = 16832 (263 * 64)
        ; And the "cycles" used in this game is 16666, and doesn't match any
        ; of the "standard" cycles for a full vertical retrace.
        ; But it is pretty similar to 16832. Since the game was released in 1982,
        ; right at the early stage of the C64, my guess is that this game was
        ; developed on a NTSC-old C64 machine.
        ; In any case, by using a Timer and not Raster interrupt, it gurantees
        ; that the time is the same for all C64 machines.

        ; Timer frequency: 16666, pretty close to full-retrace in Old NTSC C64 machine
        LDA #<(16666)                   ;Set Timer A (LSB)
        STA $DC04                       ;CIA1: Timer A: Low-Byte
        LDA #>(16666)                   ;Set Timer A (MSB)
        STA $DC05                       ;CIA1: Timer A: High-Byte

        LDA #$81                        ;Enable Timer A
        STA $DC0D                       ;CIA1: CIA Interrupt Control Register
        LDA #$11                        ;Start Timer A, Continuous mode
        STA $DC0E                       ;CIA1: CIA Control Register A

        LDA #<IRQ_HANDLER_MAIN
        STA ZP_IRQ_LO
        LDA #>IRQ_HANDLER_MAIN
        STA ZP_IRQ_HI

        ; Init Variables
        CLI
        CLD
        LDA #$00
        STA ZP_SCORE_01
        STA ZP_SCORE_02
        STA ZP_SCORE_03
        STA ZP_ROAD_STATE_DELAY
        STA ZP_ROAD_TURN_TBL_IDX
        STA ZP_LEVEL_IDX
        STA ZP_LEVEL_TICK
        STA ZP_SPEED_LO
        STA ZP_SPEED_HI
        STA ZP_RANDOM_NUMBER
        STA ZP_RANDOM_NUMBER_SEED
        STA ZP_TIME
        STA $D015                       ;Disable all sprites

        ; Sprites from 0 to 5 have X & Y = 10
        LDY #$0A
_L01    STA $D000,Y                     ;Sprite Pos
        DEY
        BPL _L01

        STA ZP_SHOULDER_LEFT_IDX
        LDA #$64
        STA ZP_SHOULDER_RIGHT_IDX
        LDA #$07
        STA ZP_ROAD_STATE
        JSR INIT_SCREEN

        ; Fallthrough

SET_IRQ_TO_WAIT_BUTTON
        SEI
        LDX #$FA                        ;Stack
        TXS
        LDA #$00
        STA $D418                       ;Select Filter Mode and Volume
        LDA #<IRQ_HANDLER_WAIT_BUTTON
        STA ZP_IRQ_LO
        LDA #>IRQ_HANDLER_WAIT_BUTTON
        STA ZP_IRQ_HI
        CLI
        CLD
        JMP PRINT_TITLE_SCREEN

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
IRQ_HANDLER_WAIT_BUTTON
.IF USE_JOYSTICK == 0
        ; Read button from Paddle
        LDA #$FF                        ;#%11111111
        STA $DC00                       ;CIA1: Data Port Register A
        LDA $DC01                       ;CIA1: Data Port Register B
        AND #$04
        BEQ _L00
.ENDIF

        ; Read button from Joystick
.IF USE_JOYSTICK == 1
        LDA #%00111110                  ;Don't enable paddle to read the joystick button
.ELSE
        LDA #%11111110
.ENDIF
        STA $DC00                       ;CIA1: Data Port Register A
        LDA $DC01                       ;CIA1: Data Port Register B
        AND #$10                        ;#%00010000
        BNE _L01                        ;Button pressed? (Active low)

_L00    LDA #<IRQ_HANDLER_MAIN
        STA ZP_IRQ_LO
        LDA #>IRQ_HANDLER_MAIN
        STA ZP_IRQ_HI
        LDA $DC0D                       ;CIA1: CIA Interrupt Control Register
        JMP INIT_GAME

_L01    JMP IRQ_HANDLER_MAIN

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
INIT_GAME
        SEI
        LDX #$FA                        ;Stack
        TXS

        CLD
        CLI

        LDX #$00
        STX ZP_SCORE_01
        STX ZP_SCORE_02
        STX ZP_SCORE_03
        STX ZP_ROAD_STATE_DELAY
        STX ZP_ROAD_TURN_TBL_IDX
        STX ZP_LEVEL_TICK
        STX ZP_UNUSED_26
        STX ZP_SPEED_LO
        STX ZP_SPEED_HI
        STX ZP_HEADLIGHT_DURATION
        STX ZP_SHOULDER_PATTERN_CHOOSER
        STX ZP_BRAKE_FORCE
        STX ZP_FRAME_PTR_IDX
        STX ZP_SOUND_ENABLED
        STX ZP_IS_GAME_OVER
        STX ZP_GAME_OVER_STATE
        STX ZP_ENEMY_CAR_ANIM_DELAY
        STX ZP_ENEMY_CAR_FRAME_IDX
        STX ZP_TICK_COUNTER
        STX ZP_LIVES
        STX ZP_LIVES_USED
        STX ZP_COLLISION_DETECTED
        STX ZP_PLAY_CRASH_SOUND
        STX ZP_SOUND_EFFECT_TO_PLAY
        STX ZP_PLAY_SPLIT_ROAD_SOUND
        STX ZP_PLAY_PASS_CAR_SOUND
        STX ZP_PLAY_EXTENDED_TIME_SOUND
        STX ZP_ENEMY_CAR_PASSED_TBL
        STX ZP_ENEMY_CAR_PASSED_TBL+1
        STX ZP_ENEMY_CAR_PASSED_TBL+2
        STX ZP_ENEMY_CAR_PASSED_TBL+3
        STX ZP_PASSED_CARS_TOTAL
        STX ZP_ADD_1000_PTS
        STX ZP_DISPLAY_1000_PTS_DURATION
        STX ZP_TIMES_TO_DISPLAY_EXTENDED_TIME
        STX ZP_SID_VOICE_FILTER_MASK
        STX f34
        STX f34+1
        STX f34+2
        STX f34+3
        STX ZP_ENABLE_ENEMY_CAR0
        STX ZP_ENABLE_ENEMY_CAR0+1
        STX ZP_ENABLE_ENEMY_CAR0+2
        STX ZP_ENABLE_ENEMY_CAR0+3
        STX $D017                       ;Sprites Expand 2x Vertical (Y)
        STX $D01B                       ;Sprite to Background Display Priority
        STX $D01D                       ;Sprites Expand 2x Horizontal (X)
        STX $D026                       ;Sprite Multi-Color Register 1
        STX ZP_SHOULDER_LEFT_IDX

        INX

        STX ZP_CONSTANT_368_HI
        STX ZP_ENEMY_CAR_DELTA_X_TBL
        STX ZP_ENEMY_CAR_DELTA_X_TBL+1

        LDA #$04
        STA a5A
        LDA #$06
        STA ZP_PIXELS_TO_MOVE_CAR
        LDA #$07
        STA ZP_ROAD_STATE
        LDA #$0F
        STA $D025                       ;Sprite Multi-Color Register 0
        LDA #60                         ;1 second = 60 ticks
        STA ZP_TICKS_PER_SECOND
        LDA #$60                        ;Initial time: 60 seconds (BCD)
        STA ZP_TIME
        LDA #100
        STA ZP_SHOULDER_RIGHT_IDX
        LDA #112
        STA ZP_CONSTANT_368_LO

        ; Only set Visible enemy cars and hero car sprites
        LDA #$8F                        ;#%10001111
        STA $D015                       ;Sprite display Enable
        LDA #$FF                        ;#%11111111
        STA $D01C                       ;Sprites Multi-Color Mode Select

        STA ZP_ENEMY_CAR_DELTA_X_TBL+2
        STA ZP_ENEMY_CAR_DELTA_X_TBL+3

        ; Init SID
        LDA #$00
        LDY #$18
_L00    STA $D400,Y                     ;Voice 1: Frequency Control - Low-Byte
        DEY
        BPL _L00

        LDA #$02
        STA $D403                       ;Voice 1: Pulse Waveform Width - High-Nybble
        STA $D40A                       ;Voice 2: Pulse Waveform Width - High-Nybble
        LDA #$08
        STA $D40C                       ;Voice 2: Attack / Decay Cycle Control
        LDA #$F9
        STA $D40D                       ;Voice 2: Sustain / Release Cycle Control
        LDA #$2F
        STA $D418                       ;Select Filter Mode and Volume
        LDA #$BE
        STA $D416                       ;Filter Cutoff Frequency: High-Byte
        LDA #$F0
        STA $D414                       ;Voice 3: Sustain / Release Cycle Control
        LDA #$FB
        STA $D406                       ;Voice 1: Sustain / Release Cycle Control

        JSR PRINT_SCORE_AND_TIME
        JSR PRINT_SPEED
        LDA #$0E                        ;Color Light Blue
        STA $D027                       ;Sprite 0 Color
        LDA #$F4                        ;Car pos 1
        STA SPR_FRAME_PTR_00
        LDA #137
        STA $D000                       ;Sprite 0 X Pos

        ; Scroll down 15 rows with a small delay betwen each
        LDX #15
_L01    STX ZP_LEVEL_IDX                ;Overloaded ZP_LEVEL_IDX
        JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        LDY #$01
        JSR DELAY_01
        LDX ZP_LEVEL_IDX                ;Overloaded ZP_LEVEL_IDX
        DEX
        BPL _L01

        ; Play "Engine" sound while we scroll down
        LDA #$0A
        STA $D401                       ;Voice 1: Frequency Control - High-Byte
        LDA #$41
        STA $D404                       ;Voice 1: Control Register

        ; Do the initial scroll down, where the car
        ; goes up, and the START banner appears with the traffic lights
        LDX #250                        ;The loop goes from 250 to 187
_L02    STX ZP_LEVEL_IDX                ;Overloaded ZP_LEVEL_IDX
        CPX #202
        BEQ _PRINT_START_TOP
        CPX #201
        BEQ _PRINT_TRAFFICLIGHT_BOTTOM
        CPX #200
        BEQ _PRINT_TRAFFICLIGHT_TOP
        CPX #203
        BNE _L10

        ; Print Start bottom row
        LDY #$1F
_L03    LDA START_BOTTOM_ROW_BANNER,Y
        STA SCREEN_RAM,Y
        LDA #$0A                        ;Color Light Red
        STA COLOR_RAM,Y
        DEY
        BPL _L03
        BMI _L11

_PRINT_TRAFFICLIGHT_BOTTOM
        JSR DRAW_ROAD_TOP_ROW
        LDY #$07
_L05    TYA
        AND #$01
        CLC
        ADC #$2D                        ;Traffic light bottom-left char
        STA SCREEN_RAM+4,Y
        LDA #$08                        ;Color Orange
        STA COLOR_RAM+4,Y
        DEY
        BPL _L05
        BMI _L11

_PRINT_TRAFFICLIGHT_TOP
        JSR DRAW_ROAD_TOP_ROW
        LDY #$07
_L07    TYA
        AND #$01
        CLC
        ADC #$2B                        ;Traffic light top-left char
        STA SCREEN_RAM+4,Y
        LDA #$08                        ;Color Orange
        STA COLOR_RAM+4,Y
        DEY
        BPL _L07
        BMI _L11

_PRINT_START_TOP
        LDY #$1F
_L09    LDA START_TOP_ROW_BANNER,Y
        STA SCREEN_RAM,Y
        LDA #$0A                        ;Color Light Red
        STA COLOR_RAM,Y
        DEY
        BPL _L09
        BMI _L11

        ; Scroll down one row
        ; And move the Hero car 8 pixel up
_L10    JSR DRAW_ROAD_TOP_ROW
_L11    JSR SCROLL_DOWN
        LDX ZP_LEVEL_IDX
        TXA
        CLC
        ADC #$08
        STA $D001                       ;Sprite 0 Y Pos

        LDY #$01
        JSR DELAY_01

        ; Instead of going from 63 to 0, the loop goes from
        ; 250 to 187... possibly "let's tune it" hack
        DEX
        CPX #187
        BCC _L12

        JMP _L02

        ; Turn off "engine" sound
_L12    LDA #$00
        STA $D404                       ;Voice 1: Control Register

        LDY #$01
        JSR DELAY_00

        LDA #$05
        STA $D401                       ;Voice 1: Frequency Control - High-Byte
        LDA #$40                        ;#%01000000
        STA $D404                       ;Voice 1: Control Register

        LDY #$01
        JSR DELAY_00

        ; Init sprite's positions and frames
        LDA #$0E                        ;Color Light Blue
        STA $D02E                       ;Sprite 7 Color
        LDA #$F4                        ;Sprite pointer: Stopped car
        STA SPR_FRAME_PTR_07
        LDA #195
        STA $D00F                       ;Sprite 7 Y Pos
        LDA #25
        STA $D001                       ;Sprite 0 Y Pos
        STA $D003                       ;Sprite 1 Y Pos
        STA $D005                       ;Sprite 2 Y Pos
        STA $D007                       ;Sprite 3 Y Pos
        LDA #137
        STA $D00E                       ;Sprite 7 X Pos
        STA $D000                       ;Sprite 0 X Pos
        STA $D002                       ;Sprite 1 X Pos
        STA $D004                       ;Sprite 2 X Pos
        STA $D006                       ;Sprite 3 X Pos

        LDX #$03
_L13    STX ZP_LEVEL_IDX

        LDY #$02
        JSR DELAY_00

        LDA TRAFFICLIGHT_SID_FREQ_TBL,X
        STA $D408                       ;Voice 2: Frequency Control - High-Byte
        LDA #$11
        STA $D40B                       ;Voice 2: Control Register

        ; Print "trafficlight" background color
        LDA #$08                        ;Orange
        LDY #$07                        ;Number of columns to print
_L14    STA COLOR_RAM+40*14+4,Y
        STA COLOR_RAM+40*15+4,Y
        DEY
        BPL _L14

        LDA TRAFFICLIGHT_COLOR_RAM_POS_LO,X
        STA ZP_TMP_PTR_LO
        LDA TRAFFICLIGHT_COLOR_RAM_POS_HI,X
        STA ZP_TMP_PTR_HI

        LDA TRAFFICLIGHT_COLOR_TBL,X
        LDX #$03
_L15    LDY TWO_BY_TWO_OFFSET_TBL,X
        STA (ZP_TMP_PTR_LO),Y
        DEX
        BPL _L15

        LDY #$0A
        JSR DELAY_01

        LDX ZP_LEVEL_IDX
        LDA TRAFFICLIGHT_SID_CONTROL_TBL,X
        STA $D40B                       ;Voice 2: Control Register
        DEX
        BPL _L13

        LDA #$00
        STA ZP_LEVEL_IDX
        LDA #60                         ;For how long the left shoulder will be drawn
        STA ZP_LEFT_SHOULDER_ENABLED
        LDA #$08
        STA ZP_ROAD_STATE

        LDA #$90                        ;#%10010000
        STA $D40C                       ;Voice 2: Attack / Decay Cycle Control
        SEI
        LDA #<IRQ_HANDLER_GAME_LOOP
        STA ZP_IRQ_LO
        LDA #>IRQ_HANDLER_GAME_LOOP
        STA ZP_IRQ_HI
        CLI
        LDA #$01
        STA ZP_SOUND_ENABLED
        JMP MAIN_LOOP

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
TRAFFICLIGHT_COLOR_RAM_POS_LO
        .BYTE <(COLOR_RAM+40*14+10)
        .BYTE <(COLOR_RAM+40*14+8)
        .BYTE <(COLOR_RAM+40*14+6)
        .BYTE <(COLOR_RAM+40*14+4)
TRAFFICLIGHT_COLOR_RAM_POS_HI
        .BYTE >(COLOR_RAM+40*14+10)
        .BYTE >(COLOR_RAM+40*14+8)
        .BYTE >(COLOR_RAM+40*14+6)
        .BYTE >(COLOR_RAM+40*14+4)
TRAFFICLIGHT_COLOR_TBL
        .BYTE $0B,$0F,$0A,$0A           ;Dark Grey, Light Grey, Light Red, Light Red
TRAFFICLIGHT_SID_FREQ_TBL
        .BYTE $59,$2C,$2C,$2C
TRAFFICLIGHT_SID_CONTROL_TBL
        .BYTE $10,$00,$00,$00

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Initial screen, including the scrolling + animation
; Does not return (?)
PRINT_TITLE_SCREEN
        LDA #$07
        STA ZP_ROAD_STATE

        LDX #$00
_L00    STX ZP_LEVEL_IDX
        JSR DRAW_ROAD_TOP_ROW

        LDX ZP_LEVEL_IDX                ;Index of row to print
        LDY TITLE_ROWS_TBL,X            ;Choose which row to print
        LDX #$00
_L01    LDA TITLE_MSG,Y
        STA SCREEN_RAM+8,X
        LDA #$03                        ;Cyan color
        STA COLOR_RAM+8,X
        INY
        INX
        CPX #16                         ;16 colums to draw per line
        BCC _L01

        JSR SCROLL_DOWN
        LDY #$02
        JSR DELAY_01

        LDX ZP_LEVEL_IDX
        INX
        CPX #16                         ;16 rows in total (?)
        BCC _L00

        ; After print the Title Message Draw 4 rows of street
        LDX #$03
_L02    STX ZP_LEVEL_IDX
        JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN

        LDY #$02
        JSR DELAY_01

        LDX ZP_LEVEL_IDX
        DEX
        BPL _L02

        ; Stay forever, until F1 is pressed from IRQ Handler
_L03    LDY #$14
        JSR DELAY_01

        ; Blink 'Press F1...'
        LDA COLOR_RAM + 40 * 17 + 8
        EOR #$03                        ;Switch between black and cyan
        LDY #$0F                        ;16 columns to blink
_L04    STA COLOR_RAM+40*17+8,Y         ;3 rows
        STA COLOR_RAM+40*18+8,Y
        STA COLOR_RAM+40*19+8,Y
        DEY
        BPL _L04
        JMP _L03

        ; (C) 1982 by Commodore electronics...
TITLE_MSG
        .ENC "screen"
        .BYTE $1B,$03,$1C,$20,$22,$2A,$29,$23   ; (C) 1982
        .TEXT         " BY     "
        .TEXT "   COMMODORE    "
        .TEXT "ELECTRONICS LTD",$1E             ; .
        .TEXT "      AND       "
        .TEXT " HAL LABORATORY "
        .TEXT "  PUSH ",$1D,$06,$22,$1D," OR  " ; 'F1'
.IF USE_JOYSTICK==0
        .TEXT "BUTTON ON PADDLE"
.ELSE
        .TEXT " BUTTON ON JOY",$22," "
.ENDIF
        .TEXT "    TO START    "
        .TEXT "                "

        ;
TITLE_ROWS_TBL
        .BYTE $80,$70,$60,$50,$80,$80,$80,$40
        .BYTE $80,$30,$80,$20,$10,$80,$00,$80

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Delay based on ticks. Register Y is number of ticks to wait
; Uses ZP_TIMER0_TRIGGERED
DELAY_00
_L00
        LDA #$00
        STA ZP_TIMER0_CNT
        STA ZP_TIMER0_TRIGGERED
_L01    LDA ZP_TIMER0_TRIGGERED
        BEQ _L01
        DEY
        BNE _L00
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Delay based on ticks. Register Y is number of ticks to wait
; Uses ZP_TIMER1_TRIGGERED
DELAY_01
_L00
        LDA #$00
        STA ZP_TIMER1_TRIGGERED
_L01    LDA ZP_TIMER1_TRIGGERED
        BEQ _L01
        DEY
        BNE _L00
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Clears the screen RAM with register A
CLEAR_SCREEN_RAM
        LDY #$00     ;#%00000000
_L00    STA SCREEN_RAM,Y
        STA SCREEN_RAM+$0100,Y
        STA SCREEN_RAM+$0200,Y
        STA SCREEN_RAM+$02E8,Y
        INY
        BNE _L00
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Setup screen, colors, etc.
INIT_SCREEN
        LDA #$44
        JSR CLEAR_SCREEN_RAM
        LDA #$00                        ;Black
        STA $D020                       ;Border Color
        STA $D021                       ;Background Color 0
        LDA #$08                        ;Orange color
        STA $D022                       ;Background Color 1, Multi-Color Register 0
        LDA #$0F                        ;Light Grey
        STA $D023                       ;Background Color 2, Multi-Color Register 1

        LDA #$0C                        ;Grey
        LDY #$00
_L00    STA COLOR_RAM,Y
        STA COLOR_RAM+$0100,Y
        STA COLOR_RAM+$0200,Y
        STA COLOR_RAM+$02E8,Y
        INY
        BNE _L00

        LDA #<(SCREEN_RAM + 32)
        STA ZP_TMP_PTR_LO
        LDA #>(SCREEN_RAM + 32)
        STA ZP_TMP_PTR_HI

        ; Fill the right part of the screen with spaces
        LDX #24                         ;In total 24 rows

_L01    LDY #$07                        ;7 colums: from 32 to 39
        LDA #$20                        ;Space character
_L02    STA (ZP_TMP_PTR_LO),Y
        DEY
        BPL _L02

        LDA ZP_TMP_PTR_LO
        CLC
        ADC #$28     ;#%00101000
        STA ZP_TMP_PTR_LO
        LDA ZP_TMP_PTR_HI
        ADC #$00     ;#%00000000
        STA ZP_TMP_PTR_HI
        DEX
        BPL _L01

        LDY #$07                        ;7 colums
_L03    LDA SCORE_MSG,Y
        STA SCREEN_RAM+40*1+32,Y
        LDA TIME_MSG,Y
        STA SCREEN_RAM+40*4+32,Y
        LDA HISCORE_MSG,Y
        STA SCREEN_RAM+40*7+32,Y
        LDA SPEED_MSG,Y
        STA SCREEN_RAM+40*10+32,Y

        LDA #$01                        ;White
        STA COLOR_RAM+40*1+32,Y         ;Color for 'Score' txt
        STA COLOR_RAM+40*10+32,Y        ;Color for 'Speed' txt
        STA COLOR_RAM+40*14+32,Y        ;Color for 'Extended' txt
        STA COLOR_RAM+40*15+32,Y        ;Color for '    Time' txt

        LDA #$03                        ;Cyan
        STA COLOR_RAM+40*4+32,Y         ;Color for 'Time' txt
        STA COLOR_RAM+40*11+32,Y        ;Color for Speed Dashboard top
        STA COLOR_RAM+40*12+32,Y        ;Color for Speed Dashboard bottom

        LDA #$04                        ;Purple
        STA COLOR_RAM+40*16+32,Y        ;Color to count the passed cars
        STA COLOR_RAM+40*17+32,Y        ;These is a grid of 3x3 cars
        STA COLOR_RAM+40*18+32,Y
        STA COLOR_RAM+40*19+32,Y
        STA COLOR_RAM+40*20+32,Y
        STA COLOR_RAM+40*21+32,Y

        LDA #$05                        ;Green
        STA COLOR_RAM+40*7+32,Y         ;Color for Hi-Score txt

        LDA #$07                        ;Yellow color for...
        STA COLOR_RAM+40*2+32,Y         ;... for Score value
        STA COLOR_RAM+40*5+32,Y         ;... for Time value
        STA COLOR_RAM+40*8+32,Y         ;... for Hi-Score value
        STA COLOR_RAM+40*23+32,Y        ;... for 'Bonus' txt
        STA COLOR_RAM+40*24+32,Y        ;... for '1000 PTS' txt
        DEY
        BPL _L03

        ; Print "KM/H"
        LDY #$71
        STY SCREEN_RAM+40*11+38         ;Place "K" of KM/H
        INY
        STY SCREEN_RAM+40*11+39         ;Place "M" of KM/H
        INY
        STY SCREEN_RAM+40*12+38         ;Place "/" of KM/H
        INY
        STY SCREEN_RAM+40*12+39         ;Place "H" of KM/H

        JSR PRINT_SCORE_AND_TIME
        JSR PRINT_SPEED

        LDA #<SCREEN_RAM
        STA ZP_TMP_PTR_LO
        LDA #>SCREEN_RAM
        STA ZP_TMP_PTR_HI

        LDX #$18                        ;x=24
_L04    LDY #$03                        ;y=3
_L05    CPY #$00
        BNE _L06

        TXA
        AND #$03
        BNE _L06
        LDA #$57                        ;Left shoulder char (?)
        BNE _L07

_L06    LDA SHOULDER_PATTERN_LEFT_B,Y
_L07    STA (ZP_TMP_PTR_LO),Y
        DEY
        BPL _L05
        LDA ZP_TMP_PTR_LO
        CLC
        ADC #40
        STA ZP_TMP_PTR_LO
        LDA ZP_TMP_PTR_HI
        ADC #$00
        STA ZP_TMP_PTR_HI
        DEX
        BPL _L04
        LDA #<(SCREEN_RAM+25)
        STA ZP_TMP_PTR_LO
        LDA #>(SCREEN_RAM+25)
        STA ZP_TMP_PTR_HI
        LDX #24
_L08    LDY #$03
_L09    CPY #$02
        BNE _L10
        TXA
        AND #$03
        BNE _L10
        LDA #$46                        ;Right shoulder char (?)
        BNE _L11
_L10    LDA SHOULDER_PATTERN_RIGHT_B,Y
_L11    STA (ZP_TMP_PTR_LO),Y
        DEY
        BPL _L09
        LDA ZP_TMP_PTR_LO
        CLC
        ADC #40
        STA ZP_TMP_PTR_LO
        LDA ZP_TMP_PTR_HI
        ADC #$00
        STA ZP_TMP_PTR_HI
        DEX
        BPL _L08

        ; Set pointer to color ram
        LDA #<COLOR_RAM+7
        STA ZP_TMP_PTR_LO
        LDA #>COLOR_RAM+7
        STA ZP_TMP_PTR_HI

        ; Paint 25 * 20 of Light Blue (Road)
        LDX #24
_L12    LDY #19
        LDA #$0E                        ;Color Light Blue
_L13    STA (ZP_TMP_PTR_LO),Y
        DEY
        BPL _L13

        LDA ZP_TMP_PTR_LO
        CLC
        ADC #40
        STA ZP_TMP_PTR_LO
        LDA ZP_TMP_PTR_HI
        ADC #$00
        STA ZP_TMP_PTR_HI
        DEX
        BPL _L12

        ; Setup "row" properties
        LDX #24
_L14    LDA #26
        STA ZP_ROAD_X_LEFT_ROW_TBL,X
        LDA #224
        STA ZP_ROAD_X_RIGHT_ROW_TBL,X
        LDA #$07                        ;Regular "road mode"
        STA ZP_ROAD_STATE_ROW_TBL,X
        DEX
        BPL _L14
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
        .ENC "screen"
SCORE_MSG
        .TEXT " SCORE  "
TIME_MSG
        .TEXT "  TIME  "
HISCORE_MSG
        .TEXT "HI",$1F,"SCORE"
SPEED_MSG
        .TEXT " SPEED  "

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
SCROLL_DOWN
        LDY #31
_L00
        ; Screen RAM
        .FOR I:=23, I>=0, I-=1
        LDA SCREEN_RAM+40*I,Y
        STA SCREEN_RAM+40*(I+1),Y
        .NEXT

        ; Color RAM
        .FOR I:=23, I>=0, I-=1
        LDA COLOR_RAM+40*I,Y
        STA COLOR_RAM+40*(I+1),Y
        .NEXT

        DEY
        BMI _L01
        JMP _L00

_L01    LDY #23
_L02    LDA ZP_ROAD_X_LEFT_ROW_TBL,Y
        STA ZP_ROAD_X_LEFT_ROW_TBL+1,Y
        LDA ZP_ROAD_X_RIGHT_ROW_TBL,Y
        STA ZP_ROAD_X_RIGHT_ROW_TBL+1,Y
        LDA ZP_ROAD_STATE_ROW_TBL,Y
        STA ZP_ROAD_STATE_ROW_TBL+1,Y
        DEY
        BPL _L02
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Looks like a "random" number generator
UPDATE_RANDOM_NUMBER
        STY ZP_TMP_4A
        LDY #$05
_L00    ASL ZP_RANDOM_NUMBER            ;ZP_RANDOM_NUMBER *= 2
        ROL ZP_RANDOM_NUMBER_SEED       ;ZP_RANDOM_NUMBER_SEED *= 2
        ROL A
        ROL A
        EOR ZP_RANDOM_NUMBER
        ROL A
        EOR ZP_RANDOM_NUMBER
        LSR A
        LSR A
        EOR #$FF
        AND #$01
        ORA ZP_RANDOM_NUMBER
        STA ZP_RANDOM_NUMBER
        DEY
        BPL _L00

        LDY ZP_TMP_4A
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Print Score and Time.
; Updates Hi-Score if Score is bigger than Hi-Score.
PRINT_SCORE_AND_TIME
        ; Check whether Score > Hi-Score
        LDA ZP_HI_SCORE_01
        SEC
        SBC ZP_SCORE_01
        LDA ZP_HI_SCORE_02
        SBC ZP_SCORE_02
        LDA ZP_HI_SCORE_03
        SBC ZP_SCORE_03
        BCS _L00

        ; Update Hi-Score
        LDA ZP_SCORE_01
        STA ZP_HI_SCORE_01
        LDA ZP_SCORE_02
        STA ZP_HI_SCORE_02
        LDA ZP_SCORE_03
        STA ZP_HI_SCORE_03

_L00
        ; Print Hi Score
        LDA #<HI_SCORE_OFFSET
        STA ZP_SCREEN_PTR_LO
        LDA #>HI_SCORE_OFFSET
        STA ZP_SCREEN_PTR_HI
        LDA #$00                        ;Print "0" as " "
        STA ZP_ZERO_IS_ZERO
        TAY                             ;Y is screen offset
        LDA ZP_HI_SCORE_03
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA ZP_HI_SCORE_02
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA ZP_HI_SCORE_01
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA #$21                        ;Append "0" after Hi-Score
        STA (ZP_SCREEN_PTR_LO),Y

        ; Print Score
        LDA #<SCORE_OFFSET
        STA ZP_SCREEN_PTR_LO
        LDA #>SCORE_OFFSET
        STA ZP_SCREEN_PTR_HI
        LDA #$00                        ;Print "0" as " "
        STA ZP_ZERO_IS_ZERO
        TAY
        LDA ZP_SCORE_03
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA ZP_SCORE_02
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA ZP_SCORE_01
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA #$21                        ;Append "0" after Score
        STA (ZP_SCREEN_PTR_LO),Y

        ; Print Time
        LDA #<TIME_OFFSET
        STA ZP_SCREEN_PTR_LO
        LDA #>TIME_OFFSET
        STA ZP_SCREEN_PTR_HI
        LDA #$00                        ;Print "0" as " "
        STA ZP_ZERO_IS_ZERO
        TAY
        LDA ZP_TIME
        STA ZP_BCD_TO_PRINT
        JSR PRINT_BCD
        LDA ZP_ZERO_IS_ZERO
        BNE _L01
        DEY
        LDA #$21                        ;Append a "0" after Time
        STA (ZP_SCREEN_PTR_LO),Y
_L01    RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Prints BCD character in ZP_SCREEN_PTR,Y
; Y gets incremented
; If ZP_ZERO_IS_ZERO, then '0' is printed as '0', otherwise as ' '
PRINT_BCD
        ; Print MSB first
        LDA ZP_BCD_TO_PRINT
        LSR A
        LSR A
        LSR A
        LSR A
        STA ZP_DIGIT_TO_PRINT
        JSR PRINT_DIGIT

        ; Print LSB after
        LDA ZP_BCD_TO_PRINT
        AND #$0F
        STA ZP_DIGIT_TO_PRINT

PRINT_DIGIT
        LDA ZP_DIGIT_TO_PRINT
        BNE _L01

        ; Determine how to print '0'. With ' ' or with '0'?
        LDX ZP_ZERO_IS_ZERO
        BNE _L01
        LDA #$20                        ;Space character
        STA (ZP_SCREEN_PTR_LO),Y
        BNE _L02

_L01    CLC
        ADC #$21                        ;Get correct number. $21 is "Zero"
        STA (ZP_SCREEN_PTR_LO),Y
        LDA #$01
        STA ZP_ZERO_IS_ZERO
_L02    INY                             ;Update char pointer
        RTS

        ; Unused ?
        .BYTE $70,$E6,$60,$04,$04,$05

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
PRINT_SPEED
        LDX #$00                        ;'0' is ' '
        STX ZP_ZERO_IS_ZERO
        LDA ZP_SPEED_HI
        AND #$0F                        ;#%00001111
        STA ZP_DIGIT_TO_PRINT
        JSR _L00
        LDA ZP_SPEED_LO
        LSR A
        LSR A
        LSR A
        LSR A
        STA ZP_DIGIT_TO_PRINT
        JSR _L00
        LDA ZP_SPEED_LO
        AND #$0F     ;#%00001111
        STA ZP_DIGIT_TO_PRINT
        JSR _L00
        LDA ZP_ZERO_IS_ZERO
        BNE _L03
        INC ZP_ZERO_IS_ZERO
        DEX
        DEX
_L00    LDA ZP_DIGIT_TO_PRINT
        BNE _L01
        LDY ZP_ZERO_IS_ZERO
        BNE _L01
        LDY #$0A     ;#%00001010
        BNE _L02
_L01    TAY
        LDA #$01        ;'0' is '0'
        STA ZP_ZERO_IS_ZERO

        ; Update Speed Dashboard
_L02    LDA DIGITS_DASHBOARD_TL_TBL,Y
        STA SCREEN_RAM+40*11+32,X
        LDA DIGITS_DASHBOARD_TR_TBL,Y
        STA SCREEN_RAM+40*11+33,X
        LDA DIGITS_DASHBOARD_BL_TBL,Y
        STA SCREEN_RAM+40*12+32,X
        LDA DIGITS_DASHBOARD_BR_TBL,Y
        STA SCREEN_RAM+40*12+33,X
        INX
        INX
_L03    RTS

        ; Digits used in speed dashboard: top-left
DIGITS_DASHBOARD_TL_TBL
        .BYTE $5B,$6D,$61,$61,$67,$6B,$6B,$5B,$6B,$6B,$6D
        ; Digits used in speed dashboard: top-right
DIGITS_DASHBOARD_TR_TBL
        .BYTE $5C,$5F,$62,$62,$68,$6C,$6C,$5C,$62,$62,$6E
        ; Digits used in speed dashboard: bottom-left
DIGITS_DASHBOARD_BL_TBL
        .BYTE $5D,$6F,$63,$65,$69,$65,$63,$6F,$63,$65,$6F
        ; Digits used in speed dashboard: bottom-right
DIGITS_DASHBOARD_BR_TBL
        .BYTE $5E,$60,$64,$66,$6A,$66,$66,$60,$66,$66,$70

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Draw road (?)
DRAW_ROAD_TOP_ROW
        LDA ZP_HEADLIGHT_DURATION
        BEQ _L00
        DEC ZP_HEADLIGHT_DURATION

        ; Paint top row with "full" characters
_L00    LDY #31                         ;32 columns
        LDA #$44                        ;"Full" character
_L01    STA SCREEN_RAM,Y
        DEY
        BPL _L01

        LDY ZP_ROAD_STATE
        LDA ROAD_COLOR_TBL,Y
        LDX #31                         ;32 columns
_L02    STA COLOR_RAM,X
        DEX
        BPL _L02

        INC ZP_SHOULDER_PATTERN_CHOOSER
        LDA ZP_SHOULDER_PATTERN_CHOOSER
        AND #$03
        STA ZP_SHOULDER_PATTERN_CHOOSER

        LDA ZP_ROAD_STATE
        CMP #$05
        BCC _STATES_00_04
        JMP _STATES_05_08

        ; Road State 00-04
_STATES_00_04
        LDA ZP_SHOULDER_LEFT_IDX
        CMP #16
        BCS _L04
        INC ZP_SHOULDER_LEFT_IDX

_L04    LDA ZP_SHOULDER_RIGHT_IDX
        CMP #84
        BCS _L05
        INC ZP_SHOULDER_RIGHT_IDX
        JMP DRAW_SHOULDERS

        ; Only check road state every 8 "ticks"
_L05    INC ZP_ROAD_STATE_DELAY
        LDA ZP_ROAD_STATE_DELAY
        CMP #$08
        BCC _L09
        LDA #$00
        STA ZP_ROAD_STATE_DELAY

        LDA ZP_ROAD_STATE
        CMP #$03
        BCS _STATES_03_04
        CMP #$02
        BNE _STATES_00_01

        ; Road State 02: Night
        LDA #20
        STA ZP_HEADLIGHT_DURATION

        ; Road States 00, 01
_STATES_00_01
        JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$03
        BEQ _L09
        CMP #$03
        BEQ _L09
        CMP #$01
        BNE _L10

        ;ZP_SHOULDER_LEFT_IDX--
        LDA ZP_SHOULDER_LEFT_IDX
        SEC
        SBC #$01
        CMP #$10
        BCS _L07
        LDA #$10
_L07    STA ZP_SHOULDER_LEFT_IDX

        ;ZP_SHOULDER_RIGHT_IDX++
        LDA ZP_SHOULDER_RIGHT_IDX
        CLC
        ADC #$01
        CMP #100
        BCC _L08
        LDA #100
_L08    STA ZP_SHOULDER_RIGHT_IDX

_L09    JMP DRAW_SHOULDERS

_L10    LDA ZP_SHOULDER_LEFT_IDX
        CLC
        ADC #$01
        CMP #32
        BCC _L11
        LDA #32
_L11    STA ZP_SHOULDER_LEFT_IDX

        LDA ZP_SHOULDER_RIGHT_IDX
        SEC
        SBC #$01
        CMP #84
        BCS _L08
        LDA #84
        BNE _L08

_STATES_03_04
        CMP #$03                        ;"Green" state
        BNE _STATE_04

        ; Road State 03 (Green)
        LDA #$00
        STA ZP_ROAD_TURN_TBL_IDX
        LDA ZP_SHOULDER_LEFT_IDX
        CMP #17
        BCC _L13
        DEC ZP_SHOULDER_LEFT_IDX
_L13    CMP #16
        BCS _L14
        INC ZP_SHOULDER_LEFT_IDX
_L14    LDA ZP_SHOULDER_RIGHT_IDX
        CMP #84
        BCC _L15
        DEC ZP_SHOULDER_RIGHT_IDX
_L15    CMP #83
        BCS _L09
        INC ZP_SHOULDER_RIGHT_IDX
        JMP DRAW_SHOULDERS

        ; Road State 04
_STATE_04
        LDA ZP_SHOULDER_LEFT_IDX
        CMP #17
        BCC _L17
        DEC ZP_SHOULDER_LEFT_IDX
_L17    CMP #16
        BCS _L18
        INC ZP_SHOULDER_LEFT_IDX
_L18    LDA ZP_SHOULDER_RIGHT_IDX
        CMP #101
        BCC _L19
        DEC ZP_SHOULDER_RIGHT_IDX
_L19    CMP #100
        BCS DRAW_SHOULDERS
        INC ZP_SHOULDER_RIGHT_IDX
        JMP DRAW_SHOULDERS

        ; Road States: 05-08
_STATES_05_08
        LDA ZP_ROAD_STATE
        CMP #$05                        ;Turns state
        BNE _STATES_06_08

        ; Road State 05: Turns
        INC ZP_ROAD_TURN_TBL_IDX
        LDA ZP_ROAD_TURN_TBL_IDX
        AND #$3F                        ;ROAD_TURN_TBL size is 64.
        STA ZP_ROAD_TURN_TBL_IDX        ; so, don't let it overflow

        TAY
        LDA ROAD_TURN_TBL,Y
        CLC
        ADC #16
        STA ZP_SHOULDER_LEFT_IDX

        LDA ROAD_TURN_TBL,Y
        CLC
        ADC #83
        STA ZP_SHOULDER_RIGHT_IDX
        JMP DRAW_SHOULDERS

_STATES_06_08
        CMP #$06     ;#%00000110
        BNE _STATES_07_08
        JMP DRAW_SPLIT_SCREEN

_STATES_07_08
        CMP #$07     ;#%00000111
        BNE _STATE_08

        ; Road State 07
        LDA ZP_SHOULDER_LEFT_IDX
        BEQ DRAW_SHOULDERS
        DEC ZP_SHOULDER_LEFT_IDX
        JMP DRAW_SHOULDERS

        ; Road State 08
_STATE_08
        LDA ZP_LEFT_SHOULDER_ENABLED
        BEQ _L20
        DEC ZP_LEFT_SHOULDER_ENABLED
        JMP DRAW_SHOULDERS

_L20    LDA ZP_SHOULDER_LEFT_IDX
        CMP #$0F
        BCC _L21

        LDA #$00
        STA ZP_ROAD_STATE
        BNE DRAW_SHOULDERS

_L21    INC ZP_SHOULDER_LEFT_IDX

        ; Fallthrough

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
DRAW_SHOULDERS
        LDA ZP_SHOULDER_LEFT_IDX        ;A = ZP_SHOULDER_LEFT_IDX
        ASL A                           ;A *= 2
        CLC
        ADC #24                         ;A += 24
        STA ZP_ROAD_X_LEFT_ROW_TBL

        LDA ZP_SHOULDER_RIGHT_IDX       ;A = ZP_SHOULDER_RIGHT_IDX
        ASL A                           ;A *= 2
        CLC
        ADC #24                         ;A += 24
        STA ZP_ROAD_X_RIGHT_ROW_TBL

        LDA ZP_SHOULDER_RIGHT_IDX       ;A = ZP_SHOULDER_RIGHT_IDX
        LSR A
        LSR A                           ;A /= 4
        STA a1D
        INC a1D

        LDA ZP_SHOULDER_LEFT_IDX        ;A = ZP_SHOULDER_LEFT_IDX
        LSR A
        LSR A                           ;A /= 4
        TAY
        INY

        LDA ZP_ROAD_STATE
        STA ZP_ROAD_STATE_ROW_TBL
        CMP #$07
        BCC _L00
        CPY #$06
        BCS _L00

        LDY #$06

_L00    LDX ZP_ROAD_STATE
        LDA ROAD_COLOR2_TBL,X
_L01    STA COLOR_RAM+1,Y
        INY
        CPY a1D
        BCC _L01

        ; Left Shoulder
        ; Setup Screen ptr
        LDA ZP_SHOULDER_LEFT_IDX
        LSR A                           ;ZP_SHOULDER_LEFT_IDX /= 4
        LSR A                           ;Since we draw 4 char shoulders
        STA ZP_TMP_PTR_LO               ;in this loop (?)
        LDA #$04
        STA ZP_TMP_PTR_HI

        ; Draw left shoulder (4 chars)
        LDA ZP_SHOULDER_LEFT_IDX        ;Use the 2-LSB to index the pattern to print
        AND #$03
        TAY
        LDX SHOULDER_PATTERN_IDX_TBL,Y  ;X=[0,4,8,12] Offsets for the parttern
        LDY #$00
_L02    LDA ZP_SHOULDER_PATTERN_CHOOSER
        BNE _L03

        LDA SHOULDER_PATTERN_LEFT_A,X   ;PATTERN_CHOOSER=0
        BNE _L04

_L03    LDA SHOULDER_PATTERN_LEFT_B,X
_L04    STA (ZP_TMP_PTR_LO),Y
        INX
        INY
        CPY #$04                        ;Draw 4 shoulder chars;
        BCC _L02                        ;No, loop until we do so

        ; Right Shoulder
        ; Setup Screen ptr
        LDA ZP_SHOULDER_RIGHT_IDX
        LSR A                           ;ZP_SHOULDER_RIGHT_IDX /= 4
        LSR A                           ;Since we draw 4 char shoulders
        STA ZP_TMP_PTR_LO               ;in this loop
        LDA #$04
        STA ZP_TMP_PTR_HI

        ; Draw right shoulder (4 chars)
        LDA ZP_SHOULDER_RIGHT_IDX
        AND #$03
        TAY
        LDX SHOULDER_PATTERN_IDX_TBL,Y  ;X=[0,4,8,12] Offsets for the pattern
        LDY #$00
_L05    LDA ZP_SHOULDER_PATTERN_CHOOSER
        BNE _L06
        LDA SHOULDER_PATTERN_RIGHT_A,X
        BNE _L07
_L06    LDA SHOULDER_PATTERN_RIGHT_B,X
_L07    STA (ZP_TMP_PTR_LO),Y
        INX
        INY
        CPY #$04                        ;Draw 4 shoulder chars?
        BCC _L05                        ;No, loop until we do so

        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Road State 06: Split screen
DRAW_SPLIT_SCREEN
        LDY #$05
        LDA #$0E                        ;Color Light Blue
_L00    STA COLOR_RAM+7,Y
        STA COLOR_RAM+19,Y
        DEY
        BPL _L00

        LDY #$03
_L01    LDA ZP_SHOULDER_PATTERN_CHOOSER
        BNE _L02

        ; PATTERN_CHOOSER == 0
        LDA SHOULDER_PATTERN_LEFT_A,Y
        STA SCREEN_RAM+4,Y              ;Left road, left shoulder
        LDA SHOULDER_PATTERN_LEFT_A+4,Y
        STA SCREEN_RAM+16,Y             ;Right road, left shoulder
        LDA SHOULDER_PATTERN_RIGHT_A+12,Y
        STA SCREEN_RAM+12,Y             ;Left road, right shoulder
        LDA SHOULDER_PATTERN_RIGHT_A,Y
        STA SCREEN_RAM+25,Y             ;Right road, right shoulder
        BNE _L03


        ; PATTERN_CHOOSER != 0
_L02    LDA SHOULDER_PATTERN_LEFT_B,Y
        STA SCREEN_RAM+4,Y              ;Left road, Left shoulder
        LDA SHOULDER_PATTERN_LEFT_B+4,Y
        STA SCREEN_RAM+16,Y             ;Right road, Left shoulder
        LDA SHOULDER_PATTERN_RIGHT_B+12,Y
        STA SCREEN_RAM+12,Y             ;Left road, right shoulder
        LDA SHOULDER_PATTERN_RIGHT_B,Y
        STA SCREEN_RAM+25,Y             ;Right road, right shoulder

_L03    DEY
        BPL _L01

        LDA #56
        STA ZP_ROAD_X_LEFT_ROW_TBL
        LDA #224
        STA ZP_ROAD_X_RIGHT_ROW_TBL
        LDA #$06                        ;Split screen for row
        STA ZP_ROAD_STATE_ROW_TBL
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
ROAD_COLOR_TBL
        .BYTE $0D,$09,$08,$0D,$0D,$0A,$0B,$0C
        .BYTE $0C
ROAD_COLOR2_TBL
        .BYTE $0E,$09,$08,$0E,$0E,$0E,$0E,$0E
        .BYTE $0E

        ; Each of these patterns consist of 4 rows. Each row has 4 chars.
        ;
        ; Pattern A = {
        ;    ROW0,
        ;    ROW1,
        ;    ROW2,
        ;    ROW3,
        ;  }
        ; And each ROW has:
        ; row = [C0, C1, C2, C3] where:
        ;  C0 = left-most part of the shoulder
        ;  C1 = middle-left
        ;  C2 = middle-right
        ;  C3 = right-most part of the shoulder.
        ; [C0,...C3] are screen codes (the chars to print).
        ;
        ; The rows are:
        ;  ROW0 represents a shoulder that is indented to the left.
        ;  ROW..N is a indented a bit to the rigth compared to ROW N-1.
SHOULDER_PATTERN_RIGHT_A
        .BYTE $40,$45,$46,$44
        .BYTE $41,$45,$47,$48
        .BYTE $42,$45,$45,$49
        .BYTE $43,$45,$45,$4A

SHOULDER_PATTERN_RIGHT_B
        .BYTE $40,$45,$4B,$44
        .BYTE $41,$45,$47,$44
        .BYTE $42,$45,$45,$4C
        .BYTE $43,$45,$45,$4D

SHOULDER_PATTERN_LEFT_A
        .BYTE $57,$52,$52,$51
        .BYTE $56,$52,$52,$50
        .BYTE $55,$54,$52,$4F
        .BYTE $44,$53,$52,$4E

SHOULDER_PATTERN_LEFT_B
        .BYTE $5A,$52,$52,$51
        .BYTE $59,$52,$52,$50
        .BYTE $44,$54,$52,$4F
        .BYTE $44,$58,$52,$4E

        ; Offset used for SHOULDER_PATTERN_A* and SHOULDER_PATTERN_B*
SHOULDER_PATTERN_IDX_TBL
        .BYTE $00,$04,$08,$0C

        ; Used to draw the "turns".
        ; Offset to the byte to draw
        ; Size: 64 bytes
ROAD_TURN_TBL
        .BYTE $00,$00,$01,$01,$01,$02,$02,$02
        .BYTE $03,$03,$04,$04,$05,$06,$07,$08
        .BYTE $09,$0A,$0B,$0C,$0D,$0D,$0E,$0E
        .BYTE $0F,$0F,$0F,$10,$10,$10,$11,$11
        .BYTE $11,$11,$10,$10,$10,$0F,$0F,$0F
        .BYTE $0E,$0E,$0D,$0D,$0C,$0B,$0A,$09
        .BYTE $08,$07,$06,$05,$04,$04,$03,$03
        .BYTE $02,$02,$02,$01,$01,$01,$00,$00

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Not 100% sure that is the the main loop, but looks like it
MAIN_LOOP
        LDA ZP_SPEED_LO
        BNE _L00
        LDA ZP_SPEED_HI
        BNE _L00

        ; Speed is 0
        LDA #$F4                        ;Sprite pointer: Stopped car
        STA SPR_FRAME_PTR_07
        JMP _L11

_L00    LDA ZP_ROAD_STATE
        CMP #$08
        BEQ _L02

        ; ZP_LEVEL_TICK keeps the "life" of the Level.
        ; Each Level (road state) might use this variable to know
        ; much "time" it has left.
        ; When it reaches 250, it switches to a new Level
        INC ZP_LEVEL_TICK
        LDA ZP_LEVEL_TICK
        CMP #250
        BCC _L02

        LDA #$00
        STA ZP_LEVEL_TICK
        LDY ZP_LEVEL_IDX
        INY
        CPY #40
        BCC _L01

        ; Levels 0-31 are used only once, once it reaches level 39,
        ; the game loops between Levels 32-39
        LDY #32
_L01    STY ZP_LEVEL_IDX
        LDA ROAD_STATE_TBL,Y
        STA ZP_ROAD_STATE
_L02    JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        JSR INCREMENT_SCORE
        JSR ANIMATE_HERO_CAR

        ; Check collision with shoulder
        LDA $D00F                       ;A = Sprite 7 Y Pos
        LSR A
        LSR A
        LSR A                           ;A /= 8
        SEC
        SBC #$05                        ;A -= 5
        TAY
        LDA ZP_ROAD_X_LEFT_ROW_TBL,Y
        CMP $D00E                       ;Sprite 7 X Pos
        BCS _L04

        CLC
        ADC #24
        CMP $D00E                       ;Sprite 7 X Pos
        BCS _L03

        LDA ZP_ROAD_X_RIGHT_ROW_TBL,Y
        CLC
        ADC #$02
        CMP $D00E                       ;Sprite 7 X Pos
        BCC _L04

        SEC
        SBC #22
        CMP $D00E                       ;Sprite 7 X Pos
        BCC _L03

        LDA #$05
        STA ZP_PIXELS_TO_MOVE_CAR

.if USE_JOYSTICK == 1
        LDA #%00111110                  ;Disable rumble in both joysticks
        STA $DC00
.endif
        LDA #$00
        STA ZP_BRAKE_FORCE
        STA ZP_SOUND_EFFECT_TO_PLAY
        BEQ _L05

        ; Car is colliding with shoulder,
        ; but this is not a crash yet, just warning.
_L03
.if USE_JOYSTICK == 1
        LDA #%01111110                  ;Enable rumble in J1
        STA $DC00
.endif
        LDA #$01
        STA ZP_PIXELS_TO_MOVE_CAR       ;Limit car horizontal movement
        STA ZP_BRAKE_FORCE              ;Apply brake, so car cannot speed up
        STA ZP_SOUND_EFFECT_TO_PLAY     ;Play noise
        BNE _L05

_L04    JMP DO_COLLISION

_L05    LDA ZP_ROAD_STATE_ROW_TBL,Y
        CMP #$01
        BNE _L06

        ; Ice
        LDA ZP_PIXELS_TO_MOVE_CAR
        CMP #$05
        BNE _L06
        LDA #$02
        STA ZP_PIXELS_TO_MOVE_CAR
        STA ZP_SOUND_EFFECT_TO_PLAY

_L06    LDA ZP_ROAD_STATE_ROW_TBL,Y
        CMP #$06
        BNE _L07
        LDA #108
        CMP $D00E                       ;Sprite 7 X Pos
        BCS _L07
        LDA #179
        CMP $D00E                       ;Sprite 7 X Pos
        BCC _L07
        LDA #$01
        STA ZP_PIXELS_TO_MOVE_CAR
        STA ZP_BRAKE_FORCE
        STA ZP_SOUND_EFFECT_TO_PLAY
        LDA #129
        CMP $D00E                       ;Sprite 7 X Pos
        BCS _L07
        LDA #158
        CMP $D00E                       ;Sprite 7 X Pos
        BCC _L07
        JMP DO_COLLISION

_L07    LDY ZP_PIXELS_TO_MOVE_CAR
.IF USE_JOYSTICK == 0
        ;Update car X position based on Paddle reading
_L08    LDA ZP_PADDLE_1_VALUE_INV
        CMP $D00E                       ;Sprite 7 X Pos
        BCS _L09

        ; Move Hero to the left
        DEC $D00E                       ;Sprite 7 X Pos
        JMP _L10

        ; Move Hero to the right
_L09    INC $D00E                       ;Sprite 7 X Pos
.ELSE
        ;Update car X position based on Joystick #1
_L08    LDA ZP_PADDLE_1_VALUE_INV
        AND #%00000100                  ;Left (Active Low)
        BNE _TEST_RIGHT

        ; Move Hero to the left
        DEC $D00E    ;Sprite 7 X Pos
        JMP _L10

_TEST_RIGHT
        LDA ZP_PADDLE_1_VALUE_INV
        AND #%00001000                  ;Right (Active Low)
        BNE _L10
        INC $D00E    ;Sprite 7 X Pos
.ENDIF
_L10    DEY
        BPL _L08

_L11    LDA ZP_HEADLIGHT_DURATION
        BEQ _L13
        CMP #$01
        BNE _L12

        ; Turn off headlights (sprites 4-6)
        LDA $D015                       ;Sprite display Enable
        AND #$8F                        ;#%10001111
        STA $D015                       ;Sprite display Enable
        JMP _L13

        ; Turn On Headlights (sprites 4-6)
_L12    LDA $D015                       ;Sprite display Enable
        ORA #$70                        ;#%01110000
        STA $D015                       ;Sprite display Enable
        LDA #$70                        ;#%01110000
        STA $D017                       ;Sprites Expand 2x Vertical (Y)
        STA $D01D                       ;Sprites Expand 2x Horizontal (X)
        LDA $D01C                       ;Sprites Multi-Color Mode Select
        AND #$8F                        ;#%10001111
        STA $D01C                       ;Sprites Multi-Color Mode Select
        LDA #$0C                        ;Color Grey 2
        STA $D02B                       ;Sprite 4 Color
        STA $D02C                       ;Sprite 5 Color
        LDA #$0F                        ;Color Grey 3
        STA $D02D                       ;Sprite 6 Color
        LDY #$FC                        ;Headlight top-left
        STY SPR_FRAME_PTR_04
        INY                             ;Headlight top-right
        STY SPR_FRAME_PTR_05
        INY                             ;Headlight center
        STY SPR_FRAME_PTR_06

        ; Adjust headlights sprites based on Car's position
        ; Adjust Y position
        LDA $D00F                       ;Sprite 7 Y Pos
        SEC
        SBC #42                         ;Sprite 6.Y = Car.Y - 42
        STA $D00D                       ;Sprite 6 Y Pos (Central Headlight)
        SEC
        SBC #32                         ;Sprite 5/4.Y = Car.Y - 74 (-42 - 32)
        STA $D00B                       ;Sprite 5 Y Pos (Top-Right headlight)
        STA $D009                       ;Sprite 4 Y Pos (Top-Left headlight)

        ; Adjust X position
        LDA $D00E                       ;Sprite 7 X Pos
        CLC
        ADC #10                         ;Sprite 5.X = Hero.X + 10
        STA $D00A                       ;Sprite 5 X Pos (Top-Right headlight)
        SEC
        SBC #24                         ;Sprite 6.X = Hero.X - 14 (10 - 24 )
        STA $D00C                       ;Sprite 6 X Pos (Central Headlight)
        SEC
        SBC #24                         ;Sprite 6.X = Hero.X - 38 (10 - 24 - 24)
        STA $D008                       ;Sprite 4 X Pos (Top-Left headlight)

_L13    LDA ZP_IS_GAME_OVER
        BEQ _L14
        JSR GAME_OVER

_L14    LDA ZP_COLLISION_DETECTED
        BEQ _L15
        JMP DO_COLLISION

_L15    JMP MAIN_LOOP

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
START_TOP_ROW_BANNER
        .BYTE $79,$79,$79,$79,$79,$79,$79,$91
        .BYTE $92,$79,$79,$95,$96,$79,$79,$7A
        .BYTE $7E,$79,$79,$85,$8E,$79,$79,$95
        .BYTE $96,$79,$79,$79,$79,$79,$79,$79

START_BOTTOM_ROW_BANNER
        .BYTE $79,$79,$79,$79,$79,$79,$79,$93
        .BYTE $94,$79,$79,$97,$79,$79,$79,$7F
        .BYTE $80,$79,$79,$8F,$90,$79,$79,$97
        .BYTE $79,$79,$79,$79,$79,$79,$79,$79

ROAD_STATE_TBL
        ; Before $06, there is always a $04 since:
        ;  $06 = split road
        ;  $04 = green with split road warning message
        .BYTE $00,$01,$02,$03,$05,$04,$06,$03
        .BYTE $05,$00,$02,$00,$01,$00,$04,$06
        .BYTE $00,$02,$00,$03,$05,$00,$01,$00
        .BYTE $04,$06,$00,$01,$00,$02,$04,$06
        .BYTE $00,$02,$03,$05,$00,$01,$04,$06

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;Collision detected, do the collision animation (?)
DO_COLLISION
        LDY #$02
        STY ZP_BRAKE_FORCE
        DEY
        STY ZP_PLAY_CRASH_SOUND
        STY ZP_SID_VOICE_FILTER_MASK    ;Filter Voice #1
        DEY
        STY ZP_SOUND_EFFECT_TO_PLAY
        STY ZP_PLAY_SPLIT_ROAD_SOUND
        STY $D017                       ;Sprites Expand 2x Vertical (Y)
        STY $D01D                       ;Sprites Expand 2x Horizontal (X)
        STY ZP_HEADLIGHT_DURATION

        ; Turn off headlights sprites
        ; And turn on "Flames" sprites
        LDA $D015                       ;Sprite display Enable
        AND #$EF                        ;#%11101111
        ORA #$60                        ;#%01100000
        STA $D015                       ;Sprite display Enable

        ; No Multicolor for "Flames" sprites
        LDA $D01C                       ;Sprites Multi-Color Mode Select
        AND #$9F                        ;#%10011111
        STA $D01C                       ;Sprites Multi-Color Mode Select

        ; Set color for "Flames" sprites
        LDA #$0F                        ;Color Grey 3
        STA $D02D                       ;Sprite 6 Color
        LDA #$0C                        ;Color Grey 2
        STA $D02C                       ;Sprite 5 Color

        ; Set correct sprite frames for "Flames" sprites
        LDY #$F8                        ;Flames1 sprite
        STY SPR_FRAME_PTR_06
        INY                             ;Flames 2 sprite
        STY SPR_FRAME_PTR_05

        LDA #$07                        ;Set Road State to "normal"
        STA ZP_ROAD_STATE

        LDY #35                         ;Draw 35 rows
_L00    STY ZP_LEVEL_TICK

        LDA ZP_IS_GAME_OVER
        BEQ _L01
        JSR GAME_OVER

_L01    JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        JSR INCREMENT_SCORE
        JSR ANIMATE_HERO_CAR
        LDY ZP_LEVEL_TICK
        DEY
        BPL _L00

_L02    LDX #$03
        LDY $D00E                       ;Sprite 7 X Pos
_L03    CPY #50
        BCC _L04
        DEY
        DEX
        BPL _L03
        STY $D00E                       ;Sprite 7 X Pos
        JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        JSR INCREMENT_SCORE
        JSR ANIMATE_HERO_CAR

        LDA ZP_IS_GAME_OVER
        BEQ _L02
        JSR GAME_OVER
        JMP _L02

_L04    LDA #$03
        STA ZP_BRAKE_FORCE
_L05    LDA ZP_SPEED_LO
        BNE _L06
        LDA ZP_SPEED_HI
        BEQ _L07

_L06    JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        JSR INCREMENT_SCORE
        JSR ANIMATE_HERO_CAR

        LDA ZP_IS_GAME_OVER
        BEQ _L05
        JSR GAME_OVER
        JMP _L05

        ; Speed is 0, means that the flames
        ; animation should be stopped, and the flames sprites
        ; should be disabled.
_L07    LDA $D015                       ;Sprite display Enable
        AND #$8F                        ;#%10001111
        STA $D015                       ;Sprite display Enable
        LDA #$2F                        ;#%00101111
        STA $D418                       ;Select Filter Mode and Volume
        LDA #$BE
        STA $D416                       ;Filter Cutoff Frequency: High-Byte
        ; Don't filter any voice
        LDA #$F0                        ;#%11110000
        STA $D417                       ;Filter Resonance Control / Voice Input Control

        ; Reset some game variables
        LDA #$00
        STA ZP_FRAME_PTR_IDX
        STA ZP_CAR_ANIM_DELAY
        STA ZP_BRAKE_FORCE
        STA ZP_PLAY_CRASH_SOUND
        STA ZP_COLLISION_DETECTED
        STA ZP_PASSED_CARS_TOTAL
        STA ZP_SID_VOICE_FILTER_MASK

        ; Enable shoulder for 60 rows
        LDA #60
        STA ZP_LEFT_SHOULDER_ENABLED

        ; Set Road State == Shoulder (Purple)
        LDA #$08
        STA ZP_ROAD_STATE

        LDY ZP_LEVEL_IDX
        LDA ROAD_STATE_TBL,Y
        BEQ _L08                        ;Branch on =0 (Green)
        CMP #$03
        BEQ _L08                        ;Branch on =3 (Green)
        CMP #$04
        BEQ _L08                        ;Branch on =4 (Green + Split Screen warning)
        BNE _L09

        ; On "Green" Road States, start from the previous level
_L08    DEC ZP_LEVEL_IDX

_L09    LDA #250                        ;The current level should end now
        STA ZP_LEVEL_TICK

        JMP MAIN_LOOP

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Animates the Hero car, and also applies "laternal" delay
ANIMATE_HERO_CAR
        LDA ZP_CAR_MOVEMENT_DELAY_LO
        STA ZP_TMP_3D
        LDA ZP_CAR_MOVEMENT_DELAY_HI
        STA ZP_TMP_3E

        ; Delay used to control how fast the car moves horizontally.
        ; Not only during the race, but also used for the crash animation
        ; when the car moves from right to left.
_L00    LDA ZP_TMP_3D
        SEC
        SBC #$01
        STA ZP_TMP_3D
        LDA ZP_TMP_3E
        SBC #$00
        STA ZP_TMP_3E
        BCS _L00

        LDY ZP_CAR_ANIM_DELAY
        INY
        CPY #$02
        BCC _L01
        LDY #$00

        ; Switch between "stopped car" and "moving car"
        LDA ZP_FRAME_PTR_IDX
        EOR #$01
        AND #$01
        STA ZP_FRAME_PTR_IDX
        CLC
        ADC #$F4                        ;Hero car sprite frame
        STA SPR_FRAME_PTR_07

_L01    STY ZP_CAR_ANIM_DELAY
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
INCREMENT_SCORE
        ; Score++
        SED
        LDA ZP_SCORE_01
        CLC
        ADC #$01
        STA ZP_SCORE_01
        LDA ZP_SCORE_02
        ADC #$00
        STA ZP_SCORE_02
        LDA ZP_SCORE_03
        ADC #$00
        STA ZP_SCORE_03

        CLD
        LDA ZP_SCORE_01
        BNE _L00
        LDA ZP_SCORE_02
        AND #$1F                        ;20.000 points?
        BNE _L00                        ; No

        INC ZP_LIVES                    ; Yes, so add extra life (extended time)
        LDA #$5F
        STA ZP_TIMES_TO_DISPLAY_EXTENDED_TIME

        ; The more points you have, the more difficult is the game
_L00    LDY #$01
        LDA ZP_SCORE_02
        CMP #$40
        BEQ _L01

        CMP #$20
        BEQ _L02

        CMP #$05
        BEQ _L03

        CMP #$02
        BEQ _L04
        BNE _L05

        ; Enable the enemy cars as more points are added
        ; Enemy cars should appear at points: 2000,5000,20000,40000
_L01    STY ZP_ENABLE_ENEMY_CAR0+3      ;Score is 40xx ?
_L02    STY ZP_ENABLE_ENEMY_CAR0+2      ;Score is 20xx ?
_L03    STY ZP_ENABLE_ENEMY_CAR0+1      ;Score is 05xx ?
_L04    STY ZP_ENABLE_ENEMY_CAR0+0      ;Score is 02xx ?
_L05    RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
IRQ_HANDLER_GAME_LOOP
        LDA ZP_GAME_OVER_STATE
        BEQ _L00

        ; In "GAME OVER" state skip the input controls
        ; The car should not be moved by the user.
        SED
        JMP _L05

_L00
.IF USE_JOYSTICK == 0
        LDA #%01000000                  ;Enable Pot A
        STA $DC00                       ;CIA1: Data Port Register A

        LDA $D419                       ;Analog/Digital Converter: Game Paddle 1
        STA ZP_PADDLE_1_VALUE

        CMP #188
        BCC _L01

        LDA #$BC
        STA ZP_PADDLE_1_VALUE

_L01    LDA #$EC
        SEC
        SBC ZP_PADDLE_1_VALUE
        STA ZP_PADDLE_1_VALUE_INV
        LDA ZP_BRAKE_FORCE
        CMP #$02
        BCS _L02
.ELSE
        LDA $DC01
        STA ZP_PADDLE_1_VALUE_INV
        JMP _TEST_BUTTON
.ENDIF

_TEST_BUTTON

        LDA $DC01                       ;CIA1: Data Port Register B
.IF USE_JOYSTICK == 0
        AND #%00000100
.ELSE
        AND #%00010000
.ENDIF
        BNE _L07

        ; Button pressed
_L02    SED
        LDA ZP_BRAKE_FORCE
        BEQ _L05
        CMP #$01
        BEQ _L03
        CMP #$03
        BEQ _L07
        LDA #$50
        SEC
        SBC ZP_SPEED_LO
        LDA #$00
        SBC ZP_SPEED_HI
        BCC _L04
        BCS _L09
_L03    LDA #$50
        SEC
        SBC ZP_SPEED_LO
        LDA #$01
        SBC ZP_SPEED_HI
        BCS _L05
_L04    LDA ZP_SPEED_LO
        SEC
        SBC #$02
        STA ZP_SPEED_LO
        LDA ZP_SPEED_HI
        SBC #$00
        STA ZP_SPEED_HI
        JMP _L06

_L05    LDY ZP_SPEED_HI                 ;Values from 0 to 3 (0xx, 1xx, 2xx, 3xx)
        LDA ACCELERATION_TBL_LO,Y
        STA ZP_TMP_68
        LDA ACCELERATION_TBL_HI,Y
        STA ZP_TMP_69

        LDA ZP_UNUSED_29                ;Not used anywhere in the game
        CLC
        ADC ZP_TMP_68
        STA ZP_UNUSED_29

        LDA ZP_SPEED_LO
        ADC ZP_TMP_69
        STA ZP_SPEED_LO
        LDA ZP_SPEED_HI
        ADC #$00
        STA ZP_SPEED_HI

_L06    LDA #$20
        SEC
        SBC ZP_SPEED_LO
        LDA #$03
        SBC ZP_SPEED_HI
        BCS _L09
        LDA #$03
        STA ZP_SPEED_HI
        LDA #$20
        STA ZP_SPEED_LO
        JMP _L09

        ; Button not pressed
_L07    LDA ZP_SPEED_HI
        BNE _L08
        LDA ZP_SPEED_LO
        BEQ _L09
_L08    SED
        LDA ZP_SPEED_LO
        SEC
        SBC #$02
        STA ZP_SPEED_LO
        LDA ZP_SPEED_HI
        SBC #$00
        STA ZP_SPEED_HI

_L09    LDA ZP_SPEED_HI
        CMP #$04
        BCC _L10
        LDA #$00
        STA ZP_SPEED_LO
        STA ZP_SPEED_HI
_L10    CLD
        JSR PRINT_SCORE_AND_TIME

        INC ZP_PRINT_SPEED_DELAY        ;Speed is displayed with a 7 frame delay
        LDA ZP_PRINT_SPEED_DELAY
        AND #$07
        BNE _L11
        JSR PRINT_SPEED

        ; Converts speed from the range of [0,320] to [0,32]
        ; Basically divides by 10
        ; And uses this new value to position the Hero Car Y position
        ; And to calculate the horizontal movement delay
_L11    LDA ZP_SPEED_LO
        LSR A
        LSR A
        LSR A
        LSR A                           ;A = SPEED_LO / 16
                                        ; Basically take the MSB 4 bits (BCD)
        LDX ZP_SPEED_HI                 ;X = SPEED_HI (values goes from 0 to 3)
        CLC
        ADC CAR_SPEED_CONVERTION_TBL,X  ;A += TABLE[X]

        ; Update Hero Y Position based on SPEED / 10
        STA ZP_CAR_Y_OFFSET

        ; Update Hero Horizontal Delay based on TABLE[SPEED/10]
        TAY
        LDA CAR_MOVEMENT_DELAY_LO_TBL,Y
        STA ZP_CAR_MOVEMENT_DELAY_LO
        LDA CAR_MOVEMENT_DELAY_HI_TBL,Y
        STA ZP_CAR_MOVEMENT_DELAY_HI

        LDA ZP_SOUND_ENABLED
        BEQ _L12
        LDA #195
        SEC
        SBC ZP_CAR_Y_OFFSET
        STA $D00F                       ;Sprite 7 Y Pos

_L12    LDA ZP_ROAD_STATE
        CMP #$07
        BNE _L14

        ; Road state 07: Initial state
        LDY $D00F                       ;Sprite 7 Y Pos
        INY
        STY $D00D                       ;Sprite 6 Y Pos
        INY
        STY $D00B                       ;Sprite 5 Y Pos
        LDA $D00E                       ;Sprite 7 X Pos
        STA $D00C                       ;Sprite 6 X Pos
        STA $D00A                       ;Sprite 5 X Pos
        LDY ZP_FLAME_ANIM_DELAY
        INY
        CPY #10
        BCC _L13

        LDY #$00

        ; Switch between Flames 00 and Flames 01 sprite pointers
        LDA ZP_FLAME_FRAME_IDX
        EOR #$01
        AND #$01
        STA ZP_FLAME_FRAME_IDX

        CLC
        ADC #$F8                        ;Flames sprite frame
        STA SPR_FRAME_PTR_06

        AND #$01
        EOR #$01
        CLC
        ADC #$F8                        ;Flames sprite frame
        STA SPR_FRAME_PTR_05

_L13    STY ZP_FLAME_ANIM_DELAY

_L14    LDA ZP_ROAD_STATE
        CMP #$04                        ;Green with Split Road Warning?
        BNE _L18                        ; No, then skip

        ; Road State 04: Show Split Screen sprite
        LDA ZP_LEVEL_TICK
        CMP #160
        BCC _L18                        ;Branch if < 160
        CMP #240
        BCS _L16                        ;Branch if > 240
        CMP #160
        BNE _L15                        ;Branch if > 160 & < 240
                                        ;Else (= 160)

        ; Sets up the Split Screen Sign at 160
        ; Between 160 and 240 it keeps toogling it
        ; And at 240 it turns it off.

        ; Show Split Screen sprite
        LDA #$40                        ;#%01000000
        STA $D017                       ;Sprites Expand 2x Vertical (Y)
        STA $D01D                       ;Sprites Expand 2x Horizontal (X)
        LDA $D01C                       ;Sprites Multi-Color Mode Select
        ORA #$40                        ;#%01000000
        STA $D01C                       ;Sprites Multi-Color Mode Select
        LDA #$03                        ;Color Cyan
        STA $D02D                       ;Sprite 6 Color
        LDA #$FB                        ;Split road ahead sprite frame
        STA SPR_FRAME_PTR_06
        LDA #58
        STA $D00D                       ;Sprite 6 Y Pos
        LDA #129
        STA $D00C                       ;Sprite 6 X Pos

        LDA #$00
        STA ZP_SPLIT_ROAD_SPRITE_DELAY
        STA ZP_SPLIT_ROAD_SPRITE_TOGGLE

_L15    LDY ZP_SPLIT_ROAD_SPRITE_DELAY
        INY
        CPY #$08
        BCC _L17

        LDY #$00
        LDA ZP_SPLIT_ROAD_SPRITE_TOGGLE
        EOR #$01
        STA ZP_SPLIT_ROAD_SPRITE_TOGGLE
        BEQ _L16

        ; Enable "Split road" sprite
        LDA $D015                       ;Sprite display Enable
        ORA #$40                        ;#%01000000
        STA $D015                       ;Sprite display Enable
        LDA #$01
        STA ZP_PLAY_SPLIT_ROAD_SOUND
        BNE _L17

        ; Disable "Split road" sprite
_L16    LDA $D015                       ;Sprite display Enable
        AND #$BF                        ;#%10111111
        STA $D015                       ;Sprite display Enable
        LDA #$00
        STA ZP_PLAY_SPLIT_ROAD_SOUND

_L17    STY ZP_SPLIT_ROAD_SPRITE_DELAY

        ; Remaining of Road States
_L18    LDA ZP_SOUND_ENABLED
        BEQ _L20

        LDA ZP_TIME
        BEQ _L19

        ; Compare if number of ticks >= Ticks per second
        LDY ZP_TICK_COUNTER
        INY
        CPY ZP_TICKS_PER_SECOND
        BCC _L20

        ; Time = Time -1
        LDY #$00
        SED
        LDA ZP_TIME
        SEC
        SBC #$01
        STA ZP_TIME
        CLD
        JMP _L20

        ; Enable Game Over animation
_L19    LDA #$01
        STA ZP_IS_GAME_OVER

_L20    STY ZP_TICK_COUNTER
        SED
        LDA ZP_SPEED_LO
        SEC
        SBC ZP_CONSTANT_368_LO          ;Unused
        LDA ZP_SPEED_HI
        SBC ZP_CONSTANT_368_HI
        BCS _L21

        LDA #$01                        ;Moving up
        STA ZP_ENEMY_CAR_VERTICAL_DIR

        ; Resistance = 368 - speed
        LDA ZP_CONSTANT_368_LO
        SEC
        SBC ZP_SPEED_LO
        STA ZP_CAR_RESISTANCE_LO

        LDA ZP_CONSTANT_368_HI
        SBC ZP_SPEED_HI
        STA ZP_CAR_RESISTANCE_HI

        JSR CALCULATE_SOMETHING_WITH_SPEED
        JMP _L22

_L21    LDA #$00                        ;Moving down
        STA ZP_ENEMY_CAR_VERTICAL_DIR

        ; Resistance = Speed - 368
        LDA ZP_SPEED_LO
        SEC
        SBC ZP_CONSTANT_368_LO
        STA ZP_CAR_RESISTANCE_LO

        LDA ZP_SPEED_HI
        SBC ZP_CONSTANT_368_HI
        STA ZP_CAR_RESISTANCE_HI

        JSR CALCULATE_SOMETHING_WITH_SPEED

_L22    LDX #$03                        ;Compare with sprites 0-3
_L23    TXA
        ASL A                           ;A = X * 2
        STA ZP_TMP_49                   ;Store value in tmp variable
        TAY
        LDA $D001,Y                     ;Sprite 0 Y Pos
        CMP #29
        BCC _L26                        ;EnemyCar.Y < 29
        CMP #50
        BCC _L25                        ;EnemyCar.Y < 50

        CPX a5A
        BNE _L24
        LDA #$04
        STA a5A
_L24    JMP _L30


        ; 29 <= EnemyCar.Y < 50
_L25    STX a5A                         ;X has Sprite Index
        JMP _L30

        ; EnemyCar.Y < 29
_L26    LDA #$00
        STA ZP_ENEMY_CAR_PASSED_TBL,X
        CPX a5A
        BNE _L28

        LDA ZP_ENABLE_ENEMY_CAR0,X
        BNE _L30

        LDA #$04
        STA a5A
_L27    JMP _L32

_L28    LDA a5A
        CMP #$04
        BNE _L27

        LDA ZP_ENABLE_ENEMY_CAR0,X
        BEQ _L27

        ; Create new enemy car?
        ; Chances are 1 in 32
        JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$1F
        BNE _L27

        ;
        ; New Enemy Car
        ;

        STX a5A
        JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$07
        TAY

        ; Set the color
        LDA ENEMY_CAR_COLOR_TBL,Y
        STA $D027,X                     ;Sprite 0 Color

        LDA ZP_ROAD_STATE_ROW_TBL
        CMP #$06                        ;Split Screen coming?
        BEQ _L29                        ; Yes

        LDA ZP_ROAD_STATE_ROW_TBL+24
        CMP #$06                        ;Still in Split Screen?
        BEQ _L29                        ; Yes

        ; Get a random number between 63 and 110
        JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$3F
        CLC
        ADC #110

        ; Set sprite X position
        LDY ZP_TMP_49                   ;Use the random number as X position
        STA $D000,Y                     ;Sprite 0 X Pos

        ; Does the sprite move horizontally, or stared fixed?
        JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$01
        STA ZP_ENEMY_CAR_X_IS_FIXED_TBL,X

        ; Set sprite direction (left or right) ?
        JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$02
        TAY
        DEY
        STY ZP_ENEMY_CAR_DELTA_X_TBL,X
        JMP _L30

        ; In Split screen, used hardcoded position x
        ; to prevent the enemy car to start in an invalid
        ; position
_L29    JSR UPDATE_RANDOM_NUMBER
        LDA ZP_RANDOM_NUMBER
        AND #$03
        TAY
        LDA ENEMY_CAR_INITIAL_X_TBL,Y
        LDY ZP_TMP_49
        STA $D000,Y                     ;Sprite 0 X Pos

        ; Sprite must stay fixed. Don't move
        LDA #$01
        STA ZP_ENEMY_CAR_X_IS_FIXED_TBL,X

_L30    LDY ZP_TMP_49
        LDA ZP_ENEMY_CAR_VERTICAL_DIR
        BNE _L31

        ; Move enemy car from top to bottom (moving down)
        LDA f34,X
        CLC
        ADC ZP_CAR_RESISTANCE_LO
        STA f34,X

        LDA $D001,Y                     ;Sprite 0 Y Pos
        ADC ZP_CAR_RESISTANCE_HI
        STA $D001,Y                     ;Sprite 0 Y Pos
        JMP _L33

        ; Move enemy car from bottom to top (moving up)
_L31    LDA f34,X
        SEC
        SBC ZP_CAR_RESISTANCE_LO
        STA f34,X

        LDA $D001,Y                     ;Sprite 0 Y Pos
        SBC ZP_CAR_RESISTANCE_HI
        STA $D001,Y                     ;Sprite 0 Y Pos
        JMP _L33

_L32    LDY ZP_TMP_49
        LDA #25
        STA $D001,Y                     ;Sprite 0 Y Pos
_L33    LDA ZP_ROAD_STATE
        CMP #$04
        BNE _L34

        LDA ZP_LEVEL_TICK
        CMP #200
        BCC _L34

        LDA $D000,Y                     ;Sprite 0 X Pos
        CMP #107
        BCC _L36
        CMP #179
        BCS _L36
        LDA $D000,Y                     ;Sprite 0 X Pos
        CLC
        ADC ZP_ENEMY_CAR_DELTA_X_TBL,X
        STA $D000,Y                     ;Sprite 0 X Pos
        JMP _L36

_L34    LDA ZP_ENEMY_CAR_X_IS_FIXED_TBL,X
        BNE _L36                        ;Enemy car must not move horizontally

        LDA ZP_ROAD_STATE
        CMP #$06                        ;Split screen?
        BEQ _L36                        ; yes, don't move the sprite horizontally

        LDA ZP_ROAD_STATE_ROW_TBL+24
        CMP #$06                        ;Split scren in current row?
        BEQ _L36                        ; yes, ditto above

        ; Move the enemy car horizontally
        LDA $D000,Y                     ;Sprite 0 X Pos
        CLC
        ADC ZP_ENEMY_CAR_DELTA_X_TBL,X
        STA $D000,Y                     ;Sprite 0 X Pos

        CMP #103
        BCS _L35
        LDA #$01
        STA ZP_ENEMY_CAR_DELTA_X_TBL,X
        BNE _L36
_L35    CMP #183
        BCC _L36
        LDA #$FF
        STA ZP_ENEMY_CAR_DELTA_X_TBL,X

_L36    LDY ZP_TMP_49
        LDA $D001,Y                     ;Sprite 0 Y Pos
        LSR A
        LSR A
        LSR A
        SEC
        SBC #$05
        TAY
        LDA ZP_ROAD_STATE_ROW_TBL,Y
        CMP #$02                        ;Night for the current row for the sprite?
        BNE _L37                        ; No

        LDA #$FA                        ; Yes, nigth, so update car frame
        STA SPR_FRAME_PTR_00,X          ; with the "Night car" sprite frame
        BNE _L38

_L37    LDA #$F6                        ;Enemy Car 00
        STA SPR_FRAME_PTR_00,X
_L38    LDY ZP_TMP_49
        LDA $D001,Y                     ;Sprite 0 Y Pos
        CMP #50
        BCC _L39
        CMP #60
        BCS _L39

        LDA #$01
        STA ZP_ENEMY_CAR_PASSED_TBL,X
_L39    LDA $D001,Y                     ;Sprite 0 Y Pos
        CMP $D00F                       ;Sprite 7 Y Pos
        BCC _L40

        ; The enemy car can only be passed once.
        ; Once we pass it, tag it as passed.
        LDA ZP_ENEMY_CAR_PASSED_TBL,X
        BEQ _L40
        LDA #$00
        STA ZP_ENEMY_CAR_PASSED_TBL,X

        INC ZP_PASSED_CARS_TOTAL
        LDA ZP_PASSED_CARS_TOTAL
        CMP #10                         ;Passed cars >=  10
        BCC _L40
        LDY #$00                        ;Passed cars = 0
        STY ZP_PASSED_CARS_TOTAL
        INY
        STY ZP_ADD_1000_PTS             ;Trigger Bonus Points (???)

_L40    DEX
        BMI _L41
        JMP _L23

_L41    LDY ZP_ENEMY_CAR_ANIM_DELAY
        INY
        CPY #$04
        BCC _L44

        LDY #$00
        LDA ZP_ENEMY_CAR_FRAME_IDX
        EOR #$01
        STA ZP_ENEMY_CAR_FRAME_IDX

        CLC
        ADC #$F6                        ;Enemy Car 00 frame
        LDY #$03
_L42    LDX SPR_FRAME_PTR_00,Y
        CPX #$FA                        ;Enemy night car frame
        BEQ _L43
        STA SPR_FRAME_PTR_00,Y
_L43    DEY
        BPL _L42

_L44    STY ZP_ENEMY_CAR_ANIM_DELAY

        LDA ZP_PLAY_CRASH_SOUND
        BEQ _L46
        INC ZP_DISPLAY_PIT_DELAY
        LDA ZP_DISPLAY_PIT_DELAY
        AND #$04
        BNE _L45

        ; Disable Pit sprite
        LDA $D015                       ;Sprite display Enable
        AND #$EF                        ;#%11101111
        STA $D015                       ;Sprite display Enable
        JMP _L46

        ; Setup Pit sprite
_L45    LDA $D015                       ;Sprite display Enable
        ORA #$10                        ;#%00010000
        STA $D015                       ;Sprite display Enable
        LDA $D017                       ;Sprites Expand 2x Vertical (Y)
        ORA #$10                        ;#%00010000
        STA $D017                       ;Sprites Expand 2x Vertical (Y)
        LDA $D01C                       ;Sprites Multi-Color Mode Select
        ORA #$10                        ;#%00010000
        STA $D01C                       ;Sprites Multi-Color Mode Select
        LDA $D01D                       ;Sprites Expand 2x Horizontal (X)
        ORA #$10                        ;#%00010000
        STA $D01D                       ;Sprites Expand 2x Horizontal (X)
        LDA #$02                        ;Color Red
        STA $D02B                       ;Sprite 4 Color
        LDA #$F3                        ;"PIT" frame  pointer
        STA SPR_FRAME_PTR_04
        LDA #129
        STA $D008                       ;Sprite 4 X Pos
        LDA #58
        STA $D009
_L46    JMP jF2FB

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Something related to speed
CALCULATE_SOMETHING_WITH_SPEED
        CLD
        LDA #$00
        STA ZP_MOTOR_SOUND_FREQ_LO
        STA ZP_MOTOR_SOUND_FREQ_HI

        ; Before calling this function, ZP_CAR_RESISTANCE == ZP_SPEED +/- 1
        LDY ZP_CAR_RESISTANCE_HI
        BEQ _L01

_L00    LDA ZP_MOTOR_SOUND_FREQ_LO      ;ZP_MOTOR_SOUND_FREQ_LO += 100
        CLC
        ADC #100
        STA ZP_MOTOR_SOUND_FREQ_LO

        LDA ZP_MOTOR_SOUND_FREQ_HI
        ADC #$00
        STA ZP_MOTOR_SOUND_FREQ_HI

        DEY
        BNE _L00

_L01    LDA ZP_CAR_RESISTANCE_LO        ;Test 4-bit MSB
        LSR A
        LSR A
        LSR A
        LSR A
        TAY
        BEQ _L03

_L02    LDA ZP_MOTOR_SOUND_FREQ_LO      ;ZP_MOTOR_SOUND_FREQ_LO += 10 (times MSB ZP_CAR_RESISTANCE_LO)
        CLC
        ADC #10
        STA ZP_MOTOR_SOUND_FREQ_LO
        LDA ZP_MOTOR_SOUND_FREQ_HI
        ADC #$00
        STA ZP_MOTOR_SOUND_FREQ_HI
        DEY
        BNE _L02

_L03    LDA ZP_CAR_RESISTANCE_LO        ;Test 4-bit LSB
        AND #$0F
        TAY
        BEQ _L05

_L04    LDA ZP_MOTOR_SOUND_FREQ_LO      ;ZP_MOTOR_SOUND_FREQ_LO += 1 (times LSB ZP_CAR_RESISTANCE_LO)
        CLC
        ADC #$01
        STA ZP_MOTOR_SOUND_FREQ_LO
        LDA ZP_MOTOR_SOUND_FREQ_HI
        ADC #$00
        STA ZP_MOTOR_SOUND_FREQ_HI
        DEY
        BNE _L04


_L05    LDA ZP_MOTOR_SOUND_FREQ_HI      ;ZP_CAR_RESISTANCE_LO = ZP_MOTOR_SOUND_FREQ_HI
        STA ZP_CAR_RESISTANCE_LO
        LDA ZP_MOTOR_SOUND_FREQ_LO      ;ZP_CAR_RESISTANCE_HI = ZP_MOTOR_SOUND_FREQ_LO
        STA ZP_CAR_RESISTANCE_HI

        ;
        ; ZP_CAR_RESISTANCE ~= ZP_MOTOR_SOUND_FREQ / 20
        ;

        ; First divide by 32
        LDY #$05
_L06    LSR ZP_CAR_RESISTANCE_HI
        ROR ZP_CAR_RESISTANCE_LO
        DEY                             ;resistance /= 32
        BPL _L06


        ; Then add half of it to itself
        LDA ZP_CAR_RESISTANCE_HI        ;Divide by 2
        LSR A
        STA ZP_TMP_5C
        LDA ZP_CAR_RESISTANCE_LO
        ROR A
        STA ZP_TMP_5B

        LDA ZP_CAR_RESISTANCE_LO        ;Add it to self
        CLC
        ADC ZP_TMP_5B
        STA ZP_CAR_RESISTANCE_LO
        LDA ZP_CAR_RESISTANCE_HI
        ADC ZP_TMP_5C
        STA ZP_CAR_RESISTANCE_HI

        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
        ; Colors of the enemy car
ENEMY_CAR_COLOR_TBL
        .BYTE $02,$03,$05,$07,$08,$09,$0A,$0D
CAR_MOVEMENT_DELAY_LO_TBL
        .BYTE $00,$00,$00,$00,$00,$00,$80,$00
        .BYTE $80,$00,$80,$00,$80,$30,$00,$A0
        .BYTE $60,$20,$00,$D0,$98,$70,$35,$10
        .BYTE $00,$C0,$40,$18,$08,$04,$02,$00
CAR_MOVEMENT_DELAY_HI_TBL
        .BYTE $10,$0C,$0A,$09,$08,$07,$06,$06
        .BYTE $05,$05,$04,$04,$03,$03,$03,$02
        .BYTE $02,$02,$02,$01,$01,$01,$01,$01
        .BYTE $01,$00,$00,$00,$00,$00,$00,$00
CAR_SPEED_CONVERTION_TBL
        .BYTE $00,$0A,$14,$1E

        .BYTE $FE,$FD,$FB,$F7           ;Unk (Unused?)
        .BYTE $01,$02,$04,$08           ;Unk (Unused?)

        ; Valid position when in Split Screen
ENEMY_CAR_INITIAL_X_TBL
        .BYTE 81,107,179,205
ACCELERATION_TBL_LO
        .BYTE $00,$00,$40,$08
ACCELERATION_TBL_HI
        .BYTE $03,$01,$00,$00

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Check for passed cars (?)
jF2FB
        LDY #$03                        ;Y = 4 (compare with sprites 0-3)
_L00    TYA
        ASL A                           ;Y *= 2
        TAX                             ;X = Y

        ; Convention used for comments:
        ; H = hero car (our car)
        ; E = enemy car (the ones to pass/avoid)

        ; Collision between Hero and Enemies cars?
        LDA $D000,X                     ;Sprite 0 X Pos
        SEC
        SBC #$05                        ;if ((E.X-5) > H.X) then No collision
        CMP $D00E                       ;Sprite 7 X Pos
        BCS _L01

        LDA $D001,X                     ;Sprite 0 Y Pos
        SEC
        SBC #$04                        ;if ((E.Y-4) > H.Y) then No collision
        CMP $D00F                       ;Sprite 7 Y Pos
        BCS _L01

        LDA $D000,X                     ;Sprite 0 X Pos
        CLC
        ADC #15                         ;if ((E.X+15) < H.X) then No collision
        CMP $D00E                       ;Sprite 7 X Pos
        BCC _L01

        LDA $D001,X                     ;Sprite 0 Y Pos
        CLC
        ADC #18                         ;if ((E.Y+18) < H.X) then No collision
        CMP $D00F                       ;Sprite 7 Y Pos
        BCC _L01

        LDA #$01
        STA ZP_COLLISION_DETECTED

        ; Why does it do the collision detection again?
_L01    LDA $D00E                       ;Sprite 7 X Pos
        SEC
        SBC #$03                        ;if ((H.x-3) > E.X) then No collsion
        CMP $D000,X                     ;Sprite 0 X Pos
        BCS _L02

        LDA $D00F                       ;Sprite 7 Y Pos
        SEC
        SBC #$02                        ;if ((H.y-2) > E.Y) then No collision
        CMP $D001,X                     ;Sprite 0 Y Pos
        BCS _L02

        LDA $D00E                       ;Sprite 7 X Pos
        CLC
        ADC #17                         ;if ((H.x+17) < E.Y) then No collision
        CMP $D000,X                     ;Sprite 0 X Pos
        BCC _L02

        LDA $D00F                       ;Sprite 7 Y Pos
        CLC
        ADC #20                         ;if ((H.y+20) < E.Y) then No collision
        CMP $D001,X                     ;Sprite 0 Y Pos
        BCC _L02

        LDA #$01
        STA ZP_COLLISION_DETECTED

_L02    DEY                             ;Compare it with sprites 0-3
        BPL _L00

        LDA ZP_GAME_OVER_STATE
        BEQ _L03
        JMP _L13

_L03    LDY #$08
_L04    LDA PASSED_CARS_POS_LO,Y
        STA ZP_SCREEN_PTR_LO
        LDA PASSED_CARS_POS_HI,Y
        STA ZP_SCREEN_PTR_HI
        STY ZP_TMP_49

        LDX #$03
_L05    CPY ZP_PASSED_CARS_TOTAL
        BCC _L06
        LDA #$20                        ;Space
        BNE _L07
_L06    LDA PASSED_CARS_CHAR_TBL,X
_L07    LDY TWO_BY_TWO_OFFSET_TBL,X
        STA (ZP_SCREEN_PTR_LO),Y
        LDY ZP_TMP_49
        DEX
        BPL _L05
        DEY
        BPL _L04

        LDA ZP_ADD_1000_PTS
        BEQ _L10

        ; Score += 100
        ; The player sees +1000, but the rightmost zero
        ; doesn't get updated.
        LDA #40                         ;How long the message will be displayed
        STA ZP_DISPLAY_1000_PTS_DURATION
        LDA #$00
        STA ZP_ADD_1000_PTS

        SED
        LDA ZP_SCORE_02
        CLC
        ADC #$01                        ;Score_02 += 01
        STA ZP_SCORE_02
        LDA ZP_SCORE_03
        ADC #$00                        ;Add possible carry
        STA ZP_SCORE_03

        CLD
        LDA ZP_SCORE_02
        AND #$1F                        ;20.000 ?
        BNE _L08                        ; No, so no extended time

        ; Reached 20.000 points, so extend time
        INC ZP_LIVES
        LDA #$5F
        STA ZP_TIMES_TO_DISPLAY_EXTENDED_TIME

        ; Print "BONUS 1000 PTS" message
_L08    LDY #$07
_L09    LDA BONUS_MSG,Y
        STA SCREEN_RAM+40*23+32,Y
        LDA THOUSAND_PTS_MSG,Y
        STA SCREEN_RAM+40*24+32,Y
        DEY
        BPL _L09

_L10    LDA ZP_DISPLAY_1000_PTS_DURATION
        BEQ _L13
        DEC ZP_DISPLAY_1000_PTS_DURATION
        LDA ZP_DISPLAY_1000_PTS_DURATION
        AND #$04
        BEQ _L11
        LDA #$01
        STA ZP_PLAY_PASS_CAR_SOUND
        BNE _L13

_L11    LDA #$00
        STA ZP_PLAY_PASS_CAR_SOUND
        LDA ZP_DISPLAY_1000_PTS_DURATION
        BNE _L13

        ; Erase "BONUS 1000 PTS" message
        LDY #$07
        LDA #$20
_L12    STA SCREEN_RAM+40*23+32,Y
        STA SCREEN_RAM+40*24+32,Y
        DEY
        BPL _L12

_L13    LDA ZP_TIMES_TO_DISPLAY_EXTENDED_TIME
        BEQ _L17
        DEC ZP_TIMES_TO_DISPLAY_EXTENDED_TIME
        LDA ZP_TIMES_TO_DISPLAY_EXTENDED_TIME
        AND #$10
        BEQ _L15

        LDA #$01
        STA ZP_PLAY_EXTENDED_TIME_SOUND

        ; Print "EXTENDED TIME" message
        LDY #$07
_L14    LDA EXTENDED_MSG,Y
        STA SCREEN_RAM+40*14+32,Y
        LDA TIME2_MSG,Y
        STA SCREEN_RAM+40*15+32,Y
        DEY
        BPL _L14
        BMI _L17

        ; Erase "EXTENDED TIME" message
_L15    LDA #$00
        STA ZP_PLAY_EXTENDED_TIME_SOUND
        LDY #$07
        LDA #$20
_L16    STA SCREEN_RAM+40*14+32,Y
        STA SCREEN_RAM+40*15+32,Y
        DEY
        BPL _L16

_L17    JMP IRQ_HANDLER_MAIN

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
        ; Screen location of where to print the passed cars
PASSED_CARS_POS_LO
        .BYTE <(SCREEN_RAM+40*16+33)
        .BYTE <(SCREEN_RAM+40*16+35)
        .BYTE <(SCREEN_RAM+40*16+37)
        .BYTE <(SCREEN_RAM+40*18+33)
        .BYTE <(SCREEN_RAM+40*18+35)
        .BYTE <(SCREEN_RAM+40*18+37)
        .BYTE <(SCREEN_RAM+40*20+33)
        .BYTE <(SCREEN_RAM+40*20+35)
        .BYTE <(SCREEN_RAM+40*20+37)
PASSED_CARS_POS_HI
        .BYTE >(SCREEN_RAM+40*16+33)
        .BYTE >(SCREEN_RAM+40*16+35)
        .BYTE >(SCREEN_RAM+40*16+37)
        .BYTE >(SCREEN_RAM+40*18+33)
        .BYTE >(SCREEN_RAM+40*18+35)
        .BYTE >(SCREEN_RAM+40*18+37)
        .BYTE >(SCREEN_RAM+40*20+33)
        .BYTE >(SCREEN_RAM+40*20+35)
        .BYTE >(SCREEN_RAM+40*20+37)

        ; Offset to print one passed car, using
        ; PASSED_CARS_POS as reference
TWO_BY_TWO_OFFSET_TBL
        .BYTE $00,$01,$28,$29

        ; One Passed car is represented with 4 chars:
        ;   $75,$76
        ;   $77,$78
        ; Passed chars char idx
PASSED_CARS_CHAR_TBL
        .BYTE $75,$76,$77,$78

        .ENC "screen"
BONUS_MSG
.IF USE_FIX_MISSPELL == 0
        .TEXT " BOUNS  "                ;Notice the misspell.
.ELSE
        .TEXT " BONUS  "
.ENDIF
THOUSAND_PTS_MSG
        .BYTE $22,$21,$21,$21           ;1000
        .TEXT " PTS"
EXTENDED_MSG
        .TEXT "EXTENDED"
TIME2_MSG
        .TEXT "  TIME  "

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Called when time is 0.
; Game over animnation gets triggered from here
GAME_OVER
        STY ZP_TMP_REG_Y                ;Temporary save X and Y
        STX ZP_TMP_REG_X
        LDA ZP_LIVES
        BEQ _L01

        DEC ZP_LIVES                    ;Life--

        ; Make time goes faster for each life used
        LDY ZP_LIVES_USED
        CPY #$05
        BCC _L00
        LDY #$04
_L00    LDA TICKS_PER_SECOND_TBL,Y
        STA ZP_TICKS_PER_SECOND

        INY
        STY ZP_LIVES_USED               ;LIVES_USED++

        LDA #$60                        ;Initial time: 60 seconds (BCD)
        STA ZP_TIME

        LDA #$00
        STA ZP_IS_GAME_OVER             ;Not game over yet
        STA ZP_TICK_COUNTER             ;Reset tick counter

        LDY ZP_TMP_REG_X                ;Swap X & Y (or BUG?)
        LDX ZP_TMP_REG_Y                ; It seems they are not used. Legacy
                                        ; code most probably
        RTS

        ; Do Game Over
_L01
.if USE_JOYSTICK == 1
        LDA #%00111110                  ;Disable rumble in both joysticks
        STA $DC00
.endif
        INC ZP_GAME_OVER_STATE
        LDA #$07
        STA ZP_ROAD_STATE

        ; Turn off headlight/pits sprites, in case they are visible
        LDA $D015                       ;Sprite display Enable
        AND #$8F                        ;#%10001111
        STA $D015                       ;Sprite display Enable

        LDA #$00
        STA ZP_COLLISION_DETECTED
        STA ZP_PLAY_CRASH_SOUND
        STA ZP_SOUND_EFFECT_TO_PLAY
        STA ZP_PLAY_SPLIT_ROAD_SOUND
        STA ZP_PLAY_PASS_CAR_SOUND
        STA ZP_ENABLE_ENEMY_CAR0
        STA ZP_ENABLE_ENEMY_CAR0+1
        STA ZP_ENABLE_ENEMY_CAR0+2
        STA ZP_ENABLE_ENEMY_CAR0+3
        LDA #$F0                        ;#%11110000
        STA $D417                       ;Filter Resonance Control / Voice Input Control

        LDY #75                         ;75 rows to scroll down
_L02    STY ZP_LEVEL_TICK               ;Overload ZP_LEVEL_TICK, since we are in Game Over
        JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        JSR ANIMATE_HERO_CAR
        LDY ZP_LEVEL_TICK
        DEY
        BNE _L02

        LDY #31                         ;32 columns
_L03    LDA RACE_OVER_BOTTOM_ROW_BANNER,Y
        STA SCREEN_RAM,Y
        LDA #$0A                        ;Color Light Red
        STA COLOR_RAM,Y
        DEY
        BPL _L03

        JSR SCROLL_DOWN
        JSR ANIMATE_HERO_CAR

        LDY #31                         ;32 columns
_L04    LDA RACE_OVER_TOP_ROW_BANNER,Y
        STA SCREEN_RAM,Y
        DEY
        BPL _L04

        JSR SCROLL_DOWN
        JSR ANIMATE_HERO_CAR
        LDY #10
_L05    STY ZP_LEVEL_TICK               ;Overload ZP_LEVEL_TICK since we are in Game Over
        JSR DRAW_ROAD_TOP_ROW
        JSR SCROLL_DOWN
        JSR ANIMATE_HERO_CAR
        LDY ZP_LEVEL_TICK
        DEY
        BPL _L05

        SEI
        LDA #<IRQ_HANDLER_MAIN
        STA ZP_IRQ_LO
        LDA #>IRQ_HANDLER_MAIN
        STA ZP_IRQ_HI
        CLI

        INC ZP_GAME_OVER_STATE
        LDA #163
_L06    CMP #$08
        BCC _L07
        SEC
        SBC #$04
        STA $D00F                       ;Sprite 7 Y Pos
        LDY #$01
        JSR DELAY_01
        LDA $D00F                       ;Sprite 7 Y Pos
        BNE _L06

        ; Erase "Extended time", in case it was on
_L07    LDY #$07
        LDA #$20                        ;Space
_L08    STA SCREEN_RAM+40*23+32,Y
        STA SCREEN_RAM+40*24+32,Y
        DEY
        BPL _L08

        LDY #$05
        JSR DELAY_00

        ; Scroll down 26 rows, and...
        LDX #26
_L09    STX ZP_LEVEL_IDX                ;Overload ZP_LEVEL_IDX
        JSR DRAW_ROAD_TOP_ROW           ; since we are in Game Over
        JSR SCROLL_DOWN
        LDA ZP_SHOULDER_RIGHT_IDX
        CMP #100
        BEQ _L11
        BCC _L10
        DEC ZP_SHOULDER_RIGHT_IDX
        JMP _L11

_L10    INC ZP_SHOULDER_RIGHT_IDX
_L11    LDY #$01
        JSR DELAY_01
        LDX ZP_LEVEL_IDX                ;Overloaded ZP_LEVEL_IDX
        DEX                             ; See above
        BPL _L09

        ; Disable and Reset sprites X pos
NMI_HANDLER
        LDA #$00
        STA $D015                       ;Sprite display Enable
        LDX #$0F
_L00    STA $D000,X                     ;Sprite 0 X Pos
        DEX
        BPL _L00
        JMP SET_IRQ_TO_WAIT_BUTTON

        ; Time gets faster
TICKS_PER_SECOND_TBL
        .BYTE 64,58,52,47,34
RACE_OVER_TOP_ROW_BANNER
        .BYTE $79,$79,$79,$79,$79,$79,$85,$8E
        .BYTE $7A,$7E,$7A,$7B,$85,$86,$79,$79
        .BYTE $79,$79,$7A,$7E,$8A,$8B,$85,$86
        .BYTE $85,$8E,$79,$79,$79,$79,$79,$79
RACE_OVER_BOTTOM_ROW_BANNER
        .BYTE $79,$79,$79,$79,$79,$79,$8F,$90
        .BYTE $7F,$80,$7C,$7D,$87,$88,$79,$79
        .BYTE $79,$79,$7C,$89,$8C,$8D,$87,$88
        .BYTE $8F,$90,$79,$79,$79,$79,$79,$79

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
PLAY_SOUND_EFFECT
        LDA ZP_PLAY_CRASH_SOUND
        BEQ _L03

        CMP #$01
        BNE _L00

        ; ZP_PLAY_CRASH_SOUND == 1
        LDA #$00
        STA $D400                       ;Voice 1: Frequency Control - Low-Byte
        STA $D415                       ;Filter Cutoff Frequency: Low-Nybble
        LDA #$09
        STA $D401                       ;Voice 1: Frequency Control - High-Byte
        LDA #$1F                        ;#%00011111
        STA $D418                       ;Select Filter Mode and Volume
        LDA #$F1                        ;#%11110001
        STA $D417                       ;Filter Resonance Control / Voice Input Control
        LDA #$C8
        STA $D416                       ;Filter Cutoff Frequency: High-Byte
        STA ZP_SID_CUTOFF_FREQ_HI
        LDA #$81                        ;#%10000001
        STA $D404                       ;Voice 1: Control Register
        INC ZP_PLAY_CRASH_SOUND
        JMP _L08

_L00    CMP #$02
        BNE _L02

        ; ZP_PLAY_CRASH_SOUND == 2
        DEC ZP_SID_CUTOFF_FREQ_HI       ;Freq goes from $C8 to $96
        LDA ZP_SID_CUTOFF_FREQ_HI
        STA $D416                       ;Filter Cutoff Frequency: High-Byte
        CMP #$96
        BCS _L02
        INC ZP_PLAY_CRASH_SOUND

_L02    JMP _L08

_L03    LDA ZP_GAME_OVER_STATE
        CMP #$02
        BCC _L05
        CMP #$03
        BEQ _L04
        CMP #$04
        BEQ _L08

        ; ZP_GAME_OVER_STATE == 2 (or > 4)
        LDA #$40                        ;#%01000000
        STA $D404                       ;Voice 1: Control Register
        LDA #$00
        STA $D40B                       ;Voice 2: Control Register
        STA $D412                       ;Voice 3: Control Register
        STA ZP_SID_FREQ_LO
        STA $D400                       ;Voice 1: Frequency Control - Low-Byte
        LDA #$0D
        STA ZP_SID_FREQ_HI
        STA $D401                       ;Voice 1: Frequency Control - High-Byte
        INC ZP_GAME_OVER_STATE

        ; ZP_GAME_OVER_STATE == 3
_L04    LDA ZP_SID_FREQ_LO
        SEC
        SBC #$1E
        STA ZP_SID_FREQ_LO
        STA $D400                       ;Voice 1: Frequency Control - Low-Byte
        LDA ZP_SID_FREQ_HI
        SBC #$00
        STA ZP_SID_FREQ_HI
        STA $D401                       ;Voice 1: Frequency Control - High-Byte
        CMP #$0A
        BNE _L08
        INC ZP_GAME_OVER_STATE
        JMP _L08

        ; ZP_GAME_OVER_STATE == 0 or 1
_L05    LDA ZP_SPEED_LO
        BNE _L06
        LDA ZP_SPEED_HI
        BNE _L06
        LDA #$00
        STA $D404                       ;Voice 1: Control Register
        BEQ _L08

_L06    LDA ZP_SPEED_LO
        STA ZP_CAR_RESISTANCE_LO
        LDA ZP_SPEED_HI
        STA ZP_CAR_RESISTANCE_HI
        JSR CALCULATE_SOMETHING_WITH_SPEED

        ; Divide by 8
        LDY #$02
_L07    ASL ZP_MOTOR_SOUND_FREQ_LO
        ROL ZP_MOTOR_SOUND_FREQ_HI
        DEY
        BPL _L07

        LDA ZP_MOTOR_SOUND_FREQ_LO
        STA $D400                       ;Voice 1: Frequency Control - Low-Byte
        LDA ZP_MOTOR_SOUND_FREQ_HI
        CLC
        ADC #$03
        STA $D401                       ;Voice 1: Frequency Control - High-Byte
        LDA #$41                        ;#%01000001
        STA $D404                       ;Voice 1: Control Register

        ; ZP_GAME_OVER_STATE == 4
_L08    LDA ZP_PLAY_EXTENDED_TIME_SOUND
        BNE _PLAY_EXTENDED_TIME
        LDA ZP_PLAY_SPLIT_ROAD_SOUND
        BEQ _L09
        JMP _PLAY_SPLIT_ROAD

_L09    LDA ZP_PLAY_PASS_CAR_SOUND
        BNE _PLAY_PASS_CAR
        LDA ZP_SOUND_EFFECT_TO_PLAY
        BNE _PLAY_SOUND_EFFECT
        ; Sound Effect 00 (Do nothing)
        STA $D412                       ;Voice 3: Control Register
        BNE _PLAY_SOUND_EFFECT          ;Remove, never true (?)
        JMP _L18

_PLAY_SOUND_EFFECT
        CMP #$01
        BNE _L14

        ; Sound Effect 01 (Soft Collision with shoulder)
        LDY ZP_SOUND_EFFECT_01_DELAY
        INY
        CPY #$03
        BCC _L11
        LDY #$00
_L11    STY ZP_SOUND_EFFECT_01_DELAY
        CPY #$01
        BCS _L13

        LDA ZP_SPEED_LO
        BNE _L12
        LDA ZP_SPEED_HI
        BNE _L12
        JMP _L18

_L12    LDA #$04
        STA $D40F                       ;Voice 3: Frequency Control - High-Byte
        LDA #$81                        ;#%10000001
        STA $D412                       ;Voice 3: Control Register
        LDA #$F0                        ;#%11110000
        STA $D417                       ;Filter Resonance Control / Voice Input Control
        BNE _L18

_L13    LDA $00                         ;BUG? Should be LDA #$00 instead of LDA $00
        STA $D412                       ;Voice 3: Control Register
        BEQ _L18

_L14    CMP #$02
        BNE _L18

        ; Sound Effect 02 (Ice)
        LDA #$1E                        ;#%00011110
        STA $D40F                       ;Voice 3: Frequency Control - High-Byte
        LDA #$81                        ;#%10000001
        STA $D412                       ;Voice 3: Control Register
        LDA #$F4                        ;#%11110100
        STA $D417                       ;Filter Resonance Control / Voice Input Control
        BNE _L18

        ; These sound effects are almost identical.
        ; They only thing that changes i the Hi Frequency value

        ; Sound Effect: Extended Time
_PLAY_EXTENDED_TIME
        LDA #$50
        STA $D40F                       ;Voice 3: Frequency Control - High-Byte
        LDA #$21                        ;#%00100001
        STA $D412                       ;Voice 3: Control Register
        LDA #$F0                        ;#%11110000
        ORA ZP_SID_VOICE_FILTER_MASK
        STA $D417                       ;Filter Resonance Control / Voice Input Control
        BNE _L18

        ; Sound Effect: Pass Car
_PLAY_PASS_CAR
        LDA #$82
        STA $D40F                       ;Voice 3: Frequency Control - High-Byte
        LDA #$21                        ;#%00100001
        STA $D412                       ;Voice 3: Control Register
        LDA #$F0                        ;#%11110000
        ORA ZP_SID_VOICE_FILTER_MASK
        STA $D417                       ;Filter Resonance Control / Voice Input Control
        BNE _L18

        ; Sound Effect: "Split Road" ahead
_PLAY_SPLIT_ROAD
        LDA #$6E
        STA $D40F                       ;Voice 3: Frequency Control - High-Byte
        LDA #$21                        ;#%00100001
        STA $D412                       ;Voice 3: Control Register
        LDA #$F0
        ORA ZP_SID_VOICE_FILTER_MASK
        STA $D417                       ;Filter Resonance Control / Voice Input Control

_L18    LDA ZP_GAME_OVER_STATE
        CMP #$02
        BCC _L19
        JMP _L28

        ; ZP_GAME_OVER_STATE == 0 or 1
_L19    LDA ZP_CAR_Y_OFFSET
        CMP #16
        BCS _L20
        LDA ZP_CAR_Y_OFFSET
        SEC
        SBC #16
        STA a74
        LDA #$01
        STA a75
        BNE _L21
_L20    LDA #16
        SEC
        SBC ZP_CAR_Y_OFFSET
        STA a74
        LDA #$00
        STA a75
_L21    LDA #$FF
        STA a72

        LDX #$03
_L22    TXA
        ASL A
        TAY
        LDA $D001,Y                     ;Sprite 0 Y Pos
        CMP $D00F                       ;Sprite 7 Y Pos
        BCC _L23

        LDA $D001,Y                     ;Sprite 0 Y Pos
        SEC
        SBC $D00F                       ;Sprite 7 Y Pos
        CMP a72
        BCS _L24

        STA a72
        LDA #$00
        STA a73
        BEQ _L24

_L23    LDA $D00F                       ;Sprite 7 Y Pos
        SEC
        SBC $D001,Y                     ;Sprite 0 Y Pos
        CMP a72
        BCS _L24

        STA a72
        LDA #$01
        STA a73
_L24    DEX
        BPL _L22

        LDA a72
        CMP #$20
        BCC _L25
        LDA #$40                        ;#%01000000
        STA $D40B                       ;Voice 2: Control Register
        BNE _L28
_L25    LDA #$41                        ;#%01000001
        STA $D40B                       ;Voice 2: Control Register
        LDA a73
        EOR a75
        BEQ _L26
        LDA a72
        CLC
        ADC #$20                        ;#%00100000
        STA $D407
        JMP _L27

_L26    LDA #$20
        SEC
        SBC a72
        STA $D407                       ;Voice 2: Frequency Control - Low-Byte
_L27    LDA #$0A
        STA $D408                       ;Voice 2: Frequency Control - High-Byte
_L28    RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Garbage: Remove from .prg
.IF USE_PRG == 0
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$00
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$7F
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$FF,$00,$FF
.ENDIF

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Data:
.IF USE_PRG == 1
        * = $3800                       ;To avoid updating all frame pointers
                                        ; let's place it at $3800 in .prg
.ELSE
        * = $F800
.ENDIF
        .BINARY "charset-f800-f97f.bin"         ;Chars 00-47
        .BINARY "sprites-f980-f9ff.bin"         ;Frames 230-231
        .BINARY "charset-fa00-fcbf.bin"         ;Chars 64-151
        .BINARY "sprites-fcc0-ffbf.bin"         ;Frames 243-254

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Garbage: Remove from .prg
.IF USE_PRG == 0
        * = $FFC0
        .BYTE $00,$FF,$00
        .BYTE $00,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$7F,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00
        .BYTE $FF,$00,$FF
        .BYTE $00,$FF,$00,$FF
.ENDIF

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Setup NMI, IRQ, START vectors
; Remove from .prg since they are manually set
.IF USE_PRG == 0
        ; NMI ($FFFA-$FFFB)
        .ADDR NMI_HANDLER
        ; COLD RESET ($FFFC-$FFFD)
        .ADDR START
        ; IRQ ($FFFE-$FFFF)
        .ADDR IRQ_HANDLER
.ENDIF
