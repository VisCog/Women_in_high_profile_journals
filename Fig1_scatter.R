#################
#Make Figure 1
#Shen et al. 2018
#BioRxiv
#################

library(dplyr)
library(ggplot2)
library(readr)
library(ggrepel)

#Set your folder name here 
setwd("H:/PubMed1517")

#read in names of data files in folder
filenames<-list.files(pattern="*.csv")

############Calculating female author/(female author + male author) for all journals############

#initialize
female_1st<-NULL
female_last<-NULL
percent_female<-NULL
total_n<-NULL


#loop through all files
for (k in 1:length(filenames)) {
  
  file <- read_csv(filenames[k])
  
  #filter to articles with abstract 
  file <-file %>% filter(Abstract == 1)
  

  for (i in 1:length(file$Journal)) {
    if (is.na(file$Gender_1st[i])) {
      file$Gender_1st[i]<-"Unknown"    
    }
  
    if (is.na(file$Gender_last[i])) {
      file$Gender_last[i]<-"Unknown"    
    }
    
    #check if last author was missing in the original entry (single author paper)
    if (is.na(file$FName_last_Truncate[i])) {
      file$Gender_last[i]<-"SingleAuthor"    
    }
  }
  
  file$Year<-as.numeric(as.character((file$Year)))
  
  #name levesl
  file$Gender_last<-factor(file$Gender_last,levels=c("Unknown","SingleAuthor","male","female"))
  file$Gender_1st<-factor(file$Gender_1st,levels=c("Unknown","male","female"))
  
  #calculate percentage female 
  female_1st<-round(table(file$Gender_1st)[3]/(table(file$Gender_1st)[2]+table(file$Gender_1st)[3])*100,digits=2)
  female_last<-round(table(file$Gender_last)[4]/(table(file$Gender_last)[3]+table(file$Gender_last)[4])*100,digits=2)
  
  #calculate total number of entry
  total_n<-table(file$Gender_1st)[2]+table(file$Gender_1st)[3]
  
  percent_female<-rbind(percent_female,cbind(female_1st,female_last,total_n,gsub(".csv","",filenames[k])))
  
}

#Change variable type for plotting
colnames(percent_female)[4]<-"Journal"
percent_female<-as.data.frame(percent_female)
percent_female$Journal<-as.character(percent_female$Journal)

#Change file names to journal names, to merge with keys in journal impact factor
percent_female <- 
  percent_female %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Annual_Review_Neuro", "ANNUAL REVIEW OF NEUROSCIENCE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Behavioral_and_brain_sciences", "BEHAVIORAL AND BRAIN SCIENCES")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Brain", "BRAIN")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Cerebral_cortex", "CEREBRAL CORTEX")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Current_op_neuro", "CURRENT OPINION IN NEUROBIOLOGY")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_J_of_Neuro", "JOURNAL OF NEUROSCIENCE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Nature", "NATURE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Nature_Neuro", "NATURE NEUROSCIENCE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Nature_Review_of_Neuroscience", "NATURE REVIEWS NEUROSCIENCE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_NeuroImage", "NEUROIMAGE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Neuron", "NEURON")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_PNAS", "PNAS")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Science", "SCIENCE")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Trends_in_neurosciences", "TRENDS IN NEUROSCIENCES")) %>%
  mutate(Journal = replace(Journal, Journal=="Total_Processed_Neuropsychology_review", "NEUROPSYCHOLOGY REVIEW")) %>%
  as.data.frame()


############Merging with Journal Impact Factor############

ImpactFactor <- read_csv("ThomasReutersImpactFactor.csv")

#merge with percentage female, make scatter dataset
scatter<-merge(ImpactFactor,percent_female,by=c("Journal"),all=TRUE)

#change numbers to numeric
scatter$female_1st <-as.numeric(as.character(scatter$female_1st))
scatter$female_last<-as.numeric(as.character(scatter$female_last))
scatter$total_n    <-as.numeric(as.character(scatter$total_n))

#Change journal title to sentence case
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), tolower(substring(s, 2)),
        sep="", collapse=" ")
}

scatter$Journal<-sapply(as.character(scatter$Journal),simpleCap)
scatter$Journal<-as.factor(scatter$Journal)

############Scatterplot for First Authors############

first <-ggplot(scatter, aes(x= as.numeric(Impact5year), y= as.numeric(female_1st),color=Journal, label=Journal, size = total_n*10))+
  geom_point(alpha=0.5) + scale_size(range = c(5, 50)) + geom_text_repel(aes(label=Journal), size=6) + ylim(10, 55) + xlim(5, 47) +
  theme_bw() + theme(axis.text=element_text(size=14),axis.title=element_text(size=14)) + labs(x = "Impact Factor of Journal", y = "Percentage Female First Author") + theme(legend.position= "none")
first

cor(scatter$female_1st,scatter$Impact5year,method = c("spearman"))


############Scatterplot for last Authors############


last <-ggplot(scatter, aes(x= as.numeric(Impact5year), y= as.numeric(female_last),color=Journal, label=Journal, size = total_n*10))+
  geom_point(alpha=0.5) + scale_size(range = c(5, 50)) + geom_text_repel(aes(label=Journal), size=6) + ylim(10, 55) + xlim(5, 47) +
  theme_bw() + theme(axis.text=element_text(size=14),axis.title=element_text(size=14)) + labs(x = "Impact Factor of Journal", y = "Percentage Female Last Author") + theme(legend.position= "none")
last

cor(scatter$female_last,scatter$Impact5year,method = c("spearman"))


####################################################
############Scatterplot Legacy Version############
####################################################

q<-ggplot(scatter, aes(x= Impact, y= female_last,color=Journal))+
  geom_point(size=7) +  ylim(10, 45) +
  theme_bw() + theme(axis.text=element_text(size=14),axis.title=element_text(size=14)) + labs(x = "Impact Factor of Journal", y = "Percentage Female Last Author") 
q + theme(legend.position= "none")
