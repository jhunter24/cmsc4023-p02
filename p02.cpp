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

//-------------------------------------------------------------------
//File p02.cpp contains functions that process command line file names
//and interface with the lex-generated scanner 


//--------------------------------------------------------------------
//C++ Standard include files
//--------------------------------------------------------------------
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <cstdio>
#include <string>
using namespace std;
//--------------------------------------------------------------------
//Application include files
//--------------------------------------------------------------------
#include "p02lex.h"
#include "p02par.h"
//--------------------------------------------------------------------
//Externals
//--------------------------------------------------------------------
ofstream tfs;                     //trace file stream 
//--------------------------------------------------------------------
//BadSuffixException
//--------------------------------------------------------------------
struct BadSuffixException {
    BadSuffixException(char* fn)
    {   cout << endl;
        cout << "Input file \"" << fn << "\" does not have a .mcr suffix.";
    }
};
//--------------------------------------------------------------------
//--------------------------------------------------------------------
class FileNameSuffix {
    char* prefix;
public:
    FileNameSuffix(char* fn)
    {   char* p=strstr(fn,".pas");
        if (!p) throw BadSuffixException(fn);
        int n=p-fn;
        if (n+4!=strlen(fn)) throw BadSuffixException(fn);
        prefix=new char[strlen(fn)+1];
        strncpy(prefix,fn,n);
        prefix[n]=0;
    }
    ~FileNameSuffix(){if (prefix) delete[] prefix;}
    void Suffix(char* fn,const char* suffix)
    {   strcpy(fn,prefix);
        strcat(fn,suffix);
    }
};
//--------------------------------------------------------------------
//CommandLineException
//--------------------------------------------------------------------
struct CommandLineException {
    CommandLineException(int m,int a)
    {   cout << endl;
        cout << "Too many file names on the command line.";
        cout << endl;
        cout << m << " file name(s) are permitted on the command line.";
        cout << endl;
        cout << a << " file name(s) appeared on the command line.";
        cout << endl;
    }
};
//--------------------------------------------------------------------
//FileException
//--------------------------------------------------------------------
struct FileException {
   FileException(const char* fn)
   {   cout << endl;
       cout << "File " << fn << " could not be opened.";
       cout << endl;
   }
};
//--------------------------------------------------------------------
//--------------------------------------------------------------------
void CompilerMgr(FILE* i)
{   Parser P(i);
    int rc=P.Parse();
}
//--------------------------------------------------------------------
//Function main processes command line file names
//--------------------------------------------------------------------
int main(int argc,char* argv[])
{   try {
        char ifn[255];
        switch (argc) {
            case 1:               //Prompt for the input file name
                cout << "Enter the input file name. ";
                cin >> ifn;
                break;
            case 2:               //Read the input file name
                strcpy(ifn,argv[1]);
                break;
            default:
                throw CommandLineException(1,argc-1);
                break;
    }
    FileNameSuffix F(ifn);        //Find the prefix of the input file name
    char tfn[255];
    F.Suffix(tfn,".trc");         //Create the trace file name
    FILE* i=fopen(ifn,"r");       //Open the input file
    if (!i) throw FileException(ifn);
    tfs.open(tfn); if (!tfs) throw FileException(tfn);
    CompilerMgr(i);
    tfs << endl;                  //Put a new line in the trace file
    tfs.close();                  //Close the trace file
    fclose(i);                    //Close the input file
    } catch (...) {
        cout << endl;
        cout << "Program terminated!";
        cout << endl;
        cout << "I won't be back!";
        cout << endl;
        exit(EXIT_FAILURE);
    }
    return 0;
	
}


