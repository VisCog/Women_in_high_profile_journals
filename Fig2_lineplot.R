#################
#Make Figure 2
#Shen et al. 2018
#BioRxiv
#################


#Set your working directory here
setwd("H:/PubMed1517")

#Read in NIH %female, with # female nature, science, and PNAS calculated
LineGraphTop3Journals <- read.csv("LineGraphTop3Journals.csv")

#filter to last author
data = LineGraphTop3Journals %>% filter(Type == "last_article")

#plot last author time series
last = ggplot(data = data, aes(x = Year, y = Percent, color = journal)) +
  geom_line() 

last + theme_bw() + scale_x_continuous(breaks=seq(2005,2017,1)) + ylim(0,50) +
  theme(axis.text=element_text(size=14),axis.title=element_text(size=14)) +
  labs(x = "Year", y = "Percent Female Last Author") + theme(legend.position= c(0.9,0.8)) + scale_colour_manual(name = "DATA SOURCE", values = c("red", "grey", "green4", "blue")) +
  theme(legend.title=element_text(size=12)) + theme(legend.text = element_text(size=12))

#filter to first author
data = LineGraphTop3Journals %>% filter(Type == "first_article")

#plot first author time series
first = ggplot(data = data, aes(x = Year, y = Percent, color = journal)) +
  geom_line() 

first + theme_bw() + scale_x_continuous(breaks=seq(2005,2017,1)) + ylim(0,50) +
  theme(axis.text=element_text(size=14),axis.title=element_text(size=14)) +
  labs(x = "Year", y = "Percent Female First Author") + theme(legend.position= c(0.9,0.2)) + scale_color_manual(name = "DATA SOURCE", values = c("red", "green4", "blue")) +
  theme(legend.title=element_text(size=12)) + theme(legend.text = element_text(size=12))
