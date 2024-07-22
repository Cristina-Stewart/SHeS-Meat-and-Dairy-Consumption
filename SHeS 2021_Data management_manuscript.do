

************************************************************************************
*Manuscript: "Meat and dairy consumption in Scottish adults: Insights from a national survey"

*Data management do-file for the manuscript 
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
global location "K:\DrJaacksGroup\FSS - Dietary Monitoring\SHeS\SHeS 2021\Current intakes paper" 
global data `"$location\Data"'
global output `"$location\Output"'
global code `"$location\Code"'
global date "20240603"

*Demographic data
global dems `"$data\shes21i_eul"'
*Intake24 diet data (multiple obeservations per participant, each observation = food item reported)
global diet `"$data\diet_dairydisag_20231512"'
*Set maximum number of variables to 15,000
set maxvar 15000


******************
*Merging datasets
******************
/*Rename missing variable names
use "$diet", clear
sort Cpseriala RecallNo

rename variabl0 Retinol
rename variabl00 TotCarotene
rename variabl01 Alpcarotene
rename variabl02 Betacarotene
rename variabl03 BCryptoxanthin
rename variabl04 VitaminA
rename variabl05 VitaminD
rename variabl06 VitaminB12
rename variabl07 Folate
rename variabl08 Biotin
rename variabl09 Iodine
rename variabl000 Selenium

sort Cpseriala

save "$diet", replace
*/

use "$dems", clear
keep Cpseriala CHHSerialA HBCode psu Strata InIntake24 SHeS_Intake24_wt_sc simd20_sga SIMD20_RPa Ethnic05 Sex age SlfHtDV_adj SlfWtDV_adj bmi_adj bmivg5_adj NumberOfRecalls PregNowC WRFOOD ATELESS2 HHFOOD2 FoodEkcal 
sort Cpseriala
merge 1:m Cpseriala using "$diet"
	*check merge - OK
	*tab _merge InIntake24
	drop _merge
	*dropping nutrients not used
	drop Retinol TotCarotene Alpcarotene Betacarotene BCryptoxanthin Alcoholg Waterg Totalsugarsg Othersugarsg Starchg Glucoseg Fructoseg Sucroseg Maltoseg Lactoseg Totalnitrogeng Cholesterolmg Saturatedfattyacidsg CisMonounsaturatedfattyacidsg Cisn6fattyacidsg Cisn3fattyacidsg Transfattyacidsg Fruitg DriedFruitg FruitJuiceg SmoothieFruitg Tomatoesg TomatoPureeg Brassicaceaeg YellowRedGreeng Beansg Nutsg OtherVegg Pantothenicacidmg Biotin
		*note: no DRV for pantothenic acid, or biotin
	*dropping old cheese disag variables not used
	drop CottageCheeseg CheddarCheeseg OtherCheeseg

****************************************
*Create subpop variable for analysis
****************************************
*Completed at least 1 recall
gen intake24=0
replace intake24=1 if InIntake24==1

*Completed 2 recalls
gen TwoRecalls=0
replace TwoRecalls=1 if NumberOfRecalls==2
replace TwoRecalls=. if InIntake24==0

****************************************
*Create age group variable for analysis
****************************************
gen age_cat=.
replace age_cat=1 if age>=16 & age<25
replace age_cat=2 if age>=25 & age<35
replace age_cat=3 if age>=35 & age<45
replace age_cat=4 if age>=45 & age<55
replace age_cat=5 if age>=55 & age<65
replace age_cat=6 if age>=65 & age<75
replace age_cat=7 if age>=75 & age!=.

gen age_catdesc=""
replace age_catdesc="16-24y" if age_cat==1
replace age_catdesc="25-34y" if age_cat==2
replace age_catdesc="35-44y" if age_cat==3
replace age_catdesc="45-54y" if age_cat==4
replace age_catdesc="55-64y" if age_cat==5
replace age_catdesc="65-74y" if age_cat==6
replace age_catdesc="75y+" if age_cat==7


********************************************************
*Create categorical variable for DRV age and sex groups
********************************************************
gen RNI_agesex=0
replace RNI_agesex=1 if Sex==1 & age>=15 & age<=18
replace RNI_agesex=2 if Sex==1 & age>=19 & age<=50
replace RNI_agesex=3 if Sex==1 & age>=51 
replace RNI_agesex=4 if Sex==2 & age>=15 & age<=18
replace RNI_agesex=5 if Sex==2 & age>=19 & age<=50
replace RNI_agesex=6 if Sex==2 & age>=51 

gen RNI_agesexdesc=""
replace RNI_agesexdesc="Men 15-18y" if RNI_agesex==1
replace RNI_agesexdesc="Men 19-50y" if RNI_agesex==2
replace RNI_agesexdesc="Men 51+y" if RNI_agesex==3
replace RNI_agesexdesc="Women 15-18y" if RNI_agesex==4
replace RNI_agesexdesc="Women 19-50y" if RNI_agesex==5
replace RNI_agesexdesc="Women 51+y" if RNI_agesex==6

		
*************************************************************************
*Dropping intake from supplements as interested in intake from food only
*************************************************************************
drop if RecipeMainFoodGroupCode==54 /*n=3,589*/


**********************************************************************************
*Tag each unique recall within the food-level dataset for subsequent calculations
**********************************************************************************
bysort Cpseriala RecallNo: gen n=_n==1
replace n=. if RecallNo==.


/************************************************************************************
Some dairy product re-categorisation is required:

1) Re-categorising dairy-free items out of dairy and into new dairy-free food groups
2) Re-categorising hot chocolates made with water out of dairy and into 'misc'
3) Re-categorising milky coffees (e.g. lattes, cappucinos) into dairy from 'coffee'
4) Re-categorising two ice lollies (without ice cream) incorrectly categorised into 
'ice cream' instead of 'sugar confectionery'
************************************************************************************/

***1) Recategorising dairy-free items

*Sub food group level
replace RecipeSubFoodGroupCode="13R_DF" if RecipeSubFoodGroupCode=="13R" & (strpos(FoodDescription, "Almond") | strpos(FoodDescription, "Alpro") | strpos(FoodDescription, "soya") | strpos(FoodDescription, "Soya") | strpos(FoodDescription, "Hemp") | strpos(FoodDescription, "Oat") | strpos(FoodDescription, "Rice"))
replace RecipeSubFoodGroupCode="13B_DF" if RecipeSubFoodGroupCode=="13B" & strpos(FoodDescription, "Alpro") 
replace RecipeSubFoodGroupCode="14R_DF" if RecipeSubFoodGroupCode=="14R" & strpos(FoodDescription, "Tofu") 
replace RecipeSubFoodGroupCode="15B_DF" if RecipeSubFoodGroupCode=="15B" & strpos(FoodDescription, "Soya") 
replace RecipeSubFoodGroupCode="15C_DF" if RecipeSubFoodGroupCode=="15C" & strpos(FoodDescription, "Soya") 
replace RecipeSubFoodGroupCode="53R_DF" if RecipeSubFoodGroupCode=="53R" & strpos(FoodDescription, "Dairy free")
*Main food group level
replace RecipeMainFoodGroupCode=63 if RecipeSubFoodGroupCode=="13R_DF" | RecipeSubFoodGroupCode=="13B_DF"
replace RecipeMainFoodGroupCode=64 if RecipeSubFoodGroupCode=="14R_DF"
replace RecipeMainFoodGroupCode=65 if RecipeSubFoodGroupCode=="15B_DF" | RecipeSubFoodGroupCode=="15C_DF"
replace RecipeMainFoodGroupCode=66 if RecipeSubFoodGroupCode=="53R_DF"


***2) Re-categorising hot chocolates made with water

*Sub food group level
replace RecipeSubFoodGroupCode="50A" if RecipeSubFoodGroupCode=="13R" & strpos(FoodDescription, "made with water") 
*Main food group level 
replace RecipeMainFoodGroupCode=50 if RecipeSubFoodGroupCode=="50A"


***3) Re-categorising milky coffees (lattes/cappuccinos/mochas) into 'other milk'

*First, re-categorise dairy-free coffees
replace RecipeSubFoodGroupCode="13R_DF" if RecipeSubFoodGroupCode=="51A" & (strpos(FoodDescription, "soya milk"))

*Sub food group level
replace RecipeSubFoodGroupCode="13R" if RecipeSubFoodGroupCode=="51A" & (strpos(FoodDescription, "Cappuccino") | strpos(FoodDescription, "latte") | strpos(FoodDescription, "cappuccino")| strpos(FoodDescription, "Flat white") | strpos(FoodDescription, "Latte") | strpos(FoodDescription, "Mocha")) 
*Main food group level
replace RecipeMainFoodGroupCode=13 if RecipeSubFoodGroupCode=="13R"


***4) Re-categorising two incorrectly categorised ice lollies

*Sub food group level
replace RecipeSubFoodGroupCode="43R" if RecipeSubFoodGroupCode=="53R" & (strpos(FoodDescription, "Sorbet") | strpos(FoodDescription, "Twister")) 

*Main food group level
replace RecipeMainFoodGroupCode=43 if RecipeSubFoodGroupCode=="43R"


***5) Update main and sub food group description variables based on updated categories

*Main food groups
replace RecipeMainFoodGroupDesc="OTHER MILK AND CREAM (DAIRY FREE)" if RecipeMainFoodGroupCode==63
replace RecipeMainFoodGroupDesc="CHEESE (DAIRY FREE)" if RecipeMainFoodGroupCode==64
replace RecipeMainFoodGroupDesc="YOGURT, FROMAGE FRAIS & DAIRY DESSERTS (DAIRY FREE)" if RecipeMainFoodGroupCode==65
replace RecipeMainFoodGroupDesc="ICE CREAM (DAIRY-FREE)" if RecipeMainFoodGroupCode==66
*Sub food group
replace RecipeSubFoodGroupDesc="OTHER MILK (DAIRY-FREE)" if RecipeSubFoodGroupCode=="13R_DF"
replace RecipeSubFoodGroupDesc="CREAM (DAIRY-FREE)" if RecipeSubFoodGroupCode=="13B_DF"
replace RecipeSubFoodGroupDesc="OTHER CHEESE (DAIRY-FREE)" if RecipeSubFoodGroupCode=="14R_DF" 
replace RecipeSubFoodGroupDesc="YOGURT (DAIRY-FREE)" if RecipeSubFoodGroupCode=="15B_DF"
replace RecipeSubFoodGroupDesc="FROMAGE FRAIS AND DAIRY DESSERTS (DAIRY-FREE)" if RecipeSubFoodGroupCode=="15C_DF"
replace RecipeSubFoodGroupDesc="ICE CREAM (DAIRY-FREE)" if RecipeSubFoodGroupCode=="53R_DF"


/***************************************************************************************************
Create high level food categories (that reflect NDNS food categories)
Here, we re-categorise butter (main food group 17) from 'fat spreads' into 'milk and milk products'
***************************************************************************************************/

***Create 'Food Category Code' and 'Food Category Description' variables

**Food category code
gen FoodCategoryCode=.
replace FoodCategoryCode=1 if RecipeMainFoodGroupCode>=1 & RecipeMainFoodGroupCode<=9 |RecipeMainFoodGroupCode==59 
replace FoodCategoryCode=2 if RecipeMainFoodGroupCode>=10 & RecipeMainFoodGroupCode<=15 | RecipeMainFoodGroupCode==17 | RecipeMainFoodGroupCode==60 | RecipeMainFoodGroupCode==53 
replace FoodCategoryCode=3 if RecipeMainFoodGroupCode==16
replace FoodCategoryCode=4 if RecipeMainFoodGroupCode>=18 & RecipeMainFoodGroupCode<=21
replace FoodCategoryCode=5 if RecipeMainFoodGroupCode>=22 & RecipeMainFoodGroupCode<=32
replace FoodCategoryCode=6 if RecipeMainFoodGroupCode>=33 & RecipeMainFoodGroupCode<=35
replace FoodCategoryCode=7 if RecipeMainFoodGroupCode==62
replace FoodCategoryCode=8 if RecipeMainFoodGroupCode>=36 & RecipeMainFoodGroupCode<=39
replace FoodCategoryCode=9 if RecipeMainFoodGroupCode==40
replace FoodCategoryCode=10 if RecipeMainFoodGroupCode==41 | RecipeMainFoodGroupCode==43 | RecipeMainFoodGroupCode==44
replace FoodCategoryCode=11 if RecipeMainFoodGroupCode==42
replace FoodCategoryCode=12 if RecipeMainFoodGroupCode==56 
replace FoodCategoryCode=13 if RecipeMainFoodGroupCode==45 | RecipeMainFoodGroupCode==61 | RecipeMainFoodGroupCode==57 | RecipeMainFoodGroupCode==58 | RecipeMainFoodGroupCode==51
replace FoodCategoryCode=14 if RecipeMainFoodGroupCode>=47 & RecipeMainFoodGroupCode<=49
replace FoodCategoryCode=15 if RecipeMainFoodGroupCode==50
replace FoodCategoryCode=16 if RecipeMainFoodGroupCode==52
replace FoodCategoryCode=17 if RecipeMainFoodGroupCode==55
replace FoodCategoryCode=18	if strpos(RecipeSubFoodGroupCode, "_DF") /* dairy-free items*/
replace FoodCategoryCode=. if RecipeMainFoodGroupCode==.

**Food category description
gen FoodCategoryDesc=""
replace FoodCategoryDesc="Cereals and Cereal Products" if FoodCategoryCode==1
replace FoodCategoryDesc="Milk and Milk Products" if FoodCategoryCode==2
replace FoodCategoryDesc="Eggs and Egg Dishes" if FoodCategoryCode==3
replace FoodCategoryDesc="Fat Spreads" if FoodCategoryCode==4
replace FoodCategoryDesc="Meat and Meat Products" if FoodCategoryCode==5
replace FoodCategoryDesc="Fish and Fish Dishes" if FoodCategoryCode==6
replace FoodCategoryDesc="Sandwiches" if FoodCategoryCode==7
replace FoodCategoryDesc="Vegetables, potatoes" if FoodCategoryCode==8
replace FoodCategoryDesc="Fruit" if FoodCategoryCode==9
replace FoodCategoryDesc="Sugar, Preserves and Confectionery" if FoodCategoryCode==10
replace FoodCategoryDesc="Savoury Snacks" if FoodCategoryCode==11
replace FoodCategoryDesc="Nuts and Seeds" if FoodCategoryCode==12
replace FoodCategoryDesc="Non-alcoholic beverages" if FoodCategoryCode==13
replace FoodCategoryDesc="Alcoholic beverages" if FoodCategoryCode==14
replace FoodCategoryDesc="Misc" if FoodCategoryCode==15
replace FoodCategoryDesc="Toddler foods" if FoodCategoryCode==16
replace FoodCategoryDesc="Artificial sweeteners" if FoodCategoryCode==17
replace FoodCategoryDesc="Milk and Milk Products (dairy-free)" if FoodCategoryCode==18


/*************************************************************************
Collapse high level food categories into four food groups for reporting:
1) Milk and milk products
2) Meat and meat products
3) Sandwiches
4) Other
*************************************************************************/

gen NewFoodCategoryCode=4
replace NewFoodCategoryCode=1 if FoodCategoryCode==5
replace NewFoodCategoryCode=2 if FoodCategoryCode==2
replace NewFoodCategoryCode=3 if FoodCategoryCode==7
replace NewFoodCategoryCode=. if FoodCategoryCode==.

gen NewFoodCategoryDesc=""
replace NewFoodCategoryDesc="Meat and meat products" if NewFoodCategoryCode==1
replace NewFoodCategoryDesc="Milk and milk products (excl dairy-free)" if NewFoodCategoryCode==2
replace NewFoodCategoryDesc="Sandwiches" if NewFoodCategoryCode==3
replace NewFoodCategoryDesc="Other" if NewFoodCategoryCode==4

order NewFoodCategoryCode NewFoodCategoryDesc FoodCategoryCode FoodCategoryDesc, before(RecipeMainFoodGroupCode)


/**************************************************************************************
Create meat animal type variables
**************************************************************************************/

/***First, re-categorising items within processed red meat, burgers, sausages and offal

Some assumptions:
1) assumed generic tongue is beef
2) assumed pate black pudding, and "meat" in tomato pasta dishes are pork (e.g. bacon)
*/

*Beef
gen Beef_Process=0
replace Beef_Process=ProcessedRedMeatg if (strpos(FoodDescription, "Pastrami") | strpos(FoodDescription, "Corned beef"))

gen Beef_Burgers=0
replace Beef_Burgers=Burgersg if (strpos(FoodDescription, "Lamb") | strpos(FoodDescription, "Hot dog"))==0

gen Beef_Sausages=0
replace Beef_Sausages=Sausagesg if strpos(FoodDescription, "Beef Sausage")

gen Beef_Offal=0
replace Beef_Offal=Offalg if (strpos(FoodDescription, "Ox") |strpos(FoodDescription, "Calf liver")) 

*Lamb
gen Lamb_Burgers=0
replace Lamb_Burgers=Burgersg if strpos(FoodDescription, "Lamb")

gen Lamb_Offal=0
replace Lamb_Offal=Offalg if (strpos(FoodDescription, "Lambs liver") | strpos(FoodDescription, "Haggis"))

*Pork
gen Pork_Process=0
replace Pork_Process=ProcessedRedMeatg if Beef_Process==0

gen Pork_Burgers=0
replace Pork_Burgers=Burgersg if Beef_Burgers==0 & Lamb_Burgers==0

gen Pork_Sausages=0
replace Pork_Sausages=Sausagesg if Beef_Sausages==0 & (strpos(FoodDescription, "Chicken/turkey sausage") | strpos(FoodDescription, "Venison sausage"))==0

gen Pork_Offal=0
replace Pork_Offal=Offalg if Beef_Offal==0 & Lamb_Offal==0 & (strpos(FoodDescription, "Chicken liver"))==0

*Poultry
gen Poultry_Sausages=0
replace Poultry_Sausages=Sausagesg if strpos(FoodDescription, "Chicken/turkey sausage")

gen Poultry_Offal=0
replace Poultry_Offal=Offalg if strpos(FoodDescription, "Chicken liver")

*Game
gen Game_Sausages=0
replace Game_Sausages=Sausagesg if strpos(FoodDescription, "Venison sausage")

*Replace values of those without recalls to missing
foreach var of varlist Beef_Process Beef_Burgers Beef_Sausages Beef_Offal Lamb_Burgers Lamb_Offal Pork_Process Pork_Burgers Pork_Sausages Pork_Offal Poultry_Sausages Poultry_Offal Game_Sausages {
	replace `var' =. if RecallNo==. 
}

