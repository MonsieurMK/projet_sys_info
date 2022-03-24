#ifndef TABLE_SYMBOLES
#define TABLE_SYMBOLES

#define TAILLE_TABLEAU 10

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int indice;

typedef struct Symbole
{
    char * nom;
    int prof;
    //char * type;
    //void * addr // pas besoin car on utilise l'indice du tableau
} symbole;

symbole * tableSymboles;

// initialise une table de symboles à un tableau vide
void initTableSymboles();

void libererTableSymboles();

// ajoute un nouveau symbole à la table
// retourne 1 si un symbole de meme nom est présent
int ajouterSymbole(char * nom, int prof);

// retourne l'indice dans la table du symbole
// recherché
// retourne 1 si le symbole n'est pas présent
int chercherSymbole(char * nom);

#endif