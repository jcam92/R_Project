## ____________________________________
##
## Nombre del script: LOESS.r
##
## Propósito del script: Evaluar el uso de LOESS.
##
## Requisitos previos:
## 
## 
##
## Parámetros de la función:
##
## 
## Resultados:
##
## Códigos de retorno: NA
##
## Autor: BIDDSA
## Fecha de creación: 2023-09-11
## Derechos de autor: (c) BIDDSA, 2023
## Correo electrónico: <email>@BIDDSA.com
##________________________________________________________________________
##> Notas:
##> 
##> 
##________________________________________________________________________
## HISTORIA DE MODIFICACIÓN
## 06AGO2023 persona0
## Cambios: Versión inicial.
##
## 06AGO2023 persona1
## Cambios: - Cambios xxx
##
## 07AGO2023 persona2
## Cambios: - Se eliminó xxx
##
##________________________________________________________________________

# install.packages()
# Bibliotecas ----
library(tidyverse)
library(lubridate)
library(stringr)
library(fs)
library(scales)

# Establecer semilla para reproducibilidad ----
set.seed(123)

# Crear Datos ----
x <- seq(1, 200, by = 1)
y <- sin(x/10) + rnorm(200, 0, 0.5)

smoothed_data <- lowess(x, y,)

# Graficar ----
ggplot(mapping = aes(x = x, y = y)) +
  geom_point(color = "blue") +
  geom_line(mapping = aes( y = smoothed_data$y), color = "red") +
  labs(title = "LOESS",
       subtitle = "Ejemplo de suavizado de datos",
       x = "x",
       y = "y") +
  theme_minimal()


# Generar tres modelos con diferentes spans ----
# Entre mas bajo el span mas alta la posibilidad de overfitting
# Crodd validation para encontrtar el mejor span

model1 <- loess(y ~ x, span = 0.2)
model2 <- loess(y ~ x, span = 0.5)
model3 <- loess(y ~ x, span = 0.8)

# Grafico de comparasion de modelos -----
FP <- ggplot(mapping = aes(x = x, y = y)) +
  geom_point(color = "blue") +
  geom_line(mapping = aes(y = predict(model1)), color = "red") +
  geom_line(mapping = aes(y = predict(model2)), color = "green") +
  geom_line(mapping = aes(y = predict(model3)), color = "purple") +
  labs(title = "LOESS",
       subtitle = "Comparación de modelos con diferentes spans",
       x = "x",
       y = "y") +
  theme_minimal()

library(plotly)
FP |> ggplotly()














