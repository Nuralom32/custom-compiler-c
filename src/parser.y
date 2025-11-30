%{
    #include <stdio.h>
    #include "tabla_simbolos.h"
    #include "tabla_cuadruplas.h"
    int yylex();
    void yyerror(const char* error);
    extern FILE* yyin;
    tablaSimbolos miTablaSimbolos;
    tablaCuadruplas miTablaCuadruplas;
    pilaSimbolos miPilaSimbolos;
%}

%union{
    int entero;
    double real;
    char* nombre;
    char caracter;
    celdaSimbolo* identificador;
    int tipo;
    operador_aritmetico op_a;
    operador_booleano op_b;
    expresion exp;
    int tipo_entero;
    tipo_intruccion instruccion;
}

%token TK_ASIGNACION
%token TK_COMENTARIO
%token TK_COMPOSICION_SECUENCIAL
%token TK_CREACION_TIPO
%token TK_DECLARACION_TIPO_VARIABLE
%token TK_ENTONCES
%token TK_FIN_ARRAY
%token TK_FIN_PARENTESIS
%token <identificador> TK_IDENTIFICADOR
%token <identificador> TK_IDENTIFICADOR_BOOLEANO
%token TK_INICIO_ARRAY
%token TK_INICIO_PARENTESIS
%token <nombre> TK_LITERAL_BOOLEANO
%token <nombre> TK_LITERAL_CADENA
%token <nombre> TK_LITERAL_CARACTER
%token <nombre> TK_LITERAL_ENTERO
%token <nombre> TK_LITERAL_REAL
%token TK_OP_DISTINTO
%token TK_OP_DIVISION
%token TK_OP_DIVISION_ENTERA
%token TK_OP_MAYOR
%token TK_OP_MAYOR_O_IGUAL
%token TK_OP_MENOR
%token TK_OP_MENOR_O_IGUAL
%token TK_OP_NO
%token TK_OP_O
%token TK_OP_PRODUCTO
%token TK_OP_RESTA
%token TK_OP_RESTO
%token TK_OP_SUMA
%token TK_OP_Y
%token TK_PR_ACCION
%token TK_PR_ALGORITMO
%token TK_PR_BOOLEANO
%token TK_PR_CADENA
%token TK_PR_CARACTER
%token TK_PR_CONST
%token TK_PR_CONTINUAR
%token TK_PR_DE
%token TK_PR_DEV
%token TK_PR_E_S
%token TK_PR_ENT
%token TK_PR_ENTERO
%token TK_PR_FACCION
%token TK_PR_FALGORITMO
%token TK_PR_FALSO
%token TK_PR_FCONST
%token TK_PR_FFUNCION
%token TK_PR_FMIENTRAS
%token TK_PR_FPARA
%token TK_PR_FSI
%token TK_PR_FTABLA
%token TK_PR_FTIPO
%token TK_PR_FTUPLA
%token TK_PR_FUNCION
%token TK_PR_FVAR
%token TK_PR_HACER
%token TK_PR_HASTA
%token TK_PR_IDENTIFICADOR
%token TK_PR_MIENTRAS
%token TK_PR_PARA
%token TK_PR_PUNTO
%token TK_PR_REAL
%token TK_PR_REF
%token TK_PR_SAL
%token TK_PR_SI
%token TK_PR_TABLA
%token TK_PR_TIPO
%token TK_PR_TUPLA
%token TK_PR_VAR
%token TK_PR_VERDADERO
%token TK_SEPARADOR
%token TK_SI_NO_SI
%token TK_SUBRANGO

%left TK_OP_SUMA TK_OP_RESTA
%left TK_OP_PRODUCTO TK_OP_DIVISION TK_OP_DIVISION_ENTERA
%left TK_OP_RESTO
%left TK_OP_MENOR TK_OP_MENOR_O_IGUAL TK_OP_MAYOR TK_OP_MAYOR_O_IGUAL TK_OP_DISTINTO TK_CREACION_TIPO  

%left TK_OP_O
%left TK_OP_Y
%left TK_OP_NO

