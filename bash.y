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
	int number;
}

%token T_PARAM
%token T_NEWLINE T_QUIT
%token T_PS 
%token T_LS 
%token T_CD
%token T_NBSP
%token T_IP_CONFIG
%token T_MKDIR
%token T_RMDIR

%token <number> NUM
%type <number> expression

%start bashing

%%

bashing: 
	   | bashing line{ printf("BashWeninger >> "); }
	   
;

line: T_NEWLINE
	| T_PS T_NEWLINE { system("ps"); }
    | T_LS T_NEWLINE { system("ls"); } 
    | T_IP_CONFIG {system("ipconfig");}	
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
    | T_CD T_PARAM T_NEWLINE {chdir(yylval.a);}
    | T_MKDIR T_PARAM T_NEWLINE {char buf[60]; sprintf(buf, "mkdir %s", yylval.a); system(buf);}
    | T_RMDIR T_PARAM T_NEWLINE {char buf[60]; sprintf(buf, "rmdir %s", yylval.a); system(buf);}
    | expression {printf("%d\n", $1);}
;

expression: NUM {$$ = $1;}
		| expression '+' expression {$$ = $1 + $3;}
		| expression '-' expression {$$ = $1 - $3;}
		| expression '*' expression {$$ = $1 * $3;}
		| expression '/' expression {$$ = $1 / $3;}

;
%%

int main() {
	yyin = stdin;
		printf("BashWeninger >> ");
	do { 
		
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Comando invalido\n");
}