*Totals will be calculated in next section


/***************************************************************************
Create daily summary intakes (g) of meat, dairy and nutrients

For meat, and dairy, we first need to create totals at the food item level
***************************************************************************/

***MEAT***

*Food level
egen totalbeef=rowtotal(Beefg Beef_Process Beef_Burgers Beef_Sausages Beef_Offal)
egen totallamb=rowtotal(Lambg Lamb_Burgers Lamb_Offal)
egen totalpork=rowtotal(Porkg Pork_Process Pork_Burgers Pork_Sausages Pork_Offal)
egen totalpoultry=rowtotal(Poultryg ProcessedPoultryg Poultry_Sausages Poultry_Offal)
egen totalgame=rowtotal(GameBirds OtherRedMeatg Game_Sausages)

egen totmeatg=rowtotal(totalbeef totallamb totalpork totalpoultry totalgame)
egen redmeatg=rowtotal(Beefg Lambg Porkg OtherRedMeatg Offalg)
egen processedmeatg=rowtotal(Burgersg Sausagesg ProcessedPoultryg ProcessedRedMeatg)
egen whitemeatg=rowtotal(Poultryg GameBirdsg)

egen redprocessedmeatg=rowtotal(totalbeef totallamb totalpork OtherRedMeatg Game_Sausages)   	

