.device ATmega328P

.equ PORTB  = 0x05
.equ DDRB   = 0x04

.equ LED_B  = 5

.equ RAMEND =  0x8ff
.equ SPL    = 0x3d
.equ SPH    = 0x3e

.equ UBRR0H = 0xc5
.equ UBRR0L = 0xc4

.equ UCSR0A = 0xc0
.equ UCSR0B = 0xc1
.equ UCSR0C = 0xc2

.equ UDR0   = 0xc6

.equ BAUD   = 9600
.equ F_CPU  = 16000000
.equ UBRR_V = (((F_CPU) + 8 * (BAUD)) / (16 * (BAUD)) - 1)

.org 0x0000 ; Execution starts here
    rjmp main

USART0_init:
    push r16
    push r30
    push r31
    
    ldi r16, low(UBRR_V)

    ldi r30, low(UBRR0L) ; set ZL
    ldi r31, high(UBRR0L) ; set ZH
    st Z, r16 ; set low part of baud rate reg

    ldi r16, high(UBRR_V)

    ldi r30, low(UBRR0H) ; set ZL
    ldi r31, high(UBRR0H) ; set ZH
    st Z, r16 ; set high part of baud rate reg


    ldi r16, 0b00011000

    ldi r30, low(UCSR0B) ; set ZL
    ldi r31, high(UCSR0B) ; set ZH
    st Z, r16 ; enable transmitter and receiver

    ldi r16, 0b00001110

    ldi r30, low(UCSR0C) ; set ZL
    ldi r31, high(UCSR0C) ; set ZH
    st Z, r16 ; set frame format: 8data, 2stop bit

    pop r31
    pop r30
    pop r16
    ret

; char to transmit is in r22
USART0_transmit:
    push r16
    push r30
    push r31
    
USART0_transmit_loop:
    ldi r30, low(UCSR0A) ; set ZL
    ldi r31, high(UCSR0A) ; set ZH
    ld r16, Z

    sbrs r16, 5 ; wait for empty transmit buffer
    rjmp USART0_transmit_loop

    ldi r30, low(UDR0) ; set ZL
    ldi r31, high(UDR0) ; set ZH
    st Z, r22 ; put data into buffer, sends the data

    pop r31
    pop r30
    pop r16

    ret

; char is in r22
USART0_receive:
    push r16
    push r30
    push r31

USART0_receive_loop:
    ldi r30, low(UCSR0A) ; set ZL
    ldi r31, high(UCSR0A) ; set ZH
    ld r16, Z

    sbrs r16, 7 ; wait for data to be received
    rjmp USART0_receive_loop

    ldi r30, low(UDR0) ; set ZL
    ldi r31, high(UDR0) ; set ZH
    ld r22, Z ; get and return received data from buffer

    pop r31
    pop r30
    pop r16

    ret

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

    call USART0_init

    ; print hi on serial terminal
    ldi r22, 'H'
    call USART0_transmit
    ldi r22, 'i'
    call USART0_transmit

    sbi PORTB, LED_B ; set PB5 to high

    ret ; return 

loop:
    ; simple echo example 
    call USART0_receive ; receive char. char is now in r22
    call USART0_transmit ; transmit char in r22
    ret ; return
