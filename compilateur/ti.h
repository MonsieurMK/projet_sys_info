#ifndef TABLE_INSTRUCTIONS
#define TABLE_INSTRUCTIONS

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "ts.h"

#define NB_INSTRUCTIONS_MAX 50

// structure représentant une instruction et ses arguments
typedef struct Instruction
{
    char * nom;
    int arg1;
    int arg2;
    int arg3;
} instruction;

int indiceInstruction;
instruction * tableInstruct;

// initialise la table des instructions
void initTable();

// retourne le nom de la dernière instruction
char * getLast();

// libère la mémoire
void libererTable();

// insère une instruction
void insert(char * nom, int arg1, int arg2, int arg3);

// ajoute une instruction d'affectation 
void ti_arithmetic_nb(int v);

void ti_arithmetic_var(int addr);

void ti_arithmetic_var_addr(int addr);

void ti_arithmetic_pointer(int addr);

void ti_arithmetic_add();

void ti_arithmetic_sub();

void ti_arithmetic_mul();

void ti_arithmetic_div();

int ti_affect_var(char * nomVar, Type type);

int ti_affect_var_addr(char * nomVar);

void ti_afficher_table();

int ti_inserer_jmp();

int ti_inserer_jmpf(int addrCond);

void ti_set_jmp(int addr, int ligne);

void ti_set_jmpf(int addr, int ligne);

int ti_get_nb_lignes_asm();

void ti_arithmetic_eq();

void ti_arithmetic_inf();

void ti_arithmetic_sup();

int ti_print(char * nomVar);

void ti_print_nb(int nb);

int ti_print_addr(char * nomPt);

int ti_exporter(FILE * fichier);

// faire affectation de variable

#endif