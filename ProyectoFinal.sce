clear
///////////////////////////////////////////////////////////////////////////
// ProyectoFinal_1.sce
//
// Programa final para la clase de métodos numéricos. Este programa
// provee una compilación de soluciones para todos los métodos vistos
// en clase:
//
//  Autores:
//      Jorge Vazquez
//      Irvel Nduva
//
//  Fecha: /05/2016
//  Version 1.0
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
// Funciones comunes
//
// Funciones utilizadas a lo largo de todo el programa
//
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//  LeeMatriz()
//
//  Función que introduce los datos a una matriz de tamaño N*M
//
//  Retorno:
//     dmatValores: Matriz con los datos del usuario
///////////////////////////////////////////////////////////////////////////
function dmatValores = LeeMatriz()
    // Lee las dimensiones de la matriz
    iRow = input("Ingrese el número de renglones: ")
    iCol = input("Ingrese el número de columnas: ")
    // Para cada renglón
    for iT = 1 : iRow
        // Para cada columna
        for iJ = 1 : iCol
            sTexto = "Ingrese el elemento:   (" + string(iT) + ", "
            dmatValores(iT, iJ) = input(sTexto + string(iJ) + "):  ")
        end
    end

    // Imprime los valores leidos de la matriz
    disp('Matriz leída: ');
    ImprimeMatriz(dmatValores)
endfunction


///////////////////////////////////////////////////////////////////////////
//  ImprimeMatriz()
//
//  Imprime todas las celdas de una matriz recibida
//
//  Parametros:
//     dmatValores: La matriz a ser impresa
///////////////////////////////////////////////////////////////////////////
function ImprimeMatriz(dmatValores)
    // Para cada renglon
    for iT = 1 : size(dmatValores,1)
        sLinea = "    "
        // Para cada columna
        for iJ = 1: size(dmatValores, 2)
            // Cuando es el último elemento, no imprime coma
            if(iJ <> size(dmatValores, 2))
                sLinea = sLinea + string(dmatValores(iT, iJ)) + ", "
            else
                sLinea = sLinea + string(dmatValores(iT, iJ))
            end
        end
        disp(sLinea)
    end
endfunction


///////////////////////////////////////////////////////////////////////////
//  ImprimeIntegral()
//
//  Imprime el resultado de una integración recibida
//
//  Parámetros:
//      dA: El punto inicial desde donde se integra la función
//      dB: El punto final hasta donde se integra la función
//      sArgDeff2: La función que fue integrada
//      dRes: El resultado obtenido
///////////////////////////////////////////////////////////////////////////
function ImprimeIntegral(dA, dB, sArgDeff2, dRes)
    sResultado = "El resultado de la integral desde " + string(dA) + " hasta "
    sResultado = sResultado + string(dB) + " para la función " + sArgDeff2
    disp(sResultado + " es: ")
    disp("    " + string(dRes))
endfunction


/////////////////////////////////////////////////////////////////////
//
//  LeeFuncion()
//
//  Pide y declara una función ingresada por el usuario con el nombre
//  recibido en el parámentro sNombreFunción
//      Parametros:
//          sNombreFuncion: El nombre que tendrá la función ingresada
//      Retorno:
//          sArgDeff1: El primer argumento para declarar la función
//          sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////
function [sArgDeff1, sArgDeff2] = LeeFuncion(sNombreFuncion)
    // Lee la función a ser utilizada
    disp("Ingrese la función a ser utilizada:");
    sFunc = input("--> ", "string")

    // Convierte cada letra ingresada en minúsculas
    convstr(sFunc,"l")

    // Serie de reglas para manejar funciones ingresadas en otros formatos,
    if(strstr(sFunc,"y=") == ""& strstr(sFunc,'y =') == "") then
        // En caso de que el usuario ingrese una función de la forma f(x)='..
        if(strstr(sFunc,'f(x)=') <> "") then
            sFunc = part(sFunc, 6:length(sFunc))
        elseif(strstr(sFunc,'f(x) =') <> "") then
            sFunc = part(sFunc, 7:length(sFunc))
        end
        sFunc = "y="+  sFunc
    end

    // Establece los argumentos para declarar la funcion con deff
    sArgDeff1 = 'y=' + sNombreFuncion + '(x)'
    sArgDeff2 = sFunc

endfunction
/////////////////////////////////////////////////////////////////////
//
//  LeeFuncion2()
//
//  Pide y declara una función ingresada por el usuario con el nombre
//  recibido en el parámentro sNombreFunción
//      Parametros:
//          sNombreFuncion: El nombre que tendrá la función ingresada
//      Retorno:
//          sArgDeff1: El primer argumento para declarar la función
//          sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////
function [sArgDeff1, sArgDeff2] = LeeFuncion2(sNombreFuncion)
    // Lee la función a ser utilizada
    disp("Ingrese la función a ser utilizada:");
    sFunc = input("--> ", "string")

    // Convierte cada letra ingresada en minúsculas
    convstr(sFunc,"l")

    // Serie de reglas para manejar funciones ingresadas en otros formatos,
    if(strstr(sFunc,"y=") == ""& strstr(sFunc,'y =') == "") then
        // En caso de que el usuario ingrese una función de la forma f(x)='..
        if(strstr(sFunc,'f(x,y)=') <> "") then
            sFunc = part(sFunc, 7:length(sFunc))
        elseif(strstr(sFunc,'f(x,y) =') <> "") then
            sFunc = part(sFunc, 8:length(sFunc))
        end
        sFunc = "[z]="+  sFunc
    end

    // Establece los argumentos para declarar la funcion con deff
    sArgDeff1 = 'z=' + sNombreFuncion + '(x,y)'
    sArgDeff2 = sFunc
    disp("sArgDeff1: " + sArgDeff1)
    disp("sArgDeff2: " + sArgDeff2)
endfunction


/////////////////////////////////////////////////////////////////////
//  CalculaErrAbs
//
//  Calcula el error absoluto porcentual dado un valor de la
//  aproximación actual y la aproximación anterior
//
//  Parámetros:
//     dPrev    el valor de la aproximación anterior
//     dAct     el valor de la aproximación actual
//  Reegresa:
//     dAprox   el valor de la nueva aproximación
///////////////////////////////////////////////////////////////////////////
function [dAprox] = CalculaErrAbs(dPrev, dAct)
    dAprox = (abs(dAct - dPrev) / abs(dAct)) * 100
endfunction


///////////////////////////////////////////////////////////////////////////
//  DespliegaArreglo()
//
//  Función que despliega los valores de las soluciones encontradas
//  para la matriz inicial
//
//  Parametros:
//     darrX: El arreglo con las soluciones a las incógnitas
///////////////////////////////////////////////////////////////////////////
function DespliegaArreglo(darrX)
    for i = 1: size(darrX, 1)
        disp("   " + string(darrX(i, 1)))
    end
    disp("")
endfunction


///////////////////////////////////////////////////////////////////////////
//  DespliegaEcuacion()
//
//  Función que despliega los valores de las soluciones encontradas
//  para la matriz
//
//  Parametros:
//     darrX: El arreglo con las soluciones a las incógnitas
//     iTipo: Entero que determina el tipo de ecuación a mostrar
///////////////////////////////////////////////////////////////////////////
function DespliegaEcuacion(darrX, iTipo)
    if iTipo == 1 then
        disp("y=" + string(darrX(1,1)) + "+" + string(darrX(2,1)) + "x")
    elseif iTipo == 2 then
        disp("y=" + string(exp(darrX(1,1))) + " e^ "  + string(darrX(2,1)))
    else
           disp("y=" + string(exp(darrX(1,1))) + "^"  + string(darrX(2,1)))
    end
endfunction


///////////////////////////////////////////////////////////////////////////
//  Cramer()
//
//  Función calcula la solución a un sistema de ecuaciones lineales
//  utilizando los determinantes por el método de Cramer.
//
//  Parametros:
//     dmatValores: La matriz que contiene el sistema a resolver
//
///////////////////////////////////////////////////////////////////////////
function Cramer(dmatValores)
    disp(ascii(10))
    sTitulo = "Solucion por el método de Cramer"
    disp("--------------- " + sTitulo + " ---------------")
    dmatCuadrada = GetSimmetricMat(dmatValores)
    dDetMat = det(dmatCuadrada)
    //Tamaño de los renglones
    iRenglones = size(dmatCuadrada,1)
    //Tamaño de las columnas
    iColumnas = size(dmatCuadrada,2)
    iAumentada = size(dmatValores,2)

    // Intercambia cada fila con la matriz aumentada y saca ese resultado
    for i = 1: iColumnas
        for j = 1: iRenglones
            dmatCuadrada(i,j) = dmatValores(j, iAumentada)
        end
        darrSol(i, 1) = det(dmatCuadrada) / dDetMat
        // Restaura el valor original de la columna
        for j = 1: iRenglones
            dmatCuadrada(i,j) = dmatValores(j, i)
        end
    end

    // Despliega los valores de las incógnitas
    disp('Las soluciones a las incógnitas son: ');
    DespliegaArreglo(darrSol)

endfunction

