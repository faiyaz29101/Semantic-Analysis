#pragma once
#include<iostream>
#include <vector>
using namespace std;

class SymbleInfo{
    private:
    string name;
    string type;
    SymbleInfo* next = nullptr;
    vector <SymbleInfo*> symbolinfolist;
    int line;
    
    public:
    SymbleInfo();
    SymbleInfo(const string &name, const string &type);
    ~SymbleInfo();
    const string getname();
    const string gettype();
    SymbleInfo* getnext();
    void setnext(SymbleInfo* next);
    void print();
    void addToList(SymbleInfo* symbleinfo);
    vector<SymbleInfo*> getList();
    void setline(int line);
    int getline();

};
