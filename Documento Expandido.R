#Receta para un buen modelo de regresión lineal múltiple (Airbnb)

library(corrplot)
library(MASS)
library(dplyr)
library(readxl)
library(nortest)
library(ggplot2)
excel <- "C:\\Users\\alex\\Downloads\\Datos_modelos.xlsx"
datos <- read_excel(excel, sheet = "Datos")
datos <- na.omit(datos)

"Nuestra base de datos original contiene a la variable ID pues nos
servirá más adelante en el análisis de los datos, sin embargo por ahora
podemos ignorarla para esta primera parte"

datos <- datos %>% 
  dplyr::select(-id)

#Paso 1. CORRELACIONES

"
Lista de variables original:
[1] host_listings_count                        
[2] host_total_listings_count                  
[3] latitude                                  
[4] longitude                                  
[5] accommodates                                
[6] bedrooms                                    
[7] beds                                        
[8] price*                                      
[9] minimum_nights                              
[10] maximum_nights                              
[11] availability_365                            
[12] number_of_reviews                           
[13] review_scores_rating                        
[14] review_scores_accuracy                      
[15] review_scores_cleanliness                   
[16] review_scores_checkin                   
[17] review_scores_communication                 
[18] review_scores_location                      
[19] review_scores_value                         
[20] calculated_host_listings_count              
[21] calculated_host_listings_count_entire_homes 
[22] calculated_host_listings_count_private_rooms
[23] calculated_host_listings_count_shared_rooms 
[24] reviews_per_month                           
[25] availability_30                             
[26] availability_60                             
[27] availability_90                           
[28] number_of_reviews_ltm                       
[29] number_of_reviews_l30d                     
[30] banios
"

"
Posibles correlaciones:
*- 1 y 2
Se puede llegar a dar pues ambas variables parametran datos
muy similares

*- 3 y 4
Se puede llegar a dar pues ambas tienen datos relativos a la ubicación del
Airbnb

*- 5, 6 y 7
Puede llegar a darse pues las tres variavles hacen alusión a la cantidad
de huéspedes que puede alergar el Airbnb

*- 6 y 30
Podría llegar a darse pues, en una mala tipificación de las habitaciones
los baños podrían haber sido tomados como tales, o tal vez porque las 
habitaciones tengan un baño integrado

*- 5, 6, 7 y 30
Igual que el motivo anterior, una mala tipificación de los datos
podría hacer que estas variables estén relacionadas

*- 9, 10, 11, 25, 26 y 27
Podrían llegar a estar relacionadas pues, mientras mayor o menor sea el
número de noches que alguien se hospede en el Airbnb menor o mayor será
la cantidad de días que estuvo disponible.
Además son las disponibilidades acumuladas en ciertos periodos de tiempo,
siendo el más alto de un año, por lo que si descubrimos correlación podríamos
quedarnos con el de periodicidad más grande

*- 12 - 19
Pues todas estas variables hacen alusión a las reviews del Airbnb

*- 3, 4 y 18
Pues las tres variables están relacionadas con la ubicación del Airbnb

*- 6, 7, 15 y 30
Pues la limpieza del Airbnb es notoria en las recámaras, las camas 
y los baños

*- 1, 2, 20, 21, 22, 23
Pues son estadísticas del hospedador de cada Airbnb

*- 12, 24, 28, 29
Pues hace alusión al número de Reviews que el Airbnb ha tenido a lo
largo de diferentes periodos de tiempo
"


#PComprobación de las correlaciones

"Primero haremos un gráfico general para ver si nuestras ideas son correctas"

corrplot(cor(datos), method = "number", tl.cex = .2)

"Podemos ver que en general hicimos una buena deducción, sin embargo debido
a la escala del gráfico no se alcanzan a apreciar de buena manera las
correlaciones, por lo que hemos de verlas más de cerca para verificar si 
nuestras suposiciones son realmente correctas. Para ello haremos un gráfico 
por cada suposición y si las variables presentan coeficientes de correlación
muy altos (de .8 en adelante) serán eliminadas"

