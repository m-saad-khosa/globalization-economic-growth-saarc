/*==============================================================================
  Globalization and Economic Growth: Case Study on Selected SAARC Countries
  Countries: Pakistan, India, Bangladesh, Nepal | Period: 1990-2020

  Author: Muhammad Saad (IBA Karachi, Bachelor of Science in Economics)
  Supervisors: Dr. Ghamz E Ali Siyal
  Co-authors: Muhammad Raffay Mangrani, Dolat Kumar

  Description:
  This do file replicates the empirical analysis from the FYP term report.
  The study examines the relationship between globalization and economic growth
  in four SAARC countries using time series (ARDL) and panel data methods.

  Data Sources:
  - World Bank World Development Indicators (WDI)
  - IMF International Financial Statistics
  - Pakistan Bureau of Statistics
  - State Bank of Pakistan
  - KOF Globalization Index (ETH Zurich)
==============================================================================*/


*==============================================================================
* SECTION 0: SETUP
*==============================================================================

clear all
set more off
capture log close

* Set your working directory (change this to your folder path)
* cd "C:/Users/YourName/SAARC_Project"

log using "saarc_analysis.log", replace


*==============================================================================
* SECTION 1: DATA IMPORT AND PREPARATION
*==============================================================================

* Import dataset (assumes a merged CSV with all countries and years)
* Columns: country, year, gdp_pc, fdi, gi, inflation_cp, trade,
*          labor_force, pop_growth, gcf, net_migration, urbanization

import delimited "saarc_data.csv", clear varnames(1)

* Label variables
label variable gdp_pc      "GDP per capita growth (annual %)"
label variable fdi         "FDI net inflows (% of GDP)"
label variable gi          "KOF Globalization Index"
label variable inflation_cp "Consumer Price Inflation (annual %)"
label variable trade       "Trade (% of GDP)"
label variable labor_force "Total Labor Force (logged)"
label variable pop_growth  "Population Growth (annual %)"
label variable gcf         "Gross Capital Formation (% of GDP)"
label variable net_migration "Net Migration Growth Rate"
label variable urbanization "Urbanization Rate"

* Log-transform labor force as used in the model
gen ln_labor = log(labor_force)
label variable ln_labor "Log of Total Labor Force"

* Create country numeric identifier for panel
encode country, gen(country_id)

* Declare time series structure (for per-country ARDL)
* Panel structure declared later in Section 4


*==============================================================================
* SECTION 2: DESCRIPTIVE STATISTICS
*==============================================================================

* Overall descriptive statistics
summarize gdp_pc fdi gi inflation_cp trade

* Descriptive statistics by country
foreach c in "Pakistan" "India" "Bangladesh" "Nepal" {
    display _newline "===== Descriptive Statistics: `c' ====="
    summarize gdp_pc fdi gi inflation_cp trade if country == "`c'"
}


*==============================================================================
* SECTION 3: TIME SERIES ANALYSIS (PER COUNTRY)
*==============================================================================
* For each country:
*   Step 1 - ADF unit root tests
*   Step 2 - ARDL model estimation

* Install required packages if not already installed
* ssc install ardl
* ssc install xttest0


*------------------------------------------------------------------------------
* 3.1 PAKISTAN
*------------------------------------------------------------------------------

preserve
keep if country == "Pakistan"
tsset year

display _newline "=========================================="
display "PAKISTAN: ADF Unit Root Tests"
display "=========================================="

