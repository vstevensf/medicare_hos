install.packages("tableone")
library(tableone) # summary stats and balance
install.packages("openxlsx")
library(openxlsx) # writing results to excel sheet
install.packages("dplyr")
library(dplyr) # for data manipulation
install.packages("ggplot2")
library(ggplot2) # plots


## Custom function to determine if Fisher's or Chi-squared was used (in CreateTableOne)
check_test_type <- function(var1, var2, data) {
  # Create a contingency table
  tbl <- table(data[[var1]], data[[var2]])
  
  # Perform Chi-squared test to extract expected counts
  chi_sq_test <- chisq.test(tbl)
  
  # Check if any expected count is less than 5
  if (any(chi_sq_test$expected < 5)) {
    return("Fisher's Exact Test")
  } else {
    return("Chi-squared Test")
  }
}


## Demographics descriptive statistics table
# checking frequencies/statistical test type
demos_to_check <- c("AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Region")
for (col in demos_to_check) {
  print(table(combined_data[[col]]))
} # high freqs for all categories, prolly will run chi sq over fisher
sapply(demos_to_check, function(var) check_test_type(var, "cohort", combined_data)) # ran chi sq on all of them

# compute descriptive stats
demos_table <- CreateTableOne(vars = demos_to_check,
                              strata = "cohort", 
                              data = combined_data)
# save output
df_demos_table <- as.data.frame(print(demos_table, 
                                      showAllLevels = TRUE, 
                                      noSpaces = TRUE,
                                      smd = TRUE))
# Extract percentages (numbers inside parentheses with or without spaces)
df_demos_table$Cohort1_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_demos_table$`Cohort 1 (1998)`))
df_demos_table$Cohort2_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_demos_table$`Cohort 23 (2020)`))
# calculate percent diff
df_demos_table$percent_diff <- df_demos_table$Cohort2_percent - df_demos_table$Cohort1_percent
# and write to excel workbook
wbss <- createWorkbook() # Create a new workbook
addWorksheet(wbss, "demos")
writeData(wbss, sheet = "demos", df_demos_table, rowNames = TRUE) 
saveWorkbook(wbss, file = "summary_stats.xlsx", overwrite = TRUE) # save sheet


## Comorbidities descriptive statistics table
comorbidities_to_check <- c(
  "Arth_Hand_Wr", "Hypertension", "ANG_CAD", "CHF", "MI", "Heart_Other", "Stroke",
  "COPD", "IBD", "Sciatica", "Diabetes", "Cancer", "Smoking_Status" 
)
# checking frequencies/statistical test type
for (col in comorbidities_to_check) {
  print(table(combined_data[[col]]))
}
sapply(comorbidities_to_check, function(var) check_test_type(var, "cohort", combined_data)) # ran chisq for all
# compute descriptive stats
comorb_table <- CreateTableOne(vars = comorbidities_to_check,
                              strata = "cohort", 
                              data = combined_data)
# save output
df_comorb_table <- as.data.frame(print(comorb_table, 
                                      showAllLevels = TRUE, 
                                      noSpaces = TRUE,
                                      smd = TRUE))
# Extract percentages
df_comorb_table$Cohort1_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_comorb_table$`Cohort 1 (1998)`))
df_comorb_table$Cohort2_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_comorb_table$`Cohort 23 (2020)`))
# calculate percent diff
df_comorb_table$percent_diff <- df_comorb_table$Cohort2_percent - df_comorb_table$Cohort1_percent
# and write to same excel workbook, new sheet
wbss <- loadWorkbook("summary_stats.xlsx")
addWorksheet(wbss, "comorb")
writeData(wbss, sheet = "comorb", df_comorb_table, rowNames = TRUE) 
saveWorkbook(wbss, file = "summary_stats.xlsx", overwrite = TRUE) # save sheet



#### PROMs descriptive statistics tables
### VR12 = PCS (Physical Health) + MCS (Mental Health)
## PCS = General health + mod activites + stairs (several) + phys accomplished less + phys limited in kind + pain interference
pcs_vr12_to_check <- c( 
  "General_Health", "Mod_Activity", "Stairs", "Phys_Amount_Limit", 
  "Phys_Type_Limit", "Pain_Work"
  )
