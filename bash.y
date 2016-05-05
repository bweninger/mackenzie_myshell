%{

#include <stdio.h>
#include <stdlib.h>

//extern int yylex();
//extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	char *a;
}

%token T_PARAM
%token T_NEWLINE T_QUIT
%left T_LS 

%start bashing

%%

bashing: 
	   | bashing line
;

line: T_NEWLINE
    | T_LS T_NEWLINE { system("ls"); } 
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

%%

int main() {
	yyin = stdin;

	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
