#### Convert Cohort 11/12/13/14/15 ASCII file into CSV 
## V. Stevens 11/16/24

# Set working directory
# setwd("C:\\Users\\m296398\\Desktop\\medicare_hos\\ascii_to_csv")
setwd("/Users/m296398/Desktop/medicare_hos/ascii_to_csv")

# Define the file path to the fixed-width ASCII file.
# ascii_file <- "C11B_PUF.TXT"
# ascii_file <- "C12B_PUF.TXT"
# ascii_file <- "C13B_PUF.TXT"
# ascii_file <- "C14B_PUF.TXT"
ascii_file <- "C15B_PUF.TXT"

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
length(all_lines) # 240682 for 2008, 298040 for 2009, 347945 for 2010
# 322794 for 2011, 321395 for 2012

# Define the indices and column names
start_indices <- c(
  1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 
  31, 32, 33, 34, 35, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 79, 
  91, 92, 105
) # Starting indices for substrings

end_indices <- c(
  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 
  31, 32, 33, 34, 35, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 79, 
  91, 94, 106
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
# write.csv(output_df, file = "C11_2008_PUF.csv", row.names = FALSE)
# write.csv(output_df, file = "C12_2009_PUF.csv", row.names = FALSE)
# write.csv(output_df, file = "C13_2010_PUF.csv", row.names = FALSE)
# write.csv(output_df, file = "C14_2011_PUF.csv", row.names = FALSE)
write.csv(output_df, file = "C15_2012_PUF.csv", row.names = FALSE)
gc()
