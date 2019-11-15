# Get packages ------------------------------------------------------------
library(frostr)
library(dplyr)
library(purrr)
library(stringr)

client.id <- config::get("client_id")

# Select random station per county ----------------------------------------

sources <- get_sources(client_id = client.id)
county_names <-
  c(
    "ROGALAND",
    "SOGN OG FJORDANE",
    "NORDLAND",
    "OPPLAND",
    "HEDMARK",
    "BUSKERUD",
    "TRØNDELAG",
    "OSLO",
    "AKERSHUS",
    "MØRE OG ROMSDAL",
    "VESTFOLD",
    "AUST-AGDER",
    "HORDALAND",
    "TROMS",
    "VEST-AGDER",
    "ØSTFOLD",
    "TELEMARK",
    "FINNMARK"
  )



county_ids <- sources %>%
  filter(county %in% county_names & stationHolders == "MET.NO" & validFrom < 1980) %>% 
  group_by(county) %>% 
 slice(1) %>% 
  ungroup() %>% 
  select(id)

# Find the name of the climate and weather elements of interest

elements <- get_elements(client_id = client.id)

element.names <- c("mean(wind_speed P1D)")

# Declare the time range for which you want to retrieve observations
reference.time <- "2018-01-01/2019-05-31"

# Get the weather observations specified
observations.df <- map_df(county_ids, ~ get_observations(client_id      = client.id,
                                    sources        = .x,
                                    elements       = element.names,
                                    reference_time = reference.time) %>% mutate(year = lubridate::year(referenceTime)) %>%
                         group_by(year, sourceId) %>% 
                         summarise(mean_wind = mean(value))
                         )

observations.df
