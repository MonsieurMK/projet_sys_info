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
void ti_initTable();

// retourne le nom de la dernière instruction
char * ti_getLast();

// libère la mémoire
void ti_libererTable();

// insère une instruction
void ti_insert(char * nom, int arg1, int arg2, int arg3);

// affectation pour la dernière variable temporaire
void ti_arithmetic_nb(int v);

// copie la valeur de la variable dans une variable temporaire
void ti_arithmetic_var(int addr);

// copie l'addresse de la variable dans une variable temporaire
void ti_arithmetic_var_addr(int addr);

// charge la valeur à l'addresse addr dans une variable temporaire
void ti_arithmetic_pointer(int addr);

// opérations arithmétiques sur les deux dernières variables temporaires
void ti_arithmetic_add();

void ti_arithmetic_sub();

void ti_arithmetic_mul();

void ti_arithmetic_div();

// affecte à une variable la dernière valeur temporaire
int ti_affect_var(char * nomVar, Type type);

// charge à l'addresse de la variable la dernière valeur temporaire
int ti_affect_var_addr(char * nomVar);

// affiche la table des instructions
void ti_afficher_table();

// saut à une ligne
int ti_inserer_jmp();

// saut conditionnel à une ligne
int ti_inserer_jmpf(int addrCond);

// modifie la ligne de destination des sauts
void ti_set_jmp(int addr, int ligne);

void ti_set_jmpf(int addr, int ligne);

// retourne le numero de ligne de l'instruction courante
int ti_get_nb_lignes_asm();

// instructions de comparaison
void ti_arithmetic_eq();

void ti_arithmetic_inf();

void ti_arithmetic_sup();

// affichage d'une variable
int ti_print(char * nomVar);

// affichage d'un nombre entier
void ti_print_nb(int nb);

// affiche de la valeur pointée par un pointeur
int ti_print_addr(char * nomPt);

// exporte la table d'instructions dans un fichier
int ti_exporter(FILE * fichier);

#endif