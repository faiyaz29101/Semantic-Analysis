#include "ScopeTabledeclaration.h"
#include<string.h>
ScopeTable::ScopeTable(int bucket){
    this->bucket = bucket;
    table = new SymbleInfo*[bucket];
    for(int i=0; i<bucket; i++){
        table[i] = nullptr;
    }
}
ScopeTable::~ScopeTable(){
    for(int i=0; i<bucket; i++){
        if(table[i] != nullptr){
            delete table[i];
            //cout<<i<<endl;
        }
    }
    delete[] table;
}
bool ScopeTable::insert(SymbleInfo symbleinfo){
    tempstring.clear();
     if(lookup(symbleinfo.getname()) != nullptr){
        tempstring = "Insertion Failed";
        //cout<<lookup(symbleinfo.getname())->getname()<<endl;
         return false;
     }
    int counter = 1;
    int hash = hashfunction(symbleinfo.getname());
    SymbleInfo *newtemp = new SymbleInfo(symbleinfo.getname(), symbleinfo.gettype());
    if(table[hash] == nullptr){
        table[hash] = newtemp;
        //counter++;
    }  else{
        counter++;
        SymbleInfo *temp = table[hash];
        while(temp->getnext() != nullptr){
            temp = temp->getnext();
            counter++;
    }
    temp->setnext(newtemp);
    }
    tempstring = "Inserted  at position <"+ to_string(hash+1) + ", "+ to_string(counter)+"> of ScopeTable# ";
    //cout<<tempstring;

    return true;
}
string ScopeTable::gettempstring(){
    return tempstring;
}
// int ScopeTable::hashfunction(string s){
//     return 5;
// }
string ScopeTable::print(){
    tempstring = "\tScopeTable# " + getID();
    for(int i=0; i<bucket; i++){
        tempstring.append("\n\t"+to_string(i+1));
        if(table[i] != nullptr){
            //tempstring.append(" --> ");
            SymbleInfo *pt = table[i];
            // cout<<pt->getname();
            // pt = pt->getnext();
            while(pt != nullptr){
                tempstring.append(" --> ");
                tempstring.append("("+pt->getname()+","+pt->gettype()+")");
                pt = pt->getnext();
                // cout<<"2"<<endl;
            }
        }
    }
    return tempstring.append("\n");
}
SymbleInfo* ScopeTable::lookup(string symbol){
    SymbleInfo *temp = table[hashfunction(symbol)];
    int counter = 1;
    tempstring = "";
        if(temp != nullptr){
            if(temp->getname().compare(symbol) == 0){
                tempstring = to_string(hashfunction(symbol)+1)+", "+to_string(counter);
                return temp;
            }
            else{
                temp = temp->getnext();
                counter++;
                while(temp != nullptr){
                    if(temp->getname().compare(symbol) == 0){
                        tempstring = to_string(hashfunction(symbol)+1)+", "+to_string(counter);
                        return temp;
                    }
                    temp = temp->getnext();
                    counter++;
                }
            }
        }
    
    return temp;
}
bool ScopeTable::Delete(string symbol){
    if(lookup(symbol) == nullptr){
        return false;
    }
    else{
        SymbleInfo *temp = nullptr;
        for(int i=0; i<bucket; i++){
            if(table[i] != nullptr){
                if(table[i]->getname().compare(symbol) == 0){
                    table[i] = table[i]->getnext();
                    return true;
                }else{
                temp = table[i];
                while(temp->getnext() != nullptr){
                    if(temp->getnext()->getname().compare(symbol) == 0){
                        temp->setnext(temp->getnext()->getnext());
                        return true;
                    }
                }
                }
            }
        }
    }
}

int ScopeTable::hashfunction(string symbol){


auto hash = static_cast<unsigned long long int>(0);
    auto len = symbol.length();

    for (auto i = 0; i < len; i++)
    {
        hash = (symbol[i]) + (hash << 6) + (hash << 16) - hash;
    }

    return hash % bucket;
}

string ScopeTable::getID(){
        return id;
}
void ScopeTable::setID(string s){
        this->id = s;
}
void ScopeTable::setParent(ScopeTable *parent){
    parentScope = parent;
}
ScopeTable* ScopeTable::getParent(){
    return parentScope;
}
void ScopeTable::setdelt(int delt){
    this->delt = delt;
}
int ScopeTable::getdelt(){
    return delt;
}
