# Figure1_Scatter.R
#
# Creates Figure 1 - Scatterplot
# Shen et al. (2018)

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(ggplot2)
library(ggrepel)
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir   <- file.path("YourWorkingDirectory", "Code")
figure_dir <- file.path(main_dir, "..", "Figure1")

# Locate all journal .csv files
file_names <- list.files(figure_dir, pattern = "*.csv")

# Create data frame with percent female information
percent_female <- lapply(file.path(figure_dir, file_names), 
                         calculate_percent_female)
percent_female <- data.frame(do.call(rbind, percent_female))
percent_female$journal <- gsub("_", " ", gsub(".csv", "", file_names))

# Read in impact factor data 
load(file.path(figure_dir, "Journal_Impact_Factor.RData")) # impact_factor

# Merge percentage female  with impact factor data to make scatterplot dataset
scatter <- merge(impact_factor, percent_female, by = "journal", all = TRUE)

# Calculate Spearman Rank correlations between female first and last authors
# and journal impact factor
r_first <- with(scatter, cor(female_first, impact_factor_5_year, 
                             use = "complete.obs", method = "spearman"))
r_last  <- with(scatter, cor(female_last, impact_factor_5_year, 
                             use = "complete.obs", method = "spearman"))

# Scatterplot - Percentage Female First Authors ---------------------------

scatter_first <- ggplot(data = scatter, 
                        aes(x = impact_factor_5_year, 
                            y = female_first, 
                            color = journal, 
                            size = n_first)) + 
  theme_bw() + 
  geom_point(alpha = 0.35) + 
  scale_size(range = c(5, 35)) +
  geom_text_repel(aes(label = journal), size = 5) + 
  theme(text = element_text(size = 14),  
        legend.position = "none") + 
  labs(x = "Impact Factor of Journal", 
       y = "Percentage Female First Author") + 
  ylim(10, 55) + xlim(0, 50) 

scatter_first

# Scatterplot - Percentage Female Last Author -----------------------------

scatter_last <- ggplot(scatter, 
                       aes(x = impact_factor_5_year, 
                           y = female_last, 
                           color = journal, 
                           size = n_last)) +
  theme_bw() +
  geom_point(alpha = 0.35) + 
  scale_size(range = c(5, 35)) + 
  geom_text_repel(aes(label = journal), size = 5) + 
  theme(text = element_text(size = 14), 
        legend.position = "none") + 
  labs(x = "Impact Factor of Journal",
       y = "Percentage Female Last Author") +
  ylim(10, 55) + xlim(0, 50)

scatter_last
