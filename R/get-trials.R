library(dplyr)
library(here)
library(fs)
library(readr)
# remotes::install_github("maia-sh/aactr")
library(aactr)
library(lubridate)
library(glue)


#  Prepare organization ---------------------------------------------------
# NOTE: This script can be run for a single org at a time, so comment out others

org_short <- "stanford"
org_names <- org_short

org_short <- "ucsf"
org_names <- stringr::str_c(org_short,
                            "University of California San Francisco",
                            "University of California, San Francisco",
                            sep = "|")

org_short <- "ucdavis"
org_names <- stringr::str_c(org_short,
                            "uc davis",
                            # "University of California, Davis",
                            # "University of California Davis",
                            sep = "|")

org_short <- "ucsd"
org_names <- stringr::str_c(org_short,
                            "University of California, San Diego",
                            "University of California San Diego",
                            sep = "|")

org_short <- "ucla"
org_names <- stringr::str_c(org_short,
                            "University of California, Los Angeles",
                            "University of California Los Angeles",
                            sep = "|")

# Additional set-up -------------------------------------------------------

# Prepare directories
dir_raw_org <- dir_create(here("data", "raw", org_short))
dir_processed_org <- dir_create(here("data", "processed", org_short))

# Specify aact username
AACT_USER <- "respmetrics"

# Get trials "led" by org -------------------------------------------------

affiliations <- get_org_trials(org = org_names, user = AACT_USER)

write_csv(affiliations, glue("{dir_raw_org}/{org_short}-trials-affiliations.csv"))

trns <- affiliations$nct_id


# Download and process AACT data ------------------------------------------

download_aact(ids = trns, dir = dir_raw_org, user = AACT_USER, query = glue("AACT_{org_short}"))
process_aact(dir_raw_org, dir_processed_org)


# Combine AACT and org affiliation info -----------------------------------

aact <- read_rds(path(dir_processed_org, "ctgov-studies.rds"))

studies <-
  affiliations %>%

  # Add org to column names
  rename_with(~stringr::str_c(org_short, ., sep = "_"), -nct_id) %>%
  left_join(aact, ., by = "nct_id") %>%
  mutate(
    registration_year = lubridate::year(registration_date),
    start_year = lubridate::year(start_date),
    completion_year = lubridate::year(completion_date)
  )

write_csv(studies, path(dir_processed_org, "ucsf-studies.csv"))


# Filter for eligible trials ----------------------------------------------

# Limit to interventional trials completed in or before 2020 with relevant status
trials <-
  studies %>%
  filter(
    study_type == "Interventional" &
      recruitment_status %in% c("Completed" , "Terminated" , "Suspended", "Unknown status") &
      completion_year < 2021
  )

write_csv(trials, glue("{dir_processed_org}/{org_short}-trials.csv"))
