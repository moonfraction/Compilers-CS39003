%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    extern int yyparse();
    extern void yyerror(const char *s);
    typedef struct _tree_node{
        union{
            int int_value;
            float float_value;
            char *name;
            char character;
        }u;
        int type; // 0: int, 1: float, 2: name, 3: character
        int size;
        struct _tree_node ** adj_list;
    }tree_node;
    typedef tree_node* tree;
    
    void add_node(tree parent, tree child);
    tree create_node_int(int value);
    tree create_node_float(float value);
    tree create_node_name(char *name);
    tree create_node_char(char character);
    void print_tree(tree root, int depth);




%}
%union{
    int int_value;
    float float_value;
    char *name;
    char character;
    struct _tree_node* node;
}

%start global_start
%token <name> IDENTIFIER STRING_LITERAL STORAGE_KEYWORD TYPE_SP_KEYWORD TYPE_QF_KEYWORD
%token <int_value> INTEGER_CONSTANT
%token <float_value> FLOATING_CONSTANT
%token <character> CHARACTER_CONSTANT
%token LP RP LBRACKET RBRACKET DOT ARROW INC_OP DEC_OP LB RB COMMA AND_OP MUL_OP ADD_OP SUB_OP BITWISE_NOT_OP LOGICAL_NOT_OP DIV_OP MOD_OP LEFT_OP RIGHT_OP LT GT LTE GTE EQ NEQ XOR_OP OR_OP LOGICAL_AND_OP LOGICAL_OR_OP QUES_MARK COLON ASSN_EQ MUL_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ LEFT_EQ RIGHT_EQ AND_EQ XOR_EQ OR_EQ SEMI ELLIPSIS
%token SIZEOF INLINE STATIC CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%nonassoc RP
%nonassoc ELSE

%type<node> primary_expression constant postfix_expression argument_expression_list unary_expression unary_operator cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression and_expression exclusive_or_expression inclusive_or_expression logical_and_expression logical_or_expression conditional_expression assignment_expression assignment_operator expression constant_expression declaration declaration_specifiers init_declarator_list init_declarator storage_class_specifier type_specifier specifier_qualifier_list type_qualifier function_specifier declarator direct_declarator pointer type_qualifier_list parameter_type_list parameter_list parameter_declaration identifier_list type_name initializer initializer_list designation designator designator_list statement labeled_statement compound_statement block_item_list block_item expression_statement selection_statement iteration_statement jump_statement translation_unit external_declaration function_definition declaration_list

%%
primary_expression: IDENTIFIER {
            tree temp = create_node_name("primary_expression");
            tree node1 = create_node_name($1);
            add_node(temp, node1); $$ = temp;
        } 
        | constant{
            tree temp = create_node_name("primary_expression");
            add_node(temp, $1); $$ = temp;
        }
        | STRING_LITERAL{
            tree temp = create_node_name("primary_expression");
            tree node1 = create_node_name($1);
            add_node(temp, node1); $$ = temp;
        }
        | LP expression RP{
            tree temp = create_node_name("primary_expression");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');

            add_node(temp, $2); add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        ;

constant: INTEGER_CONSTANT { $$ = create_node_int($1); }
        | FLOATING_CONSTANT { $$ = create_node_float($1); }
        | CHARACTER_CONSTANT { $$ = create_node_char($1); }
        ;

postfix_expression: primary_expression{
            tree temp = create_node_name("postfix_expression");
            add_node(temp, $1); $$ = temp;
        }
        | postfix_expression LBRACKET expression RBRACKET{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); $$ = temp;
        }

        | postfix_expression LP RP{
            tree temp = create_node_name("postfix_expression");
            tree  node1 = create_node_name("()");
            add_node(temp, $1); add_node(temp, node1); $$ = temp;
        }
        | postfix_expression LP argument_expression_list RP{
            tree  temp = create_node_name("postfix_expression");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); $$ = temp;
        }
        | postfix_expression DOT IDENTIFIER{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_char('.');
            tree node2 = create_node_name($3);
            add_node(temp, $1); add_node(temp, node1); $$ = temp;
        }
        | postfix_expression ARROW IDENTIFIER{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_name("->");
            tree node2 = create_node_name($3);
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | postfix_expression INC_OP{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_name("++");
            add_node(temp, $1); add_node(temp, node1); $$ = temp;
        }
        | postfix_expression DEC_OP{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_name("--");
            add_node(temp, $1); add_node(temp, node1); $$ = temp;
        }
        | LP type_name RP LB initializer_list RB{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            tree node3 = create_node_char('{');
            tree node4 = create_node_char('}');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); 
            add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); $$ = temp;
        }
        | LP type_name RP LB initializer_list COMMA RB{
            tree temp = create_node_name("postfix_expression");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            tree node3 = create_node_char('{');
            tree node4 = create_node_char(',');
            tree node5 = create_node_char('}');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); 
            add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); add_node(temp, node5); $$ = temp;
        }
        ;

