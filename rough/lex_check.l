%{
    #include "head.h"
%}

%%
: return COLON;
"db_type" return TYPE;
"db_name" return NAME;
"db_table_prefix" return TABLE_PREFIX;
"db_port" return PORT;
[a-zA-Z][a-zA-Z0-9_]* return IDENTIFIER;
[0-9]+ return INTEGER;
[ \t\n] ;
. printf("Error: %s\n", yytext);

%%
int yywrap() {
    return 1;
}