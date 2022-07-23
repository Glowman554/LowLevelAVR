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
    sbic PIND, 5 ; "skip if bit cleared" skip next instruction if bit cleared (bit is cleared if pin is pulled to gnd)
    rjmp set_pin
    
    cbi PORTB, 5 ; clear bit 5 in PORTB (PB5)
    rjmp loop

set_pin:
    sbi PORTB, 5 ; set bit 5 n PORTB (PB5)
    rjmp loop
