

************************************************************************************
*Manuscript: "Meat and milk product consumption in Scottish adults: Insights from a national survey"

*Data analysis do-file for the manuscript 
************************************************************************************


****************
*Clear settings
****************
clear all
clear matrix
macro drop _all
graph drop _all


**************************************************************
*Assign values using global macros for file location and date
**************************************************************
global location "K:\DrJaacksGroup\FSS - Dietary Monitoring\SHeS\SHeS 2021" 
global data `"$location\Data"'
global output `"$location\Output"'
global date "20231016"

*Set maximum number of variables to 15,000
set maxvar 15000
*Read in data
use "$data\SHeS 2021_participantlevel__manuscript_$date.dta", clear
*Assign survey sampling variables
svyset [pweight=SHeS_Intake24_wt_sc], psu(psu) strata(Strata)
*Format P values to 4dp
set pformat %5.4f

*****************************
*DEMOGRAPHIC CHARACTERISTICS
*****************************
ta InIntake24 if age>=16

ta TwoRecalls

ta MeatConsumer DairyConsumer
svy, subpop(intake24): ta MeatConsumer DairyConsumer, percent

summ age if intake24==1
svy, subpop(intake24): mean age

ta Sex if intake24==1
svy, subpop(intake24): ta Sex, percent

ta age_cat if intake24==1
svy, subpop(intake24): ta age_cat, percent

ta Ethnic05 if intake24==1
svy, subpop(intake24): ta Ethnic05, percent

ta simd20_sga if intake24==1
svy, subpop(intake24): ta simd20_sga, percent



******************
******************
*MEAT CONSUMPTION
******************
******************

*Mean daily intake of meat, per capita 
svy, subpop(intake24): mean Avg_Day_TotalMeat Avg_Day_RedMeat Avg_Day_WhiteMeat Avg_Day_ProcessedMeat

*Differences in meat consumption across demographic subgroups, per capita
	*Total meat
	svy, subpop(intake24): mean Avg_Day_TotalMeat, over(Sex)
	svy, subpop(intake24): mean Avg_Day_TotalMeat, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_TotalMeat, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_TotalMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga

	*Red meat
	svy, subpop(intake24): mean Avg_Day_RedMeat, over(Sex)
	svy, subpop(intake24): mean Avg_Day_RedMeat, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_RedMeat, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_RedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga

	*White meat
	svy, subpop(intake24): mean Avg_Day_WhiteMeat, over(Sex)
	svy, subpop(intake24): mean Avg_Day_WhiteMeat, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_WhiteMeat, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_WhiteMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga

	*Processed meat
	svy, subpop(intake24): mean Avg_Day_ProcessedMeat, over(Sex)
	svy, subpop(intake24): mean Avg_Day_ProcessedMeat, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_ProcessedMeat, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_ProcessedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga

*Proportion meat consumers
ta MeatConsumer if intake24==1
svy, subpop(intake24): prop MeatConsumer, percent
svy, subpop(MeatConsumer if NumberOfRecalls==2): prop MeatConsumerDays, percent

svy, subpop(intake24): prop RedMeatConsumer, percent
svy, subpop(intake24): prop WhiteMeatConsumer, percent
svy, subpop(intake24): prop ProcessedMeatConsumer, percent

*Likelihood eating meat on second recall if consumed on first recall
svy, subpop(TwoRecalls): prop MeatConsumerDay2, over(MeatConsumerDay1)
svy, subpop(TwoRecalls): logit MeatConsumerDay2 i.MeatConsumerDay1, or


*Differences in probability of being a meat consumer across demographic subgroups
	*Total meat 
	svy, subpop(intake24): prop MeatConsumer, over(Sex) percent
	svy, subpop(intake24): prop MeatConsumer, over(age_cat) percent
	svy, subpop(intake24): prop MeatConsumer, over(simd20_sga) percent
	svy, subpop(intake24): logit MeatConsumer ib(2).Sex ib(1).age_cat ib(1).simd20_sga, or

	*Red meat 
	svy, subpop(intake24): prop RedMeatConsumer, over(Sex) percent
	svy, subpop(intake24): prop RedMeatConsumer, over(age_cat) percent
	svy, subpop(intake24): prop RedMeatConsumer, over(simd20_sga) percent
	svy: logit RedMeatConsumer ib(2).Sex ib(1).age_cat ib(1).simd20_sga, or

	*White meat 
	svy, subpop(intake24): prop WhiteMeatConsumer, over(Sex) percent
	svy, subpop(intake24): prop WhiteMeatConsumer, over(age_cat) percent
	svy, subpop(intake24): prop WhiteMeatConsumer, over(simd20_sga) percent
	svy, subpop(intake24): logit WhiteMeatConsumer ib(2).Sex ib(1).age_cat ib(1).simd20_sga, or

	*Processed meat 
	svy, subpop(intake24): prop ProcessedMeatConsumer, over(Sex) percent
	svy, subpop(intake24): prop ProcessedMeatConsumer, over(age_cat) percent
	svy, subpop(intake24): prop ProcessedMeatConsumer, over(simd20_sga) percent
	svy, subpop(intake24): logit ProcessedMeatConsumer ib(2).Sex ib(1).age_cat ib(1).simd20_sga, or

*Mean daily intake of meat, among consumers
svy, subpop(MeatConsumer): mean Avg_Day_TotalMeat Avg_Day_RedMeat Avg_Day_WhiteMeat Avg_Day_ProcessedMeat

*Differences in meat consumption across demographic subgroups, among consumers
svy, subpop(MeatConsumer): reg Avg_Day_TotalMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga
svy, subpop(MeatConsumer): reg Avg_Day_RedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga
svy, subpop(MeatConsumer): reg Avg_Day_WhiteMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga
svy, subpop(MeatConsumer): reg Avg_Day_ProcessedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga

*Create binary variable for meeting SDG for red and processed meat (max 70g)
gen SDG_70_meeting=.
replace SDG_70_meeting=1 if Avg_Day_RRPM <=70 & intake24==1
replace SDG_70_meeting=0 if Avg_Day_RRPM >70 & intake24==1

	*Prop of meat consumers meeting SDG recommendation
	svy, subpop(MeatConsumer): prop SDG_70_meeting, percent
	ta SDG_70_meeting if MeatConsumer==1


