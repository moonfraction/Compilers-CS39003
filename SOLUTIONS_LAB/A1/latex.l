bplist00�[OSType-DataXUTI-Data�POhttps://cse.iitkgp.ac.in�	
_public.utf16-plain-text[public.html_$com.apple.traditional-mac-plain-text_public.utf8-plain-textO% {  # d e f i n e   C M D   1  # d e f i n e   E N V   2  # d e f i n e   M T H   3  # d e f i n e   D S P   4  # d e f i n e   O T H   5   i n t   m t h   =   0 ,   d s p   =   0 ,   e n v   =   0 ;  % }   s p a c e 	 [   \ t \ n ]  s p a c e s 	 { s p a c e } +  l e t t e r 	 [ a - z A - Z ]  a c t i v e 	 [ ~ ]  b s 	 [ \ \ ]  o t h e r 	 [ ^ a - z A - Z ~ ]  n o c m d 	 [ ^ \ \ ~ \ $ % ] +  b e n v 	 \ \ b e g i n { s p a c e } * \ { { l e t t e r } + \ }  e e n v 	 \ \ e n d { s p a c e } * \ { { l e t t e r } + \ }  c m d 	 { b s } ( { o t h e r } | ( { l e t t e r } ) + )  b c m t 	 " % "  c m t 	 { b c m t } . *  d l r 	 " $ "  d d l r 	 " $ $ "   % %   { c m t } 	 	 {   }  { n o c m d } 	 	 {   }  { d l r } 	 	 {   m t h   =   1   -   m t h ;   r e t u r n ( M T H ) ;   }  { d d l r } 	 	 {   d s p   =   1   -   d s p ;   r e t u r n ( D S P ) ;   }  " \ \ \ [ " 	 	 {   d s p   =   1 ;   r e t u r n ( D S P ) ;   }  " \ \ \ ] " 	 	 {   d s p   =   0 ;   r e t u r n ( D S P ) ;   }  { b e n v } 	 	 {   e n v   =   1 ;   r e t u r n ( E N V ) ;   }  { e e n v } 	 	 {   e n v   =   0 ;   r e t u r n ( E N V ) ;   }  { c m d } 	 	 {   r e t u r n ( C M D ) ;   }  { a c t i v e } 	 {   r e t u r n ( C M D ) ;   }   % %  O�<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"><pre style="color: rgb(255, 255, 255); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; overflow-wrap: break-word; white-space: pre-wrap;">%{
#define CMD 1
#define ENV 2
#define MTH 3
#define DSP 4
#define OTH 5

int mth = 0, dsp = 0, env = 0;
%}

space	[ \t\n]
spaces	{space}+
letter	[a-zA-Z]
active	[~]
bs	[\\]
other	[^a-zA-Z~]
nocmd	[^\\~\$%]+
benv	\\begin{space}*\{{letter}+\}
eenv	\\end{space}*\{{letter}+\}
cmd	{bs}({other}|({letter})+)
bcmt	"%"
cmt	{bcmt}.*
dlr	"$"
ddlr	"$$"

%%

{cmt}		{ }
{nocmd}		{ }
{dlr}		{ mth = 1 - mth; return(MTH); }
{ddlr}		{ dsp = 1 - dsp; return(DSP); }
"\\\["		{ dsp = 1; return(DSP); }
"\\\]"		{ dsp = 0; return(DSP); }
{benv}		{ env = 1; return(ENV); }
{eenv}		{ env = 0; return(ENV); }
{cmd}		{ return(CMD); }
{active}	{ return(CMD); }

%%
</pre><br class="Apple-interchange-newline">O�%{#define CMD 1#define ENV 2#define MTH 3#define DSP 4#define OTH 5int mth = 0, dsp = 0, env = 0;%}space	[ \t\n]spaces	{space}+letter	[a-zA-Z]active	[~]bs	[\\]other	[^a-zA-Z~]nocmd	[^\\~\$%]+benv	\\begin{space}*\{{letter}+\}eenv	\\end{space}*\{{letter}+\}cmd	{bs}({other}|({letter})+)bcmt	"%"cmt	{bcmt}.*dlr	"$"ddlr	"$$"%%{cmt}		{ }{nocmd}		{ }{dlr}		{ mth = 1 - mth; return(MTH); }{ddlr}		{ dsp = 1 - dsp; return(DSP); }"\\\["		{ dsp = 1; return(DSP); }"\\\]"		{ dsp = 0; return(DSP); }{benv}		{ env = 1; return(ENV); }{eenv}		{ env = 0; return(ENV); }{cmd}		{ return(CMD); }{active}	{ return(CMD); }%%_�%{
#define CMD 1
#define ENV 2
#define MTH 3
#define DSP 4
#define OTH 5

int mth = 0, dsp = 0, env = 0;
%}

space	[ \t\n]
spaces	{space}+
letter	[a-zA-Z]
active	[~]
bs	[\\]
other	[^a-zA-Z~]
nocmd	[^\\~\$%]+
benv	\\begin{space}*\{{letter}+\}
eenv	\\end{space}*\{{letter}+\}
cmd	{bs}({other}|({letter})+)
bcmt	"%"
cmt	{bcmt}.*
dlr	"$"
ddlr	"$$"

%%

{cmt}		{ }
{nocmd}		{ }
{dlr}		{ mth = 1 - mth; return(MTH); }
{ddlr}		{ dsp = 1 - dsp; return(DSP); }
"\\\["		{ dsp = 1; return(DSP); }
"\\\]"		{ dsp = 0; return(DSP); }
{benv}		{ env = 1; return(ENV); }
{eenv}		{ env = 0; return(ENV); }
{cmd}		{ return(CMD); }
{active}	{ return(CMD); }

%%
    " % & A J d p � ��
h�                           t