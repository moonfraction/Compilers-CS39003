#include<stdio.h>
#include "lex.yy.c"

typedef struct _node {
   char *name;
   int cnt;
   struct _node *next;
} node;
typedef node *symboltable;

symboltable addtbl ( symboltable T, char *id )
{
   node *p;

   p = T;
   while (p) {
      if (!strcmp(p->name,id)) { //Identifier already exists
        p->cnt++;
        return T;
      }
      p = p -> next;
   }

    // Adding new identifier
   p = (node *)malloc(sizeof(node));
   p -> name = (char *)malloc((strlen(id)+1) * sizeof(char));
   p -> cnt = 1;
   strcpy(p -> name, id);
   p -> next = T;
   return p;
}


int main(){
    symboltable keyWord = NULL;
    symboltable identifier = NULL;
    symboltable constant = NULL;
    symboltable stringLiteral = NULL;

    int token;
    while((token = yylex())){
        switch(token){
            case KW:
                printf("<keyword, %s>\n", yytext);
                keyWord = addtbl(keyWord, yytext);
                break;
            case ID:
                printf("<identifier, %s>\n", yytext);
                identifier = addtbl(identifier, yytext);
                break;
            case CONST:
                printf("<constant, %s>\n", yytext);
                constant = addtbl(constant, yytext);
                break;
            case STRL:
                printf("<string_literal, %s>\n", yytext);
                stringLiteral = addtbl(stringLiteral, yytext);
                break;
            case PUNC:
                printf("<punctuation, %s>\n", yytext);
                break;
            case CMMT_SL:
            //remove \n from the end of yytext
                yytext[strlen(yytext)-1] = '\0';
                printf("<comment_single_line, %s>\n", yytext);
                break;
            case CMMT_ML:
                printf("<comment_multi_line, %s>\n", yytext);
                break;
            case WS:
                // printf("Whitespace: %s\n", yytext);
                break;
            case ERR:
                printf("<error, %s>\n", yytext);
                break;
            default:
                printf("<unknown_token, %s>\n", yytext);
                break;
        }
    }

    printf("\nKeywords:\n");
    while(keyWord){
        printf("%s (%d)\n", keyWord->name, keyWord->cnt);
        keyWord = keyWord->next;
    }

    printf("\nIdentifiers:\n");
    while(identifier){
        printf("%s (%d)\n", identifier->name, identifier->cnt);
        identifier = identifier->next;
    }

    printf("\nConstants:\n");
    while(constant){
        printf("%s (%d)\n", constant->name, constant->cnt);
        constant = constant->next;
    }

    printf("\nString Literals:\n");
    while(stringLiteral){
        printf("%s (%d)\n", stringLiteral->name, stringLiteral->cnt);
        stringLiteral = stringLiteral->next;
    }

    return 0;
}