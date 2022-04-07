%{
#include <stdlib.h>
#include <stdio.h>
#include "ts.h"
#include "ti.h"

typedef struct value {
  int var1;
  int var2;
} value;

void yyerror(char *s);
%}

%union { int entier; char * var; value val; }
%token tMAIN tPO tPF tAO tAF tRET tPV
%token tELSE tAND tOR tEGAL tINT tCONST 
%token tVOID tAFFECT tSOU tADD tMUL tDIV
%token <entier> tENTIER
%token <var> tNOM
%token <entier> tIF
%token <val> tWHI
%type <entier> Operande Expression If CorpsProgramme While Condition
%start Compilateur

%right tAFFECT
%left tADD tSOU
%left tMUL tDIV

%%

Compilateur :       Main { YYACCEPT; };

Main :              tMAIN tPO tPF tAO CorpsProgramme tAF;

CorpsProgramme :    Instruction CorpsProgramme | Instruction ;

Instruction :       Constante | Variable | Affectation | If | While ;

Constante :         tCONST tNOM tAFFECT tENTIER tPV { printf("declaration de constante\n"); } ;

Variable :          tINT tNOM tAFFECT Expression tPV // peut prendre valeur de expr et operande
                    {
                      int result = ajouterSymbole($2);
                      ts_print();
                      if(result == -1) {
                          yyerror("variable deja declaree here");
                          YYERROR;
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
                        //printf("AFC %lu 0\n", result * sizeof(int)); //TODO
                        ti_affect_var($2);
                      }
                    } ;
                    

Affectation :       tNOM tAFFECT Expression tPV { 
                      //printf("affect expression\n");
                      int result = chercherSymbole($1);
                      if(result == -1) {
                          yyerror("variable non declaree");
                      } else {
                        //vars[result] = $3;
                        //printf("AFC %d %d\n", result * sizeof(int), $3);
                        ti_affect_var($1);
                      }
                    } ;

Expression :        tPO Expression tADD Expression tPF
                    { 
                      //$$=$2+$4;
                      //printf("ADD %d %d %d\n", $2, $2, $4);
                      ti_arithmetic_add();
                    }
                    |tPO Expression tSOU Expression tPF
                    {
                      //$$=$2-$4;
                      //printf("SOU %d %d %d\n", $2, $2, $4);
                      ti_arithmetic_sub();
                    }
                    |tPO Expression tMUL Expression tPF
                    {
                      //$$=$2*$4;
                      //printf("MUL %d %d %d\n", $2, $2, $4);*
                      ti_arithmetic_mul();
                    }
                    |tPO Expression tDIV Expression tPF
                    {
                      if($4 == 0) {
                        yyerror("division par zero\n");
                        //$$=0;
                      } else {
                        //$$=$2/$4;
                        //printf("DIV %d %d %d\n", $2, $2, $4);
                        ti_arithmetic_div();
                      }
                    }

                    |Expression tADD Expression
                    { 
                      //$$=$1+$3;
                      //printf("ADD %d %d %d\n", $1, $1, $3);
                      ti_arithmetic_add();
                    }
                    | Expression tSOU Expression
                    {
                      //$$=$1-$3;
                      //printf("SOU %d %d %d\n", $1, $1, $3);
                      ti_arithmetic_sub();
                    }
                    
                    | Expression tMUL Expression
                    {
                      //$$=$1*$3;
                      //printf("MUL %d %d %d\n", $1, $1, $3);
                      ti_arithmetic_mul();
                    }
                    | Expression tDIV Expression
                    {
                      if($3 == 0) {
                        yyerror("division par zero\n");
                        //$$=0;
                      } else {
                        //$$=$1/$3;
                        //printf("DIV %d %d %d\n", $1, $1, $3);
                        ti_arithmetic_div();
                      }
                    }
                    |Operande;

Operande :          tENTIER
                    { 
                      ajouterSymboleTemp();
                      ti_arithmetic_nb($1);
                      //printf("STORE %d %d\n", ind, $1);
                      $$ = $1;
                    }
                    | tNOM 
                    { 
                      // TODO PAS FINI
                      //int addr = getAddresse($1);
                      int addr = ajouterSymboleTemp();
                      //ti_arithmetic_nb()
                      //ti_arithmetic_nb(addr);
                      if (addr == -1) {
                        yyerror("variable non declaree\n");
                      } else {
                        $$ = addr;
                      }
                    } ;

/* Operateur :         tADD { $$ = ;} | tSOU | tMUL | tDIV ; */

If :                tIF tPO Condition tPF tAO
                    { 
                      int addrCond = getAddrDernierSymboleTemp();
                      int ligne = ti_inserer_jmpf(addrCond);
                      libererDernierSymboleTemp();
                      libererDernierSymboleTemp();
                      libererDernierSymboleTemp();
                      $1 = ligne;
                      augmenterProf();
                    }
                    CorpsProgramme tAF
                    {
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmpf($1, current + 2);
                      int ligne = ti_inserer_jmp();
                      $$ = ligne;
                      reduireProf();
                      ti_set_jmp(ligne, current+1);
                    }
                    | If tELSE tAO CorpsProgramme
                    {
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmp($1, current + 1);
                      reduireProf();
                    } tAF
                    | If tELSE If { printf("else if non implemente\n"); } ; // TODO

While :             tWHI tPO Condition tPF tAO 
                    {
                      //int addrCond = getAddrDernierSymboleTemp();
                      //int ligne = ti_inserer_jmpf(addrCond);
                      //libererDernierSymboleTemp();
                      //libererDernierSymboleTemp();
                      //libererDernierSymboleTemp();
                      int addrCond = getAddrDernierSymboleTemp();
                      int current = ti_get_nb_lignes_asm();
                      int ligneJmpf = ti_inserer_jmpf(addrCond);
                      $1 = (value) { current, ligneJmpf};
                      augmenterProf();
                    }
                    CorpsProgramme tAF 
                    {
                      int ligne = ti_inserer_jmp();
                      ti_set_jmp(ligne, $1.var1-2);
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmpf($1.var2, current + 1);
                      libererDernierSymboleTemp();
                      libererDernierSymboleTemp();
                      libererDernierSymboleTemp();
                      reduireProf();
                    } ;

Condition :         tENTIER 
                    | Operande tEGAL Operande
                    {
                      ti_arithmetic_eq();
                      $$ = ti_get_nb_lignes_asm();
                    }
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