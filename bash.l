%{
#include <stdio.h>

//#define YY_DECL int yylex()
#define YY_TYPE char *


#include "bash.tab.h"

%}

%%

[\t]		{return T_NBSP;}
"ps"		{return T_PS;}
"ls"		{return T_LS;}
"mkdir"		{return T_MKDIR;}
"rmdir"		{return T_RMDIR;}
"cd"		{return T_CD;}
"ipconfig"  {return T_IP_CONFIG;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}
[0-9]+		{yylval.number = atoi(yytext); return NUM;}
[-*+/]		{ return *yytext; }
[a-zA-Z0-9]+	 	{yylval.a = yytext; return T_PARAM;}
\n			{return T_NEWLINE;}
%%
