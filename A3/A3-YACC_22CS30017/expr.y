%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdarg.h> 
    #include <ctype.h>

    typedef struct _node{
        int type;
        char* id;
        bool valDefined; // true if value of ID is defined
        int val;
        struct _node* next;
    }node;
    typedef node* symboltable;
    symboltable st = NULL;
    symboltable findID(symboltable T, char* id);
    symboltable findNUM(symboltable T, int val);
    symboltable insertID(symboltable T, char* id);
    symboltable insertNUM(symboltable T, int val);
    void updateSymbolVal(symboltable T, char* id, int val);
    
    typedef struct _treenode{
        int type;
        symboltable T;
        struct _treenode *left, *right;
    } treenode;
    // treenode* createNode(int type, symboltable T = NULL, treenode* left = NULL, treenode* right = NULL);
    treenode* createLeafNode(int type, symboltable T);
    treenode* createInternalNode(int type, treenode* left, treenode* right);
    int eval(treenode* root);
    void deleteTree(treenode* root);
    void printTree (treenode* root, int level=0); // auxiliary function to print the tree

    int yylex();
    void yyerror(const char *fmt, ...);
    extern char* yytext;
    extern int yylineno;
%}

%union {
    int num;
    char* id;
    treenode* node;
}
%start PROGRAM 
%token <num> NUM 
%token <id> ID 
%token set
%token plus minus mul dvd mod pwr
%type <num> OP
%type <id> STMT SETSTMT EXPRSTMT
%type <node> ARG EXPR


%%
PROGRAM: STMT PROGRAM | STMT;
STMT: SETSTMT | EXPRSTMT;
SETSTMT: '(' set ID NUM ')' {
                st = insertNUM(st, $4);
                st = insertID(st, $3);
                updateSymbolVal(st, $3, $4);
                printf("Set %s to %d\n", $3, $4);
            } 
        | '(' set ID ID ')' {
                st = insertID(st, $3);
                symboltable tmp = findID(st, $4);
                if(tmp == NULL){
                    yyerror("ID '%s' not found", $4);
                }
                updateSymbolVal(st, $3, tmp->val);
                printf("Set %s to %d\n", $3, tmp->val);
            } 
        | '(' set ID EXPR ')' {
                st = insertID(st, $3);
                int valE = eval($4);
                deleteTree($4);
                updateSymbolVal(st, $3, valE);
                printf("Set %s to %d\n", $3, valE);
                // printTree($4);
            }
        ;
EXPRSTMT: EXPR {
            printf("Standalone expression evalutes to %d\n", eval($1));
            deleteTree($1);
            // printTree($1) ;
        }
    ;
EXPR: '(' OP ARG ARG ')' { $$ = createInternalNode($2, $3, $4);} ;
OP: plus {$$ = plus;}
    | minus {$$ = minus;}
    | mul {$$ = mul;}
    | dvd {$$ = dvd;}
    | mod {$$ = mod;}
    | pwr {$$ = pwr;}
    ;
ARG: ID { 
            symboltable tmp = findID(st, $1);
            if(tmp == NULL){
                yyerror("ID '%s' not found", $1);
            }
            treenode* node = createLeafNode(ID, tmp);
            $$ = node;
        }
    | NUM { 
            symboltable tmp = findNUM(st, $1);
            if(tmp == NULL) {
                st = insertNUM(st, $1);
                tmp = st;
            }
            treenode* node = createLeafNode(NUM, tmp);
            $$ = node;
        }
    | EXPR { $$ = $1; }
    ;


%%
void yyerror(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    fprintf(stderr, "ERROR: ");
    vfprintf(stderr, fmt, args); 
    fprintf(stderr, "\n");
    va_end(args);
    // Exit with status code 0 to avoid make error
    exit(0); 
}
