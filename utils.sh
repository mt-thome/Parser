#!/bin/bash
# Script de utilidades para o Parser

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Parser - Menu de Utilidades      ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# Função para mostrar o menu
show_menu() {
    echo -e "${GREEN}Escolha uma opção:${NC}"
    echo "  1) Compilar o parser"
    echo "  2) Executar todos os testes"
    echo "  3) Executar um teste específico"
    echo "  4) Criar novo arquivo de teste"
    echo "  5) Limpar arquivos compilados"
    echo "  6) Recompilar tudo (clean + make)"
    echo "  7) Ver estrutura do projeto"
    echo "  8) Ver documentação"
    echo "  9) Sair"
    echo ""
    echo -n "Opção: "
}

# Função para compilar
compile() {
    echo -e "${YELLOW}Compilando...${NC}"
    make
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Compilação bem-sucedida!${NC}"
    else
        echo -e "${RED}✗ Erro na compilação${NC}"
    fi
}

# Função para executar todos os testes
run_all_tests() {
    echo -e "${YELLOW}Executando todos os testes...${NC}"
    make test
}

# Função para executar teste específico
run_specific_test() {
    echo -e "${YELLOW}Testes disponíveis:${NC}"
    ls -1 tests/*.txt | nl
    echo ""
    echo -n "Escolha o número do teste: "
    read test_num
    
    test_file=$(ls -1 tests/*.txt | sed -n "${test_num}p")
    
    if [ -n "$test_file" ]; then
        echo -e "${YELLOW}Executando $test_file...${NC}"
        echo ""
        ./parser "$test_file"
    else
        echo -e "${RED}✗ Teste inválido${NC}"
    fi
}

# Função para criar novo teste
create_test() {
    echo -n "Nome do arquivo (sem extensão): "
    read test_name
    
    test_file="tests/${test_name}.txt"
    
    if [ -f "$test_file" ]; then
        echo -e "${RED}✗ Arquivo já existe!${NC}"
        return
    fi
    
    cat > "$test_file" << 'EOF'
// Novo teste
x : 10;
y : 20;

siu (x Ʌ y) {
    resultado : y;
} autre {
    resultado : x;
}
EOF
    
    echo -e "${GREEN}✓ Arquivo criado: $test_file${NC}"
    echo "Edite o arquivo para adicionar seu código."
}

# Função para limpar
clean() {
    echo -e "${YELLOW}Limpando...${NC}"
    make clean
    echo -e "${GREEN}✓ Arquivos limpos${NC}"
}

# Função para recompilar
recompile() {
    echo -e "${YELLOW}Recompilando tudo...${NC}"
    make clean && make
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Recompilação bem-sucedida!${NC}"
    else
        echo -e "${RED}✗ Erro na recompilação${NC}"
    fi
}

# Função para ver estrutura
show_structure() {
    echo -e "${YELLOW}Estrutura do projeto:${NC}"
    tree -L 2 -I 'build' || ls -R
}

# Função para ver documentação
show_docs() {
    echo -e "${YELLOW}Documentação disponível:${NC}"
    echo ""
    echo "  README.md          - Documentação principal"
    echo "  STATUS.md          - Status do projeto"
    echo "  docs/QUICKSTART.md - Guia de início rápido"
    echo "  docs/REFERENCE.md  - Referência da linguagem"
    echo ""
    echo -n "Deseja abrir algum? (readme/status/quickstart/reference/n): "
    read doc_choice
    
    case $doc_choice in
        readme)
            less README.md
            ;;
        status)
            less STATUS.md
            ;;
        quickstart)
            less docs/QUICKSTART.md
            ;;
        reference)
            less docs/REFERENCE.md
            ;;
        *)
            echo "Nenhum arquivo aberto."
            ;;
    esac
}

# Loop principal
while true; do
    show_menu
    read option
    echo ""
    
    case $option in
        1)
            compile
            ;;
        2)
            run_all_tests
            ;;
        3)
            run_specific_test
            ;;
        4)
            create_test
            ;;
        5)
            clean
            ;;
        6)
            recompile
            ;;
        7)
            show_structure
            ;;
        8)
            show_docs
            ;;
        9)
            echo -e "${GREEN}Até logo!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}────────────────────────────────────────${NC}"
    echo ""
done
