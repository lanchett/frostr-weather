client_id <- "a7c79d85-2d72-4b25-ad86-fc40546e55b7"

sources <- get_sources(client_id = client_id)
frostr::get_observations()
frostr::get_available_timeseries()
frostr::get_element_codetables()
frostr::get_elements()
frostr::get_locations()
frostr::get_observations()
frostr::get_sources()

# Attach packages
library(frostr)
library(dplyr)
library(stringr)

# Set your client ID
client.id <- "<YOUR CLIENT ID>"

# Find the source ID for Blindern held by MET.NO
sources <- get_sources(client_id = client.id)

blindern.id <- sources %>%
  filter(str_detect(name, "OSLO - BLINDERN") & stationHolders == "MET.NO") %>% 
  select(id)

# Find the name of the climate and weather elements of interest
elements <- get_elements(client_id = client.id)

View(elements)
#> id                            name                                      units
#> ...                           ...                                       ...
#> mean(air_temperature P1D)     Mean air temperature (24 h)               degC
#> sum(precipitation_amount P1D) Precipitation (24 h)                      mm
#> mean(wind_speed P1D)          Average of wind speed of main obs. (24 h) m/s
#> ...                           ...                                       ...

element.names <- c("mean(air temperature P1D)",
                   "sum(precipitation_amount P1D)",
                   "mean(wind_speed P1D)")

# Declare the time range for which you want to retrieve observations
Sys.time()
reference.time <- "1900-01-01/2019-05-31"

# Get the weather observations specified
observations.df <- get_observations(client_id      = client.id,
                                    sources        = blindern.id,
                                    elements       = element.names,
                                    reference_time = reference.time)
Sys.time()
