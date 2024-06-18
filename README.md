# Meat and dairy consumption in the Scottish Health Survey (2021)
Analysis of meat and dairy consumption among adults 16+ years in the 2021 Scottish Health Survey (SHeS)

## Data Management Files

### SHeS 2021_Data management_manuscript.do
This Stata do-file creates a food-level and participant-level dataset for SHeS containing disaggregated estimates of both meat and dairy consumption. It combines demographic survey data with dietary data collected through Intake24. 

At the participant level, mean daily intakes of meat (total, meat subtype and animal type), dairy (total and summary types - milk, cheese, yogurt, cream, and butter) and nutrients are calculated. Mean daily per cent contributions of all food categories and food groups to meat and dairy are provided, as well as mean daily per cent contributions of animal type (beef, pork, lamb, game and poultry) to meat intake, and dairy type (milk, cheese, yogurt, cream, and butter) to dairy intake. Mean daily consumption of low-fat and regular-fat dairy products is also calculated. Mean daily per cent contributions of high-level food categories to 28 nutrients were calculated; those with a contribution of at least 15% from 'meat and meat products' or 'milk and milk products' were explored further, and for these, contributions from all food groups were calculated.

#### Data files
Two data files are needed to run this do-file
- diet_dairydisag.dta_20231512 - Intake24 diet data from SHeS containing disaggregated quantities of dairy per portion of food consumed. There are multiple observations per participant, each observation corresponds to a food item reported. The code and datasets to create this file are available here: https://github.com/Cristina-Stewart/SHeS_Dairy-disaggregation. 
- shes21i_eul - participant demographic survey data. There is only one observation per participant. This is available to download from the UK Data Archive.

#### Do files
- SHeS 2021_Labels_manuscript - labels all the variables in the data management do-file.

### Output
- SHeS 2021_foodlevel_manuscript_20240603.dta - this dataset has multiple observations for each participant, corresponding to each food item reported
- SHeS 2021_participantlevel_manuscript_20240603.dta - this dataset has one observation for each participant

## Data Analysis Files
### SHeS 2021_Data analysis_manuscript.do
This do-file contains all analyses of dietary data used in the manuscript "Meat and milk product consumption in Scottish adults: insights from a national survey". This file also has code to generate figures for this manuscript.

### SHeS 2021_Exporting data into Excel tables_manuscript.do
This do-file contains code which exports the following data into Excel tables, overall and among population subgroups (age, gender, Scottish Index of Multiple Deprivation): 
1) Mean daily intake of nutrients per capita
2) Mean per cent contributions of nutrient intakes from food groups
3) Mean per cent contributions of meat from food groups
4) Mean per cent contrbiutions of dairy from food groups
5) Mean daily intakes of meat, per capita and among meat consumers
6) Mean daily intakes of dairy, per capita and among dairy consumers
7) Mean per cent contributions of animal type to meat intake
8) Mean per cent contributions of dairy type to dairy intake
9) Per cent of consumers across meat subtypes (red, white, and processed)
