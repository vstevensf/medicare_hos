# Medicare HOS, R 4.4.2 (2024-10-31)
# PROMs trends over time: 2006-2021 (cohorts 9-24)
# this serves as the preprocessing script
# where we take the raw HOS data, pare down to the arthritis,
# demographics, and PROMs columns
# remove outliers or weird answers
# remove NAs
# ascii to csv conversion must be completed before this (ascii_to_csv/ folder)
# Victoria Stevens 11/26/24

# imports
# install.packages("openxlsx")
library(openxlsx)

## Set working directory -- change as needed (have to access CSVs below)
setwd("/Users/M296398/Desktop/medicare_hos")
# setwd("C:\\Users\\m296398\\Desktop\\medicare_hos")


## Read in PUF files
df_2006 <- read.csv("data/raw/C9_2006.csv") # Cohort 9, 2006 = 123,053 x 43
df_2007 <- read.csv("data/raw/C10_2007.csv") # Cohort 10, 2007 = 196,913 x 43
df_2008 <- read.csv("data/raw/C11_2008.csv") # Cohort 11, 2008 = 240,682 x 43
df_2009 <- read.csv("data/raw/C12_2009.csv") # Cohort 12, 2009 = 298,040 x 43
df_2010 <- read.csv("data/raw/C13_2010.csv") # Cohort 13, 2010 = 347,945 x 43
df_2011 <- read.csv("data/raw/C14_2011.csv") # Cohort 14, 2011 = 322,794 x 43
df_2012 <- read.csv("data/raw/C15_2012.csv") # Cohort 15, 2012 = 321,395 x 43
df_2013 <- read.csv("data/raw/C16_2013.csv") # Cohort 16, 2013 = 303,512 x 43
df_2014 <- read.csv("data/raw/C17_2014.csv") # Cohort 17, 2014 = 301,790 x 43
df_2015 <- read.csv("data/raw/C18_2015.csv") # Cohort 18, 2015 = 286,097 x 43
df_2016 <- read.csv("data/raw/C19_2016.csv") # Cohort 19, 2016 = 260,608 x 43
df_2017 <- read.csv("data/raw/C20_2017.csv") # Cohort 20, 2017 = 256,652 x 43
df_2018 <- read.csv("data/raw/C21_2018.csv") # Cohort 21, 2018 = 239,071 x 43
df_2019 <- read.csv("data/raw/C22_2019.csv") # Cohort 22, 2019 = 231,910 x 43
df_2020 <- read.csv("data/raw/C23_2020.csv") # Cohort 23, 2020 = 287,476 x 43
df_2021 <- read.csv("data/raw/C24_2021.csv") # Cohort 24, 2021 = 288,670 x 43

df_names <- c(
  "df_2006", "df_2007", "df_2008", "df_2009", 
  "df_2010", "df_2011", "df_2012", "df_2013", 
  "df_2014", "df_2015", "df_2016", "df_2017", 
  "df_2018", "df_2019", "df_2020", "df_2021"
)

### Data Preprocessing

# VR12
# PCS = general health, moderate activities, climbing several stairs, 
#   accomplished less, limited in kind, pain interfernece
# MCS = accomplished less, not carefully as usual, energy, peaceful, 
#   down-hearted, interference in social activites

# ADLs = bathing, dressing, eating, chairs, walking, toilet

# comorbidities: htn, angina/CAD, CHF, MI, other heart, stroke, COPD, 
#   IBD, HKA, HWA, sciatica, DBM, any cancer

# smoking: current smoker

# survey disposition, CMS plan region, person completing


## Standardize column names between the two cohorts
new_fields <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "BMICAT", 
  "General_Health", "Mod_Activity", "Stairs", "Phys_Amount_Limit", 
  "Phys_Type_Limit", "Emo_Amount_Limit", "Emo_Carefulness", "Pain_Work", 
  "Peace", "Energy", "Down", "Social_Interference", "Bathing", 
  "Dressing", "Eating", "Chairs", "Walking", "Toilet", "Hypertension", 
  "ANG_CAD", "CHF", "MI", "Heart_Other", "Stroke", "COPD", "IBD", 
  "Arth_Hip_Knee", "Arth_Hand_Wr", "Osteo", "Sciatica", "Diabetes", 
  "Cancer", "Smoking_Status", "Who_Comp", "Survey_Disp", "Region"
) # length = 43

