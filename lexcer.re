#include <sstream>
#define LEXCER 1
#include "token.h"

/*!re2c
   re2c:define:YYCTYPE = "unsigned char";
   re2c:define:YYCURSOR = yyin;
   re2c:define:YYMARKER = yymk;
   re2c:yyfill:enable = 0;
   re2c:indent:top = 1;
   dexInt = [0-9]+;
   hexInt = '0'[xX][0-9a-fA-F]+;
   id = '$' [a-zA-Z_][0-9a-zA-Z_]*;
   float = [0-9]+ '.' [0-9]+;
   space  = [ \t\r\n];
 */

CToken yylex()
{
    CToken ret;
start:
    yyold = yyin;
/*!re2c
'+'    {
    ret.type = PLUS;
    return ret;
}
'-'    {
    ret.type = MINUS;
    return ret;
}
'*'    {
    ret.type = MULTIPLY;
    return ret;
}
'/'    {
    ret.type = DIVIDE;
    return ret;
}
'%'    {
    ret.type = MODIFY;
    return ret;
}
'('    {
    ret.type = PARENT1;
    return ret;
}
')'    {
    ret.type = PARENT2;
    return ret;
}
'='    {
    ret.type = EQUAL;
    return ret;
}
'exit' {
    ret.type = EXIT;
    return ret;
}
dexInt {
    ret.type = INTEGER;
    std::stringstream ss;
    while(yyold < yyin)ss << *yyold++;
    std::istringstream is(ss.str());
    is >> ret.value;
    return ret;
}
hexInt {
    ret.type = INTEGER;
    std::stringstream ss;
    while(yyold < yyin)ss << *yyold++;
    std::istringstream is(ss.str());
    is >> std::hex >> ret.value;
    return ret;
}
float  {
    ret.type = FLOAT;
    std::stringstream ss;
    while(yyold < yyin)ss << *yyold++;
    std::istringstream is(ss.str());
    is >> ret.dvalue;
    return ret;
}
id     {
    ret.type = IDENTFY;
    std::stringstream ss;
    while(yyold < yyin)ss << *yyold++;
    std::cout << "id : " << ss.str() << std::endl;
    ret.svalue = (char*)(ss.str().c_str());
    std::cout << "id : " << ret.svalue << std::endl;
    return ret;
}
space  {
    goto start;
}
[\000] {
    ret.type = END;
    return ret;
}
[^\000] {
    ret.type = ERROR;
    return ret;
}
 */
}
