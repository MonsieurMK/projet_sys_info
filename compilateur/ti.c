//Stack of instruction for our compiler

#include "ti.h"
#include "ts.h"

void ti_initTable()
{
    indiceInstruction = 0;
    tableInstruct = malloc(sizeof(instruction) * NB_INSTRUCTIONS_MAX);
}

char * ti_getLast(){
    return tableInstruct[indiceInstruction-1].nom;
}

void ti_libererTable(){
    free(tableInstruct);
}

void ti_insert(char * nom, int arg1, int arg2, int arg3)
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
    int addr = ts_getAddrDernierSymboleTemp();
    if(addr == -1){
        printf("Erreur: Pas assez de variables temporaires\n");
        exit(1);
    }
    ti_insert("AFC",addr,v,0);
}

void ti_arithmetic_var(int addr) {
    int addrResult = ts_ajouterSymboleTemp();
    ti_insert("COP", addrResult, addr, 0);
}

void ti_arithmetic_var_addr(int addr) {
    int addrResult = ts_ajouterSymboleTemp();
    ti_insert("AFC", addrResult, addr, 0);
}

void ti_arithmetic_pointer(int addr) {
    int addrResult = ts_ajouterSymboleTemp();
    ti_insert("LOA", addrResult, addr, 0);
}

void ti_arithmetic_add(){
    int addr = ts_getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    ts_libererDernierSymboleTemp();
    ti_insert("ADD",secondAddr,secondAddr,addr);
}

void ti_arithmetic_sub(){
    int addr = ts_getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    ts_libererDernierSymboleTemp();
    ti_insert("SUB",secondAddr,secondAddr,addr);
}

void ti_arithmetic_mul(){
    int addr = ts_getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    ts_libererDernierSymboleTemp();
    ti_insert("MUL",secondAddr,secondAddr,addr);
}

void ti_arithmetic_div(){
    int addr = ts_getAddrDernierSymboleTemp();
    int secondAddr = addr + 1;
    ts_libererDernierSymboleTemp();
    ti_insert("DIV",secondAddr,secondAddr,addr);
}

int ti_affect_var(char * nomVar, Type type) 
{
    int addr = ts_getAddrDernierSymboleTemp();
    int addrVar = ts_chercherSymbole(nomVar, type);
    if (addrVar == -1) 
    {
        printf("Erreur: Variable %s non déclarée\n", nomVar);
        return -1;
    }
    ts_libererDernierSymboleTemp();
    ti_insert("COP", addrVar, addr, 0);

    return 0;
}

int ti_affect_var_addr(char * nomVar)
{
    int addr = ts_getAddrDernierSymboleTemp();
    int addrVar = ts_chercherSymbole(nomVar, POINTER);
    if (addrVar == -1) 
    {
        printf("Erreur: Variable %s non déclarée ou pas un pointeur\n", nomVar);
        return -1;
    }
    ts_libererDernierSymboleTemp();
    ti_insert("STR", addrVar, addr, 0);

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
    ti_insert("JMP", 0, 0, 0);
    return indiceInstruction - 1;
}

int ti_inserer_jmpf(int addrCond)
{
    ti_insert("JMF", addrCond, 0, 0);
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
    int addr1 = ts_getAddrDernierSymboleTemp();
    int addr2 = addr1 + 1;
    int addrResult = ts_ajouterSymboleTemp();
    ti_insert("EQU", addrResult, addr2, addr1);
}

void ti_arithmetic_inf()
{
    int addr1 = ts_getAddrDernierSymboleTemp();
    int addr2 = addr1 + 1;
    int addrResult = ts_ajouterSymboleTemp();
    ti_insert("INF", addrResult, addr2, addr1);
}

void ti_arithmetic_sup()
{
    int addr1 = ts_getAddrDernierSymboleTemp();
    int addr2 = addr1 + 1;
    int addrResult = ts_ajouterSymboleTemp();
    ti_insert("SUP", addrResult, addr2, addr1);
}

int ti_print(char * nomVar)
{
    int addr = ts_chercherSymbole(nomVar, INT);
    if (addr == -1)
    {
        addr = ts_chercherSymbole(nomVar, POINTER);
        if (addr == -1)
        {
            printf("Erreur: Variable %s non declaree\n", nomVar);
            return -1;
        }
    }

    ti_insert("PRI", addr, 0, 0);
    return 0;
}

void ti_print_nb(int nb)
{
    ts_ajouterSymboleTemp();
    ti_arithmetic_nb(nb);
    int addr = ts_getAddrDernierSymboleTemp();
    ti_insert("PRI", addr, 0, 0);
    ts_libererDernierSymboleTemp();
}

int ti_print_addr(char * nomPt) {
    int addr = ts_chercherSymbole(nomPt, POINTER);
    if (addr == -1)
    {
        printf("Erreur: Variable %s non declaree ou pas un pointeur\n", nomPt);
        return -1;
    }
    
    int addrTemp = ts_ajouterSymboleTemp();
    ti_insert("LOA", addrTemp, addr, 0);
    ti_insert("PRI", addrTemp, 0, 0);
    ts_libererDernierSymboleTemp();
    return 0;
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