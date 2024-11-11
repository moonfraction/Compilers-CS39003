%{
    #include "y.tab.h"
    #include<iostream>
    #include<cstring>
    using namespace std;
    int yylex();
    void yyerror(char* s);
%}

%%
[ \t\n]         {;}
"("             {return LP;}
")"             {return RP;}
"set"           {return SET;}
"+"             {return PLUS;}
\-              {return MINUS;}
\*              {return MULTIPLY;}
"/"             {return DIVIDE;}
"%"             {return MODULO;}
"**"            {return EXP;}
[+\-]?[0-9]+    {yylval.val = atoi(yytext); return NUM;}
[a-zA-Z_][a-zA-Z_0-9]*      {yylval.id = strdup(yytext); return ID;}
.               {ECHO; yyerror("unexpected character");}
%%

int yywrap(){ return 1 ;}