*Sensitivity analysis 1: Adjusting for mean daily energy intake, per capita only
	svy, subpop(intake24): reg Avg_Day_TotalMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal
	svy, subpop(intake24): reg Avg_Day_RedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal
	svy, subpop(intake24): reg Avg_Day_WhiteMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal
	svy, subpop(intake24): reg Avg_Day_ProcessedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal

	
*Sensitivity analysis 2: Excluding outliers (+/- 2 SDs mean), per capita only

	*Total meat
	summ Avg_Day_TotalMeat [aweight=SHeS_Intake24_wt_sc]
	local mean_TotalMeat =r(mean)
	local sd_TotalMeat=r(sd)
	gen notoutlier=1 if Avg_Day_TotalMeat>(`mean_TotalMeat'-2*`sd_TotalMeat') | Avg_Day_TotalMeat<(`mean_TotalMeat'+2*`sd_TotalMeat') & Avg_Day_TotalMeat!=. 
	replace notoutlier=0 if Avg_Day_TotalMeat<(`mean_TotalMeat'-2*`sd_TotalMeat') | Avg_Day_TotalMeat>(`mean_TotalMeat'+2*`sd_TotalMeat') & Avg_Day_TotalMeat!=.

	svy, subpop(notoutlier): mean Avg_Day_TotalMeat, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_TotalMeat, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_TotalMeat, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_TotalMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga 
	drop notoutlier
	
	*Red meat
	summ Avg_Day_RedMeat [aweight=SHeS_Intake24_wt_sc]
	local mean_RedMeat =r(mean)
	local sd_RedMeat=r(sd)
	gen notoutlier=1 if Avg_Day_RedMeat>(`mean_RedMeat'-2*`sd_RedMeat') | Avg_Day_RedMeat<(`mean_RedMeat'+2*`sd_RedMeat') & Avg_Day_RedMeat!=.
	replace notoutlier=0 if Avg_Day_RedMeat<(`mean_RedMeat'-2*`sd_RedMeat') | Avg_Day_RedMeat>(`mean_RedMeat'+2*`sd_RedMeat') & Avg_Day_RedMeat!=.

	svy, subpop(notoutlier): mean Avg_Day_RedMeat, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_RedMeat, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_RedMeat, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_RedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga  
	drop notoutlier
	
	*White meat
	summ Avg_Day_WhiteMeat [aweight=SHeS_Intake24_wt_sc]
	local mean_WhiteMeat =r(mean)
	local sd_WhiteMeat=r(sd)
	gen notoutlier=1 if Avg_Day_WhiteMeat>(`mean_WhiteMeat'-2*`sd_WhiteMeat') | Avg_Day_WhiteMeat<(`mean_WhiteMeat'+2*`sd_WhiteMeat') & Avg_Day_WhiteMeat!=.
	replace notoutlier=0 if Avg_Day_WhiteMeat<(`mean_WhiteMeat'-2*`sd_WhiteMeat') | Avg_Day_WhiteMeat>(`mean_WhiteMeat'+2*`sd_WhiteMeat') & Avg_Day_WhiteMeat!=.
	
	svy, subpop(notoutlier): mean Avg_Day_WhiteMeat, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_WhiteMeat, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_WhiteMeat, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_WhiteMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	drop notoutlier
	
	*Processed meat
	summ Avg_Day_ProcessedMeat [aweight=SHeS_Intake24_wt_sc]
	local mean_ProcessedMeat =r(mean)
	local sd_ProcessedMeat=r(sd)
	gen notoutlier=1 if Avg_Day_ProcessedMeat>(`mean_ProcessedMeat'-2*`sd_ProcessedMeat') | Avg_Day_ProcessedMeat<(`mean_ProcessedMeat'+2*`sd_ProcessedMeat') & Avg_Day_ProcessedMeat!=.
	replace notoutlier=0 if Avg_Day_ProcessedMeat<(`mean_ProcessedMeat'-2*`sd_ProcessedMeat') | Avg_Day_ProcessedMeat>(`mean_ProcessedMeat'+2*`sd_ProcessedMeat') & Avg_Day_ProcessedMeat!=.
	
	svy, subpop(notoutlier): mean Avg_Day_ProcessedMeat, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_ProcessedMeat, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_ProcessedMeat, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_ProcessedMeat ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	drop notoutlier
	
	
*Animal type
*Proportion of meat that is beef, pork, lamb, poultry and game
svy, subpop(intake24): mean Prop_Avg_Day_Beef Prop_Avg_Day_Pork Prop_Avg_Day_Lamb Prop_Avg_Day_Poultry Prop_Avg_Day_Game

*Differences in animal type across demographic subgroups
	*Beef
	svy, subpop(intake24): mean Prop_Avg_Day_Beef, over(Sex)
	svy, subpop(intake24): mean Prop_Avg_Day_Beef, over(age_cat)
	svy, subpop(intake24): mean Prop_Avg_Day_Beef, over(simd20_sga)
	svy, subpop(intake24): reg Prop_Avg_Day_Beef ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Pork
	svy, subpop(intake24): mean Prop_Avg_Day_Pork, over(Sex)
	svy, subpop(intake24): mean Prop_Avg_Day_Pork, over(age_cat)
	svy, subpop(intake24): mean Prop_Avg_Day_Pork, over(simd20_sga)
	svy: reg Prop_Avg_Day_Pork ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Lamb
	svy, subpop(intake24): mean Prop_Avg_Day_Lamb, over(Sex)
	svy, subpop(intake24): mean Prop_Avg_Day_Lamb, over(age_cat)
	svy, subpop(intake24): mean Prop_Avg_Day_Lamb, over(simd20_sga)
	svy: reg Prop_Avg_Day_Lamb ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Poultry
	svy, subpop(intake24): mean Prop_Avg_Day_Poultry, over(Sex)
	svy, subpop(intake24): mean Prop_Avg_Day_Poultry, over(age_cat)
	svy, subpop(intake24): mean Prop_Avg_Day_Poultry, over(simd20_sga)
	svy: reg Prop_Avg_Day_Poultry ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Game
	svy, subpop(intake24): mean Prop_Avg_Day_Game, over(Sex)
	svy, subpop(intake24): mean Prop_Avg_Day_Game, over(age_cat)
	svy, subpop(intake24): mean Prop_Avg_Day_Game, over(simd20_sga)
	svy: reg Prop_Avg_Day_Game ib(2).Sex ib(1).age_cat ib(1).simd20_sga



***************************
***************************
*MILK PRODUCT CONSUMPTION
***************************
***************************

*Mean daily intake of dairy products, per capita 
svy, subpop(intake24): mean Avg_Day_TotDairy Avg_Day_Milk Avg_Day_Cheese Avg_Day_Yogurt Avg_Day_CreamDesserts Avg_Day_Butter

*Differences in dairy product consumption across demographic subgroups, per capita
	*Total milk products
	svy, subpop(intake24): mean Avg_Day_TotDairy, over(Sex)
	svy, subpop(intake24): mean Avg_Day_TotDairy, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_TotDairy, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_TotDairy ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Milk
	svy, subpop(intake24): mean Avg_Day_Milk, over(Sex)
	svy, subpop(intake24): mean Avg_Day_Milk, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_Milk, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_Milk ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Cheese
	svy, subpop(intake24): mean Avg_Day_Cheese, over(Sex)
	svy, subpop(intake24): mean Avg_Day_Cheese, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_Cheese, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_Cheese ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	
	*Yogurt
	svy, subpop(intake24): mean Avg_Day_Yogurt, over(Sex)
	svy, subpop(intake24): mean Avg_Day_Yogurt, over(age_cat)
	svy, subpop(intake24): mean Avg_Day_Yogurt, over(simd20_sga)
	svy, subpop(intake24): reg Avg_Day_Yogurt ib(2).Sex ib(1).age_cat ib(1).simd20_sga

	
*Proportion dairy consumers 
ta DairyConsumer
svy, subpop(intake24): prop DairyConsumer, percent
svy, subpop(DairyConsumer): prop MeatConsumer 
svy, subpop(DairyConsumer if NumberOfRecalls==2): prop DairyConsumerDays, percent

*Likelihood eating milk products on second recall if consumed on first recall
svy, subpop(TwoRecalls): prop DairyConsumerDay2, over(DairyConsumerDay1)
svy, subpop(TwoRecalls): logit DairyConsumerDay2 i.DairyConsumerDay1, or

*Differences in probability of being a milk product consumer across demographic subgroup
svy, subpop(intake24): prop DairyConsumer, over(Sex) percent
svy, subpop(intake24): prop DairyConsumer, over(age_cat) percent
svy, subpop(intake24): prop DairyConsumer, over(simd20_sga) percent
svy, subpop(intake24): logit DairyConsumer ib(2).Sex ib(1).age_cat ib(1).simd20_sga, or

*Mean daily intake of dairy products, among consumers
svy, subpop(DairyConsumer): mean Avg_Day_TotDairy Avg_Day_Milk Avg_Day_Cheese Avg_Day_Yogurt Avg_Day_CreamDesserts Avg_Day_Butter

*Differences in dairy product consumption across demographic subgroups, among consumers
svy, subpop(DairyConsumer): reg Avg_Day_TotDairy ib(2).Sex ib(1).age_cat ib(1).simd20_sga
svy, subpop(DairyConsumer): reg Avg_Day_Milk ib(2).Sex ib(1).age_cat ib(1).simd20_sga
svy, subpop(DairyConsumer): reg Avg_Day_Cheese ib(2).Sex ib(1).age_cat ib(1).simd20_sga
svy, subpop(DairyConsumer): reg Avg_Day_Yogurt ib(2).Sex ib(1).age_cat ib(1).simd20_sga

*Sensitivity Analysis 1: Adjusting for mean daily energy intake
svy, subpop(intake24): reg Avg_Day_TotDairy ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal
svy, subpop(intake24): reg Avg_Day_Milk ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal
svy, subpop(intake24): reg Avg_Day_Cheese ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal
svy, subpop(intake24): reg Avg_Day_Yogurt ib(2).Sex ib(1).age_cat ib(1).simd20_sga Avg_Day_Energykcal


*Sensitivity Analysis 2: Excluding outliers
	*Total milk products
	summ Avg_Day_TotDairy [aweight=SHeS_Intake24_wt_sc]
	local mean_TotDairy =r(mean)
	local sd_TotDairy=r(sd)
	gen notoutlier=1 if Avg_Day_TotDairy>(`mean_TotDairy'-2*`sd_TotDairy') | Avg_Day_TotDairy<(`mean_TotDairy'+2*`sd_TotDairy') & Avg_Day_TotDairy!=.
	replace notoutlier=0 if Avg_Day_TotDairy<(`mean_TotDairy'-2*`sd_TotDairy') | Avg_Day_TotDairy>(`mean_TotDairy'+2*`sd_TotDairy') & Avg_Day_TotDairy!=.
	
	svy, subpop(notoutlier): mean Avg_Day_TotDairy, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_TotDairy, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_TotDairy, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_TotDairy ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	drop notoutlier
	
	*Milk
	summ Avg_Day_Milk [aweight=SHeS_Intake24_wt_sc]
	local mean_Milk =r(mean)
	local sd_Milk=r(sd)
	gen notoutlier=1 if Avg_Day_Milk>(`mean_Milk'-2*`sd_Milk') | Avg_Day_Milk<(`mean_Milk'+2*`sd_Milk') & Avg_Day_Milk!=.
	replace notoutlier=0 if Avg_Day_Milk<(`mean_Milk'-2*`sd_Milk') | Avg_Day_Milk>(`mean_Milk'+2*`sd_Milk') & Avg_Day_Milk!=.
	
	svy, subpop(notoutlier): mean Avg_Day_Milk, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_Milk, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_Milk, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_Milk ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	drop notoutlier

	*Cheese
	summ Avg_Day_Cheese [aweight=SHeS_Intake24_wt_sc]
	local mean_Cheese =r(mean)
	local sd_Cheese=r(sd)
	gen notoutlier=1 if Avg_Day_Cheese>(`mean_Cheese'-2*`sd_Cheese') | Avg_Day_Cheese<(`mean_Cheese'+2*`sd_Cheese') & Avg_Day_Cheese!=.
	replace notoutlier=0 if Avg_Day_Cheese<(`mean_Cheese'-2*`sd_Cheese') | Avg_Day_Cheese>(`mean_Cheese'+2*`sd_Cheese') & Avg_Day_Cheese!=.
	
	svy, subpop(notoutlier): mean Avg_Day_Cheese, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_Cheese, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_Cheese, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_Cheese ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	drop notoutlier

	*Yogurt
	summ Avg_Day_Yogurt [aweight=SHeS_Intake24_wt_sc]
	local mean_Yogurt =r(mean)
	local sd_Yogurt=r(sd)
	gen notoutlier=1 if Avg_Day_Yogurt>(`mean_Yogurt'-2*`sd_Yogurt') | Avg_Day_Yogurt<(`mean_Yogurt'+2*`sd_Yogurt') & Avg_Day_Yogurt!=.
	replace notoutlier=0 if Avg_Day_Yogurt<(`mean_Yogurt'-2*`sd_Yogurt') | Avg_Day_Yogurt>(`mean_Yogurt'+2*`sd_Yogurt') & Avg_Day_Yogurt!=.

	svy, subpop(notoutlier): mean Avg_Day_Yogurt, over(Sex)
	svy, subpop(notoutlier): mean Avg_Day_Yogurt, over(age_cat)
	svy, subpop(notoutlier): mean Avg_Day_Yogurt, over(simd20_sga)
	svy, subpop(notoutlier): reg Avg_Day_Yogurt ib(2).Sex ib(1).age_cat ib(1).simd20_sga
	drop notoutlier

*Proportion of milk products that is milk, cheese, yogurt, cream & dairy desserts, and butter
svy, subpop(intake24): mean Prop_Avg_Day_Milk Prop_Avg_Day_Cheese Prop_Avg_Day_Yogurt Prop_Avg_Day_CreamDesserts Prop_Avg_Day_Butter

	
*Low fat vs regular fat milk product consumption

*Proportion of low fat dairy
svy, subpop(DairyConsumer): mean Prop_Avg_Day_LFTotDairy 
svy, subpop(DairyConsumer): mean Prop_Avg_Day_LFMilk 
svy, subpop(DairyConsumer): mean Prop_Avg_Day_LFYogurt   
svy, subpop(DairyConsumer): mean Prop_Avg_Day_LFCheese  

*Split LF milk and yogurt consumption into ordinal variable 		
gen LF_MilkYog_Cat=.
replace LF_MilkYog_Cat=1 if Prop_Avg_Day_LFTotMilkYog>=0 & Prop_Avg_Day_LFTotMilkYog<=0.4 
replace LF_MilkYog_Cat=2 if Prop_Avg_Day_LFTotMilkYog>=0.5 & Prop_Avg_Day_LFTotMilkYog<99.5
replace LF_MilkYog_Cat=3 if Prop_Avg_Day_LFTotMilkYog>=99.5 & Prop_Avg_Day_LFTotMilkYog!=.

*Ordinal regression to explore difference in LF milk and yogurt consumption
svy, subpop(DairyConsumer): prop LF_MilkYog_Cat, percent 				
svy, subpop(DairyConsumer): prop LF_MilkYog_Cat, over(Sex) percent
svy, subpop(DairyConsumer): prop LF_MilkYog_Cat, over(age_cat) percent
svy, subpop(DairyConsumer): prop LF_MilkYog_Cat, over(simd20_sga) percent
svy, subpop(DairyConsumer): ologit LF_MilkYog_Cat ib(2).Sex ib(1).age_cat ib(1).simd20_sga, or 
 


**********************************************************************************
**********************************************************************************
*POPULAITON MEAN NUTRIENT INTAKES 
*Only among those who completed two recalls
**********************************************************************************
**********************************************************************************

*Mean energy intake overall						
svy, subpop(TwoRecalls): mean Avg_Day_Energykcal

*Mean protein intake overall
svy, subpop(TwoRecalls): mean Avg_Day_Proteing

*Mean intakes for DRV age/sex groups
svy, subpop(TwoRecalls): mean Avg_Day_Proteing, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Calciummg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Chloridemg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Iodine, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Ironmg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Phosphorusmg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Selenium, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Sodiummg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Zincmg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_VitaminA, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Riboflavinmg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_Niacin, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_VitaminB6mg, over(RNI_agesex)
svy, subpop(TwoRecalls): mean Avg_Day_VitaminB12, over(RNI_agesex)

*EARs for energy have different age/sex groups
svy, subpop(TwoRecalls if Sex==1 & age >=15 & age <=18): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==1 & age >=19 & age <=49): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==1 & age >=50 & age <=59): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==1 & age >=60 & age <=64): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==1 & age >=65 & age <=74): mean Avg_Day_Energykcal 
svy, subpop(TwoRecalls if Sex==1 & age >=75): mean Avg_Day_Energykcal 

svy, subpop(TwoRecalls if Sex==2 & age >=15 & age <=18): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==2 & age >=19 & age <=49): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==2 & age >=50 & age <=59): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==2 & age >=60 & age <=64): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==2 & age >=65 & age <=74): mean Avg_Day_Energykcal
svy, subpop(TwoRecalls if Sex==2 & age >=75): mean Avg_Day_Energykcal