///////////////////////////////////////////////////////////////////////////
//  GetSimmetricMat()
//
//  Función que obtiene la matriz simetrica de una matriz
//
//  Parametros:
//     dmatValores: La matriz asimetrica inicial
//  Retorno:
//     dmatSim: La matriz simétrica final
///////////////////////////////////////////////////////////////////////////
function [dmatSim] = GetSimmetricMat(dmatValores)
    //Tamaño de las columnas
    iRenglones = size(dmatValores,1)
    for i = 1: iRenglones
        for j = 1: iRenglones
            dmatSim(i, j) = dmatValores(i, j)
        end
    end
endfunction


///////////////////////////////////////////////////////////////////////////
// Eliminacion Gaussiana
//
// Método para obtener la solución de un sistema de ecuaciones
// por el metodo de eliminación gaussiana
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//  EliminacionGaussiana()
//
//  Función realiza la eliminación Gaussiana en una matriz ingresada.
//  Algoritmo de Eliminación Gaussiana:
//      1. Para i desde 1 hasta renglones - 1
//          1.1 Para k desde i + 1 hasta renglones
//              1.1.1  factor = - M(k, i) / matriz(i, i)
//              1.1.2  Para j desde i hasta columnas
//                  1.1.2.1  M(k, j) = M(k, j) + factor * M(i, j)
//
//  Parametros:
//     dmatValores: La matriz original a ser procesada
//
///////////////////////////////////////////////////////////////////////////
function EliminacionGaussiana(dmatValores, iTipo)
    disp(ascii(10))
    sTitulo = "Solucion por medio de la Eliminación Gaussiana"
    disp("--------------- " + sTitulo + " ---------------")
    dFactor = 0
    //Tamaño de los renglones
    iRenglones = size(dmatValores,1)
    //Tamaño de las columnas
    iColumnas = size(dmatValores,2)
    for i = 1: iRenglones - 1
        for k = i + 1: iRenglones
            // Evitar divisiones entre cero
            if dmatValores(i,i) ~= 0
                dFactor =  dmatValores(k,i) / dmatValores(i,i)
            else
                dFactor =  0
            end
            disp("Factor: "+ string(dFactor))
            for j = i: iColumnas
                dmatValores(k,j) = dmatValores(k,j) - dFactor*dmatValores(i,j)
            end
        end
    end
    // Imprimir la matriz en el estado reducido
    disp("La matriz en estado reducido es: ")
    ImprimeMatriz(dmatValores)

    // Encontrar los valores de las incógnitas
    darrX = SustituyeHaciaAtras(dmatValores)

    disp(ascii(10))
    // Despliega el arreglo de las soluciones encontradas
    disp('Las soluciones a las incógnitas son: ');
    DespliegaArreglo(darrX)

endfunction


///////////////////////////////////////////////////////////////////////////
// Eliminacion Gauss-Jordan
//
// Método para obtener la solución de un sistema de ecuaciones mediante
// el método de Gauss-Jordan
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//  EliminacionGaussJordan()
//
//  Función realiza la eliminación Gauss-Jordan en una matriz recibida
//  utilizando el siguiente algoritmo:
// 1. Para cada renglon i
//      1.1 pivote = A(i,i)
//      1.2 Para cada columna j
//         1.2.1   A(i,j) = A(i,j) / pivote
//      1.3 Para cada renglon k
//          1.3.1  Si i <> k
//              1.3.1.1  fact = - A(k,i)
//              1.3.1.2   Para cada columna j
//                  1.3.1.2.1 A(k,j) = A(k,j) + fact * A(i,j)
//      1.4 Desplegar matriz
//
//  Parametros:
//     dmatValores: La matriz original a ser procesada
//
///////////////////////////////////////////////////////////////////////////
function EliminacionGaussJordan(dmatValores)
    disp(ascii(10))
    sTitulo = "Solucion por medio de la Eliminación Gauss-Jordan"
    disp("--------------- " + sTitulo + " ---------------")
    dFactor = 0
    //Tamaño de los renglones
    iRenglones = size(dmatValores,1)
    //Tamaño de las columnas
    iColumnas = size(dmatValores,2)

    for i = 1: iRenglones
        dPivote = dmatValores(i, i)
        // Si el renglon no empieza con cero
        if(dPivote <> 0) then
            // Dividir todo el renglon entre el primer elemento
            // Así convierte el primer elemento a un uno
            dPrimerElemento = dmatValores(i,i)
            for j = i: iColumnas
                dmatValores(i,j) = dmatValores(i,j) / dPrimerElemento
            end

            // Hace ceros arriba y abajo de ese uno
            for k = 1: iRenglones
                // Si el actual no es el renglon pivote
                if(k <> i) then
                    // Calcula el factor del primer elemento con el pivote
                    // Evitar divisiones entre cero
                    if dmatValores(i,i) ~= 0
                        dFactor =  dmatValores(k,i) / dmatValores(i,i)
                    else
                        dFactor =  0
                    end
                    // Resta el factor * celda para hacer 0 el primer elemento
                    for j = 1: iColumnas
                        dMult = dFactor * dmatValores(i,j)
                        dmatValores(k,j) = dmatValores(k,j) - dMult
                    end
                end
            end
        end
        // Imprimir la matriz en el número de iteración actual
        disp('Iteración #' + string(i));
        ImprimeMatriz(dmatValores)
    end

    // Imprime la matriz en el estado reducido
    disp('Matriz después de la eliminación Gauss-Jordan: ');
    ImprimeMatriz(dmatValores)
    disp(ascii(10))

    // Encuentra los valores de las incógnitas
    ExtraeSoluciones(dmatValores)

endfunction


/////////////////////////////////////////////////////////////////////
//  ExtraeSoluciones()
//
//  Función extrae las soluciones de una matriz reducidad por Gauss-Jordan
//  y las coloca en un arreglo de soluciones
//
//  Parametros:
//     dmatValores: La matriz ya procesada con el método de gauss-jordan
/////////////////////////////////////////////////////////////////////
function  ExtraeSoluciones(dmatValores)
    //Cantidad de renglones
    iRenglones= size(dmatValores,1)

    //Cantida de columnas
    iColumnas = size(dmatValores,2)

    // Copiar soluciones a arreglo auxiliar
    for i = 1 : iRenglones
        darrAux(i) = dmatValores(i, iColumnas)
    end

    // Despliega el arreglo de las soluciones encontradas
    disp('Las soluciones a las incógnitas son: ');
    DespliegaArreglo(darrAux)

endfunction



///////////////////////////////////////////////////////////////////////////
// Método Montante
//
// Método para obtener la solución de un sistema de ecuaciones
// por el método montante
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//  Montante()
//
//  Función realiza la eliminación montante en una matriz recibida
//  utilizando el siguiente algoritmo:
// 1.     PivoteAnterior = 1
// 2.     Para cada renglon i desde 1 hasta numero de renglones
//  2.1    Para cada renglon k desde 1 hasta el numero de renglones
//      2.1.1   Si k es diferente a la i
//          2.1.1.1  Para cada columna j desde i + 1 hasta numero de columnas
//              2.1.1.1.1 M(k,j) = (M(i,i)*M(k,j)-M(k,i)*M(i,j))/PivoteAnterior
//          2.1.1.2   M(k,i) = 0
//  2.2    PivoteAnterior = M(i,i)
//  2.3    Despliega M
// 3. Para cada renglon i desde 1 hasta Renglones -1
//      M(i, i) = PivoteAnterior
// 4. Despliega M
// 5. Para cada renglon i desde 1 hasta Renlones
//      X(i) = m(i,i) / pivoteAnterior
// 6.  Despliega X
//  2.3.1  M(k,k) = M(i,i)
//
//  Parametros:
//     dmatValores: La matriz original a ser procesada
///////////////////////////////////////////////////////////////////////////
function Montante(dmatValores, iTipo)
    disp(ascii(10))
    sTitulo = "Solucion por medio del método Montante"
    disp("--------------- " + sTitulo + " ---------------")
    //Inicializar el pivote anterior
    iPivoteAnterior = 1
    //Numero de renglones
    iRenglones = size(dmatValores,1)
    //Numero de columnas
    iColumnas = size(dmatValores,2)

    for i = 1: iRenglones
        for k = 1: iRenglones
            if k ~= i then
                for j = i + 1: iColumnas
                    dmatValores(k,j) = ( dmatValores(i,i) * dmatValores(k,j) - dmatValores(k,i) * dmatValores(i,j)) / iPivoteAnterior
                end
                //Hacer ceros en la columna i excepto en el pivote
                dmatValores(k,i) = 0
            end
        end
        //Actualizar el pivote
        iPivoteAnterior = dmatValores(i,i)

        // Imprimir la matriz en el número de iteración actual
        disp('Iteración #' + string(i));
        ImprimeMatriz(dmatValores)
    end
    //Igualar los pivotes anteriores con el ultimo pivote
    for i = 1: iRenglones-1
        dmatValores(i,i) = iPivoteAnterior
    end

    // Imprime la matriz en el estado reducido
    disp('Matriz después de la eliminación por el método Montante: ');
    ImprimeMatriz(dmatValores)
    disp(ascii(10))

    //Dividir cada valor de la ultima columna entre el pivote
    for i = 1: iRenglones
        // Evitar divisiones entre cero
        if iPivoteAnterior ~= 0
            X(i) = dmatValores(i,iColumnas) / iPivoteAnterior
        else
            X(i) = 0
        end
    end
    // Despliega las soluciones de los valores a las incógnitas
    disp('Las soluciones a las incógnitas son: ');
    if iTipo < 4 then
        DespliegaEcuacion(X,iTipo)
    else
        DespliegaArreglo(X)
    end

