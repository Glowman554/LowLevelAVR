.device ATmega328P

.equ PORTB  = 0x05
.equ DDRB   = 0x04

.equ LED_B  = 5

.equ RAMEND =  0x8ff
.equ SPL    = 0x3d
.equ SPH    = 0x3e

.org 0x0000 ; Execution starts here
    rjmp main

main:
    ldi r16, low(RAMEND)
    out SPL, r16 ; setup stack ptr low
    ldi r16, high(RAMEND)
    out SPH, r16 ; setu stack ptr high
    
    rcall setup ; call setup

loop_intrnl:
    rcall loop ; call loop
    jmp loop_intrnl

setup:
    sbi DDRB, LED_B ; set PB5 output

    sbi PORTB, LED_B ; set PB5 high
    
    ret ; return 

loop:
    ret ; return
