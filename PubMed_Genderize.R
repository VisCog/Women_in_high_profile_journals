####################
# Genderize.io
# Shen et al. (2018)
# BioRxiv
####################

library(dplyr)
library(ggplot2)
library(scales)
library(data.table)
library(readr)
install.packages("devtools")
devtools::install_github("kalimu/genderizeR")
library(genderizeR)

setwd("YourWorkingDirectory")

temp<-list.files(pattern="*.csv")

##Process all the files in the folder
##Note: Journal name might need eyeballing!!

for (k in 1:length(temp)) {
  
    file <- read_csv(temp[k])
   
    ##This part needs manual eyeballing, pick the journal that is your journal of interest, rather than the one with the highest frequency
    ##Automatically resort to the most frequent name
    
    sort(table(file$Journal),decreasing=TRUE)[1:10]
    
    #Change to subset to your journal of interest
    top_name<-names(sort(table(file$Journal),decreasing=TRUE))[1]
    top_name
    
    file <- file %>% filter(Journal == top_name)
  
    ##Delete cases without first name
    
    file_filtered <- file %>% dplyr::filter(file$FName_1st!="")
    
    file_filtered$FName_1st<-as.character(file_filtered$FName_1st)
    file_filtered$FName_last<-as.character(file_filtered$FName_last)
    
    ##Function to Delete Middle Initials
    ##Delete the shorter component in a first name, seperated by space.  
    
    TruncateName<-function(input) {
      a<-unlist(strsplit(input,split=" "))
      b<-unlist(lapply(a,nchar))
      c<-a[which.max(b)]
      return(c)
    }
    
    ##Truncate the first names of first author
    file_filtered$FName_1st_Truncate<-NA
    
    for (i in 1:length(file_filtered$FName_1st)) {
      file_filtered$FName_1st_Truncate[i] <- TruncateName(file_filtered$FName_1st[i])
      print(i)
    }
    
    ##Truncate the first names of last author
    
    file_filtered$FName_last_Truncate<-NA
    
    for (i in 1:length(file_filtered$FName_last)) {
      if (is.na(file_filtered$FName_last[i])) {
        file_filtered$FName_last_Truncate[i] <- "" }
      else {
        file_filtered$FName_last_Truncate[i] <- TruncateName(file_filtered$FName_last[i])}
      print(i)
    }
    
    #First Author
    file_filtered$given_name_first<-NULL
    given_name_first = findGivenNames(file_filtered$FName_1st_Truncate,textPrepare=FALSE,apikey="YourAPIKey",progress=TRUE)
    #Pull all unique first authors
    given_name_first<-given_name_first[!duplicated(given_name_first),]
    #Left join to original file
    colnames(given_name_first)[1]<-"FName_1st_Truncate"
    file_filtered<-dplyr::left_join(file_filtered,given_name_first,by="FName_1st_Truncate")
    
    #Change generic column names to indicate first authorship
    colnames(file_filtered)[15]<-"Gender_1st"
    colnames(file_filtered)[16]<-"Probability_1st"
    colnames(file_filtered)[17]<-"Count_1st"
    
    #Last Author
    file_filtered$given_name_last<-NULL
    FName_last_Truncate<-dplyr::filter(file_filtered,FName_last_Truncate!="")$FName_last_Truncate
    given_name_last = findGivenNames(FName_last_Truncate,textPrepare=FALSE,apikey="YourAPIKey",progress=TRUE)
    #Pull all unique last authors
    given_name_last<-given_name_last[!duplicated(given_name_last),]
    #Left join to original file
    colnames(given_name_last)[1]<-"FName_last_Truncate"
    file_filtered<-dplyr::left_join(file_filtered,given_name_last,by="FName_last_Truncate")
    
    
    #Change generic column names to indicate last authorship
    colnames(file_filtered)[18]<-"Gender_last"
    colnames(file_filtered)[19]<-"Probability_last"
    colnames(file_filtered)[20]<-"Count_last"
  
    write.csv(file_filtered,paste("Processed_",temp[k],sep=""))

}