%type <tipo> d_tipo
%type <tipo> lista_id
%type <tipo> tipo_base
%type <exp> expresion
%type <op_a> exp_a
%type <op_a> operando
%type <op_a> literal_numerico
%type <op_b> exp_b
%type <op_b> operando_b
%type <instruccion> bloque_alg
%type <instruccion> bloque
%type <instruccion> instrucciones
%type <instruccion> instruccion
%type <instruccion> asignacion
%type <instruccion> alternativa
%type <instruccion> iteracion
%type <instruccion> it_cota_exp
%type <instruccion> it_cota_fija
%type <instruccion> lista_opciones
%type <instruccion> N
%type <tipo_entero> M1
%type <tipo_entero> M2

%%
desc_algoritmo :
    TK_PR_ALGORITMO TK_IDENTIFICADOR TK_COMPOSICION_SECUENCIAL cabecera_alg bloque_alg TK_PR_FALGORITMO {        
		printf("Ejecucion terminada\n");    
	}
;
cabecera_alg :
    decl_globales decl_a_f decl_ent_sal TK_COMENTARIO { 
		printf("Cabecera algoritmo\n"); 
	}
;
bloque_alg :
    bloque TK_COMENTARIO { 
		printf("Bloque algoritmo\n");
        backpatch(&miTablaCuadruplas, $1.next, nextquad(&miTablaCuadruplas));
	}
;
decl_globales :
    declaracion_tipo decl_globales { 
		printf("Declaraciones tipos globales\n"); 
	}
    | declaracion_const decl_globales { 
		printf("Declaraciones constantes globales\n"); 
	}
    | %empty
;
decl_a_f : 
    accion_d decl_a_f { 
		printf("Declaracion accion\n"); 
	}
    | funcion_d decl_a_f { 
		printf("Declaracion funcion\n"); 
	}
    | %empty { 
		printf("Declaracion cadena vacia\n"); 
	}
;
bloque :
    declaraciones instrucciones { 
		printf("Bloque\n");
        $$ = $2;
	}
;
declaraciones :
    declaracion_tipo declaraciones { 
		printf("Declaraciones tipos\n"); 
	}
    | declaracion_const declaraciones { 
		printf("Declaraciones constantes\n"); 
	}
    | declaracion_var declaraciones { 
		printf("Declaraciones variables\n"); 
	}
    | %empty { 
		printf("Declaraciones cadena vacia\n"); 
	}
;

declaracion_tipo :
    TK_PR_TIPO lista_d_tipo TK_PR_FTIPO TK_COMPOSICION_SECUENCIAL { 
		printf("Declaracion tipo\n"); 
	}
;

declaracion_const :
    TK_PR_CONST lista_d_cte TK_PR_FCONST { 
		printf("Declaracion constante\n"); 
	}
;
declaracion_var :
    TK_PR_VAR lista_d_var TK_PR_FVAR { 
		printf("Declaracion variable\n"); 
	}
;

lista_d_tipo :
    TK_IDENTIFICADOR TK_CREACION_TIPO d_tipo TK_COMPOSICION_SECUENCIAL lista_d_tipo { 
		printf("Lista de tipo\n"); 
	}
    | %empty { 
		printf("Lista d tipo cadena vacia\n"); 
	}
;
d_tipo :
    TK_PR_TUPLA lista_campos TK_PR_FTUPLA { 
		printf("Tupla\n");
        $$ = OTRO; 
	}
    | TK_PR_TABLA TK_INICIO_ARRAY expresion_t TK_SUBRANGO expresion_t TK_FIN_ARRAY TK_PR_DE d_tipo TK_PR_FTABLA { 
		printf("Tabla\n");
        $$ = OTRO; 
	}
    | TK_IDENTIFICADOR { 
		printf("Identificador\n");
        $$ = OTRO; 
	}
    | expresion_t TK_SUBRANGO expresion_t { 
		printf("Subrango\n");
        $$ = OTRO; 
	}
    | TK_PR_REF d_tipo { 
		printf("Puntero\n");
        $$ = OTRO; 
	}
    | tipo_base { 
		printf("Tipo base\n");
        $$ = $1; 
	}
;
tipo_base :
    TK_PR_ENTERO { 
		printf("Entero\n");
        $$ = ENTERO; 
	}
    | TK_PR_REAL { 
		printf("Real\n");
        $$ = REAL; 
	}
    | TK_PR_BOOLEANO { 
		printf("Booleano\n");
        $$ = BOOL; 
	}
    | TK_PR_CARACTER { 
		printf("Caracter\n");
        $$ = CHAR; 
	}
    | TK_PR_CADENA { 
		printf("Cadena\n");
        $$ = CADENA; 
	}
