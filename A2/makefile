all: clean
	flex list.l
	g++ -o evalexpr evalexpr.cpp
	@echo "Compilation Successful, use 'make run' to generate output file"

run:
	./evalexpr < input_eg2.txt > output.txt

clean:
	rm -f lex.yy.c evalexpr output.txt *.out
