library(readxl)
library(here)
library(sf)
library(dplyr)
library(stringr)
library(ggforce)
library(ggtext)
library(purrr)
library(forcats)

pop_raw <- read_xlsx(here("data", "population_madaf_2019_1.xlsx"), sheet = 2, skip = 13)
names(pop_raw) <- c("code", "name_he", "name_en", "total", "jews_and_other", "others", "jews", "arabs")
# isr_nafot <- st_read(here("data", "israel-borders", "israel_borders.shp"))
shp_path <- paste0("data/", list.files(here("data"), recursive = TRUE, pattern = "\\.shp$"))

# shp_path <- list.files(pattern = "muni_il.shp", recursive = TRUE)
cities <- tribble(
  ~shp_city, ~pop_city,
  'Bnei Berak', 'Bene Beraq',
  'Mitspe Ramon', 'Mizpe Ramon',
  'Tel Aviv - Yafo', 'Tel Aviv - Yafo',
  'Jerusalem', 'Jerusalem',
  'Eilat', 'Elat', 
  "Be'er Sheva","Be'er Sheva",
  'Dimona', 'Dimona',
  'Rehovot', 'Rehovot'
) %>% 
  inner_join(pop_raw, by = c("pop_city" = "name_en")) %>% 
  select(1:2, total)


# load the borders shape file
isr_cities <- st_read(shp_path[2])


pop_area_data <- isr_cities %>% 
  filter(
    str_detect(Muni_Eng, paste(cities$shp_city, collapse = '|'))
  ) %>% 
  group_by(Muni_Eng) %>% 
  # st_union()
  summarise(new_shape = sf::st_union(geometry)) %>% 
  mutate(
    city_area = units::set_units(st_area(new_shape), "km^2"),
    Muni_Eng = ifelse(Muni_Eng == 'Yerushalayim (Jerusalem)', "Jerusalem", Muni_Eng)
  ) %>% 
  st_drop_geometry() %>% 
  left_join(cities, by = c("Muni_Eng" = "shp_city"))
  
generate_points <- function(Muni_Eng, city_area, total, ...) {
  per_km2 <- round(total / city_area)
  # Create radius (hypothenos) for the calculation below
  r <- runif(per_km2)
  # A theta angle to identify points location. 
  theta <- runif(per_km2) * 2 * pi
  
  out <- data.frame(
    x = r * cos(theta),
    y = r * sin(theta)
      ) %>% 
    mutate(
    city = factor(Muni_Eng),
    total = total,
    size = city_area,
    per_km2 = as.numeric(per_km2)
    )
  
  return(out)
}

# Generate points
kmpoints <- pmap_dfr(pop_area_data, generate_points) %>% 
  mutate(city = glue::glue("<span style='color:black'><b>{city}<b></span><br><span style='color:gray25;font-size:13pt;'>{scales::comma(per_km2)}</span>"),
         city = fct_reorder(city, per_km2))


ggplot(data = kmpoints, aes(group = city)) +
  # geom_circle(aes(x0 = 0, y0 = 0, r = 1))+
  geom_point(aes(x= x, y = y), size = .2) +
  facet_wrap(~ city, nrow = 2) +
  labs(
    title = "Population Density in Israeli Cities",
    subtitle = "<b>Points (and numbers) represent the number of people for 1 km^2</b>. Sizes are calculated from Israel's gov shape<br>files, and cities' population size from Israel's CBs report for 2019.<br><span style='font-size:24pt'>&#8226;</span> = 1 person<br>",
    caption = "@Amit_Levinson"
  )+
  theme(
    text = element_text(family = "IBM Plex Sans"),
    plot.title = element_text(hjust = 0.5, size = 36, family = "Lora", vjust = 1, face = 'bold'),
    plot.subtitle = element_markdown(hjust = 0, size = 18, lineheight = 1.1),
    plot.caption = element_text(size = 12, color = 'gray35', face = 'italic'),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    strip.background = element_blank(),
    strip.text = element_markdown(size = 16, color = 'gray55'),
    plot.margin = margin(6,4,4,4, 'mm')
  ) 
    

ggsave("density.png", width = 14, height = 10, dpi = 500)
