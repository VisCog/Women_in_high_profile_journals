# Figure2_Lineplot.R

# Clear workspace
rm(list = ls()) 

# Load in packages and functions
library(ggplot2)
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir   <- file.path("YourWorkingDirectory", "Code")
figure_dir <- file.path(main_dir, "..", "Figure2")

# Load in percentage female line plot data
load(file.path(figure_dir, "Figure2_Lineplot.RData")) # journal percent
year_range <- min(journal_percent$year):max(journal_percent$year)

# Figure2a - Percent Female First Author ----------------------------------

# Plot first author time series
line_first <- ggplot(journal_percent, 
               aes(x = year, 
                   y = female_first, 
                   color = journal)) +
  geom_errorbar(aes(ymin = female_first - sd_first, 
                    ymax = female_first + sd_first), 
                width = 0.1) + 
  geom_line() + geom_point() + theme_bw() + 
  scale_x_continuous(breaks = year_range) + 
  labs(x = "Year", y = "Percent Female First Author") +
  theme(text = element_text(size = 14), 
        title = element_text(size = 16),
        legend.position = c(0.85, 0.15),
        legend.box.background = element_rect()) +
  scale_color_manual(name = "DATA SOURCE", 
                     values = c("red", "green4", "blue")) +
  ylim(0, 50) 

line_first

# Figure 2b - Percent Female Last Author ----------------------------------

# plot last author time series
line_last <- ggplot(journal_percent, 
               aes(x = year, 
                   y = female_last, 
                   color = journal)) +
  geom_errorbar(aes(ymin = female_last - sd_last, 
                    ymax = female_last + sd_last), 
                width = 0.1) + 
  geom_line() + geom_point() + theme_bw() + 
  scale_x_continuous(breaks = year_range) + 
  labs(x = "Year", y = "Percent Female Last Author") +
  theme(text = element_text(size = 14), 
        title = element_text(size = 16),
        legend.position = c(0.85, 0.85), 
        legend.box.background = element_rect()) +
  scale_colour_manual(name = "DATA SOURCE", 
                      values = c("red", "grey", "green4", "blue")) +
  ylim(0, 50)

line_last
