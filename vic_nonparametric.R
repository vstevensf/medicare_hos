# 11/12/24

# Chi-square: Tests for independence between two categorical variables, 
# showing whether distributions are different but not if one group has 
# systematically higher or lower values.
# 
# Mann-Whitney U and Kruskal-Wallis: Compare central tendencies across groups 
# (e.g., medians), making them better suited for ordinal scales 
# (like ADL scores) where the outcome has a natural order. --> MANN WHITNEY for 2 groups
# (mann whitney = wilcoxon rank sum)

# general health
wilcox.test(General_Health ~ cohort, data = combined_data)
