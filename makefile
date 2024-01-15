firmware := Firmware/AppleIISd.bin
flasher := Software/Flasher.bin
dsk := Binary/Flasher.dsk
ac := java -jar Binary/AppleCommander-ac-1.5.0.jar

.PHONY: all clean $(firmware) $(flasher)
all: $(dsk)

clean:
	$(MAKE) clean --directory=$(dir $(firmware))
	$(MAKE) clean --directory=$(dir $(flasher))

$(firmware):
	$(MAKE) OPTIONS=mapfile,listing --directory=$(dir $@)
	$(ac) -d $(dsk) $(notdir $@)
	$(ac) -p $(dsk) $(notdir $@) $$00 < $@
	cp $@ Binary/

$(flasher):
	$(MAKE) --directory=$(dir $@)
	$(ac) -d $(dsk) $(basename $(notdir $@)).SYSTEM
	$(ac) -as $(dsk) $(basename $(notdir $@)).SYSTEM < $@
	cp $@ Binary/	

$(dsk): $(firmware) $(flasher)

