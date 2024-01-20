#pragma once
#include<iostream>


#include "ScopeTabledeclaration.h"
using namespace std;


class SymbolTable{
    private:
    ScopeTable* currentScopeTable;
    int bucket;
    string id = "1";
    
    public:
    SymbolTable(int bucket);
    ~SymbolTable();
    string enterScope();
    string exitScope();
    string insert(SymbleInfo symbleinfo);
    string remove(string symbol);
    string lookup(string symbol);
    string printCurrentScope();
    string printAllScope();
    string finalDelete();
    string add(string a, string b);
    bool findfromcurrent(string s);

};

