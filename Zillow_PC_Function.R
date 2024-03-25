

# Paquetes 
library(readxl)
library(tidyverse) 
library(lubridate)
library(fs)





getTopCitiesByCAGR <- function(Y1, Y2, show_rows){
    
    source("06_funciones_y_interacion_iteration/funcioines_script_de_importacion_de_datos.R")
    
# Importacion de Datos    
    ZMI_Data_Prep <- data_import(dataSource = "ZMI_Data_Prep")

# Data prep

    CAGR <- ZMI_Data_Prep |> 
        filter(Year %in% c(Y1,Y2)) |>
        group_by(City_zip) |>
        mutate(Beginning_Value = Z_Home_Value_Index[Year == Y1], 
               Ending_Value = Z_Home_Value_Index [Year == Y2]) |>
        ungroup () |>
        select(City_zip, Beginning_Value, Ending_Value) |>
        mutate(timeperiod = str_c(Y1,Y2, sep = "-")) |>
        distinct()
   
# Calculando CAGR
# CAGR se establece para ser calculado en base en Y1 y Y2
    
    CAGR <- CAGR |>
        mutate(Number_of_Years = Y2-Y1, 
               CAGR            =   ((Ending_Value/Beginning_Value)^(1/ Number_of_Years))-1) |>
        arrange(desc(CAGR))

#Top Cities
    
    if (show_rows == "all") {
        
        show_rows <- CAGR |> nrow()
        CAGR <- CAGR[1:show_rows, ]
        return(CAGR)
        
        
    }
    
    n <- CAGR |> nrow()
    
    if (is.numeric(show_rows) == TRUE & show_rows < n+1 ) {
        
        CAGR <- CAGR[1:show_rows, ]
        return(CAGR)
    } else
        
        print("Enter a 'numeric value' between 1 and {n} or type 'all' ")
    
         
}


# getTopCitiesByCAGR(Y1 = 2000, Y2 = 2019, show_rows = "all")

