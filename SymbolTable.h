#include "SymbolTabledeclaration.h"
#include <string>
SymbolTable::SymbolTable(int bucket)
{
    this->bucket = bucket;
    currentScopeTable = new ScopeTable(bucket);
}
string SymbolTable::enterScope()
{
    string s = "ScopeTable# ";
    ScopeTable *temp = new ScopeTable(bucket);
    temp->setID(currentScopeTable->getID().append("." + to_string(currentScopeTable->getdelt())));
    temp->setParent(currentScopeTable);
    currentScopeTable = temp;
    s.append(temp->getID() + " created");
    return s;
}
string SymbolTable::exitScope()
{
    if (currentScopeTable->getParent() == nullptr)
    {
        //delt--;
        return "ScopeTable# 1 cannot be deleted";
    }
    string s = "ScopeTable# " + currentScopeTable->getID() + " deleted";
    currentScopeTable = currentScopeTable->getParent();
    currentScopeTable->setdelt((currentScopeTable->getdelt())+1);
    //delt++;
    // currentScopeTable->setParent(nullptr);
    return s;
}
string SymbolTable::insert(SymbleInfo symbleinfo)
{
    bool f = currentScopeTable->insert(symbleinfo);
    string s = currentScopeTable->gettempstring();
    if (f)
    {
        s.append(currentScopeTable->getID());
    }
    else{
        return ("'"+symbleinfo.getname()+"' already exists in the current ScopeTable# "+currentScopeTable->getID());
    }
    return s;
}
string SymbolTable::add(string a, string b){
    SymbleInfo temp(a,b);
    string s = insert(temp);
    return s;
}
string SymbolTable::remove(string symbol)
{
    string s = "Deleted '" + symbol + "' from position <";
    if (currentScopeTable->lookup(symbol))
    {
        s.append(currentScopeTable->gettempstring() + "> of ScopeTable# " + currentScopeTable->getID());
        currentScopeTable->Delete(symbol);
        return s;
    }
    else
    {
        s = "Not found in the current ScopeTable# " + currentScopeTable->getID();
        return s;
    }
}
bool SymbolTable::findfromcurrent(string s){
    return currentScopeTable->lookup(s);
}
string SymbolTable::lookup(string symbol)
{
    string s = "found at position <";
    int counter = 1;
    if (currentScopeTable->lookup(symbol))
    {
        s.append(currentScopeTable->gettempstring().append("> of ScopeTable# " + id));
        return s;
    }
    else
    {
        ScopeTable *temp = currentScopeTable->getParent();
        while (temp != nullptr)
        {
            if (temp->lookup(symbol))
            {
                s.append(temp->gettempstring().append("> of ScopeTable# " + temp->getID()));
                return s;
            }
            temp = temp->getParent();
            counter++;
        }
        return "not found in any of the ScopeTables";
    }
}
string SymbolTable::printCurrentScope()
{
   // ScopeTable *sc = currentScopeTable;
   // string s = "ScopeTable# " + currentScopeTable->getID();
    return currentScopeTable->print();
}
string SymbolTable::printAllScope()
{
    ScopeTable *sc = currentScopeTable;
    string s;
    while (sc != nullptr)
    {
        //s.append("ScopeTable# " + sc->getID());
        s.append(sc->print());
        sc = sc->getParent();
    }
    return s;
}
SymbolTable::~SymbolTable() {
     while(currentScopeTable != nullptr)
    {
        ScopeTable* parent = currentScopeTable->getParent();
        delete currentScopeTable;
        currentScopeTable = parent;
    }
}
string SymbolTable::finalDelete(){
    string s;
    while(currentScopeTable != nullptr)
    {
        s.append("\tScopeTable# "+currentScopeTable->getID()+" deleted\n");
        ScopeTable* parent = currentScopeTable->getParent();
        delete currentScopeTable;
        currentScopeTable = parent;
    }
    return s;
}
