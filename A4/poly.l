%{
    #include "y.tab.h"
%}

d                  [2-9]
zero               [0]
one                [1]
x                  "x"
exp_sym            "^"
plus               "+"
minus              "-"

whitespace         [ \t\n]
error              .

%option noyywrap

%%
{d}                 { yylval.intval = atoi(yytext); return D; }
{zero}              { return ZERO; }
{one}               { return ONE; }
{x}                 { return X; }
{exp_sym}           { return EXP_SYM; }
{plus}              { return PLUS; }
{minus}             { return MINUS; }
{whitespace}        { /* ignore */ }
{error}             { /* ignore */ }

%%