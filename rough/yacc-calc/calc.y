%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex ( );
void yyerror ( char * );
int curridx = 0;
int results[1024] = {0};
int exprerror = 0;
void errmsg ( char *, char * );
int addresult ( int );
int getres ( char * );
int getresult ( int );
void prnresult ( int );
%}

%union { int num; }
%start lines
%token <num> NUMBER
%token <num> RESULT
%token <num> EOE
%type <num> lines expr term factor

%%

lines	: lines expr EOE	{ if (!exprerror) prnresult(addresult($2)); exprerror = 0; }
	| expr EOE		{ if (!exprerror) prnresult(addresult($1)); exprerror = 0; }
	;

expr	: expr '+' term		{ $$ = $1 + $3; }
	| expr '-' term		{ $$ = $1 - $3; }
	| term			{ $$ = $1; }
	;

term	: term '*' factor	{ $$ = $1 * $3; }
	| term '/' factor	{ $$ = $1 / $3; }
	| term '%' factor	{ $$ = $1 % $3; }
	| factor		{ $$ = $1; }
	;

factor	: '(' expr ')'		{ $$ = $2; }
	| NUMBER		{ $$ = $1; }
	| RESULT		{ $$ = $1; }
	;

%%

void errmsg ( char *msg, char *offender )
{
   fprintf(stderr, "%s: %s\n", msg, offender);
}

int addresult ( int r )
{
   ++curridx;
   results[curridx] = r;
   results[0] = curridx;
   return curridx;
}

int getresult ( int i )
{
   int idx = -1;
   char ISTR[32];

   if ((1 <= i) && (i <= curridx)) idx = i;
   else if ((i == -1) && (curridx > 1)) idx = curridx;
   else {
      sprintf(ISTR, "%d", i);
      errmsg("*** Error: Invalid index in results table", ISTR);
      exprerror = 1;
      return 0;
   }
   return results[idx];
}

int getres ( char *str )
{
   if (!strcmp(str, "%%")) return getresult(-1);
   return getresult(atoi(str+1));
}

void prnresult ( int i )
{
   char ISTR[32];

   if ((1 <= i) && (i <= curridx)) {
      printf("%%%d = %d\n", i, results[i]);
   } else {
      sprintf(ISTR, "%d", i);
      errmsg("*** Error: Invalid index in results table", ISTR);
   }
   return;
}

void yyerror ( char * s )
{
   fprintf(stderr, "Error: %s\n", s);
}