## Remove patients that didn't answer all the questions (NAs/blanks)
# Checking the datatypes within each column for each cohort -- make sure they match up
# Loop through each data frame name
# sink("console_output.txt")
for (df_name in df_names) {
  # Access the data frame dynamically using `get`
  df <- get(df_name)
  
  for (col in new_fields) {
    # Check its datatypes in the current data frame
    unique_types <- unique(sapply(df[[col]], typeof))
    
    # Print the information
    cat("Data frame:", df_name, "\n")
    cat("Column:", col, "\n")
    print(unique_types)
    cat("\n")
  }
}
# all cols are of type integer except CASE_ID & Survey_Disp, which are char
# sink()

# Handle char column = CASE_ID
# Function to check if a char value is "empty"
is_empty_char <- function(x) {
  is.null(x) || is.na(x) || x == "" || grepl("^\\s*$", x) || x == "\u00A0" || x == "\u200B" || x == "\n"
}

# Loop through each data frame
for (df_name in df_names) {
  # Access the data frame dynamically
  df <- get(df_name)
  
  # Apply the empty check to the 'CASE_ID' column
  empty_rows <- sapply(df$CASE_ID, is_empty_char)
  
  # Filter the data frame to remove rows with "empty" values in the 'CASE_ID' column
  cleaned_df <- df[!empty_rows, ]
  
  # Optionally, assign the cleaned data back to a new variable (or overwrite the old one)
  assign(paste0("cleaned_", df_name), cleaned_df)
  
  # Optional: Print a summary for confirmation
  cat("Data frame processed:", df_name, "- Rows removed:", sum(empty_rows), "\n")
} # This didn't make a difference but useful check to have


# Do it again but for 'Survey_Disp' column (also didn't make difference)
for (df_name in df_names) {
  # Access the data frame dynamically
  df <- get(df_name)
  
  # Apply the empty check to the 'CASE_ID' column
  empty_rows <- sapply(df$Survey_Disp, is_empty_char)
  
  # Filter the data frame to remove rows with "empty" values in the 'CASE_ID' column
  cleaned_df <- df[!empty_rows, ]
  
  # Optionally, assign the cleaned data back to a new variable (or overwrite the old one)
  assign(paste0("cleaned_", df_name), cleaned_df)
  
  # Optional: Print a summary for confirmation
  cat("Data frame processed:", df_name, "- Rows removed:", sum(empty_rows), "\n")
}

# Handle integer columns
# Function to check if a integer value is "empty"
is_empty_integer <- function(x) {
  is.null(x) || is.na(x) || length(x) == 0
}
# Apply the empty check to the rest of the columns
int_cols <- c(
  "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "BMICAT", 
  "General_Health", "Mod_Activity", "Stairs", "Phys_Amount_Limit", 
  "Phys_Type_Limit", "Emo_Amount_Limit", "Emo_Carefulness", "Pain_Work", 
  "Peace", "Energy", "Down", "Social_Interference", "Bathing", 
  "Dressing", "Eating", "Chairs", "Walking", "Toilet", "Hypertension", 
  "ANG_CAD", "CHF", "MI", "Heart_Other", "Stroke", "COPD", "IBD", 
  "Arth_Hip_Knee", "Arth_Hand_Wr", "Osteo", "Sciatica", "Diabetes", 
  "Cancer", "Smoking_Status", "Who_Comp", "Region"
) # length = 41

for (df_name in df_names) {
  # Access the data frame dynamically
  df <- get(df_name)
  
  # Start with the original cleaned version
  cleaned_df <- df
  
  # Loop through integer columns and remove rows with "empty" values
  for (col in int_cols) {
    cleaned_df <- cleaned_df[!sapply(cleaned_df[[col]], is_empty_integer), ]
  }
  
  # Optionally, assign the final cleaned data back to a new variable (or overwrite the old one)
  assign(paste0("cleaned_", df_name), cleaned_df)
  
  # Optional: Print a summary for confirmation
  cat("Data frame processed:", df_name, "- Rows remaining:", nrow(cleaned_df), "\n")
}

