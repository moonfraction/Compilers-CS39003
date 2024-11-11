all: clean
	flex latex.l
	gcc -o procltx procltx.c
	@echo "Compilation Successful, use 'make run' to generate output file"

run:
	./procltx < A1.tex > output.txt

clean:
	rm -f lex.yy.c procltx output.txt *.out
