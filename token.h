#ifndef TOKEN_HEADER
#define TOKEN_HEADER
#include "parser.h"
#include <map>
#include <vector>
#include <iostream>

typedef struct Token {
    int type;
    long long value;
    double dvalue;
} CToken;

#ifdef LEXCER
const char* yyin;
const char* yyold;
const char* yymk;
std::vector<std::string> hList;
std::map<std::string, CToken> hInst;
#else
extern const char* yyin;
extern const char* yyold;
extern const char* yymk;
extern std::vector<std::string> hList;
extern std::map<std::string, CToken> hInst;
#endif

void *ParseAlloc(void *(*mallocProc)(size_t));
void ParseFree(void *p, void (*freeProc)(void*));
void Parse(void *yyp, int yymajor, CToken yyminor);

#define END      0
#define ERROR   -1
#define EXIT    -2

#endif //!TOKEN_HEADER
