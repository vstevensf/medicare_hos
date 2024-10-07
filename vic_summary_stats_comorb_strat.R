# 10/7/24
# continuing descriptive/exploratory statistics
# combined stratification: PROMs x (important comorbidities + cohort)

all_proms <- c(pcs_vr12_to_check, mcs_vr12_to_check, adls_to_check)

################
# Demographics #
################
#### High priority by p-val + SMD = race, gender, mrstat, educ, region

### race x cohort combined variable
combined_data$coh_race <- interaction(combined_data$cohort, combined_data$RACE, sep = "_")
table(combined_data$coh_race) # prelim visualization of counts
# summ stats
coh_race_table <- CreateTableOne(vars = all_proms,
                                          strata = "coh_race", # Stratify by the combined variable (cohort and race)
                                          data = combined_data)
# save output
df_coh_race_table <- as.data.frame(print(coh_race_table, 
                                      showAllLevels = TRUE, 
                                      noSpaces = TRUE,
                                      smd = TRUE))
# # Extract percentages (numbers inside parentheses with or without spaces)
## gonna save this for ordinal logistic regression ill be doing later
# df_pcs_vr12_coh_race_table$C1_White_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_coh_race_table$`Cohort 1 (1998)_White`))
# df_pcs_vr12_coh_race_table$C23_White_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_coh_race_table$`Cohort 23 (2020)_White`))
# df_pcs_vr12_coh_race_table$C1_Black_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_coh_race_table$`Cohort 1 (1998)_Black or African American`))
# df_pcs_vr12_coh_race_table$C23_Black_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_coh_race_table$`Cohort 23 (2020)_Black or African American`))
# df_pcs_vr12_coh_race_table$C1_Other_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_coh_race_table$`Cohort 1 (1998)_Other`))
# df_pcs_vr12_coh_race_table$C23_Other_percent <- as.numeric(sub(".*\\(\\s*([0-9]*\\.?[0-9]+)\\s*\\)", "\\1", df_pcs_vr12_coh_race_table$`Cohort 23 (2020)_Other`))
# # calculate percent diff
# df_pcs_vr12_coh_race_table$percent_diff_White <- df_pcs_vr12_coh_race_table$C23_White_percent - df_pcs_vr12_coh_race_table$C1_White_percent
# df_pcs_vr12_coh_race_table$percent_diff_Black <- df_pcs_vr12_coh_race_table$C23_Black_percent - df_pcs_vr12_coh_race_table$C1_Black_percent
# df_pcs_vr12_coh_race_table$percent_diff_Other <- df_pcs_vr12_coh_race_table$C23_Other_percent - df_pcs_vr12_coh_race_table$C1_Other_percent

# and write to excel workbook
wb <- createWorkbook() # Create a new workbook
addWorksheet(wb, "proms vs. (race + cohort)")
writeData(wb, sheet = "proms vs. (race + cohort)", df_coh_race_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE) # save sheet


### gender x cohort combined variable
combined_data$coh_gender <- interaction(combined_data$cohort, combined_data$GENDER, sep = "_")
table(combined_data$coh_gender)
coh_gender_table <- CreateTableOne(vars = all_proms,
                                 strata = "coh_gender",
                                 data = combined_data)
