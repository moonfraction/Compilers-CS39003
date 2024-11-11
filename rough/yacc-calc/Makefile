all:
	yacc -d calc.y
	flex calc.l
	gcc proclines.c -ly -ll
	./a.out < sample.txt

clean:
	-rm -f a.out y.tab.h y.tab.c lex.yy.c
