%{
    #include<iostream>
    #include<fstream>
    #include<vector>
    //#include "SymbolTable.h"
    #include "SymbolTabledeclaration.h"

    using namespace std;

    ofstream logout;
    ofstream errorout;
    ofstream parseTree;

    SymbolTable *symbolTable = new SymbolTable(11);
    extern int line_count;
    extern FILE *yyin;

    void yyerror(char *s){
        logout << "Syntax Error" << endl;
    }

    void grammar_output(string top, string bottom){
        logout<<top<<" : "<<bottom<<endl;
    }
    
    void yyerror(string msg){
        errorout<<"Line# "<<line_count<<": "<<msg<<endl;
    }
    void print(SymbleInfo* sym, int line_no, int depth){
        for(int k=0; k<depth;k++){
            parseTree<<" ";
        }
        parseTree<<sym->getname()<<" : "<<sym->gettype()<<endl;
        vector<SymbleInfo*>  l = sym->getList();
        depth++;
        if(l.size()!=0){
            for(int i = 0; i<l.size(); i++){
                    print(l[i], line_no, depth);
            }
        }
    }



    extern int yylex();
    extern int yyparse();
    //extern int line_count;
    %}



%union{
    SymbleInfo *symbleInfo;
}
%token<symbleInfo> IF ELSE LOWER_THAN_ELSE FOR WHILE DO BREAK CHAR DOUBLE RETURN LSQUARE RSQUARE SWITCH CASE DEFAULT CONTINUE PRINTLN INCOP DECOP ASSIGNOP NOT LPAREN RPAREN WHITESPACE LCURL RCURL COMMA SEMICOLON INT FLOAT VOID CONST_INT CONST_FLOAT ID ADDOP MULOP RELOP LOGICOP CONST_CHAR
%type<symbleInfo> start program unit func_declaration func_definition parameter_list compound_statement var_declaration type_specifier declaration_list statements statement expression_statement variable expression logic_expression rel_expression simple_expression term unary_expression factor argument_list arguments

%left LOGICOP
%left RELOP
%left ADDOP
%left MULOP
%right NOT
%right INCOP DECOP

