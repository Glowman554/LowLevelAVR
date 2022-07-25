main.hex: main.asm
	@echo AS $<
	@avra -fI $<
	@rm *.eep.hex *.obj *.cof

all: main.hex

clean:
	rm *.hex -v

DEVICE=/dev/ttyACM0

upload: main.hex
	avrdude -c arduino -p m328p -P $(DEVICE) -b 115200 -U flash:w:$<

.PHONY: all upload monitor
