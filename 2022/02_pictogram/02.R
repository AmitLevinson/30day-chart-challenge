library(rtweet)
library(dplyr)
library(ggplot2)
library(tidyr)
library(ggtext)

# Collect data
dat <- rtweet::get_timeline("Amit_Levinson", n = 3200)


rstats <- dat %>% 
  # remove replies and retweets
  filter(!is_retweet, is.na(reply_to_user_id)) %>% 
  select(created_at, hashtags) %>% 
  # Unnest hashtags
  unnest(hashtags) %>% 
  # Count tweets with the rstats hashtag in them
  mutate(is_rstats = ifelse(!grepl("(R|r)stats", hashtags) | is.na(hashtags), 0, 1)) %>% 
  group_by(created_at) %>% 
  summarise(
    # If it's max 1 then we have an rstats in it
    has_rstats = max(is_rstats)
  ) %>% 
  arrange(created_at)

# Create grid layout for the icons
gridrows <- ceiling(nrow(rstats)/10) + 1
gridcols <- ceiling(nrow(rstats)/gridrows)

gridlayout <- data.frame(
  # Starting from the top row
  y = rep(gridcols:1, each = gridrows),
  # Going to the right
  x = rep(1:gridrows, gridcols)
) %>% 
  slice(1:nrow(rstats))

pictograms <- rstats %>% 
  cbind(gridlayout)

# Add a manual legend
legend_text <- data.frame(x = gridrows / 2, y = 11,
             label = paste0("<span style='color:#1DA1F2'><span style='font-family:\"Font Awesome 5 Brands\";'>twitter</span><b> Tweets with #rstats</b></span>"))
                            # "<br><span style='color:gray55'><span style='font-family:\"Font Awesome 5 Brands\";'>twitter</span><b> w/o #rstats</b></span>"))

# Add label years
year_labels <- pictograms %>% 
  mutate(tweetyear = format(created_at, "%Y"),
         # We only want one label per year, so remove any duplicates and keep the first one
         tweetyear = ifelse(duplicated(tweetyear), NA, tweetyear)) %>%
  
  drop_na() %>% 
  mutate(x = -3,
         tweetyear = ifelse(tweetyear == 2019, "2019 &#8594;", tweetyear))


# Just to get the count of tweets and quote tweets for subtitle
# pictograms %>% 
#   summarise(
#     sum(has_rstats),
#     pct = sum(has_rstats) / n(),
#     n()
#   )


ggplot(data = pictograms, aes(x =x, y= y, color = factor(has_rstats))) +
  geom_text(family='Font Awesome 5 Brands', size= 4, label = "twitter" ) +
  scale_color_manual(guide = "none", values = c("0"= "gray55", "1" = "#1DA1F2")) +
  geom_richtext(inherit.aes = F, data = legend_text, mapping = aes(x =x , y= y, label = label), size = 3.5, fill = NA, color = NA)+
  geom_richtext(data = year_labels, mapping = aes(x = x, y =y, label =tweetyear), color = "gray35", hjust = 0, size = 3, fill = NA, label.color = NA) +
  # xlim(c(-2, 39))+
  labs(
    title = "My use of the <b><span style='color:#1DA1F2'>#rstats</span></b> hashtag",
    subtitle  = "My tweets over the years, comparing those with the #rstats hashtag to those without. Replies\nand retweets are excluded. Overall I used the hashtag 140 times, for a total of ~38% out of all\ntweets and quote tweets since 2019 (n = 364)",
    x = NULL,
     y= NULL,
    caption = "Data: Twitter | @Amit_Levinson"
  ) +
  theme(
    text = element_text(family  = 'Titillium Web'),
    plot.title = element_markdown(size = 18, face = "bold", family = "Faune"),
    plot.subtitle = element_text(size = 12, color = "gray35"),
    plot.caption = element_text(size = 8, color = "gray55", face = "italic"),
    plot.title.position = "plot",
    plot.background =  element_rect(fill = "white", color = NA),
    panel.background =  element_rect(fill = "white", color = NA),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    plot.margin = margin(4,4,4,4, "mm")
  )

ggsave("2022/02_pictogram/02.png", width = 8, height = 5)  