********************************************************			
********************************************************
*MEAT AND MILK PRODUCT CONTRIBUTIONS TO NUTRIENT INTAKE
********************************************************
********************************************************

*Meat 											

*Bacon and ham 
svy, subpop(intake24): mean Prop_Avg_Proteing_22 Prop_Avg_Fatg_22 Prop_Avg_Sodiummg_22 Prop_Avg_Calciummg_22 Prop_Avg_Phosphorusmg_22 Prop_Avg_Ironmg_22 Prop_Avg_Zincmg_22 Prop_Avg_Chloridemg_22 Prop_Avg_VitaminA_22 Prop_Avg_Riboflavinmg_22 Prop_Avg_Niacin_22 Prop_Avg_VitaminB6mg_22 Prop_Avg_VitaminB12_22 Prop_Avg_Iodine_22 Prop_Avg_Selenium_22 /*none contributed >=5%*/

*Beef dishes
svy, subpop(intake24): mean Prop_Avg_Proteing_23 Prop_Avg_Fatg_23 Prop_Avg_Sodiummg_23 Prop_Avg_Calciummg_23 Prop_Avg_Phosphorusmg_23 Prop_Avg_Ironmg_23 Prop_Avg_Zincmg_23 Prop_Avg_Chloridemg_23 Prop_Avg_VitaminA_23 Prop_Avg_Riboflavinmg_23 Prop_Avg_Niacin_23 Prop_Avg_VitaminB6mg_23 Prop_Avg_VitaminB12_23 Prop_Avg_Iodine_23 Prop_Avg_Selenium_23

