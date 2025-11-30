%option noyywrap

%{
/*

Comentarios

*/
#include <math.h>
#include "tabla_simbolos.h"  
#include "parser.tab.h"
%}

CIFRA    [0-9]
LETRA   [A-Za-z_]
LETRA_O_CIFRA   {LETRA}|{CIFRA}
IDENTIFICADOR_BOOLEANO (B|b)_{LETRA_O_CIFRA}*
IDENTIFICADOR       {LETRA}{LETRA_O_CIFRA}*

LITERAL_ENTERO {CIFRA}{CIFRA}*((e|E){CIFRA}{CIFRA}*)?
LITERAL_REAL {CIFRA}{CIFRA}*(\.{CIFRA}{CIFRA}*)?((e|E){CIFRA}{CIFRA}*)?
LITERAL_BOOLEANO PR_VERDADERO|PR_FALSO
LITERAL_CARACTER \".\"
LITERAL_CADENA '([^']*|\/)*'

COMENTARIO \{[^}]*\}

PR_ACCION accion
PR_FACCION faccion
PR_ALGORITMO algoritmo
PR_FALGORITMO falgoritmo
PR_FUNCION funcion
PR_FFUNCION ffuncion
PR_PARA para
PR_FPARA fpara
PR_MIENTRAS mientras
PR_FMIENTRAS fmientras
PR_SI si
PR_FSI fsi
PR_TABLA tabla
PR_FTABLA ftabla
PR_TUPLA tupla
PR_FTUPLA ftupla
PR_VAR var
PR_FVAR fvar
PR_CONST const
PR_FCONST fconst
PR_TIPO tipo
PR_FTIPO ftipo

PR_BOOLEANO booleano
PR_CADENA cadena
PR_CARACTER caracter
PR_ENTERO entero
PR_REAL real
PR_REF ref

PR_VERDADERO verdadero
PR_FALSO falso

OP_O o
OP_Y y
OP_NO no

OP_SUMA \+
OP_RESTA \-
OP_PRODUCTO \*
OP_DIVISION \/
OP_DIVISION_ENTERA div
OP_RESTO mod

OP_MENOR <
OP_MAYOR >
OP_MENOR_O_IGUAL <=
OP_MAYOR_O_IGUAL >=
OP_DISTINTO <>

PR_CONTINUAR continuar
PR_HASTA hasta
PR_HACER hacer
PR_DEV dev
PR_DE de

PR_ENT ent
PR_SAL sal
PR_E_S e\/s

PR_PUNTO \.

ASIGNACION :=
COMPOSICION_SECUENCIAL ;
SEPARADOR ,
SUBRANGO \.\.
DECLARACION_TIPO_VARIABLE :
ENTONCES \->
SI_NO_SI \[\]
CREACION_TIPO =
INICIO_ARRAY \[
FIN_ARRAY \]
INICIO_PARENTESIS \(
FIN_PARENTESIS \)        

%%

{LITERAL_ENTERO} {printf("Un literal entero: %s\n", yytext);
	yylval.nombre = yytext;
	return TK_LITERAL_ENTERO;}
{LITERAL_REAL} {printf("Un literal real: %s\n", yytext);
	yylval.nombre = yytext;
	return TK_LITERAL_REAL;}
{LITERAL_CARACTER} {printf("Un literal caracter: %s\n", yytext);
	yylval.nombre = yytext;
	return TK_LITERAL_CARACTER;}
{LITERAL_CADENA} {printf("Un literal cadena: %s\n", yytext);
	yylval.nombre = yytext;
	return TK_LITERAL_CADENA;}
{LITERAL_BOOLEANO} {printf("Un literal booleano: %s\n", yytext);
	yylval.nombre = yytext;
	return TK_LITERAL_BOOLEANO;}

{COMENTARIO} {printf("Un comentario: %s\n", yytext);
	return TK_COMENTARIO;}

