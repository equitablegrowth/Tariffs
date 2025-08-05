** Cleaning CES employment data **
** see ce.industry.txt file **


use "$data/ces.dta", clear

drop if mdate < tm(`yr'm1) | mdate > tm(`yr'm12)

drop if data_type != 1

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

expand 2 if industry == "220000", gen(newv)
replace industry = "221000" if newv==1
drop newv
*replace industry = "221000" if industry == "221100" | industry == "221110" | industry == "221112" | industry == "221118" | industry == "221120" | industry == "221121" | industry == "221122" | industry == "221200" | industry == "221300" // producing NAICS code 221

expand 2 if industry == "230000", gen(newv) // producing code 231, equivalent to 23, intended to keep construction in analysis at 3-digit level
replace industry = "231000" if newv==1
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

keep if naics`lvl'tst == 0

drop naics*

gen naics`lvl'tst = substr(industry, `lvl', 1)
destring naics`lvl'tst, replace
keep if naics`lvl'tst != 0
drop naics`lvl'tst

gen n`lvl'ind = substr(industry, 1, `lvl')
destring n`lvl'ind, replace

capture replace n`lvl'ind = 312 if n`lvl'ind == 329 // combines NAICS codes 312 and 316 -- CES crosswalk requires combination -- see ce.industry.txt

capture replace n`lvl'ind = 446 if n`lvl'ind == 456 // assigning 2017 code for Health & Personal Care Stores
capture replace n`lvl'ind = 447 if n`lvl'ind == 457 // assigning 2017 code for Gasoline Stations
capture replace n`lvl'ind = 452 if n`lvl'ind == 455 // assigning 2017 code for General Merchandise
capture replace n`lvl'ind = 442 if n`lvl'ind == 449 // assigning 2017 Furniture and Home Furnishings Stores code -- 449 also includes 2017 code 443, Electronics and Appliance Stores
capture replace n`lvl'ind = 453 if n`lvl'ind == 442 | n`lvl'ind == 458 | n`lvl'ind == 459 // consolidating remaining retail codes to reflect CES combinations (2017 codes 442 and 443 into 2022 code 449) and BEA matrices combinations (2017 codes 442, 443, 451, and 453)
capture replace n`lvl'ind = 487 if n`lvl'ind == 488 // combining codes 487 and 488 to reflect BEA matrices combinations

capture replace n`lvl'ind = 511 if n`lvl'ind == 513 // assigning 2017 code for Publishing Industries (2017 code explicitly excludes internet)
capture replace n`lvl'ind = 515 if n`lvl'ind == 516 // assigning 2017 code for Broadcasting (2017 code explicitly excludes internet, while 2022 code includes "Content Providers")
capture replace n`lvl'ind = 521 if n`lvl'ind == 522 // combining codes 521 and 522 to reflect BEA matrices combinations
capture drop if n3ind == 236 | n3ind == 237 | n3ind == 238 // dropping 3-digit construction subsectors as BEA matrices only have detail at 2-digit level construction

capture drop if n`lvl'ind==3279 | n`lvl'ind==3314 | n`lvl'ind==3326 | n`lvl'ind==4855 | n`lvl'ind==4899 | n`lvl'ind==5178 | n`lvl'ind==5232 | n`lvl'ind==5239 | n`lvl'ind==6113 | n`lvl'ind==7113


drop sector industry data_type month

bysort n`lvl'ind : egen avgemp = mean(value)
sort n`lvl'ind mdate
bysort n`lvl'ind : keep if _n == 1
drop mdate year value


capture drop if n4ind == 9100 | n4ind == 9200 | n4ind == 9300

capture drop if n3ind == 911 | n3ind == 922 | n3ind == 932

capture drop if n2ind == 91 | n2ind == 92 | n2ind == 93



