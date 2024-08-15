
/*******************************
Modifying the dataset clslowbwt (obtained from https://www.stata-press.com/data/ishr3.html, used in  An Introduction to Stata for Health Researchers Third Edition) 
to include more variables. This dataset will be used for the 3rd assignment, which is on causal inference, within the course Biostat1 in the MSc program BDS.
******************************/

use "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Assignment2\clslowbwt.dta", clear
drop race
set seed 5284

/// Create a new identifier, the data set includes several births per woman, but we want independent data, so pretend they are from different women
drop id
gen id=_n


***
/*Add simulated variables on blood pressure, but add 1 value that is not reasonable*/
***

/// Create a binary variable for high blood pressure, with different proportions for smokers and non-smokers
gen high_bp=(runiform()<0.18) if smoke==0
replace high_bp=(runiform()<0.35) if smoke==1
tab high_bp smoke, miss chi

/// Create a continous variable for systolic blood pressure, that corresponds with the value of high_bp so that high_bp if systolic blood pressure of 135 and above
gen bp_sys=max(135,rnormal(145,7)) if high_bp==1
replace bp_sys=min(134,rnormal(115,7)) if high_bp==0
bysort high_bp: summ bp_sys, detail

/// Change 1 value to a negative value, also make sure to set missing on high_bp for that individual
replace bp_sys=-1*(bp_sys) if id==150
replace high_bp=. if id==150


***
/*Add simulated variables on premature birth and need for neonatal care*/
***

/// Create a binary variable for preterm birth, to some extent depending on birth weight
gen preterm=1 if bwt<1500
replace preterm=0 if bwt>3000
replace preterm=(runiform()<0.15) if preterm==.
tab preterm, miss

/// Create a binary variable for requiring neonatal care, where everyone preterm require care and about 2% of rest
gen neocare=preterm
replace neocare=(runiform()<0.03) if neocare==0
tab neocare preterm, miss


***
/*Save a data set that will be used as an original data file, it does not include the binary variables for low birth weight and high blood pressure*/
***
preserve
drop low high_bp 
rename lwt wt_moth
export delimited using "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Assignment2\birthweight_original.csv", nolabel replace
restore


***
/*Now create the analysis data set, it will have a couple of missing values on the outcome, also remove the continous variables birth weight and systolic blood pressure*/
***
preserve
drop bp_sys bwt
rename lwt wt_moth
replace low=. if (runiform()<0.01)
export delimited using "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Assignment2\birthweight_analysisdata.csv", nolabel replace
restore


**************************** END OF FILE **************************