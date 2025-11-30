#ifndef TABLA_CUADRUPLAS_H
#define TABLA_CUADRUPLAS_H "tabla_cuadruplas.h"

#include <stdbool.h>

typedef enum {
	SUMA_ENTERO,
    SUMA_REAL,
    RESTA_ENTERO,
    RESTA_REAL,
	NEGATIVO_ENTERO,
	NEGATIVO_REAL,
    MULTIPLICACION_ENTERO,
    MULTIPLICACION_REAL,
    DIVISION_ENTERO,
    DIVISION_REAL,
    MOD_ENTERO,
	ASIGNACION,
	IGUAL,
	MAYOR,
	MENOR,
	MAYOR_IGUAL,
	MENOR_IGUAL,
	DISTINTO,
	AND,
	OR,
	NOT,
	ENTERO_A_REAL,
	REAL_A_ENTERO,
	GOTO,
	GOTO_CONDICIONAL,
	INPUT,
	OUTPUT,
	INCREMENTAR_BUCLE
} operador;

const static char* operador_nombres[] = {
	"+entero",
    "+real",
    "-entero",
    "-real",
	"-entero",
	"-real",
    "*entero",
    "*real",
    "/entero",
    "/real",
    "%",
	":=",
	"IGUAL",
	">",
	"<",
	">=",
	"<=",
	"<>",
	"y",
	"o",
	"no",
	"(entero_a_real)",
	"(real_a_entero)",
	"goto",
	"goto",
	"input",
	"output",
	"+ 1"
};

typedef struct {
	int op1;
    int op2;
    operador operador;
	int res;
} cuadrupla;

typedef struct celdaCuadrupla {
	int id;
	cuadrupla cuadrupla;
	struct celdaCuadrupla* sig;
} celdaCuadrupla;

typedef struct {
	int tam;
	celdaCuadrupla* ini;
	celdaCuadrupla* fin;
} tablaCuadruplas; 

void inicializarTablaC(tablaCuadruplas*);
void insertarCuadrupla(tablaCuadruplas*, int, int, operador, int);
bool esNulaC(tablaCuadruplas);
void liberarTablaCuadruplas(tablaCuadruplas*);
int nextquad(tablaCuadruplas*);

#endif