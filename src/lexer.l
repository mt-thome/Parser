%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"

    extern int line_count;
    int line_count = 1;
%}

DIGITO [0-9]
PRIMEIRA_LETRA [a-zA-UW-Z]
LETRA [a-zA-Z]
ID {PRIMEIRA_LETRA}({LETRA}|{DIGITO}|_)*
INT {DIGITO}+
FLOAT {DIGITO}+"."{DIGITO}+
STRING \"[^\"]*\"

%%

"siu"           { return IF; }
"autre"         { return ELSE; }
"sinon siu"     { return ELIF; }
"changer"       { return SWITCH; }
"cas"           { return CASE; }
"defaut"        { return DEFAULT; }
"casser"        { return BREAK; }
"continuer"     { return CONTINUE; }
"retour"        { return RETURN; }
"faire"         { return DO; }
"dembele"       { return WHILE; }
"mbappe"        { return FOR; }

"+"     { return PLUS; }
"-"     { return MINUS; }
"X"     { return MULT; }
"/"     { return DIV; }
":"     { return ASSIGN; }
"Ʌ"     { return LT; }
"V"     { return GT; }
"V/"    { return LE; }
"::"    { return EQ; }
"ney:"  { return NE; }
"ney"   { return NOT; }

{ID}    { yylval.string = strdup(yytext); return ID; }

{STRING} { yylval.string = strdup(yytext); return STRING; }
{FLOAT} { yylval.fval = atof(yytext); return FLOAT; }
{INT}   { yylval.ival = atoi(yytext); return INT; }

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }

"//".* { /* Ignora comentário de linha única */ }
"/*"([^*]|"*"[^/])*"*/" { /* Ignora comentário de múltiplas linhas */ }

[ \t\r]+        { /* Ignora espaços, tabs e carriage return */ }
\n              { line_count++; /* Incrementa o contador de linha */ }

.               { printf("LINHA %d: ERRO LÉXICO! Caractere desconhecido: '%s'\n", line_count, yytext); }

%%

int yywrap(){
    return 1;
}