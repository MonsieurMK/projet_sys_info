#ifndef TABLE_INSTRUCTIONS
#define TABLE_INSTRUCTIONS

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define NB_INSTRUCTIONS_MAX 50

typedef struct Instruction
{
    char * nom;
    int arg1;
    int arg2;
    int arg3;
} instruction;

int indiceInstruction;
instruction * tableInstruct;

void initStack();

char * getLast();

void freeStack();

void insert(char * nom, int arg1, int arg2, int arg3);

void ti_arithmetic_nb(int v);

void ti_arithmetic_add();

void ti_arithmetic_sub();

void ti_arithmetic_mul();

void ti_arithmetic_div();

int ti_affect_var(char * nomVar);

void ti_afficher_table();

int ti_inserer_jmp();

int ti_inserer_jmpf(int addrCond);

void ti_set_jmp(int addr, int ligne);

void ti_set_jmpf(int addr, int ligne);

int ti_get_nb_lignes_asm();

void ti_arithmetic_eq();

// faire affectation de variable

#endif