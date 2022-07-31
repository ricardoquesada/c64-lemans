.INTERMEDIATE: commando.prg commando.exo main-charset_sprites-2084.bin
.PHONY: all clean run

D64_IMAGE = "bin/lemans.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: lemans.prg

lemans.prg: src/lemans.tas
	64tass -Wall -Werror --cbm-prg -o bin/lemans.prg -L bin/list.txt -l bin/labels.txt --vice-labels src/lemans.tas
	md5sum bin/lemans.prg orig/lemans.prg

clean:
	-rm $(D64_IMAGE)
	-rm bin/*.prg bin/*.txt bin/*.d64
