#ifndef TABLE_SYMBOLES
#define TABLE_SYMBOLES

#define TAILLE_TABLEAU 10

typedef struct Symbole
{
    char * nom;
    void * pt;
    int prof;
} Symbole;

Symbole table[TAILLE_TABLEAU];

void ajouter(char * nom, int prof);

void affecter(char * nom, void * pt);

Symbole getSymbole(char * nom);

#endif