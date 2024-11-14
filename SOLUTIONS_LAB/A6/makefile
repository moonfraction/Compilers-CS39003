all:
	yacc -d prog.y
	lex prog.l
	gcc -o codegen codegen.c

run: all
	./codegen < sample.txt>sampleout.txt

clean:
	-rm -f lex.yy.c y.tab.c y.tab.h codegen
