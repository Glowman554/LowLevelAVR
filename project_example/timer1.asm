timer1_set_prescaler_1024:
    push r16
    push r30
    push r31
    
    ldi r16, 0b00000101
    load [r31:r30, TCCR1B]
    st Z, r16 ; set preescaler to 1024

    pop r31
    pop r30
    pop r16
    ret

timer1_to_ovf:
    push r16
    push r30
    push r31
    
    ldi r16, 0
    load [r31:r30, TCCR1A]
    st Z, r16 ; disable all timer features with makes it a overflow timer

    pop r31
    pop r30
    pop r16
    ret

timer1_unmask_ovf:
    push r16
    push r30
    push r31
    
    load [r31:r30, TIMSK1]

    ld r16, Z
    ori r16, 0b00000001
    st Z, r16

    pop r31
    pop r30
    pop r16
    ret

.macro timer1_cnt
    .message "no arguments"
.endm

.macro timer1_cnt_i
    memsave [TCNT1H, TCNT1L, @0]
.endm
