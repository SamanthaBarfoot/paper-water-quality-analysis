#### Preamble ####
# Purpose: Downloads and saves the data from Toronto Open Data website
# Author: Samantha Barfoot 
# Date: 18 January 2024 
# Contact: samantha.barfoot@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Read in the data ####
raw_water_quality_data <-
  read_csv(
    file = 
      "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/92b0de8f-1ada-44a7-84cf-adc04868e990/resource/fa96223e-ccf8-4c0a-817b-6f5039311287/download/toronto-beaches-water-quality%20-%204326.csv",
    show_col_types = FALSE
  )

# We have read the data from the open data catalog website now we want to save it. 
#### Saves data ####
write_csv(
  x = raw_water_quality_data,
  file = "inputs/data/toronto-beaches-water-quality.csv"
)
