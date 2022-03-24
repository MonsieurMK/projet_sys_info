#include <stdio.h>

#include "ts.h"

int main(int argc, char const *argv[])
{
    initTableSymboles();

    ajouterSymbole("var", 0);
    ajouterSymbole("maVariable", 0);
    ajouterSymbole("var", 0);

    printf("recherche var: %d\n", chercherSymbole("var"));
    printf("recherche maVariable: %d\n", chercherSymbole("maVariable"));
    printf("recherche x: %d\n", chercherSymbole("x"));

    return 0;
}
