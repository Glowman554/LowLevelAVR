.device ATmega328P

.equ PORTB  = 0x05
.equ DDRB   = 0x04

.equ LED_B  = 5

.equ RAMEND =  0x8ff
.equ SPL    = 0x3d
.equ SPH    = 0x3e

.equ EEARH  = 0x22
.equ EEARL  = 0x21
.equ EEDR   = 0x20
.equ EECR   = 0x1f

.org 0x0000 ; Execution starts here
    rjmp main

; write to eeprom. Address to write to: low(r17), high(r18). data in r16
EEPROM_write:
    sbic EECR, 1 ; wait for complete of previous write
    rjmp EEPROM_write
    
    out EEARH, r18 ; write address high
    out EEARL, r17 ; write address low
    out EEDR, r16 ; write data
    
    sbi EECR, 2 ; set eeprom master write enable
    sbi EECR, 1 ; set eeprom write enable (this starts the write)
    ret

; read from eeprom. Address to read from: low(r17), high(r18). result in r16
EEPROM_read:
    sbic EECR, 1 ; wait for complete of previous write
    rjmp EEPROM_read
    out EEARH, r18 ; write address high
    out EEARL, r17 ; write address low
    sbi EECR, 0 ; write eeprom read enable (this reads from the eeprom)
    in r16, EEDR ; read data
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

.equ EEPROM_ADDR = 0x10

setup:
    ldi r16, 0xff
    out DDRB, r16 ; set PB5 output

    ldi r17, low(EEPROM_ADDR) ; load addr low
    ldi r18, high(EEPROM_ADDR) ; load addr high
    ldi r16, 0b10101010 ; data to write
    call EEPROM_write ; writes data in r16 to eeprom
    call EEPROM_read ; reads data in eeprom to r16

    out PORTB, r16
    
    ret ; return 

loop:
    ret ; return
