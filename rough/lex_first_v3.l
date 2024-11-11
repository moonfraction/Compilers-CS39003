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
. printf("err %s\n", yytext);


%%

int yywrap()
{
    return 1;
}



/*
Undefined symbols for architecture arm64:
  "_main", referenced from:
      <initial-undefines>
ld: symbol(s) not found for architecture arm64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
*/