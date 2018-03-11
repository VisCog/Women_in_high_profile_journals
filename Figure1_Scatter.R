####################
# Make Figure 1
# Shen et al. (2018)
# BioRxiv
####################

# Clear workspace
rm(list = ls()) 

# Load packages
library(dplyr)
library(ggplot2)
library(readr)
library(ggrepel)

# Set your folder name here 
setwd("YourWorkingDirectory")

# Read in names of data files in folder
filenames <- list.files(pattern = "*.csv")

# Reformat journal names
journal <- filenames %>% gsub(".csv", "", .) %>% gsub("_", " ", .) %>% toupper()

############ Calculating female author/(female author + male author) for all journals ############

filter_file <- function(filename) {
  file <- read.csv(filename, stringsAsFactors = FALSE)
  
  # filter to articles with abstract
  file <- file %>% filter(Abstract == 1)
  # file <- file[file$abstract ]

  # Create tables for first and last female author counts
  table_first <- table(file$gender_first)
  table_last <- table(file$gender_last)

  # Calculate total number of entries
  total_n <- table_first["male"] + table_first["female"]
  
  # Calculate percentage female 
  female_first <- round(table_first["female"] / total_n * 100, 2)
  female_last <- round(table_last["female"] / (table_last["male"] + table_first["female"]) * 100, 2)
  
  return(c(female_first, female_last, total_n))
}

# Create data frame with percent female information
percent_female = data.frame(unname(t(sapply(filenames, filter_file))))
colnames(percent_female) <- c("female_first", "female_last", "total_n")
percent_female$journal <- journal

############ Merging with Journal Impact Factor ############

# Set your folder name here 
setwd("/Applications/GitHub/Women_In_high_profile_journal/")
impact_factor <- read.csv("ThomasReutersImpactFactor.csv", stringsAsFactors = FALSE)

# Merge with percentage female, to make scatter dataset
scatter <- merge(impact_factor, percent_female, by = "journal", all = TRUE)

# Change journal title to sentence case
scatter$journal <- gsub("(\\w)(\\w*)", "\\U\\1\\L\\2", scatter$journal, perl = TRUE)

# ############ Scatterplot for First Authors ############

first <- ggplot(data = scatter, 
                aes(x = impact_5, 
                    y = female_first, 
                    color = journal, 
                    label = journal, 
                    size = total_n * 10)) + 
  theme_bw() + 
  geom_point(alpha = 0.5) + 
  scale_size(range = c(5, 50)) + 
  geom_text_repel(aes(label = journal), size = 6) + 
  theme(axis.text=element_text(size = 14), 
        axis.title=element_text(size = 14), 
        legend.position = "none") + 
  labs(x = "Impact Factor of Journal", 
       y = "Percentage Female First Author") + 
  ylim(10, 55) + 
  xlim(5, 47) 

first

with(scatter, cor(female_first, impact_5, use = "complete.obs", method = "spearman"))

# ############ Scatterplot for Last Authors ############

last <- ggplot(scatter, 
               aes(x = impact_5, 
                   y = female_last, 
                   color = journal, 
                   label = journal, 
                   size = total_n * 10)) +
  theme_bw() +
  geom_point(alpha = 0.5) + 
  scale_size(range = c(5, 50)) + 
  geom_text_repel(aes(label = journal), size = 6) + 
  theme(axis.text = element_text(size = 14), 
        axis.title = element_text(size = 14), 
        legend.position = "none") + 
  labs(x = "Impact Factor of Journal",
       y = "Percentage Female Last Author") +
  ylim(10, 55) + 
  xlim(5, 47)

last

with(scatter, cor(female_last, impact_5, use = "complete.obs", method = "spearman"))