endfunction


///////////////////////////////////////////////////////////////////////////
//  SustituyeHaciaAtras()
//
//  Función calcula los valores de las incógnitas en la matriz.
//  el paso final de la eliminación Gaussiana.
//  Algoritmo de Sustitucion Hacia Atras
//      1. X(n) = M(renglones, columnas) / M(renglones, columnas-1)
//      2. Para i desde renglones-1 hasta 1
//          2.1 Suma = 0
//          2.2 Para j desde columnas-1 hasta i+1
//              2.2.1  Suma = Suma + M(i, j) * X(j)
//          2.3 X(i) = (M(i, columnas) - Suma) / M(i,i)
//
//  Parametros:
//      dmatValores: La matriz ya procesada con la eliminación de gauss
///////////////////////////////////////////////////////////////////////////
function [darrX] = SustituyeHaciaAtras(dmatValores)
    //Cantidad de renglones
    iRen = size(dmatValores,1)

    //Cantida de columnas
    iCol = size(dmatValores,2)

    iSuma = 0
    //Obtener la primera solución
    if dmatValores(iRen, iRen) ~= 0
        darrX(iRen, 1) = dmatValores(iRen, iCol) / dmatValores(iRen, iRen)
    else
        // Evitar divisiones entre cero
        darrX(iRen, 1) = 0
    end
    // Para cada renglon
    for i = iRen - 1: -1:1
        iSuma = 0;
        // Para cada columna
        for j = iCol - 1:-1:i+1
            iSuma = iSuma + dmatValores(i,j) * darrX(j);
        end
        if dmatValores(i,i) ~= 0
            darrX(i) = (dmatValores(i, iCol) - iSuma) / dmatValores(i,i)
        else
            darrX(i) = 0
        end
    end

endfunction


///////////////////////////////////////////////////////////////////////////
// Secante: Solución de una Raíz de Una Ecuación No Lineal
//
//  Programa de Solución de una Raíz de Una Ecuación No Lineal
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//  CalculaSecante()
//
//  Pide una ecuación no lineal y calcula la solución de su raíz
//
/////////////////////////////////////////////////////////////////////
function CalculaSecante()
    // Solicita la función a ser resuelta con el nombre de funcionSecante
    [sArgDeff1, sArgDeff2] = LeeFuncion("FuncionSecante")

    // Lee los datos iniciales
    [dXPrev, dXAct, dErrMeta, iMaxIter] = leeDatosSecante()

    // Calcula las iteraciones para calcular las raices
    IteraSecante(dXPrev, dXAct, dErrMeta, iMaxIter, sArgDeff1, sArgDeff2)

endfunction


/////////////////////////////////////////////////////////////////////
//  IteraSecante()
//
//  Realiza las iteraciones para calcular la solución a la ecuación
//  no lineal por medio del método de la secante.
//  Parametros:
//      dXPrev: El valor de X previo a la iteración actual
//      dXAct: El valor de X en la iteración actual
//      dErrAbsMeta: El error absoluto mínimo que se tiene como objetivo
//      iMaxIter: La cantidad máxima de iteraciones que se pueden realizar
//      sArgDeff1: El primer argumento para declarar la función
//      sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////
function IteraSecante(dXPrev, dXAct, dErrAbsMeta, iMaxIter, sArgDeff1, sArgDeff2)
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)

    // Calcula la primera iteración y la despliega
    dXSig = IteraX(dXPrev, dXAct, sArgDeff1, sArgDeff2)

    // Obtiene el valor de la función evaluada con X = dXSig
    dEval = FuncionSecante(dXSig)

    // Inicializa el valor del error de aproximación con un valor muy grande
    dErrAbsAct = 999999999999999.9
    iIterAct = 1
    disp("Iteración #"+ string(iIterAct) + ":")
    disp("X: "+ string(dXSig))

    // Mostrar todos los decimales en el proceso
    format(25);

    // Realiza las iteraciones y actualiza los valores de X hasta alcanzar un
    // límite
    while(((iIterAct < iMaxIter) & (dErrAbsAct > dErrAbsMeta) & (dEval ~= 0.0)))
        dXPrev = dXAct
        dXAct = dXSig
        dXSig = IteraX(dXPrev, dXAct)
        dEval = FuncionSecante(dXSig)
        iIterAct = iIterAct + 1
        // Calcula el error absoluto porcentual actual
        dErrAbsAct = CalculaErrAbs(dXSig, dXAct)
        disp("Iteración #"+ string(iIterAct) + ":")
        disp("X: "+ string(dXSig))
        disp("Error absoluto: "+ string(dErrAbsAct) + "%")
    end

    // Imprime la forma en la que se obtuvo la raiz dependiendo de cual
    // haya sido el límite alcanzado
    if iIterAct >= iMaxIter then
        disp("La raiz fue aproximada con el numero de iteraciones dado")
    elseif dErrAbsAct <= dErrAbsMeta then
        disp("La raiz fue aproximada con el error absoluto porcentual")
    elseif dEval == 0 then
        disp("La raiz encontrada fue exacta")
    end
endfunction


/////////////////////////////////////////////////////////////////////
//  leeDatosSecante()
//      Regresa:
//          dA: El punto inicial desde donde se integra la función
//          dB: El punto final hasta donde se integra la función
//          iN: El número de divisiones a utilizar
//
/////////////////////////////////////////////////////////////////////
function [dXPrev, dXAct, dErrAbsMeta, iMaxIter] = leeDatosSecante()

    // Solicita el valor inicial para x previa y x actual, el error
    // absoluto en valor porcentual y el numero maximo de iteraciones
    dXPrev = input("Ingrese el valor de X previo: ")
    dXAct = input("Ingrese el valor de X actual: ")
    dErrAbsMeta = input("Ingrese el valor del error absoluto: ")
    iMaxIter = input("Ingrese el valor máximo de iteraciones: ")

endfunction


/////////////////////////////////////////////////////////////////////
//  IteraX
//
//  Realiza una iteración utilizando el método de la Secante con los
//  valores recibidos de dXPrev y dXAct y regresa el valor de dXSig.
//
//  Parametros:
//      dXPrev    el valor de previo de x
//      dXAct     el valor actual de x
//      sArgDeff1: El primer argumento para declarar la función
//      sArgDeff2: El segundo argumento para deff
//  Regresa:
//      dXSig     el siguiente valor de x
/////////////////////////////////////////////////////////////////////
function [dXSig] = IteraX(dXPrev, dXAct, sArgDeff1, sArgDeff2)
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)

    // Obtiene los valores de la función evaluada en dX
    dYPrev = FuncionSecante(dXPrev)
    dYAct = FuncionSecante(dXAct)

    // Calcula el siguiente valor de x
    dXSig = dXAct - (dYAct * (dXPrev - dXAct)) / (dYPrev - dYAct)
endfunction

/////////////////////////////////////////////////////////////////////
//  EvalueBiseccion
//
//  Evalua el valor de X en la función definida para bisección
//
//  Parametros:
//     dXPrev    el valor de x a evaluas
//  Regresa:
//     dVal     valor de x evaluado en la función
/////////////////////////////////////////////////////////////////////

function [dVal] = EvaluaBiseccion(dX)
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)

    // Calcula el valor de X Evalueado
    dVal = FuncionBiseccion(dX)
endfunction

/////////////////////////////////////////////////////////////////////
//  IteraBiseccion()
//
//  Realiza las iteraciones para calcular la solución a la ecuación
//  no lineal por medio del método de biseccion
//  Parametros:
//     dXPrev    el valor de previo de x
//     dXAct     el valor actual de x
//     dErroAbsMeta el error maximo permitid
//     iMaxIter Numero máximo de iteraciones
//     sArgDeff1: El primer argumento para declarar la función
//     sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////

function IteraBiseccion(dXPrev, dXAct, dErrAbsMeta, iMaxIter, sArgDeff1, sArgDeff2)

    dEval = EvaluaBiseccion(dXPrev)
    // Inicializa el valor del error de aproximación con un valor muy grande
    dErrAbsAct = 99.9
    iIterAct = 1
    disp("Iteración #"+ string(iIterAct) + ":")
    disp("X: "+ string((dXPrev + dXAct) / 2))

    // Mostrar todos los decimales en el proceso
    format(25);

    // Realiza las iteraciones y actualiza los valores de X hasta alcanzar un
    // límite
    while(((iIterAct < iMaxIter) & (dErrAbsAct > dErrAbsMeta) & (dEval ~= 0.0)))

        // Se inicializa la variable con el valor promedio entre el promedio de los datos
        dEval = EvaluaBiseccion((dXPrev + dXAct) / 2)

        // Se obtiene el valor de la X inicial evaluada en la función
        dXEval = EvaluaBiseccion(dXPrev)

        // Actualizar las X de acuerdo a su valor evaluado en la función
        if dEval > 0 then
            if dXEval > 0 then
                dXPrev = (dXPrev + dXAct) / 2
            else
                disp("Enters")
                dXAct = (dXPrev + dXAct) / 2
            end
        else
            if dXEval > 0 then
                dXAct = (dXPrev + dXAct) / 2
            else
                dXPrev = (dXPrev + dXAct) / 2
            end
        end

        iIterAct = iIterAct + 1
        // Calcula el error absoluto porcentual actual
        dErrAbsAct = ((dXAct - dXPrev) / dXAct) * 100
        disp("Iteración #"+ string(iIterAct) + ":")
        disp("X: "+ string((dXPrev + dXAct)/ 2))
        disp("Error absoluto: "+ string(dErrAbsAct) + "%")
    end

    // Imprime la forma en la que se obtuvo la raiz dependiendo de cual
    // haya sido el límite alcanzado
    if iIterAct >= iMaxIter then
        disp("La raiz fue aproximada con el numero de iteraciones dado")
    elseif dErrAbsAct <= dErrAbsMeta then
        disp("La raiz fue aproximada con el error absoluto porcentual")
    elseif dEval == 0 then
        disp("La raiz encontrada fue exacta")
    end

