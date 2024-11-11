%{
#define LP 1
#define RP 2
#define NUM 3
#define MOD 4
#define ID 5
#define ASG 6
#define PLUS 7
#define MINUS 8
#define MUL 9
#define DIV 10
#define SEMICOLON 11
#define INT 12
%}

space	[ \t\n]
spaces	{space}+
digit	[0-9]
digits	{digit}+
frac	\.{digits}
expt	[Ee][+-]?{digits}
number	{digits}{frac}?{expt}?
id	[a-zA-Z_][a-zA-Z0-9_]*
PUNC [;]
INT "int"

%option noyywrap
%%

{spaces}	{ }
{number}	{ return(NUM); }
"("		{ return(LP); }
")"		{ return(RP); }
"+"		{ return(PLUS); }
"-"		{ return(MINUS); }
"*"		{ return(MUL); }
"/"		{ return(DIV); }
"%"		{ return(MOD); }
{id}		{ return(ID); }
"="		{ return(ASG); }
{PUNC}		{ return SEMICOLON; }
{INT}		{ return INT; }

%%

// int yywrap(void) {
//     return 1;
// }