*Lamb dishes
svy, subpop(intake24): mean Prop_Avg_Proteing_24 Prop_Avg_Fatg_24 Prop_Avg_Sodiummg_24 Prop_Avg_Calciummg_24 Prop_Avg_Phosphorusmg_24 Prop_Avg_Ironmg_24 Prop_Avg_Zincmg_24 Prop_Avg_Chloridemg_24 Prop_Avg_VitaminA_24 Prop_Avg_Riboflavinmg_24 Prop_Avg_Niacin_24 Prop_Avg_VitaminB6mg_24 Prop_Avg_VitaminB12_24 Prop_Avg_Iodine_24 Prop_Avg_Selenium_24 /*none contributed >=5%*/

*Pork dishes 
svy, subpop(intake24): mean Prop_Avg_Proteing_25 Prop_Avg_Fatg_25 Prop_Avg_Sodiummg_25 Prop_Avg_Calciummg_25 Prop_Avg_Phosphorusmg_25 Prop_Avg_Ironmg_25 Prop_Avg_Zincmg_25 Prop_Avg_Chloridemg_25 Prop_Avg_VitaminA_25 Prop_Avg_Riboflavinmg_25 Prop_Avg_Niacin_25 Prop_Avg_VitaminB6mg_25 Prop_Avg_VitaminB12_25 Prop_Avg_Iodine_25 Prop_Avg_Selenium_25 /*none contributed >=5%*/

