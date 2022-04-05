//Stack of instruction for our compiler

#include "ti.h"
#include "ts.h"

void initStack()
{
    indice = 0;
    tableInstruct = malloc(sizeof(instruction) * NB_INSTRUCTIONS_MAX);
}

char getLast(){
    return tableInstruct[indice-1].nom;
}

void freeStack(){
    for(int i = 0; i < indice; i++){
        free(tableInstruct[i].nom);
    }
    free(tableInstruct);
    indice = 0;
}

void insert(char * nom, int arg1, int arg2, int arg3)
{
    if (indice == NB_INSTRUCTIONS_MAX)
    {
        printf("Erreur: Table instructions pleine\n");
        exit(1);
    }
    tableInstruct[indice] = (instruction) { nom, arg1, arg2, arg3 };
    indice++;
}

void ti_arithmetic_nb(int v){
    int addr = getAddrDernierSymboleTemp();
    if(addr == -1){
        printf("Erreur: Pas assez de variables temporaires\n");
        exit(1);
    }
    insert("AFC",addr,v,0);
}

void ti_arithmetic_add(){
    int addr = getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    libererDernierSymboleTemp();
    insert("ADD",secondAddr,secondAddr,addr);
}

void ti_arithmetic_sub(){
    int addr = getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    libererDernierSymboleTemp();
    insert("SUB",secondAddr,secondAddr,addr);
}

void ti_arithmetic_mul(){
    int addr = getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    libererDernierSymboleTemp();
    insert("MUL",secondAddr,secondAddr,addr);
}

void ti_arithmetic_div(){
    int addr = getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    libererDernierSymboleTemp();
    insert("DIV",secondAddr,secondAddr,addr);
}

int ti_affect_var(char * nomVar) 
{
    int addr = getAddrDernierSymboleTemp();
    int addrVar = chercherSymbole(nomVar);
    if (addrVar == -1) 
    {
        printf("Erreur: Variable %s non déclarée\n", nomVar);
        return -1;
    }
    libererDernierSymboleTemp();
    insert("AFC", addrVar, addr, 0);

    return 0;
}

void ti_afficher_table()
{
    printf("\n\nTable des instructions:\n");
    for (int i = 0; i < indice; i++)
    {
        printf("%s\t%d\t%d\t%d\n", tableInstruct[i].nom, tableInstruct[i].arg1, tableInstruct[i].arg2, tableInstruct[i].arg3);
    }
}