*Day level
bysort Cpseriala RecallNo: egen Day_Beef=sum(totalbeef)
bysort Cpseriala RecallNo: egen Day_Lamb=sum(totallamb)
bysort Cpseriala RecallNo: egen Day_Pork=sum(totalpork)
bysort Cpseriala RecallNo: egen Day_Poultry=sum(totalpoultry)
bysort Cpseriala RecallNo: egen Day_Game=sum(totalgame)

bysort Cpseriala RecallNo: egen Day_TotalMeat=sum(totmeatg)
bysort Cpseriala RecallNo: egen Day_RedMeat=sum(redmeatg)
bysort Cpseriala RecallNo: egen Day_ProcessedMeat=sum(processedmeatg)
bysort Cpseriala RecallNo: egen Day_WhiteMeat=sum(whitemeatg)

bysort Cpseriala RecallNo: egen Day_RRPM=sum(redprocessedmeatg)									


*Replace values of those without recalls to missing
foreach var of varlist totalbeef totallamb totalpork totalpoultry totalgame totmeatg redmeatg processedmeatg redprocessedmeatg whitemeatg Day_Beef Day_Lamb Day_Pork Day_Poultry Day_Game Day_TotalMeat Day_RedMeat Day_ProcessedMeat Day_WhiteMeat Day_RRPM{
	replace `var' =. if RecallNo==. 
}

***DAIRY***

*Day level
bysort Cpseriala RecallNo: egen Day_Dairy=sum(Dairyg)
bysort Cpseriala RecallNo: egen Day_Milk=sum(Milkg)
bysort Cpseriala RecallNo: egen Day_Cheese=sum(Cheeseg)
bysort Cpseriala RecallNo: egen Day_Yogurt=sum(Yogurtg)
bysort Cpseriala RecallNo: egen Day_Cream=sum(Creamg)
bysort Cpseriala RecallNo: egen Day_Butter=sum(Butterg)

bysort Cpseriala RecallNo: egen Day_Milk_Skimmed=sum(Milk_Skimmedg)
bysort Cpseriala RecallNo: egen Day_Milk_SemiSkimmed=sum(Milk_SemiSkimmedg)
bysort Cpseriala RecallNo: egen Day_Milk_Whole=sum(Milk_Wholeg)

bysort Cpseriala RecallNo: egen Day_Cheese_Cheddar=sum(Cheese_Cheddarg)
bysort Cpseriala RecallNo: egen Day_Cheese_Cottage=sum(Cheese_Cottageg)
bysort Cpseriala RecallNo: egen Day_Cheese_Other=sum(Cheese_Otherg)

bysort Cpseriala RecallNo: egen Day_Cheese_Skimmed=sum(Cheese_Skimmedg)
bysort Cpseriala RecallNo: egen Day_Cheese_SemiSkimmed=sum(Cheese_SemiSkimmedg)
bysort Cpseriala RecallNo: egen Day_Cheese_Whole=sum(Cheese_Wholeg)

bysort Cpseriala RecallNo: egen Day_Yogurt_Skimmed=sum(Yogurt_Skimmedg)
bysort Cpseriala RecallNo: egen Day_Yogurt_SemiSkimmed=sum(Yogurt_SemiSkimmedg)
bysort Cpseriala RecallNo: egen Day_Yogurt_Whole=sum(Yogurt_Wholeg)

bysort Cpseriala RecallNo: egen Day_Cream_SemiSkimmed=sum(Cream_SemiSkimmedg)
bysort Cpseriala RecallNo: egen Day_Cream_Whole=sum(Cream_Wholeg)


*Calculate daily intakes of low vs regular fat dairy
	*Total dairy
	bysort Cpseriala RecallNo: gen Day_Dairy_LF= Day_Milk_Skimmed + Day_Milk_SemiSkimmed + Day_Cheese_Skimmed + Day_Cheese_SemiSkimmed + Day_Yogurt_Skimmed + Day_Yogurt_SemiSkimmed + Day_Cream_SemiSkimmed
	bysort Cpseriala RecallNo: gen Day_Dairy_HF= Day_Milk_Whole + Day_Cheese_Whole + Day_Yogurt_Whole + Day_Cream_Whole + Day_Butter 

	*Milk
	bysort Cpseriala RecallNo: gen Day_Milk_LF= Day_Milk_Skimmed + Day_Milk_SemiSkimmed
	bysort Cpseriala RecallNo: gen Day_Milk_HF= Day_Milk_Whole

	*Cheese
	bysort Cpseriala RecallNo: gen Day_Cheese_LF= Day_Cheese_Skimmed + Day_Cheese_SemiSkimmed
	bysort Cpseriala RecallNo: gen Day_Cheese_HF= Day_Cheese_Whole
	
	*Yogurt
	bysort Cpseriala RecallNo: gen Day_Yogurt_LF= Day_Yogurt_Skimmed + Day_Yogurt_SemiSkimmed
	bysort Cpseriala RecallNo: gen Day_Yogurt_HF= Day_Yogurt_Whole
	
	*Cream
	bysort Cpseriala RecallNo: gen Day_Cream_LF= Day_Cream_SemiSkimmed
	bysort Cpseriala RecallNo: gen Day_Cream_HF= Day_Cream_Whole

	
*Replace values of those without recalls to missing
foreach var of varlist Dairyg Milkg Milk_Skimmedg Milk_SemiSkimmedg Milk_Wholeg Cheeseg Cheese_Cheddarg Cheese_Cottageg Cheese_Otherg Cheese_Skimmedg Cheese_SemiSkimmedg Cheese_Wholeg Yogurtg Yogurt_Skimmedg Yogurt_SemiSkimmedg Yogurt_Wholeg Creamg Cream_SemiSkimmedg Cream_Wholeg Butterg Day_Dairy Day_Milk Day_Cheese Day_Yogurt Day_Cream Day_Butter Day_Milk_Skimmed Day_Milk_SemiSkimmed Day_Milk_Whole Day_Cheese_Cheddar Day_Cheese_Cottage Day_Cheese_Other Day_Cheese_Skimmed Day_Cheese_SemiSkimmed Day_Cheese_Whole Day_Yogurt_Skimmed Day_Yogurt_SemiSkimmed Day_Yogurt_Whole Day_Cream_SemiSkimmed Day_Cream_Whole {
	replace `var' =. if RecallNo==. 
}


