#include<iostream>
#include<fstream>
#include<vector>
#include<sstream>
//#include "SymbleInfo.h"
//#include "ScopeTable.h"
#include "SymbolTable.h"
using namespace std;


std::vector<std::string> splitString(const std::string& input, char delimiter) {
    std::istringstream tokenStream(input);
    std::vector<std::string> tokens;
    std::string token;

    while (std::getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }

    return tokens;
}





int main(){
    string line;
    ifstream file("input.txt");
    ofstream ofile("output.txt");
    getline(file, line);
    SymbolTable st(stoi(line));
    ofile<<"\tScopeTable# 1 created\n";
    int lineno = 1;
    //ofile << line;
    while (getline(file, line)) {
        std::vector<std::string> tokens = splitString(line, ' ');
        ofile << "Cmd "<<lineno<<": ";
        ofile << line << endl;
            //ofile <<"\n"<<"Result:\n";
            if(tokens[0].compare("I") == 0){
                if(tokens.size() != 3){
                    ofile<<"\tWrong number of arugments for the command "<< tokens[0]<< endl;
                }else{
                    SymbleInfo temp(tokens[1], tokens[2]);
                    string s = st.insert(temp);
                    ofile <<"\t" << s <<endl;
                    //st.printCurrentScope();
                }
            }
           else if(tokens[0].compare("L") == 0){
                if(tokens.size() != 2){
                    ofile<<"\tWrong number of arugments for the command "<< tokens[0]<< endl;
                }else{
                    string s = "'"+tokens[1]+"' ";
                    s.append(st.lookup(tokens[1]));
                    ofile <<"\t" << s << endl;
                    
                }
             }
             else if(tokens[0].compare("D") == 0){
                if(tokens.size() != 2){
                    ofile<<"\tWrong number of arugments for the command "<< tokens[0]<< endl;
                }else{
                    string s;
                    s.append(st.remove(tokens[1]));
                    ofile <<"\t" << s << endl;
                    
                }
             }
             else if(tokens[0].compare("P") == 0){
                if(tokens.size() != 2){
                    ofile<<"\tWrong number of arugments for the command "<< tokens[0]<< endl;
                }else{
                    string s;
                    if(tokens[1].compare("A") == 0){
                         s = st.printAllScope(); 
                    }else if(tokens[1].compare("C") == 0){
                         s = st.printCurrentScope();
                    }
                    else{
                        s = "\tInvalid argument for the command P\n";
                    }
                    ofile <<s;
                    
                }
             }
             else if(tokens[0].compare("S") == 0){
                if(tokens.size() != 1){
                    ofile<<"\tWrong number of arugments for the command "<< tokens[0]<< endl;
                }else{
                    string s;
                    s = st.enterScope();
                    ofile << "\t" <<s << endl; 
                }
             }
              else if(tokens[0].compare("E") == 0){
                if(tokens.size() != 1){
                    ofile<<"\tWrong number of arugments for the command "<< tokens[0]<< endl;
                }else{
                    string s;
                    s = st.exitScope();
                    ofile << "\t" << s << endl; 
                }
             }
             else if(tokens[0].compare("Q") == 0){
                string s = st.finalDelete();
                ofile<<s<<endl;
             }
             lineno++;
    }
    file.close();
    ofile.close();
    return 0;
}