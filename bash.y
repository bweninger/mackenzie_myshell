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
%token T_PS 
%token T_LS 
%token T_CD
%token T_NBSP
%token T_IP_CONFIG


%start bashing

%%

bashing: 
	   | bashing line { printf("BashWeninger >> "); }
;

line: T_NEWLINE
	| T_PS T_NEWLINE { system("ps"); }
    | T_LS T_NEWLINE { system("ls"); } 
    | T_IP_CONFIG {system("ipconfig");}	
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
    | T_CD T_PARAM T_NEWLINE {chdir(yylval.a);}
;

%%

int main() {
	yyin = stdin;

	do { 
		printf("BashWeninger >> ");
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}