%{
    #include<bits/stdc++.h>
    using namespace std;
    int yylex();
    void yyerror(char* s);
    extern char* yytext;
    extern int yylineno;

    struct symboltable{
        public:
        char* id;
        int val;
        symboltable* next;
        symboltable(char* f, int v=0) : val(v), next(nullptr){
            id = strdup(f);
        }
    };

    typedef struct _exprtree{
        int t; // type 1 -> NUM , 2 -> ID , 3 -> OP
        union{
            int val;
            char* id;
            typedef struct {
                int op;
                struct _exprtree* left;
                struct _exprtree* right;
            } opnode;
            opnode opn;
        } data;
    } exprtree;

    symboltable* updateSymbolTable(symboltable* head, char* idx, int v);
    int getFromSymbolTable(symboltable* head, char* idx);
    int calculateExpr(int op, int val1, int val2);
    symboltable* head = nullptr;

    exprtree* createNumNode(int val);
    exprtree* createIdNode(char* idx);
    exprtree* createOpNode(int op, exprtree* left, exprtree* right);
    int evalExprtree(exprtree* root, symboltable* head);
%}

%union {
    int val;
    char* id;
    exprtree* node;
}

%start PROGRAM
%token SET PLUS MINUS MULTIPLY DIVIDE MODULO EXP LP RP
%token <val> NUM
%token <id> ID
%type  <node> EXPR ARG 
%type  <val> STMT SETSTMT OP EXPRSTMT

%%
    PROGRAM : STMT PROGRAM {;}
            | STMT         {;}
            ;

    STMT    : SETSTMT 
            | EXPRSTMT {cout<<"Standalone expression evaluates to "<<$1<<endl;}
            ;
            
    SETSTMT : LP SET ID NUM RP  {head = updateSymbolTable(head, $3, $4); cout<<"Variable "<<$3<<" is set to "<<$4<<endl;}
            | LP SET ID ID RP   {head = updateSymbolTable(head, $3, getFromSymbolTable(head, $4)); cout<<"Variable "<<$3<<" is set to "<<getFromSymbolTable(head, $4)<<endl;}
            | LP SET ID EXPR RP {head = updateSymbolTable(head, $3, evalExprtree($4,head)); cout<<"Variable "<<$3<<" is set to "<<evalExprtree($4,head)<<endl;}
            ;

    EXPRSTMT: EXPR {$$ = evalExprtree($1,head);}
            ;
    
    EXPR    : LP OP ARG ARG RP {$$ = createOpNode($2, $3, $4);}
            ;
    
    OP      : PLUS  {$$ = 1;}
            | MINUS {$$ = 2;}
            | MULTIPLY {$$ = 3;}
            | DIVIDE {$$ = 4;} 
            | MODULO {$$ = 5;}
            | EXP    {$$ = 6;}
            ;

    ARG     : ID {$$ = createIdNode($1);}
            | NUM {$$ = createNumNode($1);}  
            | EXPR {$$ = $1;}
            ;
    
%%

void yyerror(char* s){
    fprintf(stderr, "%s\n",s);
}