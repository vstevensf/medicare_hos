#### Convert Cohort 18/19/20/21/22 ASCII file into CSV 
## V. Stevens 11/16/24

# Set working directory
# setwd("C:\\Users\\m296398\\Desktop\\medicare_hos\\ascii_to_csv")
setwd("/Users/m296398/Desktop/medicare_hos/ascii_to_csv")

# Define the file path to the fixed-width ASCII file.
# ascii_file <- "C18B_PUF.TXT"
# ascii_file <- "C19B_PUF.TXT"
# ascii_file <- "C20B_PUF.TXT"
# ascii_file <- "C21B_PUF.TXT"
ascii_file <- "C22B_PUF.TXT"

# List of column names for converted file (CSV fields)
# TODO: there is a more elegant way to do this -- read from CSV file
# or sumthin and put into a vector but im too tired rn
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

# checks to see how many records (rows) there are in the original ASCII file
all_lines <- readLines(ascii_file)
length(all_lines) # 260608 for 2016, 256652 for 2017, 239071 for 2018
# 231910 for 2019

# Define the indices and column names
start_indices <- c(
  1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 
  31, 32, 33, 34, 35, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 64, 77,
  92, 93, 106
) # Starting indices for substrings

end_indices <- c(
  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 
  31, 32, 33, 34, 35, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 64, 77, 
  92, 95, 107
) # Ending indices for substrings

# Initialize an empty data frame
output_df <- data.frame(matrix(ncol = length(new_fields), nrow = length(all_lines)))
colnames(output_df) <- new_fields

# Loop through each line to extract values based on indices
for (i in seq_along(all_lines)) {
  print(i)
  for (j in seq_along(start_indices)) {
    # Extract substring and assign to the appropriate column
    output_df[i, new_fields[j]] <- substr(all_lines[i], start_indices[j], end_indices[j])
  }
}

# Export the DataFrame into a CSV file and name the file
# this will also take a sec
# row.names false to not copy over record (row) number
# write.csv(output_df, file = "C18_2015_PUF.csv", row.names = FALSE)
# write.csv(output_df, file = "C19_2016_PUF.csv", row.names = FALSE)
# write.csv(output_df, file = "C20_2017_PUF.csv", row.names = FALSE)
# write.csv(output_df, file = "C21_2018_PUF.csv", row.names = FALSE)
write.csv(output_df, file = "C22_2019_PUF.csv", row.names = FALSE)