;
expresion_t :
    expresion { 
		printf("Expresion\n"); 
	}
    | TK_LITERAL_CARACTER { 
		printf("Literal caracter\n"); 
	}
;
lista_campos :
    TK_IDENTIFICADOR TK_DECLARACION_TIPO_VARIABLE d_tipo TK_COMPOSICION_SECUENCIAL lista_campos { 
		printf("Lista de campos\n"); 
	}
    | %empty { 
		printf("Lista campos cadena vacia\n"); 
	}
;

lista_d_cte :
    TK_IDENTIFICADOR TK_CREACION_TIPO tipo_base TK_COMPOSICION_SECUENCIAL lista_d_cte { 
		printf("Lista de constantes\n"); 
	}
    | %empty { 
		printf("Lista de cte cadena vacia\n"); 
	}
;
lista_d_var :
    lista_id_tipo TK_COMPOSICION_SECUENCIAL lista_d_var{        
		printf("Listas de variables\n");
	}
    | %empty { 
		printf("Lista de variables cadena vacia\n"); 
	}
;
lista_id_tipo :
    lista_id TK_DECLARACION_TIPO_VARIABLE d_tipo{
        printf("Lista de variables y su tipo\n");
        while(!esNulaPila(miPilaSimbolos)){
            celdaSimbolo* celda = cimaPila(&miPilaSimbolos);
            insertarSimbolo(&miTablaSimbolos, celda->simbolo.nombre, celda->simbolo.tipo, celda->tipo);
            desapilarPila(&miPilaSimbolos);
        }
        modificarTipo(&miTablaSimbolos, $3);
    }
;
lista_id :
    TK_IDENTIFICADOR TK_SEPARADOR lista_id {
		printf("Identificador en lista\n");
        if (!insertarSimboloPila(&miPilaSimbolos, $1->simbolo.nombre, $3, SIMBOLO_VARIABLE, &miTablaSimbolos)){
            modificarTipoSimboloTabla(&miTablaSimbolos, SIMBOLO_ENTRADA_SALIDA, &miTablaCuadruplas);
            printf("Identificador %s ya existe\n", $1->simbolo.nombre);
        };
        $$ = $3;    
	}
    | TK_IDENTIFICADOR {
		printf("Identificador\n");
        if (!insertarSimboloPila(&miPilaSimbolos, $1->simbolo.nombre, NULO, SIMBOLO_VARIABLE, &miTablaSimbolos)){
            modificarTipoSimboloTabla(&miTablaSimbolos, SIMBOLO_ENTRADA_SALIDA, &miTablaCuadruplas);
            printf("Identificador %s ya existe\n", $1->simbolo.nombre);
        };
        $$ = NULO;
	}
    | TK_IDENTIFICADOR_BOOLEANO TK_SEPARADOR lista_id {        
		printf("Identificador booleano de lista\n");
        if (!insertarSimboloPila(&miPilaSimbolos, $1->simbolo.nombre, $3, SIMBOLO_VARIABLE, &miTablaSimbolos)){
            modificarTipoSimboloTabla(&miTablaSimbolos, SIMBOLO_ENTRADA_SALIDA, &miTablaCuadruplas);
            printf("Identificador booleano %s ya existe\n", $1->simbolo.nombre);
        };
        $$ = $3;
	}
    | TK_IDENTIFICADOR_BOOLEANO {        
		printf("Identificador booleano\n");
        if (!insertarSimboloPila(&miPilaSimbolos, $1->simbolo.nombre, BOOL, SIMBOLO_VARIABLE, &miTablaSimbolos)){
            modificarTipoSimboloTabla(&miTablaSimbolos, SIMBOLO_ENTRADA_SALIDA, &miTablaCuadruplas);
            printf("Identificador booleano %s ya existe\n", $1->simbolo.nombre);
        };
        $$ = BOOL;
	}
;

decl_ent_sal :
    decl_ent { 
		printf("Declaracion de variables de entrada\n"); 
	}
    | decl_ent decl_sal { 
		printf("Declaraciones de variables de entrada y salida\n"); 
	}
    | decl_sal { 
		printf("Declaracion de variables de entrada\n"); 
	}
