#include <stdarg.h>
#include <stdio.h>

extern int yylineno;
int		   yyparse();

void yyerror( const char * format, ... )
{
	// preprend `*** Error: ` to the error message
	fprintf( stdout, "*** Error at line %d: ", yylineno );
	va_list args;
	va_start( args, format );
	vfprintf( stdout, format, args );
	va_end( args );
	fputc( '\n', stdout );
}

void yyinfo( const char * format, ... )
{
	// preprend `*** Info: ` to the info message
	fputs( "*** Info: ", stdout );
	va_list args;
	va_start( args, format );
	vfprintf( stdout, format, args );
	va_end( args );
	fputc( '\n', stdout );
}

int main()
{
	return yyparse();
}
