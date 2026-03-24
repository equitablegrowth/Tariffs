*** County Business Patterns ***

clear

insobs 1

gen year = "`yr'"
destring year, replace

if year < 2023 {
	clear
	import delimited "$data/CBP`yr'.csv", varn(1)
}
else {
	clear
	import delimited "$data/CBP2023.csv", varn(1)
}

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

rename naics2017 naics4
gen n`lvl'ind = substr(naics4, 1,`lvl')

if `lvl' == 4 {
	replace n`lvl'ind = substr(naics4, 1, 3) if substr(naics4, 1, 1) == "1" | substr(naics4, 1, 1) == "4" | substr(naics4, 1, 1) == "5" | substr(naics4, 1, 1) == "6" | substr(naics4, 1, 1) == "7" | substr(naics4, 1, 3) == "812" | substr(naics4, 1, 3) == "813"
}
else {
	display "else"
}

replace n`lvl'ind = "31" if n`lvl'ind == "32" | n`lvl'ind == "33" // consolidating manufacturing codes
replace n`lvl'ind = "44" if n`lvl'ind == "45" // consolidating retail trade codes
replace n`lvl'ind = "48" if n`lvl'ind == "49" // consolidating transportation & warehousing

replace n`lvl'ind = "239" if n`lvl'ind == "236" | n`lvl'ind == "237" | n`lvl'ind == "238" // consolidating construction subsectors into one group to keep construction in analysis at 3-digit level

replace n`lvl'ind = "2399" if n`lvl'ind == "2361" | n`lvl'ind == "2362" | n`lvl'ind == "2371" | n`lvl'ind == "2372" | n`lvl'ind == "2373" | n`lvl'ind == "2379" | n`lvl'ind == "2381" | n`lvl'ind == "2382" | n`lvl'ind == "2383" | n`lvl'ind == "2389" // keeping construction in at 4d

bysort state county n`lvl'ind : egen totemp = total(emp)
bysort state county n`lvl'ind : egen totest = total(estab)
bysort state county n`lvl'ind : egen totpay = total(payann)
bysort state county n`lvl'ind : keep if _n==1
drop naics4 emp estab payann
rename totemp employment
rename totest establishments
rename totpay ann_payroll
destring n`lvl'ind, replace

*capture drop if n3ind == 113 | n3ind == 114 | n3ind == 115 // dropping agricultural sectors not included in CES (for the sake of comparability)
capture drop if n3ind == 236 | n3ind == 237 | n3ind == 238 // dropping 3-digit construction subsectors as BEA matrices only have detail at 2-digit level construction
capture drop if n4ind == 2361 | n4ind == 2362 | n4ind == 2371 | n4ind == 2372 | n4ind == 2373 | n4ind == 2379 | n4ind == 2381 | n4ind == 2382 | n4ind == 2383 | n4ind == 2389 // dropping 4d construction subsectors
replace n`lvl'ind = 312 if n`lvl'ind == 316 // combining NAICS codes 312 and 316 to reflect CES combination
replace n`lvl'ind = 453 if n`lvl'ind == 442 | n`lvl'ind == 443 | n`lvl'ind == 448 | n`lvl'ind == 451 | n`lvl'ind == 454 // combining codes 442, 443, 448, 451, 453, and 454 to reflect BEA matrices combinations
replace n`lvl'ind = 487 if n`lvl'ind == 488 // combining codes 487 and 488 to reflect BEA matrices combinations
replace n`lvl'ind = 521 if n`lvl'ind == 522 // combining codes 521 and 522 to reflect BEA matrices combinations
replace n`lvl'ind = 523 if n`lvl'ind == 525 // combining NAICS codes 523 and 525 to reflect CES combination

replace n`lvl'ind = 3279 if n`lvl'ind == 3274 // combining NAICS codes 3274 and 3279
replace n`lvl'ind = 3314 if n`lvl'ind == 3313 // combining NAICS codes 3313 and 3314
replace n`lvl'ind = 3326 if n`lvl'ind == 3325 // combining NAICS codes 3325 and 3326
replace n`lvl'ind = 3329 if n`lvl'ind == 3322 // combining NAICS codes 3322 and 3329
replace n`lvl'ind = 3346 if n`lvl'ind == 3343 // combining NAICS codes 3343 and 3346
replace n`lvl'ind = 3369 if n`lvl'ind == 3365 // combining NAICS codes 3365 and 3369
replace n`lvl'ind = 3372 if n`lvl'ind == 3379 // combining NAICS codes 3372 and 3379
replace n`lvl'ind = 3139 if n`lvl'ind == 3131 | n`lvl'ind == 3132 | n`lvl'ind == 3133 // combining NAICS codes 3131, 3132, 3133, and 3139
replace n`lvl'ind = 3159 if n`lvl'ind == 3151 | n`lvl'ind == 3152 // combining NAICS codes 3151, 3152, and 3159
replace n`lvl'ind = 3129 if n`lvl'ind == 3121 | n`lvl'ind == 3122 | n`lvl'ind == 3161 | n`lvl'ind == 3162 | n`lvl'ind == 3169 // combining NAICS codes 3121, 3122, 3161, 3162, and 3169

*encode state, gen(state_num)

egen state_ind = concat(state n`lvl'ind), punct("_")

egen county_state_ind = concat(county state n`lvl'ind), punct("_")

rename year CBPyear

