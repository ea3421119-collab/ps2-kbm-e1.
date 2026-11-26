EE_BIN = usbinput.elf
EE_OBJS = main.o usbd_irx.o ps2kbd_irx.o ps2mouse_irx.o
EE_LIBS = -ldebug -lkbd -lmouse -lpatches
EE_CFLAGS += -Wall -O2
BIN2C = $(PS2SDK)/bin/bin2c

.PHONY: all check-sdk clean

all: check-sdk $(EE_BIN)

check-sdk:
	@test -n "$(PS2SDK)" || { echo "ERROR: PS2SDK no esta definido"; exit 1; }
	@for f in usbd ps2kbd ps2mouse; do test -f "$(PS2SDK)/iop/irx/$$f.irx" || { echo "FALTA $(PS2SDK)/iop/irx/$$f.irx"; exit 1; }; done
	@for l in kbd mouse debug patches; do test -f "$(PS2SDK)/ee/lib/lib$$l.a" || { echo "FALTA $(PS2SDK)/ee/lib/lib$$l.a"; exit 1; }; done
	@test -x "$(BIN2C)" || { echo "FALTA $(BIN2C)"; exit 1; }

usbd_irx.c: $(PS2SDK)/iop/irx/usbd.irx
	$(BIN2C) $< $@ usbd_irx

ps2kbd_irx.c: $(PS2SDK)/iop/irx/ps2kbd.irx
	$(BIN2C) $< $@ ps2kbd_irx

ps2mouse_irx.c: $(PS2SDK)/iop/irx/ps2mouse.irx
	$(BIN2C) $< $@ ps2mouse_irx

clean:
	rm -f $(EE_BIN) $(EE_OBJS) usbd_irx.c ps2kbd_irx.c ps2mouse_irx.c

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
