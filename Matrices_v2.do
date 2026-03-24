** Intermediates table **

import excel "$data/ImportMatrices_Before_Redefinitions_DET_2017.xlsx", cellrange(A6:ON408) sheet(2017) firstrow // 2017 is the latest detailed import matrix as of March 18, 2025; a 2022 vintage won't come for a few more years

* renaming industry variables as their labels

foreach v of varlist _all {
	local x : variable label `v'
	label var `v' "a_`x'"
}

foreach v of varlist _all {
	local z : variable label `v'
	local z = strtoname("`z'")
	rename `v' `z'
}

rename a_Code code
rename a_Commodity_Description cdesc

foreach v of varlist a_* {
	replace `v' = 0 if `v' == .
}

* preparing BEA commodity codes for cross-walk with USITC commodity data

replace code = "112100" if code == "1121A0"
replace code = "112100" if code == "112120"

replace code = "333310" if code == "333314"
replace code = "333310" if code == "333316"
replace code = "333310" if code == "333318"

replace code = "335100" if code == "335110"
replace code = "335100" if code == "335120"

replace code = "335910" if code == "335911"
replace code = "335910" if code == "335912"

replace code = "336110" if code == "336111"
replace code = "336110" if code == "336112"

* refashioned cross-walk to produce aggregated industries

gen n4_1111 = a_1111A0 + a_1111B0
gen n4_1112 = a_111200
gen n4_1113 = a_111300
gen n4_1114 = a_111400
gen n4_1119 = a_111900
gen n3_111 = n4_1111 + n4_1112 + n4_1113 + n4_1114 + n4_1119

gen n4_1121 = a_1121A0 + a_112120
gen n4_1123 = a_112300
gen n3_112 = n4_1121 + n4_1123 + a_112A00

gen n3_113 = a_113000
gen n3_114 = a_114000
gen n3_115 = a_115000

gen n2_11 = n3_111 + n3_112 + n3_113 + n3_114 + n3_115

gen n3_211 = a_211000
gen n4_2111 = n3_211 // to keep in analysis at 4-digit level

gen n4_2121 = a_212100
gen n4_2122 = a_2122A0 + a_212230
gen n4_2123 = a_212310 + a_2123A0
gen n3_212 = n4_2121 + n4_2122 + n4_2123

gen n4_2131 = a_213111 + a_21311A
gen n3_213 = n4_2131

gen n2_21 = n3_211 + n3_212 + n3_213

gen n4_2211 = a_221100
gen n4_2212 = a_221200
gen n4_2213 = a_221300
gen n3_221 = n4_2211 + n4_2212 + n4_2213

gen n2_22 = n3_221

gen n2_23 = a_233210 + a_233262 + a_2332A0 + a_233240 + a_2332C0 + a_233230 + a_2332D0 + a_233411 + a_233412 + a_2334A0 + a_230301 + a_230302
gen n3_239 = n2_23 // generating code 239, equivalent to 2-digit code 23, in order to keep construction in analysis at 3-digit level
gen n4_2399 = n2_23 // generating code 2399 to keep in 4d

gen n4_3211 = a_321100
gen n4_3212 = a_321200
gen n4_3219 = a_321910 + a_3219A0
gen n3_321 = n4_3211 + n4_3212 + n4_3219

gen n4_3271 = a_327100
gen n4_3272 = a_327200
gen n4_3273 = a_327310 + a_327320 + a_327330 + a_327390
gen n4_3279 = a_327910 + a_327992 + a_327993 + a_327999 + a_327400 // consolidating codes 3274 and 3279 to reflect CES
gen n3_327 = n4_3271 + n4_3272 + n4_3273 + n4_3279

gen n4_3311 = a_331110
gen n4_3312 = a_331200
gen n4_3314 = a_331313 + a_331314 + a_33131B + a_331410 + a_331420 + a_331490 // consolidating codes 3313 and 3314 to reflect CES
gen n4_3315 = a_331510 + a_331520
gen n3_331 = n4_3311 + n4_3312 + n4_3314 + n4_3315

gen n4_3321 = a_33211A + a_332114 + a_332119
gen n4_3323 = a_332310 + a_332320
gen n4_3324 = a_332410 + a_332420 + a_332430
gen n4_3326 = a_332500 + a_332600 // consolidating codes 3325 and 3326 to reflect CES
gen n4_3327 = a_332710 + a_332720
gen n4_3328 = a_332800
gen n4_3329 = a_33291A + a_332913 + a_332991 + a_33299A + a_332996 + a_332999 + a_332200 // consoldiating codes 3322 and 3329 to reflect CES
gen n3_332 = n4_3321 + n4_3323 + n4_3324 + n4_3326 + n4_3327 + n4_3328 + n4_3329

gen n4_3331 = a_333111 + a_333112 + a_333120 + a_333130
gen n4_3332 = a_333242 + a_33329A
gen n4_3333 = a_333316 + a_333318
gen n4_3334 = a_333413 + a_333414 + a_333415
gen n4_3335 = a_333511 + a_333517 + a_333514 + a_33351B
gen n4_3336 = a_333611 + a_333612 + a_333613 + a_333618
gen n4_3339 = a_333914 + a_333912 + a_333920 + a_333991 + a_33399A + a_33399B + a_333993 + a_333994
gen n3_333 = n4_3331 + n4_3332 + n4_3333 + n4_3334 + n4_3335 + n4_3336 + n4_3339

gen n4_3341 = a_334111 + a_334112 + a_334118
gen n4_3342 = a_334210 + a_334220 + a_334290
gen n4_3344 = a_334413 + a_334418 + a_33441A
gen n4_3345 = a_334510 + a_334511 + a_334512 + a_334513 + a_334514 + a_334515 + a_334516 + a_334517 + a_33451A
gen n4_3346 = a_334300 + a_334610 // consolidating codes 3343 and 3346 to reflect CES
gen n3_334 = n4_3341 + n4_3342 + n4_3344 + n4_3345 + n4_3346

