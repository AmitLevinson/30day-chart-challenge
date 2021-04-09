library(tidyr)
library(purrr)
library(ggplot2)
library(extrafont)

set.seed(123)

generate_points <- function(grid_size, n_points){
  # Generate random numbers to create prob weights
  raw_p <- c(sample(c(1:1e6), grid_size))
  # Create grid layout
  group_points <- data.frame(expand.grid(1:sqrt(grid_size), 1:sqrt(grid_size)),
                       # Assigin p for each grid square
                       p = raw_p/sum(raw_p))
  # Generate points location
  pmap_dfr(group_points, function (Var1, Var2, p) {
  points_on_grid <- data.frame(
    ypos = Var1 - runif(n = p*n_points),
    xpos = Var2 - runif(n = p*n_points))
  return(points_on_grid)
    }
  )
}

grid_points <- generate_points(grid_size = 49, n_points = 1e5)


ggplot(grid_points9)+
  geom_point(aes(x = xpos, y= ypos), size = 0.7)+
  theme_void()+
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )+
  labs(caption = "#30DayChartChallenge &#8226; Day 9 &#8226; Statistics &#8226; Amit_Levinson")+
  theme(
    plot.caption = element_markdown(hjust = 0.5, size = 10, color = "gray45", family = "Arvo")
  )
  
ggsave("code_and_plots/09_statistics/uniform9.png", width = 14, height = 14)

