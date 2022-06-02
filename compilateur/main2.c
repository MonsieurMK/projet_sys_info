#include <stdio.h>

#include "ts.h"

int main2int argc, char const *argv[])
{
    initTableSymboles();

    ajouterSymbole("var");
    ajouterSymbole("maVariable");
    ajouterSymbole("var");

    printf("recherche var: %d\n", chercherSymbole("var"));
    printf("recherche maVariable: %d\n", chercherSymbole("maVariable"));
    printf("recherche x: %d\n", chercherSymbole("x"));

    ajouterSymboleTemp();
    ajouterSymboleTemp();

    printf("recherche variable temp: %d\n", libererDernierSymboleTemp());
    printf("recherche variable temp: %d\n", libererDernierSymboleTemp());

    return 0;
}