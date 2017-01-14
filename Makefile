ROMNAME := test
GBSNAME := gbstest
HEADERNAME := "ZT-SETEST"

all: gb gbs

gb: bin/$(ROMNAME).gb

bin/$(ROMNAME).gb: obj/$(ROMNAME).o
	rgblink -n bin/$(ROMNAME).sym -o bin/$(ROMNAME).gb obj/$(ROMNAME).o
	rgbfix -v -t $(HEADERNAME) bin/$(ROMNAME).gb

obj/$(ROMNAME).o: src/$(ROMNAME).asm src/sound/* inc/*
	rgbasm -h -o obj/$(ROMNAME).o src/$(ROMNAME).asm

clean:
	rm obj/*.o bin/*.gb bin/*.gbs bin/*.sym
	
gbs: bin/$(GBSNAME).gbs

bin/$(GBSNAME).gbs: src/$(GBSNAME).asm
	rgbasm -o obj/$(GBSNAME).o src/$(GBSNAME).asm
	rgblink -o bin/tmp.gbs obj/$(GBSNAME).o
	dd if=bin/tmp.gbs of=bin/tmp.gbsd skip=1136 bs=1
	dd if=bin/tmp.gbs of=bin/tmp.gbsh bs=1 count=112
	cat bin/tmp.gbsh bin/tmp.gbsd > bin/$(GBSNAME).gbs
	rm bin/tmp.gbsh bin/tmp.gbsd bin/tmp.gbs
