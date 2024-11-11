%{
#include "y.tab.h"
int yylex();
void yyerror(char *);
int getres ( char * );
void errmsg ( char *, char * );
%}

ws	[ \t]
num	[0-9]+
op	[+\-*/%]
paren	[()]
posnum	[1-9][0-9]*
res	\%\%|\%{posnum}
eoe	;({ws}*\n)?|\n
igneol	\\{ws}*\n

%%

{ws}		{ }
{igneol}	{ }
{eoe}		{ return EOE; }
{op}		{ return yytext[0]; }
{num}		{ yylval.num = atoi(yytext); return NUMBER; }
{paren}		{ return yytext[0]; }
{res}		{ yylval.num = getres(yytext); return RESULT; }
.		{ errmsg("*** Error: Invalid character", yytext); }

%%
