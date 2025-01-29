# Medicare HOS -- Cohort Analysis, 2006 - 2021

## Table of Contents
- [Project Description](#project-description)
- [Features](#features)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [License](#license)

## Project Description

This is a repo of R files designed for preprocessing of Medicare HOS public use files, for eventual statistical analysis of patient-reported outcome measures (PROMs) over time using survey data from [Medicare Health Outcomes Survey database](https://hosonline.org/en/). It includes a set of functions for data cleaning, [VR12 scoring](https://www.bu.edu/sph/research/centers-and-groups/vr-36-vr-12-and-vr-6d/), and PFADL scoring (TODO). 

📁 medicare_hos/

│── 📁 ascii_to_csv/                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# ASCII to CSV conversion of PUF files

│── 📁 data/raw/                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# CSV versions of PUF files

│── 📁 vr12_excel_data/                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Auxiliary files for VR12 scoring

│── 📄 README.md                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Project overview, installation, usage, and citation

│── 📄 VR12score.R                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# VR12 scoring script from BU

│── 📄 vic_preprocess_VR12.R             &nbsp;&nbsp;# Invokes the above VR12 scoring function

│── 📄 vic_preprocessing.R               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Data cleaning script

│── 📄 vics notes.txt                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Personal notes (ignore)


## Features

- Feature 1: Preprocess datasets from PUFs (public use files)
    - Conversion of ASCII PUF files to csv using guidelines detailed in the [Medicare HOS user manuals](https://hosonline.org/en/data-dissemination/data-users-guides/). Converted PUF csv files can be found [here](https://drive.google.com/drive/folders/1cQbCXR5yI503vPbaOg4Wgww_7kRdvqcj?usp=sharing).
- Feature 2: Data cleaning -- include only HKA patients, completed surveys, self-completed responses, etc.
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
install.packages(c("openxlsx", "dplyr"))
```

## Usage

R version 4.4.2 (2024-10-31 ucrt)

### PUF file conversions

📁 medicare_hos/

│── 📁 ascii_to_csv/  

│   │── 📁 conversion scripts/ 

│   │── 📁 raw_ascii_pufs/ 

The scripts in `conversion_scripts/`:
1. Read in the corresponding cohort PUF txt (ascii) files in `raw_ascii_pufs/`, which contain Medicare patient responses to the Medicare HOS (cohorts 2006 - 2019)
2. Extract relevant columns containing demographic/socioeconomic information, chronic conditions/comorbidities, PROMs, ADLs and HOS study design variables
3. Output the data in CSV form

The scripts are specific to certain cohorts, as detailed in the name (2006 - 2007, 2008 - 2012, 2013 - 2014, and 2015 - 2019). The 2020 - 2021 cohorts were available as CSVs.

CSV files are available in `medicare_hos/data/raw`.

### Preprocessing of CSV files

📁 medicare_hos/

│── 📁 data/raw/  

│── 📄 vic_preprocessing.R 

The script `vic_preprocessing.R`:
1. Reads in the CSV PUF files from `data/raw`
2. Checks for empty values and removes those records -- to avoid imputation later on
3. Extracts HKA (hip and knee arthritis) patients
4. Removes certain categories (disability/<65 years old, unknown smoking status, etc.)
5. Factors the ordinal categories, and combines all cohorts into one dataframe
6. Saves the cleaned dataframe to an excel workbook (combined_data.xlsx), which can be found [here](https://docs.google.com/spreadsheets/d/1h7rcIPigpyFxcmXMMJnIhwXuUIAod5By/edit?usp=sharing&ouid=105898128966506207562&rtpof=true&sd=true).

There are two sheets in this workbook, one with the numerical values of survey responses, and an explicit categorical sheet (listing what the numerical responses mean). Documentation on the different columns can be found [here](https://docs.google.com/document/d/1XILRR62jhN0HdO-cWpMc6kSAKw44lF-VoqyIAtt8CQw/edit?usp=sharing).

### VR-12 Scoring

📁 medicare_hos/

│── 📁 vr12_excel_data/  

│── 📄 VR12score.R 

│── 📄 vic_preprocess_VR12.R 

Using the [VR-12 scoring algorithm](https://www.bu.edu/sph/research/centers-and-groups/vr-36-vr-12-and-vr-6d/) from BU, these scripts determine quantitative scores to estimate the quality of life of the survey respondents. 

The script `vic_preprocess_VR12.R`:
1. Relabels appropriate columns for later calculations
2. Invokes the scoring function in `VR12score.R` and the auxiliary files in `vr12_excel_data/` to calculate the numerical VR12 scores for each individual from all cohorts
3. Saves the VR12 scores to an excel file. This output can be found [here](https://drive.google.com/file/d/1MYLbiqqzRuoKRlvkpwzVnj_b0euYLUzj/view?usp=sharing).

There are two scores, the PCS = physical component, and the MCS = mental component. They are the last two columns in the above output.

### TODO PFADL scoring (sum of ADL survey responses)

## License

Copyright (c) 2024 Victoria Stevens

All rights reserved. This software and associated documentation files (the "Software") may only be used by authorized collaborators of Victoria Stevens. Unauthorized copying, distribution, or modification of this software, via any medium, is strictly prohibited. 

Permission is granted only to members of the collaboration for research purposes. For inquiries, please contact at stevens.victoria@mayo.edu.
