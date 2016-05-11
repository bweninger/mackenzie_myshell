%{

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

//extern int yylex();
//extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
void cd(char* dest);
char *trimwhitespace(char *str);
%}



%union {
	char *a;
	int number;
}

%token T_PARAM
%token T_FILENAME
%token T_NEWLINE T_QUIT
%token T_PS 
%token T_LS 
%token T_CD
%token T_NBSP
%token T_IP_CONFIG
%token T_MKDIR
%token T_RMDIR
%token T_KILL
%token T_TOUCH
%token T_START

%token <number> NUM
%type <number> expression

%start bashing

%%

bashing: 
	   | bashing line{char buf[1024]; getcwd(buf, sizeof(buf)); printf("BashWeninger: %s>>", buf); }
	   
;

line: T_NEWLINE
	| T_PS T_NEWLINE { system("ps"); }
    | T_LS T_NEWLINE { system("ls"); } 
    | T_IP_CONFIG {system("ipconfig");}	
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
    | T_CD T_PARAM T_NEWLINE {cd(yylval.a);}
    | T_MKDIR T_PARAM T_NEWLINE {char buf[60]; sprintf(buf, "mkdir %s", trimwhitespace(yylval.a)); system(buf);}
    | T_RMDIR T_PARAM T_NEWLINE {char buf[60]; sprintf(buf, "rmdir %s", trimwhitespace(yylval.a)); system(buf);}
    | T_KILL NUM T_NEWLINE {char buf[60]; sprintf(buf, "kill %d", yylval.number);system(buf); }
    | T_TOUCH T_PARAM T_NEWLINE {char buf[60]; sprintf(buf, "touch %s", trimwhitespace(yylval.a)); system(buf); printf("Arquivo %s criado.", yylval.a);}
    | T_TOUCH T_FILENAME T_NEWLINE {char buf[60]; sprintf(buf, "touch %s", trimwhitespace(yylval.a)); system(buf); printf("Arquivo %s criado.", yylval.a);}
    | T_START T_PARAM T_NEWLINE {char buf[60]; sprintf(buf, "exec ./%s", trimwhitespace(yylval.a)); system(buf);}
    | T_START T_FILENAME T_NEWLINE {char buf[60]; sprintf(buf, "exec ./%s", trimwhitespace(yylval.a)); system(buf);}
    | expression T_NEWLINE {printf("%d\n", $1);}

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
		char buf[1024]; getcwd(buf, sizeof(buf)); printf("BashWeninger: %s>>", buf); 	
	do { 		
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Comando invalido\n");
}

void cd(char* dest) {
	char buf[1024];
	getcwd(buf, sizeof(buf));
	strcat(buf, "/");
	strcat(buf, dest);	
	printf("%s", buf);
	chdir(trimwhitespace(buf));
}

char *trimwhitespace(char *str)
{
  char *end;

  while(isspace(*str)) str++;

  if(*str == 0)  // All spaces?
    return str;

  end = str + strlen(str) - 1;
  while(end > str && isspace(*end)) end--;

  *(end+1) = 0;

  return str;
}