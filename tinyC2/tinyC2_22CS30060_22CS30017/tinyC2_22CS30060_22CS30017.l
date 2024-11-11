%{
    #include "y.tab.h"
%}

comment_start              "/*"
comment_end                "*/"
comment_line               "//"
comment_body               ([^*]|[*][^/])*
comment_single_line        ({comment_line}.*)
comment_multi_line         ({comment_start}{comment_body}{comment_end})

sizeof                     "sizeof"
inline                     "inline"
static                     "static"
case                       "case"
default                    "default"
if                         "if"
else                       "else"
switch                     "switch"
while                      "while"
do                         "do"
for                        "for"
goto                       "goto"
continue                   "continue"
break                      "break"
return                     "return"

storage_keyword            "extern"|"auto"|"register"
type_sp_keyword            "void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned"|"_Bool"|"_Complex"|"_Imaginary"
type_qf_keyword            "const"|"restrict"|"volatile"


identifier_nondigit        [a-zA-Z_]
digit                      [0-9]
identifier                 {identifier_nondigit}({identifier_nondigit}|{digit})*

sign                       [+-]
escape_sequence            (\\(['"?\\abfnrtv]))
c_char                     [^'\\\n]|{escape_sequence}
c_char_sequence            {c_char}+
character_constant         \'{c_char_sequence}\'
digit_sequence             {digit}+
exponential_part           [eE]{sign}?{digit_sequence}
fractional_constant        {digit_sequence}?\.{digit_sequence}|{digit_sequence}\.
floating_constant          ({fractional_constant}{exponential_part}?|{digit_sequence}{exponential_part})
integer_constant           {digit_sequence}

s_char                     [^"\\\n]|{escape_sequence}
s_char_sequence            {s_char}+
string_literal             \"{s_char_sequence}?\"


lp                         "("
rp                         ")"
lbracket                   "["
rbracket                   "]"
lb                         "{"
rb                         "}"
dot                        "."
arrow                      "->"
inc_op                     "++"
dec_op                     "--"
comma                      ","
and_op                     "&"
mul_op                     "*"
add_op                     "+"
sub_op                     "-"
bitwise_not_op             "~"
logical_not_op             "!"
div_op                     "/"
mod_op                     "%"
left_op                    "<<"
right_op                   ">>"
lt                         "<"
gt                         ">"
lte                        "<="
gte                        ">="
eq                         "=="
neq                        "!="
xor_op                     "^"
or_op                      "|"
logical_and_op             "&&"
logical_or_op              "||"
ques_mark                  "?"
colon                      ":"
assn_eq                    "="
mul_eq                     "*="
div_eq                     "/="
mod_eq                     "%="
add_eq                     "+="
sub_eq                     "-="
left_eq                    "<<="
right_eq                   ">>="
and_eq                     "&="
xor_eq                     "^="
or_eq                      "|="
semi                       ";"
ellipsis                   "..."


whitespace                 [ \t\n]
error                      .

%option noyywrap

%%
{sizeof}                   {return(SIZEOF);}
{inline}                   {return(INLINE);}
{static}                   {return(STATIC);}
{case}                     {return(CASE);}
{default}                  {return(DEFAULT);}
{if}                       {return(IF);}
{else}                     {return(ELSE);}
{switch}                   {return(SWITCH);}
{while}                    {return(WHILE);}
{do}                       {return(DO);}
{for}                      {return(FOR);}
{goto}                     {return(GOTO);}
{continue}                 {return(CONTINUE);}
{break}                    {return(BREAK);}
{return}                   {return(RETURN);}

{comment_single_line}      {}
{comment_multi_line}       {}

{storage_keyword}          {yylval.name = strdup(yytext); return(STORAGE_KEYWORD);}
{type_sp_keyword}          {yylval.name = strdup(yytext); return(TYPE_SP_KEYWORD);}
{type_qf_keyword}          {yylval.name = strdup(yytext); return(TYPE_QF_KEYWORD);}

{identifier}               {yylval.name = strdup(yytext); return(IDENTIFIER);}

{string_literal}           { 
                            yylval.name = strdup(yytext+1);
                            yylval.name[strlen(yylval.name)-1] = '\0';
                            return(STRING_LITERAL);
                            }

{character_constant}       {
                            yylval.character = yytext[1];
                            return(CHARACTER_CONSTANT);
                            }

{floating_constant}        {yylval.float_value = atof(yytext); return(FLOATING_CONSTANT);}
{integer_constant}         {yylval.int_value = atoi(yytext); return(INTEGER_CONSTANT);}

{lp}                       {return(LP);}
{rp}                       {return(RP);}
{lbracket}                 {return(LBRACKET);}
{rbracket}                 {return(RBRACKET);}
{lb}                       {return(LB);}
{rb}                       {return(RB);}
{dot}                      {return(DOT);}
{arrow}                    {return(ARROW);}
{inc_op}                   {return(INC_OP);}
{dec_op}                   {return(DEC_OP);}
{comma}                    {return(COMMA);}
{and_op}                   {return(AND_OP);}
{mul_op}                   {return(MUL_OP);}
{add_op}                   {return(ADD_OP);}
{sub_op}                   {return(SUB_OP);}
{bitwise_not_op}           {return(BITWISE_NOT_OP);}
{logical_not_op}           {return(LOGICAL_NOT_OP);}
{div_op}                   {return(DIV_OP);}
{mod_op}                   {return(MOD_OP);}
{left_op}                  {return(LEFT_OP);}
{right_op}                 {return(RIGHT_OP);}
{lt}                       {return(LT);}
{gt}                       {return(GT);}
{lte}                      {return(LTE);}
{gte}                      {return(GTE);}
{eq}                       {return(EQ);}
{neq}                      {return(NEQ);}
{xor_op}                   {return(XOR_OP);}
{or_op}                    {return(OR_OP);}
{logical_and_op}           {return(LOGICAL_AND_OP);}
{logical_or_op}            {return(LOGICAL_OR_OP);}
{ques_mark}                {return(QUES_MARK);}
{colon}                    {return(COLON);}
{assn_eq}                  {return(ASSN_EQ);}
{mul_eq}                   {return(MUL_EQ);}
{div_eq}                   {return(DIV_EQ);}
{mod_eq}                   {return(MOD_EQ);}
{add_eq}                   {return(ADD_EQ);}
{sub_eq}                   {return(SUB_EQ);}
{left_eq}                  {return(LEFT_EQ);}
{right_eq}                 {return(RIGHT_EQ);}
{and_eq}                   {return(AND_EQ);}
{xor_eq}                   {return(XOR_EQ);}
{or_eq}                    {return(OR_EQ);}
{semi}                     {return(SEMI);}
{ellipsis}                 {return(ELLIPSIS);}

{whitespace}               {}
{error}                    {}

%%