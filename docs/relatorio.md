# Relatório Técnico: Parser para Linguagem de Programação Personalizada

**Autores:** Matheus Thomé da Silva e Mário Lúcio Collinetti Junior

---

# PARTE I - Gramática Livre de Contexto (GLC)

## 1. Descrição Formal da Gramática

### 1.1 Definição

Seja $G = (V, \Sigma, P, S)$ uma gramática livre de contexto, onde:

- **V** = {program, stmt_list, stmt, block, assignment_stmt, expr, term, factor, condition, comparison, if_stmt, elif_list, elif_stmt, else_stmt, while_stmt, do_while_stmt, for_stmt, switch_stmt, case_list, case_stmt, default_stmt, return_stmt, break_stmt, continue_stmt}

- **Σ** = {IF, ELSE, ELIF, SWITCH, CASE, DEFAULT, BREAK, CONTINUE, RETURN, DO, WHILE, FOR, PLUS, MINUS, MULT, DIV, ASSIGN, LT, GT, LE, EQ, NE, NOT, SEMICOLON, COMMA, LPAREN, RPAREN, LBRACE, RBRACE, ID, INT, FLOAT, STRING}

- **S** = program

- **P** = conjunto de produções definidas abaixo

### 1.2 Conjunto de Produções (P)

#### Produções para o Programa Principal

```
P1:  program → stmt_list
```

#### Produções para Lista de Comandos

```
P2:  stmt_list → stmt_list stmt
P3:  stmt_list → stmt
P4:  stmt_list → ε
```

#### Produções para Comandos

```
P5:  stmt → assignment_stmt SEMICOLON
P6:  stmt → if_stmt
P7:  stmt → while_stmt
P8:  stmt → do_while_stmt
P9:  stmt → for_stmt
P10: stmt → switch_stmt
P11: stmt → return_stmt SEMICOLON
P12: stmt → break_stmt SEMICOLON
P13: stmt → continue_stmt SEMICOLON
P14: stmt → block
```

#### Produções para Blocos

```
P15: block → LBRACE stmt_list RBRACE
```

#### Produções para Atribuição

```
P16: assignment_stmt → ID ASSIGN expr
```

#### Produções para Expressões Aritméticas

```
P17: expr → expr PLUS term
P18: expr → expr MINUS term
P19: expr → term

P20: term → term MULT factor
P21: term → term DIV factor
P22: term → factor

P23: factor → LPAREN expr RPAREN
P24: factor → LPAREN condition RPAREN
P25: factor → ID
P26: factor → INT
P27: factor → FLOAT
P28: factor → STRING
P29: factor → NOT factor
```

#### Produções para Condições

```
P30: condition → expr comparison expr
P31: condition → LPAREN condition RPAREN
P32: condition → NOT condition

P33: comparison → LT
P34: comparison → GT
P35: comparison → LE
P36: comparison → EQ
P37: comparison → NE
```

#### Produções para Estrutura If-Elif-Else

```
P38: if_stmt → IF LPAREN condition RPAREN block elif_list else_stmt
P39: if_stmt → IF LPAREN condition RPAREN block elif_list
P40: if_stmt → IF LPAREN condition RPAREN block else_stmt
P41: if_stmt → IF LPAREN condition RPAREN block

P42: elif_list → elif_list elif_stmt
P43: elif_list → elif_stmt

P44: elif_stmt → ELIF LPAREN condition RPAREN block

P45: else_stmt → ELSE block
```

#### Produções para Loops

```
P46: while_stmt → WHILE LPAREN condition RPAREN block

P47: do_while_stmt → DO block WHILE LPAREN condition RPAREN SEMICOLON

P48: for_stmt → FOR LPAREN assignment_stmt SEMICOLON condition SEMICOLON assignment_stmt RPAREN block
```

#### Produções para Switch-Case

```
P49: switch_stmt → SWITCH LPAREN expr RPAREN LBRACE case_list default_stmt RBRACE
P50: switch_stmt → SWITCH LPAREN expr RPAREN LBRACE case_list RBRACE

P51: case_list → case_list case_stmt
P52: case_list → case_stmt

P53: case_stmt → CASE expr ASSIGN stmt_list

P54: default_stmt → DEFAULT ASSIGN stmt_list
```

#### Produções para Comandos de Controle

```
P55: return_stmt → RETURN expr
P56: return_stmt → RETURN

P57: break_stmt → BREAK

P58: continue_stmt → CONTINUE
```

### 1.3 Tokens Terminais e suas Representações

