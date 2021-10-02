%{
// Team Identification Block
// Author: Jason Hunter
// Student ID: *20473391
// E-Mail: jhunter24@uco.edu
// CRN: 11136, Fall, 2021
// Author: Nicholas Martinez
// Student ID: *20272517
// E-Mail: nmartinez5@uco.edu
// CRN: 17012, Fall, 2021
// Course: CMSC 4023 – Programming Languages
// Assignment: p02
// Due: October 4, 2021
// Account: tt081
//---------------------------------------------------------------------
//File p02par.y contains a specification for Subset Pascal  


//C++ inlcude files
//---------------------------------------------------------------------
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
using namespace std;
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//Application inlcude files
//---------------------------------------------------------------------
#include "p02lex.h"
#include "p02par.h"
//---------------------------------------------------------------------
//Functions
//---------------------------------------------------------------------
void yyerror(const char* m);
//---------------------------------------------------------------------
//Externals
//---------------------------------------------------------------------
extern char* yytext;
extern ofstream tfs;
extern int line;
extern int col;
%}
%union {
  string* token;
}

%token <token> AND
%token <token> ARRAY
%token <token> BEGAN
%token <token> DIV
%token <token> DO
%token <token> DOWNTO
%token <token> ELSE
%token <token> END
%token <token> FOR
%token <token> FUNCTION
%token <token> IF
%token <token> MOD
%token <token> NOT
%token <token> OF
%token <token> OR
%token <token> PROCEDURE
%token <token> PROGRAM
%token <token> REPEAT
%token <token> THEN
%token <token> VAR
%token <token> WHILE
%token <token> EQU
%token <token> NEQ
%token <token> LES
%token <token> LEQ
%token <token> GRT
%token <token> GEQ
%token <token> PLUS
%token <token> MINUS
%token <token> STAR
%token <token> SLASH
%token <token> ASSIGN
%token <token> LPAREN
%token <token> RPAREN
%token <token> LBRACKET
%token <token> RBRACKET
%token <token> LCURLY
%token <token> RCURLY
%token <token> COLON
%token <token> SEMICOLON
%token <token> PERIOD
%token <token> COMMA
%token <token> RANGE
%token <token> APOSTROPHE
%token <token> ID
%token <token> INTLIT
%token <token> TO
%token <token> UNTIL
%token <token> REALIT
%token <token> CHRLIT
%token <token> ERROR



%%

program:
	program_head program_declarations program_body
  {
	  tfs << endl << "#001 program -> program-head program-declarations program-body";  
  }



program_head:
	PROGRAM ID program_parameters SEMICOLON 
	{
		tfs << endl << "#002 program_head -> PROGRAM ID program_parameters;";
	}

program_declarations:
	declarations subprogram_declarations
	{
		tfs << endl << "#003 program_declarations -> declarations subprogram_declarations";
	}

program_body:
	compound_statement PERIOD
	{
		tfs << endl << "#004 program_body -> compound_statement .";
	}

program_parameters:
	{		
		tfs << endl << "#005 program_parameters -> \"\"";
	}

program_parameters:
	LPAREN program_parameter_list RPAREN
	{
		tfs << endl << "#006 program_parameters -> (program_parameter_list)";
	}

program_parameter_list:
	identifier_list
	{
		tfs << endl << "#007 program_parameter_list -> identifier_list";
	}


identifier_list:
	ID
	{
		tfs << endl << "#008 identifier_list -> ID";
	}

identifier_list:
	identifier_list COMMA ID
	{
		tfs << endl << "#009 identifier_list -> identifier_list, ID";
	}

declarations:
	{
		tfs << endl <<  "#010 declarations -> \"\"";
	}

declarations:	
	declarations VAR identifier_list COLON type SEMICOLON
	{
		tfs << endl << "#011 declarations -> declarations VAR identifier_list : type ;";	
	}

type:
	standard_type
	{
		tfs << endl << "#012 type -> standard_type";
	}

	