endfunction

///////////////////////////////////////////////////////////////////////////
// Biseccion: Solución de una Raíz de Una Ecuación No Lineal
//
//  Programa de Solución de una Raíz de Una Ecuación No Lineal
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//  CalculaBiseccion()
//
//  Pide una ecuación no lineal y calcula la solución de su raíz
//
/////////////////////////////////////////////////////////////////////

function CalculaBiseccion()
    // Solicita la función a ser resuelta con el nombre de funcionBiseccion
    [sArgDeff1, sArgDeff2] = LeeFuncion("FuncionBiseccion")
    // Lee los datos iniciales
    [dXPrev, dXAct, dErrMeta, iMaxIter] = leeDatosSecante()
    // Calcula las iteraciones para calcular las raices
    IteraBiseccion(dXPrev, dXAct, dErrMeta, iMaxIter, sArgDeff1, sArgDeff2)

endfunction

/////////////////////////////////////////////////////////////////////
//  SiguienteRegula(dXPrev,dXAct)
//
//  Función que obtiene la siugiente X de acuerdo a la formula del metodo
//
//  Parametros:
//     dXPrev    el valor de x Inferior
//     dXAct     el valor de x Superior
//     sArgDeff1: El primer argumento para declarar la función
//     sArgDeff2: El segundo argumento para deff
//  Regresa:
//     dVal     la siguiente iteración de acuerdo a la función
/////////////////////////////////////////////////////////////////////

function [dXSiguiente] = SiguienteRegula(dXPrev, dXAct)
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)
    dPrimerValor = FuncionRegulaFalsi(dXPrev)
    dSegundoValor = FuncionRegulaFalsi(dXAct)
    dXSiguiente = (dXAct*dPrimerValor - dXPrev*dSegundoValor) / (dPrimerValor - dSegundoValor)
endfunction

/////////////////////////////////////////////////////////////////////
//  EvaluaRegula
//
//  Evalua el valor de X en la función definida para regunla
//
//  Parametros:
//     dXPrev    el valor de x a evaluas
//  Regresa:
//     dVal     valor de x evaluado en la función
/////////////////////////////////////////////////////////////////////
function [dVal] = EvaluaRegula(dXValor)
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)
    dVal = FuncionRegulaFalsi(dXValor)
endfunction


/////////////////////////////////////////////////////////////////////
//  IteraRegula()
//
//  Realiza las iteraciones para calcular la solución a la ecuación
//  no lineal por medio del método de regula falsi
//  Parametros:
//     dXPrev    el valor de previo de x
//     dXAct     el valor actual de x
//     dErroAbsMeta el error maximo permitid
//     iMaxIter Numero máximo de iteraciones
//     sArgDeff1: El primer argumento para declarar la función
//     sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////

function IteraRegula(dXPrev, dXAct, dErrAbsMeta, iMaxIter, sArgDeff1, sArgDeff2)

    // Inicializa el valor del error de aproximación con un valor muy grande
    dErrAbsAct = 99.9
    iIterAct = 1
    disp("Iteración #"+ string(iIterAct) + ":")
    disp("X: "+ string(SiguienteRegula(dXPrev,dXAct)))
    dEval = 99.0

    // Mostrar todos los decimales en el proceso
    format(25);
    // Realiza las iteraciones y actualiza los valores de X hasta alcanzar un
    // límite
    while(((iIterAct < iMaxIter) & (dErrAbsAct > dErrAbsMeta) & (dEval ~= 0.0)))

        // Se inicializa la variable con el valor promedio entre el promedio de los datos
        dSiguienteX = SiguienteRegula(dXPrev,dXAct)

        //Se guarda el valor previo

        dEval = EvaluaRegula(dSiguienteX)
        // Se obtiene el valor de la X inicial evaluada en la función
        dXEval = EvaluaRegula(dXPrev)

        // Actualizar las X de acuerdo a su valor evaluado en la función
        if dEval > 0 then
            if dXEval > 0 then
                dXPrev = dSiguienteX
            else
                dXAct = dSiguienteX
            end
        else
            if dXEval > 0 then
                dXAct = dSiguienteX
            else
                dXPrev = dSiguienteX
            end
        end

        iIterAct = iIterAct + 1
        // Calcula el error absoluto porcentual actual
        dNewX = SiguienteRegula(dXPrev,dXAct)
        dErrAbsAct = ((dNewX - dSiguienteX) / dNewX) * 100
        disp("dNewX: " + string(dNewX))
        disp("dSiguienteX: " + string(dSiguienteX))
        disp("Iteración #"+ string(iIterAct) + ":")
        disp("X: "+ string(SiguienteRegula(dXPrev,dXAct)))
        disp("Error absoluto: "+ string(dErrAbsAct) + "%")
    end

    // Imprime la forma en la que se obtuvo la raiz dependiendo de cual
    // haya sido el límite alcanzado
    if iIterAct >= iMaxIter then
        disp("La raiz fue aproximada con el numero de iteraciones dado")
    elseif dErrAbsAct <= dErrAbsMeta then
        disp("La raiz fue aproximada con el error absoluto porcentual")
    elseif dEval == 0 then
        disp("La raiz encontrada fue exacta")
    end

endfunction

///////////////////////////////////////////////////////////////////////////
// Regula Falsi: Solución de una Raíz de Una Ecuación No Lineal
//
//  Programa de Solución de una Raíz de Una Ecuación No Lineal
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//  CalculaRegulaFalsi()
//
//  Pide una ecuación no lineal y calcula la solución de su raíz
//
/////////////////////////////////////////////////////////////////////

function CalculaRegulaFalsi()
    // Solicita la función a ser resuelta con el nombre de FuncionRegulaFalsi
    [sArgDeff1, sArgDeff2] = LeeFuncion("FuncionRegulaFalsi")
    // Lee los datos iniciales
    [dXPrev, dXAct, dErrMeta, iMaxIter] = leeDatosSecante()
    // Calcula las iteraciones para calcular las raices
    IteraRegula(dXPrev, dXAct, dErrMeta, iMaxIter, sArgDeff1, sArgDeff2)

endfunction

/////////////////////////////////////////////////////////////////////
// iSiguiente
//  Función que se encarga de calcular la siguiente aproximación de acuerdo a
//  formula de la serie de Netwon-Raphson:
//  iInicio - f(iIncio)/f'(iInicio)
//
//
//  Parametros:
//     iInicio    es el valor de donde empieza la serie
//
//  Regresa:
//      iNuevo       la siguiente aproximación
/////////////////////////////////////////////////////////////////////

function iNuevo = iSiguiente(iInicio)
    //Inicializar nuevo con 1
    iNuevo = 1
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)
    iNuevo = FuncionRaphson(iInicio)
    iNuevo =  iNuevo / numderivative(FuncionRaphson,iInicio)
    iNuevo = iInicio - iNuevo
endfunction


/////////////////////////////////////////////////////////////////////
// iErrorAprox
//  Función que se encarga de calcular el error aproximado de acuerdo a la
//  formula: AproxNueva - AproxVieja / AproxNueva * 100
//
//
//  Parametros:
//     iVieja    es la aproximacion vieja
//     iNueva     es la nueva aproximación
//  Regresa:
//      iE       es el valor del error aproximado
/////////////////////////////////////////////////////////////////////

function iE = iErrorAprox(iVieja,iNueva)
    //Inicializar el error en 0
    iE = 0
    //Calcular el error
    iE = abs(iNueva - iVieja) / abs(iNueva) * 100
