%option noyywrap

%x STRING_STATE
%x MULTI_COMMENT_STATE
%x SINGLE_COMMENT_STATE

%{
#include<iostream>
#include <fstream>
#include "SymbolTabledeclaration.h"

#include "y.tab.h"

using namespace std;

int line_count = 1;
int error_count = 0;
int warning_count = 0;
extern ofstream logout;
ofstream logprint;
ofstream tokenprint;
string string_log;
string string_token;
int lc = 0;
int check_string =0;
string com;
int temp_line = 0;



int bucket_size = 10;
// SymbolTable symbolTable(bucket_size);


string UpperCase(string s){
	for(int i=0;i<s.length();i++){
		if(s[i]>='a' && s[i]<='z'){
			s[i] = s[i] - 32;
		}
	}
	return s;
}
char processChar(const char* s){
    if( strlen(s) == 3 ) return s[1];
    if( s[2] == 'n' ) return '\n';
    if( s[2] == 't' ) return '\t';
   if( s[2] == '\\' ) return '\\';
    if( s[2] == 'a' ) return '\a';
    if( s[2] == 'f' ) return '\f';
    if( s[2] == 'r' ) return '\r';
    if( s[2] == 'b' ) return '\b';
    if( s[2] == 'v' ) return '\v';
   if( s[2] == '0' ) return '\0';
    if( s[2] == '\"' ) return '\"';
}

void lexeme_details_out(string s1, string s2){
        logout<<"Line# "<<line_count<<": Token <"<<s1<<"> Lexeme "<<s2<<" found"<<endl;
    }



%}

LETTER [a-zA-Z]
DIGIT [0-9]
WHITESPACE [ \t]
EMPTY_CHAR_ERROR ''
INTEGER ([1-9]+)([0-9])*|0
FLOAT([0-9]*)\.([0-9]+)
EXPONENT1 ([0-9]+([E][\+\-]?[0-9]+))
EXPONENT2 ([0-9]*(\.[0-9]+)([E][\+\-]?[0-9]+)?)
IDENTIFIERS [A-Za-z_][A-Za-z0-9_]*
CHARACTER_LITERALS1 \'([a-zA-Z])\'
STRING /"([a-zA-Z0-9 ]*)
CHARACTER_LITERALS2 \'(\\[ntrabv0\"])\'


%%
"if" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return IF;
}
"else" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return ELSE;
}
"for" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return FOR;
}
"while" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return WHILE;
}
"do" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return DO;
}
"break" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return BREAK;
}
"char" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return CHAR;
}
"double" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return DOUBLE;
}
"return" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return RETURN;
}
"switch" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return SWITCH;
}
"case" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return CASE;
}
"default" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return DEFAULT;
}
"continue" {
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return CONTINUE;
}
"printf"	{
    yylval.symbleInfo =  new SymbleInfo(yytext, "KEYWORD");
    lexeme_details_out("KEYWORD", yytext);
    return PRINTLN;
}

"int" { 
	yylval.symbleInfo = new  SymbleInfo(yytext, "INT"); 
    lexeme_details_out("INT", yytext);
	return INT;
}
"float" { 
	yylval.symbleInfo = new  SymbleInfo(yytext, "FLOAT"); 
    lexeme_details_out("FLOAT", yytext);
	return FLOAT;
}
"void" { 
	yylval.symbleInfo = new  SymbleInfo(yytext, "VOID"); 
    lexeme_details_out("VOID", yytext);
	return VOID;
}





 /* {KEYWORD} {
		tokenprint << "<" << UpperCase(yytext) << ", " << yytext << ">"<<endl;
		logprint << "Line# " << line_count << ": Token <"<< UpperCase(yytext)<<"> Lexeme "<<yytext<<" found" << endl;
	}  */
{INTEGER} {
    //cout<<"there0"<<endl;
	//tokenprint << "<" << "CONST_INT" << ", " << yytext << ">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<CONST_INT>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "CONST_INT");
    lexeme_details_out("CONST_INT", yytext);
    return CONST_INT;
}
{FLOAT} {
	//tokenprint << "<" << "CONST_FLOAT" << ", " << yytext << ">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "CONST_FLOAT");
    lexeme_details_out("CONST_FLOAT", yytext);
    return CONST_FLOAT;
}
{EXPONENT1} {
	//tokenprint << "<" << "CONST_FLOAT" << ", " << yytext << ">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "CONST_FLOAT");
    lexeme_details_out("CONST_FLOAT", yytext);
    return CONST_FLOAT;
}
{EXPONENT2} {
	//tokenprint << "<" << "CONST_FLOAT" << ", " << yytext << ">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "CONST_FLOAT");
    lexeme_details_out("CONST_FLOAT", yytext);
    return CONST_FLOAT;
}
{CHARACTER_LITERALS1} {
	//tokenprint << "<" << "CONST_CHAR" << ", " << processChar(yytext) << ">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<CONST_CHAR>"<<" Lexeme "<<processChar(yytext)<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "CHAR");
    lexeme_details_out("CHAR", yytext);
    return CHAR;
}
{CHARACTER_LITERALS2} {
	//tokenprint << "<" << "CONST_CHAR" << ", " << processChar(yytext) << ">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<CONST_CHAR>"<<" Lexeme "<<processChar(yytext)<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "CHAR");
    lexeme_details_out("CHAR", yytext);
    return CHAR;
}
{WHITESPACE} {

}
"+"|"-" {
    //tokenprint<<"<ADDOP, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<ADDOP>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "ADDOP");
    lexeme_details_out("ADDOP", yytext);
    return ADDOP;
}
"*"|"/"|"%"  {
    //tokenprint<<"<MULOP, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<MULOP>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "MULOP");
    lexeme_details_out("MULOP", yytext);
    return MULOP;
}
"++"|"--"  {
    //tokenprint<<"<INCOP, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<INCOP>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "INCOP");
    lexeme_details_out("INCOP", yytext);
    return INCOP;
}
"<"|"<="|">"|">="|"=="|"!="  {
    //tokenprint<<"<RELOP, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<RELOP>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "RELOP");
    lexeme_details_out("RELOP", yytext);
    return RELOP;
}
"="  {
    //tokenprint<<"<ASSIGNOP, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<ASSIGNOP>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "ASSIGNOP");
    lexeme_details_out("ASSIGNOP", yytext);
    return ASSIGNOP;
}
"&&"|"||"  {
    //tokenprint<<"<BITOP, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<BITOP>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "LOGICOP");
    lexeme_details_out("LOGICOP", yytext);
    return LOGICOP;
}

