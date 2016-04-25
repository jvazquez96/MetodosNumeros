clear
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