attach(datos)

#CORRELACIÓN 1. (1 y 2)

nuevo_df <- data.frame(host_listings_count = host_listings_count, 
                       host_total_listings_count = host_total_listings_count)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Podemos ver que si están sumamente correlacionadas, por lo que eliminaremos 
a la variable host_listings_count pues consideramos que la otra nos puede
dar mejores datos debido a que representan al total de los mismos

Se eliminan las variables:
-host_listings_count"

#CORRELACIÓN 2. (3 y 4)

nuevo_df <- data.frame(latitude = latitude, 
                       longitude = longitude)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Como podemos ver estas variables están levemente correlacionadas, por lo
que ambas se quedarán en el modelo"

#CORRELACIÓN 3. (5, 6 y 7)

nuevo_df <- data.frame(accommodates = accommodates, 
                       bedrooms = bedrooms,
                       beds = beds)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Podemos ver que las tres variables están correlacionads entre sí, siendo
la de camas la que tiene una correlación más fuerte con las otras dos, por
lo que al ser reiterativa se eliminará del modelo

Se eliminan las variables:
-beds"

#CORRELACIÓN 4. (6 y 30)

nuevo_df <- data.frame(bedrooms = bedrooms, 
                       banios = banios)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Ambas variables estan algo correlacionadas, pero no lo suficiente como para
eliminar a alguna de ellas"

#CORRELACIÓN 5. (5, 6, 7 y 30)

nuevo_df <- data.frame(accommodates = accommodates, 
                       bedrooms = bedrooms,
                       beds = beds,
                       banios = banios)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"La variable baños aunque esté algo correlacionada con las demás, debido a 
que su correlación no es tan significativa no se eliminará, eliminando
únicamente la de camas por lo anterior expuesto

Se eliminan las variables:
-beds"

#CORRELACIÓN 6. (9, 10, 11, 25, 26 y 27)

nuevo_df <- data.frame(minimum_nights = minimum_nights, 
                       maximum_nights = maximum_nights,
                       availability_365 = availability_365,
                       availability_30 = availability_30,
                       availability_60 = availability_60,
                       availability_90 = availability_90)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Podemos ver que las cuatro variables de availability se hayan correlacionadas
siendo las de availability_30, availability_60 y availability_90 las más
fuertemente correlacionadas, por lo que las tres se dejarán de lado, 
dejando únicamente la variable de availability_365, pues es la que menos
correlacionada está con las demás
Como añadido es levemente perceptible una realación inversa entre las variables
de máximo y mínimo de noches con las de availability lo que nos dice que 
nuestra suposición anterior era correcta pero al ser casi imperceptible será 
ignorada

Se eliminan las variables:
-availability_30
-availability_60
-availability_90"

#CORRELACIÓN 7. (12 - 19)

nuevo_df <- data.frame(number_of_reviews = number_of_reviews, 
                       review_scores_rating = review_scores_rating,
                       review_scores_accuracy = review_scores_accuracy,
                       review_scores_cleanliness = review_scores_cleanliness,
                       review_scores_checkin = review_scores_checkin,
                       review_scores_communication = review_scores_communication,
                       review_scores_location = review_scores_location,
                       review_scores_value = review_scores_value)
corrplot(cor(nuevo_df), method = "number",tl.cex = .53)

"Es posible apreciar una muy fuerte correlación entre las variables de 
review_scores_rating, review_scores_accuracy, review_scores_communication y
review_scores_value, mientras que el resto de variables si bien están
correlacionadas entre sí (salvo la variable number_of_reviews) no tienen 
correlaciones muy significativas, por lo que se eliminarán solamente las 
mencionadas al inicio

Se eliminan las variables:
-review_scores_rating
-review_scores_accuracy
-review_scores_communication
-review_scores_value"

#CORRELACIÓN 8. (3, 4 y 18)

nuevo_df <- data.frame(latitude = latitude, 
                       longitude = longitude,
                       review_scores_location = review_scores_location)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Ninguna de estas variables está correlacionada de manera significativa