"!"  {
    //tokenprint<<"<NOT, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<NOT>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "NOT");
    lexeme_details_out("NOT", yytext);
    return NOT;
}
"("  {
    //tokenprint<<"<LPAREN, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<LPAREN>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "LPAREN");
    lexeme_details_out("LPAREN", yytext);
    return LPAREN;
}
")"  {
    //tokenprint<<"<RPAREN, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<RPAREN>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "RPAREN");
    lexeme_details_out("RPAREN", yytext);
    return RPAREN;
}
"{"  {
    //cout<<"there340"<<endl;
    //tokenprint<<"<LCURL, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<LCURL>"<<" Lexeme "<<yytext<<" found"<<endl;
	////logprint<<symbolTable.printAllScope();
   // symbolTable.enterScope();
   yylval.symbleInfo = new SymbleInfo(yytext, "LCURL");
    lexeme_details_out("LCURL", yytext);
    return LCURL;
}
"}"  {
    //cout<<"there0"<<endl;
    //tokenprint<<"<RCURL, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<RCURL>"<<" Lexeme "<<yytext<<" found"<<endl;
	//symbolTable.exitScope();
    //logprint<<symbolTable.printAllScope();
    yylval.symbleInfo = new SymbleInfo(yytext, "RCURL");
    lexeme_details_out("RCURL", yytext);
    return RCURL;
}
"["  {
    //tokenprint<<"<LSQUARE, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<LSQUARE>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "LSQUARE");
    lexeme_details_out("LSQUARE", yytext);
    return LSQUARE;
}
"]"  {
    //tokenprint<<"<RSQUARE, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<RSQUARE>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "RSQUARE");
    lexeme_details_out("RSQUARE", yytext);
    return RSQUARE;
}
","  {
    //tokenprint<<"<COMMA, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<COMMA>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "COMMA");
    lexeme_details_out("COMMA", yytext);
    return COMMA;
}
";"  {
    //tokenprint<<"<SEMICOLON, "<<yytext<<">"<<endl;
    //logprint<<"Line# "<< line_count <<": Token " <<"<SEMICOLON>"<<" Lexeme "<<yytext<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(yytext, "SEMICOLON");
    lexeme_details_out("SEMICOLON", yytext);
    return SEMICOLON;
}

{IDENTIFIERS} {
		//tokenprint << "<" << "ID" << ", " << yytext << ">"<<endl;
		//logprint << "Line# " << line_count << ": Token <"<< "ID"<<"> Lexeme "<<yytext<<" found" << endl;
        yylval.symbleInfo = new SymbleInfo(yytext, "ID");
    lexeme_details_out("ID", yytext);
        return ID;
        // if(!symbolTable.findfromcurrent(yytext)){
        //   //  symbolTable.add(yytext, "ID");
		//     //logprint<<symbolTable.printAllScope();
        // }else{
        //     //logprint<<"\t"<<yytext<< " already exists in the current ScopeTable"<<endl;
        // }

	}

\/\/ {
    com = yytext;
    temp_line = line_count;
    BEGIN SINGLE_COMMENT_STATE;
}
<SINGLE_COMMENT_STATE>.* {
    com+=yytext;
    line_count++;
}
<SINGLE_COMMENT_STATE>.*\\\n {
    com+=yytext;
    line_count++;
}
<SINGLE_COMMENT_STATE>.*\n {
    com+=yytext;
    com.erase(com.length()-1);
//    //tokenprint<<"<SINGLE LINE COMMENT, "<<com<<">"<<endl;
    //logprint<<"Line# "<< temp_line <<": Token " <<"<SINGLE LINE COMMENT>"<<" Lexeme "<<com<<" found"<<endl;
    line_count++;
    BEGIN INITIAL;
}



