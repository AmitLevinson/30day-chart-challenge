library(purrr)
library(stringr)
library(dplyr)

all_files <- list.files(path = "~/", pattern ="\\.R$|.Rmd$", recursive = TRUE)

path_for_files <- paste0("~/", "\\/" ,all_files)
file_lines <- map(path_for_files, readLines)

names(file_lines) <- path_for_files


ggsaves <- map_dfr(file_lines, ~ tibble(ggsave_raw = str_extract(.x, "(?<=ggsave\\().+(?=\\\")")),
                         .id = "script") %>% 

  mutate(ggsave_clean = str_extract(ggsave_raw, "(\\\"?)(/?<=)?[a-z0-0].+(.png$|.jpeg$)")) %>% 
filter(!is.na(ggsave_raw))


library(imager)

all_images <- safely(map(path_for_files, load.image))


test_image <- load.image(ggsaves[1])

head(file_packages)