endfunction
/////////////////////////////////////////////////////////////////////
//  Calcula
//  Función que se encarga de mostrar el resultado aproximado de
//   la raiz
//
//  Parametros:
//     iInicio    es el valor de X inicial
//     iError     es el valor del error maximo
//     iTeraciones es el valor maximo a iterar
/////////////////////////////////////////////////////////////////////
function IteraNewtonRaphson(iInicio, dErrAbsMeta, iMaxIter)
    //Inicializar variables
    dErrAbsAct = 9999999
    iIterAct = 1;
    iViejo = 0;
    iNueva = 1;
    iRaiz = 1
    deff(sArgDeff1, sArgDeff2)
    //Hacer el ciclo hasta que el error sea mayor o igual al error que pidio el
    // usuario o hasta que se haya llegado al limite de ciclos pedido por el
    // usuario o hasta encontrar la raiz de la función
    while dErrAbsAct > dErrAbsMeta & iIterAct <= iMaxIter & iRaiz ~= 0
        if iIterAct == 1 then
            disp("Primera iteración: ")
            iNueva = iSiguiente(iInicio)
            disp(string(iNueva))
            iIterAct = iIterAct + 1
            iRaiz = FuncionRaphson(iNueva);
        end
        if iIterAct > 1 then
            disp("Iteración: " + string(iIterAct))
            iViejo = iNueva
            disp("Valor previo: " + string(iViejo))
            iNueva = iSiguiente(iViejo)
            disp("Valor nuevo: " + string(iNueva))
            dErrAbsAct = iErrorAprox(iViejo,iNueva)
            disp("Error aproximado: " + string(dErrAbsAct))
            iRaiz = FuncionRaphson(iNueva);
        end

        iIterAct = iIterAct + 1
        if iIterAct >= iMaxIter then
            disp("La raiz fue aproximada con el numero de iteraciones dado")
        elseif dErrAbsAct <= dErrAbsMeta then
            disp("La raiz fue aproximada con el error absoluto porcentual")
        elseif iRaiz == 0 then
            disp("La raiz encontrada fue exacta")
        end
    end
endfunction

/////////////////////////////////////////////////////////////////////
//  leeDatosSecante()
//      Regresa:
//          dA: El punto inicial desde donde se integra la función
//          dB: El punto final hasta donde se integra la función
//          iN: El número de divisiones a utilizar
//
/////////////////////////////////////////////////////////////////////
function [dXInicio, dErrAbsMeta, iMaxIter] = LeeDatosRaphson()

    // Solicita el valor inicial para x previa y x actual, el error
    // absoluto en valor porcentual y el numero maximo de iteraciones
    dXInicio = input("Ingrese el valor de X previo: ")
    dErrAbsMeta = input("Ingrese el valor del error absoluto: ")
    iMaxIter = input("Ingrese el valor máximo de iteraciones: ")

endfunction

/////////////////////////////////////////////////////////////////////
//  CalculaNewtonRaphson()
//
//  Pide una ecuación no lineal y calcula la solución de su raíz
//
/////////////////////////////////////////////////////////////////////
function CalculaNewtonRaphson()
 // Solicita la función a ser resuelta con el nombre de FuncionRaphson
    [sArgDeff1, sArgDeff2] = LeeFuncion("FuncionRaphson")
    // Lee los datos iniciales
    [dXInicio, dErrAbsMeta, iMaxIter] = LeeDatosRaphson()
    // Calcula las iteraciones para calcular las raices
    IteraNewtonRaphson(dXInicio,dErrAbsMeta,iMaxIter)
endfunction


/////////////////////////////////////////////////////////////////////
//  leedatosRegresión()
//
//  Función que lee datos para una matriz para regresiones
//
//  Regresa:
//  dmatValores = Matriz con los datos introducidos por el usuario
//
/////////////////////////////////////////////////////////////////////
function [dmatValores] = leeDatosRegresion()
    //Cantida de datos
    iCantidad = input("¿Cuantos datos? ")
    for i = 1:iCantidad
        for j = 1: 2
            dmatValores(i,j) = input("Introduzca el dato para la casilla " + string(i) + string(j))
        end
    end

endfunction

/////////////////////////////////////////////////////////////////////
//  sumatoria(dMat,iTipo)
//
//  Funcion que calcula la sumatoria depiendo de la que se requiere de los datos de una matriz
//
//  Parametros:
//  dmatValores = Matriz de donde se obtienen los datos
//  iTipo = Entero que determina la sumatoria a obtener
//
//  Regresa:
//  dSum = Sumatoria de datos
/////////////////////////////////////////////////////////////////////
function dSum = sumatoria(dmatValores,iTipo)
    //Tamaño de los renglones
    iRenglones = size(dmatValores,1)
    //Tamaño de las columnas
    iColumnas = size(dmatValores,2)
    dSum = 0
    //Suma de los valores de x
    if iTipo == 1 then
        for i = 1: iRenglones
            dSum = dSum + dmatValores(i,1)
        end
    //Suma de los valores de x*x
    elseif iTipo == 2 then
        for i = 1: iRenglones
            dSum = dSum + (dmatValores(i,1)*dmatValores(i,1))
        end 
    //Suma de los valores de log(x)
    elseif iTipo == 3 then
        for i = 1: iRenglones
            dSum = dSum + log(dmatValores(i,1))
        end
    //Suma de los valores de log(x)*log(x)
    elseif iTipo == 4 then
        for i = 1: iRenglones
            dSum = dSum + (log(dmatValores(i,1)) * log(dmatValores(i,1)))
        end
    //Suma de los valores de y
    elseif iTipo == 5 then
        for i = 1: iRenglones
            dSum = dSum + dmatValores(i,2)
        end
    elseif iTipo == 6 then
        for i = 1: iRenglones
            dSum = dSum + (dmatValores(i,2) * dmatValores(i,1))
        end
    elseif iTipo == 7 then
        for i = 1: iRenglones
            dSum = dSum + log(dmatValores(i,2))
        end
    elseif iTipo == 8 then
        for i = 1: iRenglones
            dSum = dSum + (log(dmatValores(i,2)) * dmatValores(i,1))
        end
    else
        for i = 1: iRenglones
            dSum = dSum + (log(dmatValores(i,1)) * log(dmatValores(i,2)))
        end
    end
endfunction


/////////////////////////////////////////////////////////////////////
//  llenaMatriz()
//
//  Función que llena una matríz dependiendo del tipo de regresión
//
//  Regresa:
//  dmatValores = Matriz con los valores correspondientes
//
/////////////////////////////////////////////////////////////////////

function dmatValores = llenaMatriz(dmatMatriz,iTipo)
    //Cantidad de datos
    iCantidad = size(dmatMatriz,1)
    if iTipo == 1 then
        dmatValores(1,1) = iCantidad
        dmatValores(1,2) = sumatoria(dmatMatriz,1)
        dmatValores(2,1) = sumatoria(dmatMatriz,1)
        dmatValores(2,2) = sumatoria(dmatMatriz,2)
        dmatValores(1,3) = sumatoria(dmatMatriz,5)
        dmatValores(2,3) = sumatoria(dmatMatriz,6)
    elseif iTipo == 2 then
        dmatValores(1,1) = iCantidad
        dmatValores(1,2) = sumatoria(dmatMatriz,1)
        dmatValores(2,1) = sumatoria(dmatMatriz,1)
        dmatValores(2,2) = sumatoria(dmatMatriz,2)
        dmatValores(1,3) = sumatoria(dmatMatriz,7)
        dmatValores(2,3) = sumatoria(dmatMatriz,8)
    else
        dmatValores(1,1) = iCantidad
        dmatValores(1,2) = sumatoria(dmatMatriz,3)
        dmatValores(2,1) = sumatoria(dmatMatriz,3)
        dmatValores(2,2) = sumatoria(dmatMatriz,4)
        dmatValores(1,3) = sumatoria(dmatMatriz,7)
        dmatValores(2,3) = sumatoria(dmatMatriz,9)
    end
endfunction

///////////////////////////////////////////////////////////////////////////
// Regresión Lineal: Aproximación de una función a ciertos puntos
//
//  Programa de Solución de una función a ciertos puntos
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//  RegresiónLineal()
//
//  Pide datos y se llena la matriz que se resuelve por el metodo de montante
//
/////////////////////////////////////////////////////////////////////
function RegresionLineal()

// Leer los datos iniciales
    dMat = leeDatosRegresion()
// Introducir datos en la matriz
    dCompleteMatrix = llenaMatriz(dMat,1)
// Resolver la matriz por el metodo de montante
    Montante(dCompleteMatrix,1)

endfunction

///////////////////////////////////////////////////////////////////////////
// Regresión Exponencial: Aproximación de una función a ciertos puntos
//
//  Programa de Solución de una función a ciertos puntos
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//  RegresiónExponencial()
//
//  Pide datos y se llena la matriz que se resuelve por el metodo de montante
//
/////////////////////////////////////////////////////////////////////
function RegresionExponencial()

// Leer los datos iniciales
    dMat = leeDatosRegresion()
// Introducir datos en la matriz
    dCompleteMatrix = llenaMatriz(dMat,2)
// Resolver la matriz por el metodo de montante
    Montante(dCompleteMatrix,2)

endfunction


///////////////////////////////////////////////////////////////////////////
// RegresiónPotencial()
// Regresión Pontencial: Aproximación de una función a ciertos puntos
//
//  Solución de una función a ciertos puntos
//
/////////////////////////////////////////////////////////////////////
function RegresionPotencial()

// Leer los datos iniciales
    dMat = leeDatosRegresion()
// Introducir datos en la matriz
    dCompleteMatrix = llenaMatriz(dMat,3)
// Resolver la matriz por el metodo de montante
    Montante(dCompleteMatrix,3)

endfunction


