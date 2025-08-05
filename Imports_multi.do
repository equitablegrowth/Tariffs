** Dataset with imports from multiple countries **

clear

import delimited "$data/US imports by state and country of origin, `yr'.csv", varnames(4)

rename customsvaluegenus impvalue

gen n4com = substr(commodity, 1, 4)
gen n3com = substr(commodity, 1, 3)
gen n2com = substr(commodity, 1, 2)
drop commodity

replace n`lvl'com = "31" if n`lvl'com == "32" | n`lvl'com == "33" // consolidating manufacturing codes

replace n`lvl'com = "453" if n`lvl'com == "442" | n`lvl'com == "443" | n`lvl'com == "451" // combining codes 442, 443, 451, and 453 to reflect BEA matrices combinations
replace n`lvl'com = "487" if n`lvl'com == "488" // combining codes 487 and 488 to reflect BEA matrices combinations
replace n`lvl'com = "521" if n`lvl'com == "522" // combining codes 521 and 522 to reflect BEA matrices combinations

replace state = "District of Columbia" if state == "Dist of Columbia"

destring n`lvl'com, replace

split impvalue, parse(,) gen(valpart)
gen valuenum = valpart1 + valpart2 + valpart3 + valpart4
drop impvalue
rename valuenum impvalue
destring impvalue, replace

keep state country time n`lvl'com impvalue

bysort state country n`lvl'com : egen value`lvl' = total(impvalue)
bysort state country n`lvl'com : keep if _n == 1
drop impvalue
rename value`lvl' impvalue

capture drop if n4com == 9100 | n4com == 9200 | n4com == 9300 | n4com == 9800 | n4com == 9900 // codes that appear in USA Trade Online data but not BEA import data; correspond to Waste and Scrap, Used or Second-hand Merchandise, Goods Returned (exports For Canada Only), and Other Special Classification Provisions

capture drop if n3com == 910 | n3com == 920 | n3com == 930 | n3com == 980 | n3com == 990

capture drop if n2com == 91 | n2com == 92 | n2com == 93 | n2com == 98 | n2com == 99

drop if country == "Cuba"

*insobs 1
*gen cuba_flag = 0
*replace cuba_flag = 1 if country == "Cuba"
*egen total_cuba = total(cuba_flag)

*replace country = "Cuba" if impvalue == . & total_cuba == 0
*drop if impvalue == . & total_cuba == 1
*drop total_cuba

encode state, gen(state_num)
encode country, gen(country_num)
drop country

bysort state n`lvl'com : egen totalimp = total(impvalue)

forvalues n = 1/54 {
	preserve
	keep if state_num == `n'
	reshape wide impvalue, i(n`lvl'com) j(country_num)
	order state state_num time n`lvl'com totalimp
	tempfile impfile`n'
	save `impfile`n'', replace
	restore
}

use `impfile1', clear

forvalues n = 2/54 {
	append using `impfile`n''
}


sort n`lvl'com state_num