*Coated chicken
svy, subpop(intake24): mean Prop_Avg_Proteing_26 Prop_Avg_Fatg_26 Prop_Avg_Sodiummg_26 Prop_Avg_Calciummg_26 Prop_Avg_Phosphorusmg_26 Prop_Avg_Ironmg_26 Prop_Avg_Zincmg_26 Prop_Avg_Chloridemg_26 Prop_Avg_VitaminA_26 Prop_Avg_Riboflavinmg_26 Prop_Avg_Niacin_26 Prop_Avg_VitaminB6mg_26 Prop_Avg_VitaminB12_26 Prop_Avg_Iodine_26 Prop_Avg_Selenium_26 /*none contributed >=5%*/

*Chicken dishes
svy, subpop(intake24): mean Prop_Avg_Proteing_27 Prop_Avg_Fatg_27 Prop_Avg_Sodiummg_27 Prop_Avg_Calciummg_27 Prop_Avg_Phosphorusmg_27 Prop_Avg_Ironmg_27 Prop_Avg_Zincmg_27 Prop_Avg_Chloridemg_27 Prop_Avg_VitaminA_27 Prop_Avg_Riboflavinmg_27 Prop_Avg_Niacin_27 Prop_Avg_VitaminB6mg_27 Prop_Avg_VitaminB12_27 Prop_Avg_Iodine_27 Prop_Avg_Selenium_27

*Liver dishes
svy, subpop(intake24): mean Prop_Avg_Proteing_28 Prop_Avg_Fatg_28 Prop_Avg_Sodiummg_28 Prop_Avg_Calciummg_28 Prop_Avg_Phosphorusmg_28 Prop_Avg_Ironmg_28 Prop_Avg_Zincmg_28 Prop_Avg_Chloridemg_28 Prop_Avg_VitaminA_28 Prop_Avg_Riboflavinmg_28 Prop_Avg_Niacin_28 Prop_Avg_VitaminB6mg_28 Prop_Avg_VitaminB12_28 Prop_Avg_Iodine_28 Prop_Avg_Selenium_28 /*none contributed >=5%*/

*Burgers
svy, subpop(intake24): mean Prop_Avg_Proteing_29 Prop_Avg_Fatg_29 Prop_Avg_Sodiummg_29 Prop_Avg_Calciummg_29 Prop_Avg_Phosphorusmg_29 Prop_Avg_Ironmg_29 Prop_Avg_Zincmg_29 Prop_Avg_Chloridemg_29 Prop_Avg_VitaminA_29 Prop_Avg_Riboflavinmg_29 Prop_Avg_Niacin_29 Prop_Avg_VitaminB6mg_29 Prop_Avg_VitaminB12_29 Prop_Avg_Iodine_29 Prop_Avg_Selenium_29 /*none contributed >=5%*/

*Sausages
svy, subpop(intake24): mean Prop_Avg_Proteing_30 Prop_Avg_Fatg_30 Prop_Avg_Sodiummg_30 Prop_Avg_Calciummg_30 Prop_Avg_Phosphorusmg_30 Prop_Avg_Ironmg_30 Prop_Avg_Zincmg_30 Prop_Avg_Chloridemg_30 Prop_Avg_VitaminA_30 Prop_Avg_Riboflavinmg_30 Prop_Avg_Niacin_30 Prop_Avg_VitaminB6mg_30 Prop_Avg_VitaminB12_30 Prop_Avg_Iodine_30 Prop_Avg_Selenium_30 /*none contributed >=5%*/

