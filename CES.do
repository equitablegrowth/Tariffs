** Cleaning CES employment data **
** see ce.industry.txt file **

use "$data/ces.dta", clear

drop if year < `yr' | year > `yr'

gen data_type = substr(series_id, 12, 2)
drop if data_type != "01"

gen sa = substr(series_id, 3, 1)
gen sector = substr(series_id, 4, 2)
gen industry = substr(series_id, 6, 6)
gen month = substr(period, 2, 2)
destring month, replace
destring value, replace

drop if month == 13
sort industry sector

replace industry = "230000" if industry == "000000" & sector == "20"
drop if industry == "000000" & sector == "31"
drop if industry == "000000" & sector == "32"
replace industry = "310000" if industry == "000000" & sector == "30"
replace industry = "440000" if industry == "000000" & sector == "42"
replace industry = "480000" if industry == "000000" & sector == "43"
replace industry = "510000" if industry == "000000" & sector == "50"
replace industry = "810000" if industry == "000000" & sector == "80"

replace industry = "312000" if industry == "329000"

expand 2 if industry == "312000", gen(newv)
replace industry = "312900" if newv==1 // producing code 3129 to keep in 4d
drop newv
drop if industry == "329900" | industry == "329100"

expand 2 if industry == "211000", gen(newv) // producing code 2111 to keep oil and gas extraction in analysis at 4-digit level
replace industry = "211100" if newv==1
drop newv

expand 2 if industry == "213000", gen(newv) // producing code 2131 to keep in 4d
replace industry = "213100" if newv==1
drop newv

expand 2 if industry == "220000", gen(newv)
replace industry = "221000" if newv==1
drop newv
*replace industry = "221000" if industry == "221100" | industry == "221110" | industry == "221112" | industry == "221118" | industry == "221120" | industry == "221121" | industry == "221122" | industry == "221200" | industry == "221300" // producing NAICS code 221

expand 2 if industry == "230000", gen(newv) // producing code 239, equivalent to 23, intended to keep construction in analysis at 3-digit level
replace industry = "239000" if newv==1
drop newv
drop if substr(industry, 1, 3) == "236" | substr(industry, 1, 3) == "237" | substr(industry, 1, 3) == "238"

expand 2 if industry == "239000", gen(newv) // producing code 2399
replace industry = "239900" if newv==1
drop newv

expand 2 if industry == "313000", gen(newv) // producing code 3139, intended to keep 313 in analysis at 4-digit level
replace industry = "313900" if newv==1
drop newv
drop if industry == "313200"

expand 2 if industry == "315000", gen(newv) // producing code 3159
replace industry = "315900" if newv==1
drop newv
drop if industry == "315250"

expand 2 if industry == "323000", gen(newv) // producing code 3231
replace industry = "323100" if newv==1
drop newv

expand 2 if industry == "324000", gen(newv) // producing code 3241
replace industry = "324100" if newv==1
drop newv

expand 2 if industry == "540000", gen(newv) // producing code 541
replace industry = "541000" if newv==1
drop newv

expand 2 if industry == "550000", gen(newv) // producing code 551
replace industry = "551000" if newv==1
drop newv

expand 2 if industry == "610000", gen(newv) // producing code 611
replace industry = "611000" if newv==1
drop newv

gen naics56 = substr(industry, 5, 2)
destring naics56, replace
drop if naics56 != 0

gen naics1 = substr(industry, 1, 1)
destring naics1, replace
drop if naics1 == 0

order industry year month value
sort industry year month

drop if sa == "U"
drop naics56 naics1 sa footnote_codes //series_id

gen naics2tst = substr(industry, 3, 1)
destring naics2tst, replace
gen naics3tst = substr(industry, 4, 1)
destring naics3tst, replace
gen naics4tst = substr(industry, 5, 1)
destring naics4tst, replace

