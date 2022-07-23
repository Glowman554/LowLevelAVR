#include <avr/io.h>
#include <avr/interrupt.h>

#define F_CPU 16000000
#define PRESCALER 1024
#define TCNT1_ORIG 65535 - (F_CPU / PRESCALER)

ISR(TIMER1_OVF_vect) {
    PORTB ^= _BV(DDB5);
    TCNT1 = TCNT1_ORIG;
}

int main() {
    DDRB |= _BV(DDB5);

    TCNT1 = TCNT1_ORIG;

    // set prescaler to 1024
    // 16Mhz / 1024 = 15625Hz
    TCCR1B = (1 << CS10) | (1 << CS12);

    // disable all timer features with makes is a overflow timer
    TCCR1A = 0x00;

    TIMSK1 = (1 << TOIE1); // unmask timer overflow interrupt 1

    sei(); // enable interrupts

    while (1);
}
