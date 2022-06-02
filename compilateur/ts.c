#include "ts.h"
#include <string.h>

void initTableSymboles() 
{
    indice = 0;
    indiceTemp = TAILLE_TABLEAU - 1;
    tableSymboles = malloc(sizeof(symbole) * TAILLE_TABLEAU);
    currentProf = 0;
}

void libererTableSymboles()
{
    free(tableSymboles);
    indice = 0;
    indiceTemp = TAILLE_TABLEAU - 1;
}


int ajouterSymbole(char * nom, int isConst, Type type) 
{
    if ((indice+1) == indiceTemp)
    {
        return -1;
    }
    
    for (int i = 0; i < indice; i++)
    {
        if (strcmp(nom, tableSymboles[i].nom) == 0 && tableSymboles[i].prof == currentProf)
        {
            return -1;
        }
    }
    
    tableSymboles[indice] = (symbole) { nom, currentProf, isConst, type };
    indice++;

    return indice-1;
}

int chercherSymbole(char * nom, Type type) 
{
    for (int i = 0; i < indice; i++)
    {
        if (strcmp(nom, tableSymboles[i].nom) == 0 &&
        tableSymboles[i].prof <= currentProf &&
        tableSymboles[i].type == type)
        {
            return i;
        }
    }
    
    return -1;
}

int estConstante(char * nom)
{
    int i = chercherSymbole(nom, INT);
    if (i == -1)
    {
        return 0;
    }
    return tableSymboles[i].isConst;
}

int getAddresse(char * nom, Type type)
{
    int indice = chercherSymbole(nom, type);
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
    sprintf(buf, "_tmp%d", indiceTemp);

    tableSymboles[indiceTemp].nom = buf;
    tableSymboles[indiceTemp].prof = currentProf;
    tableSymboles[indiceTemp].isConst = 0;
    tableSymboles[indiceTemp].type = INT;
    indiceTemp--;

    return indiceTemp+1;
}

int libererDernierSymboleTemp()
{
    free(tableSymboles[indiceTemp+1].nom);
    tableSymboles[indiceTemp+1] = (symbole) {"null", 0, 0, INT};
    indiceTemp++;
    return indiceTemp;
}

void augmenterProf()
{
    currentProf++;
}

int reduireProf()
{
    if (currentProf <= 0)
    {
        return 1;
    }
    currentProf--;
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
        printf("tableSymboles[%d]=%s, prof=%d\n", i, tableSymboles[i].nom, tableSymboles[i].prof);
    }
}

void ts_temp_print()
{
    for (int i = TAILLE_TABLEAU - 1; i > indiceTemp; i--)
    {
        printf("tableSymboles[%d]=%s\n", i, tableSymboles[i].nom);
    }
}