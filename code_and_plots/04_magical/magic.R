library(tuber)
library(keyring)
library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)
library(extrafont)
library(ggplot2)
library(ggtext)

# NOT RUN: Authentication and one-time download of comments
# Video:
# https://www.youtube.com/watch?v=PFA-RmV_wG0

# yt_oauth(app_id = key_get("youtube-app"), key_get("youtube-appsecret"), token = ' ')
# cmnts <- get_all_comments("PFA-RmV_wG0")
# write_csv(cmnts, "data/04/cmnts.csv")

# Data already downloaded and loaded
cmnts <- read_csv("data/04/cmnts.csv")

time_referenced <- cmnts %>% 
  # Get the times references by individuals
  transmute(time_ref = str_extract_all(textDisplay, "\\d{1,2}:\\d{2}")) %>% 
  # Some comments addressed more than one time slot
  unnest(time_ref) %>% 
  filter(!is.na(time_ref)) %>% 
  mutate(
    # Convert to a 'period' with lubridate
    time_ref_lubridate = ms(time_ref),
    # Convert to numeric for easier x-axis scale
    time_numeric = as.numeric(time_ref_lubridate)) %>% 
  arrange(-time_numeric) %>% 
  # For some odd reason people are referencing after the video ends??
  filter(time_numeric < 840) 


time_referenced %>% 
  ggplot(aes(x = time_numeric))+
  geom_histogram(bins = 50, fill = "gray35", color = NA )+
  scale_x_continuous(name = "\n Minute\n", breaks = seq(0,840, 120), labels = c("0:00", seq(2,12,2), "14:00"))+
  labs(title = "Highlights of a Magic Trick Video <span style='font-family: \"Font Awesome 5 Free Solid\"'>&#xf0d0;</span>",
       subtitle = "Bars represent frequency of comments referencing a time-frame in a magick trick video. The analysis is\nbased on ~18,000 comments from the video \"BEST Magic Show in the world - Genius Rubik\'s Cube\nMagician America\'s Got Talent\" on YouTube",
       y = "Number of references",
       caption = "Data: YouTube | Viz: Amit_Levinson")+
  theme(
    text = element_text(family = "Leelawadee UI"),
    plot.title = element_markdown(family = "Quite Magical", size = 24),
    plot.subtitle = element_text(size = 11),
    plot.caption = element_text(color = "gray25", size = 8, hjust = 0),
    axis.title = element_text(color = "gray25", size = 12),
    axis.text = element_text(color = "gray10", size = 10),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "#ffe9ec"),
    plot.background = element_rect(fill = "#ffe9ec"),
    plot.margin = margin(6,4,4,4, "mm")
  )

ggsave("code_and_plots/04_magical/magic.png", height = 7, width = 9)
