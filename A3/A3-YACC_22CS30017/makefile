all: 
	yacc -d expr.y
	flex expr.l
	g++ expr.cpp 

run:
	./a.out < input.txt > output.txt

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a.out output.txt