argument_expression_list: assignment_expression{
            tree temp = create_node_name("argument_expression_list");
            add_node(temp, $1); $$ = temp;
        }
        | argument_expression_list COMMA assignment_expression{
            tree temp = create_node_name("argument_expression_list");
            tree node = create_node_char(',');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

unary_expression: postfix_expression{
            tree temp = create_node_name("unary_expression");
            add_node(temp, $1); $$ = temp;
        }
        | INC_OP unary_expression{
            tree temp = create_node_name("unary_expression");
            tree node = create_node_name("++");
            add_node(temp, $2); add_node(temp, node); $$ = temp;
        }
        | DEC_OP unary_expression{
            tree temp = create_node_name("unary_expression");
            tree node = create_node_name("--");
            add_node(temp, $2); add_node(temp, node); $$ = temp;
        }
        | unary_operator cast_expression{
            tree temp = create_node_name("unary_expression");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | SIZEOF unary_expression{
            tree temp = create_node_name("unary_expression");
            tree node = create_node_name("sizeof");
            add_node(temp, node); add_node(temp, $2); $$ = temp;
        }
        | SIZEOF LP type_name RP{
            tree temp = create_node_name("unary_expression");
            tree node1 = create_node_name("sizeof");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); $$ = temp;
        }
        ;

unary_operator: AND_OP{
            tree temp = create_node_name("unary_operator");
            tree node = create_node_char('&');
            add_node(temp, node); $$ = temp;
        }
        | MUL_OP{
            tree temp = create_node_name("unary_operator");
            tree node = create_node_char('*');
            add_node(temp, node); $$ = temp;
        }
        | ADD_OP{
            tree temp = create_node_name("unary_operator");
            tree node = create_node_char('+');
            add_node(temp, node); $$ = temp;
        }
        | SUB_OP{
            tree temp = create_node_name("unary_operator");
            tree node = create_node_char('-');
            add_node(temp, node); $$ = temp;
        }
        | BITWISE_NOT_OP{
            tree temp = create_node_name("unary_operator");
            tree node = create_node_char('~');
            add_node(temp, node); $$ = temp;
        }
        | LOGICAL_NOT_OP{
            tree temp = create_node_name("unary_operator");
            tree node = create_node_char('!');
            add_node(temp, node); $$ = temp;
        }
        ;

cast_expression: unary_expression{
            tree temp = create_node_name("cast_expression");
            add_node(temp, $1); $$ = temp;
        }
        | LP type_name RP cast_expression{
            tree temp = create_node_name("cast_expression");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); add_node(temp, $4); $$ = temp;
        }
        ;

