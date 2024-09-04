# Panel-Regression-in-R

## Overview

This repository contains the R code and R Markdown files used in Medium  article titled "Panel Data Regression in R" 

## Contents

- `panel_markdown.Rmd`: The R Markdown file containing the complete code and documentation for the analysis.
- `panel_dbp.R`: R Script file  containing all the codes used in the article.
- `markdown.pdf`: PDF file of the R-markdown outcome
- `dbp_data.xlsx`: Data used in showing the analsyis



### Prerequisites

Ensure you have the following R packages installed:

- `plm`
- `tidyverse`
- `ggplot2`
- `lattice`

You can install these packages using the following commands:

```r
install.packages("plm")
install.packages("tidyverse")
install.packages("lattice")
```


### Results

The analysis focuses on the following:

- Estimating fixed and random effects models to evaluate treatment effectiveness.
- Comparing model performance using the Hausman test.

### Further Exploration

Readers are encouraged to explore generalized linear models (GLMs) for panel data, such as logistic regression, which may be particularly useful for binary or categorical outcomes.

