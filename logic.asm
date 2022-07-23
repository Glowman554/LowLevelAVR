.device ATmega328P

.equ PORTB = 0x05
.equ DDRB  = 0x04

.org 0x0000 ; Execution starts here
    rjmp main

main:
    ldi r16, 0xff
    out DDRB, r16 ; set PB0 - PB7 as output (data direction bit is 1)

    ldi r16, 0b10101010
    ldi r17, 0b01010101

    ; and r16, r17
    ; andi r16, 0b01010101 ; and using constant (works with every logic instruction (instr + i))

    ; or r16, r17
    ; com r16 ; com == not
    eor r16, r17 ; eor == xor

    out PORTB, r16

loop:
    rjmp loop
