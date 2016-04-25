clear
function Menu()
    //Inicializar variables
    iOpciones = 0
    while (iOpciones ~= 7)
        disp("Menu de opciones")
        disp("1. Solución de ecuaciones no lineas")
        disp("2. Solución de ecuacines lineales")
        disp("3. Ajuste de curvas")
        disp("4. Interpolación")
        disp("5. Integración")
        disp("6. Integración para ecuaciones no lineales")
        disp("7. Salir")
        iOpciones = input("Que opción deseas (1-7)") 
    end
endfunction

Menu()
