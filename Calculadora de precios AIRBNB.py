## ----------------MENSAJE DE BIENVENIDA---------------#

print(""" ¡ Hola que tal ! Sea bienvenido a este tu cotizador de precios de AIRBNB, a continuación \n
se te pedira que introduzcas una serie de datos con los cuales se podrá llevar a cabo tu cotización.

IMPORTANTE: Toma en cuenta que no puedes dejar en blanco nunguna de las entradas de información pues, en dicho caso,\n
no se podrá llevar a cabo la valuación, además que la calculadora esta diseñada para admitir únicamente números tanto \n
positivos como negativos, esto último se especifíca más adelante. 

En caso de no tener conocimiento acerca de la información que se pide, \n
coloca el valor de 1 en la entrada correspondiente y presiona la tecla enter para pasar al dato siguiente.

Antes de cotizar el precio de tu Airbnb es  importante tomar en cuenta los siguientes puntos:

1) El cotizador no admite valores negativos a excepción de la parte sobre Latitud y Longitud
2) En caso de que hayas escrito un número negativo, se despliega un enunciado pidiendo que ingreses\n
un nuevo dato. 
3) El Nivel y Calificación se consideran en un rango de entre 0-5, donde 0 corresponde al nivel/calificación más baja \n
y 5 corresponde al nivel/calificación más alta.

""")

# Importamos la paquetería que nos ayudara a crear nuestros vectores de información. 
# Así mismo importamos la paquetería math para hacer uso de operadores que no se encuentran por default en Python
import numpy as np
import math 
# Creamos nuestro vector de nombres, los cuales indicaran en cada celda de entrada de información, el valor que se pide.

t_dato=["Núm. Personas que desean hospedarse", "Núm. Baños en el Airbnb", "Núm. Cuartos Privados en el Airbnb",
       "Núm. de días disponibles en los 365 días del año","Nivel de limpieza con base en las reseñas",
       "Califiación del Airbnb con base en las reseñas", "Núm. Total de Airbnb registrados por el host" ]


# Declaramos una lista que contenga los coeficientes calculados mediante la regersión lineal.

# Es importante notar que no se considera por el momento a los coeficientes relacionados con 
# las variables "Latitud" y "Longitud", esto debido a que pueden ser número negativos, de manera que será 
# conveniente agregarlas al final. 

# Es importante notar a nuestra variable intercepto, o bien, nuestra ordenada al origen.
intercepto = -0.002258


lista_coef=[0.4465,0.7028,-1.114,0.0009943,1.467,2.709,0.09588]

lista_coef=np.array(lista_coef) # Convertimos la lista anterior en un vector con los que podamos realizar operaciones

n=len(t_dato)

datos = np.empty(n, dtype=object)  # Creamos un vector vacio que llenaremos con los datos proporcionados por el usuario

# --------ALMACENAMIENTO DE LA INFORMACIÓN-------------- #

# Creamos un ciclo for para almacenar la información proporcionada por el usuario.


for i in range(n):

    info = float(input("Ingrese el dato respecto a {}: ".format(t_dato[i]))) 
    if info >=0:
        datos[i]=info
    
    elif info < 0:
        print("Este valor es incorrecto, introduce otro nuevamente")
        info = float(input("Ingrese el dato respecto a {}: ".format(t_dato[i])))

# ---------ALMACENAMIENTO DE LA INFO SOBRE "lATITUD" Y "lONGITUD"--------- #

# Como la latitud y longitud pueden ser valores tanto positivos como negativos, los dejamos al final para darles un tratamiento
# distinto. 

# Pedimos al usuario que introduzca los datos respecto a la información solicitada.
lati = float(input("Ingrese el dato respecto Latitud: "))
long= float(input("Ingrese el dato respecto Longitud: "))

#coeficientes relacionados a la latitud y longitud

# Nuevamente los alamacenamos en una lista para posteriormente hacerlos un vector y poder operar con ellos.
coef=[8.513,-0.2102]
coef=np.array(coef)


# Almacenamos la información del usuario en una lista y la volvemos vector para operar con ella. 
datos_esp = [lati,long]
datos_esp = np.array(datos_esp)

# ------------PRECIO DEL AIRBNB-------------------#

# Realizamos las operaciones correspondientes para determinar el precio del AIRBNB.

prod1 = lista_coef*datos
suma1 = float(sum(prod1))

prod2 = coef*datos_esp
suma2 = float(sum(prod2))

sum_final = intercepto + suma1 + suma2
print(f"El precio del AIRBNB de acuerdo a los datos proporcionados es: {sum_final}")