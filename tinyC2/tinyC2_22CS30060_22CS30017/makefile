all: clean
	clear
	yacc -d tinyC2_22CS30060_22CS30017.y
	flex tinyC2_22CS30060_22CS30017.l
	gcc -o tinyC2_22CS30060_22CS30017 tinyC2_22CS30060_22CS30017.c
	@echo "Compilation Successful, use make run to generate output file"

run:
	./tinyC2_22CS30060_22CS30017 < input_22CS30060_22CS30017.c > output_22CS30060_22CS30017.txt

clean:
	rm -f y.tab.c y.tab.h lex.yy.c tinyC2_22CS30060_22CS30017 output_22CS30060_22CS30017.txt