type:
	ARRAY LBRACKET INTLIT RANGE INTLIT RBRACKET OF standard_type
	{
		tfs << endl << "#013 ARRAY[INTLIT..INTLIT] OF standard_type";
	}

standard_type:
	ID
	{
		tfs << endl << "#014 standard_type -> ID";
	}

subprogram_declarations:
	{
		tfs << endl << "#015 subprogram_declarations -> \"\"";
	}

subprogram_declarations:
	subprogram_declarations subprogram_declaration SEMICOLON
	{
		tfs << endl << "#016 subprogram_declarations -> subprogram_declarations subprogram_declaration ;";
	}

subprogram_declaration:
	subprogram_head declarations compound_statement
	{
		tfs << endl << "#017 subprogram_declaration -> subprogram_head declarations compound_statement";
	}

subprogram_head:
	FUNCTION ID subprogram_parameters COLON standard_type SEMICOLON
	{
		tfs << endl << "#018 subprogram_head -> FUNCTION ID subprogram_parameters : standard_type ;";
	}

subprogram_head:
	PROCEDURE ID subprogram_parameters SEMICOLON
	{
		tfs << endl << "#019 subprogram_head -> PROCEDURE ID subprogram_parameters;";
	}

subprogram_parameters:
	{
		tfs << endl << "#020 subprogram_parameters -> \"\"";
	}

subprogram_parameters:
	LPAREN parameter_list RPAREN
	{
		tfs << endl << "#021 subprogram_parameters -> ( parameter_list )";
	}

parameter_list:
	identifier_list COLON type
	{
		tfs << endl << "#022 parameter_list -> identifier_list : type";
	}

parameter_list:
	parameter_list SEMICOLON identifier_list COLON type
	{
		tfs << endl << "#023 parameter_list -> parameter_list ; identifier_list : type";
	}

compound_statement:
	BEGAN optional_statements END
	{
		tfs << endl << "#024 compound_statement -> BEGIN optional_statements END";
	}

optional_statements:
	{
		tfs << endl << "#025 optional_statements -> \"\"";
	}

optional_statements:
	statement_list
	{
		tfs << endl << "#026 optional_statements -> statement_list";
	}

statement_list:
	statement
	{
		tfs << endl << "#027 statement_list -> statement";
	}
statement_list:
	statement_list SEMICOLON statement
	{
		tfs << endl << "#028 statement_list -> statement_list ; statement";
	}


statement:
	variable ASSIGN expression
	{
		tfs << endl << "#029 statement -> variable := expression";
	}
statement:
	procedure_statement
	{
		tfs << endl << "#030 statement -> procedure_statement";
	}

statement:
	alternative_statement
	{
		tfs << endl << "#031 statement -> alternative_statement";
	}

statement:
	iterative_statement
	{
		tfs << endl << "#032 statement -> iterative_statement";
	}

statement:
	compound_statement
	{
		tfs << endl << "#033 statement -> compound_statement";
	}

alternative_statement:
	if_statement
	{
		tfs << endl << "#034 alternative_statement -> if_statement";
	}

iterative_statement:
	while_statement
	{
		tfs << endl << "#035 iterative_statement -> while_statement";
	}

iterative_statement:
	repeat_statement
	{
		tfs << endl << "#036 iterative_statement -> repeat_statement";
	}

iterative_statement:
	for_statement
	{
		tfs << endl << "#037 iterative_statement -> for_statement";
	}

if_statement:
	IF expression THEN statement ELSE statement
	{
		tfs << endl << "#038 if expression then statement else statement";
	}

while_statement:
	WHILE expression DO statement
	{
		tfs << endl <<"#039 WHILE expression DO statement";
	}



repeat_statement:
	REPEAT statement_list UNTIL expression
	{
		tfs << endl << "#040 repeat_statement -> REPEAT statement_list UNTIL expression";
	}

for_statement:
	FOR variable ASSIGN expression TO expression DO statement
	{
		tfs << endl << "#041 for_statement -> for variable := expression TO expression DO statement";
	}

for_statement:
	FOR variable ASSIGN expression DOWNTO expression DO statement
	{
		tfs << endl << "#042 for_statement -> for variable := expression DOWNTO expression DO statement";
	}



