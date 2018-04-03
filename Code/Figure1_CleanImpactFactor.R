# Figure1_CleanImpactFactor.R

# Clear workspace
rm(list = ls()) 

# Load in functions
source("Women_in_Journal_Functions.R")

# Declare the working directories
main_dir   <- file.path("YourWorkingDirectory", "Code")
data_dir   <- file.path(main_dir, "..", "Impact_Factor_Data")
figure_dir <- file.path(main_dir, "..", "Figure1")

# Read in all Thomas Reuters Impact Factor data
impact_file   <- file.path(data_dir, "Thomas_Reuters_Impact_Factor.csv")
all_impact_factor <- read.csv(impact_file, skip = 1, stringsAsFactors = FALSE)
all_impact_factor <- all_impact_factor[!duplicated(all_impact_factor$Full.Journal.Title), ]

# Specify journal names to extract
journal_names <- c(
  "Nature Reviews Neuroscience",
  "Nature Neuroscience",
  "Annual Review of Neuroscience",
  "Behavioral and Brain Sciences",
  "Neuron",
  "Trends in Neurosciences",
  "Brain",
  "Cerebral Cortex",
  "Neuropsychology Review",
  "Current Opinion in Neurobiology",
  "Journal of Neuroscience",
  "NeuroImage",
  "Nature",
  "Science",
  "Proceedings of the National Academy of Sciences of the United States of America"
)

# Extract Specified Journals
indx <- sapply(journal_names, get_journal_indx, all_impact_factor$Full.Journal.Title)
impact_factor <- all_impact_factor[indx, ]

# Keep only columns of interest and rename
keep_columns  <- c("Full.Journal.Title", "Journal.Impact.Factor", "X5.Year.Impact.Factor")
impact_factor <- impact_factor[, keep_columns]
colnames(impact_factor) <- c("journal", "impact_factor", "impact_factor_5_year")

# Reassign column classes
impact_factor$impact_factor <- as.numeric(impact_factor$impact_factor)
impact_factor$impact_factor_5_year <- as.numeric(impact_factor$impact_factor_5_year)

# Renames long journal names and to proper case
impact_factor$journal <- sapply(impact_factor$journal, to_proper_case)
indx <- impact_factor$journal == "Proceedings of the National Academy of Sciences of the United States of America"
impact_factor$journal[indx] <- "PNAS"
impact_factor$journal[impact_factor$journal == "Neuroimage"] <- "NeuroImage"

# Save Impact Factor Data
save(impact_factor, file = file.path(figure_dir, "Journal_Impact_Factor.RData"))
