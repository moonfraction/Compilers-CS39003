#include <stdio.h>
#include "head.h"
extern int yylex();
extern int yylineno;
extern char *yytext;
char *names[] = {NULL, "db_type", "db_name", "db_table_prefix", "db_port" };
int main(void){
    int ntoken, vtoken;
    ntoken = yylex();
    while(ntoken){
        printf("Token: %d\n", ntoken);
        if(yylex() != COLON){
            printf("Error: syntax error in line %d, expected a ':' but found %s\n", yylineno, yytext);
            return 1;
        }
        vtoken = yylex();
        switch(ntoken){
            case TYPE:
            case NAME:
            case TABLE_PREFIX:
                if(vtoken != IDENTIFIER){
                    printf("Error: syntax error in line %d, expected an identifier but found %s\n", yylineno, yytext);
                    return 1;
                }
                printf("%s is set to %s\n", names[ntoken], yytext); 
                break;
            case PORT:
                if(vtoken != INTEGER){
                    printf("Error: syntax error in line %d, expected an integer but found %s\n", yylineno, yytext);
                    return 1;
                }
                printf("%s is set to %s\n", names[ntoken], yytext); 
                break;  
            default:
                printf("Error: syntax error in line %d, unexpected token %s\n", yylineno, yytext);
                return 1;
        }
        ntoken = yylex();
    }
    return 0;
}