*Meat pies
svy, subpop(intake24): mean Prop_Avg_Proteing_31 Prop_Avg_Fatg_31 Prop_Avg_Sodiummg_31 Prop_Avg_Calciummg_31 Prop_Avg_Phosphorusmg_31 Prop_Avg_Ironmg_31 Prop_Avg_Zincmg_31 Prop_Avg_Chloridemg_31 Prop_Avg_VitaminA_31 Prop_Avg_Riboflavinmg_31 Prop_Avg_Niacin_31 Prop_Avg_VitaminB6mg_31 Prop_Avg_VitaminB12_31 Prop_Avg_Iodine_31 Prop_Avg_Selenium_31 /*none contributed >=5%*/

*Other meat products
svy, subpop(intake24): mean Prop_Avg_Proteing_32 Prop_Avg_Fatg_32 Prop_Avg_Sodiummg_32 Prop_Avg_Calciummg_32 Prop_Avg_Phosphorusmg_32 Prop_Avg_Ironmg_32 Prop_Avg_Zincmg_32 Prop_Avg_Chloridemg_32 Prop_Avg_VitaminA_32 Prop_Avg_Riboflavinmg_32 Prop_Avg_Niacin_32 Prop_Avg_VitaminB6mg_32 Prop_Avg_VitaminB12_32 Prop_Avg_Iodine_32 Prop_Avg_Selenium_32 /*none contributed >=5%*/


***THOSE ABOVE 5%***

**Beef dishes 
*Main food group					
svy, subpop(intake24): mean Prop_Avg_Proteing_23 Prop_Avg_Zincmg_23 Prop_Avg_Niacin_23 Prop_Avg_VitaminB6mg_23 Prop_Avg_VitaminB12_23

*Sub food groups
svy, subpop(intake24): mean Prop_Avg_Proteing_23A Prop_Avg_Zincmg_23A Prop_Avg_Niacin_23A Prop_Avg_VitaminB6mg_23A Prop_Avg_VitaminB12_23A Prop_Avg_Proteing_23B Prop_Avg_Zincmg_23B Prop_Avg_Niacin_23B Prop_Avg_VitaminB6mg_23B Prop_Avg_VitaminB12_23B

**Chicken dishes
*Main food group
svy, subpop(intake24): mean Prop_Avg_Proteing_27 Prop_Avg_Phosphorusmg_27 Prop_Avg_Zincmg_27 Prop_Avg_Niacin_27 Prop_Avg_VitaminB6mg_27 Prop_Avg_Selenium_27 

*Sub food group
svy, subpop(intake24): mean Prop_Avg_Proteing_27A Prop_Avg_Phosphorusmg_27A Prop_Avg_Zincmg_27A Prop_Avg_Niacin_27A Prop_Avg_VitaminB6mg_27A Prop_Avg_Selenium_27A Prop_Avg_Proteing_27B Prop_Avg_Phosphorusmg_27B Prop_Avg_Zincmg_27B Prop_Avg_Niacin_27B Prop_Avg_VitaminB6mg_27B Prop_Avg_Selenium_27B 


*Milk products

*Whole milk
svy, subpop(intake24): mean Prop_Avg_Proteing_10 Prop_Avg_Fatg_10 Prop_Avg_Sodiummg_10 Prop_Avg_Calciummg_10 Prop_Avg_Phosphorusmg_10 Prop_Avg_Ironmg_10 Prop_Avg_Zincmg_10 Prop_Avg_Chloridemg_10 Prop_Avg_VitaminA_10 Prop_Avg_Riboflavinmg_10 Prop_Avg_Niacin_10 Prop_Avg_VitaminB6mg_10 Prop_Avg_VitaminB12_10 Prop_Avg_Iodine_10 Prop_Avg_Selenium_10

*Semi-skimmed milk
svy, subpop(intake24): mean Prop_Avg_Proteing_11 Prop_Avg_Fatg_11 Prop_Avg_Sodiummg_11 Prop_Avg_Calciummg_11 Prop_Avg_Phosphorusmg_11 Prop_Avg_Ironmg_11 Prop_Avg_Zincmg_11 Prop_Avg_Chloridemg_11 Prop_Avg_VitaminA_11 Prop_Avg_Riboflavinmg_11 Prop_Avg_Niacin_11 Prop_Avg_VitaminB6mg_11 Prop_Avg_VitaminB12_11 Prop_Avg_Iodine_11 Prop_Avg_Selenium_11

*1% milk
svy, subpop(intake24): mean Prop_Avg_Proteing_60 Prop_Avg_Fatg_60 Prop_Avg_Sodiummg_60 Prop_Avg_Calciummg_60 Prop_Avg_Phosphorusmg_60 Prop_Avg_Ironmg_60 Prop_Avg_Zincmg_60 Prop_Avg_Chloridemg_60 Prop_Avg_VitaminA_60 Prop_Avg_Riboflavinmg_60 Prop_Avg_Niacin_60 Prop_Avg_VitaminB6mg_60 Prop_Avg_VitaminB12_60 Prop_Avg_Iodine_60 Prop_Avg_Selenium_60 /*none contributed >=5%*/

*Skimmed milk
svy, subpop(intake24): mean Prop_Avg_Proteing_12 Prop_Avg_Fatg_12 Prop_Avg_Sodiummg_12 Prop_Avg_Calciummg_12 Prop_Avg_Phosphorusmg_12 Prop_Avg_Ironmg_12 Prop_Avg_Zincmg_12 Prop_Avg_Chloridemg_12 Prop_Avg_VitaminA_12 Prop_Avg_Riboflavinmg_12 Prop_Avg_Niacin_12 Prop_Avg_VitaminB6mg_12 Prop_Avg_VitaminB12_12 Prop_Avg_Iodine_12 Prop_Avg_Selenium_12 /*none contributed >=5%*/

