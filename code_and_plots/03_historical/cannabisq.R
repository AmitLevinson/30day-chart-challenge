library(ggplot2)
library(readxl)
library(dplyr)
library(extrafont)
library(ggtext)
library(ggimage)

survey <- read_xlsx("data/03/cannabis-1991-clean.xlsx") %>% 
  mutate(
    Q1 = ifelse(Q1 == "Don't know/ Refuse to answer", "Don't know/\nRefuse to answer", Q1),
    q1 = factor(Q1, levels = c("Extremely severe harm",
                                  "Severe harm",
                                  "Light harm",
                                  "Doesn't harm at all",
                                  "Don't know/\nRefuse to answer")))


(p <- ggplot(survey, aes (x = q1, group = 1))+
  geom_bar(aes(y = ..prop..), fill = "gray 45")+
  scale_y_continuous(name = NULL, labels = scales::percent, limits = c(0,0.71))+
  geom_text(aes(label = scales::percent(..prop.., accuracy = 0.1), y = ..prop..), stat = "count", vjust = -0.5, family = "Noto Serif",  size = 4, color = "gray15")+
  labs(title = "In your opinion, does use of drugs harm the Israeli society?",
       subtitle = "Question taken from a representative <b>1991 phone survey</b> of 1017 Israelis on 'awareness to the topic of drugs'.<br>The question and response categories were translated by Amit Levinson.",
       x = NULL,
       caption = "\nData: dataisrael.idi | Viz: Amit_Levinson")+
  theme_minimal()+
  theme(
      text = element_text(family = "Segoe UI"),
      plot.title = element_text(family = "MedievalSharp", size = 16, face = "bold"),
      plot.subtitle = element_markdown(size = 10, color = "gray10"),
      axis.text.x = element_text(size = 11, color = "gray10", family = "MedievalSharp"),
      plot.caption = element_text(size = 9, color = "gray20", hjust = 0),
      axis.text.y = element_blank(),
      panel.grid = element_blank(),
      plot.margin = margin(6,3,4,4,"mm"),
      plot.background = element_rect(fill = NA, color = "gray45")
  ))

# Add background
ggbackground(p, background = "data/03/paper.jpg")


ggsave("code_and_plots/03_historical/survey.png", width =8, height = 6)

# Original questions in Hebrew:
# האם, לדעתך, שימוש בסמים הוא פגיעה בחברה הישראלית?
# In your opionion, is the use of drugs a harm of the Israeli society?
