
# import and prepare final dataset

# final data
data = read.csv("C:\\Users\\alena\\Documents\\UiO\\MCT\\Thesis\\R folder\\data.csv")
#View(data)

# create musicianship with JUST TWO LEVELS
data$music2 <- ifelse((data$music == "0" | data$music == "1"), "non-musician", 
                               ifelse((data$music == "2" | data$music == "3" |
                                         data$music == "4" | data$music == "5"), "musician", NA))

# make factors 
data[c("pnr", "music", "loss", "ex", "music2")] = lapply(data[c("pnr", "music", "loss", "ex", "music2")], factor)
str(data)

# make subset dataframe with the pnr, loss, music, empathy, r/f emotions for rep-measures ANOVA

data_long = data[,c(1, 4:6, 14, 17:24)]

# make factors before putting data into long format
data_long[c("pnr", "music", "loss", "ex")] = lapply(data_long[c("pnr", "music", "loss", "ex")], factor)
str(data_long)

# put data into long format with just condition and scores
library(tidyr)
data_long = gather(data_long, condition, ratings, r_happy:f_peaceful, 
                        factor_key=TRUE)
#View(data_long)

# split the condition column into 2 columns for emotion and F/R
data_long$emotion = ifelse((data_long$condition == "r_happy" | data_long$condition == "f_happy"), "happy", 
                                     ifelse((data_long$condition == "r_sad" | data_long$condition == "f_sad"), "sad",
                                           ifelse((data_long$condition == "r_scary" | data_long$condition == "f_scary"), "scary", 
                                                 ifelse((data_long$condition == "r_peaceful" | data_long$condition == "f_peaceful"), "peaceful", NA))))


data_long$felt_rec = ifelse((data_long$condition == "r_happy" | data_long$condition == "r_sad" | 
                                    data_long$condition == "r_scary" | data_long$condition == "r_peaceful"), "R", 
                                 ifelse((data_long$condition == "f_happy" | data_long$condition == "f_sad" |
                                           data_long$condition == "f_scary" | data_long$condition == "f_peaceful"), "F", NA))

# export long dataset to csv to check 
write.csv(data_long,"C:\\Users\\alena\\Documents\\UiO\\MCT\\Thesis\\R folder\\data_long.csv", row.names = FALSE)

# Remove condition column
data_long$condition = NULL 

data_long[c("pnr", "music", "loss", "ex", "emotion", "felt_rec")] = 
  lapply(data_long[c("pnr", "music", "loss", "ex", "emotion", "felt_rec")], factor)
str(data_long)


# create subset with the average over F/R for mixed ANOVAs

data_long_avg = data[,c(1, 4:6, 14, 25:28)]

# make factors before putting data into long format
data_long_avg[c("pnr", "music", "loss", "ex")] = 
  lapply(data_long_avg[c("pnr", "music", "loss", "ex")], factor)
str(data_long_avg)

# put data into long format with just condition and scores
library(tidyr)
data_long_avg = gather(data_long_avg, emotion, avg_ratings, avg_happy:avg_peaceful, 
                   factor_key=TRUE)

# Rename factor names 
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_happy"] <- "happy"
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_sad"] <- "sad"
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_scary"] <- "scary"
levels(data_long_avg$emotion)[levels(data_long_avg$emotion)=="avg_peaceful"] <- "peaceful"


# create musicianship, empathy, and loss binary variables
# create musicianship with JUST TWO LEVELS
data_long_avg$music2 <- ifelse((data_long_avg$music == "0" | data_long_avg$music == "1"), "non-musician", 
                       ifelse((data_long_avg$music == "2" | data_long_avg$music == "3" |
                                 data_long_avg$music == "4" | data_long_avg$music == "5"), "musician", NA))

# create empathy with JUST TWO LEVELS
data_long_avg$empathy2 <- ifelse(data_long_avg$empathy <= median(data_long_avg$empathy), "low empathy", 
                         ifelse(data_long_avg$empathy >= median(data_long_avg$empathy), "high empathy", NA))

# create hearing level with JUST TWO LEVELS
# add mild hearing loss to no hearing loss as well
data_long_avg$loss2 <- ifelse((data_long_avg$loss == "no" | data_long_avg$loss == "mild"), "hearing", "non-hearing")

# make the rest of the variables into factors
data_long_avg[c("music2", "loss2", "empathy2")] = lapply(data_long_avg[c("music2", "loss2", "empathy2")], factor)
str(data_long_avg)

# export long dataset to csv to be safe 
write.csv(data_long,"C:\\Users\\alena\\Documents\\UiO\\MCT\\Thesis\\R folder\\data_long_avg.csv", row.names = FALSE)


# create subsets for each type of excerpt so I can fit it in the later analysis

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
