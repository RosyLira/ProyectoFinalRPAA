
# ----------------MENSAJE DE BIENVENIDA----------------
print(""" 
¡Hola! Sea bienvenido a este cotizador de precios de AIRBNB.
A continuación, se te pedirá que introduzcas una serie de datos con los cuales se podrá llevar a cabo tu cotización.

IMPORTANTE: No puedes dejar en blanco ninguna de las entradas de información, pues en dicho caso,
no se podrá llevar a cabo la valuación. La calculadora está diseñada para admitir únicamente números,
tanto positivos como negativos. 

En caso de no tener conocimiento acerca de la información que se pide, 
coloca el valor de 1 en la entrada correspondiente y presiona la tecla enter para pasar al dato siguiente.

Antes de cotizar el precio de tu Airbnb es importante tomar en cuenta los siguientes puntos:
1) El cotizador no admite valores negativos a excepción de la parte sobre Latitud y Longitud.
2) En caso de que hayas escrito un número negativo, se desplegará un mensaje pidiendo que ingreses
   un nuevo dato.
3) El Nivel y Calificación se consideran en un rango de entre 0-5, donde 0 corresponde al nivel/calificación más baja 
   y 5 corresponde al nivel/calificación más alta.
""")

# Importamos la paquetería que nos ayudará a crear nuestros vectores de información.
# Así mismo, importamos la paquetería math para hacer uso de operadores que no se encuentran por default en Python.
import numpy as np
import math 

# Creamos nuestro vector de nombres, los cuales indicarán en cada celda de entrada de información, el valor que se pide.
t_dato = [
    "Núm. Personas que desean hospedarse", 
    "Núm. Baños en el Airbnb", 
    "Núm. Cuartos Privados en el Airbnb",
    "Núm. de días disponibles en los 365 días del año",
    "Nivel de limpieza con base en las reseñas",
    "Calificación del Airbnb con base en las reseñas", 
    "Núm. Total de Airbnb registrados por el host"
]

# Declaramos una lista que contiene los coeficientes calculados mediante la regresión lineal.
intercepto = -225.8

lista_coef = [0.4465, 21.02, -8.513, 0.0009943, 1.467, 2.709, 0.09588]
lista_coef = np.array(lista_coef) # Convertimos la lista anterior en un vector para realizar operaciones.

n = len(t_dato)
datos = np.empty(n, dtype=object)  # Creamos un vector vacío que llenaremos con los datos proporcionados por el usuario.

# --------ALMACENAMIENTO DE LA INFORMACIÓN-------------- #

# Creamos un ciclo for para almacenar la información proporcionada por el usuario.
for i in range(n):
    while True:
        try:
            info = float(input(f"Ingrese el dato respecto a {t_dato[i]}: "))
            if info >= 0:
                datos[i] = info
                break
            else:
                print("Este valor es incorrecto, introduce otro nuevamente")
        except ValueError:
            print("Por favor, introduce un número válido.")

# --------ALMACENAMIENTO DE LA INFO SOBRE "LATITUD" Y "LONGITUD"--------- #

# Como la latitud y longitud pueden ser valores tanto positivos como negativos, los dejamos al final para darles un tratamiento distinto. 
while True:
    try:
        lati = float(input("Ingrese el dato respecto a Latitud: "))
        long = float(input("Ingrese el dato respecto a Longitud: "))
        break
    except ValueError:
        print("Por favor, introduce un número válido.")

# Coeficientes relacionados a la latitud y longitud.
coef = [8.513, -21.02]
coef = np.array(coef)

# Almacenamos la información del usuario en una lista y la convertimos en un vector para operar con ella.
datos_esp = [lati, long]
datos_esp = np.array(datos_esp)

# ------------PRECIO DEL AIRBNB-------------------#

# Realizamos las operaciones correspondientes para determinar el precio del AIRBNB.
prod1 = lista_coef * datos
suma1 = float(sum(prod1))

prod2 = coef * datos_esp
suma2 = float(sum(prod2))

sum_final = intercepto + suma1 + suma2
print(f"El precio del AIRBNB de acuerdo a los datos proporcionados es: {sum_final}")
