.macro load
    ; This message is shown if you use the macro within your code
    ; specifying no parameters. If your macro allows the case where
    ; no parameters are given, exchange .message with your code.
    .message "no parameters specified"
.endm

; Here we define the macro "load" for the case it is being used
; with two registers as first parameter and an immediate (constant)
; value as second parameter:

.macro load_16_i
    ldi @0,high(@2)
    ldi @1,low(@2)
.endm

.macro memsave
    .message "no parameters specified"
.endm

.macro memsave_i_i_i
    load [r31:r30, @0]
    ldi r16, high(@2)
    st Z, r16

    load [r31:r30, @1]
    ldi r16, low(@2)
    st Z, r16
.endm

.macro subs
    .message "no parameters specified"
.endm

.macro subs_16_16
    sub @1, @3
    sbc @0, @2
.endm

.macro subs_16_8
    sub  @1, @2
    sbci @0, 0
.endm

.macro addi
    .message "no parameters specified"
.endm

.macro addi_16_16
    add @1, @3
    adc @0, @2
.endm
:
.macro addi_16_8
    add @1, @2
    ldi r16, 0
    adc @0, r16
.endm

.macro pusha
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push r16
    push r17
    push r18
    push r19
    push r20
    push r21
    push r22
    push r23
    push r24
    push r25
    push r26
    push r27
    push r28
    push r29
    push r30
    push r31
.endm

.macro popa
    pop r31
    pop r30
    pop r29
    pop r28
    pop r27
    pop r26
    pop r25
    pop r24
    pop r23
    pop r22
    pop r21
    pop r20
    pop r19
    pop r18
    pop r17
    pop r16
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
.endm
