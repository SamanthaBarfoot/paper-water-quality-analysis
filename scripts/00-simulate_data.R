#### Preamble ####
# Purpose: Simulates water quality throughout summer
# Author: Samantha Barfoot 
# Date: 17 January 2024
# Contact: samantha.barfoot@mail.utoronto.ca 
# License: MIT
# Pre-requisites: [...UPDATE THIS...]


#### Workspace setup ####
#install.packages("tidyverse")
#install.packages("janitor")
#### Workspace setup ####
library(tidyverse)
library(janitor)


#### Simulate data ####
for(fileName in c("sunnyside.csv","marieCurtis.csv")){
  simulated_data <-
    tibble(
      # Use 1 through to 153 to represent each day
      "day" = 1:153,
      # Randomly pick an option, with replacement, 153 times
      "eColi" = sample(
        x = 1:200,
        size = 153,
        replace = TRUE
      ),
      "yearsSafe" = sample(
        x = 1:25,
        size = 153,
        replace = TRUE
      ),
      "yearsUnSafe" = sample(
        x = 1:25,
        size = 153,
        replace = TRUE
      )
    )
  #creates csv file with simuated data for each beach
  write_csv(
    x = simulated_data,
    file = paste("outputs/data",fileName, sep = "/")
  )
}