multiplicative_expression: cast_expression{
            tree temp = create_node_name("multiplicative_expression");
            add_node(temp, $1); $$ = temp;
        }
        | multiplicative_expression MUL_OP cast_expression{
            tree temp = create_node_name("multiplicative_expression");
            tree node = create_node_char('*');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | multiplicative_expression DIV_OP cast_expression{
            tree temp = create_node_name("multiplicative_expression");
            tree node = create_node_char('/');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | multiplicative_expression MOD_OP cast_expression{
            tree temp = create_node_name("multiplicative_expression");
            tree node = create_node_char('%');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

additive_expression: multiplicative_expression{
            tree temp = create_node_name("additive_expression");
            add_node(temp, $1); $$ = temp;
        }
        | additive_expression ADD_OP multiplicative_expression{
            tree temp = create_node_name("additive_expression");
            tree node = create_node_char('+');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | additive_expression SUB_OP multiplicative_expression{
            tree temp = create_node_name("additive_expression");
            tree node = create_node_char('-');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

shift_expression: additive_expression{
            tree temp = create_node_name("shift_expression");
            add_node(temp, $1); $$ = temp;
        }
        | shift_expression LEFT_OP additive_expression{
            tree temp = create_node_name("shift_expression");
            tree node = create_node_name("<<");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | shift_expression RIGHT_OP additive_expression{
            tree temp = create_node_name("shift_expression");
            tree node = create_node_name(">>");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

relational_expression: shift_expression{
            tree temp = create_node_name("relational_expression");
            add_node(temp, $1); $$ = temp;
        }
        | relational_expression LT shift_expression{
            tree temp = create_node_name("relational_expression");
            tree node = create_node_char('<');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | relational_expression GT shift_expression{
            tree temp = create_node_name("relational_expression");
            tree node = create_node_char('>');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | relational_expression LTE shift_expression{
            tree temp = create_node_name("relational_expression");
            tree node = create_node_name("<=");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | relational_expression GTE shift_expression{
            tree temp = create_node_name("relational_expression");
            tree node = create_node_name(">=");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

equality_expression: relational_expression{
            tree temp = create_node_name("equality_expression");
            add_node(temp, $1); $$ = temp;
        }
        | equality_expression EQ relational_expression{
            tree temp = create_node_name("equality_expression");
            tree node = create_node_name("==");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | equality_expression NEQ relational_expression{
            tree temp = create_node_name("equality_expression");
            tree node = create_node_name("!=");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

and_expression: equality_expression{
            tree temp = create_node_name("and_expression");
            add_node(temp, $1); $$ = temp;
        }
        | and_expression AND_OP equality_expression{
            tree temp = create_node_name("and_expression");
            tree node = create_node_char('&');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

exclusive_or_expression: and_expression{
            tree temp = create_node_name("exclusive_or_expression");
            add_node(temp, $1); $$ = temp;
        }
        | exclusive_or_expression XOR_OP and_expression{
            tree temp = create_node_name("exclusive_or_expression");
            tree node = create_node_char('^');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

inclusive_or_expression: exclusive_or_expression{
            tree temp = create_node_name("inclusive_or_expression");
            add_node(temp, $1); $$ = temp;
        }
        | inclusive_or_expression OR_OP exclusive_or_expression{
            tree temp = create_node_name("inclusive_or_expression");
            tree node = create_node_char('|');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

logical_and_expression: inclusive_or_expression{
            tree temp = create_node_name("logical_and_expression");
            add_node(temp, $1); $$ = temp;
        }
        | logical_and_expression LOGICAL_AND_OP inclusive_or_expression{
            tree temp = create_node_name("logical_and_expression");
            tree node = create_node_name("&&");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

logical_or_expression: logical_and_expression{
            tree temp = create_node_name("logical_or_expression");
            add_node(temp, $1); $$ = temp;
        }
        | logical_or_expression LOGICAL_OR_OP logical_and_expression{
            tree temp = create_node_name("logical_or_expression");
            tree node = create_node_name("||");
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

conditional_expression: logical_or_expression{
            tree temp = create_node_name("conditional_expression");
            add_node(temp, $1); $$ = temp;
        }
        | logical_or_expression QUES_MARK expression COLON conditional_expression{
            tree temp = create_node_name("conditional_expression");
            tree node1 = create_node_char('?');
            tree node2 = create_node_char(':');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); add_node(temp, $5); $$ = temp;
        }
        ;

assignment_expression: conditional_expression{
            tree temp = create_node_name("assignment_expression");
            add_node(temp, $1); $$ = temp;
        }
        | unary_expression assignment_operator assignment_expression{
            tree temp = create_node_name("assignment_expression");
            add_node(temp, $1); add_node(temp, $2); add_node(temp, $3); $$ = temp;
        }
        ;

assignment_operator: ASSN_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_char('=');
            add_node(temp, node); $$ = temp;
        }
        | MUL_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("*=");
            add_node(temp, node); $$ = temp;
        }
        | DIV_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("/=");
            add_node(temp, node); $$ = temp;
        }
        | MOD_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("%=");
            add_node(temp, node); $$ = temp;
        }
        | ADD_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("+=");
            add_node(temp, node); $$ = temp;
        }
        | SUB_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("-=");
            add_node(temp, node); $$ = temp;
        }
        | LEFT_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("<<=");
            add_node(temp, node); $$ = temp;
        }
        | RIGHT_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name(">>=");
            add_node(temp, node); $$ = temp;
        }
        | AND_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("&=");
            add_node(temp, node); $$ = temp;
        }
        | XOR_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("^=");
            add_node(temp, node); $$ = temp;
        }
        | OR_EQ{
            tree temp = create_node_name("assignment_operator");
            tree node = create_node_name("|=");
            add_node(temp, node); $$ = temp;
        }
        ;

expression: assignment_expression{
            tree temp = create_node_name("expression");
            add_node(temp, $1); $$ = temp;
        }
        | expression COMMA assignment_expression{
            tree temp = create_node_name("expression");
            tree node = create_node_char(',');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }

constant_expression: conditional_expression{
            tree temp = create_node_name("constant_expression");
            add_node(temp, $1); $$ = temp;
        }
        ;

declaration: declaration_specifiers SEMI{
            tree temp = create_node_name("declaration");
            tree node = create_node_char(';');
            add_node(temp, $1); add_node(temp, node);$$ = temp;
        }
        | declaration_specifiers init_declarator_list SEMI{
            tree temp = create_node_name("declaration");
            tree node = create_node_char(';');
            add_node(temp, $1); add_node(temp, $2); add_node(temp, node); $$ = temp;
        }
        ;

declaration_specifiers: storage_class_specifier{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); $$ = temp;
        }
        | storage_class_specifier declaration_specifiers{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | type_specifier{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); $$ = temp;
        }
        | type_specifier declaration_specifiers{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | type_qualifier{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); $$ = temp;
        }
        | type_qualifier declaration_specifiers{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | function_specifier{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); $$ = temp;
        }
        | function_specifier declaration_specifiers{
            tree temp = create_node_name("declaration_specifiers");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        ;

init_declarator_list: init_declarator{
            tree temp = create_node_name("init_declarator_list");
            add_node(temp, $1); $$ = temp;
        }
        | init_declarator_list COMMA init_declarator{
            tree temp = create_node_name("init_declarator_list");
            tree node = create_node_char(',');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

init_declarator: declarator{
            tree temp = create_node_name("init_declarator");
            add_node(temp, $1); $$ = temp;
        }
        | declarator ASSN_EQ initializer{
            tree temp = create_node_name("init_declarator");
            tree node = create_node_char('=');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

storage_class_specifier: STORAGE_KEYWORD{
            tree temp = create_node_name("storage_class_specifier");
            tree node = create_node_name($1);
            add_node(temp, node); $$ = temp;
        }
        | STATIC{
            tree temp = create_node_name("storage_class_specifier");
            tree node = create_node_name("static");
            add_node(temp, node); $$ = temp;
        }
        ;

type_specifier: TYPE_SP_KEYWORD{
            tree temp = create_node_name("type_specifier");
            tree node = create_node_name($1);
            add_node(temp, node); $$ = temp;
        }
        ;

specifier_qualifier_list: type_specifier{
            tree temp = create_node_name("specifier_qualifier_list");
            add_node(temp, $1); $$ = temp;
        }
        | type_specifier specifier_qualifier_list{
            tree temp = create_node_name("specifier_qualifier_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | type_qualifier{
            tree temp = create_node_name("specifier_qualifier_list");
            add_node(temp, $1); $$ = temp;
        }
        | type_qualifier specifier_qualifier_list{
            tree temp = create_node_name("specifier_qualifier_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        ;

type_qualifier: TYPE_QF_KEYWORD{
            tree temp = create_node_name("type_qualifier");
            tree node = create_node_name($1);
            add_node(temp, node); $$ = temp;
        }
        ;

function_specifier: INLINE{
            tree temp = create_node_name("function_specifier");
            tree node = create_node_name("inline");
            add_node(temp, node); $$ = temp;
        }
        ;

declarator: pointer direct_declarator{
            tree temp = create_node_name("declarator");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | direct_declarator{
            tree temp = create_node_name("declarator");
            add_node(temp, $1); $$ = temp;
        }
        ;

direct_declarator: IDENTIFIER{
            tree temp = create_node_name("direct_declarator");
            tree node = create_node_name($1);
            add_node(temp, node); $$ = temp;
        }
        | LP declarator RP{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LBRACKET RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LBRACKET type_qualifier_list RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LBRACKET assignment_expression RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LBRACKET type_qualifier_list assignment_expression RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, $4); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LBRACKET STATIC assignment_expression RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_name("static");
            tree node3 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); add_node(temp, $4); add_node(temp, node3); $$ = temp;
        }
        | direct_declarator LBRACKET STATIC type_qualifier_list assignment_expression RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_name("static");
            tree node3 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); add_node(temp, $4); add_node(temp, $5); add_node(temp, node3); $$ = temp;
        }
        | direct_declarator LBRACKET type_qualifier_list STATIC assignment_expression RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_name("static");
            tree node3 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); add_node(temp, $5); add_node(temp, node3); $$ = temp;
        }
        | direct_declarator LBRACKET MUL_OP RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char('*');
            tree node3 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); add_node(temp, node3); $$ = temp;
        }
        | direct_declarator LBRACKET type_qualifier_list MUL_OP RBRACKET{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char('*');
            tree node3 = create_node_char(']');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); add_node(temp, node3); $$ = temp;
        }
        | direct_declarator LP parameter_type_list RP{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LP RP{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | direct_declarator LP identifier_list RP{
            tree temp = create_node_name("direct_declarator");
            tree node1 = create_node_char('(');
            tree node2 = create_node_char(')');
            add_node(temp, $1); add_node(temp, node1); add_node(temp, $3); add_node(temp, node2); $$ = temp;
        }
        ;

pointer: MUL_OP{
            tree temp = create_node_name("pointer");
            tree node = create_node_char('*');
            add_node(temp, node); $$ = temp;
        }
        | MUL_OP type_qualifier_list{
            tree temp = create_node_name("pointer");
            tree node1 = create_node_char('*');
            add_node(temp, node1); add_node(temp, $2); $$ = temp;
        }
        | MUL_OP pointer{
            tree temp = create_node_name("pointer");
            tree node1 = create_node_char('*');
            add_node(temp, node1); add_node(temp, $2); $$ = temp;
        }
        | MUL_OP type_qualifier_list pointer{
            tree temp = create_node_name("pointer");
            tree node1 = create_node_char('*');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, $3); $$ = temp;
        }
        ;

type_qualifier_list: type_qualifier{
            tree temp = create_node_name("type_qualifier_list");
            add_node(temp, $1); $$ = temp;
        }
        | type_qualifier_list type_qualifier{
            tree temp = create_node_name("type_qualifier_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        ;

parameter_type_list: parameter_list{
            tree temp = create_node_name("parameter_type_list");
            add_node(temp, $1); $$ = temp;
        }
        | parameter_list COMMA ELLIPSIS{
            tree temp = create_node_name("parameter_type_list");
            tree node = create_node_name("...");
            add_node(temp, $1); add_node(temp, node); $$ = temp;
        }
        ;

parameter_list: parameter_declaration{
            tree temp = create_node_name("parameter_list");
            add_node(temp, $1); $$ = temp;
        }
        | parameter_list COMMA parameter_declaration{
            tree temp = create_node_name("parameter_list");
            tree node = create_node_char(',');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        ;

parameter_declaration: declaration_specifiers declarator{
            tree temp = create_node_name("parameter_declaration");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | declaration_specifiers{
            tree temp = create_node_name("parameter_declaration");
            add_node(temp, $1); $$ = temp;
        }
        ;

identifier_list: IDENTIFIER{
            tree temp = create_node_name("identifier_list");
            tree node = create_node_name($1);
            add_node(temp, node); $$ = temp;
        }  
        | identifier_list COMMA IDENTIFIER{
            tree temp = create_node_name("identifier_list");
            tree node1 = create_node_char(',');
            tree node2 = create_node_name($3);
            add_node(temp, $1); add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        ;

type_name: specifier_qualifier_list{
            tree temp = create_node_name("type_name");
            add_node(temp, $1); $$ = temp;
        }
        ;

initializer: assignment_expression{
            tree temp = create_node_name("initializer");
            add_node(temp, $1); $$ = temp;
        }
        | LB initializer_list RB{
            tree temp = create_node_name("initializer");
            tree node1 = create_node_char('{');
            tree node2 = create_node_char('}');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); $$ = temp;
        }
        | LB initializer_list COMMA RB{
            tree temp = create_node_name("initializer");
            tree node1 = create_node_char('{');
            tree node2 = create_node_char(',');
            tree node3 = create_node_char('}');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); add_node(temp, node3); $$ = temp;
        }
        ;

initializer_list: initializer{
            tree temp = create_node_name("initializer_list");
            add_node(temp, $1); $$ = temp;
        }
        | designation initializer{
            tree temp = create_node_name("initializer_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        | initializer_list COMMA initializer{
            tree temp = create_node_name("initializer_list");
            tree node = create_node_char(',');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $3); $$ = temp;
        }
        | initializer_list COMMA designation initializer{
            tree temp = create_node_name("initializer_list");
            tree node = create_node_char(',');
            add_node(temp, $1); add_node(temp, node); add_node(temp, $4); $$ = temp;
        }
        ;

designation: designator_list ASSN_EQ{
            tree temp = create_node_name("designation");
            tree node = create_node_char('=');
            add_node(temp, $1); add_node(temp, node); $$ = temp;
        }
        ;

designator_list: designator{
            tree temp = create_node_name("designator_list");
            add_node(temp, $1); $$ = temp;
        }
        | designator_list designator{
            tree temp = create_node_name("designator_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        ;

designator: LBRACKET constant_expression RBRACKET{
            tree temp = create_node_name("designator");
            tree node1 = create_node_char('[');
            tree node2 = create_node_char(']');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); $$ = temp;
        }
        | DOT IDENTIFIER{
            tree temp = create_node_name("designator");
            tree node1 = create_node_char('.');
            tree node2 = create_node_name($2);
            add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        ;

statement: labeled_statement{
            tree temp = create_node_name("statement");
            add_node(temp, $1); $$ = temp;
        }
        | compound_statement{
            tree temp = create_node_name("statement");
            add_node(temp, $1); $$ = temp;
        }
        | expression_statement{
            tree temp = create_node_name("statement");
            add_node(temp, $1); $$ = temp;
        }
        | selection_statement{
            tree temp = create_node_name("statement");
            add_node(temp, $1); $$ = temp;
        }
        | iteration_statement{
            tree temp = create_node_name("statement");
            add_node(temp, $1); $$ = temp;
        }
        | jump_statement{
            tree temp = create_node_name("statement");
            add_node(temp, $1); $$ = temp;
        }
        ;

labeled_statement: IDENTIFIER COLON statement{
            tree temp = create_node_name("labeled_statement");
            tree node1 = create_node_name($1);
            tree node2 = create_node_char(':');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); $$ = temp;
        }
        | CASE constant_expression COLON statement{
            tree temp = create_node_name("labeled_statement");
            tree node1 = create_node_name("case");
            tree node2 = create_node_char(':');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); add_node(temp, $4); $$ = temp;
        }
        | DEFAULT COLON statement{
            tree temp = create_node_name("labeled_statement");
            tree node1 = create_node_name("default");
            tree node2 = create_node_char(':');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); $$ = temp;
        }
        ;

compound_statement: LB RB{
            tree temp = create_node_name("compound_statement");
            tree node1 = create_node_char('{');
            tree node2 = create_node_char('}');
            add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | LB block_item_list RB{
            tree temp = create_node_name("compound_statement");
            tree node1 = create_node_char('{');
            tree node2 = create_node_char('}');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); $$ = temp;
        }
        ;

block_item_list: block_item{
            tree temp = create_node_name("block_item_list");
            add_node(temp, $1); $$ = temp;
        }
        | block_item_list block_item{
            tree temp = create_node_name("block_item_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        ;

block_item: declaration{
            tree temp = create_node_name("block_item");
            add_node(temp, $1); $$ = temp;
        }
        | statement{
            tree temp = create_node_name("block_item");
            add_node(temp, $1); $$ = temp;
        }
        ;

expression_statement: SEMI{
            tree temp = create_node_name("expression_statement");
            tree node = create_node_char(';');
            add_node(temp, node); $$ = temp;
        }
        | expression SEMI{
            tree temp = create_node_name("expression_statement");
            tree node = create_node_char(';');
            add_node(temp, $1); add_node(temp, node); $$ = temp;
        }
        ;

selection_statement: IF LP expression RP statement{
            tree temp = create_node_name("selection_statement");
            tree node1 = create_node_name("if");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); $$ = temp;
        }
        | IF LP expression RP statement ELSE statement{
            tree temp = create_node_name("selection_statement");
            tree node1 = create_node_name("if");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(')');
            tree node4 = create_node_name("else");
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); add_node(temp, $7); $$ = temp;
        }
        | SWITCH LP expression RP statement{
            tree temp = create_node_name("selection_statement");
            tree node1 = create_node_name("switch");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); $$ = temp;
        }
        ;

iteration_statement: WHILE LP expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("while");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); $$ = temp;
        }
        | DO statement WHILE LP expression RP SEMI{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("do");
            tree node2 = create_node_name("while");
            tree node3 = create_node_char('(');
            tree node4 = create_node_char(')');
            tree node5 = create_node_char(';');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); add_node(temp, node5); $$ = temp;
        }
        | FOR LP SEMI SEMI RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, node3); add_node(temp, node4); add_node(temp, node5); add_node(temp, $6); $$ = temp;
        }
        | FOR LP expression SEMI SEMI RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, node4); add_node(temp, node5); add_node(temp, $7); $$ = temp;
        }
        | FOR LP SEMI expression SEMI RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, node3); add_node(temp, $4); add_node(temp, node4); add_node(temp, node5); add_node(temp, $7); $$ = temp;
        }
        | FOR LP expression SEMI expression SEMI RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); add_node(temp, node5); add_node(temp, $8); $$ = temp;
        }
        | FOR LP SEMI SEMI expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, node3); add_node(temp, node4); add_node(temp, $5); add_node(temp, node5); add_node(temp, $7); $$ = temp;
        }
        | FOR LP expression SEMI SEMI expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, node4); add_node(temp, $6); add_node(temp, node5); add_node(temp, $8); $$ = temp;
        }
        | FOR LP SEMI expression SEMI expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, node3); add_node(temp, $4); add_node(temp, node4); add_node(temp, $6); add_node(temp, node5); add_node(temp, $8); $$ = temp;
        }
        | FOR LP expression SEMI expression SEMI expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(';');
            tree node5 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); add_node(temp, $7); add_node(temp, node5); add_node(temp, $9); $$ = temp;
        }
        | FOR LP declaration SEMI RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, node4); add_node(temp, $6); $$ = temp;
        }
        | FOR LP declaration expression SEMI RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, $4); add_node(temp, node3); add_node(temp, node4); add_node(temp, $7); $$ = temp;
        }
        | FOR LP declaration SEMI expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, node3); add_node(temp, $5); add_node(temp, node4); add_node(temp, $7); $$ = temp;
        }
        | FOR LP declaration expression SEMI expression RP statement{
            tree temp = create_node_name("iteration_statement");
            tree node1 = create_node_name("for");
            tree node2 = create_node_char('(');
            tree node3 = create_node_char(';');
            tree node4 = create_node_char(')');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, $3); add_node(temp, $4); add_node(temp, node3); add_node(temp, $6); add_node(temp, node4); add_node(temp, $8); $$ = temp;
        }
        ;

