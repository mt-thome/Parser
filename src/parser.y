%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
    extern int yylex();
    extern FILE *yyin;
    extern int line_count;
    
    void yyerror(const char* s);
%}

%union {
    int ival;
    float fval;
    char* string;
}

%token <ival> INT
%token <fval> FLOAT
%token <string> ID STRING

%token IF ELSE ELIF SWITCH CASE DEFAULT BREAK CONTINUE RETURN DO WHILE FOR
%token PLUS MINUS MULT DIV ASSIGN LT GT LE EQ NE NOT
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE

%left EQ NE
%left LT GT LE
%left PLUS MINUS
%left MULT DIV
%right NOT
%right ASSIGN

%type <string> program stmt_list stmt assignment_stmt expr term factor
%type <string> if_stmt elif_list elif_stmt else_stmt
%type <string> while_stmt do_while_stmt for_stmt
%type <string> switch_stmt case_list case_stmt default_stmt
%type <string> return_stmt break_stmt continue_stmt
%type <string> block condition comparison

%%

program:
    stmt_list                   { 
                                    printf("\n=== ANÁLISE SINTÁTICA CONCLUÍDA COM SUCESSO ===\n"); 
                                    printf("Programa sintaticamente correto!\n");
                                }
    ;

stmt_list:
    stmt_list stmt              { }
    | stmt                      { }
    | /* vazio */               { }
    ;

stmt:
    assignment_stmt SEMICOLON   { printf("Reconhecido: Atribuição\n"); }
    | if_stmt                   { printf("Reconhecido: Estrutura condicional (if)\n"); }
    | while_stmt                { printf("Reconhecido: Loop while\n"); }
    | do_while_stmt             { printf("Reconhecido: Loop do-while\n"); }
    | for_stmt                  { printf("Reconhecido: Loop for\n"); }
    | switch_stmt               { printf("Reconhecido: Estrutura switch\n"); }
    | return_stmt SEMICOLON     { printf("Reconhecido: Comando return\n"); }
    | break_stmt SEMICOLON      { printf("Reconhecido: Comando break\n"); }
    | continue_stmt SEMICOLON   { printf("Reconhecido: Comando continue\n"); }
    | block                     { printf("Reconhecido: Bloco de comandos\n"); }
    ;

block:
    LBRACE stmt_list RBRACE     { }
    ;

assignment_stmt:
    ID ASSIGN expr              { printf("  Atribuição: %s := expressão\n", $1); }
    ;

expr:
    expr PLUS term              { printf("  Operação: +\n"); }
    | expr MINUS term           { printf("  Operação: -\n"); }
    | term                      { }
    ;

term:
    term MULT factor            { printf("  Operação: X\n"); }
    | term DIV factor           { printf("  Operação: /\n"); }
    | factor                    { }
    ;

factor:
    LPAREN expr RPAREN          { }
    | LPAREN condition RPAREN   { printf("  Condição entre parênteses\n"); }
    | ID                        { printf("  Variável: %s\n", $1); }
    | INT                       { printf("  Inteiro: %d\n", $1); }
    | FLOAT                     { printf("  Float: %f\n", $1); }
    | STRING                    { printf("  String: %s\n", $1); }
    | NOT factor                { printf("  Operação: ney (negação)\n"); }
    ;

condition:
    expr comparison expr        { printf("  Condição avaliada\n"); }
    | LPAREN condition RPAREN   { }
    | NOT condition             { printf("  Negação de condição\n"); }
    ;

comparison:
    LT                          { printf("  Comparação: Ʌ (menor)\n"); }
    | GT                        { printf("  Comparação: V (maior)\n"); }
    | LE                        { printf("  Comparação: V/ (menor ou igual)\n"); }
    | EQ                        { printf("  Comparação: :: (igual)\n"); }
    | NE                        { printf("  Comparação: ney: (diferente)\n"); }
    ;

if_stmt:
    IF LPAREN condition RPAREN block elif_list else_stmt
                                { printf("  Estrutura if completa\n"); }
    | IF LPAREN condition RPAREN block elif_list
                                { printf("  Estrutura if com elif\n"); }
    | IF LPAREN condition RPAREN block else_stmt
                                { printf("  Estrutura if-else\n"); }
    | IF LPAREN condition RPAREN block
                                { printf("  Estrutura if simples\n"); }
    ;

elif_list:
    elif_list elif_stmt         { }
    | elif_stmt                 { }
    ;

elif_stmt:
    ELIF LPAREN condition RPAREN block
                                { printf("  Bloco elif reconhecido\n"); }
    ;

else_stmt:
    ELSE block                  { printf("  Bloco else reconhecido\n"); }
    ;

while_stmt:
    WHILE LPAREN condition RPAREN block
                                { printf("  Loop while completo\n"); }
    ;

do_while_stmt:
    DO block WHILE LPAREN condition RPAREN SEMICOLON
                                { printf("  Loop do-while completo\n"); }
    ;

for_stmt:
    FOR LPAREN assignment_stmt SEMICOLON condition SEMICOLON assignment_stmt RPAREN block
                                { printf("  Loop for completo\n"); }
    ;

switch_stmt:
    SWITCH LPAREN expr RPAREN LBRACE case_list default_stmt RBRACE
                                { printf("  Switch com default\n"); }
    | SWITCH LPAREN expr RPAREN LBRACE case_list RBRACE
                                { printf("  Switch sem default\n"); }
    ;

case_list:
    case_list case_stmt         { }
    | case_stmt                 { }
    ;

case_stmt:
    CASE expr ASSIGN stmt_list  { printf("  Caso reconhecido\n"); }
    ;

default_stmt:
    DEFAULT ASSIGN stmt_list    { printf("  Default reconhecido\n"); }
    ;

return_stmt:
    RETURN expr                 { printf("  Return com expressão\n"); }
    | RETURN                    { printf("  Return vazio\n"); }
    ;

break_stmt:
    BREAK                       { }
    ;

continue_stmt:
    CONTINUE                    { }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "ERRO SINTÁTICO na linha %d: %s\n", line_count, s);
}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        printf("Uso: %s <arquivo de entrada>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if(input_file == NULL) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    yyin = input_file;
    
    printf("=== INICIANDO ANÁLISE SINTÁTICA ===\n\n");
    
    int result = yyparse();
    
    fclose(input_file);
    
    if(result == 0) {
        printf("\n=== ANÁLISE FINALIZADA ===\n");
        return 0;
    } else {
        printf("\n=== ANÁLISE FINALIZADA COM ERROS ===\n");
        return 1;
    }
}  