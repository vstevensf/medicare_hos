# Medicare HOS, R 4.4.1
# PROMs trends over time: 1998 vs 2020 (cohort 1 vs 23)
# this serves as the preprocessing script
# where we take the raw HOS data, pare down to the arthritis,
# demographics, and PROMs columns
# remove outliers or weird answers
# standardize the scoring to match between the two cohorts
# get demographic characteristics about the raw data TODO.
# ascii to csv conversion must be completed before this
# Victoria Stevens 8/15/24

# imports
install.packages("openxlsx")
library(openxlsx)



## Set working directory -- change as needed (have to access CSVs below)
# setwd("/Users/M296398/Desktop/medicare_HOS_ortho/medicare_hos")
setwd("C:\\Users\\m296398\\Desktop\\medicare_hos")


## Read in PUF files -- change filenames as needed
df_1998 <- read.csv("C1_1998_PUF.csv") # Cohort 1, 1998 = 134076 x 200
df_2020 <- read.csv("C23A_2020_PUF.csv") # Cohort 23, 2020 = 281791 x 160

### Data Preprocessing
## Remove unnecessary cols -- we want demographics, arthritis status, and PROMs

# TODO: no income status available (include as pitfall in paper), no retirement comm in cohort 23
# only overlapping questions
# had to recategorize for some (c23)
# very broad categories (nature of survey data)
# no residential status or BMI info on both

# VR12
# PCS = general health, moderate activities, climbing several stairs, accomplished less, limited in kind, pain interfernece
#     B1GENHTH, B1MODACT, B1CLMBSV, B1PACML, B1PLMTKW. B1PNINTF
#     B23VRGENHTH, B23VRMACT, B23VRSTAIR, B23VRPACCL, B23VRPWORK, B23VRPAIN
# MCS = accomplished less, not carefully as usual, energy, peaceful, down-hearted, interference in social activites
#     B1EACMPL, B1ENTCRF, B1ENERGY, B1PCEFUL, B1BLSAD, B1SCLACT
#     B23VRMACCL, B23VRMWORK, B23VRENERGY, B23VRCALM, B23VRDOWN, B23VRSACT
# ADLs = bathing, dressing, eating, chairs, walking, toilet
#     B1DIFBTH, B1DIFDRS, B1DIFEAT, B1DIFCHR, B1DIFWLK, B1DIFTOL
#     B23ADLBTH, B23ADLDRS, B23ADLEAT, B23ADLCHR, B23ADLWLK, B23ADLTLT
# comorbidities: htn, angina/CAD, CHF, MI, other heart, stroke, COPD, IBD, HKA, HWA, sciatica, DBM, any cancer
#     B1HIGHBP, B1ANGCAD, B1CHF, B1AMI, B1OTHHRT, B1STROKE, B1COPD_E,  B1GI_ETC,  B1ATHHIP, B1ATHHAN, B1WSCIATC, B1DIABET, B1ANYCAN
#     B23CCHBP, B23CC_CAD, B23CC_CHF, B23CCMI, B23CCHRTOTH,  B23CCSTROKE, B23CC_COPD, B23CCGI, B23CCARTHIP, B23CCARTHND, B23CCSCIATI, B23CCDIABET, B23CCANYCA
# smoking: current smoker
#     B1SMKFRQ
#     B23SMOKE
# survey disposition (98) , CMS plan region (102) , person ccompleting
#     B1SRVDSP, P1PLREGCDE, B1WHOCMP
#     B23SRVDISP, P23PLREGCDE, B23CMPWHO

