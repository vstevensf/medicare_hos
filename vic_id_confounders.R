# Medicare HOS, R 4.4.1
# this script takes in preprocessed HOS data
# and runs chi sq comparisons on potential confounders
# which we would then control for with propensity matching
# for us, it's the comorbidities (HF, MI, etc.)
# run this script pre and post propensity matching
# Victoria Stevens 8/19/24


## Imports
# library(readxl)
# library(tidyr)
# library(dplyr)
# library(writexl)
# library(e1071)
install.packages("MatchIt")
library(MatchIt)
install.packages("tableone")
library(tableone)


## Set working directory -- change as needed (have to access CSVs below)
setwd("/Users/M296398/Desktop/medicare_HOS_ortho/medicare_hos")
# setwd("C:\\Users\\Victoria\\Desktop\\medicare")

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
  
  # take log ten to give neg number, and interpret relative magnitude
  log_p_value <- log10(new_var_name$p.value)
  print(log_p_value)
}

## and check the standardized differences for categorical variables
# Create a Table One
table1 <- CreateTableOne(vars = confounders_to_check, strata = "cohort", data = combined_data, test = FALSE)

# Print the table with standardized differences
# smd = true to display and measure balance
# we expect them to be unbalanced tbh, where SMD > .1 is meaningful imbalance
print(table1, smd = TRUE)


# Perform optimal nearest neighbor matching
#TODO optimal??
m.out <- matchit(cohort ~ RACE + MRSTAT + EDUC + Diabetes + ANG_CAD + Hypertension + CHF + MI + IBD + COPD + Smoking_Status + Stroke, 
                 data = combined_data, 
                 method = "nearest",            # Nearest neighbor matching
                 exact = ~ AGE + GENDER,        # Exact matching on age and gender
                 caliper = 0.2,                 # Caliper width
                 distance = "logit",            # Distance based on the logit of the propensity score
                 replace = FALSE,               # Matching without replacement
                 m.order = "closest")           # Closest matching order TODO

# View summary of matching
summary(m.out)
matched_data <- match.data(m.out)

# Create a Table One
table2 <- CreateTableOne(vars = confounders_to_check, strata = "cohort", data = matched_data, test = FALSE)

# Print the table with standardized differences
# smd = true to display and measure balance
# we expect them to be unbalanced tbh, where SMD > .1 is meaningful imbalance
print(table2, smd = TRUE)

for (name in confounders_to_check) {
  # Create a new variable name by appending "_new" to the original variable name
  new_var_name <- paste0(name, "_chisq_after_result")
  
  # save and print the chisq result for each variable
  print(paste0(name, "_chisq_after_result"))
  new_var_name <- chisq.test(table(matched_data[[name]], matched_data$cohort))
  print(new_var_name)
  
  # take log ten to give neg number, and interpret relative magnitude
  log_p_value <- log10(new_var_name$p.value)
  print(log_p_value)
}


######
p_values_before <- sapply(confounders_to_check, function(var) {
  chisq.test(table(combined_data[[var]], combined_data$cohort))$p.value
})
p_values_after <- sapply(confounders_to_check, function(var) {
  chisq.test(table(matched_data[[var]], matched_data$cohort))$p.value
})
p_values_df <- data.frame(
  Covariate = confounders_to_check,
  P_Value_Before = p_values_before,
  P_Value_After = p_values_after
)

print(p_values_df)

# test logistic regression with Emo_Carefulness outcome
library(nnet)
model <- multinom(Emo_Carefulness ~ cohort + RACE + IBD + Smoking_Status, data = matched_data)

# Get the summary of the model
model_summary <- summary(model)

# Coefficients
coefficients <- model_summary$coefficients

# Standard errors
std_errors <- model_summary$standard.errors

# Calculate z-values
z_values <- coefficients / std_errors

# Calculate p-values
p_values <- 2 * (1 - pnorm(abs(z_values)))

# Create a summary table
summary_table <- cbind(coefficients, std_errors, z_values, p_values)

# Print the summary table
print(summary_table)

###########
# Extract the matched datasets
matched_data_1998 <- subset(matched_data, cohort == 0)
matched_data_2023 <- subset(matched_data, cohort == 1)



###STATS CODE###

##General_Health
table(matched_data_1998$General_Health)
table(matched_data_2023$General_Health)

#change over time p-value
chisq.test(matched_data$cohort, matched_data$Toilet)

# Install the package if necessary
install.packages("geepack")
install.packages("nnet")
library(geepack)
library(nnet)

# Multinomial Logistic Regression
multinom_model <- multinom(Toilet ~ cohort, data = matched_data)

# Coefficients from the multinomial model
summary(multinom_model)




# Convert to a table of counts
toilet_table <- table(matched_data$cohort, matched_data$Toilet)

# Print the contingency table
print(toilet_table)

# Perform the Stuart-Maxwell test
install.packages("DescTools")
library(DescTools)
result <- StuartMaxwellTest(toilet_table)

# Print the result
print(result)

# Extracting paired vectors based on subclass
paired_data <- split(matched_data, matched_data$subclass)

# Initialize vectors to store paired outcomes
outcome_1 <- c()
outcome_2 <- c()

# Loop through the paired data
for (pair in paired_data) {
  if (nrow(pair) == 2) {
    outcome_1 <- c(outcome_1, pair$General_Health[1])
    outcome_2 <- c(outcome_2, pair$General_Health[2])
  }
}

# Check the paired vectors
head(outcome_1)
head(outcome_2)

# Create a contingency table of the paired outcomes
contingency_table <- table(outcome_1, outcome_2)

# Perform Stuart-Maxwell test (install the package if necessary)
library(DescTools)
test_result <- StuartMaxwellTest(contingency_table)

# Print the test results
print(test_result)

# Function to perform pairwise proportion tests
pairwise_prop_test_grid <- function(table) {
  n_rows <- nrow(table)
  n_cols <- ncol(table)
  
  # List to store results
  results_list <- list()
  
  # Loop through all pairs of rows and columns
  for (i in 1:(n_rows - 1)) {
    for (j in (i + 1):n_rows) {
      for (k in 1:(n_cols - 1)) {
        for (l in (k + 1):n_cols) {
          # Compare row i with row j and column k with column l
          comparison_name <- paste("Row", i, "vs Row", j, "& Col", k, "vs Col", l)
          
          # Extract the relevant data
          data_to_compare <- matrix(c(table[i, k], table[i, l], table[j, k], table[j, l]), nrow = 2)
          
          # Perform pairwise proportion test
          test_result <- pairwise.prop.test(data_to_compare, p.adjust.method = "bonferroni")
          
          # Store the result
          results_list[[comparison_name]] <- test_result
        }
      }
    }
  }
  
  return(results_list)
}

# Run the function and get the results
pairwise_results_grid <- pairwise_prop_test_grid(contingency_table)

# Display the results
pairwise_results_grid

# standardized differences (not influenced by sample size and are more apropariate for assessing balance)
