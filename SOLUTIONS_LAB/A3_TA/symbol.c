#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbol.h"

Symbol * SymbolTable_Find( SymbolTable * table, const char * name )
{
	for ( Symbol * s = table->head.next; s != NULL; s = s->next )
	{
		if ( strcmp( s->name, name ) == 0 )
		{
			return s;
		}
	}
	return NULL;
}

Symbol * SymbolTable_InsertOrUpdate( SymbolTable * table, const char * name,
									 int value )
{
	Symbol * s = SymbolTable_Find( table, name );
	if ( s == NULL )
	{
		s  = ( Symbol * ) malloc( sizeof( Symbol ) );
		*s = ( Symbol ) {
			.value = value,
			.next  = table->head.next,
		};
		strcpy( s->name, name );
		table->head.next = s;
	}
	else
	{
		s->value = value;
	}
	return s;
}

void SymbolTable_Print( SymbolTable * table )
{
	puts( "Symbol Table:" );
	for ( Symbol * s = table->head.next; s != NULL; s = s->next )
	{
		printf( "\t%s = %d\n", s->name, s->value );
	}
}

void SymbolTable_Free( SymbolTable * table )
{
	for ( Symbol * s = table->head.next; s != NULL; )
	{
		Symbol * next = s->next;
		free( s );
		s = next;
	}
	table->head.next = NULL;
}

Symbol * SymbolTable_Insert( SymbolTable * table, int value )
{
	Symbol * s = ( Symbol * ) malloc( sizeof( Symbol ) );
	*s		   = ( Symbol ) {
				.name  = "",
				.value = value,
				.next  = table->head.next,
	};
	table->head.next = s;
	return s;
}
