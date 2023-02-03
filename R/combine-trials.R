library(dplyr)

dir_processed <- here::here("data", "processed")

# Get all universities
universities <-
  fs::dir_ls(dir_processed) |>
  fs::path_file()


# Read in specified trials for specified university, and normalize names
normalize_trials <- function(university, trial_type){
  glue::glue("{dir_processed}/{university}/{university}-{trial_type}.csv") |>
    readr::read_csv() |>
    rename_with(~ stringr::str_remove(., glue::glue("{university}_")), starts_with(university)) |>
    mutate(uni = university)
}

trials_chen_1417 <-
  purrr::map_dfr(universities, ~normalize_trials(., "trials-chen-2014-2017"))

trials_chen_1417 |>
  count(recruitment_status)
