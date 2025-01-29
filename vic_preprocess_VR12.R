# 11/14/24
library(dplyr)

# scoring VR12 for each patient using BU vr12 algorithm
# this is the script to reformat the data

vr12_copy <- combined_data

# cols_to_keep <- c(
#   "CASE_ID", "AGE", "RACE", "GENDER", "MRSTAT", "EDUC", "Arth_Hip_Knee", "Arth_Hand_Wr", "General_Health", 
#   "Mod_Activity", "Stairs", "Phys_Amount_Limit", "Phys_Type_Limit", "Pain_Work",
#   "Emo_Amount_Limit", "Emo_Carefulness",  "Peace", "Energy", "Down", "Social_Interference", 
#   "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet", "Hypertension", 
#   "ANG_CAD",  "CHF", "MI", "Heart_Other", "Stroke", "COPD", "IBD", "Sciatica",
#   "Diabetes", "Cancer", "Smoking_Status", "Survey_Disp", "Region", "Who_Comp"
# )

# rename columns
vr12_copy <- vr12_copy %>% rename(GH1 = General_Health)
vr12_copy <- vr12_copy %>% rename(PF02 = Mod_Activity)
vr12_copy <- vr12_copy %>% rename(PF04 = Stairs)
vr12_copy <- vr12_copy %>% rename(VRP2 = Phys_Amount_Limit)
vr12_copy <- vr12_copy %>% rename(VRP3 = Phys_Type_Limit)
vr12_copy <- vr12_copy %>% rename(VRE2 = Emo_Amount_Limit)
vr12_copy <- vr12_copy %>% rename(VRE3 = Emo_Carefulness)
vr12_copy <- vr12_copy %>% rename(BP2 = Pain_Work)
vr12_copy <- vr12_copy %>% rename(MH3 = Peace)
vr12_copy <- vr12_copy %>% rename(VT2 = Energy)
vr12_copy <- vr12_copy %>% rename(MH4 = Down)
vr12_copy <- vr12_copy %>% rename(SF2 = Social_Interference)

# and rescore when necessary
# General Health
# combined_data$General_Health <- factor(combined_data$General_Health,
#                                        levels = c(5, 4, 3, 2, 1),
#                                        labels = c("Poor", "Fair", "Good", "Very Good", "Excellent"),
#                                        ordered = TRUE)
vr12_copy$GH1 <- as.numeric(vr12_copy$GH1)

# Moderate Activities
# combined_data$Mod_Activity <- factor(combined_data$Mod_Activity, 
#                                      levels = c(1, 2, 3),
#                                      labels = c("Yes, limited a lot", "Yes, limited a little", "No, not limited at all"),
#                                      ordered = TRUE)
vr12_copy$PF02 <- as.numeric(vr12_copy$PF02)

# Climbing several flights of stairs
# combined_data$Stairs <- factor(combined_data$Stairs, 
#                                levels = c(1, 2, 3),
#                                labels = c("Yes, limited a lot", "Yes, limited a little", "No, not limited at all"),
#                                ordered = TRUE)
vr12_copy$PF04 <- as.numeric(vr12_copy$PF04)

# phys amt limit
# combined_data$Phys_Amount_Limit <- factor(combined_data$Phys_Amount_Limit, 
#                                           levels = c(5, 4, 3, 2, 1),
#                                           labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
#                                           ordered = TRUE)
vr12_copy$VRP2 <- as.numeric(vr12_copy$VRP2)

# phys type limit
# combined_data$Phys_Type_Limit <- factor(combined_data$Phys_Type_Limit, 
#                                         levels = c(5, 4, 3, 2, 1),
#                                         labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
#                                         ordered = TRUE)
vr12_copy$VRP3 <- as.numeric(vr12_copy$VRP3)

# pain work
# combined_data$Pain_Work <- factor(combined_data$Pain_Work, 
#                                   levels = c(5, 4, 3, 2, 1),
#                                   labels = c("Extremely", "Quite a bit", "Moderately", "A little bit", "Not at all"),
#                                   ordered = TRUE)
vr12_copy$BP2 <- as.numeric(vr12_copy$BP2)

# emo amount limit
# combined_data$Emo_Amount_Limit <- factor(combined_data$Emo_Amount_Limit, 
#                                          levels = c(5, 4, 3, 2, 1),
#                                          labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
#                                          ordered = TRUE)
vr12_copy$VRE2 <- as.numeric(vr12_copy$VRE2)

# emo carefulness
# combined_data$Emo_Carefulness <- factor(combined_data$Emo_Carefulness, 
#                                         levels = c(5, 4, 3, 2, 1),
#                                         labels = c("Yes, all of the time", "Yes, most of the time", "Yes, some of the time", "Yes, a little of the time", "No, none of the time"),
#                                         ordered = TRUE)
vr12_copy$VRE3 <- as.numeric(vr12_copy$VRE3)

# peace
# combined_data$Peace <- factor(combined_data$Peace, 
#                               levels = c(6, 5, 4, 3, 2, 1),
#                               labels = c("None of the time", "A little of the time", "Some of the time", "A good bit of the time", "Most of the time", "All of the time"),
#                               ordered = TRUE)
vr12_copy$MH3 <- as.numeric(vr12_copy$MH3)

# Energy
# combined_data$Energy <- factor(combined_data$Energy,
#                                levels = c(6, 5, 4, 3, 2, 1),
#                                labels = c("None of the time", "A little of the time", "Some of the time", "A good bit of the time", "Most of the time", "All of the time"),
#                                ordered = TRUE)
vr12_copy$VT2 <- as.numeric(vr12_copy$VT2)

# Down
# combined_data$Down <- factor(combined_data$Down,
#                              levels = c(6, 5, 4, 3, 2, 1),
#                              labels = c("None of the time", "A little of the time", "Some of the time", "A good bit of the time", "Most of the time", "All of the time"),
#                              ordered = TRUE)
vr12_copy$MH4 <- as.numeric(vr12_copy$MH4)

# social interference
# combined_data$Social_Interference <- factor(combined_data$Social_Interference,
#                                             levels = c(5, 4, 3, 2, 1),
#                                             labels = c("None of the time", "A little of the time", "Some of the time", "Most of the time", "All of the time"),
#                                             ordered = TRUE)
vr12_copy$SF2 <- as.numeric(vr12_copy$SF2)

# create Survey column
vr12_copy$Survey <- ifelse(grepl("M", vr12_copy$Survey_Disp), "Mail",
                           ifelse(grepl("T", vr12_copy$Survey_Disp), "Phone", NA))

## now save to csv file
write.csv(vr12_copy, "vr12_copy.csv", row.names = FALSE)

## now run the scoring script
source("C:/Users/m296398/Desktop/medicare_hos/VR12score.R")

vr12score(file.in="C:/Users/m296398/Desktop/medicare_hos/vr12_copy.csv", 
          file.out="C:/Users/m296398/Desktop/medicare_hos/vr12_scores.csv", 
          keyfilepath="C:/Users/m296398/Desktop/medicare_hos/vr12_excel_data")

## and finally, add values to combined data df

vr12data <- read.csv("C:/Users/m296398/Desktop/medicare_hos/vr12_scores.csv")
vr12data <- vr12data %>% select(CASE_ID, cohort, PCS, MCS)

# This performs a left join
combined_data <- merge(combined_data, vr12data[, c("CASE_ID", "PCS", "MCS")], by = "CASE_ID", all.x = TRUE)



