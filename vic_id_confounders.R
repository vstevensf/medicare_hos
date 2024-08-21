# Medicare HOS, R 4.4.1
# this script takes in preprocessed HOS data
# and runs chi sq comparisons on potential confounders
# which we would then control for with propensity matching
# for us, it's the comorbidities (HF, MI, etc.)
# run this script pre and post propensity matching
# Victoria Stevens 8/15/24


## Imports
# library(readxl)
# library(tidyr)
# library(dplyr)
# library(writexl)
# library(e1071)
# library(MatchIt)


## Set working directory -- change as needed (have to access CSVs below)
# setwd("/Users/M296398/Desktop/medicare_HOS_ortho/stats redo w strat")
setwd("C:\\Users\\Victoria\\Desktop\\medicare")

## Retrieve the preprocessed HOS data
# TODO: add the code into a main file at the end
# vars of interest: final_1998, final_2020, combined_data
source("vic_preprocessing.R")

## Run Chi sq/t test to see if there is a significant diff in comorbidities bt cohorts
# If significant, we want to make sure we account for it in propensity matching as a covariate
# And we wanna see that that significance is taken care of post-match and ensure matching was sufficient

# Variables we wanna check
# Age, Race, Gender, marriage status, education, diabetes, angina/coronary artery disease,
# hypertension, congestive heart failure, MI, IBD, COPD, former smoking, & stroke
# age is continuous variable so it isn't included in this vector
confounders_to_check <- c(
  "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Diabetes", 
  "ANG_CAD", "Hypertension", "CHF", "MI", "IBD", "COPD", 
  "Smoking_Status", "Stroke"
)

# TODO TODO TODO treat age as a continuous variable!! do t test!!
# p value cutoff > 0.05 ---> TODO: check this
# TODO also make this its own function maybe
for (name in confounders_to_check) {
  # Create a new variable name by appending "_new" to the original variable name
  new_var_name <- paste0(name, "_chisq")
  
  # save and print the chisq result for each variable
  print(paste0(name, "_chisq_result"))
  new_var_name <- chisq.test(table(combined_data[[name]], combined_data$cohort))
  print(new_var_name)
  
}




# The love.plot() function from the cobalt package generates a Love plot, 
# which visually compares standardized mean differences of covariates before 
# and after matching. The plot helps you assess whether matching improved balance.
# Threshold for standardized mean difference? TODO: 


# chisq_before_gender <- chisq.test(table(dataset$Gender, dataset$treatment))
