#include "ts.h"
#include <string.h>

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
    if ((indice+1) == indiceTemp)
    {
        return -1;
    }
    
    for (int i = 0; i < indice; i++)
    {
        if (strcmp(nom, tableSymboles[i].nom) == 0 && tableSymboles[i].prof == prof)
        {
            return -1;
        }
    }
    
    tableSymboles[indice] = (symbole) { nom, prof };
    //printf("tableSymboles[%d]=%s\n", indice, tableSymboles[indice].nom);
    indice++;

    return indice-1;
}

int chercherSymbole(char * nom) 
{
    for (int i = 0; i < indice; i++)
    {
        if (strcmp(nom, tableSymboles[i].nom) == 0 && tableSymboles[i].prof == prof)
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
    if ((indiceTemp-1) == indice)
    {
        return -1;
    }
    
    char * buf = malloc(sizeof(char) * 6);
    //snprintf(buf, 9, "tempvar%d", indiceTemp);
    sprintf(buf, "_tmp%d", indiceTemp);
    //printf("buf=%s\n", buf);

    tableSymboles[indiceTemp].nom = buf;
    tableSymboles[indiceTemp].prof = prof;
    indiceTemp--;

    return indiceTemp+1;
}

int libererDernierSymboleTemp()
{
    free(tableSymboles[indiceTemp+1].nom);
    tableSymboles[indiceTemp+1] = (symbole) {"null", 0};
    indiceTemp++;
    return indiceTemp;
}

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

int getAddrDernierSymboleTemp()
{
    return indiceTemp+1;
}

void ts_print()
{
    for (int i = 0; i < indice; i++)
    {
        printf("tableSymboles[%d]=%s\n", i, tableSymboles[i].nom);
    }
}

void ts_temp_print()
{
    for (int i = TAILLE_TABLEAU - 1; i > indiceTemp; i--)
    {
        printf("tableSymboles[%d]=%s\n", i, tableSymboles[i].nom);
    }
}