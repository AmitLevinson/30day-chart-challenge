library(readr)
library(here)
library(dplyr)
library(geofacet)
library(ggtextures)
library(ggplot2)
library(magick)

ftr <- read_csv(here("data", "fertility-rate-complete-gapminder.csv"))

child_svg <- image_read_svg(here("data", "baby.svg"))

ftr_clean <- ftr %>% 
  group_by(Entity) %>% 
  filter(Year == max(Year)) %>% 
  select(everything(), ftr = 4) %>% 
  head(20) %>% 
  mutate(
    image = list(image_read_svg(here("data", "baby-head-outline-with-pacifier.svg"))),
    ftr = round(ftr, 1)
  )

ftr_world_map <- ftr_clean %>% 
  left_join(world_countries_grid1, by = c("Code" = "code_alpha3")) %>% 
  filter(is.na(col))

ggplot(ftr_world_map, aes(x = ftr, y = Entity))
  #geom_col()+
  facet_geo(~ Entity, grid = "world_countries_grid1") 

ggplot(ftr_clean, aes(x = reorder(Entity, ftr), y = ftr, image = image))+
  geom_isotype_col(img_width = grid::unit(1, "native"), img_height = NULL, ncol = NA, nrow = 1, hjust = 0,vjust = 0.5)+
  coord_flip()+
  theme_minimal()

ggsave(here("code_and_plots", "02_pictogram", "test.png"), width = 8, height = 12)

?geom_isotype_col


# svg from:
# <div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

data <- tibble(
  count = c(5, 3, 6),
  animal = c("giraffe", "elephant", "horse"),
  image = list(
    image_read_svg("http://steveharoz.com/research/isotype/icons/giraffe.svg"),
    image_read_svg("http://steveharoz.com/research/isotype/icons/elephant.svg"),
    image_read_svg("http://steveharoz.com/research/isotype/icons/horse.svg")
  ))
  ?image_read_svg
  
  ggplot(data, aes(animal, count, image = image)) +
    geom_isotype_col() +
    theme_minimal()
  