*Other milk and cream 
svy, subpop(intake24): mean Prop_Avg_Proteing_13 Prop_Avg_Fatg_13 Prop_Avg_Sodiummg_13 Prop_Avg_Calciummg_13 Prop_Avg_Phosphorusmg_13 Prop_Avg_Ironmg_13 Prop_Avg_Zincmg_13 Prop_Avg_Chloridemg_13 Prop_Avg_VitaminA_13 Prop_Avg_Riboflavinmg_13 Prop_Avg_Niacin_13 Prop_Avg_VitaminB6mg_13 Prop_Avg_VitaminB12_13 Prop_Avg_Iodine_13 Prop_Avg_Selenium_13

*Cheese
svy, subpop(intake24): mean Prop_Avg_Proteing_14 Prop_Avg_Fatg_14 Prop_Avg_Sodiummg_14 Prop_Avg_Calciummg_14 Prop_Avg_Phosphorusmg_14 Prop_Avg_Ironmg_14 Prop_Avg_Zincmg_14 Prop_Avg_Chloridemg_14 Prop_Avg_VitaminA_14 Prop_Avg_Riboflavinmg_14 Prop_Avg_Niacin_14 Prop_Avg_VitaminB6mg_14 Prop_Avg_VitaminB12_14 Prop_Avg_Iodine_14 Prop_Avg_Selenium_14

*Yogurt, fromage frais and other dairy desserts
svy, subpop(intake24): mean Prop_Avg_Proteing_15 Prop_Avg_Fatg_15 Prop_Avg_Sodiummg_15 Prop_Avg_Calciummg_15 Prop_Avg_Phosphorusmg_15 Prop_Avg_Ironmg_15 Prop_Avg_Zincmg_15 Prop_Avg_Chloridemg_15 Prop_Avg_VitaminA_15 Prop_Avg_Riboflavinmg_15 Prop_Avg_Niacin_15 Prop_Avg_VitaminB6mg_15 Prop_Avg_VitaminB12_15 Prop_Avg_Iodine_15 Prop_Avg_Selenium_15

*Ice cream
svy, subpop(intake24): mean Prop_Avg_Proteing_53 Prop_Avg_Fatg_53 Prop_Avg_Sodiummg_53 Prop_Avg_Calciummg_53 Prop_Avg_Phosphorusmg_53 Prop_Avg_Ironmg_53 Prop_Avg_Zincmg_53 Prop_Avg_Chloridemg_53 Prop_Avg_VitaminA_53 Prop_Avg_Riboflavinmg_53 Prop_Avg_Niacin_53 Prop_Avg_VitaminB6mg_53 Prop_Avg_VitaminB12_53 Prop_Avg_Iodine_53 Prop_Avg_Selenium_53 /*none contributed >=5%*/

*Butter
svy, subpop(intake24): mean Prop_Avg_Proteing_17 Prop_Avg_Fatg_17 Prop_Avg_Sodiummg_17 Prop_Avg_Calciummg_17 Prop_Avg_Phosphorusmg_17 Prop_Avg_Ironmg_17 Prop_Avg_Zincmg_17 Prop_Avg_Chloridemg_17 Prop_Avg_VitaminA_17 Prop_Avg_Riboflavinmg_17 Prop_Avg_Niacin_17 Prop_Avg_VitaminB6mg_17 Prop_Avg_VitaminB12_17 Prop_Avg_Iodine_17 Prop_Avg_Selenium_17 /*none contributed >=5%*/

***THOSE ABOVE 5%***
*Whole milk
svy, subpop(intake24): mean Prop_Avg_Iodine_10

*Semi-skimmed milk
svy, subpop(intake24): mean Prop_Avg_Calciummg_11 Prop_Avg_Phosphorusmg_11 Prop_Avg_Riboflavinmg_11 Prop_Avg_VitaminB6mg_11 Prop_Avg_VitaminB12_11 Prop_Avg_Iodine_11 

*Other milk and cream
svy, subpop(intake24): mean Prop_Avg_Calciummg_13 Prop_Avg_Riboflavinmg_13 Prop_Avg_VitaminB12_13 Prop_Avg_Iodine_13

*Cheese
svy, subpop(intake24): mean Prop_Avg_Calciummg_14 Prop_Avg_VitaminA_14 Prop_Avg_VitaminB12_14

*Yogurt, fromage, dessert
svy, subpop(intake24): mean Prop_Avg_Iodine_15 



*********
*********
*FIGURES
*********
*********

*FIGURE 1
graph bar (mean) Prop_Avg_Day_Beef Prop_Avg_Day_Lamb Prop_Avg_Day_Pork Prop_Avg_Day_Poultry Prop_Avg_Day_Game [aweight=SHeS_Intake24_wt_sc], over(age_cat, relabel(1 "16-24y" 2 "25-34y" 3 "35-44y" 4 "45-54y" 5 "55-64y" 6 "65-74y" 7 "75y+") label(labsize(*1.2))) legend(size(*1.2) cols(3)) stack blabel(bar,pos(center) color(white) size(medium) format(%9.0f)) yvaroptions(relabel(1 "Beef" 2 "Lamb" 3 "Pork" 4 "Poultry" 5 "Game")) bar(1,color(18 67 109)) bar(2,color(40 161 151)) bar(3, color(128 22 80)) bar(4,color(244 106 37)) bar(5,color(61 61 61))  ylabel(, labsize(large)) ytitle("Percentage", size (medium)) 

