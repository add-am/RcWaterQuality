library(tidyverse)
library(glue)

path <- "C:/Users/adams/drytropicshealthywaters.org/DTPHW Team - Documents/DTPHW/3.0 Technical/4.0 Technical Data/2023-2024 Data/DES Pesticides/"

data <- read_csv(glue("{path}/test2.csv"))

data_pivot <- data |> 
  mutate(Value = Value*1000,
         `Date Time` = dmy_hm(`Date Time`)) |> 
  unite(Value, c(Operator, Value), sep = "", na.rm = T) |> 
  select(-Unit) |> 
  pivot_wider(names_from = "Analyte", values_from = "Value") |> 
  rename(Site.Name = "Site Name", Date = "Date Time", MCPA = "MCPA (Monochlorophenoxyacetic acid)")

write_csv(data_pivot, glue("{path}/test3.csv"))
