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
//     dMat: Matriz con los datos del usuario
///////////////////////////////////////////////////////////////////////////
function dMat = LeeMatriz()
    // Leer las dimensiones de la matriz
    iRow = input("Ingrese el número de renglones: ")
    iCol = input("Ingrese el número de columnas: ")
    // Para cada renglón
    for iT = 1 : iRow
        // Para cada columna
        for iJ = 1 : iCol
           dMat(iT, iJ) = input("Ingrese el elemento:   (" + string(iT) + ", " + string(iJ) + "):  ")
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




///////////////////////////////////////////////////////////////////////////
// Eliminacion Gaussiana
//
// Método para obtener la solución de un sistema de ecuaciones
// por el metodo de eliminación gaussiana
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//   EliminacionGaussiana()
//
//  Función realiza la eliminación Gaussiana en una matriz recibida.
//  Algoritmo de Eliminación Gaussiana:
//      1. Para i desde 1 hasta renglones - 1
//          1.1 Para k desde i + 1 hasta renglones
//              1.1.1  factor = - M(k, i) / matriz(i, i)
//              1.1.2  Para j desde i hasta columnas
//                  1.1.2.1  M(k, j) = M(k, j) + factor * M(i, j)
//
//  Parametros:
//     dMatrix: La matriz original a ser procesada
///////////////////////////////////////////////////////////////////////////
function dMatrix = EliminacionGaussiana(dMatrix)
    iFactor = 0
    //Tamaño de los renglones
    iRenglones = size(dMatrix,1)
    //Tamaño de las columnas
    iColumnas = size(dMatrix,2)
    for i = 1: iRenglones - 1
        for k = i + 1: iRenglones
            iFactor =  dMatrix(k,i) / dMatrix(i,i)
            disp("Factor: " + string(iFactor))
            for j = i: iColumnas
                dMatrix(k,j) = dMatrix(k,j) - iFactor*dMatrix(i,j)
            end
        end
    end
    // Imprimir la matriz en el estado reducido
    ImprimeMatriz(dMatrix)

    // Encontrar los valores de las incógnitas
    SustituyeHaciaAtras(dMatrix)

endfunction
///////////////////////////////////////////////////////////////////////////
// Método Mondante
//
// Método para obtener la solución de un sistema de ecuaciones
// por el método montante
//
// version 1.0
///////////////////////////////////////////////////////////////////////////

function Montante(dMatValues)
    //Inicializar el pivote anterior
    iPivoteAnterior = 1
    //Numero de renglones
    iRenglones = size(dMatValues,1)
    //Numero de columnas
    iColumnas = size(dMatValues,2)
     
    for i = 1: iRenglones
        for k = 1: iRenglones
            if k ~= i then
                for j = i + 1: iColumnas
                    dMatValues(k,j) = ( dMatValues(i,i) * dMatValues(k,j) - dMatValues(k,i) * dMatValues(i,j)) / iPivoteAnterior
                end
                //Hacer ceros en la columna i excepto en el pivote
                dMatValues(k,i) = 0
            end
        end
        //Actualizar el pivote
        iPivoteAnterior = dMatValues(i,i)
        ImprimeMatriz(dMatValues)
    end
    //Igualar los pivotes anteriores con el ultimo pivote
    for i = 1: iRenglones-1
        dMatValues(i,i) = iPivoteAnterior
    end
    ImprimeMatriz(dMatValues)
    //Dividir cada valor de la ultima columna entre el pivote
    for i = 1: iRenglones
        X(i) = dMatValues(i,iColumnas) / iPivoteAnterior
    end
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
//      dMatValues: La matriz ya procesada con la eliminación de gauss
///////////////////////////////////////////////////////////////////////////
function SustituyeHaciaAtras(dMatValues)
    //Cantidad de renglones
    iRenglones= size(dMatValues,1)

    //Cantida de columnas
    iColumnas = size(dMatValues,2)

    iSuma = 0
    //Obtener la primera solución
    X(iRenglones,1) = dMatValues(iRenglones,iColumnas)/dMatValues(iRenglones,iRenglones)
    // Para cada renglon
    for i = iRenglones - 1: -1:1
        iSuma = 0;
        // Para cada columna
        for j = iColumnas - 1:-1:i+1
            iSuma = iSuma + dMatValues(i,j) * X(j);
        end
      X(i) = (dMatValues(i,iColumnas) - iSuma) / dMatValues(i,i)
    end

    // Despliega el arreglo de las soluciones encontradas
    DespliegaArreglo(X)

endfunction


///////////////////////////////////////////////////////////////////////////
//  DespliegaArreglo()
//
//  Función que despliega los valores de las soluciones encontradas
//  para la matriz inicial
//
//  Parametros:
//     dArr: El arreglo con las soluciones a las incógnitas
///////////////////////////////////////////////////////////////////////////
function DespliegaArreglo(dArr)
    for i = 1: size(dArr,1)
        disp(string(dArr(i,1)))
    end
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
    while (iOpciones ~= 5)
        iOpciones = input("Ingresa la matrix, si deseas salir teclea 5")
        if iOpciones ~= 5 then 
            dmatMatriz = LeeMatriz()
        elseif iOpciones < 5 then
            disp("Menu de opciones")
            disp("1. Cramer")
            disp("2. Eliminación Gaussiana")
            disp("3. Gauss-Jordan")
            disp("4. Montante")
            disp("5. Salir")
            iOpciones = input("Que opción deseas (1-6) ")
            if (iOpciones == 4) then
                Montante(dmatMatriz)
            elseif (iOpciones == 3) then
                EliminacionGaussiana(dmatMatriz)
                end
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
