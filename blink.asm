.device ATmega328P

.equ PORTB = 0x05
.equ DDRB  = 0x04

.org 0x0000 ; Execution starts here
    jmp main

main:
        sbi DDRB, 5 ; Set pin B5 as output (Arduino pin 13)

loop:
        sbi PORTB, 5 ; Set pin B5 to high
        call delay_1000ms ; wait 1s
        cbi PORTB, 5 ; Set pin B5 to low
        call delay_1000ms ; wait 1s
        rjmp loop ; loop

delay_1000ms:
        ldi r18, 0xFF
        ldi r24, 0xD3
        ldi r25, 0x30
        ; 0xff + 0xd3 + 0x30 = 514

inner_loop:
        subi r18, 0x01 ; Substract 1
        sbci r24, 0x00 ; Substract c (1) if previous sub overflowed
        sbci r25, 0x00 ; Substract c (1) if previous sub overflowed
        brne inner_loop ; branch not equal (in this case if != 0)
        ret
