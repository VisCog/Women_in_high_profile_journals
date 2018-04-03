# Table1_Slopes.R
#
# Calculates Table 1 - Slopes
# Shen et al. (2018)

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(tidyr)
library(stringr)
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir <- getwd()
# main_dir   <- file.path("YourWorkingDirectory", "Code")
figure_dir <- file.path(main_dir, "..", "Figure1")

# Locate all journal .csv files
file_names <- list.files(figure_dir, pattern = "*.csv")
file_names <- file.path(figure_dir, file_names)

# Calculate percent female by year
journal_percent <- lapply(file_names, calculate_year_percent_female)
journal_percent <- do.call(rbind, journal_percent)
journal_percent$journal <- gsub("_", " ", gsub(".csv", "", journal_percent$journal))

# Table 1 -----------------------------------------------------------------

table_percent <- split(journal_percent, journal_percent$journal)
table1 <- data.frame(t(sapply(table_percent, calculate_percent_female_slope)))

# Supplementary Figures ---------------------------------------------------

# Transforming data for plotting
year_range <- with(journal_percent, seq(min(year), max(year), 2))
journal_line <- gather(journal_percent, percent_author, percent, female_first, female_last)
journal_line$journal <- str_wrap(journal_line$journal, 1)
journal_line$percent_author <- factor(journal_line$percent_author, 
                                      labels = c("Author First", 
                                                 "Author Last"))

# Plot Journal by First and Last Author Supplmentary Figure
ggplot(journal_line, 
       aes(x = year, y = percent, color = percent_author)) +
  geom_line(linetype = "dashed", alpha = 0.5) +
  geom_point(alpha = 0.5) + theme_bw() + ylim(0, 75) + 
  geom_smooth(method = lm, se = FALSE) +
  scale_x_continuous(breaks = year_range) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), 
        legend.position = "none") +
  labs(x = "Year", y = "Percent Female Author") + 
  facet_grid(percent_author ~ journal)
