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
SymbleInfo::SymbleInfo() {}
