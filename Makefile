# Variables de directorios y compilador
CC = gcc
SRC_DIR = src
CFLAGS = -I$(SRC_DIR) -lm
LIBS = -lfl

# Objetivos principales
all: compilador

# Linkado final
compilador: parser.tab.o lex.yy.o tabla_simbolos.o tabla_cuadruplas.o
	$(CC) parser.tab.o lex.yy.o tabla_simbolos.o tabla_cuadruplas.o $(LIBS) $(CFLAGS) -o compilador

# Compilación de objetos auxiliares (buscando en src/)
tabla_simbolos.o: $(SRC_DIR)/tabla_simbolos.c
	$(CC) -c $(SRC_DIR)/tabla_simbolos.c $(CFLAGS)

tabla_cuadruplas.o: $(SRC_DIR)/tabla_cuadruplas.c
	$(CC) -c $(SRC_DIR)/tabla_cuadruplas.c $(CFLAGS)

# Compilación del parser generado
parser.tab.o: parser.tab.c
	$(CC) -c parser.tab.c $(CFLAGS)

# Compilación del lexer generado
lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c $(CFLAGS)

# Generación del lexer con Flex
lex.yy.c: $(SRC_DIR)/scanner.l parser.tab.h
	flex $(SRC_DIR)/scanner.l

# Generación del parser con Bison
parser.tab.c parser.tab.h: $(SRC_DIR)/parser.y
	bison -v -d -t $(SRC_DIR)/parser.y -Wconflicts-sr -Wconflicts-rr

# Limpieza
borrar:
	rm -f *.o lex.yy.c parser.tab.c parser.tab.h parser.output compilador codigo_tres_direcciones.txt