all: cabrillo

cabrillo.tab.c cabrillo.tab.h:	cabrillo.y
	bison -t -v -d cabrillo.y

lex.yy.c: cabrillo.l cabrillo.tab.h
	flex cabrillo.l

cabrillo: lex.yy.c cabrillo.tab.c cabrillo.tab.h
	gcc -o cabrillo cabrillo.tab.c lex.yy.c

debug: lex.yy.c cabrillo.tab.c cabrillo.tab.h
	gcc -g -o cabrillo-g cabrillo.tab.c lex.yy.c

clean:
	rm cabrillo cabrillo-g cabrillo.tab.c lex.yy.c cabrillo.tab.h cabrillo.output

