%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    extern int yyparse();
    extern void yyerror(const char *s);

    typedef struct _tree_node{
        int inh, val, size;
        char* type;
        struct _tree_node **children;
    } tree_node;

    typedef struct _tree_node* tree;
    tree PT;
    int const_poly = 1;

    void add_node(tree, tree);
    tree create_node(int, int, char*);
    void print_tree(tree, int);
    void setatt(tree);
    int evalpoly(tree, int);
    void printderivative(tree);

%}

%union {
    int intval;
    struct _tree_node* node;
}

%start s
%token <intval> D
%token X EXP_SYM ZERO ONE PLUS MINUS
%type <node> s p t n m x

%%
s: p {
        tree temp = create_node(0, 0, "s");
        add_node(temp, $1);
        PT = temp;
    }
    | PLUS p {
        tree temp = create_node(0, 0, "s");
        tree node1 = create_node(0, 0, "+");
        add_node(temp, node1); add_node(temp, $2);
        PT = temp;

    }
    | MINUS p {
        tree temp = create_node(0, 0, "s");
        tree node1 = create_node(0, 0, "-");
        add_node(temp, node1); add_node(temp, $2);
        PT = temp;
    }
    ;

p: t {
        tree temp = create_node(0, 0, "p");
        add_node(temp, $1);
        $$ = temp;
    }
    | t PLUS p {
        tree temp = create_node(0, 0, "p");
        tree node1 = create_node(0, 0, "+");
        add_node(temp, $1); add_node(temp, node1); add_node(temp, $3);
        $$ = temp;
    }
    | t MINUS p {
        tree temp = create_node(0, 0, "p");
        tree node1 = create_node(0, 0, "-");
        add_node(temp, $1); add_node(temp, node1); add_node(temp, $3);
        $$ = temp;
    }
    ;

t: ONE {
        tree temp = create_node(0, 0, "t");
        tree node = create_node(0, 1, "1");
        add_node(temp, node);
        $$ = temp;
    }
    | n{
        tree temp = create_node(0, 0, "t");
        add_node(temp, $1);
        $$ = temp;
    }
    | x{
        tree temp = create_node(0, 0, "t");
        add_node(temp, $1);
        $$ = temp;
    }
    | n x{
        tree temp = create_node(0, 0, "t");
        add_node(temp, $1); add_node(temp, $2);
        $$ = temp;
    }
    ;

x: X{
        tree temp = create_node(0, 0, "X");
        tree node = create_node(0, 0, "x");
        add_node(temp, node);
        $$ = temp;
    }
    | X EXP_SYM n{
        tree temp = create_node(0, 0, "X");
        tree node1 = create_node(0, 0, "x");
        tree node2 = create_node(0, 0, "^");
        add_node(temp, node1); add_node(temp, node2); add_node(temp, $3);
        $$ = temp;
    }
    ;

n: D{
        tree temp = create_node(0, 0, "n");
        tree node = create_node(0, $1, "D");
        add_node(temp, node);
        $$ = temp;
    }
    | ONE m{
        tree temp = create_node(0, 0, "n");
        tree node1 = create_node(0, 1, "1");
        add_node(temp, node1); add_node(temp, $2);
        $$ = temp;
    }
    | D m{
        tree temp = create_node(0, 0, "n");
        tree node1 = create_node(0, $1, "D");
        add_node(temp, node1); add_node(temp, $2);
        $$ = temp;
    }
    ;

m: ZERO{
        tree temp = create_node(0, 0, "m");
        tree node = create_node(0, 0, "0");
        add_node(temp, node);
        $$ = temp;
    }
    | ONE {
        tree temp = create_node(0, 0, "m");
        tree node = create_node(0, 1, "1");
        add_node(temp, node);
        $$ = temp;
    }
    | D{
        tree temp = create_node(0, 0, "m");
        tree node = create_node(0, $1, "D");
        add_node(temp, node);
        $$ = temp;
    }
    | ZERO m{
        tree temp = create_node(0, 0, "m");
        tree node1 = create_node(0, 0, "0");
        add_node(temp, node1); add_node(temp, $2);
        $$ = temp;
    }
    | ONE m{
        tree temp = create_node(0, 0, "m");
        tree node1 = create_node(0, 1, "1");
        add_node(temp, node1); add_node(temp, $2);
        $$ = temp;
    }
    | D m{
        tree temp = create_node(0, 0, "m");
        tree node1 = create_node(0, $1, "D");
        add_node(temp, node1); add_node(temp, $2);
        $$ = temp;
    }
    ;

%%

void yyerror(const char *s){
    fprintf(stderr, "ERROR: %s\n", s);
    exit(0);
}