
# This script contains code for installing relevant packages, for importing and 
# preparing the data_descriptives.csv file to be used as a dataset, as well as 
# code for calculating means and SDs of different variables for reporting. 

#---------------------------------------------------------------------------------------------------------------------------

# install packages and add them in the library

# ggplot2 has to be loaded before psych, such that alpha gets overwritten
#install.packages("ggplot2") # visualisations
library(ggplot2)

#install.packages("psych") # psychometrics
library(psych)

#install.packages("doBy") # descriptives
library(doBy)

#install.packages("plyr")
library(plyr)

#install.packages("Rmisc")
library(Rmisc)

#install.packages("rstatix")
library(rstatix)

#install.packages("ggpubr")
library(ggpubr)

#install.packages("RColorBrewer")
library(RColorBrewer) # for color palettes 

#--------------------------------------------------------------------------------------------------------------------------

# Importing data for descriptive statistics
data_descriptives <- read.csv("C:\\Users\\alena\\Documents\\UiO\\MCT\\Thesis\\R folder\\data_descriptives.csv", 
                 stringsAsFactors = TRUE)
View(data_descriptives)


# create musicianship column with JUST TWO LEVELS
data_descriptives$music2 <- ifelse((data_descriptives$music == "0" | data_descriptives$music == "1"), "non-musician", 
                      ifelse((data_descriptives$music == "2" | data_descriptives$music == "3" |
                                data_descriptives$music == "4" | data_descriptives$music == "5"), "musician", NA))
# create hearing loss column with JUST TWO LEVELS
data_descriptives$loss2 <- ifelse((data_descriptives$loss == "no" | data_descriptives$loss == "mild"), 
                                  "hearing", "non-hearing")

# make relevant variables into factors 
data_descriptives[c("pnr", "music", "gen", "associations", "loss", "loss2", "music2")] = 
  lapply(data_descriptives[c("pnr", "music", "gen", "associations", "loss", "loss2", "music2")], factor)
str(data_descriptives)

#---------------------------------------------------------------------------------------------------------------------------

# descriptive statistics: mean and SD

# age 
mean_age <- mean(data_descriptives$age)
sd_age <- sd(data_descriptives$age)

# empathy (IRI index)
mean_empathy <- mean(data_descriptives$empathy)
sd_empathy <- sd(data_descriptives$empathy)
min_empathy <- min(data_descriptives$empathy)
max_empathy <- max(data_descriptives$empathy)


# descriptive statistics for empathy scores between groups 

# empathy based on hearing loss level and types of associations
summarySE(data_descriptives, measurevar="empathy", groupvars=c("loss2","associations"), 
          na.rm=TRUE, conf.interval = 0.95)

# empathy based on binary musicianship level and hearing loss level
summarySE(data_descriptives, measurevar="empathy", groupvars=c("music2","loss2"), 
          na.rm=TRUE, conf.interval = 0.95)

# empathy based on musicianship level and types of associations
summarySE(data_descriptives, measurevar="empathy", groupvars=c("music","associations"), 
          na.rm=TRUE, conf.interval = 0.95)