jump_statement: GOTO IDENTIFIER SEMI{
            tree temp = create_node_name("jump_statement");
            tree node1 = create_node_name("goto");
            tree node2 = create_node_name($2);
            tree node3 = create_node_char(';');
            add_node(temp, node1); add_node(temp, node2); add_node(temp, node3); $$ = temp;
        }
        | CONTINUE SEMI{
            tree temp = create_node_name("jump_statement");
            tree node1 = create_node_name("continue");
            tree node2 = create_node_char(';');
            add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | BREAK SEMI{
            tree temp = create_node_name("jump_statement");
            tree node1 = create_node_name("break");
            tree node2 = create_node_char(';');
            add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | RETURN SEMI{
            tree temp = create_node_name("jump_statement");
            tree node1 = create_node_name("return");
            tree node2 = create_node_char(';');
            add_node(temp, node1); add_node(temp, node2); $$ = temp;
        }
        | RETURN expression SEMI{
            tree temp = create_node_name("jump_statement");
            tree node1 = create_node_name("return");
            tree node2 = create_node_char(';');
            add_node(temp, node1); add_node(temp, $2); add_node(temp, node2); $$ = temp;
        }
        ;

translation_unit: external_declaration{
            tree temp = create_node_name("translation_unit");
            add_node(temp, $1); $$ = temp;
        }
        | translation_unit external_declaration{
            tree temp = create_node_name("translation_unit");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;

        }
        ;
global_start: translation_unit{
            print_tree($1, 0);
        };

external_declaration: function_definition{
            tree temp = create_node_name("external_declaration");
            add_node(temp, $1); $$ = temp;
        }
        | declaration{
            tree temp = create_node_name("external_declaration");
            add_node(temp, $1); $$ = temp;
        }
        ;

function_definition: declaration_specifiers declarator declaration_list compound_statement{
            tree temp = create_node_name("function_definition");
            add_node(temp, $1); add_node(temp, $2); add_node(temp, $3); add_node(temp, $4); $$ = temp;
        }
        | declaration_specifiers declarator compound_statement{
            tree temp = create_node_name("function_definition");
            add_node(temp, $1); add_node(temp, $2); add_node(temp, $3); $$ = temp;
        }
        ;

declaration_list: declaration{
            tree temp = create_node_name("declaration_list");
            add_node(temp, $1); $$ = temp;
        }
        | declaration_list declaration{
            tree temp = create_node_name("declaration_list");
            add_node(temp, $1); add_node(temp, $2); $$ = temp;
        }
        ;

%%

void yyerror(const char *s){
    printf("error: %s\n", s);
}