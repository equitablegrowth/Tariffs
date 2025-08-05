*** County Business Patterns ***

clear

import delimited "$data/CBP`yr'.csv", varn(1)

foreach var of varlist * {
  label variable `var' "`=`var'[1]'"
}

rename ïgeo_id geo_id

drop if _n==1
drop lfo lfo_label payann_n payqtr1 payqtr1_n emp_n v*
keep if empszes=="001"
drop empszes empszes_label
destring year estab payann emp, replace

split name, parse(,) gen(place)
rename place1 county
rename place2 state
drop name naics*_label
order geo_id county state

rename naics* naics4
gen n`lvl'ind = substr(naics4, 1,`lvl')

replace n`lvl'ind = "31" if n`lvl'ind == "32" | n`lvl'ind == "33" // consolidating manufacturing codes
replace n`lvl'ind = "44" if n`lvl'ind == "45" // consolidating retail trade codes
replace n`lvl'ind = "48" if n`lvl'ind == "49" // consolidating transportation & warehousing

replace n`lvl'ind = "231" if n`lvl'ind == "236" | n`lvl'ind == "237" | n`lvl'ind == "238" // consolidating construction subsectors back into one group to keep construction in analysis at 3-digit level

bysort state county n`lvl'ind : egen totemp = total(emp)
bysort state county n`lvl'ind : egen totest = total(estab)
bysort state county n`lvl'ind : egen totpay = total(payann)
bysort state county n`lvl'ind : keep if _n==1
drop naics4 emp estab payann
rename totemp employment
rename totest establishments
rename totpay ann_payroll
destring n`lvl'ind, replace

capture drop if n3ind == 113 | n3ind == 114 | n3ind == 115 // dropping agricultural sectors not included in CES (for the sake of comparability)
capture drop if n3ind == 236 | n3ind == 237 | n3ind == 238 // dropping 3-digit construction subsectors as BEA matrices only have detail at 2-digit level construction
replace n`lvl'ind = 312 if n`lvl'ind == 316 // combining NAICS codes 312 and 316 to reflect CES combination
replace n`lvl'ind = 453 if n`lvl'ind == 442 | n`lvl'ind == 443 | n`lvl'ind == 448 | n`lvl'ind == 451 | n`lvl'ind == 454 // combining codes 442, 443, 448, 451, 453, and 454 to reflect BEA matrices combinations
replace n`lvl'ind = 487 if n`lvl'ind == 488 // combining codes 487 and 488 to reflect BEA matrices combinations
replace n`lvl'ind = 521 if n`lvl'ind == 522 // combining codes 521 and 522 to reflect BEA matrices combinations
replace n`lvl'ind = 523 if n`lvl'ind == 525 // combining NAICS codes 523 and 525 to reflect CES combination

*encode state, gen(state_num)

egen state_ind = concat(state n`lvl'ind), punct("_")

