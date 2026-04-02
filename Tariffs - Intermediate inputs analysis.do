*** Tariffs - Intermediate Inputs & Employment ***

clear all

global data "/home/cbangertdrowns/public_projects/Tariffs"
local usgeo national // level of US geographic detail; options are national, state, or county
local lvl 4 // level of NAICS detail; options are 2, 3, or 4
local yr 2025 // year of import and employment data; options are 2017-2023 for state/county detail, 2017-2025 for national detail; if year > 2023 and state or county selected, employment data will be for 2023


include "$data/Matrices_v2.do" // running and saving crosswalk of BEA input-output data at desired `lvl' of NAICS detail

label variable n`lvl'ind "Industry at the `lvl'-digit NAICS level [BEA]"
label variable com_detail "Commodity at the highest level of detail possible [BEA]"
label variable impshare "Imported fraction of n`lvl'ind's use of com_detail (valimp/valuse) [BEA]"
label variable com_impshare "Average imported fraction of com_detail among all industries in this dataset (total_com_imp/total_com_use) [BEA]"
label variable com_indshare "Fraction of total com_detail imports used by n`lvl'ind (valimp/total_com_imp) [BEA]"
label variable valuse "Total value of com_detail used by n`lvl'ind in BEA's 2017 benchmark input-output table, millions of dollars [BEA]"
label variable valimp "Total value of com_detail imported by n`lvl'ind in BEA's 2017 benchmark input-output table, millions of dollars [BEA]"
label variable total_com_use "Total use of com_detail among all industries in this dataset, millions of dollars (BEA 2017 I-O benchmark) [BEA]"
label variable total_com_imp "Total imports of com_detail among all industries in this dataset, millions of dollars (BEA 2017 I-O benchmark) [BEA]"
label variable total_ind_use "Total value of all commodities in this dataset used by n`lvl'ind [BEA]"
label variable total_ind_imp "Total value of imported commodities in this dataset used by n`lvl'ind [BEA]"
label variable ind_impshare "Imported fraction of n`lvl'ind's use of all commodities in this dataset [BEA]"
label variable com_frac "Fraction of n`lvl'ind's imports attributable to com_detail"

save "$data/intermediate_use_merged.dta", replace

clear

