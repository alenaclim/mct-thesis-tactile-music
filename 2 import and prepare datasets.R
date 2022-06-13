
# This script contains code for importing and preparing the entire dataset to be
# used later for analysis. Additional subsets of the data are created and prepared
# for later analysis, visualizations and reporting.

#--------------------------------------------------------------------------------------------------------------------------

# import and prepare dataset
data = read.csv("C:\\Users\\alena\\Documents\\UiO\\MCT\\Thesis\\R folder\\data.csv")
#View(data)

# create musicianship column with JUST TWO LEVELS
data$music2 <- ifelse((data$music == "0" | data$music == "1"), "non-musician", 
                   ifelse((data$music == "2" | data$music == "3" |
                       data$music == "4" | data$music == "5"), "musician", NA))

# make relevant variables into factors
data[c("pnr", "music", "loss", "ex", "music2")] = lapply(data[c("pnr", "music", 
                        "loss", "ex", "music2")], factor)
str(data)

#--------------------------------------------------------------------------------------------------------------------------

# make subset of entire dataframe for repeated-measures ANOVAs
# data has to be in long format to perform the ANOVAs 

# the subset contains the pnr, loss, music, empathy, rec/felt emotions columns
data_long = data[,c(1, 4:6, 14, 17:24)]

# make factors before transforming data into long format
data_long[c("pnr", "music", "loss", "ex")] = lapply(data_long[c("pnr", "music", 
                              "loss", "ex")], factor)
str(data_long)

# transform data into long format with just condition and scores
#install.packages("tidyr")
library(tidyr)
data_long = gather(data_long, condition, ratings, r_happy:f_peaceful, 
                        factor_key=TRUE)
#View(data_long)

# split the condition column into 2 columns: emotion and if it was Felt/Rec
data_long$emotion = ifelse((data_long$condition == "r_happy" | data_long$condition == "f_happy"), "happy", 
                    ifelse((data_long$condition == "r_sad" | data_long$condition == "f_sad"), "sad",
                    ifelse((data_long$condition == "r_scary" | data_long$condition == "f_scary"), "scary", 
                    ifelse((data_long$condition == "r_peaceful" | data_long$condition == "f_peaceful"), "peaceful", NA))))


data_long$felt_rec = ifelse((data_long$condition == "r_happy" | data_long$condition == "r_sad" | 
                              data_long$condition == "r_scary" | data_long$condition == "r_peaceful"), "R", 
                     ifelse((data_long$condition == "f_happy" | data_long$condition == "f_sad" |
                              data_long$condition == "f_scary" | data_long$condition == "f_peaceful"), "F", NA))

# remove condition column, it will not be needed anymore
data_long$condition = NULL 

# make all relevant variables into factors
data_long[c("pnr", "music", "loss", "ex", "emotion", "felt_rec")] = 
  lapply(data_long[c("pnr", "music", "loss", "ex", "emotion", "felt_rec")], factor)
str(data_long)

#--------------------------------------------------------------------------------------------------------------------------

# create subset of entire dataset for mixed-measures ANOVAs
# the subset has to be in long format to perform ANOVAs
# emotions' scores are averaged over Felt/Rec

data_long_avg = data[,c(1, 4:6, 14, 25:28)]

# make factors before transforming  data into long format
data_long_avg[c("pnr", "music", "loss", "ex")] = 
  lapply(data_long_avg[c("pnr", "music", "loss", "ex")], factor)
str(data_long_avg)

# transform data into long format with just condition and scores columns 
library(tidyr)
data_long_avg = gather(data_long_avg, emotion, avg_ratings, avg_happy:avg_peaceful, 
                   factor_key=TRUE)

# Rename factor names for clarity and visualizations 
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_happy"] <- "happy"
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_sad"] <- "sad"
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_scary"] <- "scary"
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_peaceful"] <- "peaceful"


# create binary variables for musicianship, empathy, and hearing loss 
# for visualizations and reporting

# create musicianship column with JUST TWO LEVELS
data_long_avg$music2 <- ifelse((data_long_avg$music == "0" | data_long_avg$music == "1"), "non-musician", 
                        ifelse((data_long_avg$music == "2" | data_long_avg$music == "3" |
                                 data_long_avg$music == "4" | data_long_avg$music == "5"), "musician", NA))

# create empathy column with JUST TWO LEVELS
data_long_avg$empathy2 <- ifelse(data_long_avg$empathy <= median(data_long_avg$empathy), "low empathy", 
                          ifelse(data_long_avg$empathy >= median(data_long_avg$empathy), "high empathy", NA))

# create hearing loss level with JUST TWO LEVELS
# add mild hearing loss to no hearing loss category
data_long_avg$loss2 <- ifelse((data_long_avg$loss == "no" | data_long_avg$loss == "mild"), "hearing", "non-hearing")

# make the rest of the relevant variables into factors
data_long_avg[c("music2", "loss2", "empathy2")] = lapply(data_long_avg[c("music2", "loss2", "empathy2")], factor)
str(data_long_avg)

#--------------------------------------------------------------------------------------------------------------------------

# create individual subsets for each excerpt for later analysis and visualizations

# create exH1, exH2... from data_long
exH1 <- as.data.frame(subset(data_long, ex == "H1"))
exH2 <- as.data.frame(subset(data_long, ex == "H2"))
exP1 <- as.data.frame(subset(data_long, ex == "P1"))
exP2 <- as.data.frame(subset(data_long, ex == "P2"))
exS1 <- as.data.frame(subset(data_long, ex == "S1"))
exS2 <- as.data.frame(subset(data_long, ex == "S2"))
exT1 <- as.data.frame(subset(data_long, ex == "T1"))
exT2 <- as.data.frame(subset(data_long, ex == "T2"))

# create avgH1, avgH2... from data_long_avg
avgH1 <- as.data.frame(subset(data_long_avg, ex == "H1"))
avgH2 <- as.data.frame(subset(data_long_avg, ex == "H2"))
avgP1 <- as.data.frame(subset(data_long_avg, ex == "P1"))
avgP2 <- as.data.frame(subset(data_long_avg, ex == "P2"))
avgS1 <- as.data.frame(subset(data_long_avg, ex == "S1"))
avgS2 <- as.data.frame(subset(data_long_avg, ex == "S2"))
avgT1 <- as.data.frame(subset(data_long_avg, ex == "T1"))
avgT2 <- as.data.frame(subset(data_long_avg, ex == "T2"))

