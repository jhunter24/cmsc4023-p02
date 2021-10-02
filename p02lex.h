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

#ifndef p02lex_h
#define p02lex_h 1
//--------------------------------------------------------------------
// File p02lex.h defines class Lexer.  

//--------------------------------------------------------------------
// Standard C and C++ include files                                        
//--------------------------------------------------------------------
#include <cstdio>
#include <fstream>
#include <iostream>

//--------------------------------------------------------------------
//Namespaces
//--------------------------------------------------------------------
using namespace std;
//--------------------------------------------------------------------
//Function: yylex                                                     
//Function yylex is the pasner.  Function yylex returns an integer   
//token code as defined above or 0 if end-of-file has been     
//reached.                                                            
//--------------------------------------------------------------------
#ifdef __cplusplus
extern "C" 
#endif
int yylex (void);
//--------------------------------------------------------------------
//Class Lexer defines the attributes of a Scanner
//--------------------------------------------------------------------
class Lexer {
public:
  Lexer(FILE* i);                //Constructor used to redirect the keyboard
                                 //(stdin) to file i.
  int Lex(void);                 //Call the scanner yylex and return the code
};
#endif
