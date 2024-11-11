%{
	#include <string.h>
	#include "expr.tab.h"

	int yyerror( const char *format , ... );
%}

spaces		[ \t\n]+
number		[+-]?(0|[1-9][0-9]*)
ident		[a-zA-Z_][a-zA-Z0-9_]*

%%

"set"			{ return SET; }
{spaces}		{ /* ignore whitespace */ }
{number}		{ yylval.num = atoi(yytext); return NUM;}
{ident}			{ strcpy(yylval.id, yytext); return ID; }
"**"			{ return EXP; }
"+"				{ return ADD; }
"-"				{ return SUB; }
"*"				{ return MUL; }
"/"				{ return DIV; }
"%"				{ return MOD; }
"("				{ return LP;  }
")"				{ return RP;  }
.				{ yyerror("Unknown character: %s\n", yytext); }
