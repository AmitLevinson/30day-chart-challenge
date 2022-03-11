library(dplyr)
# install.packages("bcmaps")
library(bcmaps)
library(tidyr)
library(purrr)


individuals <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-23/individuals.csv')
locations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-23/locations.csv')


caribou_on <- individuals %>% 
  select(animal_id, contains("long"), contains("lat")) %>% 
  drop_na() %>% 
  st_as_sf(coords = c("deploy_on_longitude", "deploy_on_latitude")) %>% 
  rename(geometry_on = geometry)

caribou_both <- st_as_sf(as.data.frame(caribou_on), coords = c("deploy_off_longitude", "deploy_off_latitude")) %>% 
  rename(geometry_off = geometry) %>% 
  mutate(across(c(geometry_on, geometry_off), ~st_set_crs(.x, 4326))) %>% 
  transform_bc_albers()

individuals %>% 
  inner_join(caribou_on, by = c("animal_id" = "animal_id")) 
count(animal_id, sort = T)

locations

animals$geometry[[1]] %>% 
  st_as_sf(coords = c(1,2))
locations %>% 
  count(animal_id, sort = T)

animals <- locations %>% 
  group_by(animal_id) %>% 
  filter(n()> 3500) %>% 
  arrange(animal_id, timestamp) %>% 
  select(animal_id,timestamp, longitude, latitude) %>% 
  mutate(timestamp = as.POSIXct(timestamp)) %>%
  group_by(animal_id) %>% 
  mutate(time_dist = difftime(lead(timestamp), timestamp, units = "hours")) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 3347) 

chickwts
?ChickWeight

locations %>% 
  filter(animal_id %in% c("BP_car145", "QU_car143")) %>% 
  ggplot(aes(x = longitude, y = latitude))+
  geom_point()

animals_dist %>% 
  count(animal_id)

animals$geometry <- st_transform(animals$geometry, crs = "+proj=lcc +lon_0=-90 +lat_1=33 +lat_2=45")


animals_dist <- animals %>% 
  mutate(stamp_dis = st_distance(geometry, lead(geometry), by_element = TRUE))
  
animals_dist %>% 
  #st_drop_geometry() %>% 
  arrange(-stamp_dis) %>% 
  mutate(stamp_dis = as.numeric(stamp_dis)) %>% 
  # filter(stamp_dis < 0.2) %>% 
  # filter(time_dist< 12) %>% 
  ggplot(aes(x = stamp_dis))+
  geom_histogram(bins = 3) +
  facet_wrap(vars(animal_id))

?facet_wrap
class(animals_dist$time_dist)

# mutate(data = map(data, function (x) st_distance(x, lead(x), by_element = TRUE))) %>% 
  

empty <- st_as_sfc("POINT(EMPTY)")

df %>%
  mutate(
    elapsed_time = lead(timestamp) - timestamp,
    distance_to_next = sf::st_distance(
      geometry, 
      lead(geometry, default = empty), 
      by_element = TRUE)
  )
  