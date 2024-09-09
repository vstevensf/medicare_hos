# Medicare HOS -- Propensity Matched Cohort Analysis, 1998 vs 2020

## License

Copyright (c) 2024 Victoria Stevens

All rights reserved. This software and associated documentation files (the "Software") may only be used by authorized collaborators of Victoria Stevens. Unauthorized copying, distribution, or modification of this software, via any medium, is strictly prohibited. 

Permission is granted only to members of the collaboration for research purposes. For inquiries, please contact at stevens.victoria@mayo.edu.


## Table of Contents
- [Project Description](#project-description)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Project Description

This is a repo of R files designed for statistical analysis of patient-reported outcome measures over time from [Medicare Health Outcomes Survey database](https://hosonline.org/en/). It includes a set of functions for data cleaning, propensity score matching and covariate adjustment, and balance diagnostics. 

## Features

- Feature 1: Preprocess datasets from PUFs (public use files)
- Feature 2: Visualize data with ggplot2-based plots
- Feature 3: Run regression models with a single function

- Preprocessing not included in this repo: conversion of ASCII PUF files to csv (converted files included here) using Medicare HOS user manuals

## Installation

Provide instructions on how to install and set up your R project. Depending on the nature of your project (an R package, script, or Shiny app), the installation steps may vary.

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
    git clone https://github.com/yourusername/yourproject.git
    ```

2. Open the R project in RStudio or another IDE, and install required dependencies. You can install all packages listed in `DESCRIPTION` or `requirements.R`:

    ```r
    install.packages(c("ggplot2", "dplyr", "tidyverse"))  # Add relevant package names
    ```

## Usage

Provide instructions for using your project. Include sample code and examples if possible.

### Example 1: Data Cleaning
```r
# Load the package
library(yourproject)

# Clean dataset
cleaned_data <- clean_data(raw_data)
