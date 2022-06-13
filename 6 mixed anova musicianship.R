
# This script contains the code for running the mixed-measures ANOVAs
# based on emotions' score averaged over Felt/Rec scores and musicianship level. 
# Code for visualizing the data grouped in boxplots in a grid is also here.
# The binary musicianship variable is used here, as there are too little people
# in each musicianship category otherwise. Additionally, it contains code for 
# checking the necessary assumptions, as well as post-hoc paired t-tests. 

#--------------------------------------------------------------------------------------------------------------------------

# Summarize data by musicianship level

sum_em_music <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(music2, emotion) %>%
    get_summary_stats(avg_ratings, type = "mean_sd")
}

sum_em_music(avgH1)
sum_em_music(avgH2)
sum_em_music(avgP1)
sum_em_music(avgP2)
sum_em_music(avgS1)
sum_em_music(avgS2)
sum_em_music(avgT1)
sum_em_music(avgT2)

#--------------------------------------------------------------------------------------------------------------------------

# Visualize with box plots

plot_music2_H1 <- ggboxplot(
  avgH1, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_H2 <- ggboxplot(
  avgH2, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_P1 <- ggboxplot(
  avgP1, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_P2 <- ggboxplot(
  avgP2, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_S1 <- ggboxplot(
  avgS1, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_S2 <- ggboxplot(
  avgS2, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_T1 <- ggboxplot(
  avgT1, x = "emotion", y = "avg_ratings", color = "music2")

plot_music2_T2 <- ggboxplot(
  avgT2, x = "emotion", y = "avg_ratings", color = "music2")

# put it in a grid 4 x 2
boxplot_grid_music2 = ggarrange(plot_music2_H1, plot_music2_H2, plot_music2_P1, plot_music2_P2, 
                              plot_music2_S1, plot_music2_S2, plot_music2_T1, plot_music2_T2, 
                              labels = c("H1", "H2", "P1", "P2", "S1", "S2", "T1", "T2"),
                              common.legend = TRUE, 
                              legend = "bottom",
                              ncol = 2, nrow = 4, align = "v")

# visualize and export in the interface
boxplot_grid_music2

#--------------------------------------------------------------------------------------------------------------------------

# Check assumptions

# Outliners

# function to identify outliers per excerpt
out_em_music <- function(temp_avg_ex) {
  
  # return a tibble with identified outliers
  temp_avg_ex %>%
    group_by(music2, emotion) %>%
    identify_outliers(avg_ratings)
}

# identify outliers per excerpt
out_em_music(avgH1)
out_em_music(avgH2) # extreme outliers identified for scariness in non-musicians
out_em_music(avgP1)
out_em_music(avgP2)
out_em_music(avgS1)
out_em_music(avgS2) # extreme outliers identified for peacefulness in musicians
out_em_music(avgT1) # extreme outliers identified for scariness in non-musicians
out_em_music(avgT2)

#----------------------------------------------------------------------------

# replace extreme outliers with the respective quantiles

# function to calculate quantiles and replace extreme outliers
library(scales)
extreme_out_replace_music <- function(temp_avg_ex, temp_em, temp_music) {
  
  # temporary dataframe
  temp = as.data.frame(subset(temp_avg_ex, (emotion == temp_em & music2 == temp_music)))
  
  # calculate the quantiles for the avg_ratings of only that subset
  quantiles <- round(quantile(temp$avg_ratings, c(.05, .95 )))
  
  # squish the values of the avg_ratings inside the quantiles
  #library(scales)
  temp$avg_ratings <- squish(temp$avg_ratings, quantiles)
  
  for (d in 1:nrow(temp_avg_ex)) {
    for (s in 1:nrow(temp)) {
      
      if(temp_avg_ex[d,"pnr"] == temp[s,"pnr"]) {
        if(temp_avg_ex[d,"emotion"] == temp[s,"emotion"]) {
          if(temp_avg_ex[d, "music2"] == temp[s,"music2"]) {
            
            # if the pnr, emotion and musician/non-musician is the same, transfer new avg_ratings
            temp_avg_ex[d, "avg_ratings"] = temp[s,"avg_ratings"]
            
          }
        }
      }
      
    }
  }
  
  # return the excerpt dataset with the replaced values
  return(temp_avg_ex)
} 

# replace only the excerpts that had exteme outliers
avgH2 <- extreme_out_replace_music(avgH2, "scary", "non-musician")

avgS2 <- extreme_out_replace_music(avgS2, "peaceful", "musician")

avgT1 <- extreme_out_replace_music(avgT1, "scary", "non-musician")

#------------------------------------------------------------------------------------------------------------------------

# Normality

# shapiro test function
norm_em_music <- function(temp_avg_ex) {
  
  # return a tibble with results of shapiro test per group
  temp_avg_ex %>%
    group_by(music2, emotion) %>%
    shapiro_test(avg_ratings)
}

# test normality per excerpt
# p < 0.05 => NOT normal
norm_em_music(avgH1) # error because of little values
norm_em_music(avgH2)
norm_em_music(avgP1)
norm_em_music(avgP2)
norm_em_music(avgS1)
norm_em_music(avgS2)
norm_em_music(avgT1)
norm_em_music(avgT2)

#-----------------------------------------------------------------------------------------------------------------------

# Homogneity of variance and co-variance
# music2 is the between-IV

# function for levene test of variance 
var_music <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion) %>%
    levene_test(avg_ratings ~ music2)
}

# function for box's M-test of co-variance 
# test is not robust with unequal sample sizes
covar_music <- function(temp_avg_ex){
  box_m(temp_avg_ex[, "avg_ratings", drop = FALSE], temp_avg_ex$music2)
}

# test the variance and co-variance for each excerpt
var_music(avgH1)
covar_music(avgH1)
var_music(avgH2)
covar_music(avgH2)
var_music(avgP1)
covar_music(avgP1)
var_music(avgP2)
covar_music(avgP2)
var_music(avgS1)
covar_music(avgS1)
var_music(avgS2)
covar_music(avgS2)
var_music(avgT1)
covar_music(avgT1)
var_music(avgT2)
covar_music(avgT2)

#--------------------------------------------------------------------------------------------------------------------------

# Sphericity
# tested and adjusted when running the anova model, see below

#--------------------------------------------------------------------------------------------------------------------------

# Two-way mixed measures ANOVAs for musicianship
# the formula is y ~ w1*w2 + Error(id/(w1*w2))

# Bonferroni method used to adjust p-values for paired t-tests in post-hoc
# p-values are corrected for sphericity

#------------------------------------------------------------------------------

# scripts for functions

# function to run the ANOVA per excerpt
ANOVA_em_music <- function(temp_avg_ex){
  
  # run model
  temp_anova <- anova_test(
    data = temp_avg_ex, dv = avg_ratings, wid = pnr,
    between = music2, within = emotion
  )
  # get table with adjusted values
  get_anova_table(temp_anova, correction = c("auto"))
}


# functions to get post-hoc paired t-tests per excerpt which has significant 
# interaction between factors

# Pairwise comparisons between musicianship levels
# for significant interaction
ttest_inter_music <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion) %>%
    pairwise_t_test(avg_ratings ~ music2, p.adjust.method = "bonferroni")
}

# Pairwise comparisons between type of emotion rated at each musicianship level
# for significant interaction
ttest_inter_em_music <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(music2) %>%
    pairwise_t_test(
      avg_ratings ~ emotion, paired = TRUE, 
      p.adjust.method = "bonferroni") 
}

#------------------------------------------------------------------------------

# Run ANOVAs and post-hocs per excerpt

# type of emotion (2nd) factor has same values as the ones run for 2w rep ANOVA

ANOVA_em_music(avgH1) # not significant

ANOVA_em_music(avgH2) # significant 1st and 2nd factor and interaction
ttest_inter_music(avgH2)
ttest_inter_em_music(avgH2)

ANOVA_em_music(avgP1) # significant 2nd factor

ANOVA_em_music(avgP2) # significant 2nd factor

ANOVA_em_music(avgS1) # sgnificant 2nd factor and interaction
ttest_inter_music(avgS1)
ttest_inter_em_music(avgS1)

ANOVA_em_music(avgS2) # significant 2nd factor 

ANOVA_em_music(avgT1) # significant 2nd factor 

ANOVA_em_music(avgT2) # significant 2nd factor

