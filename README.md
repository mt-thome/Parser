# Parser para Linguagem de Programação Personalizada

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Language](https://img.shields.io/badge/language-C-orange.svg)]()
[![Flex](https://img.shields.io/badge/flex-2.6+-green.svg)]()
[![Bison](https://img.shields.io/badge/bison-3.0+-green.svg)]()

Um analisador léxico e sintático completo para uma linguagem de programação imperativa com palavras-chave em francês e símbolos matemáticos especiais.

## Índice

- [Características](#-características)
- [Demonstração](#-demonstração)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [Sintaxe da Linguagem](#-sintaxe-da-linguagem)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Documentação](#-documentação)
- [Testes](#-testes)
- [Licença](#-licença)

## Características

- ✅ **Analisador Léxico** (Flex) - Reconhecimento de tokens
- ✅ **Analisador Sintático** (Bison) - Validação da estrutura do programa
- ✅ **Palavras-chave em Francês** - Sintaxe única e criativa
- ✅ **Operadores Matemáticos** - Símbolos especiais (Ʌ, V, X, etc.)
- ✅ **Estruturas de Controle** - if/elif/else, while, do-while, for, switch/case
- ✅ **Detecção de Erros** - Mensagens informativas com número de linha
- ✅ **Feedback Detalhado** - Rastreamento da análise em tempo real
- ✅ **Suite de Testes** - 6 arquivos de teste incluídos

## Demonstração

### Código de Exemplo

```
// Cálculo de média
nota1 : 8;
nota2 : 7;
soma : nota1 + nota2;
media : soma / 2;

siu (media V/ 7) {
    status : "Aprovado";
} autre {
    status : "Reprovado";
}
```

### Saída do Parser

```
=== INICIANDO ANÁLISE SINTÁTICA ===

  Inteiro: 8
  Atribuição: nota1 := expressão
Reconhecido: Atribuição
...
=== ANÁLISE SINTÁTICA CONCLUÍDA COM SUCESSO ===
Programa sintaticamente correto!
```

## Instalação

### Pré-requisitos

- GCC (Compilador C)
- Flex (≥ 2.6)
- Bison (≥ 3.0)
- Make

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install gcc flex bison make
```

### Compilação

```bash
# Clone o repositório
git clone https://github.com/mt-thome/LexicalAnalyzer.git
cd LexicalAnalyzer/Parser

# Compile o parser
make

# Execute um teste
./parser tests/test_simple.txt
```

## Uso

### Sintaxe Básica

```bash
./parser <arquivo_de_entrada>
```

### Exemplos

```bash
# Executar um teste específico
./parser tests/test_simple.txt

# Executar todos os testes
make test

# Usar o menu interativo
./utils.sh

# Limpar arquivos compilados
make clean
```

## Sintaxe da Linguagem

### Palavras-chave

| Palavra | Significado | Uso |
|---------|-------------|-----|
| `siu` | if | Condicional |
| `autre` | else | Alternativa |
| `sinon siu` | elif | Condicional encadeada |
| `dembele` | while | Loop |
| `faire` | do | Do-while |
| `mbappe` | for | Loop com contador |
| `changer` | switch | Seleção múltipla |
| `retour` | return | Retorno |
| `casser` | break | Interrompe loop |
| `continuer` | continue | Próxima iteração |

### Operadores

```
Aritméticos:  +  -  X  /
Atribuição:   :
Comparação:   Ʌ  V  V/  ::  ney:
Lógico:       ney (negação)
```

### Estruturas de Controle

#### If-Elif-Else

```
siu (x V 10) {
    resultado : "maior";
} sinon siu (x :: 10) {
    resultado : "igual";
} autre {
    resultado : "menor";
}
```

#### Loops

```
// While
dembele (contador Ʌ 10) {
    contador : contador + 1;
}

// Do-While
faire {
    contador : contador - 1;
} dembele (contador V 0);

// For
mbappe (i : 0; i Ʌ 10; i : i + 1) {
    soma : soma + i;
}
```

#### Switch-Case

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
    defaut: {
        acao : "Cancelar";
    }
}
```

## Estrutura do Projeto

```
Parser/
├── src/
│   ├── lexer.l          # Analisador léxico (Flex)
│   └── parser.y         # Analisador sintático (Bison)
├── tests/
│   └── test_complete.txt     # Exemplo completo
├── docs/
│   ├── RELATORIO.md          # Relatório técnico 
├── Makefile                  # Sistema de build
├── utils.sh                  # Menu interativo
└── README.md                 # Este arquivo
```

## Documentação

A documentação completa está disponível em:

- **[RELATORIO.md](docs/RELATORIO.md)** - Gramática formal (GLC) e manual do usuário

## Testes

### Executar Todos os Testes

```bash
make test
```

### Arquivos de Teste Disponíveis

1. **test_complete.txt** - Exemplo de programa completo

### Criar Novo Teste

```bash
# Crie um arquivo em tests/
echo 'x : 10; y : 20; soma : x + y;' > tests/meu_teste.txt

# Execute
./parser tests/meu_teste.txt
```

## Gramática

A linguagem é definida por uma **Gramática Livre de Contexto (GLC)** com:

- **58 produções** cobrindo todas as estruturas
- **Precedência de operadores** definida explicitamente
- **Recursão à esquerda** para expressões aritméticas
- **Suporte a aninhamento** de estruturas de controle

### Exemplo de Derivação

Para o programa `x : 10;`:

```
program ⟹ stmt_list ⟹ stmt ⟹ assignment_stmt SEMICOLON 
        ⟹ ID ASSIGN expr SEMICOLON ⟹ x : 10 ;
```

Veja detalhes completos em [docs/RELATORIO.md](docs/RELATORIO.md).

## Ferramentas Auxiliares

### Menu Interativo

```bash
./utils.sh
```

Oferece opções para:
- Compilar o parser
- Executar testes
- Criar novos arquivos de teste
- Ver documentação
- Limpar projeto

### Makefile

```bash
make          # Compila o parser
make test     # Executa todos os testes
make clean    # Remove arquivos compilados
```

## Autor

**mt-thome**

- GitHub: [@mt-thome](https://github.com/mt-thome)
- Repositório: [LexicalAnalyzer](https://github.com/mt-thome/LexicalAnalyzer)

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