;
decl_ent :
    TK_PR_ENT lista_d_var { 
		printf("Declaracion de entrada\n");
        modificarTipoSimboloTabla(&miTablaSimbolos, SIMBOLO_ENTRADA, &miTablaCuadruplas);
	}
;
decl_sal :
    TK_PR_SAL lista_d_var { 
		printf("Declaracion de salida\n");
        modificarTipoSimboloTabla(&miTablaSimbolos, SIMBOLO_SALIDA, &miTablaCuadruplas);
	}
;

expresion :
    exp_a { 
		printf("Expresion aritmetica\n");
        $$.tipo = EXPRESION_ARITMETICA;
        $$.aritmetico.id = $1.id;
        $$.aritmetico.tipo = $1.tipo;
	}
    | exp_b { 
		printf("Expresion booleana\n");
        $$.tipo = EXPRESION_BOOLEANA;
        $$.booleano.verdadero = $1.verdadero;
        $$.booleano.falso = $1.falso;
	}
    | funcion_ll { 
		printf("Llamada a funcion\n"); 
	}
;
exp_a :
    exp_a TK_OP_SUMA exp_a { 
		printf("Suma de operandos\n");
        if ($1.tipo == ENTERO && $3.tipo == ENTERO)
        {
            printf("Suma de 2 enteros\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, SUMA_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else if ($1.tipo == REAL && $3.tipo == ENTERO)
        {
		    printf("Suma de 1 real y 1 entero\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, miTablaSimbolos.fin->id - 1, SUMA_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;        
	    }
        else if ($1.tipo == ENTERO && $3.tipo == REAL)
        {
            printf("Suma de 1 entero y 1 real\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 1, $3.id, SUMA_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == REAL && $3.tipo == REAL)
        {
            printf("Suma de 2 reales\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, SUMA_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }    
	}
    | exp_a TK_OP_RESTA exp_a { 
		printf("Resta de operandos\n");
        if ($1.tipo == ENTERO && $3.tipo == ENTERO)
        {
            printf("Resta de 2 enteros\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, RESTA_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else if ($1.tipo == REAL && $3.tipo == ENTERO)
        {
            printf("Resta de 1 real y 1 entero\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, miTablaSimbolos.fin->id - 1, RESTA_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == ENTERO && $3.tipo == REAL)
        {
            printf("Resta de 1 entero y 1 real\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 1, $3.id, RESTA_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == REAL && $3.tipo == REAL)
        {
            printf("Resta de 2 reales\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, RESTA_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }    
	}
    | exp_a TK_OP_PRODUCTO exp_a { 
		printf("Productos de operandos\n");
        if ($1.tipo == ENTERO && $3.tipo == ENTERO)
        {
            printf("Producto de 2 enteros\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MULTIPLICACION_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else if ($1.tipo == REAL && $3.tipo == ENTERO)
        {
            printf("Producto de 1 real y 1 entero\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, miTablaSimbolos.fin->id - 1, MULTIPLICACION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == ENTERO && $3.tipo == REAL)
        {
            printf("Producto de 1 entero y 1 real\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 1, $3.id, MULTIPLICACION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == REAL && $3.tipo == REAL)
        {
            printf("Producto de 2 reales\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MULTIPLICACION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }    
	}
    | exp_a TK_OP_DIVISION_ENTERA exp_a { 
		printf("Division entera entre operandos\n");
        if ($1.tipo == ENTERO && $3.tipo == ENTERO)
        {
            printf("Division entera entre 2 enteros\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, DIVISION_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else if ($1.tipo == REAL && $3.tipo == ENTERO)
        {
            printf("Division entera entre 1 real y 1 entero\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, REAL_A_ENTERO, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 1, $3.id, DIVISION_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else if ($1.tipo == ENTERO && $3.tipo == REAL)
        {
            printf("Division entera entre 1 entero y 1 real\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, REAL_A_ENTERO, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, miTablaSimbolos.fin->id - 1, DIVISION_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else if ($1.tipo == REAL && $3.tipo == REAL)
        {
            printf("Division entera entre 2 reales\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, REAL_A_ENTERO, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, REAL_A_ENTERO, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 2, miTablaSimbolos.fin->id - 1, DIVISION_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
	}
    | exp_a TK_OP_RESTO exp_a { 
		printf("resto de operandos\n");
        if ($1.tipo == ENTERO && $3.tipo == ENTERO)
        {
            printf("Resto de 2 enteros\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MOD_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;
        }
        else{
            if ($1.tipo != ENTERO){
                printf("Error: el primer operando no es un entero\n");
            }
            if ($3.tipo != ENTERO){
                printf("Error: el segundo operando no es un entero\n");
            }
        }    
	}
    | exp_a TK_OP_DIVISION exp_a { 
		printf("Division real entre operandos\n");
        if ($1.tipo == ENTERO && $3.tipo == ENTERO)
        {
            printf("Division real entre 2 enteros\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 2, miTablaSimbolos.fin->id - 1, DIVISION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == REAL && $3.tipo == ENTERO)
        {
            printf("Division entre 1 real y 1 entero\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $3.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, miTablaSimbolos.fin->id - 1, DIVISION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == ENTERO && $3.tipo == REAL)
        {
            printf("Division entre 1 entero y 1 real\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id - 1, $3.id, DIVISION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
        else if ($1.tipo == REAL && $3.tipo == REAL)
        {
            printf("Division entre 2 reales\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, DIVISION_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }
    }
    | TK_INICIO_PARENTESIS exp_a TK_FIN_PARENTESIS { 
		printf("Parentesis de operando\n");
        $$ = $2;    
	}
    | operando { 
		printf("Operando\n");
        $$ = $1;    
	}
    | literal_numerico { 
		printf("Literal numerico\n");
        $$.id = $1.id;
        $$.tipo = $1.tipo;
	}
    | TK_OP_RESTA exp_a { 
		printf("Operando con valor negativo\n");
        if ($2.tipo == ENTERO)
        {
            printf("Negativo de entero\n");
            insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $2.id, 0, NEGATIVO_ENTERO, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = ENTERO;        
	    }
        else if ($2.tipo == REAL){
            printf("Negativo de real\n");
            insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
            insertarCuadrupla(&miTablaCuadruplas, $2.id, 0, NEGATIVO_REAL, miTablaSimbolos.fin->id);
            $$.id = miTablaSimbolos.fin->id;
            $$.tipo = REAL;
        }    
	}
;
literal_numerico :
    TK_LITERAL_ENTERO { 
		printf("Literal entero\n");
        insertarSimbolo(&miTablaSimbolos, $1, ENTERO, SIMBOLO_VARIABLE);
        $$.id = miTablaSimbolos.fin->id;
        $$.tipo = ENTERO;    
	}
    | TK_LITERAL_REAL { 
		printf("Literal real\n");
        insertarSimbolo(&miTablaSimbolos, $1, REAL, SIMBOLO_VARIABLE);
        $$.id = miTablaSimbolos.fin->id;
        $$.tipo = REAL;    
	}
;
exp_b :
    exp_b TK_OP_Y M1 exp_b { 
		printf("Disyuncion booleana\n");
        backpatch(&miTablaCuadruplas, $1.verdadero, $3);
        $$.falso = merge($1.falso, $4.falso);
        $$.verdadero = $4.verdadero;    
	}
    | exp_b TK_OP_O M1 exp_b { 
		printf("Conjuncion booleana\n");
        backpatch(&miTablaCuadruplas, $1.falso, $3);
        $$.verdadero = merge($1.verdadero, $4.verdadero);
        $$.falso = $4.falso;    
	}
    | TK_OP_NO exp_b { 
		printf("Negacion booleana\n");
        $$.verdadero = $2.falso;
        $$.falso = $2.verdadero;    
	}
    | operando_b { 
		printf("Operando booleano\n");
        $$ = $1;    
	}
    | TK_PR_VERDADERO { 
		printf("Valor verdadero\n");
	}
    | TK_PR_FALSO { 
		printf("Valor falso\n");
	}
    | expresion TK_OP_MENOR expresion { 
		printf("Operador menor\n");
        $$.verdadero = makelist(nextquad(&miTablaCuadruplas));
        $$.falso = makelist(nextquad(&miTablaCuadruplas) + 1);
        insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MENOR, -1);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);
	}
    | expresion TK_OP_MAYOR expresion { 
		printf("Operador mayor\n");
        $$.verdadero = makelist(nextquad(&miTablaCuadruplas));
        $$.falso = makelist(nextquad(&miTablaCuadruplas) + 1);
        insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MAYOR, -1);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);    
	}
    | expresion TK_OP_MENOR_O_IGUAL expresion { 
		printf("Operador menor o igual\n");
        $$.verdadero = makelist(nextquad(&miTablaCuadruplas));
        $$.falso = makelist(nextquad(&miTablaCuadruplas) + 1);
        insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MENOR_IGUAL, -1);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);    
	}
    | expresion TK_OP_MAYOR_O_IGUAL expresion { 
		printf("Operador menor o igual\n");
        $$.verdadero = makelist(nextquad(&miTablaCuadruplas));
        $$.falso = makelist(nextquad(&miTablaCuadruplas) + 1);
        insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, MAYOR_IGUAL, -1);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);    
	}
    | expresion TK_OP_DISTINTO expresion { 
		printf("Operador distinto\n");
        $$.verdadero = makelist(nextquad(&miTablaCuadruplas));
        $$.falso = makelist(nextquad(&miTablaCuadruplas) + 1);
        insertarCuadrupla(&miTablaCuadruplas, $1.id, $3.id, DISTINTO, -1);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);    
	}
    | TK_INICIO_PARENTESIS exp_b TK_FIN_PARENTESIS { 
		printf("Parentesis de operando booleano\n");
        $$ = $2;    
	}
;
operando :
    TK_IDENTIFICADOR { 
		printf("operando identificador\n");
        celdaSimbolo* celda = getCeldaSimbolo(&miTablaSimbolos, $1->simbolo.nombre);
        $$.id = celda->id;
        $$.tipo = celda->simbolo.tipo;    
	}
    | operando TK_PR_PUNTO operando { 
		printf("Concatenacion\n"); 
	}
    | operando TK_INICIO_ARRAY expresion TK_FIN_ARRAY { 
		printf("Operando array\n"); 
	}
    | operando TK_PR_REF { 
		printf("Operando puntero\n"); 
	}
;
operando_b:
    TK_IDENTIFICADOR_BOOLEANO { 
		printf("Identificador booleano\n");
        celdaSimbolo* celda = getCeldaSimbolo(&miTablaSimbolos, $1->simbolo.nombre);
        $$.id = celda->id;
        $$.tipo = celda->tipo;
        $$.verdadero = makelist(nextquad(&miTablaCuadruplas));
        $$.falso = makelist(nextquad(&miTablaCuadruplas) + 1);
        insertarCuadrupla(&miTablaCuadruplas, celda->id, 0, GOTO_CONDICIONAL, -1);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);
	}
;

instrucciones :
    instruccion TK_COMPOSICION_SECUENCIAL M1 instrucciones { 
		printf("Lista de instrucciones\n");
        if (!estaVaciaListaPosicionesCuadruplas($1.next)){
            backpatch(&miTablaCuadruplas, $1.next, $3);
        }
        $$.next = $4.next;
	}
    | instruccion { 
		printf("Instruccion\n");
        $$.next = $1.next;
	}
;
instruccion :
    TK_PR_CONTINUAR { 
		printf("Continuar\n");
        $$.next = makelist(-1);
	}
    | asignacion { 
		printf("Instruccion asignacion\n");
        $$.next = $1.next;
	}
    | alternativa { 
		printf("Instruccion alternativa\n");
        $$.next = $1.next;
	}
    | iteracion { 
		printf("Instruccion iteracion\n");
        $$.next = $1.next;
	}
    | accion_ll { 
		printf("Llamada a accion\n"); 
	}
;
asignacion : 
    operando TK_ASIGNACION expresion {
		printf("Asignacion aritmetica\n");
        $$.next = makelist(-1);
        if($3.tipo == EXPRESION_ARITMETICA){
            printf("Expresion aritmetica\n");
            if ($1.tipo == ENTERO && $3.aritmetico.tipo == ENTERO)
            {
                insertarCuadrupla(&miTablaCuadruplas, $3.aritmetico.id, 0, ASIGNACION, $1.id);
            }
            else if ($1.tipo == REAL && $3.aritmetico.tipo == ENTERO)
            {
                insertarSimbolo(&miTablaSimbolos, "temp", REAL, SIMBOLO_VARIABLE);
                insertarCuadrupla(&miTablaCuadruplas, $3.aritmetico.id, 0, ENTERO_A_REAL, miTablaSimbolos.fin->id);
                insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id, 0, ASIGNACION, $1.id);
            }
            else if ($1.tipo == ENTERO && $3.aritmetico.tipo == REAL)
            {
                insertarSimbolo(&miTablaSimbolos, "temp", ENTERO, SIMBOLO_VARIABLE);
                insertarCuadrupla(&miTablaCuadruplas, $3.aritmetico.id, 0, REAL_A_ENTERO, miTablaSimbolos.fin->id);
                insertarCuadrupla(&miTablaCuadruplas, miTablaSimbolos.fin->id, 0, ASIGNACION, $1.id);
            }
            else if ($1.tipo == REAL && $3.aritmetico.tipo == REAL)
            {
                insertarCuadrupla(&miTablaCuadruplas, $3.aritmetico.id, 0, ASIGNACION, $1.id);
            }
        }else{
            if($3.tipo != EXPRESION_ARITMETICA){
                printf("El operando 2 no es de tipo aritmetico\n");
            }
        }
	}
    | operando_b TK_ASIGNACION expresion { 
		printf("Asignacion booleana\n");
        $$.next = makelist(-1);
        if ($3.tipo == EXPRESION_BOOLEANA){
            insertarCuadrupla(&miTablaCuadruplas, $3.booleano.id, 0, ASIGNACION, $1.id);
            $1.verdadero = $3.booleano.verdadero;
            $1.falso = $3.booleano.falso;
        }
        else {
            if($3.tipo != EXPRESION_BOOLEANA){ 
                printf("La expresion no es de tipo booleano\n");
            }
        }
    }
;
alternativa :
    TK_PR_SI expresion TK_ENTONCES M1 instrucciones N M2 lista_opciones TK_PR_FSI { 
		printf("Alternativa\n");
        backpatch(&miTablaCuadruplas, $2.booleano.verdadero, $4);
        backpatch(&miTablaCuadruplas, $2.booleano.falso, $7);
        $$.next = merge($5.next, merge($6.next, $8.next));
	}
    | TK_PR_SI expresion TK_ENTONCES M1 instrucciones TK_PR_FSI {
        printf("backpatch alternativa final\n");
		backpatch(&miTablaCuadruplas, $2.booleano.verdadero, $4);
		if (!estaVaciaListaPosicionesCuadruplas($5.next)){
            printf("Merge en alternativa\n");
			$$.next = merge($2.booleano.falso, $5.next);
        } 
		else
		{
            printf("Goto sin nada\n");
			$$.next = merge($2.booleano.falso, makelist($4));
            insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);
		}
	}
;
lista_opciones :
    TK_SI_NO_SI expresion TK_ENTONCES M1 instrucciones N M2 lista_opciones { 
		printf("Lista de opciones\n");
        backpatch(&miTablaCuadruplas, $2.booleano.verdadero, $4);
        backpatch(&miTablaCuadruplas, $2.booleano.falso, $7);
        $$.next = merge($5.next, merge($6.next, $8.next));
	}
    | %empty { 
		printf("Lista opciones cadena vacia\n");
        $$.next = makelist(-1);
	}
;
iteracion :
    it_cota_fija { 
		printf("Iteracion cota fija\n");
        $$ = $1;
	}
    | it_cota_exp { 
		printf("Iteracion cota expresion\n");
        $$ = $1;
	}
;
it_cota_exp :
    TK_PR_MIENTRAS M1 expresion TK_PR_HACER M2 instrucciones TK_PR_FMIENTRAS { 
		printf("Cota expresion\n");
        backpatch(&miTablaCuadruplas, $3.booleano.verdadero, $5);
        if (!estaVaciaListaPosicionesCuadruplas($6.next)){
            backpatch(&miTablaCuadruplas, $6.next, $2);
        } else {
            insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, $2);
        }
        $$.next = $3.booleano.falso;
	}
;
it_cota_fija :
    TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION expresion TK_PR_HASTA expresion N TK_PR_HACER M1 instrucciones TK_PR_FPARA { 
		printf("Cota fija\n");
        backpatch(&miTablaCuadruplas, $10.next, nextquad(&miTablaCuadruplas));
        celdaSimbolo* celda = getCeldaSimbolo(&miTablaSimbolos, $2->simbolo.nombre);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, INCREMENTAR_BUCLE, celda->id);
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, nextquad(&miTablaCuadruplas) + 2);
        backpatch(&miTablaCuadruplas, $7.next, nextquad(&miTablaCuadruplas));
        insertarCuadrupla(&miTablaCuadruplas, $4.id, 0, ASIGNACION, celda->id);
        insertarCuadrupla(&miTablaCuadruplas, celda->id, $6.id, MENOR, $9);
        $$.next = makelist(nextquad(&miTablaCuadruplas));
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);
	}
;
M1 : 
    %empty { $$ = nextquad(&miTablaCuadruplas);
	}
;
M2 : 
    %empty { $$ = nextquad(&miTablaCuadruplas);
	}
;
N :
    %empty {
        $$.next = makelist(nextquad(&miTablaCuadruplas));
        insertarCuadrupla(&miTablaCuadruplas, 0, 0, GOTO, -1);
	}
;

accion_d :
    TK_PR_ACCION a_cabecera bloque TK_PR_FACCION { 
		printf("Declaracion accion\n"); 
	}
;
funcion_d :
    TK_PR_FUNCION f_cabecera bloque TK_PR_DEV expresion TK_PR_FFUNCION { 
		printf("Declaracion funcion\n"); 
	}
;
a_cabecera :
    TK_PR_IDENTIFICADOR TK_INICIO_PARENTESIS d_par_form TK_FIN_PARENTESIS TK_COMPOSICION_SECUENCIAL { 
		printf("Cabecera de accion\n"); 
	}
;
f_cabecera :
    TK_IDENTIFICADOR TK_INICIO_PARENTESIS lista_d_var TK_FIN_PARENTESIS TK_PR_DEV d_tipo TK_COMPOSICION_SECUENCIAL { 
		printf("Cabecera de funcion\n"); 
	}
;
d_par_form :
    d_p_form TK_COMPOSICION_SECUENCIAL d_par_form { 
		printf("Parametros\n"); 
	}
    | %empty { 
		printf("D par form cadena vacia\n"); 
	}
;
d_p_form : 
    TK_PR_ENT lista_id TK_DECLARACION_TIPO_VARIABLE d_tipo { 
		printf("Parametros de entrada\n"); 
	}
    | TK_PR_SAL lista_id TK_DECLARACION_TIPO_VARIABLE d_tipo { 
		printf("Parametros de salida\n"); 
	}
    | TK_PR_E_S lista_id TK_DECLARACION_TIPO_VARIABLE d_tipo { 
		printf("Parametros de entrada y salida\n"); 
	}
;

accion_ll :
    TK_IDENTIFICADOR TK_INICIO_PARENTESIS l_ll TK_FIN_PARENTESIS { 
		printf("Accion\n"); 
	}
;
funcion_ll :
    TK_IDENTIFICADOR TK_INICIO_PARENTESIS l_ll TK_FIN_PARENTESIS { 
		printf("Funcion\n"); 
	}
;
l_ll : 
    expresion TK_SEPARADOR l_ll { 
		printf("Parametros de llamada\n"); 
	}
    | expresion { 
		printf("Expresion\n"); 
	}
;

%%
int main( int argc, char **argv )
{    
	//yydebug=1;
    ++argv, --argc;
    inicializarTablaS(&miTablaSimbolos);
    inicializarTablaC(&miTablaCuadruplas);
    inicializarPila(&miPilaSimbolos);
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;

    yyparse();
    
    printf("\nTABLA DE SIMBOLOS:\n");
    imprimirTablaSimbolos(&miTablaSimbolos);
    
    printf("\nTABLA DE CUADRUPLAS:\n");
    imprimirTablaCuadruplas(&miTablaCuadruplas, &miTablaSimbolos);

    printf("\nCODIGO EN TRES DIRECCIONES:\n");
    generarCodigoTresDirecciones(&miTablaCuadruplas, &miTablaSimbolos, argv[0]);
}

void yyerror(const char* error){
    fprintf(stderr,"Error: %s \n",error);
}