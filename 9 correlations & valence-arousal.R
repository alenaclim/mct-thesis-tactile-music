
# This script contains code for calculating the correlations btween participants
# irrelevant ofexcerpt, and the correlations between excerpts, irrelevant of
# participants. Additionally, the code for visualizing the valence and arousal 
# ratings as a scatterplot is here.

#---------------------------------------------------------------------------------------------------------------------------

#install.packages("corrr")
library(corrr)

#install.packages("dplyr")
library(dplyr)

#install.packages("corrplot")
library(corrplot)

#------------------------------------------------------------------------------
# function to compute the matrix of p-values
# Retrieved from http://www.sthda.com/english/wiki/visualize-correlation-matrix-using-correlogram

# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}

#---------------------------------------------------------------------------------------------------------------------------

# Correlation between participants irrelevant of excerpt


# subset the columns from data_descriptves to be used when calculating the correlations
correlation_participants <- select(data_descriptives, c(empathy, valence:peacefulness))

# generate correlation matrix
M <- cor(correlation_participants)

# matrix with the p-value of the correlation
p.mat <- cor.mtest(correlation_participants)
#head(p.mat[, 1:5])

# Visualize in a correlation plot
corrplot(M, type="lower",  method = "color", order="hclust",
         col=brewer.pal(n=10, name="BrBG"), addCoef.col = "black",
         p.mat = p.mat, sig.level = 0.05, 
         pch = 4, pch.cex = 3, pch.col = '#E69F00', non_corr.method = "pch", 
         tl.col="black", tl.srt=15, tl.cex = 0.8,
         addgrid = TRUE
         )

#---------------------------------------------------------------------------------------------------------------------------

# Correlation between excerpts irrelevant of participants


# import excerpt_correlation.csv where the appropriate averages have been calculated
correlation_excerpts = read.csv("C:\\Users\\alena\\Documents\\UiO\\MCT\\Thesis\\R folder\\excerpts_correlation.csv")

# subset the columns to be used to calculate correlation
# beware the column with excerpt names is not kept
correlation_excerpts <- select(correlation_excerpts, c(happiness:arousal))

# make correlation matrix
MM<-cor(correlation_excerpts)

# matrix of the p-value of the correlation
e.mat <- cor.mtest(correlation_excerpts)
#head(e.mat[, 1:5])

# Visualize in a correlation plot
corrplot(MM, type="lower",  method = "color", order="hclust",
         col=brewer.pal(n=10, name="BrBG"), addCoef.col = "black",
         p.mat = e.mat, sig.level = 0.05, 
         pch = 4, pch.cex = 3, pch.col = '#E69F00', non_corr.method = "pch", 
         tl.col="black", tl.srt=15, tl.cex = 0.8,
         addgrid = TRUE 
)

#---------------------------------------------------------------------------------------------------------------------------

# Valence and arousal plot with all excerpts' ratings


# add column with excerpt names to the correlation_excerpts
excerpts = c("H1", "H2", "P1", "P2", "S1", "S2", "T1", "T2")
correlation_excerpts$excerpt = excerpts

# Vizualize in as a scatter plot
valence_arousal = ggscatter(
  correlation_excerpts, x = "arousal", y = "valence", color = "excerpt", size = 3,
  palette = "BrBG", repel = TRUE, label = "excerpt", font.label = c(8,"plain"),
  xlab = "Arousal scores (0-9)",
  ylab = "Valence scores (0-9)",
  xlim = c(0,9),
  ylim = c(0,9)
)

valence_arousal + theme_gray() +
  theme(legend.position = "none") +
  scale_x_continuous(breaks=seq(0, 9, 1)) +
  scale_y_continuous(breaks=seq(0, 9, 1)) +
  scale_color_hue(c=45, l=55)

