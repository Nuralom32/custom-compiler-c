algoritmo intercambio;
	ent n, m: entero;
	sal n, m: entero;
{Prec: n= A AND m = B}
	var
		aux: entero;
	fvar
	aux:= n;
	n:= m;
	m := aux
{Post: m=A AND n = B}
falgoritmo
