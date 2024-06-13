# -*- coding: utf-8 -*-
"""
Created on Wed Jun 12 16:38:04 2024

@author: roslira
"""

import tkinter as tk
from tkinter import messagebox
import numpy as np

# Función para calcular el precio
def calcular_precio():
    try:
        # Recolección de datos desde los campos de entrada
        host_listings_count = float(entry_host_listings_count.get())
        latitude = float(entry_latitude.get())
        longitude = float(entry_longitude.get())
        accommodates = float(entry_accommodates.get())
        availability_365 = float(entry_availability_365.get())
        review_scores_cleanliness = float(entry_review_scores_cleanliness.get())
        review_scores_location = float(entry_review_scores_location.get())

        # Coeficientes del modelo
        intercepto = -225.8
        lista_coef = np.array([0.09588, 8.513, -21.02, 0.4465, 0.0009943, 1.467, 2.709])
        datos = np.array([
            host_listings_count,
            latitude,
            longitude,
            accommodates,
            availability_365,
            review_scores_cleanliness,
            review_scores_location
        ])
        
        # Cálculo del precio
        prod1 = lista_coef * datos
        sum_final = intercepto + float(sum(prod1))
        
        # Asegurarse de que el precio no sea negativo
        if sum_final < 0:
            sum_final = 0
        
        # Despliegue del resultado
        messagebox.showinfo("Resultado", f"El precio del AIRBNB de acuerdo a los datos proporcionados es: ${sum_final:.2f} MXN")
    
    except ValueError:
        messagebox.showerror("Error", "Por favor, ingrese valores numéricos válidos.")

# Configuración de la ventana principal
root = tk.Tk()
root.title("Calculadora de Precios de Airbnb")
root.geometry("500x500")
root.configure(bg='#D8BFD8')  # Color lila

# Creación de etiquetas y campos de entrada
labels = [
    "Núm. total de listados del host",
    "Latitud",
    "Longitud",
    "Capacidad de alojamiento",
    "Disponibilidad en 365 días",
    "Calificación de limpieza según reseñas",
    "Calificación de ubicación según reseñas"
]

entries = []

for label in labels:
    frame = tk.Frame(root, bg='#D8BFD8')
    frame.pack(pady=5, padx=10, fill=tk.X)
    
    lbl = tk.Label(frame, text=label, bg='#D8BFD8')
    lbl.pack(side=tk.LEFT, padx=5)
    
    entry = tk.Entry(frame)
    entry.pack(side=tk.RIGHT, padx=5)
    
    entries.append(entry)

(entry_host_listings_count, entry_latitude, entry_longitude, entry_accommodates, 
 entry_availability_365, entry_review_scores_cleanliness, entry_review_scores_location) = entries

# Botón para calcular el precio
btn_calcular = tk.Button(root, text="Calcular Precio", command=calcular_precio, bg='#E6E6FA')
btn_calcular.pack(pady=20)

# Iniciar el loop de la interfaz gráfica
root.mainloop()
