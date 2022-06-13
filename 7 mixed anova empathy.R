
# This script contains the code for running the mixed-measures ANOVAs
# based on emotions' score averaged over Felt/Rec scores and empathy level. 
# Code for visualizing the data grouped in boxplots in a grid is also here.
# The binary empathy variable is used here, with the continuous scores split 
# into high and low empathy levels. Additionally, it contains code for 
# checking the necessary assumptions, as well as post-hoc paired t-tests. 

#--------------------------------------------------------------------------------------------------------------------------

# Summarize data by empathy  level

sum_em_empathy <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(empathy2, emotion) %>%
    get_summary_stats(avg_ratings, type = "mean_sd")
  
}

sum_em_empathy(avgH1)
sum_em_empathy(avgH2)
sum_em_empathy(avgP1)
sum_em_empathy(avgP2)
sum_em_empathy(avgS1)
sum_em_empathy(avgS2)
sum_em_empathy(avgT1)
sum_em_empathy(avgT2)

#--------------------------------------------------------------------------------------------------------------------------

# Visualize with box plots

plot_empathy2_H1 <- ggboxplot(
  avgH1, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_H2 <- ggboxplot(
  avgH2, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_P1 <- ggboxplot(
  avgP1, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_P2 <- ggboxplot(
  avgP2, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_S1 <- ggboxplot(
  avgS1, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_S2 <- ggboxplot(
  avgS2, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_T1 <- ggboxplot(
  avgT1, x = "emotion", y = "avg_ratings", color = "empathy2")

plot_empathy2_T2 <- ggboxplot(
  avgT2, x = "emotion", y = "avg_ratings", color = "empathy2")

# put it in a grid 4 x 2
boxplot_grid_empathy2 = ggarrange(plot_empathy2_H1, plot_empathy2_H2, plot_empathy2_P1, plot_empathy2_P2, 
                                plot_empathy2_S1, plot_empathy2_S2, plot_empathy2_T1, plot_empathy2_T2, 
                                labels = c("H1", "H2", "P1", "P2", "S1", "S2", "T1", "T2"),
                                common.legend = TRUE, 
                                legend = "bottom",
                                ncol = 2, nrow = 4, align = "v")

# visualize and export in interface
boxplot_grid_empathy2

#------------------------------------------------------------------------------

# make plot only for excerpt H2 which has a significant interaction
plot_empathy2_H2 <- ggboxplot(
  avgH2, x = "emotion", y = "avg_ratings", color = "empathy2",
  palette = "BrBG", 
  ylab = "Average emotion score (0-9)",
  xlab = "Emotions"
  )

plot_empathy2_H2 + theme_gray() +
  theme(legend.position = "top", legend.title=element_blank()) +
  scale_y_continuous(breaks=seq(0, 9, 1)) +
  scale_color_hue(c=45, l=55)

#--------------------------------------------------------------------------------------------------------------------------

# Check assumptions

# Outliners

# function to identify outliers per excerpt
out_em_empathy <- function(temp_avg_ex) {
  
  # return a tibble with identified outliers
  temp_avg_ex %>%
    group_by(empathy2, emotion) %>%
    identify_outliers(avg_ratings)
}

# identify outliers per excerpt
out_em_empathy(avgH1)
out_em_empathy(avgH2) # extreme outliers identified for sadness and scariness in high empathy
out_em_empathy(avgP1)
out_em_empathy(avgP2)
out_em_empathy(avgS1)
out_em_empathy(avgS2) 
out_em_empathy(avgT1) # extreme outliers identified for scariness in high empathy
out_em_empathy(avgT2) # extreme outliers identified for sadness in low empathy

#------------------------------------------------------------------------------

# replace extreme outliers with the respective quantiles

# function to calculate quantiles and replace extreme outliers
library(scales)
extreme_out_replace_empathy <- function(temp_avg_ex, temp_em, temp_empathy) {
  
  # temporary dataframe
  temp = as.data.frame(subset(temp_avg_ex, (emotion == temp_em & empathy2 == temp_empathy)))
  
  # calculate the quantiles for the avg_ratings of only that subset
  quantiles <- round(quantile(temp$avg_ratings, c(.05, .95 )))
  
  # squish the values of the avg_ratings inside the quantiles
  #library(scales)
  temp$avg_ratings <- squish(temp$avg_ratings, quantiles)
  
  for (d in 1:nrow(temp_avg_ex)) {
    for (s in 1:nrow(temp)) {
      
      if(temp_avg_ex[d,"pnr"] == temp[s,"pnr"]) {
        if(temp_avg_ex[d,"emotion"] == temp[s,"emotion"]) {
          if(temp_avg_ex[d, "empathy2"] == temp[s,"empathy2"]) {
            
            # if the pnr, emotion and low/high empathy is the same, transfer new avg_ratings
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
avgH2 <- extreme_out_replace_empathy(avgH2, "sad", "high empathy")
avgH2 <- extreme_out_replace_empathy(avgH2, "scary", "high empathy")

avgT1 <- extreme_out_replace_empathy(avgT1, "scary", "high empathy")

avgT2 <- extreme_out_replace_empathy(avgT2, "sad", "low empathy")

#------------------------------------------------------------------------------------------------------------------------

# Normality

# shapiro test function
norm_em_empathy <- function(temp_avg_ex) {
  
  # return a tibble with results of shapiro test per group
  temp_avg_ex %>%
    group_by(empathy2, emotion) %>%
    shapiro_test(avg_ratings)
  
}

# test normality per excerpt
# p < 0.05 => NOT normal
norm_em_empathy(avgH1) 
norm_em_empathy(avgH2)
norm_em_empathy(avgP1)
norm_em_empathy(avgP2)
norm_em_empathy(avgS1)
norm_em_empathy(avgS2)
norm_em_empathy(avgT1)
norm_em_empathy(avgT2)

#-----------------------------------------------------------------------------------------------------------------------

# Homogneity of variance and co-variance
# empathy2 is the between-IV

# function for levene test of variance 
var_empathy <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion) %>%
    levene_test(avg_ratings ~ empathy2)
}

# function for box's M-test of co-variance 
# test is not robust with unequal sample sizes
covar_empathy <- function(temp_avg_ex){
  box_m(temp_avg_ex[, "avg_ratings", drop = FALSE], temp_avg_ex$empathy2)
}

# test the variance and co-variance for each excerpt
var_empathy(avgH1)
covar_empathy(avgH1)
var_empathy(avgH2)
covar_empathy(avgH2)
var_empathy(avgP1)
covar_empathy(avgP1)
var_empathy(avgP2)
covar_empathy(avgP2)
var_empathy(avgS1)
covar_empathy(avgS1)
var_empathy(avgS2)
covar_empathy(avgS2)
var_empathy(avgT1)
covar_empathy(avgT1)
var_empathy(avgT2)
covar_empathy(avgT2)

#--------------------------------------------------------------------------------------------------------------------------

# Sphericity
# tested and adjusted when running the anova model, see below

#--------------------------------------------------------------------------------------------------------------------------

# Two-way mixed measures ANOVAs for empathy level
# the formula is y ~ w1*w2 + Error(id/(w1*w2))

# Bonferroni method used to adjust p-values for paired t-tests in post-hoc
# p-values are corrected for sphericity

#------------------------------------------------------------------------------

# scripts for functions

# function to run the ANOVA per excerpt
ANOVA_em_empathy <- function(temp_avg_ex){
  
  # run model
  temp_anova <- anova_test(
    data = temp_avg_ex, dv = avg_ratings, wid = pnr,
    between = empathy2, within = emotion
  )
  # get table with adjusted values
  get_anova_table(temp_anova, correction = c("auto"))
}


# functions to get post-hoc paired t-tests per excerpt which has significant 
# interaction between factors

# Pairwise comparisons between empathy levels
# for significant interaction
ttest_inter_empathy <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(emotion) %>%
    pairwise_t_test(avg_ratings ~ empathy2, p.adjust.method = "bonferroni")
}

# Pairwise comparisons between type of emotion rated at each musicianship level
# for significant interaction
ttest_inter_em_empathy <- function(temp_avg_ex){
  temp_avg_ex %>%
    group_by(empathy2) %>%
    pairwise_t_test(
      avg_ratings ~ emotion, paired = TRUE, 
      p.adjust.method = "bonferroni") 
}

#------------------------------------------------------------------------------

# Run ANOVAs and post-hocs per excerpt

# type of emotion (2nd) factor has same values as the ones run for 2w rep ANOVA

ANOVA_em_empathy(avgH1) # not significant

ANOVA_em_empathy(avgH2) # significant 2nd factor and interaction
ttest_inter_empathy(avgH2)
ttest_inter_em_empathy(avgH2)

ANOVA_em_empathy(avgP1) # significant 2nd factor

ANOVA_em_empathy(avgP2) # significant 2nd factor

ANOVA_em_empathy(avgS1) # sgnificant 2nd factor 

ANOVA_em_empathy(avgS2) # significant 2nd factor 

ANOVA_em_empathy(avgT1) # significant 2nd factor 

ANOVA_em_empathy(avgT2) # significant 2nd factor


