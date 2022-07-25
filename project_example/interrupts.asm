INT1_set_intr_falling_edge:
    load [r31:r30, EICRA]
    ld r16, Z
    ldi r17, 0b00000011
    and r16, r17 ; r16 now contains the bits used for INT0
    ldi r17, 0b00001000
    or r16, r17 ; r16 now contains the original bits for INT0 and the new ones for INT1
    st Z, r16

    sbi EIMSK, 1 ; unmask INT1

    ret

INT0_set_intr_falling_edge:
    load [r31:r30, EICRA]
    ld r16, Z
    ldi r17, 0b00001100
    and r16, r17 ; r16 now contains the bits used for INT1
    ldi r17, 0b00000010
    or r16, r17 ; r16 now contains the original bits for INT1 and the new ones for INT0

    sbi EIMSK, 0 ; unmask INT0

    ret
