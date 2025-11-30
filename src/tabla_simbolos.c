#include "tabla_simbolos.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void inicializarTablaS(tablaSimbolos* tablaS){
    tablaS->ini = NULL;
    tablaS->fin = NULL;
    tablaS->tam = 0;
    tablaS->temps = 1;
}

bool insertarSimbolo(tablaSimbolos* tablaS, char* nombre, tipo t, tipo_simbolo t_sim){
    if (contieneSimbolo(tablaS, nombre)){
        return false;
    }
    simbolo nuevoSimbolo;
    if (strcmp(nombre, "temp") == 0){
        int longitud = snprintf(NULL, 0, "%s%d", nombre, tablaS->temps);
        nuevoSimbolo.nombre = malloc(longitud + 1);
        snprintf(nuevoSimbolo.nombre, longitud + 1, "%s%d", nombre, tablaS->temps);
        tablaS->temps++;
    }
    else{
        nuevoSimbolo.nombre = malloc(strlen(nombre) + 1);
        strcpy(nuevoSimbolo.nombre, nombre);
    }
    nuevoSimbolo.tipo = t;

    celdaSimbolo* nuevaCelda = malloc(sizeof(celdaSimbolo));
    nuevaCelda->id = tablaS->tam + 1;
    nuevaCelda->simbolo = nuevoSimbolo;
    nuevaCelda->sig = NULL;
    nuevaCelda->tipo = t_sim;
    nuevaCelda->tipo_e_s = -1;

    if (esNula(*tablaS)) {
        tablaS->ini = nuevaCelda;
        tablaS->fin = nuevaCelda;
    } else {
        tablaS->fin->sig = nuevaCelda;
        tablaS->fin = nuevaCelda;
    }

    tablaS->tam++;
    return true;
}

bool contieneSimbolo(tablaSimbolos* tabla, char* nombre){
    celdaSimbolo* celda = tabla->ini;
    while (celda != NULL){
        if (strcmp(celda->simbolo.nombre, nombre) == 0 && celda->tipo_e_s != -1 && strcmp(celda->simbolo.nombre, "temp") != 0){
            return true;
        }
        celda = celda->sig;
    }
    return false;
}

void modificarTipo(tablaSimbolos* tablaS, tipo t){
    celdaSimbolo* aux = tablaS->ini;
    while(aux != NULL){
        if(aux->simbolo.tipo == NULO){
            aux->simbolo.tipo = t;
        }
        aux = aux->sig;
    }
}

void modificarTipoSimboloTabla(tablaSimbolos* tabla, tipo_entrada_salida t, tablaCuadruplas* tablaC){
    celdaSimbolo* celda = tabla->ini;    
    while(celda != NULL){
        if(celda->tipo_e_s == -1){
            celda->tipo_e_s = t;
            if (t == SIMBOLO_ENTRADA){
                insertarCuadrupla(tablaC, celda->id, 0, INPUT, 0);
            }
            else if(t == SIMBOLO_SALIDA){
                insertarCuadrupla(tablaC, celda->id, 0, OUTPUT, 0);
            }
        }
        else if(celda->tipo_e_s == SIMBOLO_ENTRADA && t == SIMBOLO_ENTRADA_SALIDA){
            celda->tipo_e_s = t;
            insertarCuadrupla(tablaC, celda->id, 0, OUTPUT, 0);
        }
        celda = celda->sig;
    }
}

bool esNula(tablaSimbolos tablaS){
    return tablaS.tam == 0;
}

void imprimirTablaSimbolos(tablaSimbolos* tabla){
    celdaSimbolo* celda = tabla->ini;
    while(celda != NULL) {
        printf("\nIdentificador: %d\n", celda->id);
        if (strcmp("", celda->simbolo.nombre) != 0){
            printf("Nombre de la variable: %s\n", celda->simbolo.nombre);
        }
        printf("Nombre del tipo de la variable: %s\n", tipo_nombres[celda->simbolo.tipo]);
        printf("Tipo de la variable: %d\n", celda->simbolo.tipo);
        printf("Entrada o salida: %d\n\n", celda->tipo_e_s);
        celda = celda->sig;
    }
}

celdaSimbolo* getCeldaSimbolo(tablaSimbolos* tabla, char* nombre){
    celdaSimbolo* celda = tabla->ini;
    while (celda != NULL) {
        if (celda->tipo == SIMBOLO_VARIABLE && strcmp(celda->simbolo.nombre, nombre) == 0) {
            return celda;
        }
        celda = celda->sig;
    }
    return NULL;
}

celdaSimbolo* getCeldaIndice(tablaSimbolos* tabla, int indice){
    celdaSimbolo* celda = tabla->ini;
    while (celda != NULL) {
        if (celda->tipo == SIMBOLO_VARIABLE && celda->id == indice) {
            return celda;
        }
        celda = celda->sig;
    }
    return NULL;
}