c1_cols <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "B1ATHHIP", "B1ATHHAN", "B1GENHTH", 
  "B1MODACT", "B1CLMBSV", "B1PACMPL", "B1PLMTKW", "B1PNINTF", "B1EACMPL",  
  "B1ENTCRF", "B1PCEFUL", "B1ENERGY", "B1BLSAD", "B1SCLACT", "B1DIFBTH", 
  "B1DIFDRS", "B1DIFEAT", "B1DIFCHR", "B1DIFWLK", "B1DIFTOL", "B1HIGHBP",
  "B1ANGCAD", "B1CHF", "B1AMI", "B1OTHHRT", "B1STROKE", "B1COPD_E", "B1GI_ETC",
  "B1SCIATC", "B1DIABET", "B1ANYCAN", "B1SMKFRQ", "B1SRVDSP", "P1PLREGCDE", "B1WHOCMP"
) # length = 41
c23_cols <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "B23CCARTHIP", "B23CCARTHND",
  "B23VRGENHTH", "B23VRMACT", "B23VRSTAIR", "B23VRPACCL", "B23VRPWORK", 
  "B23VRPAIN","B23VRMACCL", "B23VRMWORK",  "B23VRCALM", "B23VRENERGY", 
  "B23VRDOWN", "B23VRSACT", "B23ADLBTH", "B23ADLDRS", "B23ADLEAT", 
  "B23ADLCHR", "B23ADLWLK", "B23ADLTLT", "B23CCHBP", "B23CC_CAD",
  "B23CC_CHF", "B23CCMI", "B23CCHRTOTH", "B23CCSTROKE", "B23CC_COPD",
  "B23CCGI", "B23CCSCIATI", "B23CCDIABET", "B23CCANYCA", "B23SMOKE",
  "B23SRVDISP", "P23PLREGCDE", "B23CMPWHO"
) # length = 41

filtered_df_1998 <- df_1998[, c1_cols]
filtered_df_2020 <- df_2020[, c23_cols]

## Standardize column names between the two cohorts
new_col_names <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Arth_Hip_Knee", "Arth_Hand_Wr", "General_Health", 
  "Mod_Activity", "Stairs", "Phys_Amount_Limit", "Phys_Type_Limit", "Pain_Work",
  "Emo_Amount_Limit", "Emo_Carefulness",  "Peace", "Energy", "Down", "Social_Interference", 
  "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet", "Hypertension", 
  "ANG_CAD",  "CHF", "MI", "Heart_Other", "Stroke", "COPD", "IBD", "Sciatica",
  "Diabetes", "Cancer", "Smoking_Status", "Survey_Disp", "Region", "Who_Comp"
) # length = 41
# Copy and replace column names
renamed_df_1998 <- `names<-`(filtered_df_1998, replace(names(filtered_df_1998), match(c1_cols, names(filtered_df_1998)), new_col_names))
renamed_df_2020 <- `names<-`(filtered_df_2020, replace(names(filtered_df_2020), match(c23_cols, names(filtered_df_2020)), new_col_names))

## Remove patients that didn't answer all the questions (NAs/blanks)
# Checking the datatypes within each column for each cohort -- make sure they match up
# Loop through each column name
for (col in new_col_names) {
  # Check its datatypes
  unique_types <- unique(sapply(renamed_df_1998[[col]], typeof))
  unique_types2 <- unique(sapply(renamed_df_2020[[col]], typeof))
  
  # and print
  cat("Column:", col, "\n")
  print("cohort 1")
  print(unique_types)
  print("cohort 23")
  print(unique_types2)
  cat("\n")
} # all cols are of type integer except CASE_ID & Survey_Disp, which are char

# Handle char column = CASE_ID
# Function to check if a char value is "empty"
is_empty_char <- function(x) {
  is.null(x) || is.na(x) || x == "" || grepl("^\\s*$", x) || x == "\u00A0" || x == "\u200B" || x == "\n"
}
# Apply the empty check to the 'CASE_ID' column
empty_rows_1998 <- sapply(renamed_df_1998$CASE_ID, is_empty_char)
empty_rows_2020 <- sapply(renamed_df_1998$CASE_ID, is_empty_char)

# Filter the data frames to remove rows with "empty" values in the 'CASE_ID' column
# This didn't make a difference but useful check to have
cleaned_1998 <- renamed_df_1998[!empty_rows_1998, ]
cleaned_2020 <- renamed_df_2020[!empty_rows_2020, ]

