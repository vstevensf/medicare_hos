# 11/12/24

# run prepreocessing script first!
## Multilevel ordinal logistic regression! (AKA mixed-effects OLR)

library(ordinal) # ordinal regression package
library(rcompanion) # pseudo R sq
library(MASS) # plyr method for getting data that allows for the test of proportional odds
library(brant) # test of proportional odds
library(AER)

options(scipen = 999)

str(combined_data)

# # Fit the model
# model <- clmm(ADL_outcome ~ cohort + age + race + education + marital_status + comorbidities + (1 | cohort), 
#               data = your_data)
# 
# # Summary of model
# summary(model)

## Null model
model_null_gh <- clm(as.factor(General_Health) ~ 1, # no predictors
                  data = combined_data,
                  link = "logit")

model_demos_gh <- clm(as.factor(General_Health) ~ as.factor(RACE) + as.factor(GENDER) + as.factor(MRSTAT) + as.factor(EDUC) + as.factor(Region),
                      data = combined_data,
                      link = "logit")
anova(model_null_gh, model_demos_gh)

nagelkerke(fit = model_demos_gh,
           null = model_null_gh)

summary(model_demos_gh)

confint(model_demos_gh)

exp(coef(model_demos_gh))

exp(confint(model_demos_gh))

# test parallel lines/proportional odds assumption
# we want brant test to be nonsignificant
modelt_demos_gh <- polr(General_Health ~ RACE + GENDER + MRSTAT + EDUC + Region,
                      data = combined_data,
                      Hess = TRUE)

brant(modelt_demos_gh)

table(combined_data$General_Health, combined_data$RACE)
table(combined_data$General_Health, combined_data$GENDER)
table(combined_data$General_Health, combined_data$MRSTAT)
table(combined_data$General_Health, combined_data$EDUC)
table(combined_data$General_Health, combined_data$Region)

nominal_test(model_demos_gh)

summary(modelt_demos_gh)
coeftest(modelt_demos_gh)

# likelihood ratio test for choosing what variables to include

# cumulative odds ratio vs predicted probabilities


############
# visualize data distribution of dependent variables

barplot(table(combined_data$General_Health)) # normal



