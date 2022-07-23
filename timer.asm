.device ATmega328P

.equ PORTB  = 0x05
.equ DDRB   = 0x04

.equ LED_B  = 5

.equ RAMEND =  0x8ff
.equ SPL    = 0x3d
.equ SPH    = 0x3e

.equ TCNT_O = 49910

.equ TCNT1L = 0x84
.equ TCNT1H = 0x85

.equ TCCR1A = 0x80
.equ TCCR1B = 0x81

.equ TIMSK1 = 0x6f

.equ SREG   = 0x3f

.org 0x0000 ; Execution starts here
    jmp main

.org 0x001A
    jmp timer1_ovf_vect

timer1_ovf_vect:
    push r16
    push r17
    push r18
    
    in r16, SREG
    
    in r17, PORTB
    ldi r18, 0b00100000
    eor r17, r18
    out PORTB, r17

    call set_tcnt

    out SREG, r16
    pop r18
    pop r17
    pop r16
    reti

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

    
   call set_tcnt


    ldi r16, 0b00000101

    ldi r30, low(TCCR1B)
    ldi r31, high(TCCR1B)

    st Z, r16


    ldi r16, 0

    ldi r30, low(TCCR1A)
    ldi r31, high(TCCR1A)

    st Z, r16


    ldi r16, 0b00000001

    ldi r30, low(TIMSK1)
    ldi r31, high(TIMSK1)

    st Z, r16

    sei

    ret ; return 

set_tcnt:
    push r16
    push r30
    push r31
    
    ldi r16, low(TCNT_O)

    ldi r30, low(TCNT1L)
    ldi r31, high(TCNT1L)

    st Z, r16


    ldi r16, high(TCNT_O)

    ldi r30, low(TCNT1H)
    ldi r31, high(TCNT1H)

    st Z, r16

    pop r31
    pop r30
    pop r16

    ret

loop:
    ret ; return