variable:
	ID
	{
		tfs << endl << "#043 variable -> ID";
	}

variable:
	ID LBRACKET expression RBRACKET
	{
		tfs << endl << "#044 variable -> ID[expression]";
	}

procedure_statement:
	ID
	{
		tfs << endl << "#045 procedure_statement -> ID";
	}

procedure_statement:
	ID LPAREN expression_list RPAREN
	{
		tfs << endl << "#046 procedure_statement -> id ( expression_list )";
	}

expression_list:
	expression
	{
		tfs << endl << "#047 expression_list -> expression";
	}

expression_list:
	expression_list COMMA expression
	{
		tfs << endl << "#048 expression_list -> expression_list, expression";
	}

expression:
	simple_expression
	{
		tfs << endl << "#049 expression -> simple_expression";
	}

expression:
	simple_expression relop simple_expression
	{
		tfs << endl << "#050 expression -> simple_expression relop simple_expression";
	}

relop:
	EQU
	{
		tfs << endl << "#051 relop -> =";
	}

relop:
	NEQ
	{
		tfs << endl << "#052 relop -> <>";
	}

relop:
	LES
	{
		tfs << endl << "#053 relop -> <";
	}

relop:
	LEQ
	{
		tfs << endl << "#054 relop -> <=";
	}

relop:
	GRT
	{
		tfs << endl << "#055 relop -> >";
	}

relop:
	GEQ
	{
		tfs << endl << "#056 relop -> >=";
	}

simple_expression:
	term
	{
		tfs << endl << "#057 simple_expression -> term";
	}

simple_expression:
	sign term
	{
		tfs << endl << "#058 simple_expression -> sign term";
	}

sign:
	PLUS
	{
		tfs << endl << "#059 sign -> +";
	}

sign:
	MINUS
	{
		tfs << endl << "#060 sign -> -";
	}

simple_expression:
	simple_expression addop term
	{
		tfs << endl << "#061 simple_expression -> simple_expression addop term";
	}

addop:
	PLUS
	{
		tfs << endl << "#062 addop -> +";
	}

addop:
	MINUS
	{
		tfs << endl << "#063 addop -> -";
	}

addop:
	OR
	{
		tfs << endl << "#064 addop -> or";
	}



term:
	factor
	{
		tfs << endl << "#065 term -> factor";
	}

term:
	term mulop factor
	{
		tfs << endl << "#066 term -> term mulop factor";
	}

mulop:
	STAR
	{
		tfs << endl << "#067 mulop -> *";
	}

mulop:
	SLASH
	{
		tfs << endl << "#068 mulop -> /";
	}

mulop:
	DIV
	{
		tfs << endl << "#069 mulop -> DIV";
	}

mulop: 
	MOD
	{
		tfs << endl << "#070 mulop -> MOD";
	}
mulop:
	AND
	{
		tfs<< endl << "#071 mulop -> AND";
	}
factor:
	ID
	{
		tfs << endl << "#072 factor -> id";
	}

factor:
	ID LBRACKET expression_list RBRACKET
	{
		tfs << endl << "#073 factor -> id ( expression_list )";
	}

factor:
	ID LPAREN expression_list RPAREN
	{
		tfs << endl << "#074 factor -> id (expression_list)";
	}

factor:
	LPAREN expression RPAREN
	{
		tfs << endl << "#075 factor -> ( expression )";
	}

factor:
	NOT factor
	{
		tfs << endl << "#076 factor -> NOT";
	}

factor:
	INTLIT
	{
		tfs << endl << "#077 factor -> INTLIT";
	}

factor:
	REALIT
	{
		tfs << endl << "#078 factor -> REALIT";
	}

factor:
	CHRLIT
	{
		tfs << endl << "#079 factor -> CHRLIT";
	}



%%
//-----------------------------------------------------------------------
//User function section
//-----------------------------------------------------------------------
void yyerror(const char* m)
{   cout << endl 
         << "line(" << line << ") col(" << col << ") " << m;
    cout << endl;
}