***NUTRIENTS***

*Day level
rename Niacinequivalentmg Niacin /*Variable names get too long in the data loop so have to rename*/

*Loop to calculate daily intake of each nutrient
foreach var of varlist Energykcal EnergykJ Proteing Fatg Carbohydrateg Sodiummg Potassiummg Calciummg Magnesiummg Phosphorusmg Ironmg Coppermg Zincmg Chloridemg VitaminA VitaminD VitaminEmg Thiaminmg Riboflavinmg Niacin VitaminB6mg VitaminB12 Folate VitaminCmg FreeSugarsg AOACFibreg Manganesemg Selenium Iodine {
	bysort Cpseriala RecallNo: egen Day_`var' =sum(`var') 
	replace Day_`var' =. if RecallNo==. 
}

/**********************************************************
 Calculate mean daily intakes of meat, dairy and nutrients
**********************************************************/

*Set local macro
ds Day_* 
local dayvalues `r(varlist)'

*Loop through each daily value
foreach var of varlist `dayvalues' {
	bysort Cpseriala RecallNo: egen DayMax_`var' =max(`var') /*daily intake*/
    bysort Cpseriala: egen Wk_`var' = total(DayMax_`var') if n==1 /*total intake across all days*/
	bysort Cpseriala: egen WkMax_`var' = max(Wk_`var') /*filling in total intake across all days across all observations*/
	bysort Cpseriala: gen Avg_`var' = (WkMax_`var'/NumberOfRecalls) /*mean daily intake*/
	drop DayMax_`var' Wk_`var' WkMax_`var'
}


