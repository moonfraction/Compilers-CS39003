#include "lex.yy.c"
#include "y.tab.c"

int main ()
{
   yyparse();
   exit(0);
}
