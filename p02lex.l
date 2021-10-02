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
//--------------------------------------------------------------------
// File p02lex.l defines a prototype scanner for the Pascal language.
// The scanner definition is a lex specification.                        




//--------------------------------------------------------------------
//--------------------------------------------------------------------
// Standard C and C++ Library Include Files                                     
//--------------------------------------------------------------------
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>                          
#include <cstdio>
#include <map>
using namespace std;
//--------------------------------------------------------------------
// Application Includes                                               
//--------------------------------------------------------------------
#include "p02lex.h"
#include "p02tkn.h"


//--------------------------------------------------------------------
//Externals
//--------------------------------------------------------------------
extern ofstream tfs;                    //Trace file stream tfs
//--------------------------------------------------------------------
//Global Variables                                                    
//--------------------------------------------------------------------
static map<string,int> RW;              //RW - Reserve Words
                                        //RW is a table of reserve words
                                        //and their corresponding
                                        //token codes.
static map<int,string> TokenName;
int line=1;                             //Current line number
int col=1;                              //Current column number
//--------------------------------------------------------------------
//Functions
//--------------------------------------------------------------------
int TokenMgr(int t);                    //Token post processing
int ReserveWord(char* s);               //Determines if string s is
                                        //a reserve word
void TokenTrace(int t);                 //Records token t in the trace file
void PopulateRWMap(void);               //Create the table of reserve
                                        //words and their token codes.
void PopulateTokenNameMap(void);        //Create a table of names for tokens
                                        //to be printed in the TokenTrace
void ToLower(char* d,char* s);          //Coerce the characters of string s
                                        //to lower case. Put the result
                                        //in string d.
//--------------------------------------------------------------------
//Exceptions
//--------------------------------------------------------------------
//An UnterminatedCommentException is thrown when an unterminated
//comment appears in the source file.
//--------------------------------------------------------------------
struct UnterminatedCommentException {
    UnterminatedCommentException()
    {   tfs << endl;
        tfs << "An unterminated comment begins on line " <<  line 
            << " and column " << col;
        tfs << endl;
    }
};
//--------------------------------------------------------------------
//A BacCharacterException is thrown when a character outside the
//defined set of characters for the Subset Pascal language appears in the 
//source.
//--------------------------------------------------------------------
struct BadCharacterException{
    BadCharacterException(char p,int l,int c)
    {   cout << endl;
        cout << "line(" << l << ") col (" << c << ")" ;
        cout << "Lexical error: ";
        cout << "Illegal character |" << p << "| ASCII code=" << (int)p;
        cout << endl;
    } 
};
%}

%%

[{]                                     {throw UnterminatedCommentException();}
[{][^}]*[}]                             {   for (int a=0;a<yyleng;a++) {
                                                col++;
                                                if (yytext[a]=='\n')
                                                {   col=1;
                                                    line++;
                                                }
                                            }
                                        }
