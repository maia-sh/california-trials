# Filter for trials to match Chen et al. 2016

# - interventional
# - overall_official from organization ("To identify trials with the responsible party based at an academic medical center, we selected those affiliated with an academic medical center, using the 'role' field to identify the lead investigator, and his or her primary affiliation through the 'affiliation' field.")
# - primary completion date
# - exclude "Unknown status" & "Withdrawn" ("We identified and excluded clinical trials with an unknown or withdrawn status")

library(dplyr)
library(readr)
library(here)
library(fs)
library(glue)

dir_processed <- here("data", "processed")

orgs <-
  dir_ls(dir_processed) %>%
  path_file() %>%
  path_ext_remove()

for (org in orgs){

  message(glue("Processing {org}..."))

  studies <- read_csv(glue("{dir_processed}/{org}/{org}-studies.csv"))

  trials_chen <-
    studies %>%

    # Limit to studies with "overall_officials" from organization
    select(-ends_with("lead_sponsor"), -ends_with("responsible_party")) %>%
    filter(!if_all(starts_with(org), is.na)) %>%

    filter(study_type == "Interventional") %>%

    filter(!recruitment_status %in% c("Unknown status", "Withdrawn")) %>%

    mutate(primary_completion_year = lubridate::year(primary_completion_date))

    # Prepare 2007-2010 comparator to Chen
  trials_chen_2007_2010 <-
    trials_chen %>%
    filter(between(primary_completion_year, 2007, 2010))
  write_csv(trials_chen_2007_2010, glue("{dir_processed}/{org}/{org}-trials-chen-2007-2010.csv"))

    # Prepare 2014-2017 for new analysis
  trials_chen_2014_2017 <-
    trials_chen %>%
    filter(between(primary_completion_year, 2014, 2017))
  write_csv(trials_chen_2014_2017, glue("{dir_processed}/{org}/{org}-trials-chen-2014-2017.csv"))
}
