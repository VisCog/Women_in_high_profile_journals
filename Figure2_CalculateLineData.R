# Figure2_CalculateLineData.R

# Clear workspace
rm(list = ls()) 

# Load in functions
source("Women_in_Journal_Functions.R")

# State working directories
main_dir   <- "/Applications/GitHub/Women_In_high_profile_journal"
figure_dir <- file.path(main_dir, "Figure1")
save_dir   <- file.path(main_dir, "Figure2")

# State journals to be plotted on Figure 2 (line plot)
journal_names <- c("Science", "PNAS", "Nature")
journal_names <- file.path(figure_dir, journal_names)

# Calculate percent female by year
journal_percent <- lapply(journal_names, calculate_year_percent_female)
journal_percent <- do.call(rbind, journal_percent)

# Save journal percentage female by year data
save(journal_percent, file = file.path(save_dir, "Figure2_Lineplot.RData"))
