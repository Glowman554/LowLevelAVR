.device ATmega328P

.equ BAUD   = 9600
.equ F_CPU  = 16000000
.equ TCNT_O = 49910

.org 0x0000 ; Execution starts here
    jmp main
.org 0x0002
    reti ; jmp EXT_INT0 ; IRQ0 Handler
.org 0x0004
    reti ; jmp EXT_INT1 ; IRQ1 Handler
.org 0x0006
    reti ; jmp PCINT0 ; PCINT0 Handler
.org 0x0008
    reti ; jmp PCINT1 ; PCINT1 Handler
.org 0x000A
    reti ; jmp PCINT2 ; PCINT2 Handler
.org 0x000C
    reti ; jmp WDT ; Watchdog Timer Handler
.org 0x000E
    reti ; jmp TIM2_COMPA ; Timer2 Compare A Handler
.org 0x0010
    reti ; jmp TIM2_COMPB ; Timer2 Compare B Handler
.org 0x0012
    reti ; jmp TIM2_OVF ; Timer2 Overflow Handler
.org 0x0014
    reti ; jmp TIM1_CAPT ; Timer1 Capture Handler
.org 0x0016
    reti ; jmp TIM1_COMPA ; Timer1 Compare A Handler
.org 0x0018
    reti ; jmp TIM1_COMPB ; Timer1 Compare B Handler
.org 0x001A
    jmp TIM1_OVF ; Timer1 Overflow Handler
.org 0x001C
    reti ; jmp TIM0_COMPA ; Timer0 Compare A Handler
.org 0x001E
    reti ; jmp TIM0_COMPB ; Timer0 Compare B Handler
.org 0x0020
    reti ; jmp TIM0_OVF ; Timer0 Overflow Handler
.org 0x0022
    reti ; jmp SPI_STC ; SPI Transfer Complete Handler
.org 0x0024
    reti ; jmp USART_RXC ; USART, RX Complete Handler
.org 0x0026
    reti ; jmp USART_UDRE ; USART, UDR Empty Handler
.org 0x0028
    reti ; jmp USART_TXC ; USART, TX Complete Handler
.org 0x002A
    reti ; jmp ADC ; ADC Conversion Complete Handler
.org 0x002C
    reti ; jmp EE_RDY ; EEPROM Ready Handler
.org 0x002E
    reti ; jmp ANA_COMP ; Analog Comparator Handler
.org 0x0030
    reti ; jmp TWI ; 2-wire Serial Interface Handler
.org 0x0032
    reti ; jmp SPM_RDY ; Store Program Memory Ready Handler

.include "ports.asm"
.include "helper.asm"
.include "usart.asm"
.include "eeprom.asm"

TIM1_OVF:
    push r16
    push r30
    push r31

    in r16, SREG ; save SREG since it can happen that we interrupt the cpu at a point where the vaule in SREG is still needed

    in r30, PORTB
    ldi r31, 0b00100000
    eor r30, r31
    out PORTB, r30 ; flip PB5

    memsave [TCNT1H, TCNT1L, TCNT_O]

    out SREG, r16 ; restore sreg
    pop r31
    pop r30
    pop r16
    reti ; return from interrupt

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

    memsave [TCNT1H, TCNT1L, TCNT_O]

    ldi r16, 0b00000101
    load [r31:r30, TCCR1B]
    st Z, r16 ; set preescaler to 1024

    ldi r16, 0
    load [r31:r30, TCCR1A]
    st Z, r16 ; disable all timer features with makes it a overflow timer
    
    ldi r16, 0b00000001
    load [r31:r30, TIMSK1]
    st Z, r16 ; unmask timer overflow interrupt 1

    sei

    ret ; return
    
loop:
    ldi r30, low(2 * hello)
    ldi r31, high(2 * hello)
    call USART0_transmit_str
    
    ret ; return

hello: .db "Hello World!", 10, 13, 0
