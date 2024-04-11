all: cabrillo

cabrillo.tab.c cabrillo.tab.h:	cabrillo.y
	bison -p cab -t -v -d cabrillo.y

lex.cab.c: cabrillo.l cabrillo.tab.h
	flex -P cab cabrillo.l

cabrillo: lex.cab.c cabrillo.tab.c cabrillo.tab.h
	gcc -o cabrillo cabrillo.tab.c lex.cab.c

debug: lex.cab.c cabrillo.tab.c cabrillo.tab.h
	gcc -g -o cabrillo-g cabrillo.tab.c lex.cab.c

clean:
	rm cabrillo cabrillo-g cabrillo.tab.c lex.cab.c cabrillo.tab.h cabrillo.output

