# Figure2_Lineplot.R

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(dplyr)
library(ggplot2)
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir   <- file.path("YourWorkingDirectory", "Code")
figure_dir <- file.path(main_dir, "..", "Figure2")

# Load in percentage female line plot data
load(file.path(figure_dir, "Figure2_Lineplot.RData")) # women_percent
year_range <- min(women_percent$year):max(women_percent$year)
graph_colors <- c("Nature" = "red", "Science" = "blue", 
                  "PNAS" = "green4", "NIH RO1 Grants" = "grey")

# Figure2a - Percent Female First Author ----------------------------------

tiff(file.path(figure_dir, "Figure2_FirstAuthor.tiff"), 
     width = 8, height = 5.5, units = "in", res = 300)

# Plot first author time series
line_first <- 
  women_percent %>% 
  filter(source != "NIH RO1 Grants") %>%
  ggplot(aes(x = year, 
             y = female_first, 
             color = source)) +
  geom_line() + geom_point() + theme_bw() + 
  scale_x_continuous(breaks = year_range) + 
  scale_colour_manual(name = "DATA SOURCE", 
                      values = graph_colors) +
  labs(x = "Year", y = "Percent Female First Author") +
  theme(text = element_text(size = 14), 
        title = element_text(size = 16),
        legend.position = c(0.85, 0.15),
        legend.box.background = element_rect()) +
  ylim(0, 50) 

print(line_first)
dev.off()

# Figure 2b - Percent Female Last Author ----------------------------------

tiff(file.path(figure_dir, "Figure2_LastAuthor.tiff"), 
     width = 8, height = 5.5, units = "in", res = 300)

# plot last author time series
line_last <- 
  ggplot(women_percent, 
         aes(x = year, 
             y = female_last, 
             color = source)) +
  geom_line() + geom_point() + theme_bw() + 
  scale_x_continuous(breaks = year_range) + 
  scale_colour_manual(name = "DATA SOURCE", 
                      values = graph_colors) +
  labs(x = "Year", y = "Percent Female First Author") +
  theme(text = element_text(size = 14), 
        title = element_text(size = 16),
        legend.position = c(0.85, 0.85), 
        legend.box.background = element_rect()) +
  ylim(0, 50)

print(line_last)
dev.off()
