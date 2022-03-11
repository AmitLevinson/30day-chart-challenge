library(dplyr)

ChickWeight %>% 
  group_by(Diet, Chick) %>% 
  arrange(Diet, Chick, Time) %>% 
  filter()
  summarise(
    weight_increase = max(weight) - min(weight),
    total_time = max(Time) - min(Time)) 
  

library(ggplot2)
ChickWeight %>% 
  group_by(Diet, Chick) %>% 
  mutate(weight_change = lead(weight) - weight,
         day_change = paste0(Time, "-" ,lead(Time))) %>% 
  group_by(Diet, day_change) %>% 
  summarise(
    mean_change = mean(weight_change)
  ) %>% 
ggplot(aes(x= day_change, y = mean_change))+
  geom_col()+
  facet_grid(Diet ~ Chick)
  
  
