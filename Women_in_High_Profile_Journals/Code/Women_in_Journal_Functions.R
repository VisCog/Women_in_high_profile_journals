# Women_in_Journal_Functions.R
#
# Collection of functions required to run the scripts:
#   PubMed_Genderized.R
#   PubMed_JoinData.R
#   Clean_Impact_Factor.R
#   Figure1_Scatter.R
#   Figure2_CalculateLineData.R
#   Figure2_Lineplot.R
#   Table1_Slopes.R

# Delete the shorter component in a first name that is seperated by space.  
remove_middle_name <- function(x) {
  output <- character(length(x))
  tmp <- strsplit(x[x != ""], split = " ")
  output[x != ""] <- sapply(tmp, function(x) x[which.max(nchar(x))])
  return(output)
}

# Genderize first names of first and last Authors (also writes to CSV)
extract_fnames <- function(file) {
  journal <- read.csv(file, stringsAsFactors = FALSE)
  journal$fname_first_trunc <- remove_middle_name(journal$fname_first)
  journal$fname_last_trunc  <- remove_middle_name(journal$fname_last)
  write.csv(journal, file, row.names = FALSE)
  return(with(journal, c(fname_first_trunc, fname_last_trunc)))
}

# Genderize first names returns NULL if warning or error
genderize_fnames <- function(fname, apikey = NULL) {
  out <- tryCatch({
    genderized <- findGivenNames(fname, textPrepare = FALSE, 
                                 apikey = apikey, progress = TRUE)
  }, warning = function(cond) return(NULL), 
  error = function(cond) return(NULL), 
  finally = NULL)
  return(out)
}

# Join genderized first name data with journal data
join_gender_fnames <- function(file, gender_data) {
  journal <- read.csv(file, stringsAsFactors = FALSE)
  
  # join genderized data with first author first names
  colnames(gender_data) <- c("fname_first_trunc", "gender_first", "p_first", "n_first")
  journal <- left_join(journal, gender_data, by = "fname_first_trunc")
  
  # join genderized data with last author first names
  colnames(gender_data) <- gsub("first", "last", colnames(gender_data))
  journal <- left_join(journal, gender_data, by = "fname_last_trunc")
  
  # subset to ensure no repeating columns of data
  colnames(journal) <- gsub("\\.(x|y)", "", colnames(journal))
  journal <- journal[, unique(colnames(journal))]
  write.csv(journal, file, row.names = FALSE)
}

# Get `journal_nae` Index within `all_journals`
get_journal_indx <- function(journal_name, all_journals) {
  return(which(tolower(journal_name) ==  tolower(all_journals)))
}

# Capitalizes the first character of a string
upper1 <- function(x) {
  return(paste0(toupper(substring(x,1,1)), substring(x,2)))
}

# Capitalizes words to proper case
to_proper_case <- function(x) {
  s <- strsplit(tolower(x), " ")[[1]] 
  indx <- sapply(s, function(x) any(x == c("and", "in", "of", "the")))
  s[!indx] = sapply(s[!indx], upper1)
  return(paste(s, collapse = " "))
}

# Calculate percentage female using female / (female + male)
percent_female <- function(x) mean(x == "female", na.rm = TRUE) * 100

# Calculate overall percentage female for first and last authors of a journal 
calculate_percent_female <- function(file) {
  journal <- read.csv(file, stringsAsFactors = FALSE)
  
  # filter to articles with abstract
  journal <- journal[as.logical(journal$abstract), ]
  
  # Calculate total number of entries used
  n_first <- sum(!is.na(journal$gender_first))
  n_last  <- sum(!is.na(journal$gender_last))
  
  # Calculate percentage female authors 
  female_first <- percent_female(journal$gender_first)
  female_last  <- percent_female(journal$gender_last)
  
  return(c(female_first = female_first, female_last = female_last, 
           n_first = n_first, n_last = n_last))
}

# Calculate percentage female authors by year
calculate_year_percent_female <- function(file) {
  journal <- read.csv(file, stringsAsFactors = FALSE)
  
  # filter to articles with abstract
  journal <- journal[as.logical(journal$abstract), ]
  
  # Calculate percentage female authors by year
  female_first <- with(journal, tapply(gender_first, year, percent_female))
  female_last  <- with(journal, tapply(gender_last, year, percent_female))
  
  return(data.frame(year = as.numeric(names(female_first)), female_first, 
                    female_last, journal = gsub(".*/", "", file)))
}

# Calculates the slope between first and last author female percentage
# as a function of year
calculate_percent_female_slope <- function(df) {
  mod_first <- summary(lm(female_first ~ year, df))
  mod_last  <- summary(lm(female_last  ~ year, df))
  slope_first <- coef(mod_first)["year", "Estimate"]
  slope_last  <- coef(mod_last) ["year", "Estimate"]
  return(c(slope_first = slope_first,
           slope_last  = slope_last))
}

# Imitates ggplot2's default color palatte
ggplot_color_ramp <- function(n) {
  hues <- seq(15, 375, length = n + 1)
  ramp <- hcl(h = hues, l = 65, c = 100)
  return(ramp[1:n])
}
