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
