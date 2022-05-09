
<!-- README.md is generated from README.Rmd. Please edit that file -->

A repository of [AACT](https://aact.ctti-clinicaltrials.org/) data for
trials affiliated with several Californian universities.

| organization | query_date |
|:-------------|:-----------|
| stanford     | 2022-02-21 |
| ucdavis      | 2022-03-09 |
| uci          | 2022-05-09 |
| ucla         | 2022-05-04 |
| ucsd         | 2022-05-04 |
| ucsf         | 2022-03-03 |

Tidied csv’s are available in `data --> processed --> {organization}`:

-   `{organization}_studies.csv` includes all trials from AACT
    affiliated with {organization}
-   `{organization}_trials.csv` is limited to interventional trials
    completed in or before 2020 with relevant status: “Completed” ,
    “Terminated” , “Suspended”, “Unknown status”

## Sample to match Chen et al. (2016)

In order to develop samples to match Chen et al. (2016), we apply the
following criteria to `{organization}_studies.csv`:

-   interventional
-   overall_official from {organization} (“To identify trials with the
    responsible party based at an academic medical center, we selected
    those affiliated with an academic medical center, using the ‘role’
    field to identify the lead investigator, and his or her primary
    affiliation through the ‘affiliation’ field.”)
-   primary completion date within specified range
-   exclude “Unknown status” & “Withdrawn” (“We identified and excluded
    clinical trials with an unknown or withdrawn status”)

Csv’s are available in
`data --> processed --> {organization} --> {organization}-trials-chen-20XX-20XX.csv`

Below is a comparison of trials in Chen 2007-2010 and our sample, for
2007-2010 and 2014-2017. Note that discrepancies are expected due to
differences in dates: Chen and colleagues include trials with a primary
completion date between “October 2007 and September 2010,” whereas we
use all of 2007 through all of 2010. Furthermore, it is likely some
registrations had data changed since Chen’s data extraction.

| university | n_trials_chen_2007_2010 | n_trials_2007_2010 | n_trials_2014_2017 |
|:-----------|------------------------:|-------------------:|-------------------:|
| stanford   |                     131 |                196 |                266 |
| ucdavis    |                      64 |                 81 |                110 |
| uci        |                      42 |                 40 |                 55 |
| ucla       |                      95 |                127 |                188 |
| ucsd       |                      75 |                103 |                127 |
| ucsf       |                     133 |                196 |                299 |

## References

Chen, R., Desai, N. R., Ross, J. S., Zhang, W., Chau, K. H., Wayda, B.,
Murugiah, K., Lu, D. Y., Mittal, A., & Krumholz, H. M. (2016).
Publication and reporting of clinical trial results: Cross sectional
analysis across academic medical centers. *BMJ*, *352*.
<https://doi.org/10.1136/bmj.i637>