cleaned_df_names <- c(
  "cleaned_df_2006", "cleaned_df_2007", "cleaned_df_2008", "cleaned_df_2009", 
  "cleaned_df_2010", "cleaned_df_2011", "cleaned_df_2012", 
  "cleaned_df_2013", "cleaned_df_2014", "cleaned_df_2015", 
  "cleaned_df_2016", "cleaned_df_2017", "cleaned_df_2018", 
  "cleaned_df_2019", "cleaned_df_2020", "cleaned_df_2021"
)

# double check that we really got rid of all the NAs/empties
# Use complete.cases() to remove rows with NA in the specified columns
# Loop through each cleaned data frame
for (df_name in cleaned_df_names) {
  # Access the data frame dynamically
  cleaned_df <- get(df_name)
  
  # Use complete.cases() to remove rows with NA in the specified columns
  cleanest_df <- cleaned_df[complete.cases(cleaned_df[, new_fields]), ]
  
  # Assign the fully cleaned data frame to a new variable
  assign(paste0("cleanest_", df_name), cleanest_df)
  
  # Optional: Print a summary of rows removed
  cat("Data frame processed:", df_name, "- Rows remaining:", nrow(cleanest_df), "\n")
}

## Select the patients with arthritis & removal of extraneous data
# >=80% survey complete
unique(cleanest_1998$Survey_Disp)
unique(cleanest_2020$Survey_Disp)
complete_surv_1998 <- subset(cleanest_1998, Survey_Disp %in% c("M10", "T10"))
complete_surv_2020 <- subset(cleanest_2020, Survey_Disp %in% c("M10", "T10"))
unique(complete_surv_1998$Survey_Disp)
unique(complete_surv_2020$Survey_Disp)

# get rid of responses filled by proxy
no_proxy_1998 <- subset(complete_surv_1998, Who_Comp %in% c(1))
no_proxy_2020 <- subset(complete_surv_2020, Who_Comp %in% c(1))

# keep age >= 65
aged_1998 <- subset(no_proxy_1998, AGE %in% c(2, 3))
aged_2020 <- subset(no_proxy_2020, AGE %in% c(2, 3))

# no smoking "dont know"
smoke_1998 <- subset(aged_1998, Smoking_Status %in% c(1, 2, 3))
smoke_2020 <- subset(aged_2020, Smoking_Status %in% c(1, 2, 3))

# Remove rows where GENDER == 3
unique(smoke_1998$GENDER)
unique(smoke_2020$GENDER)
gender_1998 <- smoke_1998[smoke_1998$GENDER != 3, ] 
gender_2020 <- smoke_2020[smoke_2020$GENDER != 3, ] 

#create cohorts of patients with arthritis
#1 = yes, 2 = no -- so keep the rows that have 1 as the value under arthritis (hip/knee)
arth_1998 <- gender_1998[gender_1998$Arth_Hip_Knee == 1, ]
arth_2020 <- gender_2020[gender_2020$Arth_Hip_Knee == 1, ]




# checking that the values of each column make sense
for (col_name in colnames(arth_1998)) {
  unique_values <- unique(arth_1998[[col_name]])  # Get unique values for each column
  print(paste("Unique values in column", col_name, ":"))
  print(unique_values)
}
for (col_name in colnames(arth_2020)) {
  unique_values <- unique(arth_2020[[col_name]])  # Get unique values for each column
  print(paste("Unique values in column", col_name, ":"))
  print(unique_values)
}


## Combining the cohorts into one dataframe (necessary for propensity matching)
# Add a binary cohort variable indicating the...cohort
arth_1998$cohort <- 0 # 11603 x 42
arth_2020$cohort <- 1 # 59090 x 42


# Combine the cohort dataframes (vertical stack)
# column names, number, and datatype must match (made sure of this above w preprocessing)
combined_data <- rbind(arth_1998, arth_2020) # 70693 records/rows
combined_data_copy <- combined_data

#### Factoring for categorical data
# age
combined_data$AGE <- factor(combined_data$AGE, 
                               levels = c(2, 3),
                               labels = c("65 to 74", "Greater than 74"),
                            ordered = TRUE)
# race
combined_data$RACE <- factor(combined_data$RACE, 
                            levels = c(1, 2, 3),
                            labels = c("White", "Black or African American", "Other"))
# gender
combined_data$GENDER <- factor(combined_data$GENDER, 
                             levels = c(1, 2),
                             labels = c("Male", "Female"))

