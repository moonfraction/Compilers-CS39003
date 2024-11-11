all: clean
	yacc -d poly.y
	flex poly.l
	gcc -o poly polyutils.c
	@echo "Compilation Successful, use 'make run' to generate output file"

run:
	./poly < sample.txt > output.txt

clean:
	rm -f y.tab.c y.tab.h lex.yy.c poly output.txt *.out