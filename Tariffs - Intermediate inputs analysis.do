*** Tariffs - Intermediate Inputs & Employment ***

clear all

global data "/home/cbangertdrowns/public_projects/Tariffs"
local usgeo national // level of US geographic detail; options are national, state, or county
local lvl 3 // level of NAICS detail; options are 2 or 3
local yr 2024 // year of import and employment data; options are 2017-2022 for state/county detail, 2017-2024 for national detail


include "$data/Matrices.do" // running and saving crosswalk of BEA input-output data at desired `lvl' of NAICS detail
save "$data/intermediate_use_merged.dta", replace

clear

insobs 1

gen usgeo = "`usgeo'" // cleaning and saving relevant employment data for desired `yr' and `lvl' of NAICS industrial detail -- Current Employment Statistics for national detail; County Business Patterns for state or county detail
if usgeo == "national" {
	clear
	include "$data/CES.do"
	save "$data/ces_cleaned.dta", replace
}
else {
	if usgeo == "county" {
		clear
		include "$data/County Business Patterns.do"
		save "$data/CBP_naics`lvl'.dta", replace
	}
	else {
		clear
		include "$data/County Business Patterns.do"
		bysort state_ind : egen total_employment = total(employment)
		bysort state_ind : egen total_estab = total(establishments)
		bysort state_ind : egen total_payroll = total(ann_payroll)
		bysort state_ind : keep if _n == 1
		drop county geo_id employment establishments ann_payroll
		save "$data/CBP_naics`lvl'.dta", replace
	}
}

clear

include "$data/Imports_multi.do" // cleaning and saving import data desired `yr' and`lvl' of NAICS commodity detail
save "$data/intermediate_imports.dta", replace

clear

