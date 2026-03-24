*** Tariffs - real effective rates ***

clear all

global data "/home/cbangertdrowns/public_projects/Tariffs"

import excel "$data/Monthly customs and duties `yr'.xlsx", sheet(Customs Value) firstrow

rename NAICNumber naics_num
rename Year year
rename Month month
rename Description description
rename CustomsValue customs_val
rename Country country
replace country = strrtrim(country)
drop if naics_num == ""
drop DataType

destring customs_val, replace

save "$data/Import customs value.dta", replace

clear

import excel "$data/Monthly customs and duties `yr'.xlsx", sheet(Calculated Duties) firstrow

rename NAICNumber naics_num
rename Year year
rename Month month
rename Description description
rename CalculatedDuties duties_val
rename Country country
replace country = strrtrim(country)
drop if naics_num == ""
drop DataType

destring duties_val, replace

merge 1:1 naics_num month country using "$data/Import customs value.dta"

drop _merge

merge m:1 country using "$data/country list encoded.dta"

drop if _merge != 3
drop _merge

merge m:1 naics_num using "$data/BEA USITC commodity cross walk.dta"

drop flag note _merge description

rename bea_num code

bysort country month code : egen com_duties_val = total(duties_val)
bysort country month code : egen com_customs_val = total(customs_val)
bysort country month code : keep if _n == 1

keep country country_num year month com_duties_val com_customs_val code

bysort country month code : gen eff_tariff = com_duties_val / com_customs_val

bysort country month : egen country_duties = total(com_duties_val)
bysort country month : egen country_customs = total(com_customs_val)
bysort country month : gen country_eff_tariff = country_duties / country_customs

bysort code month : egen com_duties = total(com_duties_val)
bysort code month : egen com_customs = total(com_customs_val)
bysort code month : gen com_eff_tariff = com_duties / com_customs

gen country_frac = com_customs_val / com_customs

save "$data/country-commodity effective rates `yr'.dta", replace

preserve
bysort country month : keep if _n == 1
keep country year month country_num country_eff_tariff country_customs country_duties
save "$data/country effective rates `yr'.dta", replace
restore

bysort code month : keep if _n == 1
keep code year month com_eff_tariff com_customs com_duties
save "$data/commodity effective rates `yr'.dta", replace

drop if code == "" // codes that appear in USITC data but not BEA import data; correspond to Goods Returned (exports For Canada Only) and Other Special Classification Provisions


drop com_duties com_customs year
reshape wide com_eff_tariff, i(code) j(month)

rename code com_detail









