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
%token tELSE tINT tCONST 
%token tEGAL tINF tSUP
%token tAFFECT tSOU tADD tMUL tDIV
%token tPRINT tESP
%token <entier> tENTIER
%token <var> tNOM
%token <entier> tIF
%token <val> tWHI
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

Constante :         // déclaration et affectation d'une constante de type entier
                    tCONST tNOM tAFFECT tENTIER tPV
                    { 
                      int result = ts_ajouterSymbole($2, 1, INT);
                      if (result == -1) 
                      {
                        yyerror("Erreur: constante deja declaree");
                        YYERROR;
                      } else {
                        ts_ajouterSymboleTemp();
                        ti_arithmetic_nb($4);
                        ti_affect_var($2, INT);
                      }
                    } ;

Variable :          // déclaration et affectation d'une variable de type entier
                    tINT tNOM tAFFECT Expression tPV
                    {
                      int result = ts_ajouterSymbole($2, 0, INT);
                      if(result == -1) 
                      {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      } else {
                        ti_affect_var($2, INT);
                      }
                    } 
                    // déclaration de multiple variables de type entier
                    | tINT tNOM tVIR DeclarationVariable
                    {
                      int result = ts_ajouterSymbole($2, 0, INT);
                      if(result == -1) 
                      {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    }
                    // déclaration d'une variable de type entier
                    | tINT tNOM tPV 
                    { 
                      int result = ts_ajouterSymbole($2, 0, INT);
                      if(result == -1) 
                      {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    } 
                    // déclaration d'une variable de type pointeur
                    | tINT tMUL tNOM tPV
                    {
                      int result = ts_ajouterSymbole($3, 0, POINTER);
                      if (result == -1) {
                        yyerror("Erreur: variable deja declaree");
                        YYERROR;
                      }
                    } 
                    // déclaration et affectation d'une variable de type pointeur
                    | tINT tMUL tNOM tAFFECT tESP tNOM tPV
                    {
                      int result = ts_ajouterSymbole($3, 0, POINTER);
                      if (result == -1) {
                        yyerror("Erreur: variable deja declaree");
                        YYERROR;
                      } else {
                        int addr = ts_chercherSymbole($6, INT);
                        if (addr == -1) {
                          yyerror("Erreur: variable non declaree");
                          YYERROR;
                        } else {
                          ti_arithmetic_var_addr(addr);
                          ti_affect_var($3, POINTER);
                        }
                      }
                    } ;

DeclarationVariable :
                    // déclaration de variable utilisée pour les déclarations multiples
                    tNOM tPV
                    {
                      int result = ts_ajouterSymbole($1, 0, INT);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    }
                    | tNOM tVIR DeclarationVariable
                    {
                      int result = ts_ajouterSymbole($1, 0, INT);
                      if(result == -1) {
                          yyerror("Erreur: variable deja declaree");
                          YYERROR;
                      }
                    } ;
                    

Affectation :       // affectation d'une valeur à une variable déjà déclarée
                    tNOM tAFFECT Expression tPV 
                    {
                      if (ts_estConstante($1) == 1) {
                        yyerror("Erreur: impossible de modifier la valeur d'une constante");
                        YYERROR;
                      } else {
                        int result = ti_affect_var($1, INT);
                        if (result == -1) {
                          result = ti_affect_var($1, POINTER);
                          if (result == -1) {
                            yyerror("Erreur: variable non declaree");
                            YYERROR;
                          }
                        }
                      }
                    } 
                    // affectation de la valeur pointée par un pointeur
                    | tMUL tNOM tAFFECT Expression tPV
                    {
                      if (ts_estConstante($2) == 1) {
                        yyerror("Erreur: impossible de modifier la valeur d'une constante");
                        YYERROR;
                      } else {
                        int result = ti_affect_var_addr($2);
                        if (result == -1) {
                          yyerror("Erreur: variable non declaree");
                          YYERROR;
                        }
                      }
                    } ;

Expression :        // expressions arithmétiques avec parenthèses
                    tPO Expression tADD Expression tPF
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
                    
                    // expressions arithmétiques sans parenthèses
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

Operande :          // opérandes élémentaires formant des expressions
                    // entier
                    tENTIER
                    { 
                      ts_ajouterSymboleTemp();
                      ti_arithmetic_nb($1);
                      $$ = $1;
                    }
                    // variable de type entier
                    | tNOM 
                    { 
                      int addr = ts_chercherSymbole($1, INT);
                      if (addr == -1) {
                        addr = ts_chercherSymbole($1, POINTER);
                        if (addr == -1) {
                          yyerror("Erreur: variable non declaree");
                          YYERROR;
                        }
                      }
                      ti_arithmetic_var(addr);
                      $$ = addr;
                    } 
                    // valeur pointée par un pointeur
                    | tMUL tNOM
                    {
                      int addr = ts_chercherSymbole($2, POINTER);
                      if (addr == -1) {
                        yyerror("Erreur: variable non declaree ou pas un pointeur");
                        YYERROR;
                      }
                      ti_arithmetic_pointer(addr);
                    } ;

If :                // intruction conditionnelle
                    tIF tPO Condition tPF tAO
                    { 
                      int addrCond = ts_getAddrDernierSymboleTemp();
                      int ligne = ti_inserer_jmpf(addrCond);
                      ts_libererDernierSymboleTemp();
                      ts_libererDernierSymboleTemp();
                      ts_libererDernierSymboleTemp();
                      $1 = ligne;
                      ts_augmenterProf();
                    }
                    CorpsProgramme tAF
                    {
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmpf($1, current + 2);
                      int ligne = ti_inserer_jmp();
                      //$$ = ligne;
                      $$ = (value) {ligne, current};
                      ts_reduireProf();
                      ti_set_jmp(ligne, current+1);
                    }
                    // else
                    | If tELSE tAO CorpsProgramme
                    {
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmp($1.var1, current + 1);
                      ts_reduireProf();
                    } tAF
                    // else if
                    | If tELSE If
                    {
                     ti_set_jmp($1.var1, $3.var2 + 1);
                    } ;


While :             // boucle
                    tWHI tPO Condition tPF tAO 
                    {
                      int addrCond = ts_getAddrDernierSymboleTemp();
                      int current = ti_get_nb_lignes_asm();
                      int ligneJmpf = ti_inserer_jmpf(addrCond);
                      $1 = (value) { current, ligneJmpf};
                      ts_augmenterProf();
                    }
                    CorpsProgramme tAF 
                    {
                      int ligne = ti_inserer_jmp();
                      ti_set_jmp(ligne, $1.var1-2);
                      int current = ti_get_nb_lignes_asm();
                      ti_set_jmpf($1.var2, current + 1);
                      ts_libererDernierSymboleTemp();
                      ts_libererDernierSymboleTemp();
                      ts_libererDernierSymboleTemp();
                      ts_reduireProf();
                    } ;

Print :             // fonction d'affichage d'une valeur ou d'un entier
                    tPRINT tPO tNOM tPF tPV
                    {
                      ti_print($3);
                    } 
                    | tPRINT tPO tENTIER tPF tPV
                    {
                      ti_print_nb($3);
                    } 
                    | tPRINT tPO tMUL tNOM tPF tPV
                    {
                      ti_print_addr($4);
                    } ;

Condition :         // condition retournant un résultat booléen, utilisée dans les structures de contrôles
                    tENTIER 
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
  ts_initTableSymboles();
  ti_initTable();

  if (argc == 3) {
    yyin = fopen(argv[1], "r");
    FILE * out = fopen(argv[2], "w");

    yyparse();

    ti_exporter(out);
  } else {
    printf("Usage : %s <inFile> <outFile>\n", argv[0]);
    exit(1);
  }

  ts_libererTableSymboles();
  ti_libererTable();
}