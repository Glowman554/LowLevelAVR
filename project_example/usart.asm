.equ UBRR_V = (((F_CPU) + 8 * (BAUD)) / (16 * (BAUD)) - 1)

USART0_init:
    push r16
    push r30
    push r31

    memsave [UBRR0H, UBRR0L, UBRR_V] ; set baudrate

    ldi r16, 0b00011000
    load [r31:r30, UCSR0B]
    st Z, r16 ; enable transmitter and receiver

    ldi r16, 0b00001110
    load [r31:r30, UCSR0C]
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
    load [r31:r30, UCSR0A]
    ld r16, Z

    sbrs r16, 5 ; wait for empty transmit buffer
    rjmp USART0_transmit_loop
    
    load [r31:r30, UDR0]
    st Z, r22 ; put data into buffer, sends the data

    pop r31
    pop r30
    pop r16

    ret

; str is in program memory and in r30:r31
USART0_transmit_str:
    push r22
    push r30
    push r31

USART0_transmit_str_loop:
    lpm r22, Z+
    cpi r22, 0
    breq USART0_transmit_str_ret
    
    call USART0_transmit
    rjmp USART0_transmit_str_loop

USART0_transmit_str_ret:
    pop r31
    pop r30
    pop r22
    ret

; char is in r22
USART0_receive:
    push r16
    push r30
    push r31

USART0_receive_loop:
    load [r31:r30, UCSR0A]
    ld r16, Z

    sbrs r16, 7 ; wait for data to be received
    rjmp USART0_receive_loop

    load [r31:r30, UDR0]
    ld r22, Z ; get and return received data from buffer

    pop r31
    pop r30
    pop r16

    ret
