# Custom Procedural Language Compiler (Source-to-IR)

A compiler built from scratch in **C** using **Flex** and **Bison**. It processes a custom procedural language (with Spanish syntax) and generates **Intermediate Code (Quadruples/Three-Address Code)**, simulating an assembly-like structure.

> **Project Scope:** Implementation of Lexical Analysis, Syntax Analysis, Semantic Analysis, and Intermediate Code Generation for arithmetic expressions and control flow structures.

## 🚀 Technical Achievements

### 1\. Symbol Table Management

* **Dynamic Storage:** Manages variable declarations in both Input/Output (`ent/sal`) and local scopes (`var/fvar`).
* **Type System:** Supports basic types (`entero`, `real`, `caracter`, `cadena`, `booleano`).
* **Constraint:** Boolean identifiers enforce a Fortran-style naming convention (must start with `b_` or `B_`) to simplify type checking.

### 2\. Intermediate Code Generation (Quadruples)

The compiler translates high-level constructs into a `codigo_tres_direcciones.txt` file containing the quadruples:

* **Arithmetic:** Integer/Real operations (+, -, \*, /, div) and implicit type casting.
* **Control Flow (Backpatching):** Implemented complex control structures (`si/if`, `mientras/while`, `para/for`) using **Backpatching** techniques to resolve jump targets in a single pass.
* **Boolean Logic:** Handles conjunctions (`y`) and disjunctions (`o`) for flow control conditions.

## 📝 The Language Syntax

The language features a custom syntax with keywords in Spanish:

* **Types:** `entero`, `real`, `booleano`
* **Flow Control:** `si` (if), `entonces` (then), `mientras` (while), `para` (for)
* **Structure:** `algoritmo`, `falgoritmo`

## 🛠️ Tech Stack

* **Core:** C (Manual memory management for data structures)
* **Lexer:** Flex
* **Parser:** Bison (Yacc)
* **Build:** GNU Make

## 📂 Project Structure

```text
.
├── src/
│   ├── scanner.l          # Lexical rules (Flex)
│   ├── parser.y           # Grammar & Semantic actions (Bison)
│   ├── tabla_simbolos.c   # Symbol Table implementation
│   └── tabla_cuadruplas.c # Logic for generating Quadruples
├── examples/              # Test scripts (programa1.alg, etc.)
├── Makefile               # Build script
└── README.md
```

## 🚦 How to Build & Run

1. **Clean & Compile:**

    ```bash
    make
    ```

    *(Use `make borrar` to clean previous builds)*

2. **Run the Compiler:**

    ```bash
    ./compilador examples/programa1.alg
    ```

3. **View Output:**
    The generated Intermediate Representation is saved to `codigo_tres_direcciones.txt`.

## 👥 Authors

* **Oier Alduncin**
* **Urki Aristu**

## ⚡ Compiler in Action: Code Generation Example

Below is a demonstration of how the compiler translates high-level control structures into linear Three-Address Code.

**Notice two key engineering features:**

1. **Implicit Type Casting:** The compiler automatically detects mixed-type operations (Integer vs Real) and inserts conversion instructions (e.g., `entero_a_real`) to ensure type safety.
2. **Control Flow Mapping:** The high-level `para` (for) loop is deconstructed into initialization, condition checks, and `goto` jumps.

### 1\. Input Source Code (`.alg`)

```pascal
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
```

### 2\. Generated Intermediate Code (Three-Address Code)

The compiler output (`codigo_tres_direcciones.txt`) shows the logical expansion:

```text
1 input c
2 input d
3 temp1 := c +entero d
4 max := temp1
5 temp2 := c -entero d
6 temp3 := (entero_a_real) temp2
7 min := temp3
8 temp4 := (entero_a_real) 0
9 k := temp4
10 j := 0
11 goto 28
12 temp5 := i *entero 2
13 temp6 := (entero_a_real) temp5
14 temp7 := k +real temp6
15 temp8 := (entero_a_real) 2
16 temp9 := temp7 /real temp8
17 k := temp9
18 temp10 := (real_a_entero) k
19 temp11 := temp10 /entero 3
20 j := temp11
21 temp12 := c +entero d
22 max := temp12
23 temp13 := c -entero d
24 temp14 := (entero_a_real) temp13
25 min := temp14
26 i := i + 1
27 goto 29
28 i := 1
29 if i < 10 then goto 12
30 goto 31
31 output max
32 output min
```
