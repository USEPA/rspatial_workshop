library(tidyverse)
regs<-read_csv("2017-09-06_registrants.csv")
table(regs$`Spatial Analysis/GIS with R`)
table(regs$`Data Visualization with ggplot2`)
spatial_regs <- regs %>%
  filter(`Spatial Analysis/GIS with R` == 'AM' | 
           `Spatial Analysis/GIS with R` == 'PM') %>%
  mutate(time = `Spatial Analysis/GIS with R`) %>%
  select(name = Name, time, email = Email) %>%
  arrange(time)
write_csv(spatial_regs,"spatial_registrants.csv")
