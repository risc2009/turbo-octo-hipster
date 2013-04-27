#ifdef linux
#include <stdlib.h>
#endif
#include <iostream>
#include "token.h"

CToken yylex();

bool runCom(std::string command);

int main(int argc,char* argv[]) {
    std::string strLine;
    if (argc > 1) {
        strLine = argv[1];
        runCom(strLine);
    } else {
        while (true) {
            std::cout << ">";
            std::getline(std::cin, strLine);
            if (runCom(strLine)) {
                return 0;
            }
        }
    }
	return 0;
}

bool runCom(std::string command) {
    yyin = command.c_str();
    CToken ct;
    void* pParser = ParseAlloc (malloc);
    Parse (pParser, QSTART, ct);
    while (true) {
        ct = yylex();
        if (ct.type == EXIT) {
            return true;
        }
        else if (ct.type == ERROR) {
            std::cout << "lexcer error!" << std::endl;
            break;
        } else if (ct.type == END) {
            Parse (pParser, QEND, ct);
            Parse (pParser, ct.type, ct);
            break;
        } else {
            Parse (pParser, ct.type, ct);
        }
    }
    ParseFree(pParser, free );
    return false;
}
