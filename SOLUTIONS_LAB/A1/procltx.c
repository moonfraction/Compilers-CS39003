bplist00�[OSType-DataXUTI-Data�POhttps://cse.iitkgp.ac.in�	
_public.utf16-plain-text[public.html_$com.apple.traditional-mac-plain-text_public.utf8-plain-textOX# i n c l u d e   < s t d i o . h >  # i n c l u d e   < s t d l i b . h >  # i n c l u d e   < s t r i n g . h >  # i n c l u d e   " l e x . y y . c "   t y p e d e f   s t r u c t   _ n o d e   {        c h a r   * n a m e ;        i n t   n o c c ;        s t r u c t   _ n o d e   * n e x t ;  }   n o d e ;  t y p e d e f   n o d e   * n a m e t a b l e ;   n a m e t a b l e   a d d t b l   (   n a m e t a b l e   T ,   c h a r   * i d   )  {        n o d e   * p ;         p   =   T ;        w h i l e   ( p )   {              i f   ( ! s t r c m p ( p - > n a m e , i d ) )   {                    + + ( p   - >   n o c c ) ;                    r e t u r n   T ;              }              p   =   p   - >   n e x t ;        }        p   =   ( n o d e   * ) m a l l o c ( s i z e o f ( n o d e ) ) ;        p   - >   n a m e   =   ( c h a r   * ) m a l l o c ( ( s t r l e n ( i d ) + 1 )   *   s i z e o f ( c h a r ) ) ;        s t r c p y ( p   - >   n a m e ,   i d ) ;        p   - >   n o c c   =   1 ;        p   - >   n e x t   =   T ;        r e t u r n   p ;  }   n a m e t a b l e   a d d e n v   (   n a m e t a b l e   T ,   c h a r   * i d   )  {        c h a r   * s ,   * e ;         s   =   s t r c h r ( i d ,   ' { ' ) ;        e   =   s t r c h r ( i d ,   ' } ' ) ;        * e   =   ' \ 0 ' ;        r e t u r n   a d d t b l ( T , s + 1 ) ;  }   v o i d   p r n n a m e s   (   n a m e t a b l e   T   )  {        i f   ( T   = =   N U L L )   r e t u r n ;        p r n n a m e s ( T   - >   n e x t ) ;        p r i n t f ( " \ t % s   ( % d ) \ n " ,   T   - >   n a m e ,   T   - >   n o c c ) ;  }   i n t   m a i n   ( )  {        i n t   n e x t t o k ;        i n t   n m t h   =   0 ,   n d s p   =   0 ;        n a m e t a b l e   C T   =   N U L L ,   E T   =   N U L L ;         w h i l e   ( ( n e x t t o k   =   y y l e x ( ) ) )   {              s w i t c h   ( n e x t t o k )   {                    c a s e   M T H :   n m t h   + =   m t h ;   b r e a k ;                    c a s e   D S P :   n d s p   + =   d s p ;   b r e a k ;                    c a s e   E N V :   i f   ( e n v )   E T   =   a d d e n v ( E T , y y t e x t ) ;   b r e a k ;                    c a s e   C M D :   C T   =   a d d t b l ( C T , y y t e x t ) ;   b r e a k ;                    d e f a u l t :   p r i n t f ( " U n k n o w n   t o k e n \ n " ) ;   b r e a k ;              }        }         p r i n t f ( " C o m m a n d s   u s e d : \ n " ) ;   p r n n a m e s ( C T ) ;        p r i n t f ( " E n v i r o n m e n t s   u s e d : \ n " ) ;   p r n n a m e s ( E T ) ;        p r i n t f ( " % d   m a t h   e q u a t i o n s   f o u n d \ n " ,   n m t h ) ;        p r i n t f ( " % d   d i s p l a y e d   e q u a t i o n s   f o u n d \ n " ,   n d s p ) ;         e x i t ( 0 ) ;  } O�<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"><pre style="color: rgb(255, 255, 255); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; overflow-wrap: break-word; white-space: pre-wrap;">#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;string.h&gt;
#include "lex.yy.c"

typedef struct _node {
   char *name;
   int nocc;
   struct _node *next;
} node;
typedef node *nametable;

nametable addtbl ( nametable T, char *id )
{
   node *p;

   p = T;
   while (p) {
      if (!strcmp(p-&gt;name,id)) {
         ++(p -&gt; nocc);
         return T;
      }
      p = p -&gt; next;
   }
   p = (node *)malloc(sizeof(node));
   p -&gt; name = (char *)malloc((strlen(id)+1) * sizeof(char));
   strcpy(p -&gt; name, id);
   p -&gt; nocc = 1;
   p -&gt; next = T;
   return p;
}

nametable addenv ( nametable T, char *id )
{
   char *s, *e;

   s = strchr(id, '{');
   e = strchr(id, '}');
   *e = '\0';
   return addtbl(T,s+1);
}

void prnnames ( nametable T )
{
   if (T == NULL) return;
   prnnames(T -&gt; next);
   printf("\t%s (%d)\n", T -&gt; name, T -&gt; nocc);
}

int main ()
{
   int nexttok;
   int nmth = 0, ndsp = 0;
   nametable CT = NULL, ET = NULL;

   while ((nexttok = yylex())) {
      switch (nexttok) {
         case MTH: nmth += mth; break;
         case DSP: ndsp += dsp; break;
         case ENV: if (env) ET = addenv(ET,yytext); break;
         case CMD: CT = addtbl(CT,yytext); break;
         default: printf("Unknown token\n"); break;
      }
   }

   printf("Commands used:\n"); prnnames(CT);
   printf("Environments used:\n"); prnnames(ET);
   printf("%d math equations found\n", nmth);
   printf("%d displayed equations found\n", ndsp);

   exit(0);
}</pre>O�#include <stdio.h>#include <stdlib.h>#include <string.h>#include "lex.yy.c"typedef struct _node {   char *name;   int nocc;   struct _node *next;} node;typedef node *nametable;nametable addtbl ( nametable T, char *id ){   node *p;   p = T;   while (p) {      if (!strcmp(p->name,id)) {         ++(p -> nocc);         return T;      }      p = p -> next;   }   p = (node *)malloc(sizeof(node));   p -> name = (char *)malloc((strlen(id)+1) * sizeof(char));   strcpy(p -> name, id);   p -> nocc = 1;   p -> next = T;   return p;}nametable addenv ( nametable T, char *id ){   char *s, *e;   s = strchr(id, '{');   e = strchr(id, '}');   *e = '\0';   return addtbl(T,s+1);}void prnnames ( nametable T ){   if (T == NULL) return;   prnnames(T -> next);   printf("\t%s (%d)\n", T -> name, T -> nocc);}int main (){   int nexttok;   int nmth = 0, ndsp = 0;   nametable CT = NULL, ET = NULL;   while ((nexttok = yylex())) {      switch (nexttok) {         case MTH: nmth += mth; break;         case DSP: ndsp += dsp; break;         case ENV: if (env) ET = addenv(ET,yytext); break;         case CMD: CT = addtbl(CT,yytext); break;         default: printf("Unknown token\n"); break;      }   }   printf("Commands used:\n"); prnnames(CT);   printf("Environments used:\n"); prnnames(ET);   printf("%d math equations found\n", nmth);   printf("%d displayed equations found\n", ndsp);   exit(0);}_�#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"

typedef struct _node {
   char *name;
   int nocc;
   struct _node *next;
} node;
typedef node *nametable;

nametable addtbl ( nametable T, char *id )
{
   node *p;

   p = T;
   while (p) {
      if (!strcmp(p->name,id)) {
         ++(p -> nocc);
         return T;
      }
      p = p -> next;
   }
   p = (node *)malloc(sizeof(node));
   p -> name = (char *)malloc((strlen(id)+1) * sizeof(char));
   strcpy(p -> name, id);
   p -> nocc = 1;
   p -> next = T;
   return p;
}

nametable addenv ( nametable T, char *id )
{
   char *s, *e;

   s = strchr(id, '{');
   e = strchr(id, '}');
   *e = '\0';
   return addtbl(T,s+1);
}

void prnnames ( nametable T )
{
   if (T == NULL) return;
   prnnames(T -> next);
   printf("\t%s (%d)\n", T -> name, T -> nocc);
}

int main ()
{
   int nexttok;
   int nmth = 0, ndsp = 0;
   nametable CT = NULL, ET = NULL;

   while ((nexttok = yylex())) {
      switch (nexttok) {
         case MTH: nmth += mth; break;
         case DSP: ndsp += dsp; break;
         case ENV: if (env) ET = addenv(ET,yytext); break;
         case CMD: CT = addtbl(CT,yytext); break;
         default: printf("Unknown token\n"); break;
      }
   }

   printf("Commands used:\n"); prnnames(CT);
   printf("Environments used:\n"); prnnames(ET);
   printf("%d math equations found\n", nmth);
   printf("%d displayed equations found\n", ndsp);

   exit(0);
}    " % & A J d p � ���                           P