/**************************************************************************
 Create consumer variables for meat (total and each subtype) and dairy
 Interested in:
 
 1) Consumer overall (yes/no)
 2) Consumer on day 1 and day 2 separately (total meat and dairy)
 3) The number of days an individual was a consumer (total meat and dairy)
**************************************************************************/

**1) Consumer overall

*Total meat
gen MeatConsumer=0
replace MeatConsumer=1 if Avg_Day_TotalMeat>0 & Avg_Day_TotalMeat!=.

*Meat subtypes
gen RedMeatConsumer=0
replace RedMeatConsumer=1 if Avg_Day_RedMeat>0 & Avg_Day_RedMeat!=.

gen ProcessedMeatConsumer=0
replace ProcessedMeatConsumer=1 if Avg_Day_ProcessedMeat>0 & Avg_Day_ProcessedMeat!=.

gen WhiteMeatConsumer=0
replace WhiteMeatConsumer=1 if Avg_Day_WhiteMeat>0 & Avg_Day_WhiteMeat!=.

*Dairy
gen DairyConsumer=0
replace DairyConsumer=1 if Avg_Day_Dairy>0 & Avg_Day_Dairy!=.


**2) Consumer on day 1 and day 2 separately

*Create binary variables for being a consumer on each day

*Meat
gen MeatConsumer_Day1=.
replace MeatConsumer_Day1=1 if RecallNo==1 & Day_TotalMeat>0 & Day_TotalMeat!=.
replace MeatConsumer_Day1=0 if RecallNo==1 & Day_TotalMeat==0

gen MeatConsumer_Day2=.
replace MeatConsumer_Day2=1 if RecallNo==2 & Day_TotalMeat>0 & Day_TotalMeat!=.
replace MeatConsumer_Day2=0 if RecallNo==2 & Day_TotalMeat==0

bysort Cpseriala: egen MeatConsumerDay1 = max(MeatConsumer_Day1)
bysort Cpseriala: egen MeatConsumerDay2 = max(MeatConsumer_Day2)
drop MeatConsumer_Day1 MeatConsumer_Day2

*Dairy 
gen DairyConsumer_Day1=.
replace DairyConsumer_Day1=1 if RecallNo==1 & Day_Dairy>0 & Day_Dairy!=.
replace DairyConsumer_Day1=0 if RecallNo==1 & Day_Dairy==0

gen DairyConsumer_Day2=.
replace DairyConsumer_Day2=1 if RecallNo==2 & Day_Dairy>0 & Day_Dairy!=.
replace DairyConsumer_Day2=0 if RecallNo==2 & Day_Dairy==0

bysort Cpseriala: egen DairyConsumerDay1 = max(DairyConsumer_Day1)
bysort Cpseriala: egen DairyConsumerDay2 = max(DairyConsumer_Day2)
drop DairyConsumer_Day1 DairyConsumer_Day2

**3) The number of days an individual was a consumer

*Meat
gen MeatConsumerDays = MeatConsumerDay1 + MeatConsumerDay2 if NumberOfRecalls==2
replace MeatConsumerDays = MeatConsumerDay1 if NumberOfRecalls==1

*Dairy
gen DairyConsumerDays = DairyConsumerDay1 + DairyConsumerDay2 if NumberOfRecalls==2
replace DairyConsumerDays = DairyConsumerDay1 if NumberOfRecalls==1


/*********************************************************************
Calculate mean daily nutrient intakes from HIGH LEVEL FOOD CATEGORIES
*********************************************************************/
local nutrients "totmeatg Dairyg Energykcal EnergykJ Proteing Fatg Carbohydrateg Sodiummg Potassiummg Calciummg Magnesiummg Phosphorusmg Ironmg Coppermg Zincmg Chloridemg VitaminA VitaminD VitaminEmg Thiaminmg Riboflavinmg Niacin VitaminB6mg VitaminB12 Folate VitaminCmg FreeSugarsg AOACFibreg Manganesemg Selenium Iodine" 
levelsof FoodCategoryCode, local(FoodCategoryCode) 

