#include "ts.h"

void initTableSymboles() 
{
    indice = 0;
    indiceTemp = TAILLE_TABLEAU - 1;
    tableSymboles = malloc(sizeof(symbole) * TAILLE_TABLEAU);
    prof = 0;
}

void libererTableSymboles()
{
    free(tableSymboles);
    indice = 0;
    indiceTemp = TAILLE_TABLEAU - 1;
}

int ajouterSymbole(char * nom) 
{
    for (int i = 0; i < indice; i++)
    {
        if (strcmp(nom, tableSymboles[i].nom) == 0)
        {
            return -1;
        }
    }
    
    tableSymboles[indice] = (symbole) { nom, prof };
    printf("tableSymboles[%d]=%s\n", indice, tableSymboles[indice].nom);
    indice++;

    return indice-1;
}

int chercherSymbole(char * nom) 
{
    for (int i = 0; i < indice; i++)
    {
        if (strcmp(nom, tableSymboles[i].nom) == 0)
        {
            return i;
        }
    }
    
    return -1;
}

int getAddresse(char * nom)
{
    int indice = chercherSymbole(nom);
    if (indice == -1)
    {
        return -1;
    }
    return indice * sizeof(int);
}

int ajouterSymboleTemp()
{
    tableSymboles[indiceTemp]
}

int libererDernierSymboleTemp();

void augmenterProf()
{
    prof++;
}

int reduireProf()
{
    if (prof <= 0)
    {
        return 1;
    }
    prof--;
    return 0;
}

// TODO la ts est une pile, montante pour les variables et descendante pour les variables temporaires