*FIGURE 2
graph bar (mean) Avg_Day_Milk Avg_Day_Cheese Avg_Day_Yogurt Avg_Day_CreamDesserts Avg_Day_Butter [aweight=SHeS_Intake24_wt_sc], over(age_cat, relabel(1 "16-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "≥75") label(labsize(large))) legend(size(*1.2) cols(3)) stack blabel(bar,pos(center) color(white) size(vsmall) format(%9.0f)) yvaroptions(relabel(1 "Milk" 2 "Cheese" 3 "Yogurt" 4 "Cream & desserts" 5 "Butter")) bar(1,color(18 67 109)) bar(2,color(40 161 151)) bar(3, color(128 22 80)) bar(4,color(244 106 37)) bar(5,color(61 61 61)) ytitle("Grams/day", size (medium)) b1title("Age group (years)")


*Export values for Figures 3, 4 and 5 to be created in R

*FIGURE 3
matrix avgmeat = J(16, 2, .)
local r=2

foreach var of varlist Prop_Avg_Proteing_FC5 Prop_Avg_Fatg_FC5 Prop_Avg_Calciummg_FC5 Prop_Avg_Chloridemg_FC5 Prop_Avg_Iodine_FC5 Prop_Avg_Ironmg_FC5 Prop_Avg_Phosphorusmg_FC5 Prop_Avg_Selenium_FC5 Prop_Avg_Sodiummg_FC5 Prop_Avg_Zincmg_FC5 Prop_Avg_VitaminA_FC5 Prop_Avg_Riboflavinmg_FC5 Prop_Avg_Niacin_FC5 Prop_Avg_VitaminB6mg_FC5 Prop_Avg_VitaminB12_FC5 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		
		local r=`r'+1

}

matrix avgmilk = J(16, 2, .)
local r=2

foreach var of varlist Prop_Avg_Proteing_FC2 Prop_Avg_Fatg_FC2 Prop_Avg_Calciummg_FC2 Prop_Avg_Chloridemg_FC2 Prop_Avg_Iodine_FC2 Prop_Avg_Ironmg_FC2 Prop_Avg_Phosphorusmg_FC2 Prop_Avg_Selenium_FC2 Prop_Avg_Sodiummg_FC2 Prop_Avg_Zincmg_FC2 Prop_Avg_VitaminA_FC2 Prop_Avg_Riboflavinmg_FC2 Prop_Avg_Niacin_FC2 Prop_Avg_VitaminB6mg_FC2 Prop_Avg_VitaminB12_FC2 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgmilk[`r',2]=r(mean) 
		
		local r=`r'+1

}

*FIGURE 4
*Manufactured chicken
matrix avgchickenman = J(8, 2, .)
local r=2

foreach var of varlist Prop_Avg_Proteing_27A Prop_Avg_Phosphorusmg_27A Prop_Avg_Selenium_27A Prop_Avg_Zincmg_27A Prop_Avg_Niacin_27A Prop_Avg_VitaminB6mg_27A Prop_Avg_VitaminB12_27A{
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgchickenman[`r',2]=r(mean) 
		
		local r=`r'+1

}
*Other chicken
matrix avgchickenother = J(8, 2, .)
local r=2

foreach var of varlist Prop_Avg_Proteing_27B Prop_Avg_Phosphorusmg_27B Prop_Avg_Selenium_27B Prop_Avg_Zincmg_27B Prop_Avg_Niacin_27B Prop_Avg_VitaminB6mg_27B Prop_Avg_VitaminB12_27B{
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgchickenother[`r',2]=r(mean) 
		
		local r=`r'+1

}
*Manufactured beef
matrix avgbeefman = J(8, 2, .)
local r=2

foreach var of varlist Prop_Avg_Proteing_23A Prop_Avg_Phosphorusmg_23A Prop_Avg_Selenium_23A Prop_Avg_Zincmg_23A Prop_Avg_Niacin_23A Prop_Avg_VitaminB6mg_23A Prop_Avg_VitaminB12_23A{
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgbeefman[`r',2]=r(mean) 
		
		local r=`r'+1

}
*Other beef
matrix avgbeefother = J(8, 2, .)
local r=2

foreach var of varlist Prop_Avg_Proteing_23B Prop_Avg_Phosphorusmg_23B Prop_Avg_Selenium_23B Prop_Avg_Zincmg_23B Prop_Avg_Niacin_23B Prop_Avg_VitaminB6mg_23B Prop_Avg_VitaminB12_23B{
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgbeefother[`r',2]=r(mean) 
		
		local r=`r'+1

}

*FIGURE 5
*Whole milk
matrix avgwholemilk = J(9, 2, .)
local r=2

foreach var of varlist Prop_Avg_Calciummg_10 Prop_Avg_Iodine_10 Prop_Avg_Phosphorusmg_10 Prop_Avg_VitaminA_10 Prop_Avg_Riboflavinmg_10 Prop_Avg_VitaminB6mg_10 Prop_Avg_VitaminB12_10 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgwholemilk[`r',2]=r(mean) 
		
		local r=`r'+1

}
*Semi skimmed milk
matrix avgsemimilk = J(9, 3, .)
local r=2

foreach var of varlist Prop_Avg_Calciummg_11 Prop_Avg_Iodine_11 Prop_Avg_Phosphorusmg_11 Prop_Avg_VitaminA_11 Prop_Avg_Riboflavinmg_11 Prop_Avg_VitaminB6mg_11 Prop_Avg_VitaminB12_11 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgsemimilk[`r',3]=r(mean) 
		
		local r=`r'+1

}
*Other milk
matrix avgothermilk = J(9, 4, .)
local r=2

foreach var of varlist Prop_Avg_Calciummg_13 Prop_Avg_Iodine_13 Prop_Avg_Phosphorusmg_13 Prop_Avg_VitaminA_13 Prop_Avg_Riboflavinmg_13 Prop_Avg_VitaminB6mg_13 Prop_Avg_VitaminB12_13 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgothermilk[`r',4]=r(mean) 
		
		local r=`r'+1

}
*Cheese
matrix avgcheese = J(9, 5, .)
local r=2

foreach var of varlist Prop_Avg_Calciummg_14 Prop_Avg_Iodine_14 Prop_Avg_Phosphorusmg_14 Prop_Avg_VitaminA_14 Prop_Avg_Riboflavinmg_14 Prop_Avg_VitaminB6mg_14 Prop_Avg_VitaminB12_14 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgcheese[`r',5]=r(mean) 
		
		local r=`r'+1

}
*Yogurt, fromage frais and dairy desserts
matrix avgyogurt = J(9, 6, .)
local r=2

foreach var of varlist Prop_Avg_Calciummg_15 Prop_Avg_Iodine_15 Prop_Avg_Phosphorusmg_15 Prop_Avg_VitaminA_15 Prop_Avg_Riboflavinmg_15 Prop_Avg_VitaminB6mg_15 Prop_Avg_VitaminB12_15 {
	
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgyogurt[`r',6]=r(mean) 
		
		local r=`r'+1

}

