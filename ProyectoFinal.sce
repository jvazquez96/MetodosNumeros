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
//     dMatrix: La matriz a ser impresa
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
    dAprox = ((dAct - dPrev) / dAct) * 100
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
function EliminacionGaussiana(dmatValores)
    disp(ascii(10))
    sTitulo = "Solucion por medio de la Eliminación Gaussiana"
    disp("--------------- " + sTitulo + " ---------------")
    iFactor = 0
    //Tamaño de los renglones
    iRenglones = size(dmatValores,1)
    //Tamaño de las columnas
    iColumnas = size(dmatValores,2)
    for i = 1: iRenglones - 1
        for k = i + 1: iRenglones
            iFactor =  dmatValores(k,i) / dmatValores(i,i)
            disp("Factor: "+ string(iFactor))
            for j = i: iColumnas
                dmatValores(k,j) = dmatValores(k,j) - iFactor*dmatValores(i,j)
            end
        end
    end
    // Imprimir la matriz en el estado reducido
    ImprimeMatriz(dmatValores)

    // Encontrar los valores de las incógnitas
    darrX = SustituyeHaciaAtras(dmatValores)

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
    iFactor = 0
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
                    dFactor =  dmatValores(k,i) / dmatValores(i,i)
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

    // Encuentra los valores de las incógnitas
    disp('Las soluciones a las incógnitas son: ');
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
function Montante(dmatValores)
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
        ImprimeMatriz(dmatValores)
    end
    //Igualar los pivotes anteriores con el ultimo pivote
    for i = 1: iRenglones-1
        dmatValores(i,i) = iPivoteAnterior
    end
    ImprimeMatriz(dmatValores)
    //Dividir cada valor de la ultima columna entre el pivote
    for i = 1: iRenglones
        X(i) = dmatValores(i,iColumnas) / iPivoteAnterior
    end
    // Despliega las soluciones de los valores a las incógnitas
    disp('Soluciones a las incógnitas son: ');
    DespliegaArreglo(X)

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
    end
    // Para cada renglon
    for i = iRen - 1: -1:1
        iSuma = 0;
        // Para cada columna
        for j = iCol - 1:-1:i+1
            iSuma = iSuma + dmatValores(i,j) * darrX(j);
        end
        if dmatValores(i,i) ~= 0
            darrX(i) = (dmatValores(i,iCol) - iSuma) / dmatValores(i,i)
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
//     dXPrev    el valor de previo de x
//     dXAct     el valor actual de x
//  Regresa:
//     dXSig     el siguiente valor de x
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


////////////////////////   PROGRAMA PRINCIPAL   ///////////////////////////

function Menu()
    //Inicializar variables
    iOpciones = 0
    while (iOpciones ~= 6)
        disp(ascii(10) + ascii(10) + ascii(10) + ascii(10) + ascii(10))
        disp("=================== Menu de opciones ===================")
        disp("1. Solución de ecuaciones no lineales")
        disp("2. Solución de ecuaciones lineales")
        disp("3. Ajuste de curvas")
        disp("4. Interpolación")
        disp("5. Integración")
        disp("6. Salir")
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
        elseif (iOpciones == 3) then
            CalculaSecante()
        elseif (iOpciones == 4) then
            CalculaRegulaFalsi()
        end
    end
endfunction


function EcuacionesLineales()
    iOpciones = 0
    bPrimeraVez = %T
    while (iOpciones ~= 5)
        iOpciones = input("Ingresa la matrix, si deseas salir teclea 5")
        if iOpciones ~= 5 then 
            dmatMatriz = LeeMatriz()
        end
        if iOpciones < 5 then
            disp("Menu de opciones")
        sMensaje = ""
        // Desplegar un mensaje diferente para la segunda vez que entre
        if(bPrimeraVez == %T)
            sMensaje = "Presiona enter para ingresar una matriz "
        else
            sMensaje = "Persiona 1 si deseas ingresar una matriz diferente, 2 "
            sMensaje = sMensaje + "si deseas usar la matriz anterior de nuevo "
        end
        iOpciones = input(sMensaje +  "o 5 si deseas regresar --> ")
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

            if (iOpciones == 2) then
                EliminacionGaussJordan(dmatValores)
            elseif (iOpciones == 3) then
                EliminacionGaussiana(dmatValores)
            elseif (iOpciones == 4) then
                Montante(dmatValores)
            end
        end
    end
    end
endfunction


function AjusteDeCurvas()
    iOpciones = 0
    while (iOpciones ~= 5)
        disp(ascii(10) + ascii(10))
        sTitulo = "Ajuste de curvas"
        disp("================ " + sTitulo + " ================")
        disp("1. Regresión Lineal")
        disp("2. Regresión Exponencial")
        disp("3. Regresión Potencial")
        disp("4. Inversa por Cofactores")
        disp("5. Salir")
        iOpciones = input(" Qué opción deseas (1-6) --> ")
    end
endfunction


function Interpolacion()
    iOpciones = 0
    while (iOpciones ~= 3)
        disp(ascii(10) + ascii(10))
        sTitulo = "Interpolación"
        disp("================ " + sTitulo + " ================")
        disp("1. Lagrange")
        disp("2. Diferencias Divididas de Newton")
        disp("3. Salir")
        iOpciones = input(" Qué opción deseas (1-3) --> ")
    end
endfunction


function Integracion()
    iOpciones = 0
    while (iOpciones ~= 4)
        disp(ascii(10) + ascii(10))
        sTitulo = "Integración"
        disp("================ " + sTitulo + " ================")
        disp("1. Trapecio")
        disp("2. Simpson 1/3")
        disp("3. Newton-Rapson para ecuaciones no lineales")
        disp("4. Salir")
        iOpciones = input(" Qué opción deseas (1-4) --> ")

    end

endfunction


Menu()
