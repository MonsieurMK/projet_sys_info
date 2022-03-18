%{
#include <stdlib.h>
#include <stdio.h>
int var[26];
void yyerror(char *s);
%}

%union { int entier; char * var; }
%token tMAIN tIF tWHI tPO tPF tAO tAF tRET tPV
%token tELSE tAND tOR tEGAL tINT tCONST tCOMM 
%token tVOID tAFFECT tSOU tADD tMUL tDIV
%token <entier> tENTIER
%token <var> tNOM
//%type <entier> Operande
%start Compilateur

%%

Compilateur :       Main ;

Main :              tMAIN tPO tPF tAO CorpsProgramme tAF;

CorpsProgramme :    Instruction CorpsProgramme | Instruction ;
Instruction :       Constante | Variable | Affectation | If | While ;

Constante :         tCONST tNOM tAFFECT tENTIER tPV { printf("declaration de constante\n"); } ;

Variable :          tINT tNOM tAFFECT tENTIER tPV { printf("declaration de variable et affectation\n"); } 
                    | tINT tNOM tPV { printf("declaration de variable\n"); } ;

Affectation :       tNOM tAFFECT tENTIER tPV { printf("affectation de variable\n"); } 
                    | tNOM tAFFECT Expression tPV { printf("affectation de variable\n"); } ;

Expression :        Operande tADD Operande /*{ printf("addition %d + %d", $1, $3); }*/ ;

Operande :          tENTIER
                    | tNOM ;

/* Operateur :         tADD { $$ = ;} | tSOU | tMUL | tDIV ; */

If :                tIF tPO Condition tPF tAO CorpsProgramme tAF { printf("IF lu\n"); }
                    | If tELSE If { printf("IF ELSE lu\n"); } ;
                    | If tELSE tAO CorpsProgramme tAF { printf("ELSE lu\n"); } ;

While :             tWHI tPO Condition tPF tAO CorpsProgramme tAF { printf("WHILE lu\n"); } ;

Condition :         tENTIER 
                    | Operande tEGAL Operande 
                    | Condition tAND Condition
                    | Condition tOR Condition ;

%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n"); // yydebug = 1;
  yyparse();
  return 0;
}