gen n4_3351 = a_335110 + a_335120
gen n4_3352 = a_335210 + a_335220
gen n4_3353 = a_335311 + a_335312 + a_335313 + a_335314
gen n4_3359 = a_335911 + a_335912 + a_335920 + a_335930 + a_335991 + a_335999
gen n3_335 = n4_3351 + n4_3352 + n4_3353 + n4_3359

gen n4_3361 = a_336111 + a_336112 + a_336120
gen n4_3362 = a_336211 + a_336212 + a_336213 + a_336214
gen n4_3363 = a_336310 + a_336320 + a_3363A0 + a_336350 + a_336360 + a_336370 + a_336390
gen n4_3364 = a_336411 + a_336412 + a_336413 + a_336414 + a_33641A
gen n4_3366 = a_336611 + a_336612
gen n4_3369 = a_336500 + a_336991 + a_336992 + a_336999 // consolidating codes 3365 and 3369 to reflect CES
gen n3_336 = n4_3361 + n4_3362 + n4_3363 + n4_3364 + n4_3366 + n4_3369

gen n4_3371 = a_337110 + a_337121 + a_337122 + a_33712N + a_337127
gen n4_3372 = a_33721A + a_337215 + a_337900 // consolidating codes 3372 and 3379 to reflect CES
gen n3_337 = n4_3371 + n4_3372

gen n4_3391 = a_339112 + a_339113 + a_339114 + a_339115 + a_339116
gen n4_3399 = a_339910 + a_339920 + a_339930 + a_339940 + a_339950 + a_339990
gen n3_339 = n4_3391 + n4_3399

gen n2_33 = n3_331 + n3_332 + n3_333 + n3_334 + n3_335 + n3_336 + n3_337 + n3_339

gen n4_3111 = a_311111 + a_311119
gen n4_3112 = a_311210 + a_311221 + a_311224 + a_311225 + a_311230
gen n4_3113 = a_311300
gen n4_3114 = a_311410 + a_311420
gen n4_3115 = a_31151A + a_311513 + a_311514 + a_311520
gen n4_3116 = a_31161A + a_311615
gen n4_3117 = a_311700
gen n4_3118 = a_311810 + a_3118A0
gen n4_3119 = a_311910 + a_311920 + a_311930 + a_311940 + a_311990
gen n3_311 = n4_3111 + n4_3112 + n4_3113 + n4_3114 + n4_3115 + n4_3116 + n4_3117 + n4_3118 + n4_3119

*gen n4_3121 = a_312110 + a_312120 + a_312130 + a_312140
*gen n4_3122 = a_312200
gen n3_312 = a_312110 + a_312120 + a_312130 + a_312140 + a_312200 + a_316000 // consolidating codes 312 and 316 to reflect ces
gen n4_3129 = n3_312 // to keep in analysis at 4-digit level

*gen n4_3131 = a_313100
*gen n4_3132 = a_313200
*gen n4_3133 = a_313300
gen n3_313 = a_313100 + a_313200 + a_313300

gen n4_3139 = a_313100 + a_313200 + a_313300 // consolidating codes 3131, 3132, and 3133 to reflect ces and keep 313 in analysis at 4-digit level

gen n4_3141 = a_314110 + a_314120
gen n4_3149 = a_314900
gen n3_314 = n4_3141 + n4_3149

gen n3_315 = a_315000
gen n4_3159 = n3_315  // to keep in analysis at 4-digit level

*gen n3_316 = a_316000

gen n2_31 = n3_311 + n3_312 + n3_313 + n3_314 + n3_315

gen n4_3221 = a_322110 + a_322120 + a_322130
gen n4_3222 = a_322210 + a_322220 + a_322230 + a_322291 + a_322299
gen n3_322 = n4_3221 + n4_3222

gen n4_3231 = a_323110 + a_323120
gen n3_323 = n4_3231

gen n4_3241 = a_324110 + a_324121 + a_324122 + a_324190
gen n3_324 = n4_3241

gen n4_3251 = a_325110 + a_325120 + a_325130 + a_325180 + a_325190
gen n4_3252 = a_325211 + a_3252A0
gen n4_3254 = a_325411 + a_325412 + a_325413 + a_325414
gen n4_3253 = a_325310 + a_325320
gen n4_3255 = a_325510 + a_325520
gen n4_3256 = a_325610 + a_325620
gen n4_3259 = a_325910 + a_3259A0
gen n3_325 = n4_3251 + n4_3252 + n4_3254 + n4_3253 + n4_3255 + n4_3256 + n4_3259

gen n4_3261 = a_326110 + a_326120 + a_326130 + a_326140 + a_326150 + a_326160 + a_326190
gen n4_3262 = a_326210 + a_326220 + a_326290
gen n3_326 = n4_3261 + n4_3262

gen n2_32 = n3_321 + n3_327 + n3_322 + n3_324 + n3_325 + n3_326

gen n4_4231 = a_423100
gen n4_4234 = a_423400
gen n4_4236 = a_423600
gen n4_4238 = a_423800
gen n3_423 = a_423A00 + n4_4231 + n4_4234 + n4_4236 + n4_4238

gen n4_4242 = a_424200
gen n4_4244 = a_424400
gen n4_4247 = a_424700
gen n3_424 = a_424A00 + n4_4242 + n4_4244 + n4_4247

gen n3_425 = a_425000

gen n2_42 = n3_423 + n3_424 + n3_425

gen n3_441 = a_441000
gen n3_444 = a_444000
gen n3_445 = a_445000
gen n3_446 = a_446000
gen n3_447 = a_447000
gen n3_448 = a_448000
gen n2_44 = n3_441 + n3_444 + n3_445 + n3_446 + n3_447 + n3_448

gen n3_452 = a_452000
gen n3_454 = a_454000
gen n3_453 = a_4B0000
gen n2_45 = n3_452 + n3_454 + n3_453

gen n3_481 = a_481000
gen n3_482 = a_482000
gen n3_483 = a_483000
gen n3_484 = a_484000
gen n3_485 = a_485000
gen n3_486 = a_486000
gen n3_487 = a_48A000 // consolidating 487 and 488
gen n2_48 = n3_487 + n3_481 + n3_482 + n3_483 + n3_484 + n3_485 + n3_486

