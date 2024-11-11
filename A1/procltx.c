#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
      if (!strcmp(p->name,id)) {
        //  printf("Identifier %s already exists\n", id);
        p->cnt++;
        return T;
      }
      p = p -> next;
   }
//    printf("Adding new identifier: %s\n", id);
   p = (node *)malloc(sizeof(node));
   p -> name = (char *)malloc((strlen(id)+1) * sizeof(char));
   strcpy(p -> name, id);
   p -> cnt = 1;
   p -> next = T;
   return p;
}

int main ()
{
   int nextok;
   symboltable T = NULL; //for commands
   symboltable T2 = NULL; // for env
   int math = 0;
   int disp = 0;

   while ((nextok = yylex())) {
      switch (nextok) {
        case SINGLE_CMD: /*printf("Single_cmd %s\n", yytext);*/ T = addtbl(T,yytext); break;
        case STR_CMD: /*printf("Str_cmd %s\n", yytext);*/ T = addtbl(T,yytext); break;
        case ACTIVE: /*printf("ACTIVE %s\n", yytext);*/ T = addtbl(T,yytext); break;
        case TEXT: break;
        case WS: break;
        case MATH_EQ: math++; break;
        case DISP_EQ: /* printf("Display Equation: %s\n", yytext); */disp++; break;
        case CMMT: /* printf("Comment: %s\n", yytext); */break;
        case ENV: T2 = addtbl(T2,yytext); break;
        default: printf("Unknown token\n"); break;
      }
   }

    node *p = T;
    if(p) printf("Commands Used:\n");
    while (p) {
        printf("\t%s (%d)\n", p->name, p->cnt);
        p = p->next;
    }

    p = T2;
    if(p) printf("\nEnvironments Used:\n");
    while (p) {
        char *env_name  = malloc(strlen(p->name) + 1);
        while(*p->name != '{') p->name++;
        p->name++;
        int i = 0;
        while(*p->name != '}') env_name[i++] = *p->name++;
        env_name[i] = '\0';
        printf("\t%s (%d)\n", env_name, p->cnt);
        p = p->next;
    }
    printf("\n");

    if(math)printf("%d math equations found\n", math/2);
    if(disp)printf("%d displayed equations found\n", disp/2);

   exit(0);
}