# checking frequencies/statistical test type
for (col in pcs_vr12_to_check) {
  print(table(combined_data[[col]]))
} # high freqs, will prolly go for chisq
sapply(pcs_vr12_to_check, function(var) check_test_type(var, "cohort", combined_data)) # ran chisq for all
# compute descriptive stats
pcs_vr12_table <- CreateTableOne(vars = pcs_vr12_to_check,
                               strata = "cohort", 
                               data = combined_data)
# save output
df_pcs_vr12_table <- as.data.frame(print(pcs_vr12_table, 
                                       showAllLevels = TRUE, 
                                       noSpaces = TRUE,
                                       smd = TRUE))
# Extract percentages
df_pcs_vr12_table$Cohort1_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_table$`Cohort 1 (1998)`))
df_pcs_vr12_table$Cohort2_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_table$`Cohort 23 (2020)`))
# calculate percent diff
df_pcs_vr12_table$percent_diff <- df_pcs_vr12_table$Cohort2_percent - df_pcs_vr12_table$Cohort1_percent
# and write to same excel workbook, new sheet
wbss <- loadWorkbook("summary_stats.xlsx")
addWorksheet(wbss, "pcs")
writeData(wbss, sheet = "pcs", df_pcs_vr12_table, rowNames = TRUE) 
saveWorkbook(wbss, file = "summary_stats.xlsx", overwrite = TRUE) # save sheet

## MCS =  emo accomplished less + not careful + peaceful + energy + down-hearted + social activity interference
mcs_vr12_to_check <- c(
  "Emo_Amount_Limit", "Emo_Carefulness",  "Peace", "Energy", "Down",
  "Social_Interference"
)
# checking frequencies/statistical test type
for (col in mcs_vr12_to_check) {
  print(table(combined_data[[col]]))
} # high freqs, will prolly go for chisq
sapply(mcs_vr12_to_check, function(var) check_test_type(var, "cohort", combined_data)) # ran chisq for all
# compute descriptive stats
mcs_vr12_table <- CreateTableOne(vars = mcs_vr12_to_check,
                                 strata = "cohort", 
                                 data = combined_data)
# save output
df_mcs_vr12_table <- as.data.frame(print(mcs_vr12_table, 
                                         showAllLevels = TRUE, 
                                         noSpaces = TRUE,
                                         smd = TRUE))
# Extract percentages
df_mcs_vr12_table$Cohort1_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_mcs_vr12_table$`Cohort 1 (1998)`))
df_mcs_vr12_table$Cohort2_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_mcs_vr12_table$`Cohort 23 (2020)`))
# calculate percent diff
df_mcs_vr12_table$percent_diff <- df_mcs_vr12_table$Cohort2_percent - df_mcs_vr12_table$Cohort1_percent
# and write to same excel workbook, new sheet
wbss <- loadWorkbook("summary_stats.xlsx")
addWorksheet(wbss, "mcs")
writeData(wbss, sheet = "mcs", df_mcs_vr12_table, rowNames = TRUE) 
saveWorkbook(wbss, file = "summary_stats.xlsx", overwrite = TRUE) # save sheet



### ADLs
# checking frequencies/statistical test type
adls_to_check <- c(
  "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet"
)
for (col in adls_to_check) {
  print(table(combined_data[[col]]))
} # high freqs, will prolly go for chisq
sapply(adls_to_check, function(var) check_test_type(var, "cohort", combined_data)) # ran chisq for all
# compute descriptive stats
adls_table <- CreateTableOne(vars = adls_to_check,
                                 strata = "cohort", 
                                 data = combined_data)
# save output
df_adls_table <- as.data.frame(print(adls_table, 
                                         showAllLevels = TRUE, 
                                         noSpaces = TRUE,
                                         smd = TRUE))
# Extract percentages
df_adls_table$Cohort1_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_adls_table$`Cohort 1 (1998)`))
df_adls_table$Cohort2_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_adls_table$`Cohort 23 (2020)`))
# calculate percent diff
df_adls_table$percent_diff <- df_adls_table$Cohort2_percent - df_adls_table$Cohort1_percent
# and write to same excel workbook, new sheet
wbss <- loadWorkbook("summary_stats.xlsx")
addWorksheet(wbss, "adls")
writeData(wbss, sheet = "adls", df_adls_table, rowNames = TRUE) 
saveWorkbook(wbss, file = "summary_stats.xlsx", overwrite = TRUE) # save sheet