por lo que no se eliminará ninguna de ellas.
Como extra podemos ver que la longitud guarda una realción inversa con
la variable de review_scores_location, indicando que mientras más al 
Este de la ciudad vayamos, la calificación de su locación será menor. "

#CORRELACIÓN 9. (6, 7, 15 y 30)

nuevo_df <- data.frame(bedrooms = bedrooms, 
                       beds = beds,
                       review_scores_cleanliness = review_scores_cleanliness,
                       banios = banios)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Una vez más podemos ver que la variable de camas es la única fuertemente
correlacionada, por lo que una vez más se confirma que debe ser eliminada
Sin embargo, resulta interesante que la calificación de limpieza no esté
prácticamente relacionada ni con las camas, ni con los baños ni con las
recámaras

Se eliminan las variables:
-beds"

#CORRELACIÓN 10. (1, 2, 20, 21, 22, 23)

nuevo_df <- data.frame(host_listings_count = host_listings_count, 
                       host_total_listings_count = host_total_listings_count,
                       calculated_host_listings_count = calculated_host_listings_count,
                       calculated_host_listings_count_entire_homes = calculated_host_listings_count_entire_homes,
                       calculated_host_listings_count_private_rooms = calculated_host_listings_count_private_rooms,
                       calculated_host_listings_count_shared_rooms = calculated_host_listings_count_shared_rooms)
corrplot(cor(nuevo_df), method = "number",tl.cex = .5)

"Podemos ver que las variables host_listings_count, calculated_host_listings_count
calculated_host_listings_count_entire_homes y host_total_listings_count están 
fuertemente relacionadas, por lo que nos quedaremos únicamente con esta última.
Respecto al resto de variables que no son las anteriormente mencionadas no se
realizarán cambios pues casi no están relacionadas entre sí

Se eliminan las variables:
-host_listings_count
-calculated_host_listings_count
-calculated_host_listings_count_entire_homes"


#CORRELACIÓN 11. (12, 24, 28, 29)

nuevo_df <- data.frame(number_of_reviews = number_of_reviews, 
                       reviews_per_month = reviews_per_month,
                       number_of_reviews_ltm = number_of_reviews_ltm,
                       number_of_reviews_l30d = number_of_reviews_l30d)
corrplot(cor(nuevo_df), method = "number",tl.cex = .9)

"Podemos ver que las variables estám correlacionadas entre sí, sin 
embargo las que están más fuertemente correlacionadas son solo las de 
reviews_per_month y number_of_reviews_ltm, por lo que eliminaremos aquella
que esté más correlacionada con las demás, siendo esta la de 
number_of_reviews_ltm

Se eliminan las variables:
-number_of_reviews_ltm"

"
Así pues, tras realizar nuestro análisis tenemos que se eliminarán las
siguientes variables:
-host_listings_count
-beds
-availability_30
-availability_60
-availability_90
-review_scores_rating
-review_scores_accuracy
-review_scores_communication
-review_scores_value
-calculated_host_listings_count
-calculated_host_listings_count_entire_homes
-number_of_reviews_ltm

Por lo que nuestra base de datos quedará así:
"
datos <- datos %>% 
  dplyr::select(-host_listings_count,
                -beds,
                -availability_30,
                -availability_60,
                -availability_90,
                -review_scores_rating,
                -review_scores_accuracy,
                -review_scores_communication,
                -review_scores_value,
                -calculated_host_listings_count,
                -calculated_host_listings_count_entire_homes,
                -number_of_reviews_ltm)

"Finalmente, tras habernos quedado con únicamente con las 18 variables 
más significativas del modelo volveremos a ejecutar un gráfico de correlaciones
general para ver si nuestra eliminación fue correcta"

corrplot(cor(datos), method = "number", tl.cex = .1)

"Podemos ver que, aunque aún se perciben ciertas correlaciones, las cantidad
que hay de ellas es mucho menor a la original y son mucho menos fuertes, lo
que nos indica que procedimos de manera correcta, por lo que podemos pasar
al siguiente paso"

