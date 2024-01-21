%{
    #include<iostream>
    #include<fstream>
    //#include "SymbolTable.h"
    #include "SymbolTabledeclaration.h"

    using namespace std;

    ofstream logout;
    ofstream errorout;

    SymbolTable *symbolTable = new SymbolTable(11);
    extern int line_count;
    extern FILE *yyin;

    void grammar_output(string top, string bottom){
        logout<<top<<" : "<<bottom<<endl;
    }
    
    void yyerror(string msg){
        errorout<<"Line# "<<line_count<<": "<<msg<<endl;
    }



    extern int yylex();
    extern int yyparse();
    //extern int line_count;
    %}



%union{
    SymbleInfo *symbleInfo;
}
%token<symbleInfo> IF ELSE LOWER_THAN_ELSE FOR WHILE DO BREAK CHAR DOUBLE RETURN BITOP LSQUARE RSQUARE SWITCH CASE DEFAULT CONTINUE PRINTLN INCOP DECOP ASSIGNOP NOT LPAREN RPAREN WHITESPACE LCURL RCURL COMMA SEMICOLON INT FLOAT VOID CONST_INT CONST_FLOAT ID ADDOP MULOP RELOP LOGICOP CONST_CHAR
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
    $$ = new SymbleInfo("","start");
    cout <<"Here"<<endl;
    //////lexeme_details_out("")
}
program : program unit {
    grammar_output("program","program unit");
    //$$ = new SymbleInfo("","program");
}
| unit {
    grammar_output("program","unit");
    //$$ = new SymbleInfo("","program");
}
;
unit : var_declaration {
    grammar_output("unit","var_declaration");
    //$$ = new SymbleInfo("","unit");
}
| func_declaration {
    grammar_output("unit","func_declaration");
    //$$ = new SymbleInfo("","unit");
}
| func_definition {
    grammar_output("unit","func_definition");
    //$$ = new SymbleInfo("","unit");
}
;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
    ////lexeme_details_out($2->gettype(), $2->getname());
    ////lexeme_details_out($3->gettype(), $3->getname());
    ////lexeme_details_out($5->gettype(), $5->getname());
    ////lexeme_details_out($6->gettype(), $6->getname());

    grammar_output("func_declaration","type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
    //$$ = new SymbleInfo("","func_declaration");
}
| type_specifier ID LPAREN RPAREN SEMICOLON {
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    //lexeme_details_out($5->gettype(), $5->getname());
    grammar_output("func_declaration","type_specifier ID LPAREN RPAREN SEMICOLON");
    //$$ = new SymbleInfo("","func_declaration");
}
;
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement {
    cout<<"now"<<endl;
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    //lexeme_details_out($5->gettype(), $5->getname());
    grammar_output("func_definition","type_specifier ID LPAREN parameter_list RPAREN compound_statement");
    //$$ = new SymbleInfo("","func_definition");
}
| type_specifier ID LPAREN RPAREN compound_statement {
    cout<<"now1"<<endl;
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("func_definition","type_specifier ID LPAREN RPAREN compound_statement");
    //$$ = new SymbleInfo("","func_definition");
}
;
parameter_list : parameter_list COMMA type_specifier ID {
    cout<<"now2"<<endl;
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("parameter_list","parameter_list COMMA type_specifier ID");
    //$$ = new SymbleInfo("","parameter_list");
}
| parameter_list COMMA type_specifier {
    cout<<"now3"<<endl;
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("parameter_list","parameter_list COMMA type_specifier");
    //$$ = new SymbleInfo("","parameter_list");
}
| type_specifier ID {
    cout<<"now4"<<endl;
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("parameter_list","type_specifier ID");
    //$$ = new SymbleInfo("","parameter_list");
}
| type_specifier {
    cout<<"now5"<<endl;
    grammar_output("parameter_list","type_specifier");
    //$$ = new SymbleInfo("","parameter_list");
}
;
compound_statement : LCURL statements RCURL {
    
    //lexeme_details_out($1->gettype(), $1->getname());
    symbolTable->enterScope();
    //lexeme_details_out($3->gettype(), $3->getname());
    logout<<symbolTable->printAllScope()<<endl;
    symbolTable->exitScope();
    grammar_output("compound_statement","LCURL statements RCURL");
    //$$ = new SymbleInfo("","compound_statement");
}
| LCURL RCURL {
    //lexeme_details_out($1->gettype(), $1->getname());
    cout << "test\n";
    symbolTable->enterScope();
    //lexeme_details_out($2->gettype(), $2->getname());
    symbolTable->exitScope();
    logout<<symbolTable->printCurrentScope()<<endl;
    grammar_output("compound_statement","LCURL RCURL");
    //$$ = new SymbleInfo("","compound_statement");
}
;
var_declaration : type_specifier declaration_list SEMICOLON {
    //lexeme_details_out($3->gettype(), $3->getname());
    grammar_output("var_declaration","type_specifier declaration_list SEMICOLON");
    //$$ = new SymbleInfo("","var_declaration");
}
;
type_specifier : INT {
    //lexeme_details_out($1->gettype(), $1->getname());
    symbolTable->insert(*$1);
    grammar_output("type_specifier","INT");
    //$$ = new SymbleInfo("","type_specifier");
}
| FLOAT {
    //lexeme_details_out($1->gettype(), $1->getname());
    symbolTable->insert(*$1);
    grammar_output("type_specifier","FLOAT");
    //$$ = new SymbleInfo("","type_specifier");
}
| VOID {
    //lexeme_details_out($1->gettype(), $1->getname());
    symbolTable->insert(*$1);
    grammar_output("type_specifier","VOID");
    //$$ = new SymbleInfo("","type_specifier");
}
;
declaration_list : declaration_list COMMA ID {
  //  cout<<"fkjw";
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    grammar_output("declaration_list","declaration_list COMMA ID");
    //$$ = new SymbleInfo("","declaration_list");
}
| declaration_list COMMA ID LSQUARE CONST_INT RSQUARE {
  //  cout<<"hsfh";
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    //lexeme_details_out($5->gettype(), $5->getname());
    //lexeme_details_out($6->gettype(), $6->getname());
    grammar_output("declaration_list","declaration_list COMMA ID LSQUARE CONST_INT RSQUARE");
    //$$ = new SymbleInfo("","declaration_list");
}
| ID {
//    cout<<"hjskdfjhks";
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("declaration_list","ID");
    //$$ = new SymbleInfo("","declaration_list");
}
| ID LSQUARE CONST_INT RSQUARE {
 //   cout<<"ei";
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("declaration_list","ID LSQUARE CONST_INT RSQUARE");
    //$$ = new SymbleInfo("","declaration_list");
}
;
statements : statement {
    grammar_output("statements","statement");
    //$$ = new SymbleInfo("","statements");
}
| statements statement {
    grammar_output("statements","statements statement");
    //$$ = new SymbleInfo("","statements");
}
;
statement : var_declaration {
    grammar_output("statement","var_declaration");
    //$$ = new SymbleInfo("","statement");
}
| expression_statement {
    grammar_output("statement","expression_statement");
    //$$ = new SymbleInfo("","statement");
}
| compound_statement {
    grammar_output("statement","compound_statement");
    //$$ = new SymbleInfo("","statement");
}
| FOR LPAREN expression_statement expression_statement expression RPAREN statement {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($8->gettype(), $8->getname());
    grammar_output("statement","FOR LPAREN expression_statement expression_statement expression RPAREN statement");
    //$$ = new SymbleInfo("","statement");
}
| IF LPAREN expression RPAREN statement {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("statement","IF LPAREN expression RPAREN statement");
    //$$ = new SymbleInfo("","statement");
}
| IF LPAREN expression RPAREN statement ELSE statement {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    //lexeme_details_out($6->gettype(), $6->getname());
    grammar_output("statement","IF LPAREN expression RPAREN statement ELSE statement");
    //$$ = new SymbleInfo("","statement");
}
| WHILE LPAREN expression RPAREN statement {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("statement","WHILE LPAREN expression RPAREN statement");
    //$$ = new SymbleInfo("","statement");
}
| PRINTLN LPAREN ID RPAREN SEMICOLON {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    //lexeme_details_out($5->gettype(), $5->getname());
    grammar_output("statement","PRINTLN LPAREN ID RPAREN SEMICOLON");
    //$$ = new SymbleInfo("","statement");
}
| RETURN expression SEMICOLON {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    grammar_output("statement","RETURN expression SEMICOLON");
    //$$ = new SymbleInfo("","statement");
}
;
expression_statement : SEMICOLON {
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("expression_statement","SEMICOLON");
    //$$ = new SymbleInfo("","expression_statement");
}
| expression SEMICOLON {
    //lexeme_details_out($2->gettype(), $2->getname());
    cout<<"in rule expression_statement:   expression SEMICOLON"<<endl;
    grammar_output("expression_statement","expression SEMICOLON");
    
    //$$ = new SymbleInfo("","expression_statement");
}
;
variable : ID {
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("variable","ID");
    //$$ = new SymbleInfo("","variable");
}
| ID LSQUARE expression RSQUARE {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("variable","ID LSQUARE expression RSQUARE");
    //$$ = new SymbleInfo("","variable");
}
;
expression : logic_expression {
    grammar_output("expression","logic_expression");
    //$$ = new SymbleInfo("","expression");
}
| variable ASSIGNOP logic_expression {
    cout<<"expression : variable ASSIGNOP logic_expression 555"<<endl;
    // lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("expression","variable ASSIGNOP logic_expression");
    // $$ = new SymbleInfo("","expression");
    //cout << "again\n";
}
;
logic_expression : rel_expression {
    grammar_output("logic_expression","rel_expression");
    cout<<"logic_expression : rel_expression\n";
    //$$ = new SymbleInfo("","logic_expression");
}
| rel_expression LOGICOP rel_expression {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("logic_expression","rel_expression LOGICOP rel_expression");
    //$$ = new SymbleInfo("","logic_expression");
}
;
rel_expression : simple_expression {
    grammar_output("rel_expression","simple_expression");
    //$$ = new SymbleInfo("","rel_expression");
}
| simple_expression RELOP simple_expression {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("rel_expression","simple_expression RELOP simple_expression");
    //$$ = new SymbleInfo("","rel_expression");
}
;
simple_expression : term {
    grammar_output("simple_expression","term");
    //$$ = new SymbleInfo("","simple_expression");
}
| simple_expression ADDOP term {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("simple_expression","simple_expression ADDOP term");
    //$$ = new SymbleInfo("","simple_expression");
}
;
term : unary_expression {
    grammar_output("term","unary_expression");
    //$$ = new SymbleInfo("","term");
}
| term MULOP unary_expression {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("term","term MULOP unary_expression");
    //$$ = new SymbleInfo("","term");
}
;
unary_expression : ADDOP unary_expression {
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("unary_expression","ADDOP unary_expression");
    //$$ = new SymbleInfo("","unary_expression");
}
| NOT unary_expression {
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("unary_expression","NOT unary_expression");
    //$$ = new SymbleInfo("","unary_expression");
}
| factor {
    grammar_output("unary_expression","factor");
    //$$ = new SymbleInfo("","unary_expression");
}
;
factor : variable {
    grammar_output("factor","variable");
    //$$ = new SymbleInfo("","factor");
}
| ID LPAREN argument_list RPAREN {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($2->gettype(), $2->getname());
    //lexeme_details_out($4->gettype(), $4->getname());
    grammar_output("factor","ID LPAREN argument_list RPAREN");
    //$$ = new SymbleInfo("","factor");
}
| LPAREN expression RPAREN {
    //lexeme_details_out($1->gettype(), $1->getname());
    //lexeme_details_out($3->gettype(), $3->getname());
    grammar_output("factor","LPAREN expression RPAREN");
    //$$ = new SymbleInfo("","factor");
}
| CONST_INT {
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("factor","CONST_INT");
    cout<<"factor : const_int\n";
    //$$ = new SymbleInfo("","factor");
}
| CONST_FLOAT {
    //lexeme_details_out($1->gettype(), $1->getname());
    grammar_output("factor","CONST_FLOAT");
    //$$ = new SymbleInfo("","factor");
}
| variable INCOP {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("factor","variable INCOP");
    //$$ = new SymbleInfo("","factor");
}
| variable DECOP {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("factor","variable DECOP");
    //$$ = new SymbleInfo("","factor");
}
;
argument_list : arguments {
    grammar_output("argument_list","arguments");
    //$$ = new SymbleInfo("","argument_list");
}
|
;
arguments : arguments COMMA logic_expression {
    //lexeme_details_out($2->gettype(), $2->getname());
    grammar_output("arguments","arguments COMMA logic_expression");
    //$$ = new SymbleInfo("","arguments");
}
| logic_expression {
    grammar_output("arguments","logic_expression");
    //$$ = new SymbleInfo("","arguments");
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