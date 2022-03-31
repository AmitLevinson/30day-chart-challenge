library(dplyr)
library(purrr)

files <- list.files(path = "~/", pattern = "(.R|.Rmd)$", recursive = T)
file_path <- paste0("~/", files[!grepl("Random/Articles_and_Courses", files)])

clean_script <- function (script) {
  readLines(script) %>% 
    # ((?<=library\\() — positive look behind to find a library(
    # .+ — We want everything right after that library(
    # (?=\\)) — Positive lookahead to find a closing percenticies but not keep it
    # \\w+(?=::)) — Capture everything before a ::, a reference for a function from a library
    stringr::str_extract("((?<=library\\().+(?=\\))|\\w+(?=::))") %>% 
    unique() %>% 
    as.data.frame() %>% 
    select(package = 1) %>% 
    filter(!is.na(.))
}

scripts <- map_dfr(file_path, clean_script, .id = "rowid")

agg_packages <- scripts %>% 
  mutate(total_scripts = max(as.numeric(rowid))) %>% 
  group_by(package) %>% 
  summarise(
    n = n(),
    pct = n / total_scripts,
    total_scripts = max(total_scripts),
    .groups = "drop"
  ) %>% 
  arrange(-n) %>% 
  distinct(package, n, pct, total_scripts)

write.csv(agg_packages, "packages.csv")


