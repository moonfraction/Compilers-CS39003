#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "expr.tab.h"
#include "tree.h"

void yyerror ( const char * format, ... );

Node * setSymbol ( Node * node, Symbol * symbol )
{
	*node = ( Node ) {
		.type	= SYMBOL,
		.symbol = symbol,
	};
	return node;
}

Node * setBinop ( Node * node, int op, Node * left, Node * right )
{
	*node = ( Node ) {
		.type = BINARY_OPERATOR,
		.binop = {
			.op		= op,
			.left	= left,
			.right	= right,
		},
	};
	return node;
}

void freeTree ( Node * node )
{
	if ( node == NULL )
	{
		return;
	}

	if ( node->type == BINARY_OPERATOR )
	{
		freeTree ( node->binop.left );
		freeTree ( node->binop.right );
	}

	free ( node );
}

int * eval_tree ( Node * node )
{
	int * result = ( int * ) malloc ( sizeof ( int ) );
	*result		 = 0;
	switch ( node->type )
	{
		case SYMBOL :
		{
			*result = node->symbol->value;
			break;
		}

		case BINARY_OPERATOR :
		{
			int * _left	 = eval_tree ( node->binop.left );
			int * _right = eval_tree ( node->binop.right );

			if ( _left == NULL )
			{
				if ( _right != NULL )
				{
					free ( _right );
				}
				return NULL;
			}
			if ( _right == NULL )
			{
				free ( _left );
				return NULL;
			}

			int left  = *_left;
			int right = *_right;

			free ( _left );
			free ( _right );

			switch ( node->binop.op )
			{
				case ADD : *result = left + right; break;
				case SUB : *result = left - right; break;
				case MUL : *result = left * right; break;
				case DIV :
				{
					if ( right == 0 )
					{
						yyerror ( "Division by zero" );
						free ( result );
						return NULL;
					}
					*result = left / right;
					break;
				}
				case MOD :
				{
					if ( right == 0 )
					{
						yyerror ( "Modulo by zero" );
						free ( result );
						return NULL;
					}
					*result = left % right;
					break;
				}
				case EXP :
				{
					if ( right < 0 )
					{
						yyerror ( "Exponentiation by negative number" );
						free ( result );
						return NULL;
					}
					*result = ( int ) pow ( left, right );
					break;
				}
			}
			break;
		}
	}

	return result;
}
