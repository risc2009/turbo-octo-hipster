%include {
    #ifdef linux
    #include <assert.h>
    #endif
    #include <math.h>
    #include <iostream>
    #include <iomanip>

    #include "token.h"
}

%token_type {CToken}
%default_type{CToken}

%type QSTART   { CToken }
%type QEND     { CToken }
%type expr    { CToken }
%type INTEGER { CToken }
%type FLOAT   { CToken }
%type IDENTFY { CToken }

%left EQUAL PLUSEQUAL MINUSEQUAL DIVIDEEQUAL MULTIPLYEQUAL MODIFYEQUAL.
%left PLUS MINUS.
%left DIVIDE MULTIPLY MODIFY.
%left PARENT1 PARENT2 ANGEL1 ANGEL2.

%syntax_error {
    std::cout << "Parser error!" << std::endl;
}

program ::= QSTART QEND. {
}

program ::= QSTART expr(A) QEND.  {
    switch(A.type){
    case FLOAT:
        std::cout << std::setprecision(14) << A.dvalue << std::endl;
        break;
    case INTEGER:
        std::cout << A.value << std::endl;
        break;
    }
}

expr(A) ::= IDENTFY(B) EQUAL expr(C). {
    hInst[hList[B.value]] = C;
    A.type = C.type;
    A.value = C.value;
    A.dvalue = C.dvalue;
}

expr(A) ::= IDENTFY(B) PLUSEQUAL expr(C). {
    if (hInst.find(hList[B.value]) == hInst.end()) {
        A.type = INTEGER;
        A.value = 0;
    } else {
        A = hInst[hList[B.value]];
    }
    if ( A.type == FLOAT || C.type == FLOAT) {
        A.dvalue =  (A.type == FLOAT ? A.dvalue : (double)A.value)
        + ( C.type == FLOAT ? C.dvalue : (double)C.value);
        A.type = FLOAT;
    } else {
        A.value = A.value + C.value;
        A.type = INTEGER;
    }
    hInst[hList[B.value]] = A;
}

expr(A) ::= IDENTFY(B) MINUSEQUAL expr(C). {
    if (hInst.find(hList[B.value]) == hInst.end()) {
        A.type = INTEGER;
        A.value = 0;
    } else {
        A = hInst[hList[B.value]];
    }
    if ( A.type == FLOAT || C.type == FLOAT) {
        A.dvalue =  (A.type == FLOAT ? A.dvalue : (double)A.value)
        - ( C.type == FLOAT ? C.dvalue : (double)C.value);
        A.type = FLOAT;
    } else {
        A.value -= C.value;
        A.type = INTEGER;
    }
    hInst[hList[B.value]] = A;
}

expr(A) ::= IDENTFY(B) DIVIDEEQUAL expr(C). {
    if (hInst.find(hList[B.value]) == hInst.end()) {
        A.type = INTEGER;
        A.value = 0;
    } else {
        A = hInst[hList[B.value]];
    }
    if ( A.type == FLOAT || C.type == FLOAT) {
        A.dvalue =  (A.type == FLOAT ? A.dvalue : (double)A.value)
        / ( C.type == FLOAT ? C.dvalue : (double)C.value);
        A.type = FLOAT;
    } else {
        A.value = A.value / C.value;
        A.type = INTEGER;
    }
    hInst[hList[B.value]] = A;
}

expr(A) ::= IDENTFY(B) MULTIPLYEQUAL expr(C). {
    if (hInst.find(hList[B.value]) == hInst.end()) {
        A.type = INTEGER;
        A.value = 0;
    } else {
        A = hInst[hList[B.value]];
    }
    if ( A.type == FLOAT || C.type == FLOAT) {
        A.dvalue =  (A.type == FLOAT ? A.dvalue : (double)A.value)
        / ( C.type == FLOAT ? C.dvalue : (double)C.value);
        A.type = FLOAT;
    } else {
        A.value = A.value / C.value;
        A.type = INTEGER;
    }
    hInst[hList[B.value]] = A;
}

expr(A) ::= IDENTFY(B) MODIFYEQUAL expr(C). {
    if (hInst.find(hList[B.value]) == hInst.end()) {
        A.type = INTEGER;
        A.value = 0;
    } else {
        A = hInst[hList[B.value]];
    }
    if ( A.type == FLOAT || C.type == FLOAT) {
        A.dvalue =  fmod((A.type == FLOAT ? A.dvalue : (double)A.value)
        ,( C.type == FLOAT ? C.dvalue : (double)C.value));
        A.type = FLOAT;
    } else {
        A.value = A.value % C.value;
        A.type = INTEGER;
    }
    hInst[hList[B.value]] = A;
}

expr(A) ::= expr(B) PLUS expr(C). {
    if ( B.type == FLOAT || C.type == FLOAT) {
        A.type = FLOAT;
        A.dvalue =  (B.type == FLOAT ? B.dvalue : (double)B.value)
            + ( C.type == FLOAT ? C.dvalue : (double)C.value);
    } else {
        A.type = INTEGER;
        A.value = B.value + C.value;
    }
}

expr(A) ::= expr(B) MINUS expr(C). {
    if ( B.type == FLOAT || C.type == FLOAT) {
        A.type = FLOAT;
        A.dvalue =  (B.type == FLOAT ? B.dvalue : (double)B.value)
        - ( C.type == FLOAT ? C.dvalue : (double)C.value);
    } else {
        A.type = INTEGER;
        A.value = B.value - C.value;
    }
}

expr(A) ::= expr(B) DIVIDE expr(C). {
    if ( B.type == FLOAT || C.type == FLOAT) {
        A.type = FLOAT;
        A.dvalue =  (B.type == FLOAT ? B.dvalue : (double)B.value)
        / ( C.type == FLOAT ? C.dvalue : (double)C.value);
    } else {
        A.type = INTEGER;
        A.value = B.value / C.value;
    }
}

expr(A) ::= expr(B) MULTIPLY expr(C). {
    if ( B.type == FLOAT || C.type == FLOAT) {
        A.type = FLOAT;
        A.dvalue =  (B.type == FLOAT ? B.dvalue : (double)B.value)
        * ( C.type == FLOAT ? C.dvalue : (double)C.value);
    } else {
        A.type = INTEGER;
        A.value = B.value * C.value;
    }
}

expr(A) ::= expr(B) MODIFY expr(C). {
    if ( B.type == FLOAT || C.type == FLOAT) {
        A.type = FLOAT;
        A.dvalue =  fmod((B.type == FLOAT ? B.dvalue : (double)B.value)
        , ( C.type == FLOAT ? C.dvalue : (double)C.value));
    } else {
        A.type = INTEGER;
        A.value = B.value % C.value;
    }
}

expr(A) ::= PARENT1 expr(B) PARENT2. {
    A.type = B.type;
    A.value = B.value;
    A.dvalue = B.dvalue;
}

expr ::= ANGEL1 expr ANGEL2. {
}

expr(A) ::= INTEGER(B). {
    A.type = INTEGER;
    A.value = B.value;
}

expr(A) ::= FLOAT(B). {
    A.type = FLOAT;
    A.dvalue = B.dvalue;
}

expr(A) ::= IDENTFY(B). {
    if (hInst.find(hList[B.value]) == hInst.end()) {
        A.type = INTEGER;
        A.value = 0;
    } else {
        A = hInst[hList[B.value]];
    }
}
