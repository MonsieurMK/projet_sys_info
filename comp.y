%{
#include "value.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ts.h"
#include "ti.h"

// implémenter fonctions

extern FILE * yyin;

int yylex();
void yyerror(char *s);
%}

%union { int entier; char * var; value val; }
%token tMAIN tPO tPF tAO tAF tPV tVIR
%token tELSE tAND tOR tINT tCONST 
%token tEGAL tINF tSUP
%token tAFFECT tSOU tADD tMUL tDIV
%token tPRINT tRET tVOID tESP
%token <entier> tENTIER
%token <var> tNOM
%token <entier> tIF
%token <val> tWHI
// removed expression and operande from below
%type <entier> Expression Operande CorpsProgramme While Condition
%type <val> If
%start Compilateur

%right tAFFECT
%left tADD tSOU
%left tMUL tDIV

%%

Compilateur :       Main { YYACCEPT; };

Main :              tMAIN tPO tPF tAO CorpsProgramme tAF;

CorpsProgramme :    Instruction CorpsProgramme { } | Instruction { } ;

Instruction :       Constante | Variable | Affectation | If | While | Print;

Constante :         tCONST tNOM tAFFECT tENTIER tPV 
                    { 
                      int result = ajouterSymbole($2, 1);
                      if (result == -1) {
                        yyerror("Erreur: constante déjà déclarée");
                        YYERROR;
                      } else {
                        ajouterSymboleTemp();
                        ti_arithmetic_nb($4);
                        ti_affect_var($2);
                      }
                    } ;

Variable :          tINT tNOM tAFFECT Expression tPV
                    {
                      int result = ajouterSymbole($2, 0);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree here");
                          YYERROR;
                      } else {
                        ti_affect_var($2);
                      }
                    } 
                    | tINT tNOM tVIR DeclarationVariable
                    {
                      int result = ajouterSymbole($2, 0);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    }
                    | tINT tNOM tPV 
                    { 
                      int result = ajouterSymbole($2, 0);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    } ;

DeclarationVariable :
                    tNOM tPV
                    {
                      int result = ajouterSymbole($1, 0);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    }
                    | tNOM tVIR DeclarationVariable
                    {
                      int result = ajouterSymbole($1, 0);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    } ;
                    

Affectation :       tNOM tAFFECT Expression tPV {
                      if (estConstante($1) == 1) {
                        yyerror("Erreur: impossible de modifier la valeur d'une constante");
                        YYERROR;
                      } else {
                        int result = chercherSymbole($1);
                        if(result == -1) {
                            yyerror("Erreur: variable non declaree");
                            YYERROR;
                        } else {
                          ti_affect_var($1);
                        }
                      }
                    } ;

Expression :        tPO Expression tADD Expression tPF
                    { 
                      ti_arithmetic_add();
                    }
                    |tPO Expression tSOU Expression tPF
                    {
                      ti_arithmetic_sub();
                    }
                    |tPO Expression tMUL Expression tPF
                    {
                      ti_arithmetic_mul();
                    }
                    |tPO Expression tDIV Expression tPF
                    {
                      ti_arithmetic_div();
                    }

                    |Expression tADD Expression
                    { 
                      ti_arithmetic_add();
                    }
                    | Expression tSOU Expression
                    {
                      ti_arithmetic_sub();
                    }
                    
                    | Expression tMUL Expression
                    {
                      ti_arithmetic_mul();
                    }
                    | Expression tDIV Expression
                    {
                      ti_arithmetic_div();
                    }
                    | Operande ;

Operande :          tENTIER
                    { 
                      ajouterSymboleTemp();
                      ti_arithmetic_nb($1);
                      $$ = $1;
                    }
                    | tNOM 
                    { 
                      int addr = chercherSymbole($1);
                      ti_arithmetic_var(addr);
                      if (addr == -1) {
                        yyerror("Erreur: variable non declaree\n");
                        YYERROR;
                      } 
                      else {
                        $$ = addr;
                      }
                    } ;

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
                      //$$ = ligne;
                      $$ = (value) {ligne, current};
                      reduireProf();
                      ti_set_jmp(ligne, current+1);
                    }
                    // else
                    | If tELSE tAO CorpsProgramme
                    {
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmp($1.var1, current + 1);
                      reduireProf();
                    } tAF
                    // else if
                    | If tELSE If
                    {
                     ti_set_jmp($1.var1, $3.var2 + 1);
                      //printf("else if reconnu\n");
                    } ;
While :             tWHI tPO Condition tPF tAO 
                    {
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

Print :             tPRINT tPO tNOM tPF tPV
                    {
                      ti_print($3);
                    } 
                    | tPRINT tPO tENTIER tPF tPV
                    {
                      ti_print_nb($3);
                    } ;

Condition :         tENTIER 
                    | Operande tEGAL Operande
                    {
                      ti_arithmetic_eq();
                      $$ = ti_get_nb_lignes_asm();
                    }
                    | Operande tINF Operande
                    {
                      ti_arithmetic_inf();
                      $$ = ti_get_nb_lignes_asm();
                    }
                    | Operande tSUP Operande
                    {
                      ti_arithmetic_sup();
                      $$ = ti_get_nb_lignes_asm();
                    }

%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); exit(1); }

int main(int argc, char **argv)
{
  initTableSymboles();
  initStack();

  if (argc == 3) {
    yyin = fopen(argv[1], "r");
    FILE * out = fopen(argv[2], "w");

    yyparse();

    ti_exporter(out);
  } else {
    printf("Usage : %s <inFile> <outFile>\n", argv[0]);
    exit(1);
  }
}