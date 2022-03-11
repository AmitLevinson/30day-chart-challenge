
# Second section contains code to aggregate by letter? --------------------



library(tidyverse)
library(ggtext)
library(ggtext)
library(extrafont)
library(ggfx)

Sys.setlocale("LC_ALL", "Hebrew")


first_names <- read_csv("data/06/first_names.csv") %>% 
  setNames("firstname")


names_split <- first_names %>% 
  mutate(
    rowid = 1:nrow(.), 
    heletters = str_split(firstname, boundary("character"))) %>% 
  unnest(heletters) %>% 
  filter(!str_detect(heletters, "(\\?| |\\\\|'|m|\\\")")) %>% 
  mutate(
    heletters = case_when(
      heletters == "ך" ~ "כ",
      heletters == "ף" ~ "פ",
      heletters == "ם" ~ "מ",
      heletters == "ץ" ~ "צ",
      heletters == "ן" ~ "נ",
      TRUE ~ heletters
    ))

letters_split <- names_split %>% 
  distinct(firstname, heletters) %>% 
  group_by(heletters) %>% 
  summarise(
    letter_freq = n(),
    letter_prop = n()/nrow(first_names)
  ) %>% 
  mutate(heletters = as.factor(heletters),
         xpos = nrow(.):1,
         ypos = 0) %>% 
  select(heletters, letter_prop, xpos,ypos)

ggplot(letters_split)+
  geom_col(aes(x = heletters, y = 1), fill = "gray90")+
  as_reference(
    geom_col(aes(x = heletters, y = letter_prop), fill = "#00528b", color =NA),
    id = "text")+
  with_blend(
    geom_text(aes(x = heletters, y= 0, label = heletters, size = letter_freq), size = 8, vjust = -0.035, color = "#00528b", family = "Open Sans Hebrew"),
    bg_layer = "text",
    blend_type = "xor")+
  #geom_richtext(data = title_df, aes(x = x, y =y, label = label), hjust = 0, label.size = NA, fill = "white")+
  labs(
    title = "Letter Frequency in Hebrew Names",
    subtitle = "The Israeli CBS published a list of distinct registered Hebrew names. The Hebrew language has a total\nof 22 letters, in addition to a few that change when appearing at the end of a word. The plot shows the\nproportion of a letter appearing at least once throughout all names.",
    caption = "Data: Israel CBS | Viz: Amit_Levinson",
    y = "% of names the letter appears in\n")+
  scale_x_discrete(limits = rev(levels(letters_split$heletters)))+
  scale_y_continuous(breaks = seq(.25,.75,.25), labels = scales::percent_format(), limits = c(0,1))+
  theme_void()+
  theme(
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.title = element_text(size = 28, family = "Bodoni MT"),
    plot.subtitle = element_text(size = 12, lineheight = 1.1),
    plot.caption = element_text(size = 9, color = "gray45", hjust = 0),
    text = element_text(family = "Open Sans"),
    axis.text.y = element_text(size = 10, color = "gray45"),
    axis.title.y = element_text(size = 11, color = "gray45", angle = 90),
    plot.background = element_rect("white", color = NA),
    panel.background = element_rect("white", color = NA),
    plot.margin = margin(4,4,4,4,"mm")
  )

ggsave("code_and_plots/06/experimental.png", height = 7, width = 10, dpi = 500)


# Never used this part ----------------------------------------------------



pos_letters <- names_split %>% 
  group_by(rowid) %>% 
  mutate(letter_id = seq_along(rowid)) %>% 
  mutate(total_letters = n()) %>% 
  group_by(rowid, heletters) %>% 
  summarise(
    avg_pos = mean(letter_id),
    count_letter = n()
  ) %>% 
  group_by(heletters) %>% 
  summarise(
    letter_count = n(),
    avg_total_pos = weighted.mean(avg_pos, count_letter)
  )

names_split %>% 
  group_by(heletters) %>% 
  summarise(
    max_length = max(total_letters),
    min_length = min(total_letters)
  ) %>% View()
weighted.mean()

?mean
# 9,095 have ' in their names
# Median number of max letters in a word for each letter is 13 (Ranging from 12-14), minimum is 2





