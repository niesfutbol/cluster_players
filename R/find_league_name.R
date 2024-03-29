ID_FROM_LEAGUE_NAME <- list(
  "femenil_mx" = 673,
  "LigaMX" = 262,
  "ligue_1" = 61,
  "bundesliga" = 78,
  "eredivisie" = 88,
  "expansion" = 263,
  "LaLiga" = 140,
  "premier" = 39,
  "primeira_liga" = 94,
  "serie_a" = 135
)

find_league_id_from_list <- function(list_files) {
  league_names <- find_league_name_from_list(list_files)
  comprehenr::to_vec(for (name in league_names) ID_FROM_LEAGUE_NAME[[name]])
}


find_league_name_from_list <- function(list_files) {
  list_files |>
    .extract_name_files() |>
    .extract_name_leagues()
}

.extract_name_leagues <- function(name_files) {
  comprehenr::to_vec(for (name in name_files) stringr::str_split(name, "_[:digit:]{2}")[[1]][1])
}

.extract_name_files <- function(list_files) {
  comprehenr::to_vec(for (file in list_files) stringr::str_split(file, "/")[[1]][4])
}


find_year_from_list <- function(list_files) {
  list_files |>
    .extract_last_year_from_list() |>
    .remove_csv_extension()
}

.extract_last_year_from_list <- function(list_files) {
  comprehenr::to_vec(for (file in list_files) stringr::str_split(file, "-")[[1]][2])
}

.remove_csv_extension <- function(list_files) {
  comprehenr::to_vec(for (file in list_files) stringr::str_split(file, "\\.")[[1]][1])
}
