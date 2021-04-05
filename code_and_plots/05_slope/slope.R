# devtools::install_github("vdeminstitute/vdemdata")
library(vdemdata)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggtext)
library(extrafont)

# Load data
dat <- vdemdata::vdem[c("country_name", "year", "v2x_polyarchy")]

polyarchy_decade <- dat %>% 
  filter(year %in% c(2010, 2020)) %>% 
  arrange(country_name, year) %>% 
  group_by(country_name) %>% 
  filter(n() > 1) %>% 
  mutate(year_diff = lead(v2x_polyarchy) - v2x_polyarchy,
         year = year) %>% 
  fill(year_diff, .direction = "down") %>% 
  ungroup() %>% 
  arrange(year_diff) %>% 
  mutate(rowid = 1:nrow(.),
         bar_color = case_when(
           # Decrease in democracy
           rowid %in% c(1:10) ~ "#d7191c",
           # Increase (last rows)
           rowid %in% c((max(rowid) - 9):max(rowid)) ~ "#2c7bb6",
           TRUE ~ "gray85"
         ),
         bar_size = ifelse(grepl("gray", bar_color), 0.4, 1))

ggplot(data = polyarchy_decade, aes(x = year, y = v2x_polyarchy, color = bar_color, group = country_name, size = bar_size))+
  geom_line()+
  # Draw highlighted lines again
  geom_line(data = subset(polyarchy_decade, !grepl("gray", bar_color)))+
  # text for countries that had a decrease
  geom_text(data = subset(polyarchy_decade, rowid %in% c(1:9) & year == 2010), aes(label = country_name), size = 3, nudge_x = -0.01, hjust = 1, family = "Lato", nudge_y = 0.002) +
  geom_text(data = subset(polyarchy_decade, rowid %in% c((max(rowid) - 9):max(rowid)) & year == 2020), aes(label = country_name), size = 3, , hjust = 0, nudge_x = 0.01, family = "Lato")+
  scale_y_continuous(breaks = c(0, .25, 0.5, 0.75), limits = c(0,max(polyarchy_decade$v2x_polyarchy)))+
  scale_x_continuous(limits = c(2009,2021), breaks = c(2010, 2020))+
  coord_cartesian(clip = "off")+
  scale_color_identity()+
  scale_size_identity()+
  labs(title = "A Decade of Democratic Values",
       subtitle = "Lines represent countries' democracy score based on V-Dem's 'polyarchy' variable. The score is made up of how much<br>does a country exercise values such as freedom of expression, clean elections and more (ranging between 0 to 1).<br>Highlighted are 5 countries with the most <span style='color:#d7191c'><b>decrease</b></span> and <span style='color:#2c7bb6'><b>increase</b></span> of democratic values between 2010 and 2020.",
       x = NULL,
       y = "<br><span style='font-family:\"Font Awesome 5 Free Solid\"; color:gray45'>&#xf060;</span> Lower democratic values | Higher democratic values <span style='font-family:\"Font Awesome 5 Free Solid\";color:gray45'>&#xf061;</span><br>",
       caption = "Data: R package {vdemdata} | Viz: Amit_Levinson")+
  theme_minimal()+
  theme(
    text = element_text(family = "Lato"),
    plot.title = element_text(family = "Playfair Display SemiBold", size = 15),
    plot.subtitle = element_markdown(size = 10, lineheight = 1.15),
    plot.caption = element_text(size = 8, hjust = 0.5, color = "gray45"),
    panel.grid = element_blank(),
    axis.title.y = element_markdown(color = "gray25"),
    axis.text.y = element_text(size = 8, color = "gray55"),
    axis.text.x = element_text(size = 12, family = "Playfair Display"),
    plot.margin = margin(7,4,4,4, "mm"),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave("code_and_plots/05_slope/vdem.png", width = 9, height = 8)

