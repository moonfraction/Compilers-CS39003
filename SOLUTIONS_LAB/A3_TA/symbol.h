#pragma once

#ifndef _SYMBOL_H_
	#define _SYMBOL_H_

	#define MAX_SYMBOL_NAME_LENGTH 1024

typedef struct _Symbol
{
	char			 name[ MAX_SYMBOL_NAME_LENGTH ];
	int				 value;
	struct _Symbol * next;
} Symbol;

typedef struct _SymbolTable
{
	Symbol head;
} SymbolTable;

	#define SYMBOL_TABLE_INITIALIZER \
		( SymbolTable )              \
		{                            \
			.head = {                \
				.name  = "",         \
				.value = 0,          \
				.next  = NULL,       \
			}                        \
		}

Symbol * SymbolTable_Find( SymbolTable * table, const char * name );
Symbol * SymbolTable_InsertOrUpdate( SymbolTable * table, const char * name,
									 int value );
Symbol * SymbolTable_Insert( SymbolTable * table, int value );
void	 SymbolTable_Print( SymbolTable * table );
void	 SymbolTable_Free( SymbolTable * table );

#endif	  // _SYMBOL_H_