/////////////////////////////////////////////////////////////////////
//  InterLagrange()
//  Función que realiza una interpolación de Lagrange entre dos
//  puntos recibidos
//
//      Parámetros:
//          dmatPuntos: Los pares de puntos que se interpolarán
//          dPred: El punto a predecir
//
/////////////////////////////////////////////////////////////////////
function InterLagrange(dmatPuntos, dPred)
    disp(ascii(10))
    sTitulo = "Interpolación por medio de Lagrange"
    disp("--------------- " + sTitulo + " ---------------")
    iT = size(dmatPuntos, 1)
    // La tabla de diferencias
    dmatDiff = ones(iT, 1)
    dPredPunto = zeros(1, 1)

    // Construir la tabla de diferencias
    for i = 1:iT
        for j = 1:iT
            if i ~= j then
                dNumerador = dmatDiff(i,:) .* (dPred - dmatPuntos(j, 1))
                dDenom = dmatPuntos(i,1)-dmatPuntos(j,1)
                // Evitar dividir entre cero
                if iOpciones ~= 0
                    dmatDiff(i, :) = dNumerador ./ dDenom
                else
                    dmatDiff(i, :) = 0
                end
            end
        end
    end
    // Calcular el valor del punto a predecir
    for i = 1:iT
        dPredPunto = dPredPunto + dmatPuntos(i,2) * dmatDiff(i,:)
    end
    // Imprime la predicción
    disp('La predicción para el punto ingresado es: ');
    ImprimeMatriz(dPredPunto)
    disp(ascii(10))
endfunction


/////////////////////////////////////////////////////////////////////
//  InterNewtonDiff()
//  Función que realiza una interpolación de diferencias difididas
//  de Newton entre dos puntos recibidos
//
//      Parámetros:
//          dmatPuntos: Los pares de puntos que se interpolarán
//          dPred: El punto a predecir
//
/////////////////////////////////////////////////////////////////////
function InterNewtonDiff(dmatPuntos, dPred)
    disp(ascii(10))
    sTitulo = "Interpolación por medio de Diferencias divididas de Newton"
    disp("---------- " + sTitulo + " ----------")

    iN = size(dmatPuntos, 1)
    dDiferencia = dmatPuntos(2,1) - dmatPuntos(1,1)
    dCoeficiente = (dPred - dmatPuntos(1,1)) / dDiferencia
    dSuma = dmatPuntos(1,2)
    for iT=1:iN - 1
        for iJ=1:iN - iT
            dmatInterP(iT,iJ) = dmatPuntos(iJ+1, 2) - dmatPuntos(iJ, 2)
        end
        for iJ=1:iN - iT
            dmatPuntos(iJ, 2) = dmatInterP(iT,iJ)
        end
    end
    for iT = 2:iN
        dResMult = 1
        for iJ = 1:iT - 1
            dResMult = (dCoeficiente + 1 -iJ) * dResMult / iJ
        end
        dSuma = dSuma + dResMult * dmatInterP(iT-1,1)
    end

    // Imprime la predicción
    disp('La predicción para el punto ingresado es: ');
    disp(dSuma)
    disp(ascii(10))

endfunction



/////////////////////////////////////////////////////////////////////
//  leeDatosInterpolacion()
//  Funcion que lee los datos necesarios para evaluar una integral
//  de una función entre dos puntos.
//      Regresa:
//          dmatPuntos: Los puntos que se interpolarán
//          darrPred: Los puntos que serán predecidos con la función interpolada
//
/////////////////////////////////////////////////////////////////////
function [dmatPuntos, dPred] = leeDatosInterpolacion()
    // Lee los puntos de interpolación
    iN = input(' Ingrese la cantidad de puntos a interpolar: ')
    for iT = 1 : iN
        sTexto = "Ingrese el punto #" + string(iT) + " en X: "
        dmatPuntos(iT, 1) = input(sTexto)
        sTexto = "Ingrese el punto #" + string(iT) + " en Y: "
        dmatPuntos(iT, 2) = input(sTexto)
    end

    dPred = input(' Ingrese el punto a predecir: ')

endfunction


/////////////////////////////////////////////////////////////////////
//  IntegraTrapecios()
//  Función que aproxima el resultado de una integral evaluada en
//  FuncionIntegración por el método de Trapecios
//
//      Parámetros:
//          dA: El punto inicial desde donde se integra la función
//          dB: El punto final hasta donde se integra la función
//          iN: El número de divisiones a utilizar
//          sArgDeff1: El primer argumento para declarar la función
//          sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////
function IntegraTrapecios(dA, dB, iN, sArgDeff1, sArgDeff2)
    deff(sArgDeff1, sArgDeff2)
    iH = (dB - dA) / iN
    iFA = FuncionIntegracion(dA)
    iFB = FuncionIntegracion(dB)
    iSum = 0

    // Obtiene el valor de la sumatoria
    for i = 1: iN - 1
        iSum = iSum + FuncionIntegracion(i * iH)
    end

    // Calcula el resultado de acuerdo a la fórmula
    iSum = iSum * 2
    dResultado = (iH / 2) * (iFA + iSum + iFB)

    // Imprime el resultado
    disp(ascii(10))
    sTitulo = "Integración por el método Trapecios con " + string(iN)
    disp("---------- " + sTitulo + " cortes"  + " ----------")
    ImprimeIntegral(dA, dB, sArgDeff2, dResultado)

endfunction


/////////////////////////////////////////////////////////////////////
//  IntegraSimpson()
//  Función que aproxima el resultado de una integral evaluada en
//  FuncionIntegración por el método de Simpson 1/3
//      Parámetros:
//          dA: El punto inicial desde donde se integra la función
//          dB: El punto final hasta donde se integra la función
//          iN: El número de divisiones a utilizar
//          sArgDeff1: El primer argumento para declarar la función
//          sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////
function IntegraSimpson(dA, dB, iN, sArgDeff1, sArgDeff2)
    deff(sArgDeff1, sArgDeff2)
    iH = (dB - dA) / iN
    // Obtiene el valor de la función evaluada en dA
    iFA = FuncionIntegracion(dA)

    // Obtiene el valor de la función evaluada en dB
    iFB = FuncionIntegracion(dB)
    iSum1 = 0
    iSum2 = 0

    // Obtiene el valor de la primera sumatoria
    if (iN > 1)
        for i = 1:2:(iN - 1)
            iSum1 = iSum1 + FuncionIntegracion(i * iH)
        end
        iSum1 = iSum1 * 4
    end

    // Obtiene el valor de la segunda sumatoria
    if (iN > 2)
        for i = 2:2:(iN - 2)
            iSum2 = iSum2 + FuncionIntegracion(i * iH)
        end
        iSum2 = iSum2 * 2
    end
    dResultado = (iH / 3) * (iFA + iSum1 + iSum2 + iFB)

    // Imprime el resultado
    disp(ascii(10))
    sTitulo = "Integración por el método Simpson 1/3 con " + string(iN)
    disp("---------- " + sTitulo + " cortes"  + " ----------")
    ImprimeIntegral(dA, dB, sArgDeff2, dResultado)

endfunction


/////////////////////////////////////////////////////////////////////
//  leeDatosIntegracion()
//  Funcion que lee los datos necesarios para evaluar una integral
//  de una función entre dos puntos.
//      Regresa:
//          dA: El punto inicial desde donde se integra la función
//          dB: El punto final hasta donde se integra la función
//          iN: El número de divisiones a utilizar
//          sArgDeff1: El primer argumento para declarar la función
//          sArgDeff2: El segundo argumento para deff
//
/////////////////////////////////////////////////////////////////////
function [dA, dB, iN, sArgDeff1, sArgDeff2] = leeDatosIntegracion()
    // Lee los límites y el número de cortes
    dA = input(' Ingrese el límite inferior: ')
    dB = input(' Ingrese el límite superior: ')
    iN = input(' Ingrese el número de cortes: ')

    // Lee la función a ser integrada
    [sArgDeff1, sArgDeff2] = LeeFuncion("FuncionIntegracion")

endfunction



/////////////////////////////////////////////////////////////////////
//   iDet(dmatValores,iX,iY)
// 
//  Función que saca el determinante de una matriz de un valor de la matriz 
//
//  Parametros:
//     dmatValores
//     iX: Coordenada X del valor de la matriz a evitar
//     iY: Coordenada Y del valor de la matriz a evitar
/////////////////////////////////////////////////////////////////////
function iDeterminante =  iDet(dmatValores,iX,iY)
     //Numero de renglones
    iRenglones = size(dmatValores,1)
    //Numero de columnas
    iColumnas = size(dmatValores,2)
    //Auxiliar
    iContador = 1
    iA = 1
    iB = 1
    iDeterminante = 0
    for i = 1: iRenglones
        for j = 1: iColumnas
            if i ~= iX & j ~= iY then
                if iContador == 2 | iContador == 3 then
                    iContador = iContador + 1
                    iB = iB * dmatValores(i,j)
                else
                    iContador = iContador + 1
                    iA = iA * dmatValores(i,j)
                end
            end
        end
    end
    iDeterminante = iA - iB
endfunction


/////////////////////////////////////////////////////////////////////
//   Cofactores()
//
//  Función que saca la matriz de cofactores de una matriz
//
//  Parametros:
//     dmatValores: Matriz de donde se obtienen los valores para sacar la
//              matriz de cofactores.
/////////////////////////////////////////////////////////////////////
function Cofactores(dmatValores)
    //Numero de renglones
    iRenglones = size(dmatValores,1)
    //Numero de columnas
    iColumnas = size(dmatValores,2)
    iAux = dmatValores
    iSigno = 1
    for i = 1: iRenglones
        for j = 1: iColumnas
            dmatValores(i,j) = iDet(iAux,i,j)*iSigno
            iSigno = iSigno*-1
        end
    end
    disp("Matriz Cofactores")
    ImprimeMatriz(dmatValores)
    Transpose(dmatValores)