gen n3_492 = a_492000
gen n3_493 = a_493000

gen n4_5111 = a_511110 + a_511120 + a_511130 + a_5111A0
gen n4_5112 = a_511200
gen n3_511 = n4_5111 + n4_5112

gen n4_5121 = a_512100
gen n4_5122 = a_512200
gen n3_512 = n4_5121 + n4_5122

gen n4_5151 = a_515100
gen n4_5152 = a_515200
gen n3_515 = n4_5151 + n4_5152

gen n4_5173 = a_517110 + a_517210
gen n3_517 = a_517A00 + n4_5173

gen n4_5182 = a_518200
gen n3_518 = n4_5182

gen n4_5191 = a_519130 + a_5191A0
gen n3_519 = n4_5191

gen n2_51 = n3_511 + n3_512 + n3_515 + n3_517 + n3_518 + n3_519

gen n3_521 = a_52A000 + a_522A00 // consolidating codes 521 and 522
gen n4_5239 = a_523900
gen n3_523 = a_523A00 + n4_5239
gen n4_5241 = a_524113 + a_5241XX
gen n4_5242 = a_524200
gen n3_524 = n4_5241 + n4_5242
gen n3_525 = a_525000
gen n2_52 = n3_521 + n3_523 + n3_524 + n3_525

gen n3_531 = a_531HST + a_531ORE
gen n4_5321 = a_532100
gen n4_5324 = a_532400
gen n3_532 = a_532A00 + n4_5321 + n4_5324
gen n3_533 = a_533000
gen n2_53 = n3_531 + n3_532 + n3_533

gen n4_5411 = a_541100
gen n4_5412 = a_541200
gen n4_5413 = a_541300
gen n4_5416 = a_541610 + a_5416A0
gen n4_5417 = a_541700
gen n4_5418 = a_541800
gen n4_5414 = a_541400
gen n4_5419 = a_5419A0 + a_541920 + a_541940
gen n4_5415 = a_541511 + a_541512 + a_54151A
gen n3_541 = n4_5411 + n4_5412 + n4_5413 + n4_5416 + n4_5417 + n4_5418 + n4_5414 + n4_5419 + n4_5415
gen n2_54 = n3_541

gen n2_55 = a_550000
gen n3_551 = n2_55
gen n4_5511 = n2_55

gen n4_5613 = a_561300
gen n4_5617 = a_561700
gen n4_5611 = a_561100
gen n4_5612 = a_561200
gen n4_5614 = a_561400
gen n4_5615 = a_561500
gen n4_5616 = a_561600
gen n4_5619 = a_561900
gen n3_561 = n4_5613 + n4_5617 + n4_5611 + n4_5612 + n4_5614 + n4_5615 + n4_5616 + n4_5619
gen n3_562 = a_562000
gen n2_56 = n3_561 + n3_562

gen n4_6111 = a_611100
gen n3_611 = a_611A00 + a_611B00 + n4_6111
gen n2_61 = n3_611

gen n4_6211 = a_621100
gen n4_6212 = a_621200
gen n4_6213 = a_621300
gen n4_6214 = a_621400
gen n4_6215 = a_621500
gen n4_6216 = a_621600
gen n4_6219 = a_621900
gen n3_621 = n4_6211 + n4_6212 + n4_6213 + n4_6214 + n4_6215 + n4_6216 + n4_6219
gen n3_622 = a_622000
gen n3_623 = a_623A00 + a_623B00
gen n4_6241 = a_624100
gen n4_6244 = a_624400
gen n3_624 = a_624A00 + n4_6241 + n4_6244
gen n2_62 = n3_621 + n3_622 + n3_623 + n3_624

gen n4_7111 = a_711100
gen n4_7112 = a_711200
gen n4_7115 = a_711500
gen n3_711 = a_711A00 + n4_7111 + n4_7112 + n4_7115
gen n3_712 = a_712000
gen n4_7131 = a_713100
gen n4_7132 = a_713200
gen n4_7139 = a_713900
gen n3_713 = n4_7131 + n4_7132 + n4_7139
gen n2_71 = n3_711 + n3_712 + n3_713

gen n3_721 = a_721000
gen n3_722 = a_722A00 + a_722110 + a_722211
gen n2_72 = n3_721 + n3_722

gen n4_8111 = a_811100
gen n4_8112 = a_811200
gen n4_8113 = a_811300
gen n4_8114 = a_811400
gen n3_811 = n4_8111 + n4_8112 + n4_8113 + n4_8114
gen n4_8121 = a_812100
gen n4_8122 = a_812200
gen n4_8123 = a_812300
gen n4_8129 = a_812900
gen n3_812 = n4_8121 + n4_8122 + n4_8123 + n4_8129
gen n4_8131 = a_813100
gen n3_813 = a_813A00 + a_813B00 + a_813100
gen n3_814 = a_814000
gen n2_81 = n3_811 + n3_812 + n3_813 + n3_814

gen n3_491 = a_491000
gen n2_49 = n3_492 + n3_493 + n3_491


replace n2_31 = n2_31 + n2_32 + n2_33 // consolidating manufacturing codes
drop n2_32 n2_33
replace n2_44 = n2_44 + n2_45 // consolidating retail trade codes
drop n2_45
replace n2_48 = n2_48 + n2_49 // consolidating transportation & warehousing
drop n2_49

replace n3_453 = n3_453 + n3_448 + n3_454 // consolidating remaining retail codes to reflect CES combinations
drop n3_448 n3_454
replace n3_523 = n3_523 + n3_525 // combining NAICS codes 523 and 525 to reflect CES combination
drop n3_525


* consolidating by NAICS level (lvl)

drop a_*

replace code = "910000" if code == "S00401"
replace code = "930000" if code == "S00402"

drop if substr(code, 1, 1) == "S" | substr(code, 1, 1) == "G"

if `lvl' == 2 | `lvl' == 3 {
	keep code cdesc n`lvl'_*
}
else {
	keep code cdesc n3_1* n4_2* n4_3* n3_4* n3_5* n3_6* n3_7* n4_811* n3_812 n3_813
	rename n3_* n4_*
}

foreach v of varlist n`lvl'_* {
	bysort code : egen a_`v' = total(`v')
}


