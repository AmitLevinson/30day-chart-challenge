library(tidyverse)
library(ggtext)
library(extrafont)

# Set to recognize hebrew characters
# Sys.setlocale("LC_ALL", "Hebrew")


first_names <- read_csv("data/06/first_names.csv") %>% 
  setNames("firstname")


names_split <- first_names %>% 
  mutate(
    # Id for each word
    rowid = 1:nrow(.),
    # split word to letters
    heletters = str_split(firstname, boundary("character"))) %>% 
  unnest(heletters) %>% 
  # Remove some odd letters individuals have that aren't in the Hebrew a.b.c
  filter(!str_detect(heletters, "(\\?| |\\\\|'|m|\\\")")) %>%
  mutate(
    # Convert letters that are different at the end to their source letter
    heletters = case_when(
      heletters == "ך" ~ "כ",
      heletters == "ף" ~ "פ",
      heletters == "ם" ~ "מ",
      heletters == "ץ" ~ "צ",
      heletters == "ן" ~ "נ",
      TRUE ~ heletters
    ))


letters_split <- names_split %>% 
  # Filter to distinct letters
  distinct(firstname, heletters) %>% 
  group_by(heletters) %>% 
  # Count frequency and % across words
  summarise(
    letter_freq = n(),
    letter_prop = n()/nrow(first_names)
  ) %>% 
  # convert to factor and give a x-y position
  mutate(heletters = as.factor(heletters),
         xpos = nrow(.):1,
         ypos = 0) %>% 
  select(heletters, letter_prop, xpos,ypos)

# Plot
ggplot(letters_split)+
geom_col(aes(x = heletters, y = 1), fill = "gray90")+
  # Helps add text above bar plot
    geom_col(aes(x = heletters, y = letter_prop), fill = "#00528b", color =NA)+
    geom_text(aes(x = heletters, y= 0, label = heletters, size = letter_freq), size = 8, vjust = -0.035, color = "white", family = "Open Sans Hebrew", fontface = "bold")+
  labs(
    title = "Letter Frequency in Hebrew Names",
    subtitle = "The Israeli Population and Immigration Authority published a list of distinct registered Hebrew first names. The Hebrew\nlanguage has a total of 22 letters, while some of them appear differently at the end of a word. The plot shows the likleihood\nof a letter appearing at least once in a given name.",
    caption = "Data: Israelן Population and Immigration Authority | Viz: Amit_Levinson",
    y = "% of names the letter appears in\n")+
  # Reverse the factors, otherwise it's all mixed up
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
    axis.text.y = element_text(size = 11, color = "gray45"),
    axis.title.y = element_text(size = 12, color = "gray45", angle = 90),
    plot.background = element_rect("white", color = NA),
    panel.background = element_rect("white", color = NA),
    plot.margin = margin(4,4,4,4,"mm")
  )

ggsave("code_and_plots/06/experimental.png", height = 8, width = 10, dpi = 500)
