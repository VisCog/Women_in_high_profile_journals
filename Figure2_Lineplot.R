####################
# Make Figure 2
# Shen et al. (2018)
# BioRxiv
####################

# Clear workspace
rm(list = ls())

# Set working directory here
setwd("YourWorkingDirectory")

# Read in NIH %female, with # female nature, science, and PNAS calculated
top_journals <- read.csv("LineGraphTop3Journals.csv")
year_range <- min(top_journals$Year):max(top_journals$Year)

# Filter to last author type
last_author <- top_journals[article_type == "last_article", ]
# last_author <- top_journals %>% filter(Type == "last_article")

# plot last author time series
last <- ggplot(data = last_author, 
              aes(x = Year, 
                  y = Percent, 
                  color = journal)) +
  geom_line() +
  theme_bw() + 
  scale_x_continuous(breaks = year_range) + 
  labs(x = "Year", y = "Percent Female Last Author") +
  theme(axis.text = element_text(size = 14), 
        axis.title = element_text(size = 14), 
        legend.text = element_text(size = 12), 
        legend.title = element_text(size = 12),
        legend.position = c(0.9, 0.8)) +
  scale_colour_manual(name = "DATA SOURCE", 
                      values = c("red", "grey", "green4", "blue")) +
  ylim(0,50)

last

# Filter to first author
# first_author <- top_journals %>% filter(Type == "first_article")
first_author <- top_journals[article_type == "first_article", ]

# Plot first author time series
first <- ggplot(data = first_author, 
               aes(x = Year, 
                   y = Percent, 
                   color = journal)) +
  geom_line() +
  theme_bw() + 
  scale_x_continuous(breaks = year_range) + 
  labs(x = "Year", y = "Percent Female First Author") +
  theme(axis.text = element_text(size = 14), 
        axis.title = element_text(size = 14), 
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.position = c(0.9, 0.2)) +
  scale_color_manual(name = "DATA SOURCE", 
                     values = c("red", "green4", "blue")) +
  ylim(0, 50) 

first