| Token | Símbolo na Linguagem | Descrição |
|-------|---------------------|-----------|
| IF | `siu` | Condicional if |
| ELSE | `autre` | Else |
| ELIF | `sinon siu` | Elif |
| SWITCH | `changer` | Switch |
| CASE | `cas` | Case |
| DEFAULT | `defaut` | Default |
| BREAK | `casser` | Break |
| CONTINUE | `continuer` | Continue |
| RETURN | `retour` | Return |
| DO | `faire` | Do |
| WHILE | `dembele` | While |
| FOR | `mbappe` | For |
| PLUS | `+` | Adição |
| MINUS | `-` | Subtração |
| MULT | `X` | Multiplicação |
| DIV | `/` | Divisão |
| ASSIGN | `:` | Atribuição |
| LT | `Ʌ` | Menor que |
| GT | `V` | Maior que |
| LE | `V/` | Menor ou igual |
| EQ | `::` | Igual |
| NE | `ney:` | Diferente |
| NOT | `ney` | Negação |
| SEMICOLON | `;` | Ponto e vírgula |
| COMMA | `,` | Vírgula |
| LPAREN | `(` | Abre parênteses |
| RPAREN | `)` | Fecha parênteses |
| LBRACE | `{` | Abre chaves |
| RBRACE | `}` | Fecha chaves |
| ID | [a-zA-UW-Z][a-zA-Z0-9_]* | Identificador |
| INT | [0-9]+ | Número inteiro |
| FLOAT | [0-9]+.[0-9]+ | Número decimal |
| STRING | "[^"]*" | String literal |

### 1.4 Precedência e Associatividade de Operadores

| Precedência | Operador | Associatividade | Descrição |
|-------------|----------|-----------------|-----------|
| 1 (menor) | `::`, `ney:` | Esquerda | Comparação de igualdade |
| 2 | `Ʌ`, `V`, `V/` | Esquerda | Comparação relacional |
| 3 | `+`, `-` | Esquerda | Aditivos |
| 4 | `X`, `/` | Esquerda | Multiplicativos |
| 5 | `ney` | Direita | Negação |
| 6 (maior) | `:` | Direita | Atribuição |

### 1.5 Análise da Gramática

#### 1.5.1 Características Estruturais

1. **Recursividade:**
   - Recursão à esquerda em expressões aritméticas (P17, P18, P20, P21)
   - Recursão à esquerda em listas (P2, P42, P51)
   - Recursão à direita em fatores (P29) e condições (P32)

2. **Não-determinismo:**
   - A gramática apresenta conflitos shift/reduce devido à natureza das expressões
   - Resolvidos através de declarações de precedência no analisador

3. **Cobertura:**
   - Suporta estruturas imperativas básicas
   - Expressões aritméticas completas
   - Estruturas de controle aninhadas

#### 1.5.2 Exemplo de Derivação

Para o programa: `x : 10;`

```
program 
⟹ (P1) stmt_list
⟹ (P3) stmt
⟹ (P5) assignment_stmt SEMICOLON
⟹ (P16) ID ASSIGN expr SEMICOLON
⟹ (P19) ID ASSIGN term SEMICOLON
⟹ (P22) ID ASSIGN factor SEMICOLON
⟹ (P26) ID ASSIGN INT SEMICOLON
⟹ x : 10 ;
```

Para o programa: `siu (x Ʌ 5) { y : 1; }`

```
program
⟹ (P1) stmt_list
⟹ (P3) stmt
⟹ (P6) if_stmt
⟹ (P41) IF LPAREN condition RPAREN block
⟹ (P30) IF LPAREN expr comparison expr RPAREN block
⟹ (P33) IF LPAREN expr LT expr RPAREN block
⟹ ... IF LPAREN ID LT INT RPAREN block
⟹ (P15) IF LPAREN ID LT INT RPAREN LBRACE stmt_list RBRACE
⟹ ... siu ( x Ʌ 5 ) { y : 1 ; }
```

---

# PARTE II - Manual do Usuário

## 2. Introdução

Este manual descreve como utilizar o parser para a linguagem de programação personalizada, incluindo instalação, compilação, execução e escrita de programas.

## 3. Requisitos do Sistema

### 3.1 Software Necessário

- **Sistema Operacional:** Linux (testado em Ubuntu/Debian)
- **Compilador C:** GCC
- **Flex:** Gerador de analisadores léxicos (≥ 2.6)
- **Bison:** Gerador de analisadores sintáticos (≥ 3.0)
- **Make:** Sistema de automação de compilação

### 3.2 Instalação das Dependências

```bash
sudo apt update
sudo apt install gcc flex bison make
```

