timer2_set_prescaler:
    push r16
    push r30
    push r31

    load [r31:r30, TCCR2B]

    ldi r16, 0b00000100 ; set prescaler to 64
    st Z, r16

    pop r31
    pop r30
    pop r16
    ret

; pwm value in r22
set_pb3_pwm:
    push r16
    push r30
    push r31

    rcall timer2_set_prescaler

    load [r31:r30, TCCR2A]

    ld r16, Z
    ori r16, 0b10000001 ; enable channel a and phase correct pwm
    st Z, r16

    load [r31:r30, OCR2A]
    st Z, r22

    pop r31
    pop r30
    pop r16
    ret

set_pd3_pwm:
    push r16
    push r30
    push r31

    rcall timer2_set_prescaler

    load [r31:r30, TCCR2A]

    ld r16, Z
    ori r16, 0b00100001 ; enable channel b and phase correct pwm
    st Z, r16

    load [r31:r30, OCR2B]
    st Z, r22

    pop r31
    pop r30
    pop r16
    ret
    