void imprimirTablaCuadruplas(tablaCuadruplas* tablaC, tablaSimbolos* tablaS){
    celdaCuadrupla* celdaCuadrupla = tablaC->ini;
    tablaCuadruplas tablaCuadruplaAux;
    inicializarTablaC(&tablaCuadruplaAux);
    printf("\nTamaño: %d\n\n", tablaC->tam);
    while(celdaCuadrupla != NULL) {
        celdaSimbolo* celdaResultado = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.res);
        celdaSimbolo* celdaOperando1 = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.op1);
        celdaSimbolo* celdaOperando2 = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.op2);
        if (celdaCuadrupla->cuadrupla.operador == OUTPUT){
            insertarCuadrupla(&tablaCuadruplaAux, celdaOperando1->id, 0, OUTPUT, 0);
        }
        if(celdaOperando1 != NULL){
            printf("Operando 1: %s con id %d\n", celdaOperando1->simbolo.nombre, celdaOperando1->id);
        }
        printf("Operador: %s\n", operador_nombres[celdaCuadrupla->cuadrupla.operador]);
        if(celdaOperando2 != NULL){
            printf("Operando 2: %s con id %d\n", celdaOperando2->simbolo.nombre, celdaOperando2->id);
        }
        if(celdaResultado != NULL){
            if(celdaCuadrupla->cuadrupla.operador == MAYOR || celdaCuadrupla->cuadrupla.operador == MENOR || celdaCuadrupla->cuadrupla.operador == MAYOR_IGUAL || celdaCuadrupla->cuadrupla.operador == MENOR_IGUAL || celdaCuadrupla->cuadrupla.operador == GOTO){
                printf("Goto: %d\n", celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
            }
            else if(celdaCuadrupla->cuadrupla.operador != INPUT && celdaCuadrupla->cuadrupla.operador != OUTPUT){
                printf("Resultado: %s con id %d\n", celdaResultado->simbolo.nombre, celdaResultado->id);
            }
        }
        else {
            if(celdaCuadrupla->cuadrupla.operador == MAYOR || celdaCuadrupla->cuadrupla.operador == MENOR || celdaCuadrupla->cuadrupla.operador == MAYOR_IGUAL || celdaCuadrupla->cuadrupla.operador == MENOR_IGUAL || celdaCuadrupla->cuadrupla.operador == GOTO){
                printf("Goto: %d\n", celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
            }
        }
        printf("\n");
        celdaCuadrupla = celdaCuadrupla->sig;
    }
    liberarTablaCuadruplas(&tablaCuadruplaAux);
}

