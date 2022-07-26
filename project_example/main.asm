.device ATmega328P

.equ BAUD   = 9600
.equ F_CPU  = 16000000

.equ TCNT_O = 65535 - (F_CPU / 1024)

.org 0x0000 ; Execution starts here
    jmp main
.org 0x0002
    jmp EXT_INT0 ; IRQ0 Handler
.org 0x0004
    jmp EXT_INT1 ; IRQ1 Handler
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
.include "interrupts.asm"
.include "pwm.asm"
.include "timer1.asm"

TIM1_OVF:
    isr_begin

    in r30, PORTB
    ldi r31, 0b00110000
    eor r30, r31
    out PORTB, r30 ; flip PB5

    timer1_cnt [TCNT_O]

    isr_end
    reti ; return from interrupt

EXT_INT0:
    isr_begin

    load [r31:r30, 2 * int0_str]
    call USART0_transmit_str

    isr_end
    reti ; return from interrupt

EXT_INT1:
    isr_begin

    load [r31:r30, 2 * int1_str]
    call USART0_transmit_str

    isr_end
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
    sbi DDRB, 4 ; set PB4 output
    sbi DDRB, 3 ; set PB3 output

    ldi r16, 0b00000000
    out DDRD, r16
    ldi r16, 0b11111111
    out PORTD, r16

    call USART0_init

    timer1_cnt [TCNT_O]
    call timer1_set_prescaler_1024
    call timer1_to_ovf
    call timer1_unmask_ovf

    call INT1_set_intr_falling_edge
    call INT0_set_intr_rising_edge

    ldi r22, 5
    call set_pb3_pwm

    sei

    ; ldi r16, SP_PWD ; only can wake up from INT0 or INT1
    ; call enter_sleep_mode

    ret ; return
    
loop:
    ; ldi r30, low(2 * hello)
    ; ldi r31, high(2 * hello)
    ; call USART0_transmit_str
    ldi r16, SP_IDL
    call enter_sleep_mode
    ret ; return
    
int0_str: .db "INT0", 10, 13, 0
int1_str: .db "INT1", 10, 13, 0
