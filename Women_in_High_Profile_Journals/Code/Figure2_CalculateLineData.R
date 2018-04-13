# Figure2_CalculateLineData.R

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(plyr)
source("Women_in_Journal_Functions.R")

# State working directories
main_dir   <- file.path("YourWorkingDirectory", "Code")
grant_dir  <- file.path(main_dir, "..", "NIH_RO1_Grant_Data")
figure_dir <- file.path(main_dir, "..", "Figure1")
save_dir   <- file.path(main_dir, "..", "Figure2")

# State journals to be plotted on Figure 2 (line plot)
journal_names <- c("Nature", "Science" , "PNAS")
journal_names <- file.path(figure_dir, paste0(journal_names, ".csv"))

# Calculate percent female by year
journal_percent <- lapply(journal_names, calculate_year_percent_female)
journal_percent <- do.call(rbind, journal_percent)
journal_percent$journal <- gsub(".csv", "", journal_percent$journal)

# Rename columns for later merging
column_names <- colnames(journal_percent)
column_names[column_names == "journal"] <- "source"
colnames(journal_percent) <- column_names

# Load NIH RO1 Grant Data
grant_data <- read.csv(file.path(grant_dir, "NIH_RO1_Grant.csv"), stringsAsFactors = FALSE)
grant_data <- grant_data[grant_data$Year >= min(journal_percent$year), ]

grant_percent <- data.frame(
  year = grant_data$Year, 
  female_last = as.numeric(gsub("%", "", grant_data$Percentage.to.Women)), 
  source = "NIH RO1 Grants"
)

# Combine journal and NIH RO1 grant data percent frames
women_percent <- rbind.fill(journal_percent, grant_percent)

# Save journal percentage and NIH RO1 Grant female by year data
save(women_percent, file = file.path(save_dir, "Figure2_Lineplot.RData"))
