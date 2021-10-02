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

#ifndef p02par_h

#define p02par_h 1


#include "p02lex.h"

#ifdef __cplusplus
extern "C" 
#endif
int yyparse (void);
#endif

class Parser : public Lexer {
public:
  Parser(FILE* i):Lexer(i){}
  int Parse(void) { return yyparse(); }
};
