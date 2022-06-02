//Stack of instruction for our compiler

#include "ti.h"
#include "ts.h"

void initStack()
{
    indiceInstruction = 0;
    tableInstruct = malloc(sizeof(instruction) * NB_INSTRUCTIONS_MAX);
}

char * getLast(){
    return tableInstruct[indiceInstruction-1].nom;
}

void freeStack(){
    for(int i = 0; i < indiceInstruction; i++){
        free(tableInstruct[i].nom);
    }
    //free(tableInstruct);
    indiceInstruction = 0;
}

void insert(char * nom, int arg1, int arg2, int arg3)
{
    if (indiceInstruction == NB_INSTRUCTIONS_MAX)
    {
        printf("Erreur: Table instructions pleine\n");
        exit(1);
    }
    tableInstruct[indiceInstruction] = (instruction) { nom, arg1, arg2, arg3 };
    indiceInstruction++;
}

void ti_arithmetic_nb(int v){
    int addr = getAddrDernierSymboleTemp();
    if(addr == -1){
        printf("Erreur: Pas assez de variables temporaires\n");
        exit(1);
    }
    insert("AFC",addr,v,0);
}

void ti_arithmetic_var(int addr) {
    int addrResult = ajouterSymboleTemp();
    insert("COP", addrResult, addr, 0);
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
    insert("COP", addrVar, addr, 0);

    return 0;
}

void ti_afficher_table()
{
    printf("\n\nTable des instructions:\n");
    for (int i = 0; i < indiceInstruction; i++)
    {
        printf("%d\t%s\t%d\t%d\t%d\n", i+1, tableInstruct[i].nom, tableInstruct[i].arg1, tableInstruct[i].arg2, tableInstruct[i].arg3);
    }
}

int ti_inserer_jmp()
{
    insert("JMP", 0, 0, 0);
    return indiceInstruction - 1;
}

int ti_inserer_jmpf(int addrCond)
{
    insert("JMF", addrCond, 0, 0);
    return indiceInstruction - 1;
}

void ti_set_jmp(int addr, int ligne)
{
    tableInstruct[addr].arg1 = ligne;
}

void ti_set_jmpf(int addr, int ligne)
{
    tableInstruct[addr].arg2 = ligne;
}

int ti_get_nb_lignes_asm()
{
    return indiceInstruction;
}

// TEST INVERSION ADDR1 ET ADDR2 SUR EQU, INF ET SUP
// test si il faut liberation temp
void ti_arithmetic_eq()
{
    int addr1 = getAddrDernierSymboleTemp();
    int addr2 = addr1 + 1;
    int addrResult = ajouterSymboleTemp();
    insert("EQU", addrResult, addr2, addr1);
}

void ti_arithmetic_inf()
{
    int addr1 = getAddrDernierSymboleTemp();
    int addr2 = addr1 + 1;
    int addrResult = ajouterSymboleTemp();
    insert("INF", addrResult, addr2, addr1);
}

void ti_arithmetic_sup()
{
    int addr1 = getAddrDernierSymboleTemp();
    int addr2 = addr1 + 1;
    int addrResult = ajouterSymboleTemp();
    insert("SUP", addrResult, addr2, addr1);
}

int ti_print(char * nomVar)
{
    int addr = chercherSymbole(nomVar);
    if (addr == -1)
    {
        printf("Erreur: Variable %s non déclarée\n", nomVar);
        return -1;
    }

    insert("PRI", addr, 0, 0);
    return 0;
}

void ti_print_nb(int nb)
{
    ajouterSymboleTemp();
    ti_arithmetic_nb(nb);
    int addr = getAddrDernierSymboleTemp();
    insert("PRI", addr, 0, 0);
    libererDernierSymboleTemp();
}

int ti_exporter(FILE * fichier)  
{

    for (int i = 0; i < indiceInstruction; i++)
    {
        fprintf(fichier, tableInstruct[i].nom, 3);
        fprintf(fichier, "\t");
        fprintf(fichier, "%d", tableInstruct[i].arg1);
        fprintf(fichier, "\t");
        fprintf(fichier, "%d", tableInstruct[i].arg2);
        fprintf(fichier, "\t");
        fprintf(fichier, "%d", tableInstruct[i].arg3);
        fprintf(fichier, "\n");
    }
    
    fclose(fichier);

    return 0;
}   