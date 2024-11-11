CC = gcc
CFLAGS = -D_GNU_SOURCE -Wall -g3 -fsanitize=address -I. -lm -std=c17
LEX = flex
LEXFLAGS = --yylineno
YACC = bison
YACCFLAGS = --report=all --debug -d

.SUFFIXES:

.PHONY: all clean

all: expr

expr.tab.c expr.tab.h: expr.y symbol.h tree.h
	$(YACC) $(YACCFLAGS) $<

expr.yy.c: expr.l expr.tab.h tree.h
	$(LEX) $(LEXFLAGS) -o $@ $<

symbol.o: symbol.c symbol.h
tree.o: tree.c tree.h symbol.h expr.tab.h

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

expr: expr.o expr.yy.o expr.tab.o symbol.o tree.o
	$(CC) $(CFLAGS) -o $@ $^

clean:
	-$(RM) expr.yy.* expr.tab.* *.o expr.output expr err.txt
