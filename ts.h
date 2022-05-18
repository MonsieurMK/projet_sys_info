#ifndef TABLE_SYMBOLES
#define TABLE_SYMBOLES

#define TAILLE_TABLEAU 20

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int indice;

int indiceTemp;

int currentProf;

typedef struct Symbole
{
    char * nom;
    int prof;
    int isConst;
    //char * type;
    //void * addr // pas besoin car on utilise l'indice du tableau
} symbole;

symbole * tableSymboles;

// initialise une table de symboles à un tableau vide
void initTableSymboles();

void libererTableSymboles();

// ajoute un nouveau symbole à la table
// retourne 1 si un symbole de meme nom est présent
int ajouterSymbole(char * nom, int isConst);

// retourne l'indice dans la table du symbole
// recherché
// retourne -1 si le symbole n'est pas présent
int chercherSymbole(char * nom);

int estConstante(char * nom);

int getAddresse(char * nom);

int ajouterSymboleTemp();

int libererDernierSymboleTemp();

void augmenterProf();

int reduireProf();

int getAddrDernierSymboleTemp();

int getDernierSymboleTemp();

void ts_print();

void ts_temp_print();

#endif