# marital status
combined_data$MRSTAT <- factor(combined_data$MRSTAT, 
                               levels = c(1, 2),
                               labels = c("Married", "Non-Married"))

# education
combined_data$EDUC <- factor(combined_data$EDUC, 
                               levels = c(1, 2, 3),
                               labels = c("Less than GED", "GED", "Greater than GED"),
                             ordered = TRUE)

# Arthritis of Hip/Knee
combined_data$Arth_Hip_Knee <- factor(combined_data$Arth_Hip_Knee, 
                             levels = c(1, 2),
                             labels = c("Yes", "No"))
# Arthritis of Hand/Wrist
combined_data$Arth_Hand_Wr <- factor(combined_data$Arth_Hand_Wr, 
                                      levels = c(1, 2),
                                      labels = c("Yes", "No"))
# General Health
combined_data$General_Health <- factor(combined_data$General_Health,
                                       levels = c(5, 4, 3, 2, 1),
                                       labels = c("Poor", "Fair", "Good", "Very Good", "Excellent"),
                                     ordered = TRUE)
# Moderate Activities
combined_data$Mod_Activity <- factor(combined_data$Mod_Activity, 
                                       levels = c(1, 2, 3),
                                       labels = c("Yes, limited a lot", "Yes, limited a little", "No, not limited at all"),
                                     ordered = TRUE)

# Climbing several flights of stairs
combined_data$Stairs <- factor(combined_data$Stairs, 
                                     levels = c(1, 2, 3),
                                     labels = c("Yes, limited a lot", "Yes, limited a little", "No, not limited at all"),
                               ordered = TRUE)

# phys amt limit
combined_data$Phys_Amount_Limit <- factor(combined_data$Phys_Amount_Limit, 
                               levels = c(5, 4, 3, 2, 1),
                               labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
                               ordered = TRUE)

# phys type limit
combined_data$Phys_Type_Limit <- factor(combined_data$Phys_Type_Limit, 
                                        levels = c(5, 4, 3, 2, 1),
                                        labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
                                        ordered = TRUE)

# pain work
combined_data$Pain_Work <- factor(combined_data$Pain_Work, 
                                  levels = c(5, 4, 3, 2, 1),
                                  labels = c("Extremely", "Quite a bit", "Moderately", "A little bit", "Not at all"),
                                  ordered = TRUE)

# emo amount limit
combined_data$Emo_Amount_Limit <- factor(combined_data$Emo_Amount_Limit, 
                                         levels = c(5, 4, 3, 2, 1),
                                         labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
                                         ordered = TRUE)

# emo carefulness
combined_data$Emo_Carefulness <- factor(combined_data$Emo_Carefulness, 
                                        levels = c(5, 4, 3, 2, 1),
                                        labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
                                        ordered = TRUE)

# peace
combined_data$Peace <- factor(combined_data$Peace, 
                              levels = c(6, 5, 4, 3, 2, 1),
                              labels = c("None of the time", "A little of the time", "Some of the time", "A good bit of the time", "Most of the time", "All of the time"),
                              ordered = TRUE)

# Energy
combined_data$Energy <- factor(combined_data$Energy,
                               levels = c(6, 5, 4, 3, 2, 1),
                               labels = c("None of the time", "A little of the time", "Some of the time", "A good bit of the time", "Most of the time", "All of the time"),
                               ordered = TRUE)

# Down
combined_data$Down <- factor(combined_data$Down,
                             levels = c(1, 2, 3, 4, 5, 6),
                             labels = c("All of the time", "Most of the time", "A good bit of the time", "Some of the time", "A little of the time", "None of the time"),
                             ordered = TRUE)
# social interference
combined_data$Social_Interference <- factor(combined_data$Social_Interference,
                                            levels = c(1, 2, 3, 4, 5),
                                            labels = c("All of the time", "Most of the time", "Some of the time", "A little of the time", "None of the time"),
                                            ordered = TRUE)

# Bathing
combined_data$Bathing <- factor(combined_data$Bathing, 
                                            levels = c(1, 2, 3),
                                            labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"),
                                ordered = TRUE)

# Dressing
combined_data$Dressing <- factor(combined_data$Dressing, 
                                levels = c(1, 2, 3),
                                labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"),
                                ordered = TRUE)