bysort code : keep if _n == 1

drop n`lvl'_*
rename a_* *


* formatting, saving

keep code cdesc n`lvl'_*
rename code com_detail

reshape long n`lvl'_, i(com_detail) j(n`lvl'ind)
rename n`lvl'_ valimp
order n`lvl'ind com_detail valimp
sort n`lvl'ind com_detail
drop cdesc

save "$data/matrix_cleaned.dta", replace


** Use table **

clear

import excel "$data/Use_SUT_Framework_2017_DET.xlsx", cellrange(A6:ON408) sheet(2017) firstrow

* renaming industry variables as their labels

foreach v of varlist _all {
	local x : variable label `v'
	label var `v' "a_`x'"
}

foreach v of varlist _all {
	local z : variable label `v'
	local z = strtoname("`z'")
	rename `v' `z'
}

rename a_Code code
rename a_Commodity_Description cdesc

foreach v of varlist a_* {
	replace `v' = 0 if `v' == .
}

* preparing BEA commodity codes for cross-walk with USITC commodity data

replace code = "112100" if code == "1121A0"
replace code = "112100" if code == "112120"

replace code = "333310" if code == "333314"
replace code = "333310" if code == "333316"
replace code = "333310" if code == "333318"

replace code = "335100" if code == "335110"
replace code = "335100" if code == "335120"

replace code = "335910" if code == "335911"
replace code = "335910" if code == "335912"

replace code = "336110" if code == "336111"
replace code = "336110" if code == "336112"

* refashioned cross-walk to produce aggregated industries

gen n4_1111 = a_1111A0 + a_1111B0
gen n4_1112 = a_111200
gen n4_1113 = a_111300
gen n4_1114 = a_111400
gen n4_1119 = a_111900
gen n3_111 = n4_1111 + n4_1112 + n4_1113 + n4_1114 + n4_1119

gen n4_1121 = a_1121A0 + a_112120
gen n4_1123 = a_112300
gen n3_112 = n4_1121 + n4_1123 + a_112A00

gen n3_113 = a_113000
gen n3_114 = a_114000
gen n3_115 = a_115000

gen n2_11 = n3_111 + n3_112 + n3_113 + n3_114 + n3_115

gen n3_211 = a_211000
gen n4_2111 = n3_211 // to keep in analysis at 4-digit level

gen n4_2121 = a_212100
gen n4_2122 = a_2122A0 + a_212230
gen n4_2123 = a_212310 + a_2123A0
gen n3_212 = n4_2121 + n4_2122 + n4_2123

gen n4_2131 = a_213111 + a_21311A
gen n3_213 = n4_2131

gen n2_21 = n3_211 + n3_212 + n3_213

gen n4_2211 = a_221100
gen n4_2212 = a_221200
gen n4_2213 = a_221300
gen n3_221 = n4_2211 + n4_2212 + n4_2213

gen n2_22 = n3_221

gen n2_23 = a_233210 + a_233262 + a_2332A0 + a_233240 + a_2332C0 + a_233230 + a_2332D0 + a_233411 + a_233412 + a_2334A0 + a_230301 + a_230302
gen n3_239 = n2_23 // generating code 239, equivalent to 2-digit code 23, in order to keep construction in analysis at 3-digit level
gen n4_2399 = n2_23 // generating code 2399 to keep in 4d

gen n4_3211 = a_321100
gen n4_3212 = a_321200
gen n4_3219 = a_321910 + a_3219A0
gen n3_321 = n4_3211 + n4_3212 + n4_3219

gen n4_3271 = a_327100
gen n4_3272 = a_327200
gen n4_3273 = a_327310 + a_327320 + a_327330 + a_327390
gen n4_3279 = a_327910 + a_327992 + a_327993 + a_327999 + a_327400 // consolidating codes 3274 and 3279 to reflect CES
gen n3_327 = n4_3271 + n4_3272 + n4_3273 + n4_3279

gen n4_3311 = a_331110
gen n4_3312 = a_331200
gen n4_3314 = a_331313 + a_331314 + a_33131B + a_331410 + a_331420 + a_331490 // consolidating codes 3313 and 3314 to reflect CES
gen n4_3315 = a_331510 + a_331520
gen n3_331 = n4_3311 + n4_3312 + n4_3314 + n4_3315

gen n4_3321 = a_33211A + a_332114 + a_332119
gen n4_3323 = a_332310 + a_332320
gen n4_3324 = a_332410 + a_332420 + a_332430
gen n4_3326 = a_332500 + a_332600 // consolidating codes 3325 and 3326 to reflect CES
gen n4_3327 = a_332710 + a_332720
gen n4_3328 = a_332800
gen n4_3329 = a_33291A + a_332913 + a_332991 + a_33299A + a_332996 + a_332999 + a_332200 // consoldiating codes 3322 and 3329 to reflect CES
gen n3_332 = n4_3321 + n4_3323 + n4_3324 + n4_3326 + n4_3327 + n4_3328 + n4_3329

gen n4_3331 = a_333111 + a_333112 + a_333120 + a_333130
gen n4_3332 = a_333242 + a_33329A
gen n4_3333 = a_333316 + a_333318
gen n4_3334 = a_333413 + a_333414 + a_333415
gen n4_3335 = a_333511 + a_333517 + a_333514 + a_33351B
gen n4_3336 = a_333611 + a_333612 + a_333613 + a_333618
gen n4_3339 = a_333914 + a_333912 + a_333920 + a_333991 + a_33399A + a_33399B + a_333993 + a_333994
gen n3_333 = n4_3331 + n4_3332 + n4_3333 + n4_3334 + n4_3335 + n4_3336 + n4_3339

gen n4_3341 = a_334111 + a_334112 + a_334118
gen n4_3342 = a_334210 + a_334220 + a_334290
gen n4_3344 = a_334413 + a_334418 + a_33441A
gen n4_3345 = a_334510 + a_334511 + a_334512 + a_334513 + a_334514 + a_334515 + a_334516 + a_334517 + a_33451A
gen n4_3346 = a_334300 + a_334610 // consolidating codes 3343 and 3346 to reflect CES
gen n3_334 = n4_3341 + n4_3342 + n4_3344 + n4_3345 + n4_3346

