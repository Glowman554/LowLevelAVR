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
