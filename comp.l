%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%
[ \t]+	{}
"main" { return tMAIN; }

"if" { return tIF; }
"while" { return tWHI; }

"("	{ return tPO; }
")"	{ return tPF; }

"{" { return tAO;}
"}" { return tAF; }

"return" { return tRET; }
";" { return tPV; }
"else" { return tELSE;}

"&&" { return tAND; }
"||" { return tOR; }
"==" { return tEGAL; }

"int" { return tINT; }
"const" { return tCONST; }

"="	{ return tAFFECT; }
"-"	{ return tSOU; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tDIV; }

\/\/.*$ {}

"void" { return tVOID; }

[0-9]+ {
        yylval.entier = atoi(yytext);
        return tENTIER;
    }



[ ]*[\t]*[,]* {}

\n	{}

[a-zA-Z]([a-zA-Z]*[0-9]*[_]*)* {
        yylval.var = strdup(yytext);
        return tNOM;
	}