[\n]                                    {line++; col=1;}
[ \t]+                                  {col+=yyleng;}
"."							{col++; return TokenMgr(PERIOD);}
".."						{col++;return TokenMgr(RANGE);}
[0-9]+						{col++; return TokenMgr(INTLIT);}
[0-9]*\.+[0-9]*				{col++; return TokenMgr(REALIT);}
[0-9]*[eE][+-]?[0-9]*		{col++; return TokenMgr(REALIT);}
[bB][eE][gG][iI][nN]		{col++; return TokenMgr(BEGAN);}
[aA][nN][dD]				{col++; return TokenMgr(AND);}
[aA][rR][rR][aA][yY]		{col++; return TokenMgr(ARRAY);}
[dD][iI][vV]				{col++; return TokenMgr(DIV);}
[dD][oO]					{col++; return TokenMgr(DO);}
[dD][oO][wW][nN][tT][oO]	{col++; return TokenMgr(DOWNTO);}
[eE][lL][sS][eE]			{col++; return TokenMgr(ELSE);}
[eE][nN][dD]				{col++; return TokenMgr(END);}
[fF][oO][rR]				{col++; return TokenMgr(FOR);}
[fF][uU][nN][cC][tT][iI][oO][nN]	{col++; return TokenMgr(FUNCTION);}
[iI][fF]					{col++; return TokenMgr(IF);}
[mM][oO][dD]				{col++; return TokenMgr(MOD);}
[nN][oO][tT]				{col++; return TokenMgr(NOT);}
[oO][fF]					{col++; return TokenMgr(OF);}
[oO][rR]					{col++; return TokenMgr(OR);}
[pP][rR][oO][cC][eE][dD][uU][rR][eE]	{col++; return TokenMgr(PROCEDURE);}
[pP][rR][oO][gG][rR][aA][mM]	{col++; return TokenMgr(PROGRAM);}
[rR][eE][pP][eE][aA][tT]	{col++; return TokenMgr(REPEAT);}
[tT][hH][eE][nN]			{col++; return TokenMgr(THEN);}
[tT][oO]					{col++; return TokenMgr(TO);}
[uU][nN][tT][iI][lL]		 {col++;return TokenMgr(UNTIL);}
[vV][aA][rR]				{col++;return TokenMgr(VAR);}
[wW][hH][iI][lL][eE]		{col++; return TokenMgr(WHILE);}
[_a-zA-Z][_a-zA-Z0-9]* 		 {col++;return TokenMgr(ID);}
"'"							{col++;return TokenMgr(APOSTROPHE);}
"="							{col++; return TokenMgr(EQU);}
"<>"						{col++; return TokenMgr(NEQ);}
"<"							{col++; return TokenMgr(LES);}
"<="						{col++; return TokenMgr(LEQ);}
">"							{col++; return TokenMgr(GRT);}
">="						{col++; return TokenMgr(GEQ);}
"+"							{col++; return TokenMgr(PLUS);}
"-"							{col++; return TokenMgr(MINUS);}
"*"							{col++; return TokenMgr(STAR);}
"/"							{col++; return TokenMgr(SLASH);}
":="						{col++; return TokenMgr(ASSIGN);}
"("							{col++; return TokenMgr(LPAREN);}
")"							{col++; return TokenMgr(RPAREN);}
"["							{col++; return TokenMgr(LBRACKET);}
"]"							{col++; return TokenMgr(RBRACKET);}
"}"							{col++; return TokenMgr(RCURLY);}
";"							{col++; return TokenMgr(SEMICOLON);}
":"							{col++; return TokenMgr(COLON);}
","							{col++; return TokenMgr(COMMA);}
\'[^\n]*\'|''''				{col++; return TokenMgr(CHRLIT);}
.                                       {throw BadCharacterException
                                              (*yytext
                                              ,line
                                              ,col
                                              );
                                        }
%%
//--------------------------------------------------------------------
//Class Lexer implementation
//--------------------------------------------------------------------
//Function ReserveWord determines if the input string is a reserve
//word and if it is the function returns the corresponding tokencode.
//Otherwise it return the tokencode IDENTIFIER.
//--------------------------------------------------------------------
int ReserveWord(char* s)
{
    int t=RW[(string)s];
    if (t>0) return t; else return ID;
}
//--------------------------------------------------------------------
//Function ToLower coerces the characters of string s to lower case
//and stores the result in string d.
//--------------------------------------------------------------------
void ToLower(char* d,char* s)
{   strcpy(d,s);
    for (int a=0;a<strlen(d);a++) d[a]=tolower(d[a]);
}
//--------------------------------------------------------------------
//Function TokenMgr processes the token after it has been recognized
//--------------------------------------------------------------------
int TokenMgr(int t)
{   col+=yyleng;                      //Add the length of the current
                                      //Token to the column position
    if (t==ID) 
    {   char* s=new char[yyleng];     //Create storage for a lower case
                                      //version of the token
        ToLower(s,yytext);            //Coerce the token to lower case
        yylval.token= new string(s);  //yylval is the yacc variable
                                      //associated with the %union
                                      //directive.  Member token was
                                      //declared to have the semantic
                                      //value for tokens.
        t=ReserveWord(s);             //Determie if the IDENTIFIER is a reserve word
    }
    TokenTrace(t);                    //Record the current token in the trace file
    return t;
}
//--------------------------------------------------------------------
//-----------------------------------------------------------------------
//Function TokenTrace records the attributes of the input token t
//in the trace file.
//-----------------------------------------------------------------------
void TokenTrace(int tkn)
{ 
    tfs << endl;
    tfs << "Tokentrace(";
    tfs << "line(" << setw(4) << line << ")";
    tfs << ",";
    tfs << "col(" << setw(4) << col-yyleng << ")";
    tfs << ",";
    tfs << "code(" << setw(3) << tkn << ")";
    tfs << ",";
    tfs << "name(" << setw(10) << TokenName[tkn] << ")";
    tfs << ",";
    tfs << "spelling(\"" << yytext << "\")";
    tfs << ")";
}
//--------------------------------------------------------------------
//Function PopulateRWMap assigns values to the map, RW, such that each
//reserve word is given its associated tokencode.
//--------------------------------------------------------------------
void PopulateRWMap(void)
{   
	RW["program"]=PROGRAM;
	RW["begin"]=BEGAN;
    RW["end"  ]=END;
	RW["if"]=IF;
	RW["else"]=ELSE;
	RW["then"] = THEN;
	RW["for"]=FOR;
	RW["to"] = TO;
	RW["downto"] = DOWNTO;
	RW["while"]=WHILE;
	RW["do"]=DO;
	RW["repeat"]=REPEAT;
	RW["until"] = UNTIL;
	RW["var"]=VAR;
	RW["procedure"]=PROCEDURE;
	RW["function"]=FUNCTION;
	RW["not"] = NOT;
	RW["array"] = ARRAY;
	RW["of"] = OF;
	RW["chrlit"] = CHRLIT;
	RW["intlit"] = INTLIT;
	RW["realit"] = REALIT;
	RW["or"] = OR;
	RW["mod"] = MOD;
	RW["div"] = DIV;
	RW["and"] = AND;
} 
void PopulateTokenNameMap(void)
{   TokenName[AND       ]="AND";
	TokenName[ARRAY		]="ARRAY";
	TokenName[BEGAN		]="BEGAN";
	TokenName[DIV		]="DIV";
	TokenName[DO		]="DO";
	TokenName[DOWNTO	]="DOWNTO";
	TokenName[ELSE		]="ELSE";
	TokenName[END		]="END";
	TokenName[FOR		]="FOR";
	TokenName[FUNCTION	]="FUNCTION";
	TokenName[IF		]="IF";
	TokenName[MOD		]="MOD";
	TokenName[NOT		]="NOT";
	TokenName[OF		]="OF";
	TokenName[OR		]="OR";
	TokenName[PROCEDURE	]="PROCEDURE";
	TokenName[PROGRAM	]="PROGRAM";
	TokenName[REPEAT	]="REPEAT";
	TokenName[THEN		]="THEN";
	TokenName[VAR		]="VAR";
	TokenName[WHILE		]="WHILE";
	TokenName[EQU		]="EQU";
	TokenName[NEQ		]="NEQ";
	TokenName[LES		]="LES";
	TokenName[LEQ		]="LEQ";
	TokenName[GRT		]="GRT";
	TokenName[GEQ		]="GEQ";
	TokenName[PLUS		]="PLUS";
	TokenName[MINUS		]="MINUS";
	TokenName[STAR		]="STAR";
	TokenName[SLASH		]="SLASH";
	TokenName[ASSIGN	]="ASSIGN";
	TokenName[LPAREN	]="LPAREN";
	TokenName[RPAREN	]="RPAREN";
	TokenName[LBRACKET	]="LBRACKET";
	TokenName[RBRACKET	]="RBRACKET";
	TokenName[LCURLY	]="LCURLY";
	TokenName[RCURLY	]="RCURLY";
	TokenName[COLON		]="COLON";
	TokenName[SEMICOLON	]="SEMICOLON";
	TokenName[PERIOD	]="PERIOD";
	TokenName[COMMA		]="COMMA";
	TokenName[RANGE		]="RANGE";
	TokenName[APOSTROPHE]="APOSTROPHE";
	TokenName[ID		]="ID";
	TokenName[INTLIT	]="INTLIT";
	TokenName[TO		]="TO";
	TokenName[UNTIL		]="UNTIL";
	TokenName[REALIT	]="REALIT";
	TokenName[CHRLIT	]="CHRLIT";
    TokenName[ERROR     ]="ERROR";
}
//--------------------------------------------------------------------
//Constructor Lexer is used to redirect the input file stream from the
//keyboard to input file stream i.
//--------------------------------------------------------------------
Lexer::Lexer(FILE* i) 
{   yyin=i; 
    PopulateRWMap();
    PopulateTokenNameMap();
}
//-----------------------End of Lex Definition------------------------