void generarCodigoTresDirecciones(tablaCuadruplas* tablaC, tablaSimbolos* tablaS, char* nombreFichero){
    celdaCuadrupla* celdaCuadrupla = tablaC->ini;
    tablaCuadruplas tablaCuadruplaAux;
    inicializarTablaC(&tablaCuadruplaAux);
    FILE* fichero = fopen("codigo_tres_direcciones.txt","a+");
    fprintf(fichero, "%s\n\n", nombreFichero);
    printf("\nTamaño: %d\n\n", tablaC->tam);
    int i = 1;
    while(celdaCuadrupla != NULL) {
        celdaSimbolo* celdaResultado = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.res);
        celdaSimbolo* celdaOperando1 = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.op1);
        celdaSimbolo* celdaOperando2 = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.op2);
        switch(celdaCuadrupla->cuadrupla.operador){
            case INPUT:
                printf("%d %s %s\n", i, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
                fprintf(fichero, "%d %s %s\n", i, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
                break;
            case OUTPUT:
                insertarCuadrupla(&tablaCuadruplaAux, celdaOperando1->id, 0, OUTPUT, 0);
                i--;
                break;
            case ASIGNACION:
                printf("%d %s := %s\n", i, celdaResultado->simbolo.nombre, celdaOperando1->simbolo.nombre);
                fprintf(fichero, "%d %s := %s\n", i, celdaResultado->simbolo.nombre, celdaOperando1->simbolo.nombre);
                break;
            case GOTO:
                printf("%d %s %d\n", i, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                fprintf(fichero, "%d %s %d\n", i, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                break;
            case GOTO_CONDICIONAL:
                printf("%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                fprintf(fichero, "%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                break;
            case MAYOR:
                printf("%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                fprintf(fichero, "%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                break;
            case MENOR:
                printf("%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                fprintf(fichero, "%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                break;
            case MAYOR_IGUAL:
                printf("%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                fprintf(fichero, "%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                break;
            case MENOR_IGUAL:
                printf("%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                fprintf(fichero, "%d if %s %s %s then goto %d\n", i, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre, celdaCuadrupla->cuadrupla.res - tablaCuadruplaAux.tam);
                break;
            case ENTERO_A_REAL:
                printf("%d %s := %s %s\n", i, celdaResultado->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
                fprintf(fichero, "%d %s := %s %s\n", i, celdaResultado->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
                break;
            case REAL_A_ENTERO:
                printf("%d %s := %s %s\n", i, celdaResultado->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
                fprintf(fichero, "%d %s := %s %s\n", i, celdaResultado->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
                break;
            case INCREMENTAR_BUCLE:
                printf("%d %s := %s %s\n", i, celdaResultado->simbolo.nombre, celdaResultado->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador]);
                fprintf(fichero, "%d %s := %s %s\n", i, celdaResultado->simbolo.nombre, celdaResultado->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador]);
                break;
            default:
                printf("%d %s := %s %s %s\n", i, celdaResultado->simbolo.nombre, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre);
                fprintf(fichero, "%d %s := %s %s %s\n", i, celdaResultado->simbolo.nombre, celdaOperando1->simbolo.nombre, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando2->simbolo.nombre);
                break;
        }       

        i++;
        celdaCuadrupla = celdaCuadrupla->sig;
    }

    celdaCuadrupla = tablaCuadruplaAux.ini;
    while(celdaCuadrupla != NULL) {
        celdaSimbolo* celdaOperando1 = getCeldaIndice(tablaS, celdaCuadrupla->cuadrupla.op1);
        printf("%d %s %s\n", i, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
        fprintf(fichero, "%d %s %s\n", i, operador_nombres[celdaCuadrupla->cuadrupla.operador], celdaOperando1->simbolo.nombre);
        i++;
        celdaCuadrupla = celdaCuadrupla->sig;
    }
    fprintf(fichero, "\n----------------------------------------------------------\n\n");
    fclose(fichero);
    liberarTablaCuadruplas(&tablaCuadruplaAux);
    liberarTablaCuadruplas(tablaC);
    liberarTablaSimbolos(tablaS);
}

bool estaVaciaListaPosicionesCuadruplas(lista_booleanos lista){
    return lista.tam == 0;
}

void liberarTablaSimbolos(tablaSimbolos* tabla) {
    celdaSimbolo* actual = tabla->ini;
    celdaSimbolo* siguiente;

    while (actual != NULL) {
        siguiente = actual->sig;
        free(actual->simbolo.nombre);
        free(actual);
        actual = siguiente;
    }

    tabla->ini = NULL;
    tabla->fin = NULL;
}

//booleanos
void backpatch(tablaCuadruplas* tabla, lista_booleanos lista_booleanos, int id){
    for (int i = 0; i < lista_booleanos.tam; i++) {
        celdaCuadrupla* celda = tabla->ini;
        while (celda != NULL && celda->id != lista_booleanos.lista[i]){
            celda = celda->sig;
        }
        if (celda != NULL){
            celda->cuadrupla.res = id;
        }
    }
}

lista_booleanos merge(lista_booleanos lista1, lista_booleanos lista2){
    lista_booleanos listaFinal;
    listaFinal.tam = lista1.tam + lista2.tam;
    listaFinal.lista = malloc(listaFinal.tam * sizeof(int));
    for(int i = 0; i < lista1.tam; i++) {
        listaFinal.lista[i] = lista1.lista[i];
    }
    for(int i = 0; i < lista2.tam; i++) {
        listaFinal.lista[lista1.tam + i] = lista2.lista[i];
    }
    return listaFinal;
}

lista_booleanos makelist(int id){
    lista_booleanos lista_b;
    if (id > -1){
        lista_b.tam = 1;
        lista_b.lista = malloc(sizeof(int));
        lista_b.lista[0] = id;
    } else {
        lista_b.tam = 0;
        lista_b.lista = NULL;
    }
    return lista_b;
}

// pila

void inicializarPila(pilaSimbolos* pila){
    pila->tam = 0;
    pila->cima = NULL;
}

bool esNulaPila(pilaSimbolos pila){
    return pila.tam == 0;
}

celdaSimbolo* cimaPila(pilaSimbolos* pila){
    return pila->cima;
}

bool insertarSimboloPila(pilaSimbolos* pila, char* nombre, tipo t, tipo_simbolo t_sim, tablaSimbolos* tabla){
    if (contieneSimbolo(tabla, nombre)){
        return false;
    }
    simbolo nuevoSimbolo;
    nuevoSimbolo.nombre = malloc(strlen(nombre) + 1);
    strcpy(nuevoSimbolo.nombre, nombre);
    nuevoSimbolo.tipo = t;

    celdaSimbolo* nuevaCelda = malloc(sizeof(celdaSimbolo));
    nuevaCelda->id = pila->tam + 1;
    nuevaCelda->simbolo = nuevoSimbolo;
    nuevaCelda->sig = NULL;
    nuevaCelda->tipo = t_sim;
    nuevaCelda->tipo_e_s = -1;

    if (esNulaPila(*pila)) {
        pila->tam = 1;
        pila->cima = nuevaCelda;
    } else {
        nuevaCelda->sig = pila->cima;
        pila->cima = nuevaCelda;
        pila->tam++;
    }
    return true;
}

void desapilarPila(pilaSimbolos* pila){
    celdaSimbolo* celda = pila->cima;
    pila->cima = pila->cima->sig;
    free(celda->simbolo.nombre);
    free(celda);
    pila->tam = pila->tam - 1;
}