foreach var of varlist `nutrients' {
	foreach 1 of local FoodCategoryCode {
	bysort Cpseriala RecallNo: egen D_`var'_FC`1' = sum(`var') if FoodCategoryCode==`1' /*daily nutrient intake by food group*/
	bysort Cpseriala RecallNo: egen DMax_`var'_FC`1' = max(D_`var'_FC`1') /*filling in daily nutrient intake by food group across all observations*/
	bysort Cpseriala: egen Wk_`var'_FC`1' = total(DMax_`var'_FC`1') if n==1 /*total nutrient intake by food group across all days*/
	bysort Cpseriala: egen WkMax_`var'_FC`1' = max(Wk_`var'_FC`1') /*filling in total intake across all days across all observations*/
	bysort Cpseriala: gen Avg_`var'_FC`1'= (WkMax_`var'_FC`1'/NumberOfRecalls) /*mean daily nutrient intake by food group*/
	drop D_* DMax_* Wk_* WkMax*
	}
}	


/*************************************************************************************************************
Explore nutritional contributions from 'meat and meat products' and 'milk and milk products' to all nutrients
Select  nutrients to focus on for our analysis (where either meat or milk products contributed >=15%)
Only those nutrients carried forward in subsequent code
*************************************************************************************************************/

	
/*MEAT PRODUCTS
local nutrients "Avg_Day_Energykcal Avg_Day_Proteing Avg_Day_Fatg Avg_Day_Carbohydrateg Avg_Day_Sodiummg Avg_Day_Potassiummg Avg_Day_Calciummg Avg_Day_Magnesiummg Avg_Day_Phosphorusmg Avg_Day_Ironmg Avg_Day_Coppermg Avg_Day_Chloridemg Avg_Day_Zincmg  Avg_Day_VitaminA Avg_Day_VitaminD Avg_Day_VitaminEmg Avg_Day_Thiaminmg Avg_Day_Riboflavinmg Avg_Day_Niacin Avg_Day_VitaminB6mg Avg_Day_VitaminB12 Avg_Day_Folate Avg_Day_VitaminCmg Avg_Day_FreeSugarsg Avg_Day_AOACFibreg Avg_Day_Manganesemg Avg_Day_Selenium Avg_Day_Iodine"

local nutrmeat "Avg_Energykcal_FC5 Avg_Proteing_FC5 Avg_Fatg_FC5 Avg_Carbohydrateg_FC5 Avg_Sodiummg_FC5 Avg_Potassiummg_FC5 Avg_Calciummg_FC5 Avg_Magnesiummg_FC5 Avg_Phosphorusmg_FC5 Avg_Ironmg_FC5 Avg_Coppermg_FC5 Avg_Chloridemg_FC5 Avg_Zincmg_FC5  Avg_VitaminA_FC5 Avg_VitaminD_FC5 Avg_VitaminEmg_FC5 Avg_Thiaminmg_FC5 Avg_Riboflavinmg_FC5 Avg_Niacin_FC5 Avg_VitaminB6mg_FC5 Avg_VitaminB12_FC5 Avg_Folate_FC5 Avg_VitaminCmg_FC5 Avg_FreeSugarsg_FC5 Avg_AOACFibreg_FC5 Avg_Manganesemg_FC5 Avg_Selenium_FC5 Avg_Iodine_FC5"

local n : word count `nutrients'
forvalues i = 1/`n' {
     local a : word `i' of `nutrients'
     local b : word `i' of `nutrmeat' 
     gen Prop_`b'=(`b'/`a')*100  if `a'>0 	/*If `a' is 0, Prop_`b' becomes missing, this and the next line ensures no missing values are generated*/
		replace Prop_`b'=0 if `a'==0
}

*this code calculates the survey-weighted mean and standard deviation for the proportion of nutrient intake coming from meat and meat products and outputs it into a matrix
preserve
duplicates drop Cpseriala, force
svyset [pweight=SHeS_Intake24_wt_sc], psu(psu) strata(Strata)

	matrix nutrmeat = J(27, 3, .) 	
	local r=1

quietly foreach var of varlist Prop_Avg_Energykcal_FC5 Prop_Avg_Proteing_FC5 Prop_Avg_Fatg_FC5 Prop_Avg_Carbohydrateg_FC5 Prop_Avg_FreeSugarsg_FC5 Prop_Avg_AOACFibreg_FC5 Prop_Avg_Calciummg_FC5 Prop_Avg_Chloridemg_FC5 Prop_Avg_Coppermg_FC5 Prop_Avg_Iodine_FC5 Prop_Avg_Ironmg_FC5  Prop_Avg_Magnesiummg_FC5 Prop_Avg_Manganesemg_FC5 Prop_Avg_Phosphorusmg_FC5 Prop_Avg_Potassiummg_FC5 Prop_Avg_Selenium_FC5 Prop_Avg_Sodiummg_FC5 Prop_Avg_Zincmg_FC5 Prop_Avg_VitaminA_FC5 Prop_Avg_VitaminD_FC5 Prop_Avg_Thiaminmg_FC5 Prop_Avg_Riboflavinmg_FC5 Prop_Avg_Niacin_FC5 Prop_Avg_VitaminB6mg_FC5 Prop_Avg_Folate_FC5 Prop_Avg_VitaminB12_FC5 Prop_Avg_VitaminCmg_FC5 Prop_Avg_VitaminEmg_FC5 {
			
		*overall
		sum `var'
		matrix nutrmeat[`r',1]=r(N)
		svy, subpop(intake24): mean `var'
		estat sd
		matrix nutrmeat[`r',2]=r(mean) 
		matrix nutrmeat[`r',3]=r(sd) 
				
		local r=`r'+1
}	
restore
matrix list nutrmeat

*MILK PRODUCTS
local nutrients "Avg_Day_Energykcal Avg_Day_Proteing Avg_Day_Fatg Avg_Day_Carbohydrateg Avg_Day_Sodiummg Avg_Day_Potassiummg Avg_Day_Calciummg Avg_Day_Magnesiummg Avg_Day_Phosphorusmg Avg_Day_Ironmg Avg_Day_Coppermg Avg_Day_Chloridemg Avg_Day_Zincmg  Avg_Day_VitaminA Avg_Day_VitaminD Avg_Day_VitaminEmg Avg_Day_Thiaminmg Avg_Day_Riboflavinmg Avg_Day_Niacin Avg_Day_VitaminB6mg Avg_Day_VitaminB12 Avg_Day_Folate Avg_Day_VitaminCmg Avg_Day_FreeSugarsg Avg_Day_AOACFibreg Avg_Day_Manganesemg Avg_Day_Selenium Avg_Day_Iodine"

local nutrmilk "Avg_Energykcal_FC2 Avg_Proteing_FC2 Avg_Fatg_FC2 Avg_Carbohydrateg_FC2 Avg_Sodiummg_FC2 Avg_Potassiummg_FC2 Avg_Calciummg_FC2 Avg_Magnesiummg_FC2 Avg_Phosphorusmg_FC2 Avg_Ironmg_FC2 Avg_Coppermg_FC2 Avg_Chloridemg_FC2 Avg_Zincmg_FC2  Avg_VitaminA_FC2 Avg_VitaminD_FC2 Avg_VitaminEmg_FC2 Avg_Thiaminmg_FC2 Avg_Riboflavinmg_FC2 Avg_Niacin_FC2 Avg_VitaminB6mg_FC2 Avg_VitaminB12_FC2 Avg_Folate_FC2 Avg_VitaminCmg_FC2 Avg_FreeSugarsg_FC2 Avg_AOACFibreg_FC2 Avg_Manganesemg_FC2 Avg_Selenium_FC2 Avg_Iodine_FC2"

local n : word count `nutrients'
forvalues i = 1/`n' {
     local a : word `i' of `nutrients'
     local b : word `i' of `nutrmilk' 
     gen Prop_`b'=(`b'/`a')*100 if `a'>0 	/*If `a' is 0, Prop_`b' becomes missing, this and the next line ensures no missing values are generated*/
		replace Prop_`b'=0 if `a'==0
}

