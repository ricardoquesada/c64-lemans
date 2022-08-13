.INTERMEDIATE: lemans.prg lemans.exo
.PHONY: all clean run

D64_IMAGE = "bin/lemans.d64"
X64 = x64
DEBUGGER = c64debugger
X64SC = x64sc
C1541 = c1541

all: crt

lemans.prg: src/lemans.tas src/charset-f800-f97f.bin src/sprites-f980-f9ff.bin src/charset-fa00-fcbf.bin src/sprites-fcc0-ffbf.bin
	64tass -Wall -Werror --cbm-prg -o bin/lemans.prg -L bin/list.txt -l bin/labels.txt --vice-labels src/lemans.tas
	md5sum bin/lemans.prg orig/lemans.prg

crt: lemans.prg
	dd if=bin/lemans.prg of=bin/lemans.bin skip=2 bs=1
	cat orig/crt_header_ultimax.bin bin/lemans.bin > bin/lemans.crt
	md5sum bin/lemans.crt orig/lemans.crt

run: crt
	$(X64) -verbose -moncommands bin/labels.txt bin/lemans.crt

lemans.exo: lemans.prg
	exomizer sfx sys -x1 -Di_line_number=2019 bin/lemans.prg -o bin/lemans.exo.prg

runprg: lemans.prg
	$(X64) -verbose -moncommands bin/labels.txt bin/lemans.prg

runexo: lemans.exo
	$(X64) -verbose -moncommands bin/labels.txt bin/lemans.exo.prg

d64: lemans.exo
	$(C1541) -format "lemans ,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/lemans.exo.prg "lemans"
	$(C1541) $(D64_IMAGE) -list

debug: crt
	$(DEBUGGER) -crt bin/lemans.crt

clean:
	-rm $(D64_IMAGE)
	-rm bin/*.prg bin/*.txt bin/*.d64 bin/*.bin  bin/*.crt
