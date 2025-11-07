CC = gcc
CFLAGS = -Wall -g
LEXER = flex
PARSER = bison

TARGET = parser
SRC_DIR = src
BUILD_DIR = build

LEXER_SRC = $(SRC_DIR)/lexer.l
PARSER_SRC = $(SRC_DIR)/parser.y

LEXER_OUT = $(BUILD_DIR)/lex.yy.c
PARSER_OUT = $(BUILD_DIR)/parser.tab.c
PARSER_HDR = $(BUILD_DIR)/parser.tab.h

all: $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(PARSER_OUT) $(PARSER_HDR): $(PARSER_SRC) | $(BUILD_DIR)
	$(PARSER) -d -o $(PARSER_OUT) $(PARSER_SRC)

$(LEXER_OUT): $(LEXER_SRC) $(PARSER_HDR) | $(BUILD_DIR)
	$(LEXER) -o $(LEXER_OUT) $(LEXER_SRC)

$(TARGET): $(PARSER_OUT) $(LEXER_OUT)
	$(CC) $(CFLAGS) -o $(TARGET) $(PARSER_OUT) $(LEXER_OUT) -lfl

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

test: $(TARGET)
	@echo "=== Executando testes ==="
	@if [ -d tests ]; then \
		for file in tests/*.txt; do \
			if [ -f "$$file" ]; then \
				echo "\n--- Testando: $$file ---"; \
				./$(TARGET) "$$file"; \
			fi \
		done \
	else \
		echo "Diretório tests/ não encontrado"; \
	fi

.PHONY: all clean test
