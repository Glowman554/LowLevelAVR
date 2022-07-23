%.hex: %.asm
	@echo AS $<
	@avra -fI $<
	@rm *.eep.hex *.obj *.cof

%.hex: %.c
	@echo CC $<
	@avr-gcc -mmcu=atmega328p $< -o $@.elf
	@avr-objcopy -O ihex -R .eeprom $@.elf $@

all: $(patsubst %.asm,%.hex,$(wildcard *.asm))  $(patsubst %.c,%.hex,$(wildcard *.c))

clean:
	rm *.hex *.elf -v

DEVICE=/dev/ttyACM0

upload: ${program}.hex
	avrdude -c arduino -p m328p -P $(DEVICE) -b 115200 -U flash:w:$<

.PHONY: all upload monitor
