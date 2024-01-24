#### Preamble ####
# Purpose: Cleans the raw data recorded by City of Toronto at the Sunnyside and mMrie Curtis beaches.
# Author: Samantha Barfoot 
# Date: 18 January 2024 
# Contact: samantha.barfoot@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(MASS)

#### Functions ####
convert_date <- function(date){
  month <- strtoi(substr(date,6,7), base = 10)
  day <- strtoi(substr(date,9,10), base = 10)
  
  #calculates the day in the sample collection season 
  if(month == 5){
    day_in_study <- day
  }
  else if(month == 6){
    day_in_study <- day + 31
  }
  else if(month == 7){
    day_in_study <- day + 61
  }
  else if(month == 8){
    day_in_study <- day + 92
  }
  else if(month == 9){
    day_in_study <- day + 123
  }
  
  return(day_in_study)
}

#### Clean data ####
raw_beach_data <-
  read_csv(
    file = "inputs/data/toronto-beaches-water-quality.csv",
    show_col_types = FALSE,
    skip = 1
  )

num_records <- dim(raw_beach_data)[1]

#creates matrix full of zeros to store clean data
marie_curtis_data <- matrix(rep(0, 3*153), ncol = 3, nrow = 153)
sunnyside_data <- matrix(rep(0, 3*153), ncol = 3, nrow = 153)

#fills clean data matrix with the cleaned data
#columns are as follows: day of year, average eColi levels, number of safe days, 
# and number of unsafe days
for(i in 1:num_records){
  #checks if ecoli levels are available
  if(toString(raw_beach_data[[i,6]]) != "NA"){
    #convert eColi level to integer
    ecoli <- strtoi(raw_beach_data[[i,6]])
    #removing some bad data
    if(ecoli<20000){
      #calls convert_date function to convert yyyy/mm/dd date format into which day of the 
      # data collection season it is
      day <- convert_date(toString(raw_beach_data[[i,5]]))
      #Marie Curtis beach
      if(toString(raw_beach_data[[i,2]]) == "1"){
        marie_curtis_data[day,1] <- marie_curtis_data[day,1] + ecoli
        
        #checks if eColi levels were safe to swim on the given day
        if(ecoli<100){
          marie_curtis_data[day,2] <- marie_curtis_data[day,2] + 1
        }
        else{
          marie_curtis_data[day,3] <- marie_curtis_data[day,3] + 1
        }
      }
      #Sunnyside beach
      else if(toString(raw_beach_data[[i,2]]) == "2"){
        sunnyside_data[day,1] <- sunnyside_data[day,1] + ecoli
        
        #checks if eColi levels were safe to swim on the given day
        if(ecoli<100){
          sunnyside_data[day,2] <- sunnyside_data[day,2] + 1
        }
        else{
          sunnyside_data[day,3] <- sunnyside_data[day,3] + 1
        }
      }
    }
  }
}

#averages eColi levels
for(i in 1:153){
  #checks how many available days of data there are
  total_days_available_data <- marie_curtis_data[i,2] + marie_curtis_data[i,3]
  if(total_days_available_data != 0){
    marie_curtis_data[i,1] <- marie_curtis_data[i,1]/total_days_available_data
  }
  
  total_days_available_data <- sunnyside_data[i,2] + sunnyside_data[i,3]
  if(total_days_available_data != 0){
    sunnyside_data[i,1] <- sunnyside_data[i,1]/total_days_available_data
  }
}

marie_curtis_clean_data <-
  tibble(
    #Use 1 through to 153 to represent each day
    "day" = 1:153,
    "eColi" = marie_curtis_data[,1],
    "yearsSafe" = marie_curtis_data[,2],
    "yearsUnSafe" = marie_curtis_data[,3]
  )

sunnyside_clean_data <-
  tibble(
    #Use 1 through to 153 to represent each day
    "day" = 1:153,
    "eColi" = sunnyside_data[,1],
    "yearsSafe" = sunnyside_data[,2],
    "yearsUnSafe" = sunnyside_data[,3]
  )

#creates csv file with cleaned data for each beach
write_csv(
  x = marie_curtis_clean_data,
  file = paste("outputs/data/marieCurtis.csv")
)

write_csv(
  x = sunnyside_clean_data,
  file = paste("outputs/data/sunnyside.csv")
)
