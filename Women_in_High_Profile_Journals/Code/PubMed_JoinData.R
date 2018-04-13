# PubMed_JoinData.R
#
# Joins individual journal data with genderized first name data

# Clear workspace
rm(list = ls())

# Load in packages and functions
library(dplyr)
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir   <- file.path("YourWorkingDirectory", "Code")
figure_dir <- file.path(main_dir, "..", "Figure1")

# Locate all journal .csv files
file_names <- list.files(figure_dir, pattern = "*.csv")
file_names <- file.path(figure_dir, file_names)

# Load genderized first name data
load(file.path(figure_dir, "Genderized_First_Names.RData")) # gender_fnames

# Join journal data and genderized names
for (i in 1:length(file_names)) {
  join_gender_fnames(file_names[i], gender_fnames)
}
