

************************************************************************************
*Manuscript: "Meat and milk product consumption in Scottish adults: Insights from a national survey"

*Export results to Excel do-file for the manuscript 
************************************************************************************


*****************
*Clear settings
*****************
clear all
clear matrix
macro drop _all
graph drop _all


*************************************************************
*Assign values using global macros for file location and date
*************************************************************

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


/*===================================================================================
AVERAGE DAILY INTAKE OF NUTRIENTS, per capita
====================================================================================*/

matrix avgnutrient = J(400, 8, .)
local r=2

quietly foreach var of varlist Avg_Day_Energykcal Avg_Day_Proteing Avg_Day_Fatg Avg_Day_Iodine Avg_Day_Calciummg Avg_Day_Chloridemg Avg_Day_Ironmg Avg_Day_Phosphorusmg Avg_Day_Selenium Avg_Day_Sodiummg Avg_Day_Zincmg Avg_Day_VitaminA Avg_Day_Riboflavinmg Avg_Day_Niacin Avg_Day_VitaminB6mg Avg_Day_VitaminB12 {
			
		*overall
		sum `var'
		matrix avgnutrient[`r',1]=r(N) 
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgnutrient[`r',2]=r(mean) 
		matrix avgnutrient[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc], p(2.5, 50, 97.5)
		matrix avgnutrient[`r',3]=r(r2) 
		matrix avgnutrient[`r',5]=r(r1) 
		matrix avgnutrient[`r',6]=r(r3) 
		
		*by sex
		*female
		sum `var' if Sex==2 
		matrix avgnutrient[`r'+17,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+17,3]=r(r2) 
		matrix avgnutrient[`r'+17,5]=r(r1) 
		matrix avgnutrient[`r'+17,6]=r(r3) 
	
		*male
		sum `var' if Sex==1 
		matrix avgnutrient[`r'+34,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+34,3]=r(r2) 
		matrix avgnutrient[`r'+34,5]=r(r1) 
		matrix avgnutrient[`r'+34,6]=r(r3)
 		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix avgnutrient[`r'+17,2]=r(mean)[1,2] 
		matrix avgnutrient[`r'+17,4]=r(sd)[1,2]
		
		matrix avgnutrient[`r'+34,2]=r(mean)[1,1] 
		matrix avgnutrient[`r'+34,4]=r(sd)[1,1]
	
		*by age
		*16-24
		sum `var' if age_cat==1 
		matrix avgnutrient[`r'+51,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+51,3]=r(r2) 
		matrix avgnutrient[`r'+51,5]=r(r1) 
		matrix avgnutrient[`r'+51,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2
		matrix avgnutrient[`r'+68,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+68,3]=r(r2) 
		matrix avgnutrient[`r'+68,5]=r(r1) 
		matrix avgnutrient[`r'+68,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3
		matrix avgnutrient[`r'+85,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+85,3]=r(r2) 
		matrix avgnutrient[`r'+85,5]=r(r1) 
		matrix avgnutrient[`r'+85,6]=r(r3)	
			
 		*45-54
		sum `var' if age_cat==4
		matrix avgnutrient[`r'+102,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+102,3]=r(r2) 
		matrix avgnutrient[`r'+102,5]=r(r1) 
		matrix avgnutrient[`r'+102,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5
		matrix avgnutrient[`r'+119,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+119,3]=r(r2) 
		matrix avgnutrient[`r'+119,5]=r(r1) 
		matrix avgnutrient[`r'+119,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6
		matrix avgnutrient[`r'+136,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+136,3]=r(r2) 
		matrix avgnutrient[`r'+136,5]=r(r1) 
		matrix avgnutrient[`r'+136,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7
		matrix avgnutrient[`r'+153,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+153,3]=r(r2) 
		matrix avgnutrient[`r'+153,5]=r(r1) 
		matrix avgnutrient[`r'+153,6]=r(r3)	
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix avgnutrient[`r'+51,2]=r(mean)[1,1] 
		matrix avgnutrient[`r'+51,4]=r(sd)[1,1] 
		matrix avgnutrient[`r'+68,2]=r(mean)[1,2] 
		matrix avgnutrient[`r'+68,4]=r(sd)[1,2] 
		matrix avgnutrient[`r'+85,2]=r(mean)[1,3] 
		matrix avgnutrient[`r'+85,4]=r(sd)[1,3]	
		matrix avgnutrient[`r'+102,2]=r(mean)[1,4] 
		matrix avgnutrient[`r'+102,4]=r(sd)[1,4]	
		matrix avgnutrient[`r'+119,2]=r(mean)[1,5] 
		matrix avgnutrient[`r'+119,4]=r(sd)[1,5]	
		matrix avgnutrient[`r'+136,2]=r(mean)[1,6] 
		matrix avgnutrient[`r'+136,4]=r(sd)[1,6]	
		matrix avgnutrient[`r'+153,2]=r(mean)[1,7] 
		matrix avgnutrient[`r'+153,4]=r(sd)[1,7]
		
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1
		matrix avgnutrient[`r'+170,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+170,3]=r(r2) 
		matrix avgnutrient[`r'+170,5]=r(r1) 
		matrix avgnutrient[`r'+170,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2
		matrix avgnutrient[`r'+187,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+187,3]=r(r2) 
		matrix avgnutrient[`r'+187,5]=r(r1) 
		matrix avgnutrient[`r'+187,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3
		matrix avgnutrient[`r'+204,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+204,3]=r(r2) 
		matrix avgnutrient[`r'+204,5]=r(r1) 
		matrix avgnutrient[`r'+204,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4
		matrix avgnutrient[`r'+221,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+221,3]=r(r2) 
		matrix avgnutrient[`r'+221,5]=r(r1) 
		matrix avgnutrient[`r'+221,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5
		matrix avgnutrient[`r'+238,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5, p(2.5, 50, 97.5)
		matrix avgnutrient[`r'+238,3]=r(r2) 
		matrix avgnutrient[`r'+238,5]=r(r1) 
		matrix avgnutrient[`r'+238,6]=r(r3)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix avgnutrient[`r'+170,2]=r(mean)[1,1] 
		matrix avgnutrient[`r'+170,4]=r(sd)[1,1] 
		matrix avgnutrient[`r'+187,2]=r(mean)[1,2] 
		matrix avgnutrient[`r'+187,4]=r(sd)[1,2] 
		matrix avgnutrient[`r'+204,2]=r(mean)[1,3] 
		matrix avgnutrient[`r'+204,4]=r(sd)[1,3]
		matrix avgnutrient[`r'+221,2]=r(mean)[1,4] 
		matrix avgnutrient[`r'+221,4]=r(sd)[1,4]
		matrix avgnutrient[`r'+238,2]=r(mean)[1,5] 
		matrix avgnutrient[`r'+238,4]=r(sd)[1,5]	
				
		local r=`r'+1
}	

	*Export to Excel 
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Avgerage nutrient intakes") modify
	putexcel B2=matrix(avgnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"


/*================================================================
AVERAGE % CONTRIBUTIONS TO NUTRIENT INTAKES @ FOOD CATEGORY LEVEL
=================================================================*/

*PROTEIN - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Proteing_FC1- Prop_Avg_Proteing_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Protein - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*FAT - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Fatg_FC1- Prop_Avg_Fatg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Fat - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	

*IODINE - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Iodine_FC1- Prop_Avg_Iodine_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Iodine - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	

*CALCIUM - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Calciummg_FC1- Prop_Avg_Calciummg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Calcium - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
*CHLORIDE - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Chloridemg_FC1- Prop_Avg_Chloridemg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Chloride - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*IRON - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Ironmg_FC1- Prop_Avg_Ironmg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Iron - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*PHOSPHORUS - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Phosphorusmg_FC1- Prop_Avg_Phosphorusmg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Phos - food categ % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
*SELENIUM - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Selenium_FC1- Prop_Avg_Selenium_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Selenium - food category % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*SODIUM - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Sodiummg_FC1- Prop_Avg_Sodiummg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Sodium - food cat % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*ZINC - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Zincmg_FC1- Prop_Avg_Zincmg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Zinc - food cat % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
*VITAMIN A - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_VitaminA_FC1- Prop_Avg_VitaminA_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Vit A - food cat % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*RIBOFLAVIN - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Riboflavinmg_FC1- Prop_Avg_Riboflavinmg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Ribo - food cate % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	

*NIACIN - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_Niacin_FC1- Prop_Avg_Niacin_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Niacin - food cat % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*VITAMIN B6- Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_VitaminB6mg_FC1- Prop_Avg_VitaminB6mg_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Vit B6 - food cat % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
*VITAMIN B12 - Food category level
matrix propnutrient = J(620, 4, .)
local r=2

quietly foreach var of varlist Prop_Avg_VitaminB12_FC1- Prop_Avg_VitaminB12_FC18 {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+38,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+19,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+19,3]=r(sd)[1,2]
		matrix propnutrient[`r'+38,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+171,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+57,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+57,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+76,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+76,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+95,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+95,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+114,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+114,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+133,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+133,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+152,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+152,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+171,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+171,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+266,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+190,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+190,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+209,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+209,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+228,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+228,3]=r(sd)[1,3]
		matrix propnutrient[`r'+247,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+247,3]=r(sd)[1,4]
		matrix propnutrient[`r'+266,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+266,3]=r(sd)[1,5]	
				local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Vit B12 - food cat % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	

/*=================================================================
AVERAGE % CONTRIBUTIONS TO NUTRIENT INTAKES @ MAIN FOOD GROUP LEVEL
15 KEY NUTRIENTS
==================================================================*/

*PROTEIN - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Proteing_1- Prop_Avg_Proteing_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Protein - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
*FAT - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Fatg_1- Prop_Avg_Fatg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Fat - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
*IODINE - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Iodine_1- Prop_Avg_Iodine_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Iodine - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
*CALCIUM - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Calciummg_1- Prop_Avg_Calciummg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Calcium - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


*CHLORIDE - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Chloridemg_1- Prop_Avg_Chloridemg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Chloride - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


*IRON - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Ironmg_1- Prop_Avg_Ironmg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Iron - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


*PHOSPHORUS - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Phosphorusmg_1- Prop_Avg_Phosphorusmg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Phosph - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

*SELENIUM - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Selenium_1- Prop_Avg_Selenium_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Selenium - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


*SODIUM - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Sodiummg_1- Prop_Avg_Sodiummg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Sodium - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

*ZINC - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Zincmg_1- Prop_Avg_Zincmg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Zinc - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

*VITAMIN A - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_VitaminA_1- Prop_Avg_VitaminA_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("VitaminA - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

*RIBOFLAVIN - main food group level
matrix propnutrient = J(2500, 4, .)
local r=2

	quietly foreach var of varlist Prop_Avg_Riboflavinmg_1- Prop_Avg_Riboflavinmg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Ribo - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


*NIACIN - main food group level
	matrix propnutrient = J(2500, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Niacin_1- Prop_Avg_Niacin_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Niacin - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

*VITAMIN B6 - main food group level
	matrix propnutrient = J(2500, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_VitaminB6mg_1- Prop_Avg_VitaminB6mg_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("VitaminB6 - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

*VITMAIN b12 - main food group level
	matrix propnutrient = J(2500, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_VitaminB12_1- Prop_Avg_VitaminB12_66 {
						
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+130,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+65,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+65,3]=r(sd)[1,2]
		matrix propnutrient[`r'+130,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+585,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+195,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+195,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+260,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+260,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+325,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+325,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+390,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+390,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+455,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+455,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+520,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+520,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+585,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+585,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+910,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+650,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+650,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+715,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+715,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+780,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+780,3]=r(sd)[1,3]
		matrix propnutrient[`r'+845,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+845,3]=r(sd)[1,4]
		matrix propnutrient[`r'+910,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

	*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Vit B12 - MFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
/*================================================================
AVERAGE % CONTRIBUTIONS TO NUTRIENT INTAKES @ SUB FOOD GROUP LEVEL
17 KEY NUTRIENTS
==================================================================*/

	
**PROTEIN - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Proteing_10R- Prop_Avg_Proteing_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Protein - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


**FAT - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Fatg_10R- Prop_Avg_Fatg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Fat - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


**IODINE - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Iodine_10R- Prop_Avg_Iodine_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Iodine - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

**CALCIUM - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Calciummg_10R- Prop_Avg_Calciummg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Calcium - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
**CHLORIDE - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Chloridemg_10R- Prop_Avg_Chloridemg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Chloride - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
**IRON - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Ironmg_10R- Prop_Avg_Ironmg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Iron - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

**PHOSPHORUS - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Phosphorusmg_10R- Prop_Avg_Phosphorusmg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Phospho - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

**SELENIUM - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Selenium_10R- Prop_Avg_Selenium_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Selenium - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


**SODIUM - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Sodiummg_10R- Prop_Avg_Sodiummg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Sodium - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

**ZINC - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Zincmg_10R- Prop_Avg_Zincmg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Zinc - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
**VITAMIN A - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_VitaminA_10R- Prop_Avg_VitaminA_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("VitaminA - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

**RIBOFLAVIN - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Riboflavinmg_10R- Prop_Avg_Riboflavinmg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Riboflavin - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


**NIACIN - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_Niacin_10R- Prop_Avg_Niacin_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Niacin - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
**VITAMIN B6 - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_VitaminB6mg_10R- Prop_Avg_VitaminB6mg_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("VitaminB6 - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

**VITAMIN B12 - sub food group
	matrix propnutrient = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_VitaminB12_10R- Prop_Avg_VitaminB12_9H {
			
		*overall		
		sum `var'
		matrix propnutrient[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix propnutrient[`r',2]=r(mean)
		matrix propnutrient[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 
		matrix propnutrient[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 
		matrix propnutrient[`r'+290,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix propnutrient[`r'+145,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+145,3]=r(sd)[1,2]
		matrix propnutrient[`r'+290,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 
		matrix propnutrient[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 
		matrix propnutrient[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 
		matrix propnutrient[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 
		matrix propnutrient[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5
		matrix propnutrient[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 
		matrix propnutrient[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 
		matrix propnutrient[`r'+1305,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix propnutrient[`r'+435,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+435,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+580,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+580,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+725,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+725,3]=r(sd)[1,3]	
		matrix propnutrient[`r'+870,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+870,3]=r(sd)[1,4]	
		matrix propnutrient[`r'+1015,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+1015,3]=r(sd)[1,5]	
		matrix propnutrient[`r'+1160,2]=r(mean)[1,6] 
		matrix propnutrient[`r'+1160,3]=r(sd)[1,6]	
		matrix propnutrient[`r'+1305,2]=r(mean)[1,7] 
		matrix propnutrient[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 
		matrix propnutrient[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 
		matrix propnutrient[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 
		matrix propnutrient[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 
		matrix propnutrient[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 
		matrix propnutrient[`r'+2030,1]=r(N)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		matrix propnutrient[`r'+1450,2]=r(mean)[1,1] 
		matrix propnutrient[`r'+1450,3]=r(sd)[1,1] 
		matrix propnutrient[`r'+1595,2]=r(mean)[1,2] 
		matrix propnutrient[`r'+1595,3]=r(sd)[1,2] 
		matrix propnutrient[`r'+1740,2]=r(mean)[1,3] 
		matrix propnutrient[`r'+1740,3]=r(sd)[1,3]
		matrix propnutrient[`r'+1885,2]=r(mean)[1,4] 
		matrix propnutrient[`r'+1885,3]=r(sd)[1,4]
		matrix propnutrient[`r'+2030,2]=r(mean)[1,5] 
		matrix propnutrient[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\Nutrient Intakes_key nutrients.xlsx", sheet("Vitamin B12 - SFG % cont") modify
	putexcel B2=matrix(propnutrient)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	

/*========================================
AVERAGE DAILY INTAKES OF MEAT, per capita
*Meat subtypes and animal types
=========================================*/
	
**MEAT SUBTYPES (red vs white vs processed)
	matrix avgmeat = J(170, 6, .) 	
	local r=2

	quietly foreach var of varlist Avg_Day_TotalMeat Avg_Day_RedMeat Avg_Day_ProcessedMeat Avg_Day_WhiteMeat {
			
		*overall
		sum `var'
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc], p(2.5, 50, 97.5)
		matrix avgmeat[`r',3]=r(r2)
		matrix avgmeat[`r',5]=r(r1)
		matrix avgmeat[`r',6]=r(r3)
		
		*by sex
		*female
		sum `var' if Sex==2 
		matrix avgmeat[`r'+5,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+5,3]=r(r2) 
		matrix avgmeat[`r'+5,5]=r(r1) 
		matrix avgmeat[`r'+5,6]=r(r3) 
	
		*male
		sum `var' if Sex==1 
		matrix avgmeat[`r'+10,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+10,3]=r(r2) 
		matrix avgmeat[`r'+10,5]=r(r1) 
		matrix avgmeat[`r'+10,6]=r(r3)
 		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix avgmeat[`r'+5,2]=r(mean)[1,2]
		matrix avgmeat[`r'+5,4]=r(sd)[1,2]
		
		matrix avgmeat[`r'+10,2]=r(mean)[1,1]
		matrix avgmeat[`r'+10,4]=r(sd)[1,1]

				
		*by age
		*16-24
		sum `var' if age_cat==1 
		matrix avgmeat[`r'+15,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+15,3]=r(r2) 
		matrix avgmeat[`r'+15,5]=r(r1) 
		matrix avgmeat[`r'+15,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2
		matrix avgmeat[`r'+20,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+20,3]=r(r2) 
		matrix avgmeat[`r'+20,5]=r(r1) 
		matrix avgmeat[`r'+20,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3
		matrix avgmeat[`r'+25,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+25,3]=r(r2) 
		matrix avgmeat[`r'+25,5]=r(r1) 
		matrix avgmeat[`r'+25,6]=r(r3)	
			
 		*45-54
		sum `var' if age_cat==4
		matrix avgmeat[`r'+30,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+30,3]=r(r2) 
		matrix avgmeat[`r'+30,5]=r(r1) 
		matrix avgmeat[`r'+30,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5
		matrix avgmeat[`r'+35,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+35,3]=r(r2) 
		matrix avgmeat[`r'+35,5]=r(r1) 
		matrix avgmeat[`r'+35,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6
		matrix avgmeat[`r'+40,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+40,3]=r(r2) 
		matrix avgmeat[`r'+40,5]=r(r1) 
		matrix avgmeat[`r'+40,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7
		matrix avgmeat[`r'+45,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+45,3]=r(r2) 
		matrix avgmeat[`r'+45,5]=r(r1) 
		matrix avgmeat[`r'+45,6]=r(r3)	
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix avgmeat[`r'+15,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+15,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+20,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+20,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+25,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+25,4]=r(sd)[1,3]	
		matrix avgmeat[`r'+30,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+30,4]=r(sd)[1,4]	
		matrix avgmeat[`r'+35,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+35,4]=r(sd)[1,5]	
		matrix avgmeat[`r'+40,2]=r(mean)[1,6] 
		matrix avgmeat[`r'+40,4]=r(sd)[1,6]	
		matrix avgmeat[`r'+45,2]=r(mean)[1,7] 
		matrix avgmeat[`r'+45,4]=r(sd)[1,7]
			
			
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1
		matrix avgmeat[`r'+50,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+50,3]=r(r2) 
		matrix avgmeat[`r'+50,5]=r(r1) 
		matrix avgmeat[`r'+50,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2
		matrix avgmeat[`r'+55,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+55,3]=r(r2) 
		matrix avgmeat[`r'+55,5]=r(r1) 
		matrix avgmeat[`r'+55,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3
		matrix avgmeat[`r'+60,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+60,3]=r(r2) 
		matrix avgmeat[`r'+60,5]=r(r1) 
		matrix avgmeat[`r'+60,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4
		matrix avgmeat[`r'+65,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+65,3]=r(r2) 
		matrix avgmeat[`r'+65,5]=r(r1) 
		matrix avgmeat[`r'+65,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5
		matrix avgmeat[`r'+70,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+70,3]=r(r2) 
		matrix avgmeat[`r'+70,5]=r(r1) 
		matrix avgmeat[`r'+70,6]=r(r3)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgmeat[`r'+50,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+50,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+55,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+55,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+60,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+60,4]=r(sd)[1,3]
		matrix avgmeat[`r'+65,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+65,4]=r(sd)[1,4]
		matrix avgmeat[`r'+70,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+70,4]=r(sd)[1,5]	
		
		local r=`r'+1	
}
	*Export to Excel 
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Average meat intake") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"

	
	
**MEAT ANIMAL TYPES (beef vs lamb vs pork vs game vs poultry)

	matrix avgmeat = J(200, 6, .) 	
	local r=2

	quietly foreach var of varlist Avg_Day_Beef Avg_Day_Lamb Avg_Day_Pork Avg_Day_Poultry Avg_Day_Game {
			
		*overall
		sum `var'
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc], p(2.5, 50, 97.5)
		matrix avgmeat[`r',3]=r(r2)
		matrix avgmeat[`r',5]=r(r1)
		matrix avgmeat[`r',6]=r(r3)
		
		*by sex
		*female
		sum `var' if Sex==2 
		matrix avgmeat[`r'+6,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+6,3]=r(r2) 
		matrix avgmeat[`r'+6,5]=r(r1) 
		matrix avgmeat[`r'+6,6]=r(r3) 
	
		*male
		sum `var' if Sex==1 
		matrix avgmeat[`r'+12,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+12,3]=r(r2) 
		matrix avgmeat[`r'+12,5]=r(r1) 
		matrix avgmeat[`r'+12,6]=r(r3)
 		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix avgmeat[`r'+6,2]=r(mean)[1,2]
		matrix avgmeat[`r'+6,4]=r(sd)[1,2]
		
		matrix avgmeat[`r'+12,2]=r(mean)[1,1]
		matrix avgmeat[`r'+12,4]=r(sd)[1,1]
				
		*by age
		*16-24
		sum `var' if age_cat==1 
		matrix avgmeat[`r'+18,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+18,3]=r(r2) 
		matrix avgmeat[`r'+18,5]=r(r1) 
		matrix avgmeat[`r'+18,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2
		matrix avgmeat[`r'+24,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+24,3]=r(r2) 
		matrix avgmeat[`r'+24,5]=r(r1) 
		matrix avgmeat[`r'+24,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3
		matrix avgmeat[`r'+30,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+30,3]=r(r2) 
		matrix avgmeat[`r'+30,5]=r(r1) 
		matrix avgmeat[`r'+30,6]=r(r3)	
			
 		*45-54
		sum `var' if age_cat==4
		matrix avgmeat[`r'+36,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+36,3]=r(r2) 
		matrix avgmeat[`r'+36,5]=r(r1) 
		matrix avgmeat[`r'+36,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5
		matrix avgmeat[`r'+42,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+42,3]=r(r2) 
		matrix avgmeat[`r'+42,5]=r(r1) 
		matrix avgmeat[`r'+42,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6
		matrix avgmeat[`r'+48,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+48,3]=r(r2) 
		matrix avgmeat[`r'+48,5]=r(r1) 
		matrix avgmeat[`r'+48,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7
		matrix avgmeat[`r'+54,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+54,3]=r(r2) 
		matrix avgmeat[`r'+54,5]=r(r1) 
		matrix avgmeat[`r'+54,6]=r(r3)	
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix avgmeat[`r'+18,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+18,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+24,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+24,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+30,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+30,4]=r(sd)[1,3]	
		matrix avgmeat[`r'+36,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+36,4]=r(sd)[1,4]	
		matrix avgmeat[`r'+42,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+42,4]=r(sd)[1,5]	
		matrix avgmeat[`r'+48,2]=r(mean)[1,6] 
		matrix avgmeat[`r'+48,4]=r(sd)[1,6]	
		matrix avgmeat[`r'+54,2]=r(mean)[1,7] 
		matrix avgmeat[`r'+54,4]=r(sd)[1,7]
		
	
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1
		matrix avgmeat[`r'+60,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+60,3]=r(r2) 
		matrix avgmeat[`r'+60,5]=r(r1) 
		matrix avgmeat[`r'+60,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2
		matrix avgmeat[`r'+66,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+66,3]=r(r2) 
		matrix avgmeat[`r'+66,5]=r(r1) 
		matrix avgmeat[`r'+66,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3
		matrix avgmeat[`r'+72,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+72,3]=r(r2) 
		matrix avgmeat[`r'+72,5]=r(r1) 
		matrix avgmeat[`r'+72,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4
		matrix avgmeat[`r'+78,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+78,3]=r(r2) 
		matrix avgmeat[`r'+78,5]=r(r1) 
		matrix avgmeat[`r'+78,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5
		matrix avgmeat[`r'+84,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+84,3]=r(r2) 
		matrix avgmeat[`r'+84,5]=r(r1) 
		matrix avgmeat[`r'+84,6]=r(r3)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgmeat[`r'+60,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+60,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+66,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+66,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+72,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+72,4]=r(sd)[1,3]
		matrix avgmeat[`r'+78,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+78,4]=r(sd)[1,4]
		matrix avgmeat[`r'+84,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+84,4]=r(sd)[1,5]	
				
		local r=`r'+1
}	


	*Export to Excel 
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Avg meat intake (animals)") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"
	



/*============================================ 					
AVERAGE DAILY INTAKES OF MEAT, among consumers						
*Meat subtypes and animal types
===============================================*/

**MEAT SUBTYPES - AVG INTAKES PER CONSUMER
	matrix avgmeat = J(170, 6, .) 	
	local r=2

	quietly foreach var of varlist Avg_Day_TotalMeat Avg_Day_RedMeat Avg_Day_ProcessedMeat Avg_Day_WhiteMeat {
			
		*overall
		sum `var' if MeatConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if MeatConsumer==1 , p(2.5, 50, 97.5)
		matrix avgmeat[`r',3]=r(r2)
		matrix avgmeat[`r',5]=r(r1)
		matrix avgmeat[`r',6]=r(r3)
		
		
		*by sex
		*female
		sum `var' if Sex==2 & MeatConsumer==1
		matrix avgmeat[`r'+5,1]=r(N) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+5,3]=r(r2) 
		matrix avgmeat[`r'+5,5]=r(r1) 
		matrix avgmeat[`r'+5,6]=r(r3) 
		
	
		*male
		sum `var' if Sex==1 & MeatConsumer==1
		matrix avgmeat[`r'+10,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+10,3]=r(r2) 
		matrix avgmeat[`r'+10,5]=r(r1) 
		matrix avgmeat[`r'+10,6]=r(r3)
 		
		svy, subpop(MeatConsumer): mean `var', over(Sex)
		estat sd
		matrix avgmeat[`r'+5,2]=r(mean)[1,2]
		matrix avgmeat[`r'+5,4]=r(sd)[1,2]
		
		matrix avgmeat[`r'+10,2]=r(mean)[1,1]
		matrix avgmeat[`r'+10,4]=r(sd)[1,1]
		
				
		*by age
		*16-24
		sum `var' if age_cat==1 & MeatConsumer==1
		matrix avgmeat[`r'+15,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+15,3]=r(r2) 
		matrix avgmeat[`r'+15,5]=r(r1) 
		matrix avgmeat[`r'+15,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2 & MeatConsumer==1
		matrix avgmeat[`r'+20,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+20,3]=r(r2) 
		matrix avgmeat[`r'+20,5]=r(r1) 
		matrix avgmeat[`r'+20,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3 & MeatConsumer==1
		matrix avgmeat[`r'+25,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+25,3]=r(r2) 
		matrix avgmeat[`r'+25,5]=r(r1) 
		matrix avgmeat[`r'+25,6]=r(r3)	
			
 		*45-54 
		sum `var' if age_cat==4 & MeatConsumer==1
		matrix avgmeat[`r'+30,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+30,3]=r(r2) 
		matrix avgmeat[`r'+30,5]=r(r1) 
		matrix avgmeat[`r'+30,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5 & MeatConsumer==1
		matrix avgmeat[`r'+35,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+35,3]=r(r2) 
		matrix avgmeat[`r'+35,5]=r(r1) 
		matrix avgmeat[`r'+35,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6 & MeatConsumer==1
		matrix avgmeat[`r'+40,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+40,3]=r(r2) 
		matrix avgmeat[`r'+40,5]=r(r1) 
		matrix avgmeat[`r'+40,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7 & MeatConsumer==1
		matrix avgmeat[`r'+45,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+45,3]=r(r2) 
		matrix avgmeat[`r'+45,5]=r(r1) 
		matrix avgmeat[`r'+45,6]=r(r3)	
		
		svy, subpop(MeatConsumer): mean `var', over(age_cat)
		estat sd
		matrix avgmeat[`r'+15,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+15,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+20,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+20,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+25,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+25,4]=r(sd)[1,3]	
		matrix avgmeat[`r'+30,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+30,4]=r(sd)[1,4]	
		matrix avgmeat[`r'+35,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+35,4]=r(sd)[1,5]	
		matrix avgmeat[`r'+40,2]=r(mean)[1,6] 
		matrix avgmeat[`r'+40,4]=r(sd)[1,6]	
		matrix avgmeat[`r'+45,2]=r(mean)[1,7] 
		matrix avgmeat[`r'+45,4]=r(sd)[1,7]
				
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1 & MeatConsumer==1
		matrix avgmeat[`r'+50,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+50,3]=r(r2) 
		matrix avgmeat[`r'+50,5]=r(r1) 
		matrix avgmeat[`r'+50,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2 & MeatConsumer==1
		matrix avgmeat[`r'+55,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+55,3]=r(r2) 
		matrix avgmeat[`r'+55,5]=r(r1) 
		matrix avgmeat[`r'+55,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3 & MeatConsumer==1
		matrix avgmeat[`r'+60,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+60,3]=r(r2) 
		matrix avgmeat[`r'+60,5]=r(r1) 
		matrix avgmeat[`r'+60,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4 & MeatConsumer==1
		matrix avgmeat[`r'+65,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+65,3]=r(r2) 
		matrix avgmeat[`r'+65,5]=r(r1) 
		matrix avgmeat[`r'+65,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5 & MeatConsumer==1
		matrix avgmeat[`r'+70,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+70,3]=r(r2) 
		matrix avgmeat[`r'+70,5]=r(r1) 
		matrix avgmeat[`r'+70,6]=r(r3)
		
		svy, subpop(MeatConsumer): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgmeat[`r'+50,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+50,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+55,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+55,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+60,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+60,4]=r(sd)[1,3]
		matrix avgmeat[`r'+65,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+65,4]=r(sd)[1,4]
		matrix avgmeat[`r'+70,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+70,4]=r(sd)[1,5]	
		
		
		local r=`r'+1
}	


	*Export to Excel 
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Avg meat intake (per consumer)") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"
	
	
**MEAT ANIMAL TYPES (beef vs lamb vs pork vs game vs poultry) - PER CONSUMER		

	matrix avgmeat = J(200, 6, .) 	
	local r=2

	quietly foreach var of varlist Avg_Day_Beef Avg_Day_Lamb Avg_Day_Pork Avg_Day_Poultry Avg_Day_Game {
			
		*overall
		sum `var' if MeatConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r',3]=r(r2)
		matrix avgmeat[`r',5]=r(r1)
		matrix avgmeat[`r',6]=r(r3)
		
		*by sex
		*female
		sum `var' if Sex==2 & MeatConsumer==1
		matrix avgmeat[`r'+6,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+6,3]=r(r2) 
		matrix avgmeat[`r'+6,5]=r(r1) 
		matrix avgmeat[`r'+6,6]=r(r3) 
	
		*male
		sum `var' if Sex==1 & MeatConsumer==1
		matrix avgmeat[`r'+12,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+12,3]=r(r2) 
		matrix avgmeat[`r'+12,5]=r(r1) 
		matrix avgmeat[`r'+12,6]=r(r3)
 		
		svy, subpop(MeatConsumer): mean `var', over(Sex)
		estat sd
		matrix avgmeat[`r'+6,2]=r(mean)[1,2]
		matrix avgmeat[`r'+6,4]=r(sd)[1,2]
		
		matrix avgmeat[`r'+12,2]=r(mean)[1,1]
		matrix avgmeat[`r'+12,4]=r(sd)[1,1]

				
		*by age
		*16-24
		sum `var' if age_cat==1 & MeatConsumer==1
		matrix avgmeat[`r'+18,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+18,3]=r(r2) 
		matrix avgmeat[`r'+18,5]=r(r1) 
		matrix avgmeat[`r'+18,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2 & MeatConsumer==1
		matrix avgmeat[`r'+24,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+24,3]=r(r2) 
		matrix avgmeat[`r'+24,5]=r(r1) 
		matrix avgmeat[`r'+24,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3 & MeatConsumer==1
		matrix avgmeat[`r'+30,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+30,3]=r(r2) 
		matrix avgmeat[`r'+30,5]=r(r1) 
		matrix avgmeat[`r'+30,6]=r(r3)	
			
 		*45-54
		sum `var' if age_cat==4 & MeatConsumer==1
		matrix avgmeat[`r'+36,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+36,3]=r(r2) 
		matrix avgmeat[`r'+36,5]=r(r1) 
		matrix avgmeat[`r'+36,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5 & MeatConsumer==1
		matrix avgmeat[`r'+42,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+42,3]=r(r2) 
		matrix avgmeat[`r'+42,5]=r(r1) 
		matrix avgmeat[`r'+42,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6 & MeatConsumer==1
		matrix avgmeat[`r'+48,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+48,3]=r(r2) 
		matrix avgmeat[`r'+48,5]=r(r1) 
		matrix avgmeat[`r'+48,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7 & MeatConsumer==1
		matrix avgmeat[`r'+54,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+54,3]=r(r2) 
		matrix avgmeat[`r'+54,5]=r(r1) 
		matrix avgmeat[`r'+54,6]=r(r3)	
		
		svy, subpop(MeatConsumer): mean `var', over(age_cat)
		estat sd
		matrix avgmeat[`r'+18,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+18,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+24,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+24,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+30,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+30,4]=r(sd)[1,3]	
		matrix avgmeat[`r'+36,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+36,4]=r(sd)[1,4]	
		matrix avgmeat[`r'+42,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+42,4]=r(sd)[1,5]	
		matrix avgmeat[`r'+48,2]=r(mean)[1,6] 
		matrix avgmeat[`r'+48,4]=r(sd)[1,6]	
		matrix avgmeat[`r'+54,2]=r(mean)[1,7] 
		matrix avgmeat[`r'+54,4]=r(sd)[1,7]
				
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1 & MeatConsumer==1
		matrix avgmeat[`r'+60,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+60,3]=r(r2) 
		matrix avgmeat[`r'+60,5]=r(r1) 
		matrix avgmeat[`r'+60,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2 & MeatConsumer==1
		matrix avgmeat[`r'+66,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+66,3]=r(r2) 
		matrix avgmeat[`r'+66,5]=r(r1) 
		matrix avgmeat[`r'+66,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3 & MeatConsumer==1
		matrix avgmeat[`r'+72,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+72,3]=r(r2) 
		matrix avgmeat[`r'+72,5]=r(r1) 
		matrix avgmeat[`r'+72,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4 & MeatConsumer==1
		matrix avgmeat[`r'+60,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+60,3]=r(r2) 
		matrix avgmeat[`r'+60,5]=r(r1) 
		matrix avgmeat[`r'+60,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5 & MeatConsumer==1
		matrix avgmeat[`r'+66,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5 & MeatConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+66,3]=r(r2) 
		matrix avgmeat[`r'+66,5]=r(r1) 
		matrix avgmeat[`r'+66,6]=r(r3)
		
		svy, subpop(MeatConsumer): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgmeat[`r'+60,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+60,4]=r(sd)[1,1] 
		matrix avgmeat[`r'+66,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+66,4]=r(sd)[1,2] 
		matrix avgmeat[`r'+72,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+72,4]=r(sd)[1,3]
		matrix avgmeat[`r'+60,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+60,4]=r(sd)[1,4]
		matrix avgmeat[`r'+66,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+66,4]=r(sd)[1,5]	
		
		
		local r=`r'+1
}	


	*Export to Excel 
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Avg intake (animals), cons") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"


/*====================================
AVERAGE % CONTRIBUTIONS TO MEAT INTAKE
*Animal type and food groups 
======================================*/

**Meat contributions - ANIMAL TYPES (beef vs lamb vs pork vs game vs poultry)		
	matrix avgmeat = J(200, 6, .) 	
	local r=2

	quietly foreach var of varlist Prop_Avg_Day_Beef Prop_Avg_Day_Lamb Prop_Avg_Day_Pork Prop_Avg_Day_Poultry Prop_Avg_Day_Game {
			
		*overall
		sum `var'
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',3]=r(sd) 
				
		*by sex
		*female
		sum `var' if Sex==2 & MeatConsumer==1
		matrix avgmeat[`r'+6,1]=r(N) 

		*male
		sum `var' if Sex==1 & MeatConsumer==1
		matrix avgmeat[`r'+12,1]=r(N)
		 		
		svy, subpop(MeatConsumer): mean `var', over(Sex)
		estat sd
		matrix avgmeat[`r'+6,2]=r(mean)[1,2]
		matrix avgmeat[`r'+6,3]=r(sd)[1,2]
		
		matrix avgmeat[`r'+12,2]=r(mean)[1,1]
		matrix avgmeat[`r'+12,3]=r(sd)[1,1]

				
		*by age
		*16-24
		sum `var' if age_cat==1 & MeatConsumer==1
		matrix avgmeat[`r'+18,1]=r(N) 

		*25-34
		sum `var' if age_cat==2 & MeatConsumer==1
		matrix avgmeat[`r'+24,1]=r(N)
				
 		*35-44
		sum `var' if age_cat==3 & MeatConsumer==1
		matrix avgmeat[`r'+30,1]=r(N)
			
 		*45-54
		sum `var' if age_cat==4 & MeatConsumer==1
		matrix avgmeat[`r'+36,1]=r(N)
		
 		*55-64
		sum `var' if age_cat==5 & MeatConsumer==1
		matrix avgmeat[`r'+42,1]=r(N)
		
 		*65-74
		sum `var' if age_cat==6 & MeatConsumer==1
		matrix avgmeat[`r'+48,1]=r(N)
		
 		*75+
		sum `var' if age_cat==7 & MeatConsumer==1
		matrix avgmeat[`r'+54,1]=r(N)

		svy, subpop(MeatConsumer): mean `var', over(age_cat)
		estat sd
		matrix avgmeat[`r'+18,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+18,3]=r(sd)[1,1] 
		matrix avgmeat[`r'+24,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+24,3]=r(sd)[1,2] 
		matrix avgmeat[`r'+30,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+30,3]=r(sd)[1,3]	
		matrix avgmeat[`r'+36,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+36,3]=r(sd)[1,4]	
		matrix avgmeat[`r'+42,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+42,3]=r(sd)[1,5]	
		matrix avgmeat[`r'+48,2]=r(mean)[1,6] 
		matrix avgmeat[`r'+48,3]=r(sd)[1,6]	
		matrix avgmeat[`r'+54,2]=r(mean)[1,7] 
		matrix avgmeat[`r'+54,3]=r(sd)[1,7]
				
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1 & MeatConsumer==1
		matrix avgmeat[`r'+60,1]=r(N)
		
		*SIMD 2
		sum `var' if simd20_sga==2 & MeatConsumer==1
		matrix avgmeat[`r'+66,1]=r(N)
		
		*SIMD 3
		sum `var' if simd20_sga==3 & MeatConsumer==1
		matrix avgmeat[`r'+72,1]=r(N)
		
		*SIMD 4
		sum `var' if simd20_sga==4 & MeatConsumer==1
		matrix avgmeat[`r'+78,1]=r(N)
		
		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5 & MeatConsumer==1
		matrix avgmeat[`r'+84,1]=r(N)
				
		svy, subpop(MeatConsumer): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgmeat[`r'+60,2]=r(mean)[1,1] 
		matrix avgmeat[`r'+60,3]=r(sd)[1,1] 
		matrix avgmeat[`r'+66,2]=r(mean)[1,2] 
		matrix avgmeat[`r'+66,3]=r(sd)[1,2] 
		matrix avgmeat[`r'+72,2]=r(mean)[1,3] 
		matrix avgmeat[`r'+72,3]=r(sd)[1,3]
		matrix avgmeat[`r'+78,2]=r(mean)[1,4] 
		matrix avgmeat[`r'+78,3]=r(sd)[1,4]
		matrix avgmeat[`r'+84,2]=r(mean)[1,5] 
		matrix avgmeat[`r'+84,3]=r(sd)[1,5]	
		
		
		local r=`r'+1
}	


* Export to Excel 
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Animal type % cont") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 
	


**Meat contributions - FOOD CATEGORIES
	
	matrix propmeatFC = J(620, 4, .)
	local r=2

quietly foreach var of varlist Prop_Avg_totmeatg_FC1- Prop_Avg_totmeatg_FC18 {
			
		*overall		
		sum `var'
		matrix propmeatFC[`r',1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var'
		estat sd
		matrix propmeatFC[`r',2]=r(mean)
		matrix propmeatFC[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 & MeatConsumer==1
		matrix propmeatFC[`r'+19,1]=r(N) 
		
		sum `var' if Sex==1  & MeatConsumer==1
		matrix propmeatFC[`r'+38,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(Sex)
		estat sd
		matrix propmeatFC[`r'+19,2]=r(mean)[1,2] 
		matrix propmeatFC[`r'+19,3]=r(sd)[1,2]
		matrix propmeatFC[`r'+38,2]=r(mean)[1,1] 
		matrix propmeatFC[`r'+38,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1  & MeatConsumer==1
		matrix propmeatFC[`r'+57,1]=r(N)
		
		sum `var' if age_cat==2  & MeatConsumer==1
		matrix propmeatFC[`r'+76,1]=r(N)
		
		sum `var' if age_cat==3  & MeatConsumer==1
		matrix propmeatFC[`r'+95,1]=r(N)
		
		sum `var' if age_cat==4  & MeatConsumer==1
		matrix propmeatFC[`r'+114,1]=r(N)
		
		sum `var' if age_cat==5 & MeatConsumer==1
		matrix propmeatFC[`r'+133,1]=r(N)
		
		sum `var' if age_cat==6  & MeatConsumer==1
		matrix propmeatFC[`r'+152,1]=r(N)
		
		sum `var' if age_cat==7  & MeatConsumer==1
		matrix propmeatFC[`r'+171,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(age_cat)
		estat sd
		matrix propmeatFC[`r'+57,2]=r(mean)[1,1] 
		matrix propmeatFC[`r'+57,3]=r(sd)[1,1] 
		matrix propmeatFC[`r'+76,2]=r(mean)[1,2] 
		matrix propmeatFC[`r'+76,3]=r(sd)[1,2] 
		matrix propmeatFC[`r'+95,2]=r(mean)[1,3] 
		matrix propmeatFC[`r'+95,3]=r(sd)[1,3]	
		matrix propmeatFC[`r'+114,2]=r(mean)[1,4] 
		matrix propmeatFC[`r'+114,3]=r(sd)[1,4]	
		matrix propmeatFC[`r'+133,2]=r(mean)[1,5] 
		matrix propmeatFC[`r'+133,3]=r(sd)[1,5]	
		matrix propmeatFC[`r'+152,2]=r(mean)[1,6] 
		matrix propmeatFC[`r'+152,3]=r(sd)[1,6]	
		matrix propmeatFC[`r'+171,2]=r(mean)[1,7] 
		matrix propmeatFC[`r'+171,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1  & MeatConsumer==1
		matrix propmeatFC[`r'+190,1]=r(N)
		
		sum `var' if simd20_sga==2  & MeatConsumer==1
		matrix propmeatFC[`r'+209,1]=r(N)
		
		sum `var' if simd20_sga==3  & MeatConsumer==1
		matrix propmeatFC[`r'+228,1]=r(N)
		
		sum `var' if simd20_sga==4  & MeatConsumer==1
		matrix propmeatFC[`r'+247,1]=r(N)
		
		sum `var' if simd20_sga==5  & MeatConsumer==1
		matrix propmeatFC[`r'+266,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(simd20_sga)
		estat sd
		matrix propmeatFC[`r'+190,2]=r(mean)[1,1] 
		matrix propmeatFC[`r'+190,3]=r(sd)[1,1] 
		matrix propmeatFC[`r'+209,2]=r(mean)[1,2] 
		matrix propmeatFC[`r'+209,3]=r(sd)[1,2] 
		matrix propmeatFC[`r'+228,2]=r(mean)[1,3] 
		matrix propmeatFC[`r'+228,3]=r(sd)[1,3]
		matrix propmeatFC[`r'+247,2]=r(mean)[1,4] 
		matrix propmeatFC[`r'+247,3]=r(sd)[1,4]
		matrix propmeatFC[`r'+266,2]=r(mean)[1,5] 
		matrix propmeatFC[`r'+266,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Food category % cont") modify
	putexcel B2=matrix(propmeatFC)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
*Meat contributions - MAIN FOOD GROUP
	matrix propmeatMFG = J(2500, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_totmeatg_1- Prop_Avg_totmeatg_66 {
			
		*overall		
		sum `var'
		matrix propmeatMFG[`r',1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var'
		estat sd
		matrix propmeatMFG[`r',2]=r(mean)
		matrix propmeatMFG[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 & MeatConsumer==1
		matrix propmeatMFG[`r'+65,1]=r(N) 
		
		sum `var' if Sex==1 & MeatConsumer==1
		matrix propmeatMFG[`r'+130,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(Sex)
		estat sd
		matrix propmeatMFG[`r'+65,2]=r(mean)[1,2] 
		matrix propmeatMFG[`r'+65,3]=r(sd)[1,2]
		matrix propmeatMFG[`r'+130,2]=r(mean)[1,1] 
		matrix propmeatMFG[`r'+130,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 & MeatConsumer==1
		matrix propmeatMFG[`r'+195,1]=r(N)
		
		sum `var' if age_cat==2 & MeatConsumer==1
		matrix propmeatMFG[`r'+260,1]=r(N)
		
		sum `var' if age_cat==3 & MeatConsumer==1
		matrix propmeatMFG[`r'+325,1]=r(N)
		
		sum `var' if age_cat==4 & MeatConsumer==1
		matrix propmeatMFG[`r'+390,1]=r(N)
		
		sum `var' if age_cat==5 & MeatConsumer==1
		matrix propmeatMFG[`r'+455,1]=r(N)
		
		sum `var' if age_cat==6 & MeatConsumer==1
		matrix propmeatMFG[`r'+520,1]=r(N)
		
		sum `var' if age_cat==7 & MeatConsumer==1
		matrix propmeatMFG[`r'+585,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(age_cat)
		estat sd
		matrix propmeatMFG[`r'+195,2]=r(mean)[1,1] 
		matrix propmeatMFG[`r'+195,3]=r(sd)[1,1] 
		matrix propmeatMFG[`r'+260,2]=r(mean)[1,2] 
		matrix propmeatMFG[`r'+260,3]=r(sd)[1,2] 
		matrix propmeatMFG[`r'+325,2]=r(mean)[1,3] 
		matrix propmeatMFG[`r'+325,3]=r(sd)[1,3]	
		matrix propmeatMFG[`r'+390,2]=r(mean)[1,4] 
		matrix propmeatMFG[`r'+390,3]=r(sd)[1,4]	
		matrix propmeatMFG[`r'+455,2]=r(mean)[1,5] 
		matrix propmeatMFG[`r'+455,3]=r(sd)[1,5]	
		matrix propmeatMFG[`r'+520,2]=r(mean)[1,6] 
		matrix propmeatMFG[`r'+520,3]=r(sd)[1,6]	
		matrix propmeatMFG[`r'+585,2]=r(mean)[1,7] 
		matrix propmeatMFG[`r'+585,3]=r(sd)[1,7]
	
		
		*By SIMD		
		sum `var' if simd20_sga==1 & MeatConsumer==1
		matrix propmeatMFG[`r'+650,1]=r(N)
		
		sum `var' if simd20_sga==2 & MeatConsumer==1
		matrix propmeatMFG[`r'+715,1]=r(N)
		
		sum `var' if simd20_sga==3 & MeatConsumer==1
		matrix propmeatMFG[`r'+780,1]=r(N)
		
		sum `var' if simd20_sga==4 & MeatConsumer==1
		matrix propmeatMFG[`r'+845,1]=r(N)
		
		sum `var' if simd20_sga==5 & MeatConsumer==1
		matrix propmeatMFG[`r'+910,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(simd20_sga)
		estat sd
		matrix propmeatMFG[`r'+650,2]=r(mean)[1,1] 
		matrix propmeatMFG[`r'+650,3]=r(sd)[1,1] 
		matrix propmeatMFG[`r'+715,2]=r(mean)[1,2] 
		matrix propmeatMFG[`r'+715,3]=r(sd)[1,2] 
		matrix propmeatMFG[`r'+780,2]=r(mean)[1,3] 
		matrix propmeatMFG[`r'+780,3]=r(sd)[1,3]
		matrix propmeatMFG[`r'+845,2]=r(mean)[1,4] 
		matrix propmeatMFG[`r'+845,3]=r(sd)[1,4]
		matrix propmeatMFG[`r'+910,2]=r(mean)[1,5] 
		matrix propmeatMFG[`r'+910,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	


*Export to Excel
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Main food group % cont") modify
	putexcel B2=matrix(propmeatMFG)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"

	
*Meat contributions - SUB FOOD GROUP
	matrix propmeatSFG = J(5100, 4, .)
	local r=2

	quietly foreach var of varlist Prop_Avg_totmeatg_10R- Prop_Avg_totmeatg_9H {
			
		*overall		
		sum `var'
		matrix propmeatSFG[`r',1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var'
		estat sd
		matrix propmeatSFG[`r',2]=r(mean)
		matrix propmeatSFG[`r',3]=r(sd)		

		*by sex
		sum `var' if Sex==2 & MeatConsumer==1
		matrix propmeatSFG[`r'+145,1]=r(N) 
		
		sum `var' if Sex==1 & MeatConsumer==1
		matrix propmeatSFG[`r'+290,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(Sex)
		estat sd
		matrix propmeatSFG[`r'+145,2]=r(mean)[1,2] 
		matrix propmeatSFG[`r'+145,3]=r(sd)[1,2]
		matrix propmeatSFG[`r'+290,2]=r(mean)[1,1] 
		matrix propmeatSFG[`r'+290,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 & MeatConsumer==1
		matrix propmeatSFG[`r'+435,1]=r(N)
		
		sum `var' if age_cat==2 & MeatConsumer==1
		matrix propmeatSFG[`r'+580,1]=r(N)
		
		sum `var' if age_cat==3 & MeatConsumer==1
		matrix propmeatSFG[`r'+725,1]=r(N)
		
		sum `var' if age_cat==4 & MeatConsumer==1
		matrix propmeatSFG[`r'+870,1]=r(N)
		
		sum `var' if age_cat==5 & MeatConsumer==1
		matrix propmeatSFG[`r'+1015,1]=r(N)
		
		sum `var' if age_cat==6 & MeatConsumer==1
		matrix propmeatSFG[`r'+1160,1]=r(N)
		
		sum `var' if age_cat==7 & MeatConsumer==1
		matrix propmeatSFG[`r'+1305,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(age_cat)
		estat sd
		matrix propmeatSFG[`r'+435,2]=r(mean)[1,1] 
		matrix propmeatSFG[`r'+435,3]=r(sd)[1,1] 
		matrix propmeatSFG[`r'+580,2]=r(mean)[1,2] 
		matrix propmeatSFG[`r'+580,3]=r(sd)[1,2] 
		matrix propmeatSFG[`r'+725,2]=r(mean)[1,3] 
		matrix propmeatSFG[`r'+725,3]=r(sd)[1,3]	
		matrix propmeatSFG[`r'+870,2]=r(mean)[1,4] 
		matrix propmeatSFG[`r'+870,3]=r(sd)[1,4]	
		matrix propmeatSFG[`r'+1015,2]=r(mean)[1,5] 
		matrix propmeatSFG[`r'+1015,3]=r(sd)[1,5]	
		matrix propmeatSFG[`r'+1160,2]=r(mean)[1,6] 
		matrix propmeatSFG[`r'+1160,3]=r(sd)[1,6]	
		matrix propmeatSFG[`r'+1305,2]=r(mean)[1,7] 
		matrix propmeatSFG[`r'+1305,3]=r(sd)[1,7]
		
		
		*By SIMD		
		sum `var' if simd20_sga==1 & MeatConsumer==1
		matrix propmeatSFG[`r'+1450,1]=r(N)
		
		sum `var' if simd20_sga==2 & MeatConsumer==1
		matrix propmeatSFG[`r'+1595,1]=r(N)
		
		sum `var' if simd20_sga==3 & MeatConsumer==1
		matrix propmeatSFG[`r'+1740,1]=r(N)
		
		sum `var' if simd20_sga==4 & MeatConsumer==1
		matrix propmeatSFG[`r'+1885,1]=r(N)
		
		sum `var' if simd20_sga==5 & MeatConsumer==1
		matrix propmeatSFG[`r'+2030,1]=r(N)
		
		svy, subpop(MeatConsumer): mean `var', over(simd20_sga)
		estat sd
		matrix propmeatSFG[`r'+1450,2]=r(mean)[1,1] 
		matrix propmeatSFG[`r'+1450,3]=r(sd)[1,1] 
		matrix propmeatSFG[`r'+1595,2]=r(mean)[1,2] 
		matrix propmeatSFG[`r'+1595,3]=r(sd)[1,2] 
		matrix propmeatSFG[`r'+1740,2]=r(mean)[1,3] 
		matrix propmeatSFG[`r'+1740,3]=r(sd)[1,3]
		matrix propmeatSFG[`r'+1885,2]=r(mean)[1,4] 
		matrix propmeatSFG[`r'+1885,3]=r(sd)[1,4]
		matrix propmeatSFG[`r'+2030,2]=r(mean)[1,5] 
		matrix propmeatSFG[`r'+2030,3]=r(sd)[1,5]	
		
		local r=`r'+1
}	

*Export to Excel
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("Sub food group % cont") modify
	putexcel B2=matrix(propmeatSFG)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"
	
	
/*============================
% CONSUMERS ACROSS MEAT TYPES
==============================*/
	matrix meatconsumers = J(160, 4, .)
	local r=2

	quietly foreach var of varlist MeatConsumer RedMeatConsumer ProcessedMeatConsumer WhiteMeatConsumer  {
			
		*overall				
		summ `var'
		matrix meatconsumers[`r',1]=r(N) /*Per capita N*/
		
		summ `var' if `var'==1
		matrix meatconsumers[`r',2]=r(N) /*Consumer N*/
		
		prop `var' [pweight=SHeS_Intake24_wt_sc]
		matrix meatconsumers[`r',3]=r(table)[1,2] /*Proportion of consumers*/
		
		
		*by sex
		*female
		sum `var' if Sex==2 
		matrix meatconsumers[`r'+5,1]=r(N) 
		
		summ `var' if Sex==2 & `var'==1
		matrix meatconsumers[`r'+5,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2
		matrix meatconsumers[`r'+5,3]=r(table)[1,2] 

		*male
		sum `var' if Sex==1 
		matrix meatconsumers[`r'+10,1]=r(N) 
		
		summ `var' if Sex==1 & `var'==1
		matrix meatconsumers[`r'+10,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1
		matrix meatconsumers[`r'+10,3]=r(table)[1,2] 


		*by age
		*16-24
		sum `var' if age_cat==1
		matrix meatconsumers[`r'+15,1]=r(N) 
		
		summ `var' if age_cat==1 & `var'==1
		matrix meatconsumers[`r'+15,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1
		matrix meatconsumers[`r'+15,3]=r(table)[1,2] 
	
		*25-34
		sum `var' if age_cat==2
		matrix meatconsumers[`r'+20,1]=r(N) 
		
		summ `var' if age_cat==2 & `var'==1
		matrix meatconsumers[`r'+20,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2
		matrix meatconsumers[`r'+20,3]=r(table)[1,2] 
		
 		*35-44
		sum `var' if age_cat==3
		matrix meatconsumers[`r'+25,1]=r(N) 
		
		summ `var' if age_cat==3 & `var'==1
		matrix meatconsumers[`r'+25,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3
		matrix meatconsumers[`r'+25,3]=r(table)[1,2] 
			
 		*45-54
		sum `var' if age_cat==4
		matrix meatconsumers[`r'+30,1]=r(N) 
		
		summ `var' if age_cat==4 & `var'==1
		matrix meatconsumers[`r'+30,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4
		matrix meatconsumers[`r'+30,3]=r(table)[1,2] 
		
 		*55-64
		sum `var' if age_cat==5
		matrix meatconsumers[`r'+35,1]=r(N) 
		
		summ `var' if age_cat==5 & `var'==1
		matrix meatconsumers[`r'+35,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5
		matrix meatconsumers[`r'+35,3]=r(table)[1,2] 
				
 		*65-74
		sum `var' if age_cat==6
		matrix meatconsumers[`r'+40,1]=r(N) 
		
		summ `var' if age_cat==6 & `var'==1
		matrix meatconsumers[`r'+40,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6
		matrix meatconsumers[`r'+40,3]=r(table)[1,2] 
					
 		*75+
		sum `var' if age_cat==7
		matrix meatconsumers[`r'+45,1]=r(N) 
		
		summ `var' if age_cat==7 & `var'==1
		matrix meatconsumers[`r'+45,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7
		matrix meatconsumers[`r'+45,3]=r(table)[1,2] 
			
		
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1
		matrix meatconsumers[`r'+50,1]=r(N) 
		
		summ `var' if simd20_sga==1 & `var'==1
		matrix meatconsumers[`r'+50,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1
		matrix meatconsumers[`r'+50,3]=r(table)[1,2] 

		*SIMD 2
		sum `var' if simd20_sga==2
		matrix meatconsumers[`r'+55,1]=r(N) 
		
		summ `var' if simd20_sga==2 & `var'==1
		matrix meatconsumers[`r'+55,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2
		matrix meatconsumers[`r'+55,3]=r(table)[1,2] 
		
		*SIMD 3
		sum `var' if simd20_sga==3
		matrix meatconsumers[`r'+60,1]=r(N) 
		
		summ `var' if simd20_sga==3 & `var'==1
		matrix meatconsumers[`r'+60,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3
		matrix meatconsumers[`r'+60,3]=r(table)[1,2] 
				
		*SIMD 4
		sum `var' if simd20_sga==4
		matrix meatconsumers[`r'+65,1]=r(N) 
		
		summ `var' if simd20_sga==4 & `var'==1
		matrix meatconsumers[`r'+65,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4
		matrix meatconsumers[`r'+65,3]=r(table)[1,2] 

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5
		matrix meatconsumers[`r'+70,1]=r(N) 
		
		summ `var' if simd20_sga==5 & `var'==1
		matrix meatconsumers[`r'+70,2]=r(N) 

		prop `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5
		matrix meatconsumers[`r'+70,3]=r(table)[1,2] 
		
				
		local r=`r'+1
}	

**Export to Excel
	putexcel set "$output\SHeS Meat Intakes_Manuscript.xlsx", sheet("% meat subtype consumers") modify
	putexcel B2=matrix(meatconsumers)
	putexcel B1="Per capita, N" 
	putexcel C1="Consumers, N"
	putexcel D1="Prop consumers" 


/*=========================================
AVERAGE DAILY INTAKES OF DAIRY, per capita
===========================================*/
		
	matrix avgdairy = J(250, 7, .)
	local r=2
	
quietly foreach var of varlist Avg_Day_TotDairy Avg_Day_Milk Avg_Day_Cheese Avg_Day_Yogurt Avg_Day_CreamDesserts Avg_Day_Butter {
	
		*overall
		sum `var'
		matrix avgdairy[`r',1]=r(N)
		
		svy, subpop(intake24): mean `var'
		estat sd
		matrix avgdairy[`r',2]=r(mean) 
		matrix avgdairy[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc], p(2.5, 50, 97.5)
		matrix avgdairy[`r',3]=r(r2)
		matrix avgdairy[`r',5]=r(r1)
		matrix avgdairy[`r',6]=r(r3)
		
		*by sex
		*female
		sum `var' if Sex==2 
		matrix avgdairy[`r'+7,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+7,3]=r(r2) 
		matrix avgdairy[`r'+7,5]=r(r1) 
		matrix avgdairy[`r'+7,6]=r(r3) 
	
		*male
		sum `var' if Sex==1 
		matrix avgdairy[`r'+14,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+14,3]=r(r2) 
		matrix avgdairy[`r'+14,5]=r(r1) 
		matrix avgdairy[`r'+14,6]=r(r3)
 		
		svy, subpop(intake24): mean `var', over(Sex)
		estat sd
		matrix avgdairy[`r'+7,2]=r(mean)[1,2]
		matrix avgdairy[`r'+7,4]=r(sd)[1,2]
		
		matrix avgdairy[`r'+14,2]=r(mean)[1,1]
		matrix avgdairy[`r'+14,4]=r(sd)[1,1]

				
		*by age
		*16-24
		sum `var' if age_cat==1 
		matrix avgdairy[`r'+21,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+21,3]=r(r2) 
		matrix avgdairy[`r'+21,5]=r(r1) 
		matrix avgdairy[`r'+21,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2
		matrix avgdairy[`r'+28,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+28,3]=r(r2) 
		matrix avgdairy[`r'+28,5]=r(r1) 
		matrix avgdairy[`r'+28,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3
		matrix avgdairy[`r'+35,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+35,3]=r(r2) 
		matrix avgdairy[`r'+35,5]=r(r1) 
		matrix avgdairy[`r'+35,6]=r(r3)	
			
 		*45-54
		sum `var' if age_cat==4
		matrix avgdairy[`r'+42,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+42,3]=r(r2) 
		matrix avgdairy[`r'+42,5]=r(r1) 
		matrix avgdairy[`r'+42,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5
		matrix avgdairy[`r'+49,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+49,3]=r(r2) 
		matrix avgdairy[`r'+49,5]=r(r1) 
		matrix avgdairy[`r'+49,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6
		matrix avgdairy[`r'+56,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+56,3]=r(r2) 
		matrix avgdairy[`r'+56,5]=r(r1) 
		matrix avgdairy[`r'+56,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7
		matrix avgdairy[`r'+63,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+63,3]=r(r2) 
		matrix avgdairy[`r'+63,5]=r(r1) 
		matrix avgdairy[`r'+63,6]=r(r3)	
		
		svy, subpop(intake24): mean `var', over(age_cat)
		estat sd
		matrix avgdairy[`r'+21,2]=r(mean)[1,1] 
		matrix avgdairy[`r'+21,4]=r(sd)[1,1] 
		matrix avgdairy[`r'+28,2]=r(mean)[1,2] 
		matrix avgdairy[`r'+28,4]=r(sd)[1,2] 
		matrix avgdairy[`r'+35,2]=r(mean)[1,3] 
		matrix avgdairy[`r'+35,4]=r(sd)[1,3]	
		matrix avgdairy[`r'+42,2]=r(mean)[1,4] 
		matrix avgdairy[`r'+42,4]=r(sd)[1,4]	
		matrix avgdairy[`r'+49,2]=r(mean)[1,5] 
		matrix avgdairy[`r'+49,4]=r(sd)[1,5]	
		matrix avgdairy[`r'+56,2]=r(mean)[1,6] 
		matrix avgdairy[`r'+56,4]=r(sd)[1,6]	
		matrix avgdairy[`r'+63,2]=r(mean)[1,7] 
		matrix avgdairy[`r'+63,4]=r(sd)[1,7]
			
				
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1
		matrix avgdairy[`r'+70,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+70,3]=r(r2) 
		matrix avgdairy[`r'+70,5]=r(r1) 
		matrix avgdairy[`r'+70,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2
		matrix avgdairy[`r'+77,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+77,3]=r(r2) 
		matrix avgdairy[`r'+77,5]=r(r1) 
		matrix avgdairy[`r'+77,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3
		matrix avgdairy[`r'+84,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+84,3]=r(r2) 
		matrix avgdairy[`r'+84,5]=r(r1) 
		matrix avgdairy[`r'+84,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4
		matrix avgdairy[`r'+91,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+91,3]=r(r2) 
		matrix avgdairy[`r'+91,5]=r(r1) 
		matrix avgdairy[`r'+91,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5
		matrix avgdairy[`r'+98,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+98,3]=r(r2) 
		matrix avgdairy[`r'+98,5]=r(r1) 
		matrix avgdairy[`r'+98,6]=r(r3)
		
		svy, subpop(intake24): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgdairy[`r'+70,2]=r(mean)[1,1] 
		matrix avgdairy[`r'+70,4]=r(sd)[1,1] 
		matrix avgdairy[`r'+77,2]=r(mean)[1,2] 
		matrix avgdairy[`r'+77,4]=r(sd)[1,2] 
		matrix avgdairy[`r'+84,2]=r(mean)[1,3] 
		matrix avgdairy[`r'+84,4]=r(sd)[1,3]
		matrix avgdairy[`r'+91,2]=r(mean)[1,4] 
		matrix avgdairy[`r'+91,4]=r(sd)[1,4]
		matrix avgdairy[`r'+98,2]=r(mean)[1,5] 
		matrix avgdairy[`r'+98,4]=r(sd)[1,5]	
				
		local r=`r'+1
}	


*4. Export to Excel 
	putexcel set "$output\SHeS Dairy Intakes_Manuscript.xlsx", sheet("Average intake, per capita") modify
	putexcel B2=matrix(avgdairy)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"


/*==============================================
AVERAGE DAILY INTAKES OF DAIRY, among consumers
===============================================*/
	
	matrix avgdairy = J(250, 7, .)
	local r=2

quietly foreach var of varlist Avg_Day_TotDairy Avg_Day_Milk Avg_Day_Cheese Avg_Day_Yogurt Avg_Day_CreamDesserts Avg_Day_Butter {
	
		*overall
		sum `var' if DairyConsumer==1
		matrix avgdairy[`r',1]=r(N)
		
		svy, subpop(DairyConsumer): mean `var'
		estat sd
		matrix avgdairy[`r',2]=r(mean) 
		matrix avgdairy[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r',3]=r(r2)
		matrix avgdairy[`r',5]=r(r1)
		matrix avgdairy[`r',6]=r(r3)
		
		*by sex
		*female
		sum `var' if Sex==2 & DairyConsumer==1
		matrix avgdairy[`r'+7,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==2 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+7,3]=r(r2) 
		matrix avgdairy[`r'+7,5]=r(r1) 
		matrix avgdairy[`r'+7,6]=r(r3) 
	
		*male
		sum `var' if Sex==1 & DairyConsumer==1
		matrix avgdairy[`r'+14,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if Sex==1 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+14,3]=r(r2) 
		matrix avgdairy[`r'+14,5]=r(r1) 
		matrix avgdairy[`r'+14,6]=r(r3)
 		
		svy, subpop(DairyConsumer): mean `var', over(Sex)
		estat sd
		matrix avgdairy[`r'+7,2]=r(mean)[1,2]
		matrix avgdairy[`r'+7,4]=r(sd)[1,2]
		
		matrix avgdairy[`r'+14,2]=r(mean)[1,1]
		matrix avgdairy[`r'+14,4]=r(sd)[1,1]

				
		*by age
		*16-24
		sum `var' if age_cat==1 & DairyConsumer==1
		matrix avgdairy[`r'+21,1]=r(N) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==1 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+21,3]=r(r2) 
		matrix avgdairy[`r'+21,5]=r(r1) 
		matrix avgdairy[`r'+21,6]=r(r3) 
		
		*25-34
		sum `var' if age_cat==2 & DairyConsumer==1
		matrix avgdairy[`r'+28,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==2 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+28,3]=r(r2) 
		matrix avgdairy[`r'+28,5]=r(r1) 
		matrix avgdairy[`r'+28,6]=r(r3)
		
 		*35-44
		sum `var' if age_cat==3 & DairyConsumer==1
		matrix avgdairy[`r'+35,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==3 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+35,3]=r(r2) 
		matrix avgdairy[`r'+35,5]=r(r1) 
		matrix avgdairy[`r'+35,6]=r(r3)	
			
 		*45-54
		sum `var' if age_cat==4 & DairyConsumer==1
		matrix avgdairy[`r'+42,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==4 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+42,3]=r(r2) 
		matrix avgdairy[`r'+42,5]=r(r1) 
		matrix avgdairy[`r'+42,6]=r(r3)
			
 		*55-64
		sum `var' if age_cat==5 & DairyConsumer==1
		matrix avgdairy[`r'+49,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==5 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+49,3]=r(r2) 
		matrix avgdairy[`r'+49,5]=r(r1) 
		matrix avgdairy[`r'+49,6]=r(r3)		
				
 		*65-74
		sum `var' if age_cat==6 & DairyConsumer==1
		matrix avgdairy[`r'+56,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==6 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+56,3]=r(r2) 
		matrix avgdairy[`r'+56,5]=r(r1) 
		matrix avgdairy[`r'+56,6]=r(r3)			
					
 		*75+
		sum `var' if age_cat==7 & DairyConsumer==1
		matrix avgdairy[`r'+63,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if age_cat==7 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+63,3]=r(r2) 
		matrix avgdairy[`r'+63,5]=r(r1) 
		matrix avgdairy[`r'+63,6]=r(r3)	
		
		svy, subpop(DairyConsumer): mean `var', over(age_cat)
		estat sd
		matrix avgdairy[`r'+21,2]=r(mean)[1,1] 
		matrix avgdairy[`r'+21,4]=r(sd)[1,1] 
		matrix avgdairy[`r'+28,2]=r(mean)[1,2] 
		matrix avgdairy[`r'+28,4]=r(sd)[1,2] 
		matrix avgdairy[`r'+35,2]=r(mean)[1,3] 
		matrix avgdairy[`r'+35,4]=r(sd)[1,3]	
		matrix avgdairy[`r'+42,2]=r(mean)[1,4] 
		matrix avgdairy[`r'+42,4]=r(sd)[1,4]	
		matrix avgdairy[`r'+49,2]=r(mean)[1,5] 
		matrix avgdairy[`r'+49,4]=r(sd)[1,5]	
		matrix avgdairy[`r'+56,2]=r(mean)[1,6] 
		matrix avgdairy[`r'+56,4]=r(sd)[1,6]	
		matrix avgdairy[`r'+63,2]=r(mean)[1,7] 
		matrix avgdairy[`r'+63,4]=r(sd)[1,7]
			
		
		*By SIMD
		*SIMD 1 (most deprived)
		sum `var' if simd20_sga==1 & DairyConsumer==1
		matrix avgdairy[`r'+70,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==1 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+70,3]=r(r2) 
		matrix avgdairy[`r'+70,5]=r(r1) 
		matrix avgdairy[`r'+70,6]=r(r3)	

		*SIMD 2
		sum `var' if simd20_sga==2 & DairyConsumer==1
		matrix avgdairy[`r'+77,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==2 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+77,3]=r(r2) 
		matrix avgdairy[`r'+77,5]=r(r1) 
		matrix avgdairy[`r'+77,6]=r(r3)
		
		*SIMD 3
		sum `var' if simd20_sga==3 & DairyConsumer==1
		matrix avgdairy[`r'+84,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==3 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+84,3]=r(r2) 
		matrix avgdairy[`r'+84,5]=r(r1) 
		matrix avgdairy[`r'+84,6]=r(r3)
				
		*SIMD 4
		sum `var' if simd20_sga==4 & DairyConsumer==1
		matrix avgdairy[`r'+91,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==4 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+91,3]=r(r2) 
		matrix avgdairy[`r'+91,5]=r(r1) 
		matrix avgdairy[`r'+91,6]=r(r3)

		*SIMD 5 (least deprived)
		sum `var' if simd20_sga==5 & DairyConsumer==1
		matrix avgdairy[`r'+98,1]=r(N)
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if simd20_sga==5 & DairyConsumer==1, p(2.5, 50, 97.5)
		matrix avgdairy[`r'+98,3]=r(r2) 
		matrix avgdairy[`r'+98,5]=r(r1) 
		matrix avgdairy[`r'+98,6]=r(r3)
		
		svy, subpop(DairyConsumer): mean `var', over(simd20_sga)
		estat sd
		
		matrix avgdairy[`r'+70,2]=r(mean)[1,1] 
		matrix avgdairy[`r'+70,4]=r(sd)[1,1] 
		matrix avgdairy[`r'+77,2]=r(mean)[1,2] 
		matrix avgdairy[`r'+77,4]=r(sd)[1,2] 
		matrix avgdairy[`r'+84,2]=r(mean)[1,3] 
		matrix avgdairy[`r'+84,4]=r(sd)[1,3]
		matrix avgdairy[`r'+91,2]=r(mean)[1,4] 
		matrix avgdairy[`r'+91,4]=r(sd)[1,4]
		matrix avgdairy[`r'+98,2]=r(mean)[1,5] 
		matrix avgdairy[`r'+98,4]=r(sd)[1,5]	
				
		local r=`r'+1	
}	

* Export to Excel 
	putexcel set "$output\SHeS Dairy Intakes_Manuscript.xlsx", sheet("Average intake, per consumer") modify
	putexcel B2=matrix(avgdairy)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"


/*=============================================
AVERAGE DAILY INTAKES OF DAIRY, % CONTRIBUTIONS	
===============================================*/

	matrix propdairy = J(230, 4, .)
	local r=2

quietly foreach var of varlist Prop_Avg_Day_Milk Prop_Avg_Day_Cheese Prop_Avg_Day_Yogurt Prop_Avg_Day_CreamDesserts Prop_Avg_Day_Butter {
			
		*overall		
		sum `var'
		matrix propdairy[`r',1]=r(N)
		
		svy, subpop(DairyConsumer): mean `var'
		estat sd
		matrix propdairy[`r',2]=r(mean)
		matrix propdairy[`r',3]=r(sd)

		*by sex
		sum `var' if Sex==2 & DairyConsumer==1
		matrix propdairy[`r'+6,1]=r(N) 
		
		sum `var' if Sex==1 & DairyConsumer==1
		matrix propdairy[`r'+12,1]=r(N)
		
		svy, subpop(DairyConsumer): mean `var', over(Sex)
		estat sd
		matrix propdairy[`r'+6,2]=r(mean)[1,2] 
		matrix propdairy[`r'+6,3]=r(sd)[1,2]
		matrix propdairy[`r'+12,2]=r(mean)[1,1] 
		matrix propdairy[`r'+12,3]=r(sd)[1,1]
		
		*by age
		sum `var' if age_cat==1 & DairyConsumer==1
		matrix propdairy[`r'+18,1]=r(N)
		
		sum `var' if age_cat==2 & DairyConsumer==1
		matrix propdairy[`r'+24,1]=r(N)
		
		sum `var' if age_cat==3 & DairyConsumer==1
		matrix propdairy[`r'+30,1]=r(N)
		
		sum `var' if age_cat==4 & DairyConsumer==1
		matrix propdairy[`r'+36,1]=r(N)
		
		sum `var' if age_cat==5 & DairyConsumer==1
		matrix propdairy[`r'+42,1]=r(N)
		
		sum `var' if age_cat==6 & DairyConsumer==1
		matrix propdairy[`r'+48,1]=r(N)
		
		sum `var' if age_cat==7 & DairyConsumer==1
		matrix propdairy[`r'+54,1]=r(N)
		
		svy, subpop(DairyConsumer): mean `var', over(age_cat)
		estat sd
		matrix propdairy[`r'+18,2]=r(mean)[1,1] 
		matrix propdairy[`r'+18,3]=r(sd)[1,1] 
		matrix propdairy[`r'+24,2]=r(mean)[1,2] 
		matrix propdairy[`r'+24,3]=r(sd)[1,2] 
		matrix propdairy[`r'+30,2]=r(mean)[1,3] 
		matrix propdairy[`r'+30,3]=r(sd)[1,3]	
		matrix propdairy[`r'+36,2]=r(mean)[1,4] 
		matrix propdairy[`r'+36,3]=r(sd)[1,4]	
		matrix propdairy[`r'+42,2]=r(mean)[1,5] 
		matrix propdairy[`r'+42,3]=r(sd)[1,5]	
		matrix propdairy[`r'+48,2]=r(mean)[1,6] 
		matrix propdairy[`r'+48,3]=r(sd)[1,6]	
		matrix propdairy[`r'+54,2]=r(mean)[1,7] 
		matrix propdairy[`r'+54,3]=r(sd)[1,7]
				
		*By SIMD		
		sum `var' if simd20_sga==1 & DairyConsumer==1
		matrix propdairy[`r'+60,1]=r(N)
		
		sum `var' if simd20_sga==2 & DairyConsumer==1
		matrix propdairy[`r'+66,1]=r(N)
		
		sum `var' if simd20_sga==3 & DairyConsumer==1
		matrix propdairy[`r'+72,1]=r(N)
		
		sum `var' if simd20_sga==4 & DairyConsumer==1
		matrix propdairy[`r'+78,1]=r(N)
		
		sum `var' if simd20_sga==5 & DairyConsumer==1
		matrix propdairy[`r'+84,1]=r(N)
		
		svy, subpop(DairyConsumer): mean `var', over(simd20_sga)
		estat sd
		matrix propdairy[`r'+60,2]=r(mean)[1,1] 
		matrix propdairy[`r'+60,3]=r(sd)[1,1] 
		matrix propdairy[`r'+66,2]=r(mean)[1,2] 
		matrix propdairy[`r'+66,3]=r(sd)[1,2] 
		matrix propdairy[`r'+72,2]=r(mean)[1,3] 
		matrix propdairy[`r'+72,3]=r(sd)[1,3]
		matrix propdairy[`r'+78,2]=r(mean)[1,4] 
		matrix propdairy[`r'+78,3]=r(sd)[1,4]
		matrix propdairy[`r'+84,2]=r(mean)[1,5] 
		matrix propdairy[`r'+84,3]=r(sd)[1,5]	
		
		local r=`r'+1
		
}	

	*Export to Excel
	putexcel set "$output\SHeS Dairy intakes_Manuscript.xlsx", sheet("Dairy contributions") modify
	putexcel B2=matrix(propdairy)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD"


