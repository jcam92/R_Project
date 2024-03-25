
# install.packages()
# Cargar las bibliotecas necesarias
library(readxl)
library(tidyverse)
library(naniar)
library(lubridate)
library(stringr)
library(fs)
library(scales)
library(FinancialMath)

# Para importar conjuntos de datos como "Employment", "Zillow", "Population" y "LandArea" 
source("06_funciones_y_interacion_iteration/funcioines_script_de_importacion_de_datos.R")

Zillow <- data_import(dataSource = "Zillow")

Zillow_MI <- Zillow |>
    filter(StateName == "MI" & Metro =="Detroit-Warren-Dearborn, MI")

miss_val_Zillow <- Zillow_MI %>% miss_case_summary()

Zillow_MI <- Zillow_MI %>% 
    mutate(id=1:nrow(Zillow_MI))%>%
    select(id, everything())

Zillow_MI <- left_join(Zillow_MI, 
          miss_val_Zillow, by = c("id"="case"))
Zillow_MI <- Zillow_MI %>% filter(n_miss==0)

Zillow_MI %>% miss_case_summary()

# Zillow_MI |> gg_miss_var()

ZMI_Data_Prep <- Zillow_MI |> tibble() |>
    gather(key="Date", value = "Z_Home_Value_Index",X2023.08.31:X2000.01.31) |>
    mutate(City_zip = str_glue("{City}_{RegionName}")) |>
    select(Date, City_zip, Z_Home_Value_Index, RegionName) |>
    mutate(Date_chr= Date |> str_replace_all(pattern = "X", replacement = "")) |>
    mutate(Date_chr=Date_chr|> str_c(" 00:00:00")) |>
    mutate(Date_chr = Date_chr |> ymd_hms(tz="UTC")) |>
    mutate(Year = Date_chr|> year()) |>
    select(Year, City_zip, Z_Home_Value_Index, RegionName) |>
    group_by(City_zip, Year, RegionName) |>
        summarize(Z_Home_Value_Index=Z_Home_Value_Index  |> mean()) |>
        ungroup() |>
        mutate(ZHVI_lagl = lag(Z_Home_Value_Index, n = 1)) |>
    mutate(ZHVI_lagl= case_when(
        
        Year== 2000 ~ Z_Home_Value_Index,
        TRUE ~ ZHVI_lagl
        
    )) |> 
    mutate(ZHVI_diff = Z_Home_Value_Index - ZHVI_lagl) |>
    mutate(ZHVI_PC_YoY = ZHVI_diff/ZHVI_lagl) |>
    mutate(ZHVI_PC_YoY_chr = ZHVI_PC_YoY |> scales::percent(accuracy = 0.01))

AAR <- ZMI_Data_Prep |>
    group_by(City_zip) |>
    summarise(AAR = ZHVI_PC_YoY %>% sum()) |>
    ungroup() %>%
    mutate(AAR = AAR/23) %>%
    mutate(AAR_chr = AAR %>% scales::percent())

CAGR <-  ZMI_Data_Prep |> 
    filter(Year %in% c(2000, 2023))  |>
    group_by(City_zip) |>
    mutate(Beginning_Value = Z_Home_Value_Index[Year == 2000],
           Ending_Value    = Z_Home_Value_Index [Year==2023]) |>
    ungroup() |>
    select(City_zip, Beginning_Value, Ending_Value) |>
    distinct()

# calculando CAGR 
CAGR <- CAGR |>
    mutate(Number_of_Years = 2023-2000,
           CAGR = ((Ending_Value / Beginning_Value)^(1/Number_of_Years))-1)

#Calcular el CAGR 

# principal <- 155053
# principal_chr <- principal |> scales::dollar()
# CAGR <- 0.01918387
# Year <- 23
# 
# for (i in 1:Year) {
#         
#     principal <- principal * (1 + CAGR)
#     principal_chr <-  principal |> scales::dollar()
#     print(str_glue("Year: {i} Amount: {principal_chr}"))
# }
    


crime_rate <-  data_import(dataSource = "crime_rate")
demographics <-  data_import(dataSource = "demographics")

#MD
ZMI_Data_Prep <- ZMI_Data_Prep |> mutate(RegionName = RegionName |> as.character())
demographics <-demographics |> mutate(zip = zip |> as.character())

MD <- ZMI_Data_Prep |> 
    left_join(AAR,          by = "City_zip") |> 
    left_join (CAGR,        by = "City_zip" ) |>
    left_join (crime_rate,  by = c("RegionName" = "Zipcode")) |>
    left_join(demographics, by =c ("RegionName"="zip"))

MD |> miss_case_summary()
MD |> gg_miss_var()

# check <- MD |> filter(is.na(`Overall Crime Grade`)==TRUE)
MD <- MD |> filter(!is.na(`Overall Crime Grade`)==TRUE)

# MD |> na.omit()

MD |> filter(CAGR > 0.04 & Z_Home_Value_Index < 300000 & familyPercentPoverty < 12)

Employment <- data_import(dataSource = "Employment")
Employment |> gg_miss_var(facet = Year)
Employment |> miss_case_summary()

Employment_C <- Employment |> gather(key = "Month", value = "Employment", Jan:Dec) |>
    filter(Employment != is.na(Employment)) |>
    select(Year, Employment) |>
    group_by(Year) |>
    summarise(Employment=Employment |> mean()) |>
    mutate(Employment_lag1 = lag(Employment, n=1)) |>
    mutate(Employment_lag1=case_when(
        
        is.na(Employment_lag1) ~Employment,
        TRUE ~ Employment_lag1
    )) |>
    mutate(diff_1 = Employment - Employment_lag1) |>
    mutate(PC_YoY = diff_1/Employment_lag1) |>
    mutate(PC_YoY_chr = scales:: percent(PC_YoY))

# Data Store ----
write_rds(x=ZMI_Data_Prep, file = "01_Informacion_Data/Bureau_Labor_of_Statistics_Data/ZMI_Data_Prep.rds")
write_rds(x=Employment_C, file = "01_Informacion_Data/Zillow/Employment_C.rds")

 