preserve
duplicates drop Cpseriala, force
svyset [pweight=SHeS_Intake24_wt_sc], psu(psu) strata(Strata)

	matrix nutrmilk = J(27, 3, .) 	
	local r=1
quietly foreach var of varlist Prop_Avg_Energykcal_FC2 Prop_Avg_Proteing_FC2 Prop_Avg_Fatg_FC2 Prop_Avg_Carbohydrateg_FC2 Prop_Avg_FreeSugarsg_FC2 Prop_Avg_AOACFibreg_FC2 Prop_Avg_Calciummg_FC2 Prop_Avg_Chloridemg_FC2 Prop_Avg_Coppermg_FC2 Prop_Avg_Iodine_FC2 Prop_Avg_Ironmg_FC2  Prop_Avg_Magnesiummg_FC2 Prop_Avg_Manganesemg_FC2 Prop_Avg_Phosphorusmg_FC2 Prop_Avg_Potassiummg_FC2 Prop_Avg_Selenium_FC2 Prop_Avg_Sodiummg_FC2 Prop_Avg_Zincmg_FC2 Prop_Avg_VitaminA_FC2 Prop_Avg_VitaminD_FC2 Prop_Avg_Thiaminmg_FC2 Prop_Avg_Riboflavinmg_FC2 Prop_Avg_Niacin_FC2 Prop_Avg_VitaminB6mg_FC2 Prop_Avg_Folate_FC2 Prop_Avg_VitaminB12_FC2 Prop_Avg_VitaminCmg_FC2 Prop_Avg_VitaminEmg_FC2 {
			
		*overall
		sum `var'
		matrix nutrmilk[`r',1]=r(N)
		svy, subpop(intake24): mean `var'
		estat sd
		matrix nutrmilk[`r',2]=r(mean) 
		matrix nutrmilk[`r',3]=r(sd) 	
		local r=`r'+1
}	

restore
matrix list nutrmilk

*Drop these variables so loops can run further down
drop Prop_Avg_*
*/

/*******************************************************************************
Calculate mean daily nutrient intakes from COLLAPSED HIGH LEVEL FOOD CATEGORIES
*******************************************************************************/
local nutrients "totmeatg Dairyg Energykcal EnergykJ Proteing Fatg Sodiummg Calciummg Phosphorusmg Ironmg Zincmg Chloridemg VitaminA VitaminD Riboflavinmg Niacin VitaminB6mg VitaminB12 Iodine Selenium" 
levelsof NewFoodCategoryCode, local(NewFoodCategoryCode) 

foreach var of varlist `nutrients' {
	foreach 1 of local NewFoodCategoryCode {
	bysort Cpseriala RecallNo: egen D_`var'_NFC`1' = sum(`var') if NewFoodCategoryCode==`1' 
	bysort Cpseriala RecallNo: egen DMax_`var'_NFC`1' = max(D_`var'_NFC`1') 
	bysort Cpseriala: egen Wk_`var'_NFC`1' = total(DMax_`var'_NFC`1') if n==1
	bysort Cpseriala: egen WkMax_`var'_NFC`1' = max(Wk_`var'_NFC`1')
	bysort Cpseriala: gen Avg_`var'_NFC`1'= (WkMax_`var'_NFC`1'/NumberOfRecalls)
	drop D_* DMax_* Wk_* WkMax* 
	}
}	


/***********************************************************
Calculate mean daily nutrient intakes from MAIN FOOD GROUPS
***********************************************************/
local nutrients "totmeatg Dairyg Energykcal EnergykJ Proteing Fatg Sodiummg Calciummg Phosphorusmg Ironmg Zincmg Chloridemg VitaminA VitaminD Riboflavinmg Niacin VitaminB6mg VitaminB12 Iodine Selenium" 
levelsof RecipeMainFoodGroupCode, local(MainFoodGroup) 

foreach var of varlist `nutrients' {
	foreach 1 of local MainFoodGroup {
	bysort Cpseriala RecallNo: egen D_`var'_`1' = sum(`var') if RecipeMainFoodGroupCode==`1' 
	bysort Cpseriala RecallNo: egen DMax_`var'_`1' = max(D_`var'_`1')
	bysort Cpseriala: egen Wk_`var'_`1' = total(DMax_`var'_`1') if n==1
	bysort Cpseriala: egen WkMax_`var'_`1' = max(Wk_`var'_`1')
	bysort Cpseriala: gen Avg_`var'_`1'= (WkMax_`var'_`1'/NumberOfRecalls)
	drop D_* DMax_* Wk_* WkMax*
	}
}	


/***********************************************************
Calculate mean daily nutrient intakes from SUB FOOD GROUPS
***********************************************************/
local nutrients "totmeatg Dairyg Energykcal EnergykJ Proteing Fatg Sodiummg Calciummg Phosphorusmg Ironmg Zincmg Chloridemg VitaminA VitaminD Riboflavinmg Niacin VitaminB6mg VitaminB12 Iodine Selenium" 
levelsof RecipeSubFoodGroupCode, local(SubFoodGroup)

foreach var of varlist `nutrients' {
	foreach 1 of local SubFoodGroup {
	bysort Cpseriala RecallNo: egen D_`var'_`1' = sum(`var') if RecipeSubFoodGroupCode=="`1'"
	bysort Cpseriala RecallNo: egen DMax_`var'_`1' = max(D_`var'_`1')
	drop D_*
	bysort Cpseriala: egen Wk_`var'_`1' = total(DMax_`var'_`1') if n==1
	drop DMax_*
	bysort Cpseriala: egen WkMax_`var'_`1' = max(Wk_`var'_`1')
	drop Wk_*
	bysort Cpseriala: gen Avg_`var'_`1'= (WkMax_`var'_`1'/NumberOfRecalls)
	drop WkMax*
	}
}


/********************************************************************
Create variables for proportion of animal types to total meat intake
********************************************************************/
ds Avg_Day_Beef Avg_Day_Lamb Avg_Day_Pork Avg_Day_Poultry Avg_Day_Game
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_TotalMeat)*100
}


/********************************************************************
Create variables for proportion of meat subtype to total meat intake
********************************************************************/
ds Avg_Day_RedMeat Avg_Day_WhiteMeat Avg_Day_ProcessedMeat
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_TotalMeat)*100
}


