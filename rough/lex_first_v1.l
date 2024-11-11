/*Auxiliary declarations*/
%{
    #include <stdio.h>
    #define IF 1
    #define ELSE 2
    #define NUM 3
    #define OP 4
    #define ERR 5
%}

/*Regular Definitions*/
%%
if return (IF);
else return (ELSE);
[0-9]+ return (NUM);
[+-/*] return (OP); 
. return (ERR);


%%
int main()
{
    int ntoken;
    do{
        ntoken =  yylex();
        if(ntoken==0) break;
        if (ntoken == IF) printf("The IF token is %s\n", yytext);
        else if (ntoken == ELSE) printf("The ELSE token is %s\n", yytext);
        else if (ntoken == NUM) printf("The NUM token is %s\n", yytext);
        else if (ntoken == OP) printf("The OP token is %s\n", yytext);
        else if (ntoken == ERR) printf("The ERR token is %s\n", yytext);
    } while(1);
    return 1;
}

int yywrap()
{
    return 1;
}