**********************
* Create the data and the plots for the lecture on splines
* Created by Therese M-L Andersson 2024-08-29
* It is based on an example from Paul Lamberts site https://pclambert.net/interactivegraphs/spline_eg/spline_eg
**********************



//number of data points, and set seed
local Nobs=150	
set seed 192

//define the placement of knots
local k1=0.2	
local k2=0.5
local k3=0.8

//create the x variable distributed uniformly over 0-1
clear all 		
set obs `Nobs' 
gen double x = .
local k=1
local imax=`Nobs'-1
forvalues i = 0 / `imax' {
      qui replace x = (`i'+1)/`Nobs' in `k'
	  local k=`k'+1
}


// y variable with continuous non-linear dependency on x, save the data	   
gen  y =  sin(x*10) + 0.4*rnormal()		
export delimited using "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\tmp.csv", replace


//plot data
twoway (scatter y x, sort) , legend(off) graphregion(color(white)) bgcolor(white) name(scatter, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\scatter.png", as(png) name("scatter") replace


// linear effect
regress y x
predict linxb, xb

twoway (scatter y x, sort) (line linxb x, sort), legend(off) ytitle(y) graphregion(color(white)) bgcolor(white) name(linear, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\linear.png", as(png) name("linear") replace


// polynomial degree 2
gen x2=x^2
regress y x x2
predict sqxb, xb

twoway (scatter y x, sort) (line sqxb x, sort), legend(off) ytitle(y) graphregion(color(white)) bgcolor(white) name(poly2, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\poly2.png", as(png) name("poly2") replace


//polynomial degree 3
gen x3=x^3
regress y x x2 x3
predict cubxb, xb

twoway (scatter y x, sort) (line cubxb x, sort), legend(off) ytitle(y) graphregion(color(white)) bgcolor(white) name(poly3, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\poly3.png", as(png) name("poly3") replace


// define knots
twoway (scatter y x, sort), xline(`k1' `k2' `k3') legend(off) graphregion(color(white)) bgcolor(white) ///
	ytitle(y) name(knots, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\knots.png", as(png) name("knots") replace


// piece-wise constant
gen int1=1 if x<=`k1'
gen int2=1 if x>`k1' & x<=`k2'
gen int3=1 if x>`k2' & x<=`k3'
gen int4=1 if x>`k3'
foreach var of varlist int1-int4 {
	replace `var'=0 if `var'==.
}
regress y int1 int2 int3 int4, nocons
predict piecxb, xb

twoway (scatter y x, sort) (line piecxb x if x<=0.2, sort lcolor(black)) ///
	(line piecxb x if x>0.2 & x<=0.5, sort lcolor(black)) (line piecxb x if x>0.5 & x<=0.8, sort lcolor(black)) ///
	(line piecxb x if x>0.8, sort lcolor(black)), xline(`k1' `k2' `k3') legend(off) graphregion(color(white)) bgcolor(white) ///
	ytitle(y) name(piececon, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\piececon.png", as(png) name("piececon") replace
	

// Piece-wise cubic
gen xp1=x if x<=`k1'
gen xpsq1=x^2 if x<=`k1'
gen xpcub1=x^3 if x<=`k1'
gen xp2=x if x>`k1' & x<=`k2'
gen xpsq2=x^2 if x>`k1' & x<=`k2'
gen xpcub2=x^3 if x>`k1' & x<=`k2'
gen xp3=x if x>`k2' & x<=`k3'
gen xpsq3=x^2 if x>`k2' & x<=`k3'
gen xpcub3=x^3 if x>`k2' & x<=`k3'
gen xp4=x if x>`k3'
gen xpsq4=x^2 if x>`k3'
gen xpcub4=x^3 if x>`k3'
foreach var of varlist xp? xpsq? xpcub? {
	replace `var'=0 if `var'==.
}

regress y int? xp? xpsq? xpcub? , nocons
predict pieccubxb, xb

twoway (scatter y x, sort) (line pieccubxb x if x<=0.2, sort lcolor(black)) ///
	(line pieccubxb x if x>0.2 & x<=0.5, sort lcolor(black)) (line pieccubxb x if x>0.5 & x<=0.8, sort lcolor(black)) ///
	(line pieccubxb x if x>0.8, sort lcolor(black)), xline(`k1' `k2' `k3') legend(off) graphregion(color(white)) bgcolor(white) ///
	ytitle(y) name(piececub, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\piececub.png", as(png) name("piececub") replace


// Alternative Piece-wise cubic	
gen cons=1
gen xa4=(x>`k1')
gen xa5=max(0,x-`k1')
gen xa6=max(0,x-`k1')^2
gen xa7=max(0,x-`k1')^3
gen xa8=(x>`k2')
gen xa9=max(0,x-`k2')
gen xa10=max(0,x-`k2')^2
gen xa11=max(0,x-`k2')^3
gen xa12=(x>`k3')
gen xa13=max(0,x-`k3')
gen xa14=max(0,x-`k3')^2
gen xa15=max(0,x-`k3')^3

regress y cons x x2 x3 xa4-xa15, nocons


// Cubic spline
regress y cons x x2 x3 xa7 xa11 xa15, nocons
predict cubsplxb, xb

twoway (scatter y x, sort) (line cubsplxb x , sort lcolor(black)) , xline(`k1' `k2' `k3') legend(off) graphregion(color(white)) bgcolor(white) ///
	ytitle(y) name(cubspl, replace)
graph export "C:\Users\theand\OneDrive - Karolinska Institutet\BDS\Biostat1\Temp\Splines\cubspl.png", as(png) name("cubspl") replace



******************************************** END OF FILE ********************************
	
	*gensplines x, intercept knots(0.2,0.5,0.8) type(bs) gen(bs)   
	*gensplines x, intercept knots(0.2,0.5,0.8) type(ns) gen(ns)