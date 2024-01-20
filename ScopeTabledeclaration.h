
#pragma once

#include <iostream>
#include "SymbleInfodeclaration.h"
using namespace std;

class ScopeTable{
    private:
    int bucket;
    SymbleInfo **table;
    string id = "1";
    int delt = 1;
    ScopeTable *parentScope = nullptr;
    string tempstring = " ";


    public:
    ScopeTable(int bucket);                   //
    ~ScopeTable();
    bool insert(SymbleInfo symbleinfo);       //
    SymbleInfo* lookup(string symbol);        //
    bool Delete(string symbol);               //
    string print();                             //
    int hashfunction(string symbol);          //
    string getID();                           //
    void setID(string s);                     //
    void setParent(ScopeTable *parent);
    ScopeTable* getParent();
    string gettempstring();
    void setdelt(int delt);
    int getdelt();
    


};
