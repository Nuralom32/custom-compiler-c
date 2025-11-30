algoritmo ejemploPara;
    ent c, d: entero;
    sal max: entero; min: real;
{Prec: c = A AND d = B}
    var
        i, j: entero;
        k: real;
    fvar
    max := c + d;
    min := c - d;
    k := 0;
    j := 0;
    para i := 1 hasta 10 hacer
    	k := (k + i * 2) / 2;
    	j := k div 3;
        max := c + d;
        min := c - d
    fpara
{Post: max = A + B AND min = A - B}
falgoritmo