## 4. Compilação do Parser

### 4.1 Compilando o Projeto

Navegue até o diretório do projeto

```bash
cd /caminho/para/Parser
```

Compile o parser
```bash
make
```

O executável 'parser' será criado no diretório atual



## 5. Executando o Parser

### 5.1 Sintaxe de Execução

```bash
./parser <arquivo_de_entrada>
```

### 5.2 Exemplos de Execução

```bash
# Executar um teste simples
./parser tests/test_simple.txt

# Executar todos os testes
make test
```

### 5.3 Saída do Parser

O parser fornece feedback detalhado durante a análise:

```
=== INICIANDO ANÁLISE SINTÁTICA ===

  Inteiro: 10
  Atribuição: x := expressão
Reconhecido: Atribuição
  ...

=== ANÁLISE SINTÁTICA CONCLUÍDA COM SUCESSO ===
Programa sintaticamente correto!

=== ANÁLISE FINALIZADA ===
```

Em caso de erro:

```
ERRO SINTÁTICO na linha 5: syntax error

=== ANÁLISE FINALIZADA COM ERROS ===
```

## 6. Sintaxe da Linguagem

### 6.1 Estrutura Básica

Todo programa consiste em uma sequência de comandos. Cada comando deve terminar com ponto e vírgula (`;`), exceto blocos delimitados por chaves.

### 6.2 Comentários

```
// Comentário de linha única

/* Comentário de
   múltiplas linhas */
```

### 6.3 Tipos de Dados

#### 6.3.1 Números Inteiros

```
x : 42;
y : -15;
contador : 0;
```

#### 6.3.2 Números Decimais (Float)

```
pi : 3.14159;
taxa : 0.05;
temperatura : -2.5;
```

#### 6.3.3 Strings

```
nome : "João Silva";
mensagem : "Olá, mundo!";
vazio : "";
```

#### 6.3.4 Identificadores

- Começam com letra (exceto `V`)
- Podem conter letras, dígitos e underscore (`_`)
- Exemplos: `x`, `contador`, `valor_total`, `temp2`

### 6.4 Operadores

#### 6.4.1 Operadores Aritméticos

```
soma : a + b;           // Adição
diferenca : a - b;      // Subtração
produto : a X b;        // Multiplicação
quociente : a / b;      // Divisão
```

#### 6.4.2 Operadores de Comparação

```
siu (x Ʌ y) { }         // Menor que
siu (x V y) { }         // Maior que
siu (x V/ y) { }        // Menor ou igual
siu (x :: y) { }        // Igual
siu (x ney: y) { }      // Diferente
```

#### 6.4.3 Operador de Negação

```
siu (ney (x V y)) { }   // Negação de condição
inverso : ney verdadeiro;
```

### 6.5 Atribuições

```
// Sintaxe: identificador : expressão;
x : 10;
y : x + 5;
z : (a + b) X (c - d) / e;
```

### 6.6 Estruturas de Controle

#### 6.6.1 If Simples

```
siu (x V 10) {
    resultado : x;
}
```

#### 6.6.2 If-Else

```
siu (x Ʌ y) {
    menor : x;
} autre {
    menor : y;
}
```

#### 6.6.3 If-Elif-Else

```
siu (nota V/ 10) {
    conceito : "A";
} sinon siu (nota V/ 8) {
    conceito : "B";
} sinon siu (nota V/ 6) {
    conceito : "C";
} autre {
    conceito : "D";
}
```

### 6.7 Estruturas de Repetição

#### 6.7.1 While

```
contador : 0;
dembele (contador Ʌ 10) {
    soma : soma + contador;
    contador : contador + 1;
}
```

#### 6.7.2 Do-While

```
contador : 5;
faire {
    contador : contador - 1;
} dembele (contador V 0);
```

#### 6.7.3 For

```
// Sintaxe: mbappe (init; condition; increment) { }
mbappe (i : 0; i Ʌ 10; i : i + 1) {
    total : total + i;
}
```

### 6.8 Estrutura Switch-Case

```
changer (opcao) {
    cas 1: {
        acao : "Novo";
        casser;
    }
    cas 2: {
        acao : "Abrir";
        casser;
    }
    cas 3: {
        acao : "Salvar";
        casser;
    }
    defaut: {
        acao : "Cancelar";
    }
}
```

### 6.9 Comandos de Controle de Fluxo

#### 6.9.1 Break (casser)

```
dembele (verdadeiro) {
    siu (condicao) {
        casser;  // Sai do loop
    }
}
```

#### 6.9.2 Continue (continuer)

