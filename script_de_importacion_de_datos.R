
# Paquetes 
library(readxl)
library(tidyverse) 
library(lubridate)
library(fs)

    
# Employment ----
# https://www.bls.gov/eag/

Employment <- read_excel(path = "01_Informacion_Data/Bureau_Labor_of_Statistics_Data/Detroit_Warren_Dearborn.xlsx",
                         sheet="BLS Data Series",
                         skip=10)
    
# Zillow ----
# https://www.zillow.com/research/data/
  
Zillow <- read.csv(file = "01_Informacion_Data/Zillow/Zip_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv")   
     
# Land Area ----
# formato .lpk 
# https://www.arcgis.com/home/item.html?id=8d2012a2016e484dafaac0451f9aea24#!

Land_Area <- read_excel(path = "01_Informacion_Data/Land_Area/LandArea.xlsx")

# Population ----
## Zip files ----
# https://data.census.gov/table?t=Populations+and+People&g=040XX00US26$8600000&y=2020&tid=ACSDP5Y2020.DP05
  
# my_dir <- "01_Informacion_Data/US_Census_Bureau/"
# 
# zip_files <- list.files(path = my_dir, pattern = "*.zip", full.names = TRUE)
# 
# unzip_files <- zip_files %>% map(.f = unzip, exdir = my_dir ) 
# 
# data_files <- list.files(path = my_dir, pattern = "*.csv", full.names = TRUE)
# text_files <- list.files(path = my_dir, pattern = "*.txt", full.names = TRUE) 
# 
# 
# pop_data <-  map(.x = data_files, .f = read.csv, skip = 1, header = TRUE)
# 
# for (i in 1:length(pop_data)) {
#   pop_data[[i]]$Year <- 2010 + i 
#   
# }
# 
# pop_data <- map_dfr(.x = pop_data, .f = pluck)
# 
# pop_data <- pop_data %>% select(starts_with(match = "Geographic"),
#                                 starts_with(match = "Estimate"),
#                                 Year)
# 
# pop_data <-  pop_data %>% select(Geographic.Area.Name,Estimate..SEX.AND.AGE..Total.population, Year)
# 
# 
# file_delete(data_files)
# file_delete(text_files)
# 
# write_excel_csv(x = pop_data, file = "01_Informacion_Data/US_Census_Bureau/pop_data.xlsx")
# write_rds(x = pop_data, file = "01_Informacion_Data/US_Census_Bureau/pop_data.rds")

pop_data <- read_rds("01_Informacion_Data/US_Census_Bureau/pop_data.rds")

