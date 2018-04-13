# Figure1_Scatter.R
#
# Creates Figure 1 - Scatterplot
# Shen et al. (2018)

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(ggplot2)
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
scatter$number <- 1:nrow(scatter)

# Calculate Spearman Rank correlations between female first and last authors
# and journal impact factor
r_first <- with(scatter, cor(female_first, impact_factor_5_year, 
                             use = "complete.obs", method = "spearman"))
r_last  <- with(scatter, cor(female_last, impact_factor_5_year, 
                             use = "complete.obs", method = "spearman"))

# Scatterplot - Percentage Female First Authors ---------------------------

tiff(file.path(figure_dir, "Figure1_FirstAuthor.tiff"), 
     width = 6.5, height = 5, units = "in", res = 300)

scatter_first <-
  ggplot(scatter, aes(x = impact_factor_5_year, 
                      y = female_first, 
                      color = journal, 
                      label = number)) +
  theme_bw() + geom_point(size = 6) + 
  geom_text(color = "white", size = 4) + 
  theme(text = element_text(size = 14), 
        legend.position = "none") + 
  labs(x = "Impact Factor of Journal", 
       y = "Percentage Female First Author", 
       color = "Journals") +
 xlim(0, 50) + ylim(10, 55) 

print(scatter_first)
dev.off()

# Scatterplot - Percentage Female Last Author -----------------------------

tiff(file.path(figure_dir, "Figure1_LastAuthor.tiff"), 
     width = 6.5, height = 5, units = "in", res = 300)

scatter_last <-
  ggplot(scatter, aes(x = impact_factor_5_year, 
                      y = female_last, 
                      color = journal, 
                      label = number)) +
  theme_bw() + geom_point(size = 6) + 
  geom_text(color = "white", size = 4) + 
  theme(text = element_text(size = 14), 
        legend.position = "none") + 
  labs(x = "Impact Factor of Journal", 
       y = "Percentage Female Last Author", 
       color = "Journals") +
  xlim(0, 50) + ylim(10, 55) 

print(scatter_last)
dev.off()

# Legend ------------------------------------------------------------------

# Create legend position data frame
l <- data.frame(x = 0, y = rev(seq(0, 1, length.out = nrow(scatter))), 
                journal = scatter$journal, 
                number = 1:nrow(scatter))

tiff(file.path(figure_dir, "Figure1_Legend.tiff"), 
     width = 5, height = 7, units = "in", res = 300)

legend <- ggplot(l, aes(x = x, y = y, color = journal, label = journal)) + 
  geom_point(size = 6) + 
  geom_text(label = l$number, color = "white") +
  geom_text(x = 0.07, color = "black", size = 4, hjust = 0) +
  annotate("text", x = 0.07, y = 1.09, label = "Journals", size = 6) +
  theme(line = element_blank(), rect = element_blank(), 
        text = element_blank(), legend.position = "none") + 
  xlim(-0.5, 1) + ylim(-0.5, 1.5)

print(legend)
dev.off()
