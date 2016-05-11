%{
#include <stdio.h>

//#define YY_DECL int yylex()
#define YY_TYPE char *


#include "bash.tab.h"

%}

%%

[ \t]		;
"ps"		{return T_PS;}
"ls"		{return T_LS;}
"mkdir"		{return T_MKDIR;}
"rmdir"		{return T_RMDIR;}
"cd"		{return T_CD;}
"kill"		{return T_KILL;}
"touch"		{return T_TOUCH;}
"ipconfig"  {return T_IP_CONFIG;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}
"start"		{return T_START;}
[0-9]+		{yylval.number = atoi(yytext); return NUM;}
[-*+/]		{ return *yytext; }
[a-zA-Z0-9]+ {yylval.a = yytext; return T_PARAM;}
[a-zA-Z0-9]+\.*[a-z]* {yylval.a = yytext; return T_FILENAME;}
\n			{return T_NEWLINE;}
%%
