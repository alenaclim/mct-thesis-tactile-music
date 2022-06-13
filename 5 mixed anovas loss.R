
# This script contains the code for running the mixed-measures ANOVAs
# based on emotions' score averaged over Felt/Rec scores and hearing loss level. 
# Code for visualizing the data grouped in boxplots in a grid is also here.
# The binary hearing loss variable is used here, as there are too little people
# in each hearing loss category otherwise. Additionally, it contains code for 
# checking the necessary assumptions, as well as post-hoc paired t-tests. 

#--------------------------------------------------------------------------------------------------------------------------

# Summarize data by hearing loss level

sum_em_loss <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion, loss2) %>%
    get_summary_stats(avg_ratings, type = "mean_sd")
}

sum_em_loss(avgH1)
sum_em_loss(avgH2)
sum_em_loss(avgP1)
sum_em_loss(avgP2)
sum_em_loss(avgS1)
sum_em_loss(avgS2)
sum_em_loss(avgT1)
sum_em_loss(avgT2)

#--------------------------------------------------------------------------------------------------------------------------

# Visualize data with boxplots

plot_loss2_H1 <- ggboxplot(
  avgH1, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_H2 <- ggboxplot(
  avgH2, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_P1 <- ggboxplot(
  avgP1, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_P2 <- ggboxplot(
  avgP2, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_S1 <- ggboxplot(
  avgS1, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_S2 <- ggboxplot(
  avgS2, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_T1 <- ggboxplot(
  avgT1, x = "emotion", y = "avg_ratings", color = "loss2")

plot_loss2_T2 <- ggboxplot(
  avgT2, x = "emotion", y = "avg_ratings", color = "loss2")

# put it in a grid 4 x 2
boxplot_grid_loss2 = ggarrange(plot_loss2_H1, plot_loss2_H2, plot_loss2_P1, plot_loss2_P2, 
                               plot_loss2_S1, plot_loss2_S2, plot_loss2_T1, plot_loss2_T2,
                               labels = c("H1", "H2", "P1", "P2", "S1", "S2", "T1", "T2"),
                               common.legend = TRUE, 
                               legend = "bottom",
                               ncol = 2, nrow = 4, align = "v")

# visualize and export using interface
boxplot_grid_loss2

#--------------------------------------------------------------------------------------------------------------------------

# Check assumptions

# Outliners

# function to identify outliers per excerpt
out_em_loss <- function(temp_avg_ex) {
  
  # return a tibble with identified outliers
  temp_avg_ex %>%
    group_by(loss2, emotion) %>%
    identify_outliers(avg_ratings) 
}

# identify outliers per excerpt
out_em_loss(avgH1)
out_em_loss(avgH2) # extreme outliers identified for sadness and scariness in hearing 
out_em_loss(avgP1)
out_em_loss(avgP2)
out_em_loss(avgS1)
out_em_loss(avgS2) # extreme outliers identified for happiness and peacefulness in non-hearing
out_em_loss(avgT1)
out_em_loss(avgT2)

#------------------------------------------------------------------------------

# replace extreme outliers with the respective quantiles

# function to calculate quantiles and replace extreme outliers
library(scales)
extreme_out_replace_loss <- function(temp_avg_ex, temp_em, temp_loss) {
  
  # temporary dataframe
  temp = as.data.frame(subset(temp_avg_ex, (emotion == temp_em & loss2 == temp_loss)))
  
  # calculate the quantiles for the avg_ratings of only that subset
  quantiles <- round(quantile(temp$avg_ratings, c(.05, .95 )))
  
  # squish the values of the avg_ratings inside the quantiles
  #library(scales)
  temp$avg_ratings <- squish(temp$avg_ratings, quantiles)
  
  for (d in 1:nrow(temp_avg_ex)) {
    for (s in 1:nrow(temp)) {
      
      if(temp_avg_ex[d,"pnr"] == temp[s,"pnr"]) {
        if(temp_avg_ex[d,"emotion"] == temp[s,"emotion"]) {
          if(temp_avg_ex[d, "loss2"] == temp[s,"loss2"]) {
            
            # if the pnr, emotion and hearing/non-hearing is the same, transfer new avg_ratings
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
avgH2 <- extreme_out_replace_loss(avgH2, "sad", "hearing")
avgH2 <- extreme_out_replace_loss(avgH2, "scary", "hearing")

avgS2 <- extreme_out_replace_loss(avgS2, "happy", "non-hearing")
avgS2 <- extreme_out_replace_loss(avgS2, "peaceful", "non-hearing")

#------------------------------------------------------------------------------------------------------------------------

# Normality

# shapiro test function
norm_em_loss <- function(temp_avg_ex) {
  
  # return a tibble with results of shapiro test per group
  temp_avg_ex %>%
    group_by(loss2, emotion) %>%
    shapiro_test(avg_ratings)
}

# test normality per excerpt
# p < 0.05 => NOT normal
norm_em_loss(avgH1) # error because of little values
norm_em_loss(avgH2)
norm_em_loss(avgP1)
norm_em_loss(avgP2)
norm_em_loss(avgS1)
norm_em_loss(avgS2)
norm_em_loss(avgT1)
norm_em_loss(avgT2)

#-----------------------------------------------------------------------------------------------------------------------

# Homogneity of variance and co-variance
# loss2 is the between-IV

# function for levene test of variance 
var_loss <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion) %>%
    levene_test(avg_ratings ~ loss2)
}

# function for box's M-test of co-variance 
# test is not robust with unequal sample sizes
covar_loss <- function(temp_avg_ex){
  box_m(temp_avg_ex[, "avg_ratings", drop = FALSE], temp_avg_ex$loss2)
}

# test the variance and co-variance for each excerpt
var_loss(avgH1)
covar_loss(avgH1)
var_loss(avgH2)
covar_loss(avgH2)
var_loss(avgP1)
covar_loss(avgP1)
var_loss(avgP2)
covar_loss(avgP2)
var_loss(avgS1)
covar_loss(avgS1)
var_loss(avgS2)
covar_loss(avgS2)
var_loss(avgT1)
covar_loss(avgT1)
var_loss(avgT2)
covar_loss(avgT2)

#--------------------------------------------------------------------------------------------------------------------------

# Sphericity
# tested and adjusted when running the anova model, see below

#--------------------------------------------------------------------------------------------------------------------------

# Two-way mixed measures ANOVAs for hearing loss
# the formula is y ~ w1*w2 + Error(id/(w1*w2))

# Bonferroni method used to adjust p-values for paired t-tests in post-hoc
# p-values are corrected for sphericity

#------------------------------------------------------------------------------

# scripts for functions

# function to run the ANOVA per excerpt
ANOVA_em_loss <- function(temp_avg_ex){
  
  # run model
  anova_temp <- anova_test(
    data = temp_avg_ex, dv = avg_ratings, wid = pnr,
    between = loss2, within = emotion
  )
  # get table with adjusted values
  get_anova_table(anova_temp, correction = c("auto"))
}


# functions to get post-hoc paired t-tests per excerpt which has significant 
# interaction between factors

# Pairwise comparisons between hearing loss levels
# for significant interaction
ttest_inter_loss <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion) %>%
    pairwise_t_test(avg_ratings ~ loss2, p.adjust.method = "bonferroni")
}

# Pairwise comparisons between type of emotion rated at each hearing loss level
# for significant interaction
ttest_inter_em_loss <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(loss2) %>%
    pairwise_t_test(
      avg_ratings ~ emotion, paired = TRUE, 
      p.adjust.method = "bonferroni") 
}

#------------------------------------------------------------------------------

# Run ANOVAs and post-hocs per excerpt

# type of emotion (2nd) factor has same values as the ones run for 2w rep ANOVA


ANOVA_em_loss(avgH1) # significant 2nd factor and interaction
ttest_inter_loss(avgH1)
ttest_inter_em_loss(avgH1)

ANOVA_em_loss(avgH2) # significant 1st and 2nd factor

ANOVA_em_loss(avgP1) # not significant

ANOVA_em_loss(avgP2) # significant 2nd factor

ANOVA_em_loss(avgS1) # not significant

ANOVA_em_loss(avgS2) # not significant

ANOVA_em_loss(avgT1) # significant 1st and 2nd factor 

ANOVA_em_loss(avgT2) # significant 1st and 2nd factor and interaction
ttest_inter_loss(avgT2)
ttest_inter_em_loss(avgT2)

