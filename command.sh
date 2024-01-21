yacc -d -y  2005111.y &> 00yacc_report.log 
flex 2005111.l
g++ -w   lex.yy.c  y.tab.c ScopeTable.cpp SymbleInfo.cpp SymbolTable.cpp -o test_executable  &> 02gcc_report_main.log
./test_executable in.c