/*******************************************************************
Create variables for proportion of dairy types to total dairy inake
*******************************************************************/
ds Avg_Day_Milk Avg_Day_Cheese Avg_Day_Yogurt Avg_Day_Cream Avg_Day_Butter
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Dairy)*100
}


/**********************************************************************
Create variables for proportion of dairy consumed that is low/high fat
**********************************************************************/


*Total dairy
ds Avg_Day_Dairy_LF Avg_Day_Dairy_HF
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Dairy)*100
}

*Milk
ds Avg_Day_Milk_LF Avg_Day_Milk_HF
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Milk)*100
}

*Cheese
ds Avg_Day_Cheese_LF Avg_Day_Cheese_HF
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Cheese)*100
}

*Yogurt
ds Avg_Day_Yogurt_LF Avg_Day_Yogurt_HF
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Yogurt)*100
}

*Cream
ds Avg_Day_Cream_LF Avg_Day_Cream_HF
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Cream)*100
}


/***************************************************************************************
 Create variables for food group contributions (food category, main and sub food group)
 to meat and all key nutrients
***************************************************************************************/

**Meat
ds Avg_totmeatg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_TotalMeat)*100 if Avg_Day_TotalMeat>0
	replace Prop_`var'=0 if Avg_Day_TotalMeat==0
}

**Dairy
ds Avg_Dairyg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Dairy)*100 if Avg_Day_Dairy>0
	replace Prop_`var'=0 if Avg_Day_Dairy==0
}
**Energy
ds Avg_Energykcal_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Energykcal)*100 if Avg_Day_Energykcal>0
	replace Prop_`var'=0 if Avg_Day_Energykcal==0
}

**Energy (KJ)
ds Avg_EnergykJ_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_EnergykJ)*100 if Avg_Day_EnergykJ>0
	replace Prop_`var'=0 if Avg_Day_EnergykJ==0
}

**Protein
ds Avg_Proteing_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Protein)*100 if Avg_Day_Protein>0
	replace Prop_`var'=0 if Avg_Day_Protein==0
}

**Fat
ds Avg_Fatg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Fatg)*100 if Avg_Day_Fatg>0
	replace Prop_`var'=0 if Avg_Day_Fatg==0
}

**Sodium
ds Avg_Sodiummg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Sodiummg)*100 if Avg_Day_Sodiummg>0
	replace Prop_`var'=0 if Avg_Day_Sodiummg==0
}

**Calcium
ds Avg_Calciummg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Calcium)*100 if Avg_Day_Calcium>0
	replace Prop_`var'=0 if Avg_Day_Calcium==0
}

**Phosphorus
ds Avg_Phosphorusmg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Phosphorusmg)*100 if Avg_Day_Phosphorusmg>0
	replace Prop_`var'=0 if Avg_Day_Phosphorusmg==0
}

**Iron
ds Avg_Ironmg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Iron)*100 if Avg_Day_Iron>0
	replace Prop_`var'=0 if Avg_Day_Iron==0
}


**Zinc
ds Avg_Zincmg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Zinc)*100 if Avg_Day_Zinc>0
	replace Prop_`var'=0 if Avg_Day_Zinc==0
}

**Chloride
ds Avg_Chloridemg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Chloridemg)*100 if Avg_Day_Chloridemg>0
	replace Prop_`var'=0 if Avg_Day_Chloridemg==0
}

**Vitamin A
ds Avg_VitaminA_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_VitaminA)*100 if Avg_Day_VitaminA>0
	replace Prop_`var'=0 if Avg_Day_VitaminA==0
}

**Vitamin D
ds Avg_VitaminD_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_VitaminD)*100 if Avg_Day_VitaminD>0
	replace Prop_`var'=0 if Avg_Day_VitaminD==0
}

**Riboflavin
ds Avg_Riboflavinmg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Riboflavin)*100 if Avg_Day_Riboflavin>0
	replace Prop_`var'=0 if Avg_Day_Riboflavin==0
}

**Niacin
ds Avg_Niacin_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Niacin)*100 if Avg_Day_Niacin>0
	replace Prop_`var'=0 if Avg_Day_Niacin==0
}

**Vitamin B6
ds Avg_VitaminB6mg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_VitaminB6mg)*100 if Avg_Day_VitaminB6mg>0
	replace Prop_`var'=0 if Avg_Day_VitaminB6mg==0
}

**VitaminB12
ds Avg_VitaminB12_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_VitaminB12)*100 if Avg_Day_VitaminB12>0
	replace Prop_`var'=0 if Avg_Day_VitaminB12==0
}


**Iodine
ds Avg_Iodine_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Iodine)*100 if Avg_Day_Iodine>0
	replace Prop_`var'=0 if Avg_Day_Iodine==0
}


**Selenium
ds Avg_Selenium_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_Selenium)*100  if Avg_Day_Selenium>0
	replace Prop_`var'=0 if Avg_Day_Selenium==0
}


*****************
*Label variables
*****************
do "$code\SHeS 2021_Labels_manuscript.do"


*********************************
*Drop  varibles no longer needed
*********************************
drop n Dairy_Ingredients- Butter Beef_Process- redprocessedmeatg

**************
*Save Dataset
**************

*Food level dataset
save "$data\SHeS 2021_foodlevel_manuscript_$date.dta", replace

*Participant level dataset for analysis (drop duplicates and unecessary food level variables)
duplicates drop Cpseriala, force
drop FoodNumber- Butterg Day_Beef- Day_Iodine

save "$data\SHeS 2021_participantlevel__manuscript_$date.dta", replace

