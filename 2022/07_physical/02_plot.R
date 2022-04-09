library(readr)
library(dplyr)
library(ggplot2)
library(ggridges)
library(ggtext)
library(lubridate)
# install.packages("ggh4x")
library(ggh4x) # Use for dual discerete axis in ggplot2

Sys.setlocale("LC_ALL", "Hebrew") # Some columns in Hebrew

dat <- read_csv("07_physical/clean_runners.csv")

clean_dat <- dat %>%
  filter(!is.na(score)) %>% 
  mutate(
    # Using dattetime for easier x scale with HH:MM
    score = as_datetime(paste(today(), score), tz = "UTC"),
    age_cat = case_when(
      age_cat == '70+' | age_cat == '65-69' | age_cat == '35-39' ~ paste0(age_cat, '*'),
      age_cat == 'General' ~ "<b>General</b>",
      TRUE ~ age_cat
    ),
    age_cat = factor(age_cat, levels = c("<b>General</b>", "70+*", "65-69*", "60-64", "55-59", "50-54","45-49", "40-44", "35-39*", "< 19"))
  ) 


ggplot(clean_dat) +
  geom_density_ridges(aes(x = score, y = forcats::fct_rev(age_cat), fill = higher_cat), alpha = 0.6, color = 'gray95', size = 0.1) +
  labs(title= 'Tel-Aviv Run 2022',
       subtitle = "~18,000 participants ran in the streets of Tel-Aviv on a rainy Friday afternoon in February 2022. Runners chose one out<br>of several age categories, either a specific age group or the <b>'General'</b> category (eventually being the biggest one).",
       x = "Run Score (HH:MM)",
       y = "Age Category",
       caption = "<br><span style='color:#3B3C36'>*Age-categories with with less than 30 participants in the Marathon race.</span><br>Data: Tel-Aviv Run &middot; @Amit_Levinson") +
  facet_wrap (~race_cat, scales = "free_x") +
  scale_fill_manual(name = NULL, labels = c ("<b><span style='color:#E1BE6A'>Men</span></b>", "<b><span style='color:#40B0A6'>Women</span></b>"),values = c("men"= "#E1BE6A", "women" = "#40B0A6"))+
  scale_x_datetime(breaks = scales::breaks_width("1 hour"), date_labels = "%H:%M")+
         # Add legend key below text
  guides(fill = guide_legend(label.position = "top"),
         # Second duplicate discerete axis, see {ggh4x}
         y.sec = guide_axis_manual())+ 
  theme(
    text = element_text(family = "Titillium Web"),
    plot.title.position = "plot",
    plot.title = element_text(size = 24, face = "bold", family = "Lora"),
    plot.subtitle = element_markdown(size = 14),
    plot.caption = element_markdown(hjust = 0, size = 11, color = 'gray45', lineheight = 1.1),
    axis.text.y = element_markdown(size = 12, color = "#343434"),
    axis.text.x = element_markdown(size = 10),
    axis.text.y.right = element_markdown(color = 'gray55'),
    axis.title.x = element_text(vjust = -3),
    axis.title.y = element_text(color = 'gray25'),
    axis.title = element_text(size = 12),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.spacing.x = unit(11, "mm"), # spacing between facets
    panel.background = element_rect(fill = "#Fdfcfa", color = NA),
    legend.position = "top",
    legend.key.height = unit(1, 'mm'),
    legend.key.width = unit(1, 'mm'),
    legend.text = element_markdown(size = 14),
    legend.background = element_rect(color = NA, fill =NA),
    strip.background = element_blank(),
    strip.text = element_text(size = 13, face = "bold"),
    axis.ticks = element_blank(),
    plot.background = element_rect(fill = "#Fdfcfa", color = NA),
    plot.margin = margin(8,5,4,5,"mm")
  )

ggsave("07_physical/run.png", width =13, height = 8, dpi = 600)
