%{
#define SINGLE_CMD 1
#define STR_CMD 2
#define ACTIVE 3
#define TEXT 4
#define WS 5
#define MATH_EQ 6
#define DISP_EQ 7
#define CMMT 8
#define ENV 9
%}

comment %.*\n
single \\.
str \\[a-zA-Z]+
text .
space [ \t\n]
ws {space}+
env \\begin\{([a-zA-Z]+)\} 

%option noyywrap


%%
{comment} 	{return(CMMT); }
\\"["        {return(DISP_EQ);}
\\"]"        {return(DISP_EQ);}
{single}	{return(SINGLE_CMD); }
{str}		{return(STR_CMD); }
"~"         {return(ACTIVE); }
"$"         {return(MATH_EQ);}
"$$"        {return(DISP_EQ);}
{text}      {return(TEXT);}
{ws}        {return(WS);}
{env}       {return(ENV);}

%%