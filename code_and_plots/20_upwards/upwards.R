library(tidyverse)
library(extrafont)

# Get all file names that might have R code
all_files <- list.files(path = "~/", pattern ="\\.R$|.Rmd$", recursive = TRUE)
# Add the complete file
path_for_files <- paste0("~/", "\\/" ,all_files)
# Remove some files from paths that reference courses I downloaded/cloned
path_for_files <- path_for_files[!str_detect(path_for_files, "(Advanced-Research|my_PS6)")]
# Read lines
file_info <- map(path_for_files, file.info, extra_cols = TRUE)
# Add scripts as names
names(file_info) <- path_for_files

file_info_df <- map_dfr(file_info, ~ tibble(created = .x[["ctime"]]),
        .id = "script") %>% 
  mutate(
    # Split up to categories, more of a heuristic approach on the Author's end
    category = case_when(
      str_detect(script, "TidyTuesday") ~ "TidyTuesday",
      str_detect(script, "amitlevinson.com|draft") ~ "Website",
      str_detect(script, "30") ~ "Various\nchallenges",
      str_detect(script, "Thesis|JO|CV") ~ "Thesis/ Work",
      str_detect(script, "Courses|sql") ~ "Learning",
      TRUE ~ "Other",
    )
  )  

file_info_clean <- file_info_df %>% 
  arrange(created) %>% 
  # there's 1-2 files that have a very weird date.
  filter(between(format(created,"%Y"), 2019, 2022)) %>% 
  add_count(script, category, created) %>% 
  group_by(category) %>% 
  mutate(cum_scripts = cumsum(n),
         created = as.POSIXct(created, tz = "IDT")) %>% 
  ungroup()

group_labels <- file_info_clean %>% 
  group_by(category) %>% 
  filter(created == max(created)) %>% 
  mutate(vjust = ifelse(str_detect(category, "Various|Learning"), 1, 0.5))

ggplot(data = file_info_clean, aes(x = created, y= cum_scripts, color = category, group = category))+
  geom_path(size =0.6)+
  geom_point(data = group_labels,aes(x = created, y = cum_scripts), size = 0.8)+
  geom_text(data = group_labels, aes(x = created, y = cum_scripts, label = category, vjust = vjust), hjust = -0.02,  nudge_x = 3600*24*1, size =4, family = "Raleway Medium", lineheight = 0.8)+
  coord_cartesian(clip = "off", expand = TRUE)+
  guides(color = "none")+
  scale_x_datetime(name = "Script creation date", breaks = "3 months", date_labels = "%b %y", expand = c(0, 3600*24*50))+
  scale_y_continuous(name = "Cumulative number of scripts", breaks = seq(0, 100, 20))+
  labs(title = "My R Scripts Creation History",
       subtitle = "Plot shows the creation history of R/Rmd scripts located on my computer: drafts, random\nsnippets and files uploaded to GitHub. Scripts are categorized to various subjects.",
       caption = "Data: Personal Scripts | Viz: Amit_Levinson")+
  theme_minimal()+
  theme(
    text = element_text(family = "Raleway"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    plot.title.position = "plot",
    plot.title = element_text(size = 23, family = "Bodoni MT"),
    plot.subtitle = element_text(size = 12, color = "gray15"),
    plot.caption = element_text(size = 9, color = "gray35", hjust = 1),
    axis.title = element_text(color = "gray15", size = 11),
    axis.text = element_text(color = "gray25", size = 10),
    plot.margin = margin(5,3,3,3,"mm")
  )
  
ggsave("code_and_plots/20_upwards/upwards.png", width = 11, height = 7)
