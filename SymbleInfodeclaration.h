#pragma once
#include<iostream>
using namespace std;

class SymbleInfo{
    private:
    string name;
    string type;
    SymbleInfo* next = nullptr;
    
    public:
    SymbleInfo();
    SymbleInfo(const string &name, const string &type);
    ~SymbleInfo();
    const string getname();
    const string gettype();
    SymbleInfo* getnext();
    void setnext(SymbleInfo* next);
    void print();


};
