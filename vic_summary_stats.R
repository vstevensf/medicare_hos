install.packages("tableone")
library(tableone) # summary stats and balance
install.packages("openxlsx")
library(openxlsx)
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)

# convert all numeric variables with fewer than 5 unique values 
# (suggesting they are categorical) into factors automatically
combined_data <- combined_data %>%
  mutate_if(~ is.numeric(.) && n_distinct(.) < 5, as.factor)

# Convert numeric gender variable to a factor with labels Male and Female
combined_data$GENDER <- factor(combined_data$GENDER, 
                             levels = c(1, 2),  # Assuming 1 = Male, 2 = Female
                             labels = c("Male", "Female"))


# summary stats for demographics
demos_to_check <- c(
  "AGE", "RACE", "GENDER", "MRSTAT", "EDUC" 
)
demos_table <- CreateTableOne(vars = demos_to_check,
                              strata = "cohort", 
                              data = combined_data,
                              factorVars = demos_to_check,
                              includeNA = TRUE)
print(demos_table, smd = TRUE)
df_demos_table <- as.data.frame(print(demos_table, smd=TRUE))

# Remove any leading or trailing spaces in the columns before extraction
df_demos_table[["0"]] <- trimws(df_demos_table[["0"]])
df_demos_table[["1"]] <- trimws(df_demos_table[["1"]])

# Extract the counts (numbers before the parentheses)
# df_demos_table$Cohort1_counts <- as.numeric(sub(" \\(.*\\)", "", df_demos_table[["0"]]))
# df_demos_table$Cohort2_counts <- as.numeric(sub(" \\(.*\\)", "", df_demos_table[["1"]]))

# Extract percentages (numbers inside parentheses with or without spaces)
df_demos_table$Cohort1_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_demos_table[["0"]]))
df_demos_table$Cohort2_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_demos_table[["1"]]))


df_demos_table$percent_diff <- df_demos_table$Cohort2_percent - df_demos_table$Cohort1_percent

# summary stats for comorbidities
comorbidities_to_check <- c(
  "Diabetes",  "ANG_CAD", "Hypertension", "CHF", "MI", "IBD", "COPD", 
  "Smoking_Status", "Stroke"
)
comorb_table <- CreateTableOne(vars = comorbidities_to_check,
                               strata = "cohort", 
                               data = combined_data,
                               test = TRUE)
df_comorb_table <- as.data.frame(print(comorb_table, smd=TRUE))

# summary stats for PROMs

vr12_to_check <- c(
  "General_Health", "Mod_Activity", "Stairs", "Phys_Amount_Limit", "Phys_Type_Limit",
  "Emo_Amount_Limit", "Emo_Carefulness", "Pain_Work", "Peace", "Energy", "Down",
  "Social_Interference"
)
vr12_table <- CreateTableOne(vars = vr12_to_check,
                             strata = "cohort", 
                             data = combined_data,
                             test = TRUE)
df_vr12_table <- as.data.frame(print(vr12_table, smd=TRUE))

adls_to_check <- c(
  "Bathing", "Dressing", "Eating", "Chairs", "Walking", "Toilet"
)
adl_table <- CreateTableOne(vars = adls_to_check,
                             strata = "cohort", 
                             data = combined_data,
                             test = TRUE)
df_adl_table <- as.data.frame(print(adl_table, smd=TRUE))

# also stratifying by comorb
# Create a new stratification variable combining cohort x diabeted
combined_data$coh_diab <- interaction(combined_data$cohort, combined_data$Diabetes)

# Create a TableOne object stratified by the new combined strata (cohort and diabetes status)
vr12_coh_diab_table <- CreateTableOne(vars = vr12_to_check,
                         strata = "coh_diab",  # Stratify by the combined variable (cohort and diabetes)
                         data = combined_data, test = TRUE)

# Print the summary table
df_vr12_coh_diab_table <- as.data.frame(print(vr12_coh_diab_table, smd=TRUE))

adl_coh_diab_table <- CreateTableOne(vars = adls_to_check,
                                      strata = "coh_diab",  # Stratify by the combined variable (cohort and diabetes)
                                      data = combined_data, test = TRUE)
df_adl_coh_diab_table <- as.data.frame(print(adl_coh_diab_table, smd=TRUE))

# coh x ang/cad
combined_data$coh_angcad <- interaction(combined_data$cohort, combined_data$ANG_CAD)

vr12_coh_angcad_table <- CreateTableOne(vars = vr12_to_check,
                                      strata = "coh_angcad",  
                                      data = combined_data, test = TRUE)
df_vr12_coh_angcad_table <- as.data.frame(print(vr12_coh_angcad_table, smd=TRUE))

adl_coh_angcad_table <- CreateTableOne(vars = adls_to_check,
                                     strata = "coh_diab",  
                                     data = combined_data, test = TRUE)
df_adl_coh_angcad_table <- as.data.frame(print(adl_coh_angcad_table, smd=TRUE))

### figures
# Proportional bar plot to compare age distribution by cohort
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(AGE, levels = c(1, 2, 3), labels = c("Less than 65", "65 to 74", "Greater than 74")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Age Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Age") +
  theme_minimal()

# race
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(RACE, levels = c(1, 2, 3), labels = c("White", "Black/AA", "Other")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Race Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Race") +
  theme_minimal()


# Proportional bar plot with gender proportions within each cohort
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(GENDER, levels = c(1, 2), labels = c("Male", "Female")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Gender Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Gender") +
  theme_minimal()

# married status
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(MRSTAT, levels = c(1, 2), labels = c("Married", "Non-Married")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Marital Status Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Marital Status") +
  theme_minimal()

# education
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(EDUC, levels = c(1, 2, 3), labels = c("< GED", "GED", "> GED")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Education Level Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Education Level") +
  theme_minimal()

# diabetes
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(Diabetes, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Diabetes Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Diabetes") +
  theme_minimal()

# ang cad
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(ANG_CAD, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Angina/CAD Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Angina/CAD") +
  theme_minimal()

# htn
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(Hypertension, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Hypertension Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "HTN") +
  theme_minimal()

# chf
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(CHF, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Congestive Heart Failure Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "CHF") +
  theme_minimal()

# mi
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(MI, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Myocardial Infarction Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "MI") +
  theme_minimal()

# ibd
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(IBD, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Inflamm Bowel Disease Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "IBD") +
  theme_minimal()

# copd
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(COPD, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional COPD Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "COPD") +
  theme_minimal()

# smoking status
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(Smoking_Status, levels = c(1, 2, 3, 4), labels = c("Every day", "Some days", "Not at all", "Don't Know")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Current Smoker Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Current Smoker") +
  theme_minimal()

# stroke
ggplot(combined_data, aes(x = factor(cohort, levels = c(0, 1), labels = c("1998", "2020")), fill = factor(Stroke, levels = c(1, 2), labels = c("Yes", "No")))) +
  geom_bar(position = "fill", width = 0.7) +  # "fill" ensures proportions within each cohort
  labs(title = "Proportional Stroke Distribution", 
       x = "Cohort", 
       y = "Proportion", 
       fill = "Stroke") +
  theme_minimal()


