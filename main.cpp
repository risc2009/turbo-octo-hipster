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
    while (true) {
        ct = yylex();
        if (ct.type == EXIT) {
            return true;
        }
        else if (ct.type == ERROR) {
            std::cout << "lexcer error!" << std::endl;
            break;
        } else {
            Parse (pParser, ct.type, ct);
            if (ct.type == END) {
                break;
            }
        }
    }
    ParseFree(pParser, free );
    return false;
}