%%
start : program {
   // grammar_output("start","program");
    $$ = new SymbleInfo("start","program");
    //cout <<"Here"<<endl;
    $$->addToList($1);
    $$->setline(line_count);
    //cout<<"OK";
    print($$, 1, 0);
    //////lexeme_details_out("")
}
program : program unit {
    grammar_output("program","program unit");
    $$ = new SymbleInfo("program","program unit");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
| unit {
    grammar_output("program","unit");
    $$ = new SymbleInfo("program","unit");
    $$->addToList($1);
    $$->setline(line_count);
}
;
unit : var_declaration {
    grammar_output("unit","var_declaration");
    $$ = new SymbleInfo("unit","var_declaration");
    $$->addToList($1);
    $$->setline(line_count);
}
| func_declaration {
    grammar_output("unit","func_declaration");
    $$ = new SymbleInfo("unit","func_declaration");
    $$->addToList($1);
    $$->setline(line_count);
}
| func_definition {
    grammar_output("unit","func_definition");
    $$ = new SymbleInfo("unit","func_definition");
    $$->addToList($1);
    $$->setline(line_count);
}
;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
    grammar_output("func_declaration","type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
    $$ = new SymbleInfo("func_declaration","type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->addToList($6);
    $$->setline(line_count);
}
| type_specifier ID LPAREN RPAREN SEMICOLON {
    grammar_output("func_declaration","type_specifier ID LPAREN RPAREN SEMICOLON");
    $$ = new SymbleInfo("func_declaration","type_specifier ID LPAREN RPAREN SEMICOLON");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->setline(line_count);
}
;
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement {
    grammar_output("func_definition","type_specifier ID LPAREN parameter_list RPAREN compound_statement");
    $$ = new SymbleInfo("func_definition","type_specifier ID LPAREN parameter_list RPAREN compound_statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->addToList($6);
    $$->setline(line_count);
}
| type_specifier ID LPAREN RPAREN compound_statement {
    grammar_output("func_definition","type_specifier ID LPAREN RPAREN compound_statement");
    $$ = new SymbleInfo("func_definition","type_specifier ID LPAREN RPAREN compound_statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->setline(line_count);
}
;
parameter_list : parameter_list COMMA type_specifier ID {
    grammar_output("parameter_list","parameter_list COMMA type_specifier ID");
    $$ = new SymbleInfo("parameter_list","parameter_list COMMA type_specifier ID");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->setline(line_count);
}
| parameter_list COMMA type_specifier {
    grammar_output("parameter_list","parameter_list COMMA type_specifier");
    $$ = new SymbleInfo("parameter_list","parameter_list COMMA type_specifier");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
| type_specifier ID {
    grammar_output("parameter_list","type_specifier ID");
    $$ = new SymbleInfo("parameter_list","type_specifier ID");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
| type_specifier {
    grammar_output("parameter_list","type_specifier");
    $$ = new SymbleInfo("parameter_list","type_specifier");
    $$->addToList($1);
    $$->setline(line_count);
}
;
compound_statement : LCURL statements RCURL {
    //cout<<"here-1"<<endl;
    symbolTable->enterScope();
    logout<<symbolTable->printAllScope()<<endl;
    symbolTable->exitScope();
    grammar_output("compound_statement","LCURL statements RCURL");
    $$ = new SymbleInfo("compound_statement","LCURL statements RCURL");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
| LCURL RCURL {
    symbolTable->enterScope();
    symbolTable->exitScope();
    logout<<symbolTable->printCurrentScope()<<endl;
    grammar_output("compound_statement","LCURL RCURL");
    $$ = new SymbleInfo("compound_statement","LCURL RCURL");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
;
var_declaration : type_specifier declaration_list SEMICOLON {
    grammar_output("var_declaration","type_specifier declaration_list SEMICOLON");
    $$ = new SymbleInfo("var_declaration","type_specifier declaration_list SEMICOLON");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
type_specifier : INT {
    symbolTable->insert(*$1);
    grammar_output("type_specifier","INT");
    $$ = new SymbleInfo("type_specifier","INT");
    $$->addToList($1);
    $$->setline(line_count);
}
| FLOAT {
    symbolTable->insert(*$1);
    grammar_output("type_specifier","FLOAT");
    $$ = new SymbleInfo("type_specifier","FLOAT");
    $$->addToList($1);
}
| VOID {
    symbolTable->insert(*$1);
    grammar_output("type_specifier","VOID");
    $$ = new SymbleInfo("type_specifier","VOID");
    $$->addToList($1);
}
;
declaration_list : declaration_list COMMA ID {
    grammar_output("declaration_list","declaration_list COMMA ID");
    $$ = new SymbleInfo("declaration_list","declaration_list COMMA ID");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
| declaration_list COMMA ID LSQUARE CONST_INT RSQUARE {
    grammar_output("declaration_list","declaration_list COMMA ID LSQUARE CONST_INT RSQUARE");
    $$ = new SymbleInfo("declaration_list","declaration_list COMMA ID LSQUARE CONST_INT RSQUARE");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->addToList($6);
    $$->setline(line_count);
}
| ID {
    grammar_output("declaration_list","ID");
    $$ = new SymbleInfo("declaration_list","ID");
    $$->addToList($1);
    $$->setline(line_count);
}
| ID LSQUARE CONST_INT RSQUARE {
    grammar_output("declaration_list","ID LSQUARE CONST_INT RSQUARE");
    $$ = new SymbleInfo("declaration_list","ID LSQUARE CONST_INT RSQUARE");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->setline(line_count);
}
;
statements : statement {
    grammar_output("statements","statement");
    $$ = new SymbleInfo("statements","statement");
    $$->addToList($1);
    $$->setline(line_count);
}
| statements statement {
    grammar_output("statements","statements statement");
    $$ = new SymbleInfo("statements","statements statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
;
statement : var_declaration {
    grammar_output("statement","var_declaration");
    $$ = new SymbleInfo("statement","var_declaration");
    $$->addToList($1);
    $$->setline(line_count);
}
| expression_statement {
    //cout<<"here0"<<endl;
    grammar_output("statement","expression_statement");
    $$ = new SymbleInfo("statement","expression_statement");
    $$->addToList($1);
    $$->setline(line_count);
}
| compound_statement {
    grammar_output("statement","compound_statement");
    $$ = new SymbleInfo("statement","compound_statement");
    $$->addToList($1);
    $$->setline(line_count);
}
| FOR LPAREN expression_statement expression_statement expression RPAREN statement {
    grammar_output("statement","FOR LPAREN expression_statement expression_statement expression RPAREN statement");
    $$ = new SymbleInfo("statement","FOR LPAREN expression_statement expression_statement expression RPAREN statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->addToList($6);
    $$->addToList($7);
    $$->setline(line_count);
}
| IF LPAREN expression RPAREN statement {
    grammar_output("statement","IF LPAREN expression RPAREN statement");
    $$ = new SymbleInfo("statement","IF LPAREN expression RPAREN statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->setline(line_count);

}
| IF LPAREN expression RPAREN statement ELSE statement {
    grammar_output("statement","IF LPAREN expression RPAREN statement ELSE statement");
    $$ = new SymbleInfo("statement","IF LPAREN expression RPAREN statement ELSE statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->addToList($6);
    $$->addToList($7);
    $$->setline(line_count);
}
| WHILE LPAREN expression RPAREN statement {
    grammar_output("statement","WHILE LPAREN expression RPAREN statement");
    $$ = new SymbleInfo("statement","WHILE LPAREN expression RPAREN statement");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->setline(line_count);
}
| PRINTLN LPAREN ID RPAREN SEMICOLON {
    grammar_output("statement","PRINTLN LPAREN ID RPAREN SEMICOLON");
    $$ = new SymbleInfo("statement","PRINTLN LPAREN ID RPAREN SEMICOLON");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->addToList($5);
    $$->setline(line_count);
}
| RETURN expression SEMICOLON {
    grammar_output("statement","RETURN expression SEMICOLON");
    $$ = new SymbleInfo("statement","RETURN expression SEMICOLON");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
expression_statement : SEMICOLON {
    grammar_output("expression_statement","SEMICOLON");
    $$ = new SymbleInfo("expression_statement","SEMICOLON");
    $$->addToList($1);
    $$->setline(line_count);
}
| expression SEMICOLON {
    //cout<<"here1"<<endl;
    grammar_output("expression_statement","expression SEMICOLON");
    $$ = new SymbleInfo("expression_statement","expression SEMICOLON");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
;
variable : ID {
    grammar_output("variable","ID");
    $$ = new SymbleInfo("variable","ID");
    $$->addToList($1);
    $$->setline(line_count);
}
| ID LSQUARE expression RSQUARE {
    grammar_output("variable","ID LSQUARE expression RSQUARE");
    $$ = new SymbleInfo("variable","ID LSQUARE expression RSQUARE");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->setline(line_count);
}
;
expression : logic_expression {
    //cout<<"here2"<<endl;
    grammar_output("expression","logic_expression");
    $$ = new SymbleInfo("expression","logic_expression");
    $$->addToList($1);
    $$->setline(line_count);
}
| variable ASSIGNOP logic_expression {
    grammar_output("expression","variable ASSIGNOP logic_expression");
    $$ = new SymbleInfo("expression","variable ASSIGNOP logic_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
logic_expression : rel_expression {
    //cout<<"here3"<<endl;
    grammar_output("logic_expression","rel_expression");
    $$ = new SymbleInfo("","logic_expression");
    $$->addToList($1);
    $$->setline(line_count);
}
| rel_expression LOGICOP rel_expression {
    //cout<<"here4"<<endl;
    grammar_output("logic_expression","rel_expression LOGICOP rel_expression");
    $$ = new SymbleInfo("logic_expression","rel_expression LOGICOP rel_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
rel_expression : simple_expression {
    //cout<<"here5"<<endl;
    grammar_output("rel_expression","simple_expression");
    $$ = new SymbleInfo("rel_expression","simple_expression");
    $$->addToList($1);
    $$->setline(line_count);
}
| simple_expression RELOP simple_expression {
    //cout<<"here6"<<endl;
    grammar_output("rel_expression","simple_expression RELOP simple_expression");
    $$ = new SymbleInfo("rel_expression","simple_expression RELOP simple_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
simple_expression : term {
    //cout<<"here7"<<endl;
    grammar_output("simple_expression","term");
    $$ = new SymbleInfo("simple_expression","term");
    $$->addToList($1);
    $$->setline(line_count);
}
| simple_expression ADDOP term {
    grammar_output("simple_expression","simple_expression ADDOP term");
    $$ = new SymbleInfo("simple_expression","simple_expression ADDOP term");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
term : unary_expression {
    //cout<<"here8"<<endl;
    grammar_output("term","unary_expression");
    $$ = new SymbleInfo("term","unary_expression");
    $$->addToList($1);
    $$->setline(line_count);
}
| term MULOP unary_expression {
    grammar_output("term","term MULOP unary_expression");
    $$ = new SymbleInfo("term","term MULOP unary_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
;
unary_expression : ADDOP unary_expression {
    grammar_output("unary_expression","ADDOP unary_expression");
    $$ = new SymbleInfo("unary_expression","ADDOP unary_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
| NOT unary_expression {
    grammar_output("unary_expression","NOT unary_expression");
    $$ = new SymbleInfo("unary_expression","NOT unary_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
| factor {
    //cout<<"here9"<<endl;
    grammar_output("unary_expression","factor");
    $$ = new SymbleInfo("unary_expression","factor");
    $$->addToList($1);
    $$->setline(line_count);
}
;
factor : variable {
    //cout<<"here10"<<endl;
    grammar_output("factor","variable");
    $$ = new SymbleInfo("factor","variable");
    $$->addToList($1);
    $$->setline(line_count);
}
| ID LPAREN argument_list RPAREN {
    grammar_output("factor","ID LPAREN argument_list RPAREN");
    $$ = new SymbleInfo("factor","ID LPAREN argument_list RPAREN");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->addToList($4);
    $$->setline(line_count);
}
| LPAREN expression RPAREN {
    grammar_output("factor","LPAREN expression RPAREN");
    $$ = new SymbleInfo("factor","LPAREN expression RPAREN");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
| CONST_INT {
   // cout<<"here10"<<endl;
    grammar_output("factor","CONST_INT");
    $$ = new SymbleInfo("factor","CONST_INT");
    $$->addToList($1);
    $$->setline(line_count);
}
| CONST_FLOAT {
    grammar_output("factor","CONST_FLOAT");
    $$ = new SymbleInfo("factor","CONST_FLOAT");
    $$->addToList($1);
    $$->setline(line_count);
}
| variable INCOP {
    grammar_output("factor","variable INCOP");
    $$ = new SymbleInfo("factor","variable INCOP");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
| variable DECOP {
    grammar_output("factor","variable DECOP");
    $$ = new SymbleInfo("factor","variable DECOP");
    $$->addToList($1);
    $$->addToList($2);
    $$->setline(line_count);
}
;
argument_list : arguments {
    grammar_output("argument_list","arguments");
    $$ = new SymbleInfo("argument_list","arguments");
    $$->addToList($1);
    $$->setline(line_count);
}
;
arguments : arguments COMMA logic_expression {
    grammar_output("arguments","arguments COMMA logic_expression");
    $$ = new SymbleInfo("arguments","arguments COMMA logic_expression");
    $$->addToList($1);
    $$->addToList($2);
    $$->addToList($3);
    $$->setline(line_count);
}
| logic_expression {
    grammar_output("arguments","logic_expression");
   // $$ = new SymbleInfo("","arguments");
   // $$->addToList($1);
   // $$->setline(line_count);
}
WHITESPACE


%%



int main(int argc,char *argv[]){
	FILE *fp;

	if((fp=fopen(argv[1],"r"))==NULL){
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logout.open("log.txt");
    parseTree.open("parseTree.txt");
	/* errout.open("error.txt"); */

	yyin=fp;
	yyparse();
	
	/* symbolTable->printAllScopeTable(logout); */

	logout<<"Total lines: "<<line_count<<endl;
    /* logout<<"Total errors: "<<error_count<<endl; */

	fclose(yyin);
 	logout.close();
	/* errout.close(); */
	return 0;
}