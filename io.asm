.device ATmega328P

.equ PORTB = 0x05
.equ DDRB  = 0x04

.equ PORTD = 0x0b
.equ DDRD  = 0x0a
.equ PIND  = 0x09

.org 0x0000 ; Execution starts here
    rjmp main

main:
    ldi r16, 0xff
    out DDRB, r16 ; set PB0 - PB7 as output (data direction bit is 1)

    ldi r16, 0x00
    out DDRD, r16 ; set PD0 - PD7 as input (data direction bit is 0)

    ldi r16, 0xff
    out PORTD, r16 ; set PD0 - PD7 pullup (since pd* is set as input we set pullup using PORTD)

loop:
    in r16, PIND ; read PD0 - PD7 
    out PORTB, r16 ; write PD0 - PD7 to PB0 - PB7
    
    rjmp loop
