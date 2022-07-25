INT1_set_intr_falling_edge:
    push r16
    push r17
    push r30
    push r31

    load [r31:r30, EICRA]
    ld r16, Z
    ldi r17, 0b00000011
    and r16, r17 ; r16 now contains the bits used for INT0
    ldi r17, 0b00001000
    or r16, r17 ; r16 now contains the original bits for INT0 and the new ones for INT1
    st Z, r16

    sbi EIMSK, 1 ; unmask INT1

    pop r31
    pop r30
    pop r17
    pop r16

    ret

INT1_set_intr_rising_edge:
    push r16
    push r17
    push r30
    push r31

    load [r31:r30, EICRA]
    ld r16, Z
    ldi r17, 0b00000011
    and r16, r17 ; r16 now contains the bits used for INT0
    ldi r17, 0b00001100
    or r16, r17 ; r16 now contains the original bits for INT0 and the new ones for INT1
    st Z, r16

    sbi EIMSK, 1 ; unmask INT1

    pop r31
    pop r30
    pop r17
    pop r16

    ret

INT0_set_intr_falling_edge:
    push r16
    push r17
    push r30
    push r31
    
    load [r31:r30, EICRA]
    ld r16, Z
    ldi r17, 0b00001100
    and r16, r17 ; r16 now contains the bits used for INT1
    ldi r17, 0b00000010
    or r16, r17 ; r16 now contains the original bits for INT1 and the new ones for INT0
    st Z, r16

    sbi EIMSK, 0 ; unmask INT0

    pop r31
    pop r30
    pop r17
    pop r16

    ret

INT0_set_intr_rising_edge:
    push r16
    push r17
    push r30
    push r31

    load [r31:r30, EICRA]
    ld r16, Z
    ldi r17, 0b00001100
    and r16, r17 ; r16 now contains the bits used for INT1
    ldi r17, 0b00000011
    or r16, r17 ; r16 now contains the original bits for INT1 and the new ones for INT0
    st Z, r16

    sbi EIMSK, 0 ; unmask INT0

    pop r31
    pop r30
    pop r17
    pop r16

    ret

; enter sleep mode stored in r16 (SE bit gets set automatically)
enter_sleep_mode:
    push r16
    push r17

    ldi r17, 0b00000001
    or r16, r17

    out SMCR, r16

    sleep

    ldi r16, 0b00000000
    out SMCR, r16

    pop r17
    pop r16

    ret