endfunction


/////////////////////////////////////////////////////////////////////
//  Transpose(dmatMatrix)
// 
//  Función que saca la matriz transpuesta de una matriz
//
//  Parametros:
//     dmatMatrix: Matriz de donde se obtienen los valores
/////////////////////////////////////////////////////////////////////
function Transpose(dmatMatrix)
    //Numero de renglones
    iRenglones = size(dmatMatrix,1)
    //Numero de columnas
    iColumnas = size(dmatMatrix,2)
    //Matriz transpuesta
    iTranspose = 0
    for i = 1:iRenglones
        for j = 1:iColumnas
            iTranspose(j,i) = dmatMatrix(i,j)
        end
    end
    disp("Matriz Cofactores Transpuesta")
    ImprimeMatriz(iTranspose)
    iDeterminante = GetDeterminante(iAux)
    InversaCofactores(iTranspose,iDeterminante)
endfunction


/////////////////////////////////////////////////////////////////////
//   GetDeterminante(dmatMatrix)
// 
//  Función que saca el determinante inverso de una matriz
//
//  Parametros:
//     dmatMatrix
//  Regresa:
//     iDeterminante: Determinante inverso de la matriz
/////////////////////////////////////////////////////////////////////
function iDeterminante = GetDeterminante(dmatMatrix)
    iDeterminante = 1/det(dmatMatrix)
endfunction


/////////////////////////////////////////////////////////////////////
//   InversaCofactores(dmatValores,iDeterminante)
// 
//
//  Función que saca la matriz inversa de una matriz a través de la formula:
//  Inversa: 1/determinante de la matriz * (Matriz de cofactores)
//
//  Parametros:
//     dmatValores: A introducir datos
/////////////////////////////////////////////////////////////////////
function InversaCofactores(dmatValores,iDeterminante)
    //Numero de renglones
    iRenglones = size(dmatValores,1)
    //Numero de columnas
    iColumnas = size(dmatValores,2)
    for i = 1: iRenglones
        for j = 1: iColumnas
            dmatValores(i,j) = dmatValores(i,j) * iDeterminante
         end
    end
    ImprimeMatriz(dmatValores)
endfunction

///////////////////////////////////////////////////////////////////////////
// Newton-Raphson para ecuaciones no lineales
//
//  Programa de integración por el metodo de newton-raphson
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//  IteraNewton(iTeraciones,darrX,sArgDeff1,sArgDeff2....)
//
//  Programa que realiza las iteraciones del metodo newton-raphson para
//  integral
//
//  Parametros:
//  iTeraciones = Numero de iteraciones máximas a dar
//  darrX = Arreglo que contiene el vector X
//  sArgDeff1: El primer argumento para declarar la función
//  sArgDeff2: El segundo argumento para deff
//  and so on....
//
///////////////////////////////////////////////////////////////////////////

function IteraNewton(iTeraciones, darrX, sArgDeff1,sArgDeff2,sArgDeff3,sArgDeff4,sArgDeff5,sArgDeff6,sArgDeff7,sArgDeff8,sArgDeff9,sArgDeff10,sArgDeff11,sArgDeff12)
    //Declara la función a ser resuelta
    deff(sArgDeff1, sArgDeff2)
    deff(sArgDeff3, sArgDeff4)
    deff(sArgDeff5, sArgDeff6)
    deff(sArgDeff7, sArgDeff8)
    deff(sArgDeff9, sArgDeff10)
    deff(sArgDeff11,sArgDeff12)
    iVal = sOriginal1(1,2)
    disp("iVal: " + string(iVal))
    for i = 1: iTeraciones
        J = [sParcialX1(darrX(1),darrX(2)), sParcialY1(darrX(1),darrX(2)); sParcialX2(darrX(1),darrX(2)), sParcialY2(darrX(1),darrX(2))]
        F = [sOriginal1(darrX(1),darrX(2)); sOriginal2(darrX(1),darrX(2))]
        darrX  = darrX - inv(J) * F
        disp(darrX)
    end
endfunction


/////////////////////////////////////////////////////////////////////
//  LeDatosNewton()
//
//  Pide los datos para integrar una ecuación por newton-raphson
/////////////////////////////////////////////////////////////////////

function LeeDatosNewton()
    dX(1) = input("Introduzca la x: ")
    dX(2) = input("Introduzca la y: ")
    disp("Introduzca la primera equación")
    [sArgDeff1, sArgDeff2] = LeeFuncion2("sOriginal1")
    disp("Introduzca la segunda equación" )
    [sArgDeff3, sArgDeff4] = LeeFuncion2("sOriginal2")
    disp("Introduzca la derivada parcial con respecto a X de la primera ecuación ")
    [sArgDeff5, sArgDeff6] = LeeFuncion2("sParcialX1")
    disp("Introduzca la dervida parcial con respecto a Y de la primera ecuación ")
    [sArgDeff7, sArgDeff8] = LeeFuncion2("sParcialY1")
    disp("Introduzca la derivadar parcial con respecto a X de la segunda ecuación ")
    [sArgDeff9, sArgDeff10] = LeeFuncion2("sParcialX2")
    disp("Introduzca la derivada parcial con respecto a Y de la segunda ecuacuón")
    [sArgDeff11, sArgDeff12] = LeeFuncion2("sParcialY2")
    IteraNewton(1,dX,sArgDeff1,sArgDeff2,sArgDeff3,sArgDeff4,sArgDeff5,sArgDeff6,sArgDeff7,sArgDeff8,sArgDeff9,sArgDeff10,sArgDeff11,sArgDeff12)


endfunction
/////////////////////////////////////////////////////////////////////
//  CalculaNewton()
//
//  Pide datos y se llena la matriz que se encuentra su integral
//
/////////////////////////////////////////////////////////////////////

function CalculaNewton()
// Leer datos iniciales
    LeeDatosNewton()
endfunction
///////////////////////////////////////////////////////////////////////////
//     divisionSitentica(darrCoeficientes,dFactor,dCantidad)
//
//   Función que calcula 2 diviones sinteticas de acuerdo al metodo y regresa
//   los valores para obtener el siguiente facot
//
//   Parametros:
//    darrCoeficientes = Arreglo de datos con los coeficientes de la ecuación
//    dCantidad = Cantidad de datos del arreglo
//    dFactor = Valor inicial de las iteraciones
///////////////////////////////////////////////////////////////////////////
function [dPrimerValor, dSegundoValor] = divisionSintetica(darrCoeficientes, dCantidad, dFactor)
    darrSoluciones(1) = darrCoeficientes(1)
    for i = 2:dCantidad
        darrSoluciones(i) = (darrSoluciones(i-1) * dFactor) +  darrCoeficientes(i)
    end
    for i = 1: dCantidad
        disp(string(darrSoluciones(i)))
    end
    darrSoluciones2(1) = darrCoeficientes(1)
    dPrimerValor = darrSoluciones(dCantidad)
    for i = 2: dCantidad-1
        darrSoluciones2(i) = (darrSoluciones2(i-1) * dFactor) +  darrSoluciones(i)
    end
    dSegundoValor = darrSoluciones2(dCantidad-1)
endfunction
///////////////////////////////////////////////////////////////////////////
//     IteracionVieta(darrDatos,dFactor,dCantidad,dIteraciones)
//
//  Funcion que realiza las Iteraciones del metodo Birge Vieta hasta llegar
//   al numero deseado de
//
//   Parametros:
//    darrDatos = Arreglo de datos con los coeficientes de la ecuación
//    dCantidad = Cantidad de datos del arreglo
//    dFactor = Valor inicial de las iteraciones
//    dIteraciones = Numero máximo de las iteraciones
///////////////////////////////////////////////////////////////////////////
function IteracionVieta(darrDatos,dFactor, dCantidad,dIteraciones)
    //Inicalizamos el error con un valor muy grande
    dErrorAbsAct = 99999.9
    //Inicializamos las iteraciones que tenemos
    dIteracionesActuales = 0
    while (dIteracionesActuales <> dIteraciones)
        //Obtenemos los primeros valores de la iteración
        [dPrimerValor, dSegundoValor ] = divisionSintetica(darrDatos,dCantidad,dFactor)
        dFactorPrevio = dFactor
        dFactor = dFactor - dPrimerValor/dSegundoValor
        if dIteracionesActuales <> 0 then
            disp("Iteracion: " + string(dIteracionesActuales))
            disp("Factor: " + string(dFactor))
            disp("Error: " + string(abs(dFactor-dFactorPrevio) / abs(dFactor)))
        else
            disp("Iteracion: " + string(dIteracionesActuales))
            disp("Factor: " + string(dFactor))
        end
        dIteracionesActuales = dIteracionesActuales + 1
    end
