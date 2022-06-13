
# This script contains code for summarizing data per excerpt grouped by several variables.
# Additionally, it contains code for visualizing the data in a grid of boxplots grouped
# per type of emotion and Felt/Rec.

#--------------------------------------------------------------------------------------------------------------------------

# Summarize the data

# group the data by type of emotion and Felt/Rec and compute
# summary statistics for emotion rating (mean and sd)

# function 
sum_em_F_R <- function(temp_ex) {

  # return a tibble with grouped mean and SD
  temp_ex %>%
    group_by(emotion, felt_rec) %>%
    get_summary_stats(ratings, type = "mean_sd")
}

# summarize per excerpt
sum_em_F_R(exH1)
sum_em_F_R(exH2)
sum_em_F_R(exP1)
sum_em_F_R(exP2)
sum_em_F_R(exS1)
sum_em_F_R(exS2)
sum_em_F_R(exT1)
sum_em_F_R(exT2)

#-----------------------------------------------------------------------------------------------------------------------

# summarize data based on the type of emotion to report in the table
# use averaged data, to have the correct number of degrees of freedom

# function
sum_em <- function(temp_ex) {
  
  # return a tibble with grouped mean and SD
  temp_ex %>%
    group_by(emotion) %>%
    get_summary_stats(avg_ratings, type = "mean_sd")
}

# summarize per excerpt
sum_em(avgH1)
sum_em(avgH2)
sum_em(avgP1)
sum_em(avgP2)
sum_em(avgS1)
sum_em(avgS2)
sum_em(avgT1)
sum_em(avgT2)

#------------------------------------------------------------------------------------------------------------------------

# summarize data based on the Felt/Rec emotion scores to report in the table

# function
sum_F_R <- function(temp_ex) {
  
  # return a tibble with grouped mean and SD
  temp_ex %>%
    group_by(felt_rec) %>%
    get_summary_stats(ratings, type = "mean_sd")
}

# summarize per excerpt
sum_F_R(exH1)
sum_F_R(exH2)
sum_F_R(exP1)
sum_F_R(exP2)
sum_F_R(exS1)
sum_F_R(exS2)
sum_F_R(exT1)
sum_F_R(exT2)

#-------------------------------------------------------------------------------------------------------------------------

# Visualize the data 
# per excerpt, grouped by type of emotiona and Felt/Rec

# boxplots function per excerpt
box_F_R <- function(temp_ex) {
  
  temp_plot = ggplot(temp_ex, aes(x=emotion, y=ratings, fill=felt_rec)) + 
    geom_boxplot() +
    expand_limits(y=c(0,9)) +
    scale_y_continuous(breaks=seq(0,9,2)) +
    guides(fill=guide_legend(title=NULL)) +
    scale_x_discrete(name="", limits=c("happy","sad","scary", "peaceful")) +
    ylab("Scores (0-9)")
  
  return(temp_plot)
}

# create boxplot for each excerpt
plotH1 = box_F_R(exH1)
plotH2 = box_F_R(exH2)
plotP1 = box_F_R(exP1)
plotP2 = box_F_R(exP2)
plotS1 = box_F_R(exS1)
plotS2 = box_F_R(exS2)
plotT1 = box_F_R(exT1)
plotT2 = box_F_R(exT2)


# put all boxplots in a grid 4 x 2
boxplot_grid = ggarrange(plotH1, plotH2, plotP1, plotP2, plotS1, plotS2, plotT1, plotT2,
          labels = c("H1", "H2", "P1", "P2", "S1", "S2", "T1", "T2"),
          common.legend = TRUE, 
          legend = "bottom",
          ncol = 2, nrow = 4, align = "v")

# see and export grid from interface
boxplot_grid

