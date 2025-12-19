# rk.codebook: Data Documentation for RKWard

![Version](https://img.shields.io/badge/Version-0.0.1-blue.svg)
![License](https://img.shields.io/badge/License-GPL--3-green.svg)
![R Version](https://img.shields.io/badge/R-%3E%3D%203.0.0-lightgrey.svg)

**rk.codebook** generates professional HTML data dictionaries directly within RKWard. It bridges the gap between RKWard's internal variable labels and standard R reporting tools (powered by **[`sjPlot`](https://strengejacke.github.io/sjPlot/)**), allowing you to create instant "Codebooks" for your datasets.

## Features

*   **Generate Codebook:**
    *   Produces a clean HTML table listing every variable in your dataframe.
    *   **Metadata:** Shows Variable Name, Label, Type, and Missing Values.
    *   **Distributions:** Shows frequency tables and value labels for categorical data.
*   **RKWard Integration:**
    *   **Auto-Sync:** Automatically pulls variable labels defined in the RKWard Data Editor (or via `rk.set.label`) and applies them to the report.

## Requirements

1.  **RKWard**: 0.7.5 or higher.
2.  The R package **`sjPlot`**.
    ```R
    install.packages("sjPlot")
    ```
3.  The R package **`devtools`** (for installation from source).

## Installation

1.  Open R in RKWard.
2.  Run the following commands in the R console:

```R
local({
## Preparar
require(devtools)
## Computar
  install_github(
    repo="AlfCano/rk.codebook"
  )
## Imprimir el resultado
rk.header ("Resultados de Instalar desde git")
})
```
3.  Restart RKWard to ensure the new menu items appear correctly.

## Usage & Examples

To generate a useful codebook, your data needs metadata (Labels). You can add these via the RKWard Data Editor GUI, or programmatically using `rk.set.label`.

### Step 1: Prepare Data with Labels
Run this code in the RKWard console to create a dataset and assign RKWard-native labels:

```R
# 1. Create a raw dataset
my_survey <- data.frame(
  id = 1:10,
  age = c(25, 30, 22, NA, 45, 28, 33, 40, 29, 31),
  group = factor(c(1, 1, 2, 2, 1, 2, 1, 2, 1, 1), labels = c("Control", "Treatment")),
  satisfaction = c(4, 5, 3, 4, NA, 5, 4, 2, 3, 5)
)

# 2. Apply Variable Labels using RKWard's native function
# This is what the plugin "Sync" feature looks for.
rk.set.label(my_survey$id, "Participant Unique Identifier")
rk.set.label(my_survey$age, "Age of Respondent (Years)")
rk.set.label(my_survey$group, "Experimental Condition")
rk.set.label(my_survey$satisfaction, "Self-reported Satisfaction (1-5)")

# 3. (Optional) Check that labels are applied
# rk.get.label(my_survey$age) 
```

### Step 2: Generate the Report
1.  Navigate to **Analysis > Data Documentation (codebook) > Generate Data Codebook**.
2.  **Dataframe:** Select `my_survey`.
3.  **Metadata Integration:** Ensure **"Sync RKWard Variable Labels to Report"** is checked.
4.  **Table Content:**
    *   Check **Show Frequencies** (Useful for the `group` variable).
    *   Check **Show Missing Values (NA)**.
5.  Click **Submit**.

### Result
The Output Window will display a formatted HTML table where:
*   The **Label** column displays the text set via `rk.set.label`.
*   The **Values** column shows the factor levels ("Control", "Treatment").
*   The **missings** column highlights the `NA` in Age and Satisfaction.

## Author

**Alfonso Cano Robles**
*   Email: alfonso.cano@correo.buap.mx

Assisted by Gemini, a large language model from Google.
