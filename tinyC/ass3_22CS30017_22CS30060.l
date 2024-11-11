%{
    #define KW 1
    #define ID 2
    #define CONST 3
    #define STRL 4
    #define PUNC 5
    #define CMMT_SL 6
    #define CMMT_ML 7
    #define WS 8
    #define ERR 9
%}

comment_start              "/*"
comment_end                "*/"
comment_line               "//"
comment_body               ([^*]|[*][^/])*
comment_single_line        ({comment_line}.*\n)
comment_multi_line         ({comment_start}{comment_body}{comment_end})

keyword                    (auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|_Bool|_Complex|_Imaginary)
identifier_nondigit        [a-zA-Z_]
digit                      [0-9]
identifier                 {identifier_nondigit}({identifier_nondigit}|{digit})*

sign                       [+-]
escape_sequence            (\\(['"?\\abfnrtv]))
c_char                     [^'\\\n]|{escape_sequence}
c_char_sequence            {c_char}+
character_constant         '{c_char_sequence}'

digit_sequence             {digit}+
exponential_part           [eE]{sign}?{digit_sequence}
fractional_constant        {digit_sequence}?\.{digit_sequence}|{digit_sequence}\.
floating_constant          ({fractional_constant}{exponential_part}?|{digit_sequence}{exponential_part})
integer_constant           {digit_sequence}
constant                   {integer_constant}|{floating_constant}|{character_constant}

s_char                     [^"\\\n]|{escape_sequence}
s_char_sequence            {s_char}+
string_literal             \"{s_char_sequence}?\"

whitespace                 [ \t\n]
error                      .

%option noyywrap

%%
{comment_single_line}      {}
{comment_multi_line}       {}


{keyword}                  {return(KW);}
{identifier}               {return(ID);}
{constant}                 {return(CONST);}
{string_literal}           {return(STRL);}
{punctuator}               {return(PUNC);}
{whitespace}               {return(WS);}
{error}                    {return(ERR);}

%%