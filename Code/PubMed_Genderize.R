# PubMed_Genderize.R
# 
# Extracts all first names from journal CSV files to be "genderized" 
# with the `genderizeR` package.

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(genderizeR)
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir   <- "YourWorkingDirectory"
figure_dir <- file.path(main_dir, "..", "Figure1")

# Locate all the data .csv files
file_names <- list.files(figure_dir, pattern = "*.csv")
file_names <- file.path(figure_dir, file_names)

# Extract all first names (first and last authors)
# Remove duplicates and empty strings
# Convert to packaged lists of 200 names to prevent API timeout issues
all_fnames <- unlist(sapply(file_names, extract_fnames), use.names = FALSE)
all_fnames <- all_fnames[!duplicated(all_fnames) & all_fnames != ""]
all_fnames <- split(all_fnames, ceiling(seq_along(all_fnames)/200))

# Genderize first names, convert to data frame
gender_fnames <- lapply(all_fnames, genderize_fnames)
gender_fnames <- do.call(rbind, gender_fnames)
gender_fnames <- gender_fnames[order(gender_fnames$name), ]

# Save genderized first names data
save(gender_fnames, 
     file = file.path(figure_dir, "Genderized_First_Names.RData"))