# Do it again but for 'Survey_Disp' column (also didn't make difference)
empty_rows_1998_2 <- sapply(cleaned_1998$Survey_Disp, is_empty_char)
empty_rows_2020_2 <- sapply(cleaned_2020$Survey_Disp, is_empty_char)
cleaned_1998_2 <- renamed_df_1998[!empty_rows_1998_2, ]
cleaned_2020_2 <- renamed_df_2020[!empty_rows_2020_2, ]

# Handle integer columns
# Function to check if a integer value is "empty"
is_empty_integer <- function(x) {
  is.null(x) || is.na(x) || length(x) == 0
}
# Apply the empty check to the rest of the columns
cols_to_check <- c(
  "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Arth_Hip_Knee", "Arth_Hand_Wr", "General_Health", 
  "Mod_Activity", "Stairs", "Phys_Amount_Limit", "Phys_Type_Limit", "Pain_Work",
  "Emo_Amount_Limit", "Emo_Carefulness",  "Peace", "Energy", "Down", "Social_Interference", 
  "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet", "Hypertension", 
  "ANG_CAD",  "CHF", "MI", "Heart_Other", "Stroke", "COPD", "IBD", "Sciatica",
  "Diabetes", "Cancer", "Smoking_Status", "Region", "Who_Comp"
)
for (col in cols_to_check) {
  # remove rows with "empty" values
  cleaned_again_1998 <- cleaned_1998_2[!sapply(cleaned_1998_2[[col]], is_empty_integer), ]
  cleaned_again_2020 <- cleaned_2020_2[!sapply(cleaned_2020_2[[col]], is_empty_integer), ]
}

# double check that we really got rid of all the NAs/empties
# Use complete.cases() to remove rows with NA in the specified columns
cleanest_1998 <- cleaned_again_1998[complete.cases(cleaned_again_1998[, new_col_names]), ]
cleanest_2020 <- cleaned_again_2020[complete.cases(cleaned_again_2020[, new_col_names]), ]

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

## Make sure all scoring is the same (differs from year to year, refer to HOS docs)
# VR12: Transforming "Phys_Amount_Limit", "Phys_Type_Limit", "Emo_Amount_Limit", "Emo_Carefulness" for 2020
# "Phys_Amount_Limit" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
# "Phys_Type_Limit" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
# "Emo_Amount_Limit" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
# "Emo_Carefulness" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
arth_2020$Phys_Amount_Limit <- ifelse(arth_2020$Phys_Amount_Limit == 1, 2, 1)
arth_2020$Phys_Type_Limit <- ifelse(arth_2020$Phys_Type_Limit == 1, 2, 1)
arth_2020$Emo_Amount_Limit <- ifelse(arth_2020$Emo_Amount_Limit == 1, 2, 1)
arth_2020$Emo_Carefulness <- ifelse(arth_2020$Emo_Carefulness == 1, 2, 1)

# Transforming ADL variables "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet" for 2020
# "Bathing" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Dressing" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Eating" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Chairs" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Walking" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Toilet" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
arth_2020$Bathing <- ifelse(arth_2020$Bathing == 1, 3, ifelse(arth_2020$Bathing == 2, 2, 1))
arth_2020$Dressing <- ifelse(arth_2020$Dressing == 1, 3, ifelse(arth_2020$Dressing == 2, 2, 1))
arth_2020$Eating <- ifelse(arth_2020$Eating == 1, 3, ifelse(arth_2020$Eating == 2, 2, 1))
arth_2020$Chairs <- ifelse(arth_2020$Chairs == 1, 3, ifelse(arth_2020$Chairs == 2, 2, 1))
arth_2020$Walking <- ifelse(arth_2020$Walking == 1, 3, ifelse(arth_2020$Walking == 2, 2, 1))
arth_2020$Toilet <- ifelse(arth_2020$Toilet == 1, 3, ifelse(arth_2020$Toilet == 2, 2, 1))

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
                               labels = c("65 to 74", "Greater than 74"))
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
                               labels = c("Less than GED", "GED", "Greater than GED"))

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
                                     levels = c(1, 2, 3, 4, 5),
                                     labels = c("Excellent", "Very Good", "Good", "Fair", "Poor"))
