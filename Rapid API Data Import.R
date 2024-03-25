 
library(httr)
library(jsonlite)
library(tidyverse)
library(fs)
library(rvest)
library(xml2)
library(readxl)


# Para importar conjuntos de datos como "Employment", "Zillow", "Population" y "LandArea." 
source("06_funciones_y_interacion_iteration/funcioines_script_de_importacion_de_datos.R")

Zillow <- data_import(dataSource="Zillow") 

zip_codes <- Zillow %>% 
    filter(StateName=="MI" & Metro == "Detroit-Warren-Dearborn, MI") %>%
    distinct(RegionName) %>% 
    pull(RegionName)
    

crime_data <- read_rds(file = "01_Informacion_Data/Crime_Rates_by_ZipCodes/crime_rating_by_zip.R") 
crime_zip  <- crime_data %>% 
    distinct(Zipcode) %>% 
    pull(Zipcode) %>%
    as.character()    
    
DWD_MI_Zip <- as.character(zip_codes)

identical(DWD_MI_Zip,crime_zip)

DWD_MI_Zip[!DWD_MI_Zip %in% crime_zip]
crime_zip[!crime_zip %in% DWD_MI_Zip]

missing_zip_codesDWD_MI <- setdiff(crime_zip,DWD_MI_Zip)
missing_zip_codescrime_zip <- setdiff(DWD_MI_Zip,crime_zip)


url <- "https://crime-data-by-zipcode-api.p.rapidapi.com/crime_data"
API_Key <- "ede790b8b6msh75ec256677a7d29p15b1dfjsn2b2539f74d38"
API_Host <- "crime-data-by-zipcode-api.p.rapidapi.com"
request_delay <- 2 # Definir el retardo entre las solicitudes (en segundos)


data_import_API <- function(url, API_Key, API_Host, request_delay){
    data_df <- tibble()
    
    for (i in seq_along(missing_zip_codescrime_zip)) {
        
        query_params <- list(zip = missing_zip_codescrime_zip[i])
        
        response <- GET(url, add_headers("X-RapidAPI-Key" = API_Key, "X-RapidAPI-Host" = API_Host),
                        query = query_params)
        
        warn_for_status(response)
        
        cont_response <- fromJSON(rawToChar(response$content))
        
        data_df <- bind_rows(data_df, as_tibble(cont_response))
        
        print(str_glue("Zip Code: {missing_zip_codescrime_zip[i]}"))
        
        Sys.sleep(request_delay)
        
    }
    colnames(data_df) <- c("Overall","Crime BreakDown","Crime Rates Nearby", "Similar Population Crime Rates","success","status code" )
return(data_df)
}

data_import_API(url = url, API_Key = API_Key, API_Host = API_Host, request_delay = request_delay)

# cont_response %>% names()
# [1] "Overall"                        "Crime BreakDown"                "Crime Rates Nearby"            
# [4] "Similar Population Crime Rates" "success"                        "status code"
