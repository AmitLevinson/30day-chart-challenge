library(ggraph)
library(tidyverse)
library(igraph)
library(extrafont)
library(ggtext)

# Get all file names that might have R code
all_files <- list.files(path = "~/", pattern ="\\.R$|.Rmd$", recursive = TRUE)
# Add the complete file
path_for_files <- paste0("~/", "\\/" ,all_files)
# Remove some files from paths that reference courses I downloaded/cloned
path_for_files <- path_for_files[!str_detect(path_for_files, "(Advanced-Research|my_PS6|From_moodle|Kearan_healy)")]
# Read lines
file_lines <- map(path_for_files, readLines)
# Add scripts as names
names(file_lines) <- path_for_files

# Extract geoms:
g_used <- map_dfr(file_lines, ~ tibble(package = str_extract_all(.x, "(?<=geom_)\\w+")),
                  .id = "script") %>% 
  unnest(package) %>% 
  filter(!is.na(package)) %>% 
  distinct(script, package) 


# Basically we're left with solving the 'handshake problem', creating a distinct combination
# between all ge0ms ('who shaked hands with who')
g_count <- g_used %>% 
  group_by(script) %>% 
  # Create combinations
  expand(from = package,to= package) %>% 
  # First filter of dupliace values
  filter(from != to) %>% 
  # Here's the tricky part using new columns as a way to reorder the values by a.b.c... and then filtering
  # duplicates using distinct.
  transmute(nodea = ifelse(from < to, from, to),
            nodeb = ifelse(from > to, from , to)) %>% 
  distinct(script, nodea,nodeb) %>% 
  ungroup() %>% 
  # I only used these once by themselves so we'll exclude them :(
  filter(!nodea %in% c("linerange", "step", "treemap", "treemap_text"))

# count the edges
edges_df <- select(g_count, -script) %>% 
  count(nodea, nodeb)

# Create vertices
# New data frame including script in one column and names in another
vertices_df <- data.frame(
  script = rep(g_count$script,2),
  g_name = c(g_count$nodea, g_count$nodeb)) %>% 
  distinct(script, g_name) %>% 
  count(g_name) %>% 
  # Count how many geoms across all scripts that contain geoms
  mutate(pct = round(n/n_distinct(g_used$script)*100, 1))

# Extract top 10
top_10 <- arrange(vertices_df, -pct)[1:10,1]

# Highlight the top 10 vertices
vertices_df <- vertices_df %>% 
  mutate(label_pct = ifelse(g_name %in% top_10, paste0(g_name, " (", pct, "%)"), g_name),
         label_color = ifelse(g_name %in% top_10, "yes", "no"))

# Create the ggraph
g_ggraph <- graph_from_data_frame(edges_df,
                                  directed = F,
                                  vertices = vertices_df)

# Plot
ggraph(g_ggraph, layout="stress")+
  geom_edge_link0(aes(edge_width = n), edge_colour = "gray35", alpha = 0.7)+
  geom_node_point(aes(size = pct, colour = label_color), shape=19)+
  geom_node_text(aes(label=label_pct, colour = label_color),  repel=F, vjust = -1, size = 6, family = "Raleway")+
  scale_color_manual(values = c("yes" = "#FEE851", "no" = "gray75"))+
  labs(title = "My network of \"geom(s)_\"",
       subtitle = "Plot shows the co-occurences of geoms (gemoetric objects added to a plot) used in my R scripts. Point size represents<br>the distinct frequency (%) of the geom across all scripts, where <span style='color:#FEE851'>the top 10 most common geoms are highlighted</span>",
       caption = "Data: My R scripts (except 4 geoms) | Viz: Amit_Levinson")+
  guides(size = "none",
         edge_width = "none",
         colour = "none")+
  theme(
    plot.title.position = "plot",
    plot.title = element_text(size = 32, color = "white", family = "Merriweather"),
    plot.subtitle = element_markdown(color = "gray75", size = 20, lineheight = 1.1),
    plot.caption = element_text(size = 10, color = "gray55", family = "Merriweather", hjust = 0.5),
    plot.background = element_rect(fill= "#222831", color = NA),
    panel.background = element_rect(fill= "#222831", color = NA),
    plot.margin = margin(6,3,4,6,"mm"))

ggsave("code_and_plots/18_connections/geoms.png", width = 20, height = 13)