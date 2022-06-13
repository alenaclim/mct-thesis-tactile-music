
# This script contains the code for running the repeated-measures ANOVAs
# based on type of emotion and Felt/Rec. Additionally, it contains code for 
# checking the necessary assumptions, as well as post-hoc paired t-tests. 

#--------------------------------------------------------------------------------------------------------------------------

# Check assumptions

# Outliers

# function to identify outliers per excerpt
out_em_F_R <- function(temp_ex) {
  
  # return a tibble with identified outliers
  temp_ex %>%
    group_by(emotion, felt_rec) %>%
    identify_outliers(ratings) 
}

# identify outliers per excerpt
out_em_F_R(exH1)
out_em_F_R(exH2) # extreme outliers identified for felt and rec sadness
out_em_F_R(exP1)
out_em_F_R(exP2) # extreme outliers identified for felt sadness
out_em_F_R(exS1)
out_em_F_R(exS2)
out_em_F_R(exT1)
out_em_F_R(exT2) # extreme outliers identified for felt sadness

#----------------------------------------------------------------------------

# replace extreme outliers with the respective quantiles

# function to calculate quantiles and replace extreme outliers
library(scales)
extreme_out_replace <- function(temp_ex, temp_em, temp_FR) {
  
  # temporary dataframe 
  temp = as.data.frame(subset(temp_ex, (emotion == temp_em & felt_rec == temp_FR)))
  
  # calculate the quantiles for the ratings of only that subset
  quantiles <- round(quantile(temp$ratings, c(.05, .95 )))
  
  # squish the values of the ratings inside the quantiles
  temp$ratings <- squish(temp$ratings, quantiles)
 
  # for each value in the excerpt and the temporary dataframe, replace the values
  # that are outside the 5th and 95th quantile with the respective quantile 
  for (d in 1:nrow(temp_ex)) {
    for (s in 1:nrow(temp)) {
      
      if(temp_ex[d,"pnr"] == temp[s,"pnr"]) {
        if(temp_ex[d,"emotion"] == temp[s,"emotion"]) {
          if(temp_ex[d, "felt_rec"] == temp[s,"felt_rec"]) {
            
            # if the pnr, emotion and felt/rec is the same, transfer new ratings
            temp_ex[d, "ratings"] = temp[s,"ratings"]
            
          }
        }
      }
      
    }
  }
  
  # return the excerpt dataset with the replaced values
  return(temp_ex)
} 

# replace only the excerpts that had exteme outliers
exH2 <- extreme_out_replace(exH2, "sad", "F")
exH2 <- extreme_out_replace(exH2, "sad", "R")

exP2 <- extreme_out_replace(exP2, "sad", "F")

exT2 <- extreme_out_replace(exT2, "sad", "F")

#------------------------------------------------------------------------------------------------------------------------

# Normality

# shapiro test function
norm_em_F_R <- function(temp_ex) {
  
  # return a tibble with results of shapiro test per group
  temp_ex %>%
    group_by(emotion, felt_rec) %>%
    shapiro_test(ratings)
}

# test normality per excerpt
# p < 0.05 => NOT normal
norm_em_F_R(exH1)
norm_em_F_R(exH2)
norm_em_F_R(exP1)
norm_em_F_R(exP2)
norm_em_F_R(exS1)
norm_em_F_R(exS2)
norm_em_F_R(exT1)
norm_em_F_R(exT2)

#-----------------------------------------------------------------------------------------------------------------------

# Sphericity
# tested and adjusted when running the anova model, see below

#-----------------------------------------------------------------------------------------------------------------------

# Two-factors repeated measures ANOVAs
# the formula is y ~ w1*w2 + Error(id/(w1*w2))

# Bonferroni method used to adjust p-values for paired t-tests in post-hoc
# p-values are corrected for sphericity

#--------------------------------------------------------------------------

# scripts for functions


# function to run the ANOVA per excerpt
ANOVA_em_F_R <- function(temp_ex) {
  
  # run model
  anova_temp <- anova_test(
    data = temp_ex, dv = ratings, wid = pnr,
    within = c(emotion, felt_rec)
  )
  
  # display all anova and sphericity tables
  # anova_temp
  
  # display corrected scores for sphericity
  # these values were used in the report
  get_anova_table(anova_temp, correction = c("auto"))
  
}

# function to get post-hoc paired t-tests per excerpt for 1st factor (type of emotion)
ttest_em <- function(temp_avg_ex){
  
  # comparisons for type of emotion factor
  # use the average between felt/recognized
  temp_avg_ex %>%
    pairwise_t_test(
      avg_ratings ~ emotion, paired = TRUE, 
      p.adjust.method = "bonferroni"
    )
}

# function to get post-hoc paired t-tests per excerpt for 2nd factor (Felt/Rec)
ttest_F_R <- function(temp_ex){
  
  # comparisons for Felt/Rec scoring factor
  temp_ex %>%
    pairwise_t_test(
      ratings ~ felt_rec, paired = TRUE, 
      p.adjust.method = "bonferroni"
    )
}

# functions to get post-hoc paired t-tests per excerpt which has significant 
# interaction between factors

# Pairwise comparisons between type of emotion groups
ttest_inter_em <- function(temp_ex){ 
  
  temp_ex %>%
    group_by(emotion) %>%
    pairwise_t_test(
      ratings ~ felt_rec, paired = TRUE,
      p.adjust.method = "bonferroni"
    )
}

# Pairwise comparisons between felt_rec points
ttest_inter_F_R <- function(temp_ex){
  
  temp_ex %>%
    group_by(felt_rec) %>%
    pairwise_t_test(
      ratings ~ emotion, paired = TRUE,
      p.adjust.method = "bonferroni"
    )
}

#-----------------------------------------------------------------------------

# Run ANOVA and post-hoc tests per excerpt

ANOVA_em_F_R(exH1) # significant 2nd factor and interaction
ttest_F_R(exH1)
ttest_inter_em(exH1)
ttest_inter_F_R(exH1)

ANOVA_em_F_R(exH2) # significant 1st factor
ttest_em(avgH2)

ANOVA_em_F_R(exP1) # significant 1st and 2nd factor and interaction
ttest_em(avgP1)
ttest_F_R(exP1)
ttest_inter_em(exP1)
ttest_inter_F_R(exP1)

ANOVA_em_F_R(exP2) # significant 1st and 2nd factor and interaction
ttest_em(avgP2)
ttest_F_R(exP2)
ttest_inter_em(exP2)
ttest_inter_F_R(exP2)

ANOVA_em_F_R(exS1) # significant 1st factor and interaction
ttest_em(avgS1)
ttest_inter_em(exS1)
ttest_inter_F_R(exS1)

ANOVA_em_F_R(exS2) # significant 1st factor
ttest_em(avgS2)

ANOVA_em_F_R(exT1) # significant 1st factor and interaction
ttest_em(avgT1)
ttest_inter_em(exT1)
ttest_inter_F_R(exT1)

ANOVA_em_F_R(exT2) # significant 1st and 2nd factor and interaction
ttest_em(avgT2)
ttest_F_R(exT2)
ttest_inter_em(exT2)
ttest_inter_F_R(exT2)