################### Figures
## Demographics by cohort
# Proportional bar plot to compare age distribution by cohort
ggplot(combined_data, aes(x = cohort, fill = AGE)) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Age Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Age") +
  theme_minimal()

# race
ggplot(combined_data, aes(x = cohort, fill = RACE)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Race Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Race") +
  theme_minimal()


# gender
ggplot(combined_data, aes(x = cohort, fill = GENDER)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Gender Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Gender") +
  theme_minimal()

# married status
ggplot(combined_data, aes(x = cohort, fill = MRSTAT)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Marital Status Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Marital Status") +
  theme_minimal()

# education
ggplot(combined_data, aes(x = cohort, fill = EDUC)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Education Level Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Education Level") +
  theme_minimal()

# region
ggplot(combined_data, aes(x = cohort, fill = Region)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Regional Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Region") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 0.6),  # Rotate labels
        legend.text = element_text(size = 7),  # Reduce legend text size
        legend.key.size = unit(0.5, "cm"),     # Reduce the size of legend keys
        legend.spacing.y = unit(0.2, "cm"))    # Reduce space between legend items

# region p2
# Prepare the data by summarizing the count of each category within each cohort
region_summary <- combined_data %>%
  group_by(Region, cohort) %>%   # Group by cohort and gender
  summarise(count = n()) %>%     # Count the occurrences
  group_by(cohort) %>%
  mutate(proportion = count / sum(count))  # Calculate proportions if needed

# Create the side-by-side bar plot (dodged) for gender by cohort
ggplot(region_summary, aes(x = Region, y = proportion, fill = cohort)) +
  geom_bar(stat = "identity", position = position_dodge()) +  # Use position_dodge for side-by-side bars
  scale_y_continuous(labels = scales::percent_format()) +  # Show proportions as percentages
  scale_x_discrete(labels = c(
    "Region 1 - Boston (CT, ME, MA, NH, RI, and VT)" = "1",
    "Region 2 - New York (NJ, NY, PR, and the VI)" = "2",
    "Region 3 - Philadelphia (DC, DE, MD, PA, VA, and WV)" = "3",
    "Region 4 - Atlanta (AL, FL, GA, KY, MS, NC, SC, and TN)" = "4",
    "Region 5 - Chicago (IL, IN, MI, MN, OH, and WI)" = "5",
    "Region 6 - Dallas (AR, LA, NM, OK, and TX)" = "6",
    "Region 7 - Kansas City (IA, KS, MO, and NE)" = "7",
    "Region 8 - Denver (CO, MT, ND, SD, UT, and WY)" = "8",
    "Region 9 - San Francisco (AZ, CA, Guam, HI, and NV)" = "9",
    "Region 10 - Seattle (AK, ID, OR, and WA)" = "10"
  )) +  # Rename x-axis labels
  labs(title = "Region Distribution by Cohort",
       x = "Region", y = "Count", fill = "Cohort") +
  theme_minimal() + 
  theme(
    legend.position = "top", 
    axis.text.x = element_text(size = 10))


## Comorbidities by cohort
# hand/wrist arthritis
ggplot(combined_data, aes(x = cohort, fill = Arth_Hand_Wr)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Arthritis of Hand or Knee Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Arth_Hand_Wr") +
  theme_minimal()

# hypertension
ggplot(combined_data, aes(x = cohort, fill = Hypertension)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Hypertension Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Hypertension") +
  theme_minimal()

# ang_cad
ggplot(combined_data, aes(x = cohort, fill = ANG_CAD)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Angina Pectoris/Coronary Artery Disease \nDistribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Angina/CAD") +
  theme_minimal()

# chf
ggplot(combined_data, aes(x = cohort, fill = CHF)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Congestive Heart Failure Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "CHF") +
  theme_minimal()

# mi
ggplot(combined_data, aes(x = cohort, fill = MI)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Myocardial Infarction Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "MI") +
  theme_minimal()

# other heart
ggplot(combined_data, aes(x = cohort, fill = Heart_Other)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional \"Other Heart Condition\" Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Heart_Other") +
  theme_minimal()

# Stroke
ggplot(combined_data, aes(x = cohort, fill = Stroke)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Stroke Distribution by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Stroke") +
  theme_minimal()

# copd
ggplot(combined_data, aes(x = cohort, fill = COPD)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional COPD/Emphysema/Asthma by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "COPD") +
  theme_minimal()

# ibd
ggplot(combined_data, aes(x = cohort, fill = IBD)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional IBD (Crohn's, Ulcerative Colitis) by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "IBD") +
  theme_minimal()

# sciatica
ggplot(combined_data, aes(x = cohort, fill = Sciatica)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Sciatica by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Sciatica") +
  theme_minimal()

# diabetes
ggplot(combined_data, aes(x = cohort, fill = Diabetes)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Diabetes/Hyperglycemia/Glycosuria by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Diabetes") +
  theme_minimal()

# cancer
ggplot(combined_data, aes(x = cohort, fill = Cancer)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional \"Any cancer (excluding skin cancer)\" by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Cancer") +
  theme_minimal()

# current smoking status
ggplot(combined_data, aes(x = cohort, fill = Smoking_Status)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Current Smoking Status by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Smoking_Status") +
  theme_minimal()


## PCS of VR12 by cohort
# general health
ggplot(combined_data, aes(x = cohort, fill = General_Health)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional General Health by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "General_Health") +
  theme_minimal()

# moderate activities
ggplot(combined_data, aes(x = cohort, fill = Mod_Activity)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Limited Moderate Activities by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Mod_Activity") +
  theme_minimal()

# several flights of stairs
ggplot(combined_data, aes(x = cohort, fill = Stairs)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Limited in Climbing Several Flights of Stairs by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Stairs") +
  theme_minimal()

# phys amt limit
ggplot(combined_data, aes(x = cohort, fill = Phys_Amount_Limit)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Physical Health Limiting Amount Accomplished by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Phys_Amount_Limit") +
  theme_minimal()

# phys type limit
ggplot(combined_data, aes(x = cohort, fill = Phys_Type_Limit)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Physical Health Kind of Activities by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Phys_Type_Limit") +
  theme_minimal()

# pain work
ggplot(combined_data, aes(x = cohort, fill = Pain_Work)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Pain Interfering with Work by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Pain_Work") +
  theme_minimal()


## MCS of VR12 by cohort
# emo amt limit
ggplot(combined_data, aes(x = cohort, fill = Emo_Amount_Limit)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Emotional Problems Limiting Amount Accomplished\n by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Emo_Amount_Limit") +
  theme_minimal()

# emo carefulness
ggplot(combined_data, aes(x = cohort, fill = Emo_Carefulness)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Emotional Problems Limiting Carefulness\n by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Emo_Carefulness") +
  theme_minimal()

# peace
ggplot(combined_data, aes(x = cohort, fill = Peace)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Calm and Peaceful by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Peace") +
  theme_minimal()

# energy
ggplot(combined_data, aes(x = cohort, fill = Energy)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Lots of Energy by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Energy") +
  theme_minimal()

# down
ggplot(combined_data, aes(x = cohort, fill = Down)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Downhearted and Blue by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Down") +
  theme_minimal()

# social interference
ggplot(combined_data, aes(x = cohort, fill = Social_Interference)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Amount of Time Health Interfering with Social Activities\n by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Social_Interference") +
  theme_minimal()


## ADLs by cohort
# bathing
ggplot(combined_data, aes(x = cohort, fill = Bathing)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Difficulty Bathing by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Bathing") +
  theme_minimal()

# dressing
ggplot(combined_data, aes(x = cohort, fill = Dressing)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Difficulty Dressing by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Dressing") +
  theme_minimal()

# eating
ggplot(combined_data, aes(x = cohort, fill = Eating)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Difficulty Eating by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Eating") +
  theme_minimal()

# chairs
ggplot(combined_data, aes(x = cohort, fill = Chairs)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Difficulty Getting In/Out of Chairs by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Chairs") +
  theme_minimal()

# walking
ggplot(combined_data, aes(x = cohort, fill = Walking)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Difficulty Walking by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Walking") +
  theme_minimal()

# toilet
ggplot(combined_data, aes(x = cohort, fill = Toilet)) +
  geom_bar(position = "fill", width = 0.7) + 
  labs(title = "Proportional Difficulty Using the Toilet by Cohort", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Toilet") +
  theme_minimal()

################
rm(wbss) # remove workbook object
gc() # run garbage collection (frees memory)


