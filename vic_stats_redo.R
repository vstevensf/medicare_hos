## Imports
# library(readxl)
# library(tidyr)
# library(dplyr)
# library(writexl)
# library(e1071)
# library(MatchIt)


################################
#matched_data <- matchit(treatment ~ AGE + GENDER + Diabetes + Hypertension + CHF + COPD + Smoking_Status, 
#                            data = combined_data, 
#                            method = "cem", k2k = TRUE, cutpoints = 0)

#Now, perform propensity score matching
matched_data <- matchit(treatment ~ AGE + GENDER + Diabetes + Hypertension + CHF + COPD + Smoking_Status + Arthritis, 
                        data = combined_data, 
                        method = "nearest",
                        exact = ~ GENDER + AGE + Arthritis)

summary(matched_data)$nn

m.data <- match.data(matched_data)

# Extract the matched datasets
matched_data_1998 <- subset(m.data, treatment == 0)
matched_data_2023 <- subset(m.data, treatment == 1)



###STATS CODE###
##race (#1 = white, #2 = black, #3 = other)
table(matched_data_1998$RACE)
table(matched_data_2023$RACE)

#change over time p-value
chisq.test(m.data$treatment, m.data$RACE)



##Gender (#1 = male, #2 = female)
table(matched_data_1998$GENDER)
table(matched_data_2023$GENDER)

#change over time p-value
chisq.test(m.data$treatment, m.data$GENDER)


##MRSTAT
table(matched_data_1998$MRSTAT)
table(matched_data_2023$MRSTAT)

#change over time p-value
chisq.test(m.data$treatment, m.data$MRSTAT)

##AGE
table(matched_data_1998$AGE)
table(matched_data_2023$AGE)

#change over time p-value
chisq.test(m.data$treatment, m.data$AGE)


##EDUC
table(matched_data_1998$EDUC)
table(matched_data_2023$EDUC)

#change over time p-value
chisq.test(m.data$treatment, m.data$EDUC)

##General_Health
table(matched_data_1998$General_Health)
table(matched_data_2023$General_Health)

#change over time p-value
chisq.test(m.data$treatment, m.data$General_Health)

##Mod_Activity
table(matched_data_1998$Mod_Activity)
table(matched_data_2023$Mod_Activity)

#change over time p-value
chisq.test(m.data$treatment, m.data$Mod_Activity)

##Stairs
table(matched_data_1998$Stairs)
table(matched_data_2023$Stairs)

#change over time p-value
chisq.test(m.data$treatment, m.data$Stairs)

##Phys_Amount_Limit
table(matched_data_1998$Phys_Amount_Limit)
table(matched_data_2023$Phys_Amount_Limit)

#change over time p-value
chisq.test(m.data$treatment, m.data$Phys_Amount_Limit)

##Phys_Type_Limit
table(matched_data_1998$Phys_Type_Limit)
table(matched_data_2023$Phys_Type_Limit)

#change over time p-value
chisq.test(m.data$treatment, m.data$Phys_Type_Limit)

##Emo_Amount_Limit
table(matched_data_1998$Emo_Amount_Limit)
table(matched_data_2023$Emo_Amount_Limit)

#change over time p-value
chisq.test(m.data$treatment, m.data$Emo_Amount_Limit)

##Emo_Carefulness
table(matched_data_1998$Emo_Carefulness)
table(matched_data_2023$Emo_Carefulness)

#change over time p-value
chisq.test(m.data$treatment, m.data$Emo_Carefulness)

##Pain_Work
table(matched_data_1998$Pain_Work)
table(matched_data_2023$Pain_Work)

#change over time p-value
chisq.test(m.data$treatment, m.data$Pain_Work)

##Peace
table(matched_data_1998$Peace)
table(matched_data_2023$Peace)

#change over time p-value
chisq.test(m.data$treatment, m.data$Peace)

##Energy
table(matched_data_1998$Energy)
table(matched_data_2023$Energy)

#change over time p-value
chisq.test(m.data$treatment, m.data$Energy)

##Down
table(matched_data_1998$Down)
table(matched_data_2023$Down)

#change over time p-value
chisq.test(m.data$treatment, m.data$Down)

##Social_Interference
table(matched_data_1998$Social_Interference)
table(matched_data_2023$Social_Interference)

#change over time p-value
chisq.test(m.data$treatment, m.data$Social_Interference)

##Bathing
table(matched_data_1998$Bathing)
table(matched_data_2023$Bathing)

#change over time p-value
chisq.test(m.data$treatment, m.data$Bathing)

##Dressing
table(matched_data_1998$Dressing)
table(matched_data_2023$Dressing)

#change over time p-value
chisq.test(m.data$treatment, m.data$Dressing)

##Eating
table(matched_data_1998$Eating)
table(matched_data_2023$Eating)

#change over time p-value
chisq.test(m.data$treatment, m.data$Eating)

##Chairs
table(matched_data_1998$Chairs)
table(matched_data_2023$Chairs)

#change over time p-value
chisq.test(m.data$treatment, m.data$Chairs)

##Walking
table(matched_data_1998$Walking)
table(matched_data_2023$Walking)

#change over time p-value
chisq.test(m.data$treatment, m.data$Walking)

##Toilet
table(matched_data_1998$Toilet)
table(matched_data_2023$Toilet)

#change over time p-value
chisq.test(m.data$treatment, m.data$Toilet)
