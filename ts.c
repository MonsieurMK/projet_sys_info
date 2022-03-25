#include "ts.h"

void initTableSymboles() 
{
    indice = 0;
    tableSymboles = malloc(sizeof(symbole) * TAILLE_TABLEAU);
}

void libererTableSymboles()
{
    free(tableSymboles);
    indice = 0;
}

int ajouterSymbole(char * nom, int prof) 
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