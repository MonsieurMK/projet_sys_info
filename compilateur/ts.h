#ifndef TABLE_SYMBOLES
#define TABLE_SYMBOLES

#define TAILLE_TABLEAU 20

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int indice;

int indiceTemp;

int currentProf;

// ensemble des types autorisés dans le programme
typedef enum Type { INT, POINTER } Type;

// structure représentant chaque symbole de la table
typedef struct Symbole
{
    char * nom;
    int prof;
    int isConst;
    Type type;
} symbole;

symbole * tableSymboles;

// initialise une table de symboles à un tableau vide
void ts_initTableSymboles();

// vide une table des symboles et libère la mémoire
void ts_libererTableSymboles();

// ajoute un nouveau symbole à la table
// retourne 1 si un symbole de meme nom est présent
int ts_ajouterSymbole(char * nom, int isConst, Type type);

// retourne l'indice dans la table du symbole
// recherché
// retourne -1 si le symbole n'est pas présent
int ts_chercherSymbole(char * nom, Type type);

// retourne 1 si la variable est une constante,
// retourne 0 sinon
int ts_estConstante(char * nom);

// retourne l'adresse (multipliée par 4) de la variable
int ts_getAddresse(char * nom, Type type);

// ajoute une variable temporaire à la table des symboles et retourne son adresse
int ts_ajouterSymboleTemp();

// libère le dernier symbole temporaire utilisé
int ts_libererDernierSymboleTemp();

// augmente la profondeur courante du programme
void ts_augmenterProf();

// réduit la profondeur courante du programme
int ts_reduireProf();

// retourne l'adresse du dernier symbole temporaire
int ts_getAddrDernierSymboleTemp();

// affiche les variables dans la table des symboles
void ts_print();

// affiche les variables temporaires dans la table des symboles
void ts_temp_print();

#endif