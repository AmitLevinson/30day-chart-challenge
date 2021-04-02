library(waffle)
library(extrafont)
library(ggtext)
library(here)
library(ggplot2)


pm <- data.frame(
  gender = c(rep("M", 4), "F", rep("M", 8)))


ggplot(pm, aes(label = gender, values = 1))+
  geom_pictogram(aes(colour = gender), n_rows = 15, flip = TRUE, family =  "Font Awesome 5 Free Solid", show.legend = FALSE, size = 10)+
  scale_color_manual(name = NULL, values = c("#6A0DAD", "gray60")) +
  scale_label_pictogram(name = NULL, values = c("female", "male"), labels = c("F", "M"))+
  geom_text(aes(x = 5.1, y = 1.18), label= "Golda Meir\nTenure: 1969-1974", hjust = 0, size = 3, color = "#6A0DAD", family = "Raleway Medium")+
  geom_text(aes(x = 6, y = 0.5), label= "Viz: Amit_Levinson", hjust = 0, size = 3, color = "gray55", family = "Raleway Medium")+
  geom_segment(aes(y = 1.1, yend = 1.21, x = 5, xend = 5), alpha = 0.3, color = "#6A0DAD", linetype = "dashed", size = 0.5)+
  labs(title = "Israel has exprienced only one <span style='color:#6A0DAD'><b>female</b></span> prime minister")+
  theme_void()+
  theme(
    text = element_text(family = "Arvo"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color =NA),
    plot.margin = margin(10,20,10,20,"mm"),
    plot.title = element_markdown(hjust = 0.5, size = 16),
    plot.caption = element_text(hjust = 0.5, size = 6, color = "gray35")
  )


ggsave(filename = here("code_and_plots","02_pictogram", "pm.png"), width = 7, height = 6)