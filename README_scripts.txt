
This file contains details about the code in each R-script and what it was used for: to import and prepare the datasets, 
to run several types of analysis, to create visualizations. Information about the datasets can be found in another file,
specificallyl "README_csv_files.txt".

---------------------------------------------------------------------------------------------------------------------------

  "1 general statistics.R"

This script contains code for installing relevant packages, for importing and preparing the data_descriptives.csv file 
to be used as a dataset, as well as code for calculating means and SDs of different variables for reporting. 

  "2 import and prepare datasets.R"
  
This script contains code for importing and preparing the entire dataset to be used later for analysis. Additionally, 
subsets of the data are created and prepared for later analysis, visualizations and reporting.

  "3 summarize and visualize.R"
  
This script contains code for summarizing data per excerpt grouped by several variables. Additionally, it contains code 
for visualizing the data in a grid of boxplots grouped per type of emotion and Felt/Recognized.

  "4 2w rep anova.R"
  
This script contains the code for running the repeated-measures ANOVAs based on type of emotion and Felt/Recognized. 
Additionally, it contains code for checking the necessary assumptions, as well as post-hoc paired t-tests. 

  "5 mixed anovas loss.R"
  
This script contains the code for running the mixed-measures ANOVAs # based on emotions' score averaged over Felt/
Recognized scores and hearing loss level. Code for visualizing the data grouped in boxplots in a grid is also here.
The binary hearing loss variable is used here, as there are too little people in each hearing loss category otherwise. 
Additionally, it contains code for checking the necessary assumptions, as well as post-hoc paired t-tests. 

  "6 mixed anova musicianship.R"
  
This script contains the code for running the mixed-measures ANOVAs based on emotions' score averaged over Felt/Recognized 
scores and musicianship level. Code for visualizing the data grouped in boxplots in a grid is also here. The binary 
musicianship variable is used here, as there are too little people in each musicianship category otherwise. Additionally, 
it contains code for checking the necessary assumptions, as well as post-hoc paired t-tests. 

  "7 mixed anova empathy.R"
  
This script contains the code for running the mixed-measures ANOVAs based on emotions' score averaged over Felt/Recognized 
scores and empathy level. Code for visualizing the data grouped in boxplots in a grid is also here. The binary empathy 
variable is used here, with the continuous scores split into high and low empathy levels. Additionally, it contains code for 
checking the necessary assumptions, as well as post-hoc paired t-tests. 

  "8 indep t-test musicianship empathy.R"
  
This script contains code for running an independent sample t-test to check whether the musicianship level influenced the 
empathy scores, empathy being a continuous variable here and not a binary as for the mixed ANOVAs. The analysis is run 
irrelevant of excerpt, so the data_descriptives.csv file is used. Additionally, code for visualizing the empathy scores versus 
average emotions' ratings as a scatter plot with regression lines is here.

  "9 correlations & valence-arousal.R"
  
This script contains code for calculating the correlations btween participants irrelevant ofexcerpt, and the correlations 
between excerpts, irrelevant of participants. Additionally, the code for visualizing the valence and arousal ratings as 
a scatterplot is here.