if `lvl' == 2 | `lvl' == 3 {
	keep if naics`lvl'tst == 0
	
	drop naics*

	gen naics`lvl'tst = substr(industry, `lvl', 1)
	destring naics`lvl'tst, replace
	keep if naics`lvl'tst != 0
	drop naics`lvl'tst

	gen n`lvl'ind = substr(industry, 1, `lvl')
	destring n`lvl'ind, replace
}
else {
	keep if (naics3tst != 0 & (substr(industry, 1, 1) == "2" | substr(industry, 1, 1) == "3" | substr(industry, 1, 3) == "811")) | (naics3tst == 0 & (substr(industry, 1, 1) == "1" | substr(industry, 1, 1) == "4" | substr(industry, 1, 1) == "5" | substr(industry, 1, 1) == "6" | substr(industry, 1, 1) == "7" | substr(industry, 1, 3) == "812" | substr(industry, 1, 3) == "813"))
	
	keep if naics2tst != 0
		
	drop if naics3tst == 0 & (substr(industry, 1, 1) == "2" | substr(industry, 1, 1) == "3" | substr(industry, 1, 1) == "811")
	
	drop naics*
	
	replace industry = substr(industry, 1, 3) if substr(industry, 4, 1) == "0"
	
	gen n`lvl'ind = substr(industry, 1, `lvl')
	destring n`lvl'ind, replace
}

capture replace n`lvl'ind = 312 if n`lvl'ind == 329 // combines NAICS codes 312 and 316 -- CES crosswalk requires combination -- see ce.industry.txt

capture replace n`lvl'ind = 446 if n`lvl'ind == 456 // assigning 2017 code for Health & Personal Care Stores
capture replace n`lvl'ind = 447 if n`lvl'ind == 457 // assigning 2017 code for Gasoline Stations
capture replace n`lvl'ind = 448 if n`lvl'ind == 458 // assigning 2017 code for Clothing Stores
capture replace n`lvl'ind = 452 if n`lvl'ind == 455 // assigning 2017 code for General Merchandise
capture replace n`lvl'ind = 442 if n`lvl'ind == 449 // assigning 2017 Furniture and Home Furnishings Stores code -- 449 also includes 2017 code 443, Electronics and Appliance Stores
capture replace n`lvl'ind = 453 if n`lvl'ind == 442 | n`lvl'ind == 458 | n`lvl'ind == 459 | n`lvl'ind == 448 // consolidating remaining retail codes to reflect CES combinations (2017 codes 442 and 443 into 2022 code 449) and BEA matrices combinations (2017 codes 442, 443, 451, and 453)
capture replace n`lvl'ind = 487 if n`lvl'ind == 488 // combining codes 487 and 488 to reflect BEA matrices combinations

capture replace n`lvl'ind = 511 if n`lvl'ind == 513 // assigning 2017 code for Publishing Industries (2017 code explicitly excludes internet)
capture replace n`lvl'ind = 515 if n`lvl'ind == 516 // assigning 2017 code for Broadcasting (2017 code explicitly excludes internet, while 2022 code includes "Content Providers")
capture replace n`lvl'ind = 521 if n`lvl'ind == 522 // combining codes 521 and 522 to reflect BEA matrices combinations

*capture drop if n`lvl'ind==3279 | n`lvl'ind==3314 | n`lvl'ind==3326 | n`lvl'ind==4855 | n`lvl'ind==4899 | n`lvl'ind==5178 | n`lvl'ind==5232 | n`lvl'ind==5239 | n`lvl'ind==6113 | n`lvl'ind==7113


drop sector industry data_type

bysort n`lvl'ind month : egen emp = total(value)
bysort n`lvl'ind month : keep if _n == 1

bysort n`lvl'ind : egen avgemp = mean(value)
sort n`lvl'ind month
rename emp monthlyemp
drop year period value


capture drop if n4ind == 9100 | n4ind == 9200 | n4ind == 9300

capture drop if n3ind == 911 | n3ind == 922 | n3ind == 932

capture drop if n2ind == 91 | n2ind == 92 | n2ind == 93



