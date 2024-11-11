run: clean a.out
	./a.out < ass3_22CS30017_22CS30060_test.c

a.out: lex.yy.c
	gcc ass3_22CS30017_22CS30060.c

lex.yy.c: ass3_22CS30017_22CS30060.l
	lex ass3_22CS30017_22CS30060.l

clean:
	rm -f lex.yy.c a.out