# 11/12/24

# run vic_preprocessing.R before this

## Description of the data
# summ_combined_data <- as.data.frame(summary(combined_data))
cols_of_interest <- c("AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Arth_Hand_Wr",
                      "General_Health", "Mod_Activity", "Stairs", "Phys_Amount_Limit",
                      "Phys_Type_Limit", "Pain_Work", "Emo_Amount_Limit", "Emo_Carefulness",
                      "Peace", "Energy", "Down", "Social_Interference", "Bathing",
                      "Dressing", "Eating", "Chairs", "Walking", "Toilet",
                      "Hypertension", "ANG_CAD", "CHF", "MI", "Heart_Other",
                      "Stroke", "COPD", "IBD", "Sciatica", "Diabetes", "Cancer",
                      "Smoking_Status", "Region", "cohort")
summ_combined_data <- lapply(combined_data[, cols_of_interest], table)

# and read into excel sheet
# Create a new workbook
wb <- createWorkbook()

# for factored, relabeled data
addWorksheet(wb, "descriptive")
start_row <- 1  # Initialize starting row for the first table

for (i in seq_along(summ_combined_data)) {
  # Write the table to the sheet at the specified starting row
  writeData(wb, sheet = "descriptive", summ_combined_data[[i]], startRow = start_row)
  
  # Update the starting row for the next table, adding space if needed (e.g., add 2 rows)
  start_row <- start_row + nrow(summ_combined_data[[i]]) + 2  # Add 2 for a blank row between tables
}

# Save the workbook to a file
saveWorkbook(wb, file = "descr_stats.xlsx", overwrite = TRUE)

rm(wb) # remove workbook object
gc() # run garbage collection (frees memory)
