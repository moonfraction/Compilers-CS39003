%{
    #include <stdio.h>
%}

%%
if printf("if\n");
else printf("else\n");
[0-9]+ printf("num %s\n", yytext);
[+-/*] printf("op %s\n", yytext);
. printf("err %s\n", yytext);

%%
int main()
{
    yylex();
    return 1;
}

int yywrap()
{
    return 1;
}