{PR_ACCION} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_ACCION;}
{PR_FACCION} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FACCION;}
{PR_ALGORITMO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_ALGORITMO;}
{PR_FALGORITMO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FALGORITMO;}
{PR_FUNCION} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FUNCION;}
{PR_FFUNCION} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FFUNCION;}
{PR_PARA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_PARA;}
{PR_FPARA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FPARA;}
{PR_MIENTRAS} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_MIENTRAS;}
{PR_FMIENTRAS} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FMIENTRAS;}
{PR_SI} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_SI;}
{PR_FSI} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FSI;}
{PR_TABLA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_TABLA;}
{PR_FTABLA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FTABLA;}
{PR_TUPLA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_TUPLA;}
{PR_FTUPLA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FTUPLA;}
{PR_VAR} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_VAR;}
{PR_FVAR} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FVAR;}
{PR_CONST} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_CONST;}
{PR_FCONST} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FCONST;}
{PR_TIPO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_TIPO;}
{PR_FTIPO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FTIPO;}
{PR_BOOLEANO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_BOOLEANO;}
{PR_CADENA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_CADENA;}
{PR_CARACTER} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_CARACTER;}
{PR_ENTERO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_ENTERO;}
{PR_REAL} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_REAL;}
{PR_REF} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_REF;}
{PR_VERDADERO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_VERDADERO;}
{PR_FALSO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_FALSO;}
{OP_O} {printf("Un operador logico o: %s\n", yytext);
	return TK_OP_O;}
{OP_Y} {printf("Un operador logico y: %s\n", yytext);
	return TK_OP_Y;}
{OP_NO} {printf("Un operador logico no: %s\n", yytext);
	return TK_OP_NO;}
{OP_SUMA} {printf("Un operador matematico de suma: %s\n", yytext);
	return TK_OP_SUMA;}
{OP_RESTA} {printf("Un operador matematico de resta: %s\n", yytext);
	return TK_OP_RESTA;}
{OP_PRODUCTO} {printf("Un operador matematico de producto: %s\n", yytext);
	return TK_OP_PRODUCTO;}
{OP_DIVISION} {printf("Un operador matematico de division: %s\n", yytext);
	return TK_OP_DIVISION;}
{OP_DIVISION_ENTERA} {printf("Un operador matematico de division entera: %s\n", yytext);
	return TK_OP_DIVISION_ENTERA;}
{OP_RESTO} {printf("Un operador matematico de resto: %s\n", yytext);
	return TK_OP_RESTO;}
{OP_MENOR} {printf("Un operador matematico de menor: %s\n", yytext);
	return TK_OP_MENOR;}
{OP_MAYOR} {printf("Un operador matematico de mayor: %s\n", yytext);
	return TK_OP_MAYOR;}
{OP_MENOR_O_IGUAL} {printf("Un operador matematico de menor o igual: %s\n", yytext);
	return TK_OP_MENOR_O_IGUAL;}
{OP_MAYOR_O_IGUAL} {printf("Un operador matematico de mayor o igual: %s\n", yytext);
	return TK_OP_MAYOR_O_IGUAL;}
{OP_DISTINTO} {printf("Un operador matematico de distinto: %s\n", yytext);
	return TK_OP_DISTINTO;}
{PR_CONTINUAR} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_CONTINUAR;}
{PR_HASTA} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_HASTA;}
{PR_HACER} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_HACER;}
{PR_DEV} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_DEV;}
{PR_DE} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_DE;}
{PR_ENT} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_ENT;}
{PR_SAL} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_SAL;}
{PR_E_S} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_E_S;}
{PR_PUNTO} {printf("Una palabra reservada: %s\n", yytext);
	return TK_PR_PUNTO;}

{ASIGNACION} {printf("Una asignacion: %s\n", yytext);
	return TK_ASIGNACION;}
{COMPOSICION_SECUENCIAL} {printf("Una composicion secuencial: %s\n", yytext);
	return TK_COMPOSICION_SECUENCIAL;}
{SEPARADOR} {printf("Un separador: %s\n", yytext);
	return TK_SEPARADOR;}
{SUBRANGO} {printf("Un subrango: %s\n", yytext);
	return TK_SUBRANGO;}
{DECLARACION_TIPO_VARIABLE} {printf("Una declaracion de tipo de variable: %s\n", yytext);
	return TK_DECLARACION_TIPO_VARIABLE;}
{ENTONCES} {printf("Un entonces: %s\n", yytext);
	return TK_ENTONCES;}
{SI_NO_SI} {printf("Un si no si: %s\n", yytext);
	return TK_SI_NO_SI;}
{CREACION_TIPO} {printf("Una creacion de tipo: %s\n", yytext);
	return TK_CREACION_TIPO;}
{INICIO_ARRAY} {printf("Un inicio de array: %s\n", yytext);
	return TK_INICIO_ARRAY;}
{FIN_ARRAY} {printf("Un fin de array: %s\n", yytext);
	return TK_FIN_ARRAY;}
{INICIO_PARENTESIS} {printf("Un inicio de parentesis: %s\n", yytext);
	return TK_INICIO_PARENTESIS;}
{FIN_PARENTESIS} {printf("Un fin de parentesis: %s\n", yytext);
	return TK_FIN_PARENTESIS;}
{IDENTIFICADOR_BOOLEANO} {
    printf("Un identificador booleano: %s\n", yytext);
    simbolo nuevoSimbolo;
    nuevoSimbolo.nombre = malloc(strlen(yytext) + 1);
    strcpy(nuevoSimbolo.nombre, yytext);
    nuevoSimbolo.tipo = BOOL;
    celdaSimbolo* nuevaCelda = malloc(sizeof(celdaSimbolo));
    nuevaCelda->simbolo = nuevoSimbolo;
    nuevaCelda->sig = NULL;
    nuevaCelda->tipo = SIMBOLO_VARIABLE;
    nuevaCelda->tipo_e_s = -1;
    yylval.identificador = nuevaCelda;
    
	return TK_IDENTIFICADOR_BOOLEANO;
}
{IDENTIFICADOR} {
    printf("Un identificador: %s\n", yytext);
    simbolo nuevoSimbolo;
    nuevoSimbolo.nombre = malloc(strlen(yytext) + 1);
    strcpy(nuevoSimbolo.nombre, yytext);
    nuevoSimbolo.tipo = -1;
    celdaSimbolo* nuevaCelda = malloc(sizeof(celdaSimbolo));
    nuevaCelda->simbolo = nuevoSimbolo;
    nuevaCelda->sig = NULL;
    nuevaCelda->tipo = SIMBOLO_VARIABLE;
    nuevaCelda->tipo_e_s = -1;
    yylval.identificador = nuevaCelda;
    
	return TK_IDENTIFICADOR;
}

[ \t\n]+

%%