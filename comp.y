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
%start Compilateur
%%

Compilateur : Main;
Main : tMAIN tPO tPF tAO CorpsProgramme tAF ;
CorpsProgramme : Instruction tPV CorpsProgramme ;
Instruction : Constante | Variable | Affectation | If | While ;
Constante : tCONST tNOM tAFFECT tENTIER ;
Variable : tINT tNOM | tINT tNOM tAFFECT tENTIER ;
Affectation : tNOM tAFFECT tENTIER | tNOM tAFFECT Expression ;
Expression : Operande Operateur Operande ;
Operande : tENTIER | tNOM ;
Operateur : tADD | tSOU | tMUL | tDIV ;
If : tIF tPO Operande tEGAL Operande tPF tAO CorpsProgramme tAF ;
While : tWHI tPO Operande tEGAL Operande tPF tAO CorpsProgramme tAF ;
 
%%