#include "tabla_cuadruplas.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void inicializarTablaC(tablaCuadruplas *tablaC){
    tablaC->ini = NULL;
    tablaC->fin = NULL;
    tablaC->tam = 0;
}

void insertarCuadrupla(tablaCuadruplas* tablaC, int op1, int op2, operador operador, int resultado){
    celdaCuadrupla *aux;
    aux=(celdaCuadrupla*)malloc(sizeof(celdaCuadrupla));
    aux->cuadrupla.op1 = op1;
    aux->cuadrupla.op2 = op2;
    aux->cuadrupla.operador = operador;
    aux->cuadrupla.res = resultado;
    aux->sig = NULL;
    if(esNulaC(*tablaC)){
        aux->id = 1;
        tablaC->ini = aux;
        tablaC->fin = aux;
        tablaC->tam = 1;
    }
    else{
        aux->id = (tablaC->fin->id) + 1;
        tablaC->fin->sig = aux;
        tablaC->fin = aux;
        tablaC->tam = (tablaC->tam) + 1;
    } 
}

bool esNulaC(tablaCuadruplas tablaC){
    return ((tablaC.ini == NULL) && (tablaC.fin == NULL));
}

void liberarTablaCuadruplas(tablaCuadruplas* tabla) {
    celdaCuadrupla* actual = tabla->ini;
    celdaCuadrupla* siguiente;

    while (actual != NULL) {
        siguiente = actual->sig;
        free(actual);
        actual = siguiente;
    }

    tabla->ini = NULL;
    tabla->fin = NULL;
}

int nextquad(tablaCuadruplas* tabla){
    return tabla->tam + 1;
}