gen n4_3351 = a_335110 + a_335120
gen n4_3352 = a_335210 + a_335220
gen n4_3353 = a_335311 + a_335312 + a_335313 + a_335314
gen n4_3359 = a_335911 + a_335912 + a_335920 + a_335930 + a_335991 + a_335999
gen n3_335 = n4_3351 + n4_3352 + n4_3353 + n4_3359

gen n4_3361 = a_336111 + a_336112 + a_336120
gen n4_3362 = a_336211 + a_336212 + a_336213 + a_336214
gen n4_3363 = a_336310 + a_336320 + a_3363A0 + a_336350 + a_336360 + a_336370 + a_336390
gen n4_3364 = a_336411 + a_336412 + a_336413 + a_336414 + a_33641A
gen n4_3366 = a_336611 + a_336612
gen n4_3369 = a_336500 + a_336991 + a_336992 + a_336999 // consolidating codes 3365 and 3369 to reflect CES
gen n3_336 = n4_3361 + n4_3362 + n4_3363 + n4_3364 + n4_3366 + n4_3369

gen n4_3371 = a_337110 + a_337121 + a_337122 + a_33712N + a_337127
gen n4_3372 = a_33721A + a_337215 + a_337900 // consolidating codes 3372 and 3379 to reflect CES
gen n3_337 = n4_3371 + n4_3372

gen n4_3391 = a_339112 + a_339113 + a_339114 + a_339115 + a_339116
gen n4_3399 = a_339910 + a_339920 + a_339930 + a_339940 + a_339950 + a_339990
gen n3_339 = n4_3391 + n4_3399

gen n2_33 = n3_331 + n3_332 + n3_333 + n3_334 + n3_335 + n3_336 + n3_337 + n3_339

gen n4_3111 = a_311111 + a_311119
gen n4_3112 = a_311210 + a_311221 + a_311224 + a_311225 + a_311230
gen n4_3113 = a_311300
gen n4_3114 = a_311410 + a_311420
gen n4_3115 = a_31151A + a_311513 + a_311514 + a_311520
gen n4_3116 = a_31161A + a_311615
gen n4_3117 = a_311700
gen n4_3118 = a_311810 + a_3118A0
gen n4_3119 = a_311910 + a_311920 + a_311930 + a_311940 + a_311990
gen n3_311 = n4_3111 + n4_3112 + n4_3113 + n4_3114 + n4_3115 + n4_3116 + n4_3117 + n4_3118 + n4_3119

*gen n4_3121 = a_312110 + a_312120 + a_312130 + a_312140
*gen n4_3122 = a_312200
gen n3_312 = a_312110 + a_312120 + a_312130 + a_312140 + a_312200 + a_316000 // consolidating codes 312 and 316 to reflect ces
gen n4_3129 = n3_312 // to keep in analysis at 4-digit level

*gen n4_3131 = a_313100
*gen n4_3132 = a_313200
*gen n4_3133 = a_313300
gen n3_313 = a_313100 + a_313200 + a_313300

gen n4_3139 = a_313100 + a_313200 + a_313300 // consolidating codes 3131, 3132, and 3133 to reflect ces and keep 313 in analysis at 4-digit level

gen n4_3141 = a_314110 + a_314120
gen n4_3149 = a_314900
gen n3_314 = n4_3141 + n4_3149

gen n3_315 = a_315000
gen n4_3159 = n3_315  // to keep in analysis at 4-digit level

*gen n3_316 = a_316000

gen n2_31 = n3_311 + n3_312 + n3_313 + n3_314 + n3_315

gen n4_3221 = a_322110 + a_322120 + a_322130
gen n4_3222 = a_322210 + a_322220 + a_322230 + a_322291 + a_322299
gen n3_322 = n4_3221 + n4_3222

gen n4_3231 = a_323110 + a_323120
gen n3_323 = n4_3231

gen n4_3241 = a_324110 + a_324121 + a_324122 + a_324190
gen n3_324 = n4_3241

gen n4_3251 = a_325110 + a_325120 + a_325130 + a_325180 + a_325190
gen n4_3252 = a_325211 + a_3252A0
gen n4_3254 = a_325411 + a_325412 + a_325413 + a_325414
gen n4_3253 = a_325310 + a_325320
gen n4_3255 = a_325510 + a_325520
gen n4_3256 = a_325610 + a_325620
gen n4_3259 = a_325910 + a_3259A0
gen n3_325 = n4_3251 + n4_3252 + n4_3254 + n4_3253 + n4_3255 + n4_3256 + n4_3259

gen n4_3261 = a_326110 + a_326120 + a_326130 + a_326140 + a_326150 + a_326160 + a_326190
gen n4_3262 = a_326210 + a_326220 + a_326290
gen n3_326 = n4_3261 + n4_3262

gen n2_32 = n3_321 + n3_327 + n3_322 + n3_324 + n3_325 + n3_326

gen n4_4231 = a_423100
gen n4_4234 = a_423400
gen n4_4236 = a_423600
gen n4_4238 = a_423800
gen n3_423 = a_423A00 + n4_4231 + n4_4234 + n4_4236 + n4_4238

gen n4_4242 = a_424200
gen n4_4244 = a_424400
gen n4_4247 = a_424700
gen n3_424 = a_424A00 + n4_4242 + n4_4244 + n4_4247

gen n3_425 = a_425000

gen n2_42 = n3_423 + n3_424 + n3_425

gen n3_441 = a_441000
gen n3_444 = a_444000
gen n3_445 = a_445000
gen n3_446 = a_446000
gen n3_447 = a_447000
gen n3_448 = a_448000
gen n2_44 = n3_441 + n3_444 + n3_445 + n3_446 + n3_447 + n3_448

gen n3_452 = a_452000
gen n3_454 = a_454000
gen n3_453 = a_4B0000
gen n2_45 = n3_452 + n3_454 + n3_453