endfunction
///////////////////////////////////////////////////////////////////////////
// leeDatosVieata()
//
//  Funcion que pide los datos para BirgeVieta
//
//   Regresa:
//    darrDatos = Arreglo de datos con los coeficientes de la ecuación
//    dCantidad = Cantidad de datos del arreglo
///////////////////////////////////////////////////////////////////////////
function [darrDatos,dCantidad]  = leeDatosVieta()
    dCantidad = input("¿Grado del polinomio? ")
    dCantidad = dCantidad + 1
    for i = 1: dCantidad
        darrDatos(i) = input("Introduzca los coeficientes del polinomio, si en algún coeficiente no hay introduzca 0 ")
    end
    dFactor = input("¿Valor inicial? ")
    dIteraciones = input("¿Cuantas iteraciones? ")
    //Función que manda a llamar a iterar Birge Vieat
    IteracionVieta(darrDatos,dFactor,dCantidad,dIteraciones)
endfunction

///////////////////////////////////////////////////////////////////////////
// Birge Vieta
//
//  Programa que encuentra la raiz de una ecuación por el metodo de 
//  Birge Vieta
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
// CalculaVieta()
//
//  Funcion que manda a inicializar todos los valores necesarios para el 
//  metodo de Birge Vieta
//
///////////////////////////////////////////////////////////////////////////
function CalculaVieta()
    [darrDatos,dCantidad] = leeDatosVieta()
endfunction


////////////////////////   PROGRAMA PRINCIPAL   ///////////////////////////

function Menu()
    //Inicializar variables
    iOpciones = 0
    while (iOpciones ~= 6)
        // Limpiar la pantalla antes del menu de opciones
        disp(ascii(10) + ascii(10) + ascii(10) + ascii(10) + ascii(10))
        disp(ascii(10) + ascii(10) + ascii(10) + ascii(10) + ascii(10))
        disp("=================== Menu de opciones ===================")
        disp("1. Solución de ecuaciones no lineales")
        disp("2. Solución de ecuaciones lineales")
        disp("3. Ajuste de curvas")
        disp("4. Interpolación")
        disp("5. Integración")
        disp("6. Salir")
        disp(ascii(10))
        iOpciones = input(" Qué opción deseas (1-6) --> ")
        if (iOpciones == 1) then
            EcuacionesNoLineales()
        elseif (iOpciones == 2) then
            EcuacionesLineales()
        elseif (iOpciones == 3 ) then
            AjusteDeCurvas()
        elseif (iOpciones == 4) then
            Interpolacion()
        elseif (iOpciones == 5) then
            Integracion()
        elseif (iOpciones == 6) then
            disp("Hasta luego ")
        else
            disp("Opción erronea")
        end
    end
endfunction


function EcuacionesNoLineales()
    iOpciones = 0
    while(iOpciones  ~=  6)
        disp(ascii(10) + ascii(10))
        sTitulo = "Solución de ecuaciones no lineales"
        disp("================ " + sTitulo + " ================")
        disp("1. Bisección")
        disp("2. Newton-Rapson")
        disp("3. Secante")
        disp("4. Regula Falsi")
        disp("5. Birge Vieta")
        disp("6. Salir")
        iOpciones = input(" Qué opción deseas (1-6) --> ")
        if iOpciones == 1 then
            CalculaBiseccion()
        elseif iOpciones == 2 then
            CalculaNewtonRaphson()
        elseif (iOpciones == 3) then
            CalculaSecante()
        elseif (iOpciones == 4) then
            CalculaRegulaFalsi()
        elseif (iOpciones == 5) then
            CalculaVieta()
        end
    end
endfunction


function EcuacionesLineales()
    iOpciones = 0
    bPrimeraVez = %T
    while (iOpciones ~= 5)
        sMensaje = ""
        // Desplegar un mensaje diferente para la segunda vez que entre
        if(bPrimeraVez == %T)
            sMensaje = "Presiona enter para ingresar una matriz "
        else
            sMensaje = "Presiona 1 si deseas ingresar una matriz diferente,"
            sMensaje = sMensaje + ascii(10) + "2 "
            sMensaje = sMensaje + "si deseas usar la matriz anterior de nuevo "
        end
        iOpciones = input(sMensaje +  "o 5 si deseas regresar --> ")
        if(iOpciones == 5)
            break
        end
        // Para permitir al usuario ingresar una matriz en todos los casos
        // En la primera vez, forzosamente se tiene que leer la matriz
        if(iOpciones ~= 5 & iOpciones ~= 2 | bPrimeraVez)
            dmatValores = LeeMatriz()
        end

        if iOpciones ~= 5 then
            bPrimeraVez = %F
            disp(ascii(10) + ascii(10))
            sTitulo = "Solución de sistemas de ecuaciones lineales"
            disp("================ " + sTitulo + " ================")
            disp("1. Cramer")
            disp("2. Eliminación Gaussiana")
            disp("3. Gauss-Jordan")
            disp("4. Montante")
            disp("5. Salir")
            iOpciones = input(" Qué opción deseas (1-5) --> ")

            if (iOpciones == 1) then
                Cramer(dmatValores)
            elseif (iOpciones == 2) then
                EliminacionGaussiana(dmatValores)
            elseif (iOpciones == 3) then
                EliminacionGaussJordan(dmatValores)
            elseif (iOpciones == 4) then
                Montante(dmatValores,5)
            end
        end
    end
endfunction


function AjusteDeCurvas()
    iOpciones = 0
    while (iOpciones ~= 5)
        // Para permitir al usuario ingresar una matriz en todos los casos
        // En la primera vez, forzosamente se tiene que leer la matriz
        disp(ascii(10) + ascii(10))
        sTitulo = "Ajuste de curvas"
        disp("================ " + sTitulo + " ================")
        disp("1. Regresión Lineal")
        disp("2. Regresión Exponencial")
        disp("3. Regresión Potencial")
        disp("4. Inversa por Cofactores")
        disp("5. Salir")
        iOpciones = input(" Qué opción deseas (1-6) --> ")
        if iOpciones == 1 then
            RegresionLineal()
        elseif iOpciones == 2 then
            RegresionExponencial()
        elseif iOpciones == 3 then
            RegresionPotencial()
        elseif iOpciones == 4 then
            dMatMatriz = LeeMatriz()
            Cofactores(dMatMatriz)
        end
    end
endfunction


function Interpolacion()
    iOpciones = 0
    bPrimeraVez = %T
    while (iOpciones ~= 3)
        sMensaje = ""
        // Desplegar un mensaje diferente para la segunda vez que entre
        if(bPrimeraVez == %T)
            sMensaje = "Presiona enter para ingresar los datos a interpolar "
        else
            sMensaje = "Presiona 1 si deseas ingresar datos diferentes,"
            sMensaje = sMensaje + ascii(10) + "2 "
            sMensaje = sMensaje + "si deseas usar los datos anteriores de nuevo "
        end
        iOpciones = input(sMensaje +  "o 3 si deseas regresar --> ")
        if(iOpciones == 3)
            break
        end
        // Para permitir al usuario ingresar una los datos en todos los casos
        // En la primera vez, forzosamente se tiene que leer la matriz
        if(iOpciones ~= 3 & iOpciones ~= 2 | bPrimeraVez)
            [dmatPuntos, dPred] = leeDatosInterpolacion()
        end
        bPrimeraVez = %F
        disp(ascii(10) + ascii(10))
        sTitulo = "Interpolación"
        disp("================ " + sTitulo + " ================")
        disp("1. Lagrange")
        disp("2. Diferencias Divididas de Newton")
        disp("3. Salir")
        iOpciones = input(" Qué opción deseas (1-3) --> ")
        if iOpciones == 1 then
            InterLagrange(dmatPuntos, dPred)
        elseif iOpciones == 2 then
            InterNewtonDiff(dmatPuntos, dPred)
        end
    end
endfunction


function Integracion()
    iOpciones = 0
    bPrimeraVez = %T
    while (iOpciones ~= 4)
        sMensaje = ""
        // Desplegar un mensaje diferente para la segunda vez que entre
        if(bPrimeraVez == %T)
            sMensaje = "Presiona enter para ingresar una función a integrar "
        else
            sMensaje = "Presiona 1 si deseas ingresar una función diferente,"
            sMensaje = sMensaje + ascii(10) + "2 "
            sMensaje = sMensaje + "si deseas usar la función anterior de nuevo "
        end
        iOpciones = input(sMensaje +  "3 si quieres ir direectamente al menu, 4 si deseas regresar --> ")
        if(iOpciones == 4)
            break
        end
        // Para permitir al usuario ingresadr una matriz en todos los casos
        // En la primera vez, forzosamente se tiene que leer la matriz
        // o checar si quiere ir directamente al metodo de Newton-Rapson
        if(iOpciones ~= 4 & iOpciones ~= 2 | bPrimeraVez) then
            if (iOpciones ~= 3) then
                [dA, dB, iN, sArgDeff1, sArgDeff2] = leeDatosIntegracion()
            end
        end
        bPrimeraVez = %F
        disp(ascii(10) + ascii(10))
        sTitulo = "Integración"
        disp("================ " + sTitulo + " ================")
        disp("1. Trapecio")
        disp("2. Simpson 1/3")
        disp("3. Newton-Rapson para ecuaciones no lineales")
        disp("4. Salir")
        iOpciones = input(" Qué opción deseas (1-4) --> ")
        if iOpciones == 1 then
            IntegraTrapecios(dA, dB, iN, sArgDeff1, sArgDeff2)
        elseif iOpciones == 2 then
            IntegraSimpson(dA, dB, iN, sArgDeff1, sArgDeff2)
        elseif iOpciones == 3 then
            CalculaNewton()
        end
    end

endfunction


Menu()
