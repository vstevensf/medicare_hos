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



## Set working directory -- change as needed (have to access CSVs below)
# setwd("/Users/M296398/Desktop/medicare_HOS_ortho/stats redo w strat")
setwd("C:\\Users\\Victoria\\Desktop\\medicare")

## Read in PUF files -- change filenames as needed
df_1998 <- read.csv("C1_1998_PUF.csv") # Cohort 1, 1998 = 134076 x 200
df_2020 <- read.csv("C23A_2020_PUF.csv") # Cohort 23, 2020 = 281791 x 160

### Data Preprocessing
## Remove unnecessary cols -- we want demographics, arthritis status, and PROMs
c1_cols <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "B1ATHHIP", "B1GENHTH", 
  "B1MODACT", "B1CLMBSV", "B1PACMPL", "B1PLMTKW", "B1EACMPL", "B1ENTCRF", 
  "B1PNINTF", "B1PCEFUL", "B1ENERGY", "B1BLSAD", "B1SCLACT", "B1DIFBTH", 
  "B1DIFDRS", "B1DIFEAT", "B1DIFCHR", "B1DIFWLK", "B1DIFTOL", "B1DIABET", 
  "B1ANGCAD", "B1HIGHBP", "B1CHF", "B1AMI", "B1GI_ETC", "B1COPD_E", "B1SMKFRQ", 
  "B1STROKE"
)
c23_cols <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "B23CCARTHIP", 
  "B23VRGENHTH", "B23VRMACT", "B23VRSTAIR", "B23VRPACCL", "B23VRPWORK", 
  "B23VRMACCL", "B23VRMWORK", "B23VRPAIN", "B23VRCALM", "B23VRENERGY", 
  "B23VRDOWN", "B23VRSACT", "B23ADLBTH", "B23ADLDRS", "B23ADLEAT", 
  "B23ADLCHR", "B23ADLWLK", "B23ADLTLT", "B23CCDIABET", "B23CC_CAD", 
  "B23CCHBP", "B23CC_CHF", "B23CCMI", "B23CCGI", "B23CC_COPD", "B23SMOKE", 
  "B23CCSTROKE"
)

filtered_df_1998 <- df_1998[, c1_cols]
filtered_df_2020 <- df_2020[, c23_cols]

## Standardize column names between the two cohorts
new_col_names <- c(
  "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Arthritis", "General_Health", 
  "Mod_Activity", "Stairs", "Phys_Amount_Limit", "Phys_Type_Limit", "Emo_Amount_Limit", 
  "Emo_Carefulness", "Pain_Work", "Peace", "Energy", "Down", "Social_Interference", 
  "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet", "Diabetes", 
  "ANG_CAD", "Hypertension", "CHF", "MI", "IBD", "COPD", "Smoking_Status", "Stroke"
)
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
} # all cols are of type integer except CASE_ID, which is char

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

# Handle integer columns
# Function to check if a integer value is "empty"
is_empty_integer <- function(x) {
  is.null(x) || is.na(x) || length(x) == 0
}
# Apply the empty check to the rest of the columns
cols_to_check <- new_col_names[2:length(new_col_names)]
for (col in cols_to_check) {
  # remove rows with "empty" values
  cleaned_again_1998 <- cleaned_1998[!sapply(cleaned_1998[[col]], is_empty_integer), ]
  cleaned_again_2020 <- cleaned_2020[!sapply(cleaned_2020[[col]], is_empty_integer), ]
}

# double check that we really got rid of all the NAs/empties
# Use complete.cases() to remove rows with NA in the specified columns
cleanest_1998 <- cleaned_again_1998[complete.cases(cleaned_again_1998[, new_col_names]), ]
cleanest_2020 <- cleaned_again_2020[complete.cases(cleaned_again_2020[, new_col_names]), ]

## Select the patients with arthritis & removal of extraneous data
#create cohorts of patients with arthritis
#1 = yes, 2 = no -- so keep the rows that have 1 as the value under arthritis
arth_1998 <- cleanest_1998[cleanest_1998$Arthritis == 1, ]
arth_2020 <- cleanest_2020[cleanest_2020$Arthritis == 1, ]

# Remove rows where GENDER == 3
final_1998 <- arth_1998[arth_1998$GENDER != 3, ] # 22001 x 34
final_2020 <- arth_2020[arth_2020$GENDER != 3, ] # 89311 x 34

## Make sure all scoring is the same (differs from year to year, refer to HOS docs)
# VR12: Transforming "Phys_Amount_Limit", "Phys_Type_Limit", "Emo_Amount_Limit", "Emo_Carefulness" for 2020
# "Phys_Amount_Limit" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
# "Phys_Type_Limit" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
# "Emo_Amount_Limit" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
# "Emo_Carefulness" - 1998 = 1 (Yes) 2 (No), 2020 1 (No) 2-5 (Yes)
final_2020$Phys_Amount_Limit <- ifelse(final_2020$Phys_Amount_Limit == 1, 2, 1)
final_2020$Phys_Type_Limit <- ifelse(final_2020$Phys_Type_Limit == 1, 2, 1)
final_2020$Emo_Amount_Limit <- ifelse(final_2020$Emo_Amount_Limit == 1, 2, 1)
final_2020$Emo_Carefulness <- ifelse(final_2020$Emo_Carefulness == 1, 2, 1)

# Transforming ADL variables "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet" for 2020
# "Bathing" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Dressing" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Eating" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Chairs" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Walking" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
# "Toilet" - 1998 = 1 (Can't do) 2 (Yes, difficult) 3 (No difficulty), 2020 = 1 (no difficulty) 2 (yes, difficult) 3 (can't do)
final_2020$Bathing <- ifelse(final_2020$Bathing == 1, 3, ifelse(final_2020$Bathing == 2, 2, 1))
final_2020$Dressing <- ifelse(final_2020$Dressing == 1, 3, ifelse(final_2020$Dressing == 2, 2, 1))
final_2020$Eating <- ifelse(final_2020$Eating == 1, 3, ifelse(final_2020$Eating == 2, 2, 1))
final_2020$Chairs <- ifelse(final_2020$Chairs == 1, 3, ifelse(final_2020$Chairs == 2, 2, 1))
final_2020$Walking <- ifelse(final_2020$Walking == 1, 3, ifelse(final_2020$Walking == 2, 2, 1))
final_2020$Toilet <- ifelse(final_2020$Toilet == 1, 3, ifelse(final_2020$Toilet == 2, 2, 1))

## Combining the cohorts into one dataframe (necessary for propensity matching)
# Add a binary cohort variable indicating the...cohort
final_1998$cohort <- 0 # 22001 x 35
final_2020$cohort <- 1 # 89311 x 35
# and remove the arthritis column cos we don't need it anymore
# col number should be 34 total per cohort after this
final_1998$Arthritis = NULL
final_2020$Arthritis = NULL

# Combine the cohort dataframes (vertical stack)
#TODO treated vs control??
# column names, number, and datatype must match (made sure of this above w preprocessing)
combined_data <- rbind(final_1998, final_2020) # 111312 records/rows

