%{
	#include <stdlib.h>

	#include "symbol.h"

	int  yylex( void );
	void yyerror( const char *format , ... );
	void yyinfo( const char *format , ... );

	SymbolTable symbolTable = SYMBOL_TABLE_INITIALIZER;
%}

%code requires {
	#include "tree.h"
}

%union {
	int num;
	char id[1024];
	int op;
	Node * node;
}

%token <num> NUM
%token <id> ID
%token SET
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token EXP
%token LP
%token RP

%type <node> arg
%type <node> expr
%type <op> op

%start program

%%

program:
	stmt program
	| stmt
	| error program { yyerrok; }

stmt:
	setstmt
	| exprstmt

setstmt:
	LP SET ID arg RP {
		// if ($4 == NULL)
		// {
		// 	SymbolTable_InsertOrUpdate( &symbolTable, $3, 0 );
		// 	yyinfo("Variable %s set to 0\n", $3);
		// 	YYERROR;
		// }

		int * eval = eval_tree($4);
		if (eval == NULL)
		{
			free_tree($4);
			YYERROR;
		}
		else
		{
			SymbolTable_InsertOrUpdate( &symbolTable, $3, *eval );
			yyinfo("Variable %s set to %d", $3, *eval);
			free(eval);
		}
		free_tree($4);
	}

exprstmt:
	expr {
		int * eval = eval_tree($1);
		if (eval == NULL)
		{
			free_tree($1);
			YYERROR;
		}
		else
		{
			yyinfo("Standalone expression evaluates to %d", *eval);
			free(eval);
		}
		free_tree($1);
	}

expr:
	LP op arg arg RP {
		$$ = setBinop(( Node * ) malloc( sizeof( Node ) ), $2, $3, $4);
	}

op:
	ADD   { $$ = ADD; }
	| SUB { $$ = SUB; }
	| MUL { $$ = MUL; }
	| DIV { $$ = DIV; }
	| MOD { $$ = MOD; }
	| EXP { $$ = EXP; }

arg:
	NUM {
		Symbol * s = SymbolTable_Insert( &symbolTable, $1 );
		$$ = setSymbol( ( Node * ) malloc( sizeof( Node ) ), s );
	}
	| expr {
		$$ = $1;
	}
	| ID {
		Symbol * s = SymbolTable_Find( &symbolTable, $1 );
		if(s == NULL) {
			yyerror("Undefined symbol %s", $1);
			YYERROR;
		} else {
			$$ = setSymbol( ( Node * ) malloc( sizeof( Node ) ), s );
		}
	}


%%

int yywrap( void )
{
	SymbolTable_Free( &symbolTable );
	printf("\n\nTotal Errors: %d\n", yynerrs);
	return 1;
}
