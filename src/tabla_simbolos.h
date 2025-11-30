#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H "tabla_simbolos.h"

#include "tabla_cuadruplas.h"
#include <stdbool.h>

typedef enum{
	NULO,
	ENTERO,
	REAL,
	BOOL,
	CHAR,
	CADENA,
	OTRO
}tipo;

const static char* tipo_nombres[] = {
	"NULO",
    "ENTERO",
    "REAL",
    "BOOLEANO",
    "CARACTER",
    "CADENA",
    "OTRO"
};

typedef struct{
	char* nombre;
	tipo tipo;
}simbolo;

typedef enum{
	SIMBOLO_VARIABLE,
	SIMBOLO_FUNCION
}tipo_simbolo;

typedef enum{
	SIMBOLO_ENTRADA,
	SIMBOLO_SALIDA,
	SIMBOLO_ENTRADA_SALIDA
}tipo_entrada_salida;

typedef struct celdaSimbolo{
	int id;
	tipo_simbolo tipo;
	tipo_entrada_salida tipo_e_s;
	simbolo simbolo;
	struct celdaSimbolo* sig;
} celdaSimbolo;

typedef struct{
	int tam;
	celdaSimbolo* ini;
	celdaSimbolo* fin;
	int temps;
} tablaSimbolos;

typedef struct{
	int tam;
	celdaSimbolo* cima;
} pilaSimbolos;

typedef struct {
	int id;
   	tipo tipo;
} operador_aritmetico;

typedef enum {
    EXPRESION_ARITMETICA,
	EXPRESION_BOOLEANA
} expresion_tipo;

typedef struct{
    int tam;
    int* lista;
} lista_booleanos;

typedef struct {
	int id;
	int tipo;
    lista_booleanos verdadero;
    lista_booleanos falso;
} operador_booleano;

typedef struct {
	int id;
	expresion_tipo tipo;
	operador_aritmetico aritmetico;
	operador_booleano booleano;
} expresion;

typedef struct {
	lista_booleanos next;
} tipo_intruccion;

void inicializarTablaS(tablaSimbolos*);
bool insertarSimbolo(tablaSimbolos*, char*, tipo, tipo_simbolo);
bool contieneSimbolo(tablaSimbolos*, char*);
void modificarTipo(tablaSimbolos*, tipo);
void modificarTipoSimboloTabla(tablaSimbolos*, tipo_entrada_salida, tablaCuadruplas*);
celdaSimbolo* getCeldaSimbolo(tablaSimbolos*, char*);
celdaSimbolo* getCeldaIndice(tablaSimbolos*, int);
bool esNula(tablaSimbolos);
void imprimirTablaSimbolos(tablaSimbolos*);
void imprimirTablaCuadruplas(tablaCuadruplas*, tablaSimbolos*);
void generarCodigoTresDirecciones(tablaCuadruplas*, tablaSimbolos*, char*);
bool estaVaciaListaPosicionesCuadruplas(lista_booleanos);
void liberarTablaSimbolos(tablaSimbolos*);

//booleanos
void backpatch(tablaCuadruplas*, lista_booleanos, int);
lista_booleanos merge(lista_booleanos, lista_booleanos);
lista_booleanos makelist(int);

//pila
void inicializarPila(pilaSimbolos*);
bool esNulaPila(pilaSimbolos);
celdaSimbolo* cimaPila(pilaSimbolos*);
bool insertarSimboloPila(pilaSimbolos*, char*, tipo, tipo_simbolo, tablaSimbolos*);
void desapilarPila(pilaSimbolos*);

#endif