gen n3_481 = a_481000
gen n3_482 = a_482000
gen n3_483 = a_483000
gen n3_484 = a_484000
gen n3_485 = a_485000
gen n3_486 = a_486000
gen n3_487 = a_48A000 // consolidating 487 and 488
gen n2_48 = n3_487 + n3_481 + n3_482 + n3_483 + n3_484 + n3_485 + n3_486

gen n3_492 = a_492000
gen n3_493 = a_493000

gen n4_5111 = a_511110 + a_511120 + a_511130 + a_5111A0
gen n4_5112 = a_511200
gen n3_511 = n4_5111 + n4_5112

gen n4_5121 = a_512100
gen n4_5122 = a_512200
gen n3_512 = n4_5121 + n4_5122

gen n4_5151 = a_515100
gen n4_5152 = a_515200
gen n3_515 = n4_5151 + n4_5152

gen n4_5173 = a_517110 + a_517210
gen n3_517 = a_517A00 + n4_5173

gen n4_5182 = a_518200
gen n3_518 = n4_5182

gen n4_5191 = a_519130 + a_5191A0
gen n3_519 = n4_5191

gen n2_51 = n3_511 + n3_512 + n3_515 + n3_517 + n3_518 + n3_519

gen n3_521 = a_52A000 + a_522A00 // consolidating codes 521 and 522
gen n4_5239 = a_523900
gen n3_523 = a_523A00 + n4_5239
gen n4_5241 = a_524113 + a_5241XX
gen n4_5242 = a_524200
gen n3_524 = n4_5241 + n4_5242
gen n3_525 = a_525000
gen n2_52 = n3_521 + n3_523 + n3_524 + n3_525

gen n3_531 = a_531HST + a_531ORE
gen n4_5321 = a_532100
gen n4_5324 = a_532400
gen n3_532 = a_532A00 + n4_5321 + n4_5324
gen n3_533 = a_533000
gen n2_53 = n3_531 + n3_532 + n3_533

gen n4_5411 = a_541100
gen n4_5412 = a_541200
gen n4_5413 = a_541300
gen n4_5416 = a_541610 + a_5416A0
gen n4_5417 = a_541700
gen n4_5418 = a_541800
gen n4_5414 = a_541400
gen n4_5419 = a_5419A0 + a_541920 + a_541940
gen n4_5415 = a_541511 + a_541512 + a_54151A
gen n3_541 = n4_5411 + n4_5412 + n4_5413 + n4_5416 + n4_5417 + n4_5418 + n4_5414 + n4_5419 + n4_5415
gen n2_54 = n3_541

gen n2_55 = a_550000
gen n3_551 = n2_55
gen n4_5511 = n2_55

gen n4_5613 = a_561300
gen n4_5617 = a_561700
gen n4_5611 = a_561100
gen n4_5612 = a_561200
gen n4_5614 = a_561400
gen n4_5615 = a_561500
gen n4_5616 = a_561600
gen n4_5619 = a_561900
gen n3_561 = n4_5613 + n4_5617 + n4_5611 + n4_5612 + n4_5614 + n4_5615 + n4_5616 + n4_5619
gen n3_562 = a_562000
gen n2_56 = n3_561 + n3_562

gen n4_6111 = a_611100
gen n3_611 = a_611A00 + a_611B00 + n4_6111
gen n2_61 = n3_611

gen n4_6211 = a_621100
gen n4_6212 = a_621200
gen n4_6213 = a_621300
gen n4_6214 = a_621400
gen n4_6215 = a_621500
gen n4_6216 = a_621600
gen n4_6219 = a_621900
gen n3_621 = n4_6211 + n4_6212 + n4_6213 + n4_6214 + n4_6215 + n4_6216 + n4_6219
gen n3_622 = a_622000
gen n3_623 = a_623A00 + a_623B00
gen n4_6241 = a_624100
gen n4_6244 = a_624400
gen n3_624 = a_624A00 + n4_6241 + n4_6244
gen n2_62 = n3_621 + n3_622 + n3_623 + n3_624

gen n4_7111 = a_711100
gen n4_7112 = a_711200
gen n4_7115 = a_711500
gen n3_711 = a_711A00 + n4_7111 + n4_7112 + n4_7115
gen n3_712 = a_712000
gen n4_7131 = a_713100
gen n4_7132 = a_713200
gen n4_7139 = a_713900
gen n3_713 = n4_7131 + n4_7132 + n4_7139
gen n2_71 = n3_711 + n3_712 + n3_713

gen n3_721 = a_721000
gen n3_722 = a_722A00 + a_722110 + a_722211
gen n2_72 = n3_721 + n3_722

gen n4_8111 = a_811100
gen n4_8112 = a_811200
gen n4_8113 = a_811300
gen n4_8114 = a_811400
gen n3_811 = n4_8111 + n4_8112 + n4_8113 + n4_8114
gen n4_8121 = a_812100
gen n4_8122 = a_812200
gen n4_8123 = a_812300
gen n4_8129 = a_812900
gen n3_812 = n4_8121 + n4_8122 + n4_8123 + n4_8129
gen n4_8131 = a_813100
gen n3_813 = a_813A00 + a_813B00 + a_813100
gen n3_814 = a_814000
gen n2_81 = n3_811 + n3_812 + n3_813 + n3_814

gen n3_491 = a_491000
gen n2_49 = n3_492 + n3_493 + n3_491


replace n2_31 = n2_31 + n2_32 + n2_33 // consolidating manufacturing codes
drop n2_32 n2_33
replace n2_44 = n2_44 + n2_45 // consolidating retail trade codes
drop n2_45
replace n2_48 = n2_48 + n2_49 // consolidating transportation & warehousing
drop n2_49

replace n3_453 = n3_453 + n3_448 + n3_454 // consolidating remaining retail codes to reflect CES combinations
drop n3_448 n3_454
replace n3_523 = n3_523 + n3_525 // combining NAICS codes 523 and 525 to reflect CES combination
drop n3_525


* consolidating by NAICS level (lvl)

drop a_*

