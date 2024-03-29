library(tidyverse)
library(umap)
source("R/select_variables.R")
set.seed(2)
macro_grupo <- 5
data_path <- "results/clustered_macrogroup_with_soccerment.csv"
players_1 <- read_csv(data_path, show_col_types = FALSE) |>
  distinct() |>
  filter(grupos == macro_grupo) |>
  filter(`Minutes played` > 900)

metrics <- c("second", "daves", "soccerment", "central_attackers", "central_midfielder")
metric <- metrics[macro_grupo]
variables <- players_1 %>%
  select_variables[[metric]]()
my_umap <- variables %>%
  scale() %>%
  umap()

datos <- tibble(x = my_umap$layout[, 1], y = my_umap$layout[, 2])
n_grupos <- 3
groups <- kmeans(datos, n_grupos)


predict.kmeans <- function(object, newdata) {
  centers <- object$centers
  n_centers <- nrow(centers)
  dist_mat <- as.matrix(dist(rbind(centers, newdata)))
  dist_mat <- dist_mat[-seq(n_centers), seq(n_centers)]
  max.col(-dist_mat)
}
datos$grupos <- factor(groups$cluster)
ggplot(datos, aes(x = x, y = y, color = grupos)) +
  geom_point()
ggsave(glue::glue("figurita_second_{metric}.png"))

players_1$s_grupos <- factor(groups$cluster)

players_1 %>%
  write_csv(glue::glue("results/second_clustered_macro_{macro_grupo}_with_{metric}.csv"))
