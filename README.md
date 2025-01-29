# Medicare HOS -- Cohort Analysis, 2006 - 2021

## Table of Contents
- [Project Description](#project-description)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Project Description

This is a repo of R files designed for preprocessing of Medicare HOS public use files, for eventual statistical analysis of patient-reported outcome measures (PROMs) over time from [Medicare Health Outcomes Survey database](https://hosonline.org/en/). It includes a set of functions for data cleaning and [VR12 scoring](https://www.bu.edu/sph/research/centers-and-groups/vr-36-vr-12-and-vr-6d/). 

## Features

- Feature 1: Preprocess datasets from PUFs (public use files)
    - Conversion of ASCII PUF files to csv using [Medicare HOS user manuals](https://hosonline.org/en/data-dissemination/data-users-guides/). Converted PUF csv files used in this analysis can be found [here](https://drive.google.com/drive/folders/1cQbCXR5yI503vPbaOg4Wgww_7kRdvqcj?usp=sharing).
- Feature 2: Data cleaning -- include only HKA patients, completed surveys, and self-completed responses
- Feature 3: VR12 scoring -- using algorithm from BU to calculate PCS (physical component) and MCS (mental component) scores.
- Feature 4: TODO -- PFADL scoring for ADL survey responses

## Installation

### Option 1: Install from GitHub

You can use the `devtools` package to install the project directly from GitHub.

1. Install the `devtools` package if you don’t have it already:
    ```r
    install.packages("devtools")
    ```

2. Install the project:
    ```r
    devtools::install_github("vstevensf/medicare_hos")
    ```

### Option 2: Clone the Repository

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/vstevensf/medicare_hos.git
    ```

2. Open the R project in RStudio or another IDE, and install required dependencies (see below).

   
## Dependencies

    ```r
    install.packages(c("openxlsx", "dplyr"))  # Add relevant package names
    ```

## Usage

R version 4.4.2 (2024-10-31 ucrt)

### PUF file conversions TODO
Files: `vic_preprocessing.R`, `C1_1998_PUF.csv`, `C23A_2020_PUF.csv`

This script:
1. reads in the cohort PUF csv files, which contain Medicare patient responses to the Medicare HOS (years: 1998 and 2020) 
2. extracts relevant columns containing demographic information and PROMs
3. standardizes scoring of certain categorical variables
4. checks for empty values and removes those records

### Baseline Imbalance Assessment + 

1. initial imbalance assessment
2. ddd
3. Standardized mean difference analysis to assess covariate balance (> .1 --> index of residual imbalance)
4. TODO; graphical diagnostics to assess covariate balance --> a) mirrored histogram for distribution of propensity score in the original and matched groups, b) Love plot of the SMDs for quick overview of balance

basically, the propensity score is a "balancing score" such that baseline covariate distribution is the same across treatment arms

### Propensity Score Matching
propensity score estimated using logistic regression model in which treatment states is regressed on the measured baseline covariates

propensity score matching by logistic regression using linear terms, no interaction or stratification

## License

Copyright (c) 2024 Victoria Stevens

All rights reserved. This software and associated documentation files (the "Software") may only be used by authorized collaborators of Victoria Stevens. Unauthorized copying, distribution, or modification of this software, via any medium, is strictly prohibited. 

Permission is granted only to members of the collaboration for research purposes. For inquiries, please contact at stevens.victoria@mayo.edu.
