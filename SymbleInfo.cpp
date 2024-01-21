#pragma once
#include "SymbleInfodeclaration.h"
SymbleInfo :: SymbleInfo(const string &name, const string &type){
    this->name = name;
    this->type = type;
}
const string SymbleInfo::getname(){
    return name;
}
const string SymbleInfo::gettype(){
    return type;
}
void SymbleInfo::setnext(SymbleInfo* next){
    this->next = next;
}
SymbleInfo* SymbleInfo::getnext(){
    return next;
}
SymbleInfo:: ~SymbleInfo() {}
void SymbleInfo:: print(){
    //cout<< name << "  " << type << endl;
}

void SymbleInfo:: addToList(SymbleInfo* symbleinfo){
    symbolinfolist.push_back(symbleinfo);
}

vector<SymbleInfo*> SymbleInfo:: getList(){
        return symbolinfolist;
    }
void SymbleInfo:: setline(int line){
    this->line = line;
}
int SymbleInfo:: getline(){
    return line;
}

SymbleInfo::SymbleInfo() {}