"\n" {
		line_count++;
}
\/\* {

    com = "/*";
    BEGIN MULTI_COMMENT_STATE;
    temp_line = line_count;
}
<MULTI_COMMENT_STATE>.(\*)*\n {
    com+=yytext;
    line_count++;
}
<MULTI_COMMENT_STATE>.(\*)* {
    com+=yytext;
}
<MULTI_COMMENT_STATE>.*\*\/ {
    com+=yytext;
    //logprint<<"Line# "<< temp_line <<": Token " <<"<MULTI LINE COMMENT>"<<" Lexeme "<<com<<" found"<<endl;
    BEGIN INITIAL;
}
<MULTI_COMMENT_STATE><<EOF>> {
    error_count++;
    //logprint<<"Error at line# "<<line_count<<": UNFINISHED_COMMENT "<<com<<endl;
    BEGIN INITIAL;
    //line_count++;
}


<STRING_STATE>\\t  {
     string_log+="\\t";
     string_token+="\t";
     line_count++;
}
<STRING_STATE>[a-zA-Z0-9 ]* {
    string_log+=yytext;
    string_token+=yytext;
}
<STRING_STATE>\\\n  {
    string_log+="\\";
    string_log+="\n\t";
    string_token+='\t';
    line_count++;
    check_string=1;
}

<STRING_STATE>\\r  {
    string_log+="\r";
    string_token+="\r";
    line_count++;
}

<STRING_STATE>[\r]?\n {
    error_count++;
    //logprint<<"Error at line# "<<line_count<<": UNFINISHED_STRING "<<string_log<<endl;
    line_count+=lc+1;
    BEGIN INITIAL;
}
<STRING_STATE><<EOF>> {
    error_count++;
    //logprint<<"Error at line# "<<line_count<<": UNFINISHED_STRING "<<string_log<<endl;
    line_count++;
    BEGIN INITIAL;
}
<STRING_STATE>\\\\ {
    string_log+="\\\\";
    string_token+="\\";
}
<STRING_STATE>\\a {
    string_log+="\\a";
    string_token+="\a";
}

<STRING_STATE>\\b {
    string_log+="\\b";
    string_token+="\b";
}
<STRING_STATE>\\v {
    string_log+="\\v";
    string_token+="\v";
}
<STRING_STATE>\\0 {
    string_log+="\\0";
    string_token+="\0";
}


\" {
   lc = 0;
   string_log = "\"";
   string_token = "\"";
   temp_line = line_count;
   BEGIN STRING_STATE;
}
<STRING_STATE>\"  {
    string_log+="\"";
    string_token+="\"";
    if(check_string==0){
    //tokenprint<<"<SINGLE LINE STRING, "<<string_token<<">"<<endl;
    //logprint<<"Line# "<< temp_line <<": Token " <<"<SINGLE LINE STRING>"<<" Lexeme "<<string_log<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(string_log, "SINGLE LINE STRING");
    line_count+=lc-1;
    }else{
    //tokenprint<<"<MULTI LINE STRING, "<<string_token<<">"<<endl;
    //logprint<<"Line# "<< temp_line <<": Token " <<"<MULTI LINE STRING>"<<" Lexeme "<<string_log<<" found"<<endl;
    yylval.symbleInfo = new SymbleInfo(string_log, "MULTI LINE STRING");
    check_string=0;
    line_count+=lc;
    }
    BEGIN INITIAL;
}


[0-9]*\.[0-9]*?[\.0-9]* {
    //logprint <<"Error at line# "<<line_count<<": TOO_MANY_DECIMAL_POINTS "<<yytext<<endl;
    error_count++;
}
[0-9]*\.?[0-9]*[E][/+\-]?[\.0-9]* {
    //logprint << "Error at line# "<<line_count<<": ILLFORMED_NUMBER "<<yytext<<endl;
    error_count++;
}
[0-9]+[a-zA-Z _]+ {
    //logprint << "Error at line# "<<line_count<<": INVALID_ID_SUFFIX_NUM_PREFIX "<<yytext<<endl;
    error_count++;
}
\'[a-zA-Z]+[a-zA-z0-9 ]+\' {
    //logprint << "Error at line# "<<line_count<<": MULTICHAR_CONST_CHAR "<<yytext<<endl;
    error_count++;
}
\'[a-zA-Z]+";"?\n {
    string s = yytext;
    s.erase(s.length()-1);
    //logprint << "Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<s<<endl;
    error_count++;
    line_count++;
}
\'";"?\n {
    string s = yytext;
    s.erase(s.length()-1);
    //logprint << "Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<s<<endl;
    error_count++;
    line_count++;
}
\'\\\' {
    //logprint << "Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<yytext<<endl;
    error_count++;
}
\'\' {
    //logprint << "Error at line# "<<line_count<<": EMPTY_CONST_CHAR "<<yytext<<endl;
    error_count++;
}
. {
    //logprint << "Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<yytext<<endl;
    error_count++;
}


%%