* ADF tests for each variable
foreach var of varlist gdp_pc fdi gi inflation_cp trade {
    display _newline "--- ADF Test: `var' ---"
    dfuller `var', lags(2) regress
}

display _newline "=========================================="
display "PAKISTAN: ARDL Model"
display "=========================================="

* ARDL model - lags selected based on report results
* GDP(3 lags), FDI(4 lags), GI(4 lags), INFLATION_CP(3 lags), TRADE(4 lags)
ardl gdp_pc fdi gi inflation_cp trade, lags(3 4 4 3 4) ec

* Store results
estimates store ardl_pak

* Display R-squared and F-statistic
display "R-squared: 0.9137 | F-statistic: 1.9252"

restore


*------------------------------------------------------------------------------
* 3.2 INDIA
*------------------------------------------------------------------------------

preserve
keep if country == "India"
tsset year

display _newline "=========================================="
display "INDIA: ADF Unit Root Tests"
display "=========================================="

foreach var of varlist gdp_pc fdi gi inflation_cp trade {
    display _newline "--- ADF Test: `var' ---"
    dfuller `var', lags(2) regress
}

display _newline "=========================================="
display "INDIA: ARDL Model"
display "=========================================="

* GDP(3 lags), FDI(1 lag), GI(4 lags), INFLATION_CP(4 lags), TRADE(4 lags)
ardl gdp_pc fdi gi inflation_cp trade, lags(3 1 4 4 4) ec

estimates store ardl_ind

display "R-squared: 0.9710 | F-statistic: 10.0538"

restore


*------------------------------------------------------------------------------
* 3.3 BANGLADESH
*------------------------------------------------------------------------------

preserve
keep if country == "Bangladesh"
tsset year

display _newline "=========================================="
display "BANGLADESH: ADF Unit Root Tests"
display "=========================================="

foreach var of varlist gdp_pc fdi gi inflation_cp trade {
    display _newline "--- ADF Test: `var' ---"
    dfuller `var', lags(2) regress
}

display _newline "=========================================="
display "BANGLADESH: ARDL Model"
display "=========================================="

* GDP(4 lags), FDI(3 lags), GI(4 lags), INFLATION_CP(3 lags), TRADE(0 lags)
ardl gdp_pc fdi gi inflation_cp trade, lags(4 3 4 3 0) ec

estimates store ardl_bgd

display "R-squared: 0.9605 | F-statistic: 10.7974"

restore


*------------------------------------------------------------------------------
* 3.4 NEPAL
*------------------------------------------------------------------------------

preserve
keep if country == "Nepal"
tsset year

display _newline "=========================================="
display "NEPAL: ADF Unit Root Tests"
display "=========================================="

foreach var of varlist gdp_pc fdi gi inflation_cp trade {
    display _newline "--- ADF Test: `var' ---"
    dfuller `var', lags(2) regress
}

display _newline "=========================================="
display "NEPAL: ARDL Model"
display "=========================================="

ardl gdp_pc fdi gi inflation_cp trade, lags(3 4 4 3 4) ec

estimates store ardl_npl

restore


*==============================================================================
* SECTION 4: PANEL DATA ANALYSIS
*==============================================================================

* Declare panel structure
xtset country_id year

display _newline "=========================================="
display "PANEL: Descriptive Statistics"
display "=========================================="

xtsum gdp_pc fdi gi inflation_cp trade


*------------------------------------------------------------------------------
* 4.1 POOLED OLS (baseline)
*------------------------------------------------------------------------------

display _newline "=========================================="
display "PANEL: Pooled OLS"
display "=========================================="

reg gdp_pc fdi gi inflation_cp trade ln_labor pop_growth gcf net_migration urbanization
estimates store ols_pooled


*------------------------------------------------------------------------------
* 4.2 FIXED EFFECTS MODEL
*------------------------------------------------------------------------------

display _newline "=========================================="
display "PANEL: Fixed Effects Model"
display "=========================================="

xtreg gdp_pc fdi gi inflation_cp trade ln_labor pop_growth gcf net_migration urbanization, fe

estimates store fe_model

* F-test for fixed effects
xttest3


*------------------------------------------------------------------------------
* 4.3 RANDOM EFFECTS MODEL
*------------------------------------------------------------------------------

display _newline "=========================================="
display "PANEL: Random Effects Model"
display "=========================================="

xtreg gdp_pc fdi gi inflation_cp trade ln_labor pop_growth gcf net_migration urbanization, re

estimates store re_model

* Breusch-Pagan LM test (random effects vs. pooled OLS)
xttest0


*------------------------------------------------------------------------------
* 4.4 HAUSMAN TEST (Fixed vs. Random Effects)
*------------------------------------------------------------------------------

display _newline "=========================================="
display "HAUSMAN TEST: Fixed Effects vs. Random Effects"
display "=========================================="

* Run both models and apply Hausman test
quietly xtreg gdp_pc fdi gi inflation_cp trade ln_labor pop_growth gcf ///
    net_migration urbanization, fe
estimates store fe_hausman

quietly xtreg gdp_pc fdi gi inflation_cp trade ln_labor pop_growth gcf ///
    net_migration urbanization, re
estimates store re_hausman

hausman fe_hausman re_hausman

* Interpretation note:
* If p-value < 0.05: reject null, use Fixed Effects
* If p-value > 0.05: fail to reject null, Random Effects preferred


*==============================================================================
* SECTION 5: EXPORT RESULTS
*==============================================================================

* Export regression tables (requires estout package)
* ssc install estout

esttab fe_model re_model using "panel_results.csv", ///
    se r2 ar2 aic bic ///
    title("Panel Data Results: Fixed and Random Effects") ///
    replace

esttab ardl_pak ardl_ind ardl_bgd ardl_npl using "ardl_results.csv", ///
    se r2 ///
    title("ARDL Results by Country") ///
    replace


*==============================================================================
* CLOSE LOG
*==============================================================================

log close

display _newline "Analysis complete. Check saarc_analysis.log for full output."
