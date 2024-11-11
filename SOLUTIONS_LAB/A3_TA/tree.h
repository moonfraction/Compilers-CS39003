#pragma once

#ifndef _TREE_H_
	#define _TREE_H_

	#include "symbol.h"

typedef struct _Node
{
	enum Type
	{
		SYMBOL,
		BINARY_OPERATOR,
	} type;

	union
	{
		Symbol * symbol;

		struct Binop
		{
			int			  op;
			struct _Node *left, *right;
		} binop;
	};
} Node;

Node * setSymbol ( Node * node, Symbol * symbol );
Node * setBinop ( Node * node, int op, Node * left, Node * right );
int *  eval_tree ( Node * node );
void   freeTree ( Node * node );

#endif	  // _TREE_H_