replace code = "910000" if code == "S00401"
replace code = "930000" if code == "S00402"

drop if substr(code, 1, 1) == "S" | substr(code, 1, 1) == "G"

if `lvl' == 2 | `lvl' == 3 {
	keep code cdesc n`lvl'_*
}
else {
	keep code cdesc n3_1* n4_2* n4_3* n3_4* n3_5* n3_6* n3_7* n4_811* n3_812 n3_813
	rename n3_* n4_*
}

foreach v of varlist n`lvl'_* {
	bysort code : egen a_`v' = total(`v')
}


bysort code : keep if _n == 1

drop n`lvl'_*
rename a_* *


* formatting, saving

keep code cdesc n`lvl'_*
rename code com_detail

reshape long n`lvl'_, i(com_detail) j(n`lvl'ind)
rename n`lvl'_ valuse
order n`lvl'ind com_detail valuse
sort n`lvl'ind com_detail
drop cdesc


** Merging Intermediate and Use data **

merge 1:1 com_detail n`lvl'ind using "$data/matrix_cleaned.dta"
drop _merge

*capture drop if n2ind == 11 // dropping agricultural sector not included in CES

capture drop if n3ind == 814 // dropping private households, as omitted by CES
capture drop if n4ind == 8149
*capture drop if n3ind == 491 // dropping postal service, as partially omitted by CES
*capture drop if n3ind == 111 | n3ind == 112 // dropping agricultural sectors not included in CES

rm "$data/matrix_cleaned.dta"

gen impshare = valimp / valuse // the imported fraction of this commodity by this industry

*destring com_detail, replace

replace impshare = 0 if impshare == .


bysort com_detail : egen total_com_use = total(valuse)
bysort com_detail : egen total_com_imp = total(valimp)

bysort n`lvl'ind : egen total_ind_use = total(valuse)
bysort n`lvl'ind : egen total_ind_imp = total(valimp)

gen ind_impshare = total_ind_imp / total_ind_use

gen com_impshare = total_com_imp / total_com_use // the imported fraction of this commodity among the pool of industries

gen com_indshare = valimp / total_com_imp // fraction of imports of this commodity going to this industry

gen com_frac = valimp / total_ind_imp // fraction of this industry's imports attributable to this commodity

drop if total_com_use == 0


*** Labeling variables -- asterisks next to labels with some variation from 2017 NAICS (either name change or some type of aggregation; see Tariff intermediate analysis industry codes spreadsheet)

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
label def n3ind 239 "Construction*", add
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

