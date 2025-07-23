*** Tariff graphics ***

** 3d industries by employment and import exposure **

keep n3ind ind_impshare avgemp
bysort n3ind : keep if _n == 1
export delimited "$data/3d industries by employment and import exposure.csv", replace

** 3d industries by import exposure and state employment **

keep state state_num n3ind ind_impshare total_employment
bysort state_num n3ind : keep if _n == 1

bysort state_num : egen state_emp = total(total_employment)
gen ind_empshare = total_employment / state_emp
gen state_ind_score = ind_impshare*ind_empshare
bysort state_num : egen state_score = total(state_ind_score)
keep state state_score
bysort state : keep if _n == 1
drop if state_score == 0

replace state_score = state_score*100

gen cat = 1
replace cat = 2 if state_score > 5.75 & state_score < 6.00
replace cat = 3 if state_score > 6.00 & state_score < 6.25
replace cat = 4 if state_score > 6.25 & state_score < 6.50
replace cat = 5 if state_score > 6.50

export delimited "$data/State employment exposure score.csv", replace

** 3d manufacturing industries by employment and import exposure **

keep n3ind ind_impshare avgemp
bysort n3ind : keep if _n == 1
keep if n3ind > 300 & n3ind < 400
export delimited "$data/3d manufacturing industries by employment and import exposure.csv", replace

** 3d industries by employment and tariff cost as a percent of imports and total inputs **

drop impvalue*

egen ind_com = concat(n3ind n3com), punct("_")
reshape long fracimpvalue, i(ind_com) j(country_num)

gen country_ind_impshare = fracimpvalue*impshare
gen country_ind_valimp = fracimpvalue*valimp

bysort n3ind country_num : egen total_country_ind_valimp = total(country_ind_valimp)
bysort n3ind country_num : keep if _n == 1
keep n3ind country_num avgemp total_country_ind_valimp total_ind_imp total_ind_use ind_impshare

merge m:1 country_num using "$data/tariff rate sheet updated 7.21.dta"
drop _merge
sort country_num n3ind

replace tar_rate = 0.3 if eu_flag == 1
replace tar_rate = 0.34 if chn_flag == 1
gen add_cost = total_country_ind_valimp*tar_rate

bysort n3ind : egen tot_add_cost = total(add_cost)
bysort n3ind : egen chn_add_cost = total(add_cost) if chn_flag == 1
bysort n3ind : egen eu_add_cost = total(add_cost) if eu_flag == 1
bysort n3ind : egen oth_add_cost = total(add_cost) if other_flag == 1

foreach v in chn_flag eu_flag other_flag {
	preserve
	keep if `v' == 1
	bysort n3ind : keep if _n == 1
	tempfile `v'_costs
	save ``v'_costs', replace
	restore
}

use `chn_flag_costs', clear
append using `eu_flag_costs'
append using `other_flag_costs'

keep n3ind avgemp ind_impshare total_ind_imp total_ind_use tot_add_cost chn_add_cost eu_add_cost oth_add_cost *flag
sort n3ind 

bysort n3ind : egen chn_cost = total(chn_add_cost)
drop chn_add_cost
bysort n3ind : egen eu_cost = total(eu_add_cost)
drop eu_add_cost
bysort n3ind : egen oth_cost = total(oth_add_cost)
drop oth_add_cost

bysort n3ind : keep if _n == 1

gen tot_add_cost_fracimp = tot_add_cost / total_ind_imp
gen chn_cost_fracimp = chn_cost / total_ind_imp
gen eu_cost_fracimp = eu_cost / total_ind_imp
gen oth_cost_fracimp = oth_cost / total_ind_imp

gen tot_add_cost_fracinputs = tot_add_cost / total_ind_use
gen chn_cost_fracinputs = chn_cost / total_ind_use
gen eu_cost_fracinputs = eu_cost / total_ind_use
gen oth_cost_fracinputs = oth_cost / total_ind_use

drop if n3ind == .

export delimited "$data/tariff costs by n3ind.csv", replace
