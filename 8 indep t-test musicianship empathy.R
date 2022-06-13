
# This script contains code for running an independent sample t-test to check
# whether the musicianship level influenced the empathy scores, empathy being
# a continuous variable here and not a binary as for the mixed ANOVAs. The 
# analysis is run irrelevant of excerpt, so the data_descriptives.csv file is
# used. Additionally, code for visualizing the empathy scores versus average
# emotions' ratings as a scatter plot with regression lines is here.

#---------------------------------------------------------------------------------------------------------------------------

# Summarize empathy scores by musicianship level

summarySE(data_descriptives, measurevar="empathy", groupvars=c("music2"), 
          na.rm=TRUE, conf.interval = 0.95)

# Visualize empathy scores by musicianship level in boxplots

plot_empathy_data_descriptives = ggboxplot(
  data_descriptives, x = "music2", y = "empathy", 
  color = "music2",
  ylab = "Empathy", xlab = "", 
  legend = "none", 
  ylim = c(0,60)
)

plot_empathy_data_descriptives + theme_gray() +
  theme(legend.position = "none") +
  scale_y_continuous(breaks=seq(0, 56, 5)) 

#---------------------------------------------------------------------------------------------------------------------------

# Check assumptions

# Outliners

data_descriptives %>%
  group_by(music2) %>%
  identify_outliers(empathy)

# Normality 

# visual inspection
ggqqplot(data_descriptives, x = "empathy", facet.by = "music2")

# shapiro test
data_descriptives %>%
  group_by(music2) %>%
  shapiro_test(empathy)

# Equality of variance

# levene test: if the variances of groups are equal, p > 0.05
data_descriptives %>% levene_test(empathy ~ music2)

#---------------------------------------------------------------------------------------------------------------------------

# Run Student t-test

# Student's t-test assumes that the sample means being compared for two populations
# are normally distributed, and that the populations have equal variances.
data_descriptives %>%
  t_test(empathy ~ music2, var.equal = TRUE) %>%
  add_significance() # not significative

# Calculate effect size with Cohen's D
data_descriptives %>%  cohens_d(empathy ~ music2, var.equal = TRUE)

#---------------------------------------------------------------------------------------------------------------------------

# Visualizing empathy scores versus emotional ratings


# transform data to long format for this plot
library(tidyr)

# The arguments to gather():
# - data: Data object
# - key: Name of new key column (made from names of data columns)
# - value: Name of new value column
# - ...: Names of source columns that contain values
# - factor_key: Treat the new key column as a factor (instead of character vector)

data_descriptives_long <- gather(data_descriptives, emotions, emotion_avg_ratings, 
                                 happiness:peacefulness, factor_key=TRUE)
# data_long = as.data.frame(data_long)

# scatterplot of emotion rating against empathy
scatter = ggscatter(
  data_descriptives_long, x = "emotion_avg_ratings", y = "empathy",
  color = "emotions", palette = "BrBG",
  ylab = "Empathy score (0-56)",
  xlab = "Average emotions score (0-9)",
  add = "reg.line"
)

scatter + theme_gray() +
  theme(legend.position = "top") +
  scale_x_continuous(breaks=seq(0, 9, 1)) +
  scale_y_continuous(breaks=seq(0, 56, 5)) 