```
mbappe (i : 0; i Ʌ 10; i : i + 1) {
    siu (i :: 5) {
        continuer;  // Pula para próxima iteração
    }
    processar : i;
}
```

#### 6.9.3 Return (retour)

```
// Return com valor
retour resultado;

// Return sem valor
retour;
```

## 7. Exemplos Práticos

### 7.1 Exemplo 1: Cálculo de Média

```
// Cálculo de média de 4 notas
nota1 : 8;
nota2 : 7;
nota3 : 9;
nota4 : 6;

soma : nota1 + nota2 + nota3 + nota4;
media : soma / 4;

siu (media V/ 7) {
    status : "Aprovado";
} autre {
    status : "Reprovado";
}
```

### 7.2 Exemplo 2: Fatorial

```
n : 5;
fatorial : 1;
i : 1;

dembele (i V/ n) {
    fatorial : fatorial X i;
    i : i + 1;
}
// fatorial = 120
```

### 7.3 Exemplo 3: Soma de Números Pares

```
soma : 0;
mbappe (i : 0; i V/ 20; i : i + 2) {
    soma : soma + i;
}
// soma = 110 (0+2+4+...+20)
```

### 7.4 Exemplo 4: Menu com Switch

```
opcao : 2;

changer (opcao) {
    cas 1: {
        msg : "Cadastrar";
        casser;
    }
    cas 2: {
        msg : "Consultar";
        casser;
    }
    cas 3: {
        msg : "Alterar";
        casser;
    }
    cas 4: {
        msg : "Excluir";
        casser;
    }
    defaut: {
        msg : "Opção inválida";
    }
}
```

## 8. Boas Práticas

### 8.1 Formatação de Código

1. **Indentação:** Use 4 espaços para cada nível de indentação
2. **Espaçamento:** Coloque espaços ao redor dos operadores
3. **Comentários:** Documente seções complexas do código
4. **Organização:** Agrupe declarações relacionadas

### 8.2 Nomenclatura

- Use nomes descritivos para variáveis
- Prefira `contador` a `c`
- Use snake_case para identificadores compostos: `valor_total`

### 8.3 Estruturação

```
// BOM: código organizado
x : 10;
y : 20;

siu (x V y) {
    maior : y;
}

// EVITE: código desorganizado
x:10;y:20;siu(x V y){maior:y;}
```

## 9. Resolução de Problemas

### 9.1 Erros Comuns

#### 9.1.1 Erro: "syntax error"

**Causa:** Erro de sintaxe no código fonte

**Solução:**
- Verifique se todos os comandos terminam com `;`
- Confirme que parênteses e chaves estão balanceados
- Verifique a sintaxe dos operadores

#### 9.1.2 Erro: "Erro ao abrir o arquivo"

**Causa:** Arquivo não encontrado

**Solução:**
```bash
# Verifique se o arquivo existe
ls -l tests/test_simple.txt

# Use o caminho correto
./parser tests/test_simple.txt
```

#### 9.1.3 Erro de Compilação

**Causa:** Dependências não instaladas

**Solução:**
```bash
sudo apt install gcc flex bison
make clean && make
```

## 10. Referência Rápida

### 10.1 Palavras-chave

| Palavra-chave | Equivalente | Uso |
|---------------|-------------|-----|
| siu | if | Condicional |
| autre | else | Alternativa |
| sinon siu | elif | Condicional encadeada |
| dembele | while | Loop com condição |
| faire | do | Do-while |
| mbappe | for | Loop com contador |
| changer | switch | Seleção múltipla |
| cas | case | Caso do switch |
| defaut | default | Caso padrão |
| casser | break | Interrompe loop |
| continuer | continue | Próxima iteração |
| retour | return | Retorna valor |
| ney | not | Negação |

### 10.2 Operadores

| Operador | Operação | Exemplo |
|----------|----------|---------|
| + | Adição | `a + b` |
| - | Subtração | `a - b` |
| X | Multiplicação | `a X b` |
| / | Divisão | `a / b` |
| : | Atribuição | `x : 10` |
| Ʌ | Menor | `x Ʌ y` |
| V | Maior | `x V y` |
| V/ | Menor ou igual | `x V/ y` |
| :: | Igual | `x :: y` |
| ney: | Diferente | `x ney: y` |
| ney | Negação | `ney x` |

## 11. Conclusão

Este parser implementa um analisador sintático completo para uma linguagem de programação personalizada, utilizando Flex para análise léxica e Bison para análise sintática. A gramática suporta estruturas imperativas fundamentais e fornece feedback detalhado durante a análise.