insobs 1
gen usgeo = "`usgeo'" // code to compile desired dataset, depending on level of geographic detail
if usgeo == "national" {
	use "$data/intermediate_imports.dta", clear
	bysort n`lvl'com : egen imp_nat = total(totalimp)
	foreach v of varlist impvalue* {
		bysort n`lvl'com : egen total`v' = total(`v')
	}
	drop totalimp impvalue*
	bysort n`lvl'com : keep if _n == 1
	drop state state_num
	rename imp_nat totalimp
	rename totalimpvalue* impvalue*
	foreach v of varlist impvalue* {
		bysort n`lvl'com : gen frac`v' = `v'/totalimp
	}
	merge 1:m n`lvl'com using "$data/intermediate_use_merged.dta"
	*keep if _merge == 3 // running this line will delete matrices data for commodities with no Census import data
	drop _merge
	merge m:1 n`lvl'ind using "$data/ces_cleaned.dta"
	capture drop if n2ind == 11 // dropping agricultural sector not included in CES
	capture drop if n3ind == 111 | n3ind == 112 // dropping agricultural sectors not included in CES
	order n`lvl'ind n`lvl'com impshare com_impshare com_indshare totalimp valuse valimp total_com_use total_com_imp avgemp
	sort n`lvl'com n`lvl'ind
	drop _merge
	
	bysort n`lvl'ind : egen total_ind_imp_tarexp = total(valimp) if totalimp != .
	gen ind_tarexp = total_ind_imp_tarexp / total_ind_use
	order n`lvl'ind n`lvl'com impshare ind_impshare ind_tarexp total_ind_use total_ind_imp total_ind_imp_tarexp
	
	// chunk to compare bea and census import totals
	*preserve
	*bysort n`lvl'com : egen totalbea = total(valimp)
	*bysort n`lvl'com : keep if _n == 1
	*rename totalimp totalcensus
	*keep n`lvl'com totalbea totalcensus
	*export delimited "$data/bea_census import comparison.csv", replace
	*restore
}
else {
	if usgeo == "state" {
		use "$data/intermediate_imports.dta", clear
		forvalues n = 1/54 {
			preserve
			keep if state_num == `n'
			foreach v of varlist impvalue* {
				replace `v' = 0 if `v' == .
			}
			foreach v of varlist impvalue* {
				bysort n`lvl'com : gen frac`v' = `v'/totalimp
			}
			*reshape long
			*bysort n`lvl'com : gen fracimp = impvalue/totalimp
			*drop impvalue
			*reshape wide fracimp, i(n`lvl'com) j(country_num)
			merge 1:m n`lvl'com using "$data/intermediate_use_merged.dta"
			order state state_num n`lvl'com n`lvl'ind valuse valimp impshare totalimp
			sort n`lvl'com n`lvl'ind
			bysort n`lvl'ind : egen total_ind_imp_tarexp = total(valimp) if totalimp != .
			gen ind_tarexp = total_ind_imp_tarexp / total_ind_use
			keep if _merge == 3 // running this line will delete matrices data for commodities with no Census import data
			drop _merge
			egen state_ind = concat(state n`lvl'ind), punct("_")
			tempfile state_impfile`n'
			save `state_impfile`n'', replace
			restore
		}
		use `state_impfile1', clear
		forvalues n = 2/54 {
			append using `state_impfile`n''
		}
		merge m:1 state_ind using "$data/CBP_naics`lvl'.dta"
		*keep if _merge == 3
		sort state n`lvl'ind n`lvl'com
		order state state_num n`lvl'ind n`lvl'com valuse valimp impshare 
	}
	else{
		use "$data/intermediate_imports.dta", clear
		forvalues n = 1/54 {
			preserve
			keep if state_num == `n'
			foreach v of varlist impvalue* {
				replace `v' = 0 if `v' == .
			}
			foreach v of varlist impvalue* {
				bysort n`lvl'com : gen frac`v' = `v'/totalimp
			}
			*reshape long
			*bysort n`lvl'com : gen fracimp = impvalue/totalimp
			*drop impvalue
			*reshape wide fracimp, i(n`lvl'com) j(country_num)
			merge 1:m n`lvl'com using "$data/intermediate_use_merged.dta"
			order state state_num n`lvl'com n`lvl'ind valuse valimp impshare totalimp
			sort n`lvl'com n`lvl'ind
			bysort n`lvl'ind : egen total_ind_imp_tarexp = total(valimp) if totalimp != .
			gen ind_tarexp = total_ind_imp_tarexp / total_ind_use
			keep if _merge == 3 // running this line will delete matrices data for commodities with no Census import data -- deleting for the sake of efficiency; ind_tarexp is produced here
			drop _merge
			egen state_ind = concat(state n`lvl'ind), punct("_")
			tempfile state_impfile`n'
			save `state_impfile`n'', replace
			restore
		}
		clear
		insobs 1
		gen com_detail = "`lvl'"
		if com_detail == "2" {
			forvalues n = 1/54 {
				use `state_impfile`n'', clear
				sort n`lvl'ind n`lvl'com
				bysort n`lvl'ind : gen com_num = _n
				forvalues c = 1/3 {
					preserve
					keep if com_num == `c'
					merge 1:m state_ind using "$data/CBP_naics`lvl'.dta"
					keep if _merge == 3
					drop _merge
					tempfile state`n'_com`c'
					save `state`n'_com`c'', replace
					restore
				}
				use `state`n'_com1', clear
				forvalues c = 2/3 {
					append using `state`n'_com`c''
				}
				save `state_impfile`n'', replace
			}
			use `state_impfile1', clear
			forvalues n = 2/54 {
				append using `state_impfile`n''
			}
			sort state county n`lvl'ind n`lvl'com
			order state state_num county n`lvl'ind n`lvl'com valuse valimp impshare
		}
		else {
			if com_detail == "3" {
				forvalues n = 1/54 {
					use `state_impfile`n'', clear
					sort n`lvl'ind n`lvl'com
					bysort n`lvl'ind : gen com_num = _n
					forvalues c = 1/28 {
						preserve
						keep if com_num == `c'
						merge 1:m state_ind using "$data/CBP_naics`lvl'.dta"
						keep if _merge == 3
						drop _merge
						tempfile state`n'_com`c'
						save `state`n'_com`c'', replace
						restore
					}
					use `state`n'_com1', clear
					forvalues c = 2/28 {
						append using `state`n'_com`c''
					}
					save `state_impfile`n'', replace
				}
				use `state_impfile1', clear
				forvalues n = 2/54 {
					append using `state_impfile`n''
				}
				sort state county n`lvl'ind n`lvl'com
				order state state_num county n`lvl'ind n`lvl'com valuse valimp impshare
			}
			else {
				display "TBD"
			}
		}
	}
}

*** Labeling variables -- asterisks next to labels with some variation from 2017 NAICS (either name change or some type of aggregation; see Tariff intermediate analysis industry codes spreadsheet)

label variable impshare "Imported fraction of n`lvl'ind's use of n`lvl'com (valimp/valuse)"
label variable com_impshare "Average imported fraction of n`lvl'com among all industries in this dataset (total_com_imp/total_com_use)"
label variable com_indshare "Fraction of total n`lvl'com imports used by n`lvl'ind (valimp/total_com_imp)"
label variable totalimp "Total value of n`lvl'com imports in desired year, dollars (USA Trade Online import data)"
label variable valuse "Total value of n`lvl'com used by n`lvl'ind in BEA's 2017 benchmark input-output table, millions of dollars"
label variable valimp "Total value of n`lvl'com imported by n`lvl'ind in BEA's 2017 benchmark input-output table, millions of dollars"
label variable total_com_use "Total use of n`lvl'com among all industries in this dataset, millions of dollars (BEA 2017 I-O benchmark)"
label variable total_com_imp "Total imports of n`lvl'com among all industries in this dataset, millions of dollars (BEA 2017 I-O benchmark)"

label variable n`lvl'ind "NAICS industrial detail"

label def n2ind 21 "Mining, Quarrying, and Oil and Gas Extraction"
label def n2ind 22 "Utilities", add
label def n2ind 23 "Construction", add
label def n2ind 31 "Manufacturing*", add
label def n2ind 42 "Wholesale Trade", add
label def n2ind 44 "Retail Trade*", add
label def n2ind 48 "Transportation and Warehousing*", add
label def n2ind 51 "Information", add
label def n2ind 52 "Finance and Insurance", add
label def n2ind 53 "Real Estate and Rental and Leasing", add
label def n2ind 54 "Professional, Scientific, and Technical Services", add
label def n2ind 55 "Management of Companies and Enterprises", add
label def n2ind 56 "Administrative and Support and Waste Management and Remediation Services", add
label def n2ind 61 "Educational Services", add
label def n2ind 62 "Health Care and Social Assistance", add
label def n2ind 71 "Arts, Entertainment, and Recreation", add
label def n2ind 72 "Accommodation and Food Services", add
label def n2ind 81 "Other Services (except Public Administration)", add

label def n3ind 211 "Oil and Gas Extraction"
label def n3ind 212 "Mining (except Oil and Gas)", add
label def n3ind 213 "Support Activities for Mining", add
label def n3ind 221 "Utilities", add
label def n3ind 231 "Construction*", add
label def n3ind 311 "Food Manufacturing", add
label def n3ind 312 "Beverage, Tobacco, and Leather and Allied Product Manufacturing*", add
label def n3ind 313 "Textile Mills",add
label def n3ind 314 "Textile Product Mills", add
label def n3ind 315 "Apparel Manufacturing", add
label def n3ind 321 "Wood Product Manufacturing", add
label def n3ind 322 "Paper Manufacturing", add
label def n3ind 323 "Printing and Related Support Activities", add
label def n3ind 324 "Petroleum and Coal Products Manufacturing", add
label def n3ind 325 "Chemical Manufacturing", add
label def n3ind 326 "Plastics and Rubber Products Manufacturing", add
label def n3ind 327 "Nonmetallic Mineral Product Manufacturing", add
label def n3ind 331 "Primary Metal Manufacturing", add
label def n3ind 332 "Fabricated Metal Product Manufacturing", add
label def n3ind 333 "Machinery Manufacturing", add
label def n3ind 334 "Computer and Electronic Product Manufacturing", add
label def n3ind 335 "Electrical Equipment, Appliance, and Component Manufacturing", add
label def n3ind 336 "Transportation Equipment Manufacturing", add
label def n3ind 337 "Furniture and Related Product Manufacturing", add
label def n3ind 339 "Miscellaneous Manufacturing", add
label def n3ind 423 "Merchant Wholesalers, Durable Goods", add
label def n3ind 424 "Merchant Wholesalers, Nondurable Goods", add
label def n3ind 425 "Wholesale Trade Agents and Brokers*", add
label def n3ind 441 "Motor Vehicle and Parts Dealers", add
label def n3ind 444 "Building Material and Garden Equipment and Supplies Dealers", add
label def n3ind 445 "Food and Beverage Stores/Retailers*", add
label def n3ind 446 "Health and Personal Care Stores/Retailers*", add
label def n3ind 447 "Gasoline Stations/ Fuel Dealers*", add
label def n3ind 452 "General Merchandise Stores/Retailers*", add
label def n3ind 453 "Other Stores/Retailers*", add
label def n3ind 481 "Air Transportation", add
label def n3ind 482 "Rail Transportation", add
label def n3ind 483 "Water Transportation", add
label def n3ind 484 "Truck Transportation", add
label def n3ind 485 "Transit and Ground Passenger Transportation", add
label def n3ind 486 "Pipeline Transportation", add
label def n3ind 487 "Scenic and Sightseeing Transportationg and Support Activities*", add
label def n3ind 492 "Couriers and Messengers", add
label def n3ind 493 "Warehousing and Storage", add
label def n3ind 511 "Publishing Industries*", add
label def n3ind 512 "Motion Picture and Sound Recording Industries", add
label def n3ind 515 "Broadcasting*", add
label def n3ind 517 "Telecommunications", add
label def n3ind 518 "Data Processing, Hosting, and Related Services", add
label def n3ind 519 "Other Information Services*", add
label def n3ind 521 "Monetary Authorities and Credit Intermediaion and Related Activities*", add
label def n3ind 523 "Securities, Commodity Contracts, Funds, Trusts, and other Financial*", add
label def n3ind 524 "Insurance Carriers and Related Activities", add
label def n3ind 531 "Real Estate", add
label def n3ind 532 "Rental and Leasing Services", add
label def n3ind 533 "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", add
label def n3ind 541 "Professional, Scientific, and Technical Services", add
label def n3ind 551 "Management of Companies and Enterprises", add
label def n3ind 561 "Administrative and Support Services", add
label def n3ind 562 "Waste Management and Remediation Services", add
label def n3ind 611 "Educational Services", add
label def n3ind 621 "Ambulatory Health Care Services", add
label def n3ind 622 "Hospitals", add
label def n3ind 623 "Nursing and Residential Care Facilities", add
label def n3ind 624 "Social Assistance", add
label def n3ind 711 "Performing Arts, Spectator Sports, and Related Industries", add
label def n3ind 712 "Museums, Historical Sites, and Similar Institutions", add
label def n3ind 713 "Amusement, Gambling, and Recreation Industries", add
label def n3ind 721 "Accommodation", add
label def n3ind 722 "Food Services and Drinking Places", add
label def n3ind 811 "Repair and Maintenance", add
label def n3ind 812 "Personal and Laundry Services", add
label def n3ind 813 "Religious, Grantmaking, Civic, Professional, and Similar Organizations", add

label variable n`lvl'com "NAICS commodity detail"

label def n2com 11 "Agriculture, Forestry, Fishing and Hunting"
label def n2com 21 "Mining, Quarrying, and Oil and Gas Extraction", add
label def n2com 31 "Manufacturing", add

label def n3com 111 "Crop Production"
label def n3com 112 "Animal Production and Aquaculture", add
label def n3com 113 "Forestry and Logging", add
label def n3com 114 "Fishing, Hunting and Trapping", add
label def n3com 115 "Support Activities for Agriculture and Forestry", add
label def n3com 211 "Oil and Gas Extraction", add
label def n3com 212 "Mining (except Oil and Gas)", add
label def n3com 311 "Food Manufacturing", add
label def n3com 312 "Beverage and Tobacco Product Manufacturing", add
label def n3com 313 "Textile Mills", add
label def n3com 314 "Textile Product Mills", add
label def n3com 315 "Apparel Manufacturing", add
label def n3com 316 "Leather and Allied Product Manufacturing", add
label def n3com 321 "Wood Product Manufacturing", add
label def n3com 322 "Paper Manufacturing", add
label def n3com 323 "Printing and Related Support Activities", add
label def n3com 324 "Petroleum and Coal Products Manufacturing", add
label def n3com 325 "Chemical Manufacturing", add
label def n3com 326 "Plastics and Rubber Products Manufacturing", add
label def n3com 327 "Nonmetallic Mineral Product Manufacturing", add
label def n3com 331 "Primary Metal Manufacturing", add
label def n3com 332 "Fabricated Metal Product Manufacturing", add
label def n3com 333 "Machinery Manufacturing", add
label def n3com 334 "Computer and Electronic Product Manufacturing", add
label def n3com 335 "Electrical Equipment, Appliance, and Component Manufacturing", add
label def n3com 336 "Transportation Equipment Manufacturing", add
label def n3com 337 "Furniture and Related Product Manufacturing", add
label def n3com 339 "Miscellaneous Manufacturing", add

save "$data/tariffset_`usgeo'_`yr'_naics`lvl'.dta", replace

