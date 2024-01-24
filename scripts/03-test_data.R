#### Preamble ####
# Purpose: Boundary condition tests to ensure that e.coli levels are within a 
#           certain range and there is no bad data
# Author: Samantha Barfoot 
# Date: 18 January 2024 
# Contact: samantha.barfoot@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)

#### Test data ####

#boundary condition test
#read in the data 
sunnyside <-
  read_csv(
    file = "outputs/data/sunnyside.csv",
    show_col_types = FALSE
  )

marieCurtis <-
  read_csv(
    file = "outputs/data/marieCurtis.csv",
    show_col_types = FALSE
  )

#will check that the e.coli levels are in the range (0,20000)
for(i in 1:length(sunnyside$eColi)){
  if(sunnyside$eColi[i] < 0 || sunnyside$eColi[i] > 20000 ){
    print(paste("sunnyside: bad data on day",i))
  }
}

#will check that the e.coli levels are in the range (0,20000)
for(i in 1:length(marieCurtis$eColi)){
  if(marieCurtis$eColi[i] < 0 || marieCurtis$eColi[i] > 20000 ){
    print(paste("marie curtis: bad data on day",i))
  }
}


