%{
#include "y.tab.h" 
%}

%option noyywrap

%%
"set"                               {return set;}
[a-zA-Z][a-zA-Z0-9]*                {yylval.id = strdup(yytext); return ID;}
[-+]?[1-9][0-9]*|0                   {yylval.num = atoi(yytext); return NUM;}
"+"                                 {return plus;}
"-"                                 {return minus;}
"*"                                 {return mul;}
"/"                                 {return dvd;}
"%"                                 {return mod;}
"**"                                {return pwr;}
"("|")"                             {return yytext[0];}
[ \t\n]                             {;}

%%