df_coh_gender_table <- as.data.frame(print(coh_gender_table, 
                                         showAllLevels = TRUE, 
                                         noSpaces = TRUE,
                                         smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (gender + cohort)")
writeData(wb, sheet = "proms vs. (gender + cohort)", df_coh_gender_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE) # save sheet


### mrstat x cohort combined variable
combined_data$coh_mrstat <- interaction(combined_data$cohort, combined_data$MRSTAT, sep = "_")
table(combined_data$coh_mrstat)
coh_mrstat_table <- CreateTableOne(vars = all_proms,
                                   strata = "coh_mrstat",
                                   data = combined_data)
df_coh_mrstat_table <- as.data.frame(print(coh_mrstat_table, 
                                           showAllLevels = TRUE, 
                                           noSpaces = TRUE,
                                           smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (mrstat + cohort)")
writeData(wb, sheet = "proms vs. (mrstat + cohort)", df_coh_mrstat_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


### educ x cohort combined variable
combined_data$coh_educ <- interaction(combined_data$cohort, combined_data$EDUC, sep = "_")
table(combined_data$coh_educ)
coh_educ_table <- CreateTableOne(vars = all_proms,
                                   strata = "coh_educ",
                                   data = combined_data)
df_coh_educ_table <- as.data.frame(print(coh_educ_table, 
                                           showAllLevels = TRUE, 
                                           noSpaces = TRUE,
                                           smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (educ + cohort)")
writeData(wb, sheet = "proms vs. (educ + cohort)", df_coh_educ_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)

### region x cohort combined variable
combined_data$coh_region <- interaction(combined_data$cohort, combined_data$Region, sep = "_")
table(combined_data$coh_region)
coh_region_table <- CreateTableOne(vars = all_proms,
                                 strata = "coh_region",
                                 data = combined_data)
df_coh_region_table <- as.data.frame(print(coh_region_table, 
                                         showAllLevels = TRUE, 
                                         noSpaces = TRUE,
                                         smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (region + cohort)")
writeData(wb, sheet = "proms vs. (region + cohort)", df_coh_region_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)



#################
# Comorbidities #
#################
#### High priority by p-val + SMD = HTN, DBM, and smoking status
#### Moderate priority = angina/CAD, MI, COPD

### HTN x cohort combined variable
combined_data$coh_htn <- interaction(combined_data$cohort, combined_data$Hypertension, sep = "_")
table(combined_data$coh_htn)
coh_htn_table <- CreateTableOne(vars = all_proms,
                                   strata = "coh_htn",
                                   data = combined_data)
df_coh_htn_table <- as.data.frame(print(coh_htn_table, 
                                           showAllLevels = TRUE, 
                                           noSpaces = TRUE,
                                           smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (htn + cohort)")
writeData(wb, sheet = "proms vs. (htn + cohort)", df_coh_htn_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


### DBM x cohort combined variable
combined_data$coh_dbm <- interaction(combined_data$cohort, combined_data$Diabetes, sep = "_")
table(combined_data$coh_dbm)
coh_dbm_table <- CreateTableOne(vars = all_proms,
                                strata = "coh_dbm",
                                data = combined_data)
df_coh_dbm_table <- as.data.frame(print(coh_dbm_table, 
                                        showAllLevels = TRUE, 
                                        noSpaces = TRUE,
                                        smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (dbm + cohort)")
writeData(wb, sheet = "proms vs. (dbm + cohort)", df_coh_dbm_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


### smokers x cohort combined variable
combined_data$coh_smoke <- interaction(combined_data$cohort, combined_data$Smoking_Status, sep = "_")
table(combined_data$coh_smoke)
coh_smoke_table <- CreateTableOne(vars = all_proms,
                                strata = "coh_smoke",
                                data = combined_data)
df_coh_smoke_table <- as.data.frame(print(coh_smoke_table, 
                                        showAllLevels = TRUE, 
                                        noSpaces = TRUE,
                                        smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (smoker + cohort)")
writeData(wb, sheet = "proms vs. (smoker + cohort)", df_coh_smoke_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


### angcad x cohort combined variable
combined_data$coh_ang_cad <- interaction(combined_data$cohort, combined_data$ANG_CAD, sep = "_")
table(combined_data$coh_ang_cad)
coh_ang_cad_table <- CreateTableOne(vars = all_proms,
                                  strata = "coh_ang_cad",
                                  data = combined_data)
df_coh_ang_cad_table <- as.data.frame(print(coh_ang_cad_table, 
                                          showAllLevels = TRUE, 
                                          noSpaces = TRUE,
                                          smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (angcad + cohort)")
writeData(wb, sheet = "proms vs. (angcad + cohort)", df_coh_ang_cad_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


### mi x cohort combined variable
combined_data$coh_mi <- interaction(combined_data$cohort, combined_data$MI, sep = "_")
table(combined_data$coh_mi)
coh_mi_table <- CreateTableOne(vars = all_proms,
                                    strata = "coh_mi",
                                    data = combined_data)
df_coh_mi_table <- as.data.frame(print(coh_mi_table, 
                                            showAllLevels = TRUE, 
                                            noSpaces = TRUE,
                                            smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (mi + cohort)")
writeData(wb, sheet = "proms vs. (mi + cohort)", df_coh_mi_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


### copd x cohort combined variable
combined_data$coh_copd <- interaction(combined_data$cohort, combined_data$COPD, sep = "_")
table(combined_data$coh_copd)
coh_copd_table <- CreateTableOne(vars = all_proms,
                               strata = "coh_copd",
                               data = combined_data)
df_coh_copd_table <- as.data.frame(print(coh_copd_table, 
                                       showAllLevels = TRUE, 
                                       noSpaces = TRUE,
                                       smd = TRUE))
wb <- loadWorkbook("summary_stats_xtra_strat.xlsx")
addWorksheet(wb, "proms vs. (copd + cohort)")
writeData(wb, sheet = "proms vs. (copd + cohort)", df_coh_copd_table, rowNames = TRUE) 
saveWorkbook(wb, file = "summary_stats_xtra_strat.xlsx", overwrite = TRUE)


################
rm(wb) # remove workbook object
gc() # run garbage collection (frees memory)



