#include <avr/io.h>

#define BAUD 9600
#define F_CPU 16000000
#define UBRR_VALUE (((F_CPU) + 8UL * (BAUD)) / (16UL * (BAUD)) -1UL)

void USART0_init() {
    UBRR0H = (unsigned char) (UBRR_VALUE >> 8);
    UBRR0L = (unsigned char) UBRR_VALUE;
   
    // Enable receiver and transmitter
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);

    // Set frame format: 8data, 2stop bit
    UCSR0C = (1 << USBS0) | (3 << UCSZ00);
}

void USART0_transmit(unsigned char data) {
    // Wait for empty transmit buffer
    while (!(UCSR0A & (1 << UDRE0)));
    
    // Put data into buffer, sends the data
    UDR0 = data;
}

unsigned char USART0_receive(void) {
    // Wait for data to be received
    while (!(UCSR0A & (1 << RXC0)));

    // Get and return received data from buffer
    return UDR0;
}

void main() {
    DDRB |= _BV(DDB5);
    
    USART0_init();

    USART0_transmit('H');
    USART0_transmit('i');

    PORTB |= _BV(DDB5);

    while (1) {
        USART0_transmit(USART0_receive());
    }
}
