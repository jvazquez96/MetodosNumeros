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
//     dmatMatriz: Matriz con los datos del usuario
///////////////////////////////////////////////////////////////////////////
function dmatMatriz = LeeMatriz()
    // Lee las dimensiones de la matriz
    iRow = input("Ingrese el número de renglones: ")
    iCol = input("Ingrese el número de columnas: ")
    // Para cada renglón
    for iT = 1 : iRow
        // Para cada columna
        for iJ = 1 : iCol
            sTexto = "Ingrese el elemento:   ("  + string(iT) + ", "
            dmatMatriz(iT, iJ) = input(sTexto + string(iJ) + "):  ")
        end
    end
endfunction


///////////////////////////////////////////////////////////////////////////
//  ImprimeMatriz()
//
//  Imprime todas las celdas de una matriz recibida
//
//  Parametros:
//     dMatrix: La matriz a ser impresa
///////////////////////////////////////////////////////////////////////////
function ImprimeMatriz(dMatrix)
    // Para cada renglón
    for iT = 1 : size(dMatrix,1)
        sLinea = ""
        // Para cada columna
        for iJ = 1: size(dMatrix, 2)
           sLinea = sLinea + string(dMatrix(iT, iJ)) + " , "
        end
        disp(sLinea)
    end
endfunction

function ImprimeMatriz(dMat)
    // Para cada renglon
    for iT = 1 : size(dMat,1)
        sLinea = ""
        // Para cada columna
        for iJ = 1: size(dMat, 2)
            // Cuando es el último elemento, no imprime coma
            if(iJ <> size(dMat, 2))
                sLinea = sLinea + string(dMat(iT, iJ)) + ", "
            else
                sLinea = sLinea + string(dMat(iT, iJ))
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
//
/////////////////////////////////////////////////////////////////////
function LeeFuncion(sNombreFuncion)
    // Lee la función a ser utilizada
    disp(" Ingrese la función a ser utilizada:");
    sFunc = input("--> ", "string")

    // Convierte cada letra ingresada en minúsculas
    convstr(sFunc,"l")

    // Serie de reglas para manejar funciones ingresadas en otros formatos,
    if(strstr(sFunc,"y=") == "" & strstr(sFunc,'y =') == "") then
        // En caso de que el usuario ingrese una función de la forma f(x)='..
        if(strstr(sFunc,'f(x)=') <> "" ) then
            sFunc = part(sFunc, 6:length(sFunc))
        elseif(strstr(sFunc,'f(x) =') <> "" ) then
            sFunc = part(sFunc, 7:length(sFunc))
        end
        sFunc = "y=" +  sFunc
    end

    // Declarar la funcion con el nombre especificado
    deff('y=' + sNombreFuncion + '(x)', sFunc)

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
///////////////////////////////////////////////////////////////////////////
function EliminacionGaussiana()
    // Pide al usuario la matriz a ser utilizada
    dmatMatriz = LeeMatriz()
    iFactor = 0
    //Tamaño de los renglones
    iRenglones = size(dmatMatriz,1)
    //Tamaño de las columnas
    iColumnas = size(dmatMatriz,2)
    for i = 1: iRenglones - 1
        for k = i + 1: iRenglones
            iFactor =  dmatMatriz(k,i) / dmatMatriz(i,i)
            disp("Factor: " + string(iFactor))
            for j = i: iColumnas
                dmatMatriz(k,j) = dmatMatriz(k,j) - iFactor*dmatMatriz(i,j)
            end
        end
    end
    // Imprimir la matriz en el estado reducido
    ImprimeMatriz(dmatMatriz)

    // Encontrar los valores de las incógnitas
    darrX = SustituyeHaciaAtras(dmatMatriz)

    // Despliega el arreglo de las soluciones encontradas
    DespliegaArreglo(darrX)

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
//      dMatValues: La matriz ya procesada con la eliminación de gauss
///////////////////////////////////////////////////////////////////////////
function [darrX] = SustituyeHaciaAtras(dMatValues)
    //Cantidad de renglones
    iRenglones= size(dMatValues,1)

    //Cantida de columnas
    iColumnas = size(dMatValues,2)

    iSuma = 0
    //Obtener la primera solución
    darrX(iRenglones,1) = dMatValues(iRenglones,iColumnas)/dMatValues(iRenglones,iRenglones)
    // Para cada renglon
    for i = iRenglones - 1: -1:1
        iSuma = 0;
        // Para cada columna
        for j = iColumnas - 1:-1:i+1
            iSuma = iSuma + dMatValues(i,j) * darrX(j);
        end
        darrX(i) = (dMatValues(i,iColumnas) - iSuma) / dMatValues(i,i)
    end

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
        disp(string(darrX(i, 1)))
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
    // Solicita la función a ser resuelta y la declara como funcionSecante
    LeeFuncion("FuncionSecante")

    // Lee los datos iniciales
    [dXPrev, dXAct, dErrAbsMeta, iMaxIter] = leeDatosSecante()

    // Calcula las iteraciones para calcular las raices
    IteraSecante(dXPrev, dXAct, dErrAbsMeta, iMaxIter)


endfunction


