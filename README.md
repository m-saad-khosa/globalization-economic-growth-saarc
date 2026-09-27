# Globalization and Economic Growth: SAARC Countries (1990–2020)

## Overview

This project examines the relationship between globalization and economic growth across four South Asian countries — Pakistan, India, Bangladesh, and Nepal — using 30 years of data (1990–2020).

The analysis combines country-level time series methods (ADF unit root tests and ARDL models) with panel data techniques (Fixed Effects, Random Effects, and Hausman test) to capture both short-run and long-run dynamics.

This was completed as a Final Year Project at the Institute of Business Administration (IBA), Karachi, under the supervision of Dr. Ghamz E Ali Siyal.

---

## Research Question

How does globalization — measured through FDI, trade openness, and the KOF Globalization Index — affect GDP per capita growth in SAARC economies, and do these effects differ across countries?

---

## Data

| Variable | Description | Source |
|---|---|---|
| GDP per capita growth | Dependent variable (annual %) | World Bank WDI |
| FDI | Net inflows as % of GDP | World Bank WDI |
| KOF Globalization Index | Composite globalization measure | ETH Zurich |
| Inflation (CPI) | Consumer price inflation (annual %) | IMF / World Bank |
| Trade | Exports + imports as % of GDP | World Bank WDI |
| Labor Force | Total labor force (logged) | World Bank WDI |
| Gross Capital Formation | % of GDP | World Bank WDI |
| Population Growth | Annual % | World Bank WDI |
| Net Migration | Net migration growth rate | World Bank WDI |
| Urbanization | Urban population as % of total | World Bank WDI |

**Note:** Raw data files are not included in this repository due to World Bank and IMF data licensing. Data can be freely downloaded from [World Bank WDI](https://databank.worldbank.org/source/world-development-indicators) and [KOF Globalization Index](https://kof.ethz.ch/en/forecasts-and-indicators/indicators/kof-globalisation-index.html).

---

## Methodology

### 1. Unit Root Testing (ADF)
Augmented Dickey-Fuller tests were run for each variable in each country to determine stationarity. Variables with p-values below 0.10 were classified as stationary.

### 2. ARDL Models (Per Country)
Given the mix of I(0) and I(1) variables, ARDL (Autoregressive Distributed Lag) models were estimated separately for each country. Lag lengths were selected based on model fit and significance.

### 3. Panel Data Analysis
A balanced panel dataset (4 countries × 31 years = 124 observations) was constructed. Fixed Effects (FE) and Random Effects (RE) models were estimated, and the Hausman test was used to determine the preferred specification.

---

## Key Findings

| Country | Key Finding |
|---|---|
| Pakistan | FDI positively significant at 10%; R² = 0.91 |
| India | FDI and Inflation significant at 1%; Trade significant at 5%; R² = 0.97 |
| Bangladesh | Trade and GI significant; R² = 0.96 |
| Nepal | Results vary by variable and lag structure |

---

## Repository Structure

```
├── saarc_analysis.do       # Main Stata do file (ADF, ARDL, Panel)
├── saarc_data.csv          # Dataset (not included — see Data section above)
├── ardl_results.csv        # Exported ARDL regression output
├── panel_results.csv       # Exported FE and RE regression output
├── saarc_analysis.log      # Stata log file
└── README.md
```

---

## Tools

- **Stata** — ADF tests, ARDL estimation, Fixed/Random Effects, Hausman test
- **Excel** — Initial data cleaning and merging across sources
- **Packages:** `ardl`, `estout`, `xttest0`

---

## Authors

- Muhammad Saad
- Muhammad Raffay Mangrani
- Dolat Kumar

Institute of Business Administration (IBA), Karachi — Bachelor of Science in Economics, 2024
