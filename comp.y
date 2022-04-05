%{
#include <stdlib.h>
#include <stdio.h>
#include "ts.h"
#include "ti.h"

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
%left tADD tSOU
%left tMUL tDIV

%%

Compilateur :       Main ;

Main :              tMAIN tPO tPF tAO CorpsProgramme tAF;

CorpsProgramme :    Instruction CorpsProgramme | Instruction ;

Instruction :       Constante | Variable | Affectation | If | While ;

Constante :         tCONST tNOM tAFFECT tENTIER tPV { printf("declaration de constante\n"); } ;

Variable :          tINT tNOM tAFFECT Expression tPV // peut prendre valeur de expr et operande
                    { 
                      int result = ajouterSymbole($2);
                      if(result == -1) {
                          yyerror("variable deja declaree");
                      } else {
                        //vars[result] = $4;
                        //printf("AFC %d %d\n", result * sizeof(int), $4);
                        //ti_arithmetic_nb($4);
                        ti_affect_var($2);
                      }
                    } 
                    | tINT tNOM tPV 
                    { 
                      int result = ajouterSymbole($2);
                      if(result == -1) {
                          yyerror("variable deja declaree");
                      } else {
                        //vars[result] = 0;
                        printf("AFC %d 0\n", result * sizeof(int));
                      }
                    } ;
                    

Affectation :       tNOM tAFFECT Expression tPV { 
                      printf("affect expression\n");
                      int result = chercherSymbole($1);
                      if(result == -1) {
                          yyerror("variable non declaree");
                      } else {
                        //vars[result] = $3;
                        printf("AFC %d %d\n", result * sizeof(int), $3);
                      }
                    } ;

Expression :        tPO Expression tADD Expression tPF
                    { 
                      //$$=$2+$4;
                      printf("ADD %d %d %d\n", $2, $2, $4);
                    }
                    |tPO Expression tSOU Expression tPF
                    {
                      //$$=$2-$4;
                      printf("SOU %d %d %d\n", $2, $2, $4);
                    }
                    |tPO Expression tMUL Expression tPF
                    {
                      //$$=$2*$4;
                      printf("MUL %d %d %d\n", $2, $2, $4);
                    }
                    |tPO Expression tDIV Expression tPF
                    {
                      if($4 == 0) {
                        yyerror("division par zero\n");
                        //$$=0;
                      } else {
                        //$$=$2/$4;
                        printf("DIV %d %d %d\n", $2, $2, $4);
                      }
                    }

                    |Expression tADD Expression
                    { 
                      //$$=$1+$3;
                      printf("ADD %d %d %d\n", $1, $1, $3);
                    }
                    | Expression tSOU Expression
                    {
                      //$$=$1-$3;
                      printf("SOU %d %d %d\n", $1, $1, $3);
                    }
                    
                    | Expression tMUL Expression
                    {
                      //$$=$1*$3;
                      printf("MUL %d %d %d\n", $1, $1, $3);
                    }
                    | Expression tDIV Expression
                    {
                      if($3 == 0) {
                        yyerror("division par zero\n");
                        //$$=0;
                      } else {
                        //$$=$1/$3;
                        printf("DIV %d %d %d\n", $1, $1, $3);
                      }
                    }
                    |Operande;

Operande :          tENTIER
                    { 
                      int index = ajouterSymboleTemp();
                      printf("STORE %d %d\n", index, $1);
                      $$ = index;
                    }
                    | tNOM 
                    { 
                      
                      int addr = getAddresse($1);
                      if (addr == -1) {
                        yyerror("variable non declaree\n");
                      } else {
                        $$ = addr;
                      }
                    } ;

/* Operateur :         tADD { $$ = ;} | tSOU | tMUL | tDIV ; */

If :                tIF tPO Condition tPF tAO CorpsProgramme tAF { printf("IF lu\n");}
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
  initStack();
  yyparse();
  ti_afficher_table();
  return 0;
}