include "$data/Effective tariff rates.do" // cleaning and saving monthly customs and duties values data
save "$data/effective_rates.dta", replace
merge 1:m com_detail using "$data/intermediate_use_merged.dta"
reshape long com_eff_tariff, i(com_detail n`lvl'ind) j(month)

preserve
bysort com_detail n`lvl'ind : egen max_month = max(month)
keep if month == max_month
drop month max_month
keep n`lvl'ind com_detail impshare ind_impshare valimp com_indshare com_eff_tariff com_frac
gen impact_score = com_eff_tariff * com_frac
reshape wide com_eff_tariff valimp impshare ind_impshare com_indshare com_frac impact_score, i(com_detail) j(n`lvl'ind)
save "$data/ind`lvl'_com `yr' final month analysis.dta", replace
restore

gen ind_com_tar_cost = com_eff_tariff * valimp // multiplying the tariff rate on a commodity by its annual import by an industry gives an "annualized" value of the tariff cost of that commodity import by that indusry
bysort n`lvl'ind month : egen total_ind_tar_cost = total(ind_com_tar_cost) // totaling the annualized tariff costs across commodities for each industry-month
bysort n`lvl'ind month : egen total_ind_cost = total(valuse) // totaling the annual use costs across commodities for each industry-month
gen ind_tar_rate = total_ind_tar_cost / total_ind_imp
gen ind_tar_cost_frac = total_ind_tar_cost / total_ind_cost
bysort n`lvl'ind month : keep if _n == 1
keep n`lvl'ind month ind_impshare ind_tar_rate ind_tar_cost_frac

label variable ind_tar_rate "Estimated tariff rate by industry [USITC]"
label variable ind_tar_cost_frac "Estimated tariff costs as a fraction of all input costs by industry [USITC]"

save "$data/rates_matrices_merged.dta", replace

clear

insobs 1

gen usgeo = "`usgeo'" // cleaning and saving relevant employment data for desired `yr' and `lvl' of NAICS industrial detail -- Current Employment Statistics for national detail; County Business Patterns for state or county detail
if usgeo == "national" {
	clear
	include "$data/CES.do"
	
	label variable avgemp "Average monthly employment in n`lvl'ind in `yr' [CES]"
	label variable monthlyemp "Monthly employment in n`lvl'ind in `yr' [CES]"
	
	save "$data/ces_cleaned.dta", replace
}
else {
	if usgeo == "county" {
		clear
		include "$data/County Business Patterns.do"
		bysort county_state_ind : egen total_employment = total(employment)
		bysort county_state_ind : egen total_estab = total(establishments)
		bysort county_state_ind : egen total_payroll = total(ann_payroll)
		bysort county_state_ind : keep if _n == 1
		drop geo_id employment establishments ann_payroll
		
		label variable total_employment "Annual employment by county and industry [CBP]"
		label variable total_estab "Annual number of establishments by county and industry [CBP]"
		label variable total_payroll "Annual cost of payroll in $1,000s by county and industry [CBP]"
		
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
		
		label variable total_employment "Annual employment by state and industry [CBP]"
		label variable total_estab "Annual number of establishments by state and industry [CBP]"
		label variable total_payroll "Annual cost of payroll in $1,000s by state and industry [CBP]"
		
		save "$data/CBP_naics`lvl'.dta", replace
	}
}

clear


insobs 1
gen usgeo = "`usgeo'" // code to compile desired dataset, depending on level of geographic detail
if usgeo == "national" {
	use "$data/rates_matrices_merged.dta", clear
	
	merge 1:1 n`lvl'ind month using "$data/ces_cleaned.dta"

	bysort month : egen nat_emp = total(monthlyemp)
	gen nat_emp_frac = monthlyemp / nat_emp
	gen score = nat_emp_frac * ind_tar_cost_frac
	bysort month : egen nat_score = total(score)
	
	label variable nat_emp "Monthly national employment [CES]"
	label variable nat_emp_frac "Industry fraction of monthly national employment [CES]"
	label variable score "A metric weighing an industry's tariff exposure by its portion of monthly national employment, comparable across industries and time"
	label variable nat_score "The monthly sum of all industry score metrics, comparable across time"
	
	drop _merge
	sort n`lvl'ind month
	order month n`lvl'ind ind_impshare ind_tar_rate ind_tar_cost_frac
}
else {
	if usgeo == "state" {
		use "$data/rates_matrices_merged.dta", clear
		reshape wide ind_impshare ind_tar_rate ind_tar_cost_frac, i(n`lvl'ind) j(month)
		
		merge 1:m n`lvl'ind using "$data/CBP_naics`lvl'.dta"
		drop _merge
		drop county_state_ind
		
		reshape long ind_impshare ind_tar_rate ind_tar_cost_frac, i(n`lvl'ind state) j(month)
		
		*keep if _merge == 3
		sort state n`lvl'ind month
		order state n`lvl'ind total_employment total_estab total_payroll ind_impshare ind_tar_rate ind_tar_cost_frac
		
		keep if state != ""
		
		bysort state month : egen state_emp = total(total_employment)
		gen state_emp_frac = total_employment / state_emp
		gen score = state_emp_frac * ind_tar_cost_frac
		bysort state month : egen state_score = total(score)
		
		label variable state_emp "Annual state employment [CBP]"
		label variable state_emp_frac "Industry fraction of annual state employment [CBP]"
		label variable score "A metric weighing an industry's tariff exposure by its portion of state employment, comparable across state-industries"
		label variable state_score "The sum of all industry score metrics in each state, comparable across states"
		
		preserve
		bysort state month : keep if _n == 1
		keep state state_score month
		save "$data/state_score_`yr'.dta", replace
		export delimited "$data/state_score_`yr'.csv", replace
		restore
	}
	else{
		use "$data/rates_matrices_merged.dta", clear
		reshape wide ind_impshare ind_tar_rate ind_tar_cost_frac, i(n`lvl'ind) j(month)
		
		merge 1:m n`lvl'ind using "$data/CBP_naics`lvl'.dta"
		drop _merge
		
		reshape long ind_impshare ind_tar_rate ind_tar_cost_frac, i(n`lvl'ind state county) j(month)
		
		sort state county n`lvl'ind month
		order state county n`lvl'ind total_employment total_estab total_payroll ind_impshare ind_tar_rate ind_tar_cost_frac
		
		keep if state != "" // drops observations with industry data from BEA without corresponding industries in CBP data
		
		bysort county state month : egen county_emp = total(total_employment)
		gen county_emp_frac = total_employment / county_emp
		gen score = county_emp_frac * ind_tar_cost_frac
		bysort state county month : egen county_score = total(score)
		
		label variable county_emp "Annual county employment [CBP]"
		label variable county_emp_frac "Industry fraction of annual county employment [CBP]"
		label variable score "A metric weighing an industry's tariff exposure by its portion of county employment, comparable across county-industries"
		label variable county_score "The sum of all industry score metrics in each county, comparable across counties"
		
		preserve
		bysort state county month : keep if _n == 1
		keep state county county_score month
		save "$data/county_score_`yr'.dta", replace
		export delimited "$data/county_score`yr'.csv", replace
		restore
	}
}

*** Labeling variables -- asterisks next to labels with some variation from 2017 NAICS (either name change or some type of aggregation; see Tariff intermediate analysis industry codes spreadsheet)

if `lvl' == 2 {
	gen n2ind_label = ""
	replace n2ind_label = "Mining, Quarrying, and Oil and Gas Extraction" if n2ind == 21
	replace n2ind_label = "Utilities" if n2ind == 22
	replace n2ind_label = "Construction" if n2ind == 23
	replace n2ind_label = "Manufacturing*" if n2ind == 31
	replace n2ind_label = "Wholesale Trade" if n2ind == 42
	replace n2ind_label = "Retail Trade*" if n2ind == 44
	replace n2ind_label = "Transportation and Warehousing*" if n2ind == 48
	replace n2ind_label = "Information" if n2ind == 51
	replace n2ind_label = "Finance and Insurance" if n2ind == 52
	replace n2ind_label = "Real Estate and Rental and Leasing" if n2ind == 53
	replace n2ind_label = "Professional, Scientific, and Technical Services" if n2ind == 54
	replace n2ind_label = "Management of Companies and Enterprises" if n2ind == 55
	replace n2ind_label = "Administrative and Support and Waste Management and Remediation Services" if n2ind == 56
	replace n2ind_label = "Educational Services" if n2ind == 61
	replace n2ind_label = "Health Care and Social Assistance" if n2ind == 62
	replace n2ind_label = "Arts, Entertainment, and Recreation" if n2ind == 71
	replace n2ind_label = "Accommodation and Food Services" if n2ind == 72
	replace n2ind_label = "Other Services (except Public Administration)" if n2ind == 81
}
else {
	if `lvl' == 3 {
		gen n3ind_label = ""
		replace n3ind_label = "Oil and Gas Extraction" if n3ind == 211
		replace n3ind_label = "Mining (except Oil and Gas)" if n3ind == 212
		replace n3ind_label = "Support Activities for Mining" if n3ind == 213
		replace n3ind_label = "Utilities" if n3ind == 221
		replace n3ind_label = "Construction*" if n3ind == 239
		replace n3ind_label = "Food Manufacturing" if n3ind == 311
		replace n3ind_label = "Beverage, Tobacco, and Leather and Allied Product Manufacturing*" if n3ind == 312
		replace n3ind_label = "Textile Mills" if n3ind == 313
		replace n3ind_label = "Textile Product Mills" if n3ind == 314
		replace n3ind_label = "Apparel Manufacturing" if n3ind == 315
		replace n3ind_label = "Wood Product Manufacturing" if n3ind == 321
		replace n3ind_label = "Paper Manufacturing" if n3ind == 322
		replace n3ind_label = "Printing and Related Support Activities" if n3ind == 323
		replace n3ind_label = "Petroleum and Coal Products Manufacturing" if n3ind == 324
		replace n3ind_label = "Chemical Manufacturing" if n3ind == 325
		replace n3ind_label = "Plastics and Rubber Products Manufacturing" if n3ind == 326
		replace n3ind_label = "Nonmetallic Mineral Product Manufacturing" if n3ind == 327
		replace n3ind_label = "Primary Metal Manufacturing" if n3ind == 331
		replace n3ind_label = "Fabricated Metal Product Manufacturing" if n3ind == 332
		replace n3ind_label = "Machinery Manufacturing" if n3ind == 333
		replace n3ind_label = "Computer and Electronic Product Manufacturing" if n3ind == 334
		replace n3ind_label = "Electrical Equipment, Appliance, and Component Manufacturing" if n3ind == 335
		replace n3ind_label = "Transportation Equipment Manufacturing" if n3ind == 336
		replace n3ind_label = "Furniture and Related Product Manufacturing" if n3ind == 337
		replace n3ind_label = "Miscellaneous Manufacturing" if n3ind == 339
		replace n3ind_label = "Merchant Wholesalers, Durable Goods" if n3ind == 423
		replace n3ind_label = "Merchant Wholesalers, Nondurable Goods" if n3ind == 424
		replace n3ind_label = "Wholesale Trade Agents and Brokers*" if n3ind == 425
		replace n3ind_label = "Motor Vehicle and Parts Dealers" if n3ind == 441
		replace n3ind_label = "Building Material and Garden Equipment and Supplies Dealers" if n3ind == 444
		replace n3ind_label = "Food and Beverage Stores/Retailers*" if n3ind == 445
		replace n3ind_label = "Health and Personal Care Stores/Retailers*" if n3ind == 446
		replace n3ind_label = "Gasoline Stations/ Fuel Dealers*" if n3ind == 447
		replace n3ind_label = "General Merchandise Stores/Retailers*" if n3ind == 452
		replace n3ind_label = "Other Stores/Retailers*" if n3ind == 453
		replace n3ind_label = "Air Transportation" if n3ind == 481
		replace n3ind_label = "Rail Transportation" if n3ind == 482
		replace n3ind_label = "Water Transportation" if n3ind == 483
		replace n3ind_label = "Truck Transportation" if n3ind == 484
		replace n3ind_label = "Transit and Ground Passenger Transportation" if n3ind == 485
		replace n3ind_label = "Pipeline Transportation" if n3ind == 486
		replace n3ind_label = "Scenic and Sightseeing Transportationg and Support Activities*" if n3ind == 487
		replace n3ind_label = "Couriers and Messengers" if n3ind == 492
		replace n3ind_label = "Warehousing and Storage" if n3ind == 493
		replace n3ind_label = "Publishing Industries*" if n3ind == 511
		replace n3ind_label = "Motion Picture and Sound Recording Industries" if n3ind == 512
		replace n3ind_label = "Broadcasting*" if n3ind == 515
		replace n3ind_label = "Telecommunications" if n3ind == 517
		replace n3ind_label = "Data Processing, Hosting, and Related Services" if n3ind == 518
		replace n3ind_label = "Other Information Services*" if n3ind == 519
		replace n3ind_label = "Monetary Authorities and Credit Intermediaion and Related Activities*" if n3ind == 521
		replace n3ind_label = "Securities, Commodity Contracts, Funds, Trusts, and other Financial*" if n3ind == 523
		replace n3ind_label = "Insurance Carriers and Related Activities" if n3ind == 524
		replace n3ind_label = "Real Estate" if n3ind == 531
		replace n3ind_label = "Rental and Leasing Services" if n3ind == 532
		replace n3ind_label = "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)" if n3ind == 533
		replace n3ind_label = "Professional, Scientific, and Technical Services" if n3ind == 541
		replace n3ind_label = "Management of Companies and Enterprises" if n3ind == 551
		replace n3ind_label = "Administrative and Support Services" if n3ind == 561
		replace n3ind_label = "Waste Management and Remediation Services" if n3ind == 562
		replace n3ind_label = "Educational Services" if n3ind == 611
		replace n3ind_label = "Ambulatory Health Care Services" if n3ind == 621
		replace n3ind_label = "Hospitals" if n3ind == 622
		replace n3ind_label = "Nursing and Residential Care Facilities" if n3ind == 623
		replace n3ind_label = "Social Assistance" if n3ind == 624
		replace n3ind_label = "Performing Arts, Spectator Sports, and Related Industries" if n3ind == 711
		replace n3ind_label = "Museums, Historical Sites, and Similar Institutions" if n3ind == 712
		replace n3ind_label = "Amusement, Gambling, and Recreation Industries" if n3ind == 713
		replace n3ind_label = "Accommodation" if n3ind == 721
		replace n3ind_label = "Food Services and Drinking Places" if n3ind == 722
		replace n3ind_label = "Repair and Maintenance" if n3ind == 811
		replace n3ind_label = "Personal and Laundry Services" if n3ind == 812
		replace n3ind_label = "Religious, Grantmaking, Civic, Professional, and Similar Organizations" if n3ind == 813
	}
	else {
		gen n4ind_label = ""
		replace n4ind_label = "Oil and Gas Extraction" if n4ind == 2111
		replace n4ind_label = "Coal Mining" if n4ind == 2121
		replace n4ind_label = "Metal Ore Mining" if n4ind == 2122
		replace n4ind_label = "Nonmetallic Mineral Mining and Quarrying" if n4ind == 2123
		replace n4ind_label = "Support Activities for Mining" if n4ind == 2131
		replace n4ind_label = "Electric Power Generation, Transmission and Distribution" if n4ind == 2211
		replace n4ind_label = "Natural Gas Distribution" if n4ind == 2212
		replace n4ind_label = "Water, Sewage and Other Systems" if n4ind == 2213
		replace n4ind_label = "Construction*" if n4ind == 2399
		replace n4ind_label = "Animal Food Manufacturing" if n4ind == 3111
		replace n4ind_label = "Grain and Oilseed Milling" if n4ind == 3112
		replace n4ind_label = "Sugar and Confectionery Product Manufacturing" if n4ind == 3113
		replace n4ind_label = "Fruit and Vegetable Preserving and Specialty Food Manufacturing" if n4ind == 3114
		replace n4ind_label = "Dairy Product Manufacturing" if n4ind == 3115
		replace n4ind_label = "Animal Slaughtering and Processing" if n4ind == 3116
		replace n4ind_label = "Seafood Product Preparation and Packaging" if n4ind == 3117
		replace n4ind_label = "Bakeries and Tortilla Manufacturing" if n4ind == 3118
		replace n4ind_label = "Other Food Manufacturing" if n4ind == 3119
		replace n4ind_label = "Beverage, Tobacco, and Leather and Allied Product Manufacturing*" if n4ind == 3129
		replace n4ind_label = "Textile Mills*" if n4ind == 3139
		replace n4ind_label = "Textile Furnishings Mills" if n4ind == 3141
		replace n4ind_label = "Other Textile Product Mills" if n4ind == 3149
		replace n4ind_label = "Apparel Manufacturing*" if n4ind == 3159
		replace n4ind_label = "Sawmills and Wood Preservation" if n4ind == 3211
		replace n4ind_label = "Veneer, Plywood, and Engineered Wood Product Manufacturing" if n4ind == 3212
		replace n4ind_label = "Other Wood Product Manufacturing" if n4ind == 3219
		replace n4ind_label = "Pulp, Paper, and Paperboard Mills" if n4ind == 3221
		replace n4ind_label = "Converted Paper Product Manufacturing" if n4ind == 3222
		replace n4ind_label = "Printing and Related Support Activities" if n4ind == 3231
		replace n4ind_label = "Petroleum and Coal Products Manufacturing" if n4ind == 3241
		replace n4ind_label = "Basic Chemical Manufacturing" if n4ind == 3251
		replace n4ind_label = "Resin, Synthetic Rubber, and Artificial and Synthetic Fibers and Filaments Manufacturing" if n4ind == 3252
		replace n4ind_label = "Pesticide, Fertilizer, and Other Agricultural Chemical Manufacturing" if n4ind == 3253
		replace n4ind_label = "Pharmaceutical and Medicine Manufacturing" if n4ind == 3254
		replace n4ind_label = "Paint, Coating, and Adhesive Manufacturing" if n4ind == 3255
		replace n4ind_label = "Soap, Cleaning Compound, and Toilet Preparation Manufacturing" if n4ind == 3256
		replace n4ind_label = "Other Chemical Product and Preparation Manufacturing" if n4ind == 3259
		replace n4ind_label = "Plastics Products Manufacturing" if n4ind == 3261
		replace n4ind_label = "Rubber Product Manufacturing" if n4ind == 3262
		replace n4ind_label = "Clay Product and Refractory Manufacturing" if n4ind == 3271
		replace n4ind_label = "Glass and Glass Product Manufacturing" if n4ind == 3272
		replace n4ind_label = "Cement and Concrete Product Manufacturing" if n4ind == 3273
		replace n4ind_label = "Lime, gypsum, and other nonmetallic mineral product manufacturing*" if n4ind == 3279
		replace n4ind_label = "Iron and Steel Mills and Ferroalloy Manufacturing" if n4ind == 3311
		replace n4ind_label = "Steel Product Manufacturing from Purchased Steel" if n4ind == 3312
		replace n4ind_label = "Alumina, aluminum, and other nonferrous metal production and processing*" if n4ind == 3314
		replace n4ind_label = "Foundries" if n4ind == 3315
		replace n4ind_label = "Forging and Stamping" if n4ind == 3321
		replace n4ind_label = "Architectural and Structural Metals Manufacturing" if n4ind == 3323
		replace n4ind_label = "Boiler, Tank, and Shipping Container Manufacturing" if n4ind == 3324
		replace n4ind_label = "Hardware, spring, and wire product manufacturing*" if n4ind == 3326
		replace n4ind_label = "Machine Shops; Turned Product; and Screw, Nut, and Bolt Manufacturing" if n4ind == 3327
		replace n4ind_label = "Coating, Engraving, Heat Treating, and Allied Activities" if n4ind == 3328
		replace n4ind_label = "Cutlery, handtool, and other fabricated metal product manufacturing*" if n4ind == 3329
		replace n4ind_label = "Agriculture, Construction, and Mining Machinery Manufacturing" if n4ind == 3331
		replace n4ind_label = "Industrial Machinery Manufacturing" if n4ind == 3332
		replace n4ind_label = "Commercial and Service Industry Machinery Manufacturing" if n4ind == 3333
		replace n4ind_label = "Ventilation, Heating, Air-Conditioning, and Commercial Refrigeration Equipment Manufacturing" if n4ind == 3334
		replace n4ind_label = "Metalworking Machinery Manufacturing" if n4ind == 3335
		replace n4ind_label = "Engine, Turbine, and Power Transmission Equipment Manufacturing" if n4ind == 3336
		replace n4ind_label = "Other General Purpose Machinery Manufacturing" if n4ind == 3339
		replace n4ind_label = "Computer and Peripheral Equipment Manufacturing" if n4ind == 3341
		replace n4ind_label = "Communications Equipment Manufacturing" if n4ind == 3342
		replace n4ind_label = "Semiconductor and Other Electronic Component Manufacturing" if n4ind == 3344
		replace n4ind_label = "Navigational, Measuring, Electromedical, and Control Instruments Manufacturing" if n4ind == 3345
		replace n4ind_label = "Manufacturing and reproducing magnetic and optical media and audio and video equipment manufacturing*" if n4ind == 3346
		replace n4ind_label = "Electric Lighting Equipment Manufacturing" if n4ind == 3351
		replace n4ind_label = "Household Appliance Manufacturing" if n4ind == 3352
		replace n4ind_label = "Electrical Equipment Manufacturing" if n4ind == 3353
		replace n4ind_label = "Other Electrical Equipment and Component Manufacturing" if n4ind == 3359
		replace n4ind_label = "Motor Vehicle Manufacturing" if n4ind == 3361
		replace n4ind_label = "Motor Vehicle Body and Trailer Manufacturing" if n4ind == 3362
		replace n4ind_label = "Motor Vehicle Parts Manufacturing" if n4ind == 3363
		replace n4ind_label = "Aerospace Product and Parts Manufacturing" if n4ind == 3364
		replace n4ind_label = "Ship and Boat Building" if n4ind == 3366
		replace n4ind_label = "Railroad rolling stock and other transportation equipment manufacturing*" if n4ind == 3369
		replace n4ind_label = "Household and Institutional Furniture and Kitchen Cabinet Manufacturing" if n4ind == 3371
		replace n4ind_label = "Office furniture (including fixtures) and other furniture related product manufacturing*" if n4ind == 3372
		replace n4ind_label = "Medical Equipment and Supplies Manufacturing" if n4ind == 3391
		replace n4ind_label = "Other Miscellaneous Manufacturing" if n4ind == 3399
		replace n4ind_label = "Merchant Wholesalers, Durable Goods" if n4ind == 423
		replace n4ind_label = "Merchant Wholesalers, Nondurable Goods" if n4ind == 424
		replace n4ind_label = "Wholesale Trade Agents and Brokers*" if n4ind == 425
		replace n4ind_label = "Motor Vehicle and Parts Dealers" if n4ind == 441
		replace n4ind_label = "Building Material and Garden Equipment and Supplies Dealers" if n4ind == 444
		replace n4ind_label = "Food and Beverage Stores/Retailers*" if n4ind == 445
		replace n4ind_label = "Health and Personal Care Stores/Retailers*" if n4ind == 446
		replace n4ind_label = "Gasoline Stations/ Fuel Dealers*" if n4ind == 447
		replace n4ind_label = "General Merchandise Stores/Retailers*" if n4ind == 452
		replace n4ind_label = "Other Stores/Retailers*" if n4ind == 453
		replace n4ind_label = "Air Transportation" if n4ind == 481
		replace n4ind_label = "Rail Transportation" if n4ind == 482
		replace n4ind_label = "Water Transportation" if n4ind == 483
		replace n4ind_label = "Truck Transportation" if n4ind == 484
		replace n4ind_label = "Transit and Ground Passenger Transportation" if n4ind == 485
		replace n4ind_label = "Pipeline Transportation" if n4ind == 486
		replace n4ind_label = "Scenic and Sightseeing Transportationg and Support Activities*" if n4ind == 487
		replace n4ind_label = "Couriers and Messengers" if n4ind == 492
		replace n4ind_label = "Warehousing and Storage" if n4ind == 493
		replace n4ind_label = "Publishing Industries*" if n4ind == 511
		replace n4ind_label = "Motion Picture and Sound Recording Industries" if n4ind == 512
		replace n4ind_label = "Broadcasting*" if n4ind == 515
		replace n4ind_label = "Telecommunications" if n4ind == 517
		replace n4ind_label = "Data Processing, Hosting, and Related Services" if n4ind == 518
		replace n4ind_label = "Other Information Services*" if n4ind == 519
		replace n4ind_label = "Monetary Authorities and Credit Intermediaion and Related Activities*" if n4ind == 521
		replace n4ind_label = "Securities, Commodity Contracts, Funds, Trusts, and other Financial*" if n4ind == 523
		replace n4ind_label = "Insurance Carriers and Related Activities" if n4ind == 524
		replace n4ind_label = "Real Estate" if n4ind == 531
		replace n4ind_label = "Rental and Leasing Services" if n4ind == 532
		replace n4ind_label = "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)" if n4ind == 533
		replace n4ind_label = "Professional, Scientific, and Technical Services" if n4ind == 541
		replace n4ind_label = "Management of Companies and Enterprises" if n4ind == 551
		replace n4ind_label = "Administrative and Support Services" if n4ind == 561
		replace n4ind_label = "Waste Management and Remediation Services" if n4ind == 562
		replace n4ind_label = "Educational Services" if n4ind == 611
		replace n4ind_label = "Ambulatory Health Care Services" if n4ind == 621
		replace n4ind_label = "Hospitals" if n4ind == 622
		replace n4ind_label = "Nursing and Residential Care Facilities" if n4ind == 623
		replace n4ind_label = "Social Assistance" if n4ind == 624
		replace n4ind_label = "Performing Arts, Spectator Sports, and Related Industries" if n4ind == 711
		replace n4ind_label = "Museums, Historical Sites, and Similar Institutions" if n4ind == 712
		replace n4ind_label = "Amusement, Gambling, and Recreation Industries" if n4ind == 713
		replace n4ind_label = "Accommodation" if n4ind == 721
		replace n4ind_label = "Food Services and Drinking Places" if n4ind == 722
		replace n4ind_label = "Automotive Repair and Maintenance" if n4ind == 8111
		replace n4ind_label = "Electronic and Precision Equipment Repair and Maintenance" if n4ind == 8112
		replace n4ind_label = "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance" if n4ind == 8113
		replace n4ind_label = "Personal and Household Goods Repair and Maintenance" if n4ind == 8114
		replace n4ind_label = "Personal and Laundry Services" if n4ind == 812
		replace n4ind_label = "Religious, Grantmaking, Civic, Professional, and Similar Organizations" if n4ind == 813		
	}
}

save "$data/tariffset_`usgeo'_`yr'_naics`lvl'.dta", replace