# Moderate Activities
combined_data$Mod_Activity <- factor(combined_data$Mod_Activity, 
                                       levels = c(1, 2, 3),
                                       labels = c("Yes, limited a lot", "Yes, limited a little", "No, not limited at all"))

# Climbing several flights of stairs
combined_data$Stairs <- factor(combined_data$Stairs, 
                                     levels = c(1, 2, 3),
                                     labels = c("Yes, limited a lot", "Yes, limited a little", "No, not limited at all"))

# phys amt limit
combined_data$Phys_Amount_Limit <- factor(combined_data$Phys_Amount_Limit, 
                               levels = c(1, 2),
                               labels = c("Yes, accomplished less", "No, not affected"))

# phys type limit
combined_data$Phys_Type_Limit <- factor(combined_data$Phys_Type_Limit, 
                                          levels = c(1, 2),
                                          labels = c("Yes, limited", "No, not limited"))

# pain work
combined_data$Pain_Work <- factor(combined_data$Pain_Work, 
                                        levels = c(1, 2, 3, 4, 5),
                                        labels = c("Not at All", "A little bit", "Moderately", "Quite a bit", "Extremely"))

# emo amount limit
combined_data$Emo_Amount_Limit <- factor(combined_data$Emo_Amount_Limit, 
                                          levels = c(1, 2),
                                          labels = c("Yes, accomplished less", "No, not affected"))

# emo carefulness
combined_data$Emo_Carefulness <- factor(combined_data$Emo_Carefulness, 
                                         levels = c(1, 2),
                                         labels = c("Yes, less careful", "No, not affected"))

# peace
combined_data$Peace <- factor(combined_data$Peace, 
                                        levels = c(1, 2, 3, 4, 5, 6),
                                        labels = c("All of the time", "Most of the time", "A good bit of the time", "Some of the time", "A little of the time", "None of the time"))

# Energy
combined_data$Energy <- factor(combined_data$Energy, 
                              levels = c(1, 2, 3, 4, 5, 6),
                              labels = c("All of the time", "Most of the time", "A good bit of the time", "Some of the time", "A little of the time", "None of the time"))

# Down
combined_data$Down <- factor(combined_data$Down, 
                               levels = c(1, 2, 3, 4, 5, 6),
                               labels = c("All of the time", "Most of the time", "A good bit of the time", "Some of the time", "A little of the time", "None of the time"))

# social interference
combined_data$Social_Interference <- factor(combined_data$Social_Interference, 
                             levels = c(1, 2, 3, 4, 5),
                             labels = c("All of the time", "Most of the time", "Some of the time", "A little of the time", "None of the time"))

# Bathing
combined_data$Bathing <- factor(combined_data$Bathing, 
                                            levels = c(1, 2, 3),
                                            labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"))

# Dressing
combined_data$Dressing <- factor(combined_data$Dressing, 
                                levels = c(1, 2, 3),
                                labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"))

# Eating
combined_data$Eating <- factor(combined_data$Eating, 
                                 levels = c(1, 2, 3),
                                 labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"))

# Chairs
combined_data$Chairs <- factor(combined_data$Chairs, 
                               levels = c(1, 2, 3),
                               labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"))

# Walking
combined_data$Walking <- factor(combined_data$Walking, 
                               levels = c(1, 2, 3),
                               labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"))

# Toilet
combined_data$Toilet <- factor(combined_data$Toilet, 
                               levels = c(1, 2, 3),
                               labels = c("I am unable to do this activity", "Yes, I have difficulty", "No, I do not have difficulty"))

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
                                     levels = c(1, 2, 3),
                                     labels = c("Every day", "Some days", "Not at all"))

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
saveWorkbook(wb, file = "combined_data.xlsx", overwrite = TRUE)

