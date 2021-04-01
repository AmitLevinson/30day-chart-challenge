library(rtweet)
library(dplyr)
library(scales)
library(ggplot2)
library(glue)
library(extrafont)

al <- get_timeline("amit_levinson", n = 2000)

# calci;ate
al_clean <- al %>% 
  count(is_retweet) %>% 
  mutate(pct = n/sum(n))

# Compute label position
al_clean <- al_clean %>% 
  mutate(
    ymax = cumsum(pct),
    ymin = c(0, ymax[1]),
    labelpos = (ymax + ymin)/2,
    label = c(glue("\tOriginal tweet: {percent(pct[1])}\n({n[1]})"), glue("Retweets: {percent(pct[2])}\n({n[2]})")
  ))

ggplot(al_clean, aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 3, fill = is_retweet))+
  geom_rect()+
  coord_polar(theta = "y", clip = "off")+
  xlim(c(-0.5,5.5))+
  theme_void()+
  geom_text(aes(x = -0.5, y = 0, label = "How much do\nI (re)-tweet?"), size = 9, family = "Merriweather")+
  labs(caption = "Data: Twitter | viz: @Amit_Levinson\n")+
  geom_text(mapping = aes(x = c(5.5,5), y= labelpos, label = label, color = is_retweet), size = 4.25,  fontface = "bold", family = "Open Sans")+
  scale_fill_manual(values = c("TRUE" = "#1DA1F2", "FALSE" = "gray80"), guide = "none") +
  scale_color_manual(values = c("TRUE" = "#1DA1F2", "FALSE" = "gray40"), guide = "none")+
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    plot.caption = element_text(size = 9, family = "Open Sans", color = "gray35", hjust = 0.5),
    plot.margin = margin(0,0,6,0,"mm")
  )


ggsave("code_and_plots/01_part_to_whole/retweet.png", width = 8, height = 8)