label def n4ind 2111 "Oil and Gas Extraction"
label def n4ind 2121 "Coal Mining", add
label def n4ind 2122 "Metal Ore Mining", add
label def n4ind 2123 "Nonmetallic Mineral Mining and Quarrying", add
label def n4ind 2131 "Support Activities for Mining", add
label def n4ind 2211 "Electric Power Generation, Transmission and Distribution", add
label def n4ind 2212 "Natural Gas Distribution", add
label def n4ind 2213 "Water, Sewage and Other Systems", add
label def n4ind 2399 "Construction*", add
label def n4ind 3111 "Animal Food Manufacturing", add
label def n4ind 3112 "Grain and Oilseed Milling", add
label def n4ind 3113 "Sugar and Confectionery Product Manufacturing", add
label def n4ind 3114 "Fruit and Vegetable Preserving and Specialty Food Manufacturing", add
label def n4ind 3115 "Dairy Product Manufacturing", add
label def n4ind 3116 "Animal Slaughtering and Processing", add
label def n4ind 3117 "Seafood Product Preparation and Packaging", add
label def n4ind 3118 "Bakeries and Tortilla Manufacturing", add
label def n4ind 3119 "Other Food Manufacturing", add
label def n4ind 3129 "Beverage, Tobacco, and Leather and Allied Product Manufacturing*", add
label def n4ind 3139 "Textile Mills*",add
label def n4ind 3141 "Textile Furnishings Mills", add
label def n4ind 3149 "Other Textile Product Mills", add
label def n4ind 3159 "Apparel Manufacturing*", add
label def n4ind 3211 "Sawmills and Wood Preservation", add
label def n4ind 3212 "Veneer, Plywood, and Engineered Wood Product Manufacturing", add
label def n4ind 3219 "Other Wood Product Manufacturing", add
label def n4ind 3221 "Pulp, Paper, and Paperboard Mills", add
label def n4ind 3222 "Converted Paper Product Manufacturing", add
label def n4ind 3231 "Printing and Related Support Activities", add
label def n4ind 3241 "Petroleum and Coal Products Manufacturing", add
label def n4ind 3251 "Basic Chemical Manufacturing", add
label def n4ind 3252 "Resin, Synthetic Rubber, and Artificial and Synthetic Fibers and Filaments Manufacturing", add
label def n4ind 3253 "Pesticide, Fertilizer, and Other Agricultural Chemical Manufacturing", add
label def n4ind 3254 "Pharmaceutical and Medicine Manufacturing", add
label def n4ind 3255 "Paint, Coating, and Adhesive Manufacturing", add
label def n4ind 3256 "Soap, Cleaning Compound, and Toilet Preparation Manufacturing", add
label def n4ind 3259 "Other Chemical Product and Preparation Manufacturing", add
label def n4ind 3261 "Plastics Products Manufacturing", add
label def n4ind 3262 "Rubber Product Manufacturing", add
label def n4ind 3271 "Clay Product and Refractory Manufacturing", add
label def n4ind 3272 "Glass and Glass Product Manufacturing", add
label def n4ind 3273 "Cement and Concrete Product Manufacturing", add
label def n4ind 3279 "Lime, gypsum, and other nonmetallic mineral product manufacturing*", add
label def n4ind 3311 "Iron and Steel Mills and Ferroalloy Manufacturing", add
label def n4ind 3312 "Steel Product Manufacturing from Purchased Steel", add
label def n4ind 3314 "Alumina, aluminum, and other nonferrous metal production and processing*", add
label def n4ind 3315 "Foundries", add
label def n4ind 3321 "Forging and Stamping", add
label def n4ind 3323 "Architectural and Structural Metals Manufacturing", add
label def n4ind 3324 "Boiler, Tank, and Shipping Container Manufacturing", add
label def n4ind 3326 "Hardware, spring, and wire product manufacturing*", add
label def n4ind 3327 "Machine Shops; Turned Product; and Screw, Nut, and Bolt Manufacturing", add
label def n4ind 3328 "Coating, Engraving, Heat Treating, and Allied Activities", add
label def n4ind 3329 "Cutlery, handtool, and other fabricated metal product manufacturing*", add
label def n4ind 3331 "Agriculture, Construction, and Mining Machinery Manufacturing", add
label def n4ind 3332 "Industrial Machinery Manufacturing", add
label def n4ind 3333 "Commercial and Service Industry Machinery Manufacturing", add
label def n4ind 3334 "Ventilation, Heating, Air-Conditioning, and Commercial Refrigeration Equipment Manufacturing", add
label def n4ind 3335 "Metalworking Machinery Manufacturing", add
label def n4ind 3336 "Engine, Turbine, and Power Transmission Equipment Manufacturing", add
label def n4ind 3339 "Other General Purpose Machinery Manufacturing", add
label def n4ind 3341 "Computer and Peripheral Equipment Manufacturing", add
label def n4ind 3342 "Communications Equipment Manufacturing", add
label def n4ind 3344 "Semiconductor and Other Electronic Component Manufacturing", add
label def n4ind 3345 "Navigational, Measuring, Electromedical, and Control Instruments Manufacturing", add
label def n4ind 3346 "Manufacturing and reproducing magnetic and optical media and audio and video equipment manufacturing*", add
label def n4ind 3351 "Electric Lighting Equipment Manufacturing", add
label def n4ind 3352 "Household Appliance Manufacturing", add
label def n4ind 3353 "Electrical Equipment Manufacturing", add
label def n4ind 3359 "Other Electrical Equipment and Component Manufacturing", add
label def n4ind 3361 "Motor Vehicle Manufacturing", add
label def n4ind 3362 "Motor Vehicle Body and Trailer Manufacturing", add
label def n4ind 3363 "Motor Vehicle Parts Manufacturing", add
label def n4ind 3364 "Aerospace Product and Parts Manufacturing", add
label def n4ind 3366 "Ship and Boat Building", add
label def n4ind 3369 "Railroad rolling stock and other transportation equipment manufacturing*", add
label def n4ind 3371 "Household and Institutional Furniture and Kitchen Cabinet Manufacturing", add
label def n4ind 3372 "Office furniture (including fixtures) and other furniture related product manufacturing*", add
label def n4ind 3391 "Medical Equipment and Supplies Manufacturing", add
label def n4ind 3399 "Other Miscellaneous Manufacturing", add
label def n4ind 423 "Merchant Wholesalers, Durable Goods", add
label def n4ind 424 "Merchant Wholesalers, Nondurable Goods", add
label def n4ind 425 "Wholesale Trade Agents and Brokers*", add
label def n4ind 441 "Motor Vehicle and Parts Dealers", add
label def n4ind 444 "Building Material and Garden Equipment and Supplies Dealers", add
label def n4ind 445 "Food and Beverage Stores/Retailers*", add
label def n4ind 446 "Health and Personal Care Stores/Retailers*", add
label def n4ind 447 "Gasoline Stations/ Fuel Dealers*", add
label def n4ind 452 "General Merchandise Stores/Retailers*", add
label def n4ind 453 "Other Stores/Retailers*", add
label def n4ind 481 "Air Transportation", add
label def n4ind 482 "Rail Transportation", add
label def n4ind 483 "Water Transportation", add
label def n4ind 484 "Truck Transportation", add
label def n4ind 485 "Transit and Ground Passenger Transportation", add
label def n4ind 486 "Pipeline Transportation", add
label def n4ind 487 "Scenic and Sightseeing Transportationg and Support Activities*", add
label def n4ind 492 "Couriers and Messengers", add
label def n4ind 493 "Warehousing and Storage", add
label def n4ind 511 "Publishing Industries*", add
label def n4ind 512 "Motion Picture and Sound Recording Industries", add
label def n4ind 515 "Broadcasting*", add
label def n4ind 517 "Telecommunications", add
label def n4ind 518 "Data Processing, Hosting, and Related Services", add
label def n4ind 519 "Other Information Services*", add
label def n4ind 521 "Monetary Authorities and Credit Intermediaion and Related Activities*", add
label def n4ind 523 "Securities, Commodity Contracts, Funds, Trusts, and other Financial*", add
label def n4ind 524 "Insurance Carriers and Related Activities", add
label def n4ind 531 "Real Estate", add
label def n4ind 532 "Rental and Leasing Services", add
label def n4ind 533 "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", add
label def n4ind 541 "Professional, Scientific, and Technical Services", add
label def n4ind 551 "Management of Companies and Enterprises", add
label def n4ind 561 "Administrative and Support Services", add
label def n4ind 562 "Waste Management and Remediation Services", add
label def n4ind 611 "Educational Services", add
label def n4ind 621 "Ambulatory Health Care Services", add
label def n4ind 622 "Hospitals", add
label def n4ind 623 "Nursing and Residential Care Facilities", add
label def n4ind 624 "Social Assistance", add
label def n4ind 711 "Performing Arts, Spectator Sports, and Related Industries", add
label def n4ind 712 "Museums, Historical Sites, and Similar Institutions", add
label def n4ind 713 "Amusement, Gambling, and Recreation Industries", add
label def n4ind 721 "Accommodation", add
label def n4ind 722 "Food Services and Drinking Places", add
label def n4ind 8111 "Automotive Repair and Maintenance", add
label def n4ind 8112 "Electronic and Precision Equipment Repair and Maintenance", add
label def n4ind 8113 "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance", add
label def n4ind 8114 "Personal and Household Goods Repair and Maintenance", add
label def n4ind 812 "Personal and Laundry Services", add
label def n4ind 813 "Religious, Grantmaking, Civic, Professional, and Similar Organizations", add

label variable com_detail "NAICS commodity detail"