/////////////////////////////////////////////////////////////////////
//  IteraSecante()
//
//  Realiza las iteraciones para calcular la solución a la ecuación
//  no lineal por medio del método de la secante.
//
/////////////////////////////////////////////////////////////////////
function IteraSecante(dXPrev, dXAct, dErrAbsMeta, iMaxIter)
    // Calcula la primera iteración y la despliega
    dXSig = IteraX(dXPrev, dXAct)

    // Obtiene el valor de la función evaluada con X = dXSig
    dEval = FuncionSecante(dXSig)
    disp(" Iteración #" + string(iIterAct) + ":")
    disp(" X: " + string(dXSig))

    // Realiza las iteraciones y actualiza los valores de X hasta alcanzar un
    // límite
    while(((iIterAct < iMaxIter) & (dErrAbsAct > dErrAbsMeta) & (dEval ~= 0.0)))
        dXPrev = dXAct
        dXAct = dXSig
        dXSig = IteraX(dXPrev, dXAct)
        dEval = EvaluaX(dXSig)
        iIterAct = iIterAct + 1
        // Calcula el error absoluto porcentual actual
        dErrAbsAct = CalculaErrAbs(dXSig, dXAct)
        disp(" Iteración #" + string(iIterAct) + ":")
        disp(" X: " + string(dXSig))
        disp(" Error absoluto: " + string(dErrAbsAct) + "%")
    end

    // Imprime la forma en la que se obtuvo la raiz dependiendo de cual
    // haya sido el límite alcanzado
    if iIterAct >= iMaxIter then
        disp(" La raiz fue aproximada con el numero de iteraciones dado")
    elseif dErrAbsAct <= dErrAbsMeta then
        disp(" La raiz fue aproximada con el error absoluto porcentual")
    elseif dEval == 0 then
        disp(" La raiz encontrada fue exacta")
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
    dXPrev = input(" Ingrese el valor de X previo: ")
    dXAct = input(" Ingrese el valor de X actual: ")
    dErrAbsMeta = input(" Ingrese el valor del error absoluto: ")
    iMaxIter = input(" Ingrese el valor máximo de iteraciones: ")

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
function [dXSig] = IteraX(dXPrev, dXAct)
    // Obtiene los valores de la función evaluada en dX
    dYPrev = FuncionSecante(dXPrev)
    dYAct = FuncionSecante(dXAct)

    // Calcula el siguiente valor de x
    dXSig = dXAct - (dYAct * (dXPrev - dXAct)) / (dYPrev - dYAct)
endfunction


////////////////////////   PROGRAMA PRINCIPAL   ///////////////////////////

function Menu()
    //Inicializar variables
    iOpciones = 0
    while (iOpciones ~= 6)
        disp("Menu de opciones")
        disp("1. Solución de ecuaciones no lineales")
        disp("2. Solución de ecuacines lineales")
        disp("3. Ajuste de curvas")
        disp("4. Interpolación")
        disp("5. Integración")
        disp("6. Salir")
        iOpciones = input("Que opción deseas (1-6) ")
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
            disp("hasta luego ")
        else
            disp("Opción erronea")
        end
        input("Teclea enter para continuar")
    end
endfunction

function EcuacionesNoLineales()
    iOpciones = 0
    while(iOpciones  ~=  6)
        disp("Menu de opciones")
        disp("1. Bisección")
        disp("2. Newton-Rapson")
        disp("3. Secante")
        disp("4. Regula Falsi")
        disp("5. Birge Vieta")
        disp("6. Salir")
        iOpciones = input("Que opción deseas (1-6) ")
    end
endfunction

function EcuacionesLineales()
    iOpciones = 0
    while (iOpciones ~= 6)
        disp("Menu de opciones")
        disp("1. Cramer")
        disp("2. Eliminación Gaussiana")
        disp("3. Gauss-Jordan")
        disp("4. Montante")
        disp("5. Montante")
        disp("6. Salir")
        iOpciones = input("Que opción deseas (1-6) ")
        if (iOpciones == 3) then
            disp("Ingresa la matrix ")
            dmatMatriz = LeeMatriz()
            EliminacionGaussiana(dmatMatriz)
        end
    end
endfunction

function AjusteDeCurvas()
    iOpciones = 0
    while (iOpciones ~= 5)
        disp("Menu de opciones")
        disp("1. Regresión Lineal")
        disp("2. Regresión Exponencial")
        disp("3. Regresión Potencial")
        disp("4. Inversa por Cofactores")
        disp("5. Salir")
        iOpciones = input("Que opción deseas (1-6) ")
    end
endfunction

function Interpolacion()
    iOpciones = 0
    while (iOpciones ~= 3)
        disp("Menu de opciones")
        disp("1. Lagrange")
        disp("2. Diferencias Divididas de Newton")
        disp("3. Salir")
        iOpciones = input("Que opción deseas (1-3) ")
    end
endfunction

function Integracion()
    iOpciones = 0
    while (iOpciones ~= 4)
        disp("Menu de opciones")
        disp("1. Trapecio")
        disp("2. Simpson 1/3")
        disp("3. Newton-Rapson para ecuaciones no lineales")
        disp("4. Salir")
        iOpciones = input("Que opción deseas (1-4) ")

    end

endfunction

Menu()
