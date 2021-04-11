library(tidyverse)
library(rvest)
library(janitor)
library(ggforce)
library(glue)
library(ggtext)
library(ggimage)
library(extrafont)

# From topend  sports:
url <- "https://www.topendsports.com/resources/equipment-ball-size.htm"

# Scrape data
tbl_raw <- read_html(url) %>% 
  html_table() %>% 
  .[[1]] %>% 
  clean_names()

balls_of_interest <- c("Golf", "Baseball", "Tennis", "Softball (fastpitch)", "Volleyball", "Basketball")

# clean variables
tbl_clean <- tbl_raw %>% 
  # some come in a range so average them
  separate(diameter_mm, sep="(to|and|-)", into = c('low', "high")) %>% 
  mutate(across(.cols = c(low, high), parse_number)) %>% 
  mutate(
    # Since we split it up create one column for all
    ballcir = ifelse(!is.na(high), (low+high)/2, low),
    # Calculate circumference (value is for diameter in mm so also conver to cm)
    ballcir = (ballcir * pi)/10,
    image = ifelse(sport %in% balls_of_interest, paste0("code_and_plots/11_circular/", sport, ".png"), NA),
    balllabel = case_when(
      sport %in% balls_of_interest[c(1:3,5:6)] ~ glue("<span style='color:black; font-size:16pt'><b>{sport} ({round(ballcir)})</b></span>"),
      sport == "Softball (fastpitch)" ~ glue("<span style='color:black; font-size:15pt'><b>Softball<br>(fastpitch) ({round(ballcir)})</b></span>"),
      # What's up with these edge cases
      str_detect(sport, "Rhythmic") ~ glue("<span style='font-size:13pt'>Rhythmic<br>gymnastics<br>ball ({round(ballcir)})</span>"),
      str_detect(sport, "slowpitch") ~ glue("<span style='font-size:13pt'>Softball<br>(slowpitch) ({round(ballcir)})</span>"),
      str_detect(sport, "football") ~ glue("<span style='font-size:13pt'>Football <br>(soccer) ({round(ballcir)})</span>"),
      TRUE ~ glue("<span style='font-size:13pt'>{sport} ({round(ballcir)})</span>")),
    balllabel = reorder(balllabel, ballcir))
      

p <- ggplot(tbl_clean)+
  # use I(c(values)) to adjust image size differently
  geom_image(data = tbl_clean[!is.na(tbl_clean$image),] ,aes(x= 1, y= 1, image = image, size = I(c(0.155,0.25, 0.28, 0.375, 0.8, 0.9))))+
  geom_circle(aes(x0 = 1, y0 = 1, r = ballcir))+
  facet_wrap(~balllabel, nrow = 5)+
  labs(title = "Circumference of Sport Balls (cm)\n",
       caption = "Data: Topend Sports | Average values | Viz: Amit_Levinson")+
  theme_void()+
  theme(
    text = element_text(family = "Merriweather"),
    plot.caption = element_text(hjust = 1, color = "gray25", size = 14),
    plot.title = element_text(hjust = 0.5, size = 34),
    strip.text = element_markdown(color = "gray10",  hjust = 0.5),
    strip.background = element_blank(),
    plot.background = element_rect(fill = "#edf7fc", color =NA),
    panel.background = element_rect(fill = "#edf7fc", color = NA),
    plot.margin = margin(4,4,4,4,"mm")
  )

ggsave("code_and_plots/11_circular/balls.png",plot = p,  width = 14, height = 13)

