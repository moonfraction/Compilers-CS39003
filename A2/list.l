%{
    #define LP 1
    #define RP 2
    #define OP 3
    #define NUM 4
    #define ID 5
    #define WS 6
    #define ERR 7
%}

lp \(
rp \)
op [+\-*/%]
num [-]?[0-9]+
id [a-zA-Z][a-zA-Z0-9]*
ws [ \t\n]
err .

%option noyywrap

%%
{lp} {return(LP);}
{rp} {return(RP);}
{op} {return(OP);}
{num} {return(NUM);}
{id} {return(ID);}
{ws} {return(WS);}
{err} {return(ERR);}

%%