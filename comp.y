%{
#include <stdlib.h>
#include <stdio.h>
#include "ts.h"

int * vars;
void yyerror(char *s);
%}

%union { int entier; char * var; }
%token tMAIN tIF tWHI tPO tPF tAO tAF tRET tPV
%token tELSE tAND tOR tEGAL tINT tCONST tCOMM 
%token tVOID tAFFECT tSOU tADD tMUL tDIV
%token <entier> tENTIER
%token <var> tNOM
%type <entier> Operande Expression
%start Compilateur

%right tAFFECT
%left tADD

%%

Compilateur :       Main ;

Main :              tMAIN tPO tPF tAO CorpsProgramme tAF;

CorpsProgramme :    Instruction CorpsProgramme | Instruction ;

Instruction :       Constante | Variable | Affectation | If | While ;

Constante :         tCONST tNOM tAFFECT tENTIER tPV { printf("declaration de constante\n"); } ;

Variable :          tINT tNOM tAFFECT Expression tPV // peut prendre valeur de expr et operande
                    { 
                      printf("affect expression\n");
                      int result = ajouterSymbole($2, 0);
                      if(result == -1) {
                          yyerror("variable deja declaree");
                      } else {
                        vars[result] = $4;
                        printf("vars result=%d, result=%d\n", vars[result], result);
                      }
                    } 
                    /*|tINT tNOM tAFFECT Operande tPV // peut prendre valeur de expr et operande
                    { 
                      printf("operande detectee\n");
                      int result = ajouterSymbole($2, 0);
                      if(result == -1) {
                          yyerror("variable deja declaree");
                      } else {
                        vars[result] = $4;
                        printf("vars result=%d, result=%d\n", vars[result], result);
                      }
                    } */
                    | tINT tNOM tPV 
                    { 
                      printf("declaration\n");
                      int result = ajouterSymbole($2, 0);
                      if(result == -1) {
                          yyerror("variable deja declaree");
                      } else {
                        vars[result] = 0;
                      }
                    } ;
                    

Affectation :       tNOM tAFFECT tENTIER tPV { printf("affectation de variable\n"); } 
                    | tNOM tAFFECT Expression tPV { printf("affectation de variable\n"); } ;

Expression :        Expression tADD Expression
                    { 
                      printf("addition=%d+%d=%d\n", $1, $3, $1 + $3); return ($1 + $3); 
                    }
                    |Operande;

Operande :          tENTIER
                    | tNOM 
                    { 
                      printf("operande2 %s\n", $1);
                      int index = chercherSymbole($1); 
                      if (index == -1)
                      {
                        yyerror("variable non declaree");
                      } else {
                        printf("returned %d\n", vars[index]);
                        return vars[index];
                      }
                    } ;

/* Operateur :         tADD { $$ = ;} | tSOU | tMUL | tDIV ; */

If :                tIF tPO Condition tPF tAO CorpsProgramme tAF { printf("IF lu\n"); }
                    | If tELSE If { printf("IF ELSE lu\n"); } 
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
  initTableSymboles();
  vars = malloc(sizeof(int) * TAILLE_TABLEAU);
  yyparse();
  free(vars);
  return 0;
}