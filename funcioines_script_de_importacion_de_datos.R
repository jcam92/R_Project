
# Paquetes 
library(readxl)
library(tidyverse) 
library(lubridate)
library(fs)



data_import <- function(dataSource){
    
    
# Employment
    if (dataSource == "Employment"){
        Employment <- read_excel(path = "01_Informacion_Data/Bureau_Labor_of_Statistics_Data/Detroit_Warren_Dearborn.xlsx",
                                 sheet="BLS Data Series",
                                 skip=10)
        return(Employment)
        
    }

# Zillow    
    if (dataSource == "Zillow"){
        
        Zillow <- read.csv(file = "01_Informacion_Data/Zillow/Zip_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv") 
        
        return(Zillow)
     }
    
     
# Land_Area
     if (dataSource == "Land_Area"){
         
         Land_Area <- read_excel(path = "01_Informacion_Data/Land_Area/LandArea.xlsx")
         
         return(Land_Area)
         
     }
    
    
# pop_data
     if (dataSource == "pop_data"){
         
         pop_data <- read_rds(file = "01_Informacion_Data/US_Census_Bureau/pop_data.rds")
         
         return(pop_data)
         
     }
# crime_rate
    if (dataSource == "crime_rate"){
        
        crime_rate <- read_rds("01_Informacion_Data/Crime_Rates_by_ZipCodes/crime_rating_by_zip(1).R")
        
        return(crime_rate)

    }        
# demographics
    if (dataSource == "demographics"){
            
        demographics <- read_rds("01_Informacion_Data/Crime_Rates_by_ZipCodes/Zip_Income_and_Poerverty(1).R")

        return(demographics)       
     
    }

# ZMI_Data_Prep  
    if (dataSource == "ZMI_Data_Prep"){
        
        ZMI_Data_Prep <- read_rds("01_Informacion_Data/Bureau_Labor_of_Statistics_Data/ZMI_Data_Prep.rds")
        
        return(ZMI_Data_Prep)  
    }
# Employment_C
    if (dataSource == "Employment_C"){
            
        Employment_C <- read_rds("01_Informacion_Data/Zillow/Employment_C.rds")
            
        return(Employment_C)  
    }        
# DisplayData
    if (dataSource == "DisplayData") {
        DisplayData <- c("Employment_C", "ZMI_Data_Prep","demographics","crime_rate","pop_data","Land_Area", "Zillow","Employment")
        return(DisplayData)
    }
           
        
}
    
data_import(dataSource = "demographics")
    
     



    