# Eating
combined_data$Eating <- factor(combined_data$Eating, 
                                 levels = c(1, 2, 3),
                                 labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"),
                               ordered = TRUE)

# Chairs
combined_data$Chairs <- factor(combined_data$Chairs, 
                               levels = c(1, 2, 3),
                               labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"),
                               ordered = TRUE)

# Walking
combined_data$Walking <- factor(combined_data$Walking, 
                               levels = c(1, 2, 3),
                               labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"),
                               ordered = TRUE)

# Toilet
combined_data$Toilet <- factor(combined_data$Toilet, 
                               levels = c(1, 2, 3),
                               labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"),
                               ordered = TRUE)

# htn
combined_data$Hypertension <- factor(combined_data$Hypertension, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# angina/cad
combined_data$ANG_CAD <- factor(combined_data$ANG_CAD, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# chf
combined_data$CHF <- factor(combined_data$CHF, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# mi
combined_data$MI <- factor(combined_data$MI, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# other heart conditions
combined_data$Heart_Other <- factor(combined_data$Heart_Other, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# Stroke
combined_data$Stroke <- factor(combined_data$Stroke, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# COPD
combined_data$COPD <- factor(combined_data$COPD, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# IBD
combined_data$IBD <- factor(combined_data$IBD, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# Sciatica
combined_data$Sciatica <- factor(combined_data$Sciatica, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# Diabetes
combined_data$Diabetes <- factor(combined_data$Diabetes, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# cancer
combined_data$Cancer <- factor(combined_data$Cancer, 
                                     levels = c(1, 2),
                                     labels = c("Yes", "No"))

# current smoker
combined_data$Smoking_Status <- factor(combined_data$Smoking_Status, 
                                     levels = c(3, 2, 1),
                                     labels = c("Not at all", "Some days", "Every day"),
                                     ordered = TRUE)

# region
combined_data$Region <- factor(combined_data$Region, 
                                     levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                                     labels = c(
                                       "Region 1 - Boston (CT, ME, MA, NH, RI, and VT)",
                                       "Region 2 - New York (NJ, NY, PR, and the VI)",
                                       "Region 3 - Philadelphia (DC, DE, MD, PA, VA, and WV)",
                                       "Region 4 - Atlanta (AL, FL, GA, KY, MS, NC, SC, and TN)",
                                       "Region 5 - Chicago (IL, IN, MI, MN, OH, and WI)",
                                       "Region 6 - Dallas (AR, LA, NM, OK, and TX)",
                                       "Region 7 - Kansas City (IA, KS, MO, and NE)",
                                       "Region 8 - Denver (CO, MT, ND, SD, UT, and WY)",
                                       "Region 9 - San Francisco (AZ, CA, Guam, HI, and NV)",
                                       "Region 10 - Seattle (AK, ID, OR, and WA)"))

# Cohort: 0 = 1998 (c1), 1 = 2020 (c23)
# TODO should i treat as ordinal? i didnt because there's no inherent "ordering" as im doing the comparison over time (time point categories as independent var)
combined_data$cohort <- factor(combined_data$cohort, 
                               levels = c(0, 1),
                               labels = c("Cohort 1 (1998)", "Cohort 23 (2020)"))

for (col in colnames(combined_data)) {
  # Check its datatypes
  unique_types <- unique(sapply(combined_data[[col]], typeof))
  
  # and print
  cat("Column:", col, "\n")
  print(unique_types)
  cat("\n")
}

for (col_name in colnames(combined_data)) {
  unique_values <- unique(combined_data[[col_name]])  # Get unique values for each column
  print(paste("Unique values in column", col_name, ":"))
  print(length(unique_values))
  print(unique_values)
}

# and read into excel sheet
# Create a new workbook
wb <- createWorkbook()

# for factored, relabeled data
addWorksheet(wb, "categorical")
writeData(wb, sheet = "categorical", combined_data) 

# for numerical categories version
addWorksheet(wb, "numerical")
writeData(wb, sheet = "numerical", combined_data_copy) 

# Save the workbook to a file
saveWorkbook(wb, file = "combined_data_updated.xlsx", overwrite = TRUE)

rm(wb) # remove workbook object
gc() # run garbage collection (frees memory)

