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

* cross-walking commodity NAICS codes

gen naics = ""

replace naics = "1111" if code == "1111A0" | code == "1111B0"
replace naics = "1112" if code == "111200"
replace naics = "1113" if code == "111300"
replace naics = "1114" if code == "111400"
replace naics = "1119" if code == "111900"

replace naics = "1121" if code == "1121A0"
replace naics = "11212" if code == "112120"
replace naics = "112" if code == "112A00"
replace naics = "1123" if code == "112300"

replace naics = "113" if code == "113000"
replace naics = "114" if code == "114000"
replace naics = "115" if code == "115000"

replace naics = "211" if code == "211000"

replace naics = "2121" if code == "212100"
replace naics = "2122" if code == "2122A0"
replace naics = "21223" if code == "212230"
replace naics = "21231" if code == "212310"
replace naics = "2123" if code == "2123A0"

replace naics = "213111" if code == "213111"
replace naics = "21311" if code == "21311A"

replace naics = "2211" if code == "221100"
replace naics = "2212" if code == "221200"
replace naics = "2213" if code == "221300"

replace naics = "23" if code == "233210" | code == "233262" | code == "2332A0" | code == "233240" | code == "2332C0" | code == "233230" | code == "2332D0" | code == "233411" | code == "233412" | code == "2334A0" | code == "230301" | code == "230302"
expand 2 if naics == "23", gen(newv) // producing code 231 (equivalent to 2-digit code 23, intended to keep construction in analysis at 3-digit level)
replace naics = "231" if newv==1
drop newv

replace naics = "3211" if code == "321100"
replace naics = "3212" if code == "321200"
replace naics = "32191" if code == "321910"
replace naics = "3219" if code == "3219A0"

replace naics = "3271" if code == "327100"
replace naics = "3272" if code == "327200"
replace naics = "32731" if code == "327310"
replace naics = "32732" if code == "327320"
replace naics = "32733" if code == "327330"
replace naics = "32739" if code == "327390"
replace naics = "3274" if code == "327400"
replace naics = "32791" if code == "327910"
replace naics = "327991" if code == "327991"
replace naics = "327992" if code == "327992"
replace naics = "327993" if code == "327993"
replace naics = "327999" if code == "327999"

replace naics = "3311" if code == "331110"
replace naics = "3312" if code == "331200"

replace naics = "331313" if code == "331313"
replace naics = "331314" if code == "331314"
replace naics = "33131" if code == "33131B"
replace naics = "331410" if code == "331410"
replace naics = "33142" if code == "331420"
replace naics = "33149" if code == "331490"
replace naics = "33151" if code == "331510"
replace naics = "33152" if code == "331520"

replace naics = "33211" if code == "33211A"
replace naics = "332114" if code == "332114"
replace naics = "332119" if code == "332119"
replace naics = "3322" if code == "332200"
replace naics = "33231" if code == "332310"
replace naics = "33232" if code == "332320"
replace naics = "33241" if code == "332410"
replace naics = "33242" if code == "332420"
replace naics = "33243" if code == "332430"
replace naics = "3325" if code == "332500"
replace naics = "3326" if code == "332600"
replace naics = "33271" if code == "332710"
replace naics = "33272" if code == "332720"
replace naics = "3328" if code == "332800"
replace naics = "33291" if code == "33291A"
replace naics = "332913" if code == "332913"
replace naics = "332991" if code == "332991"
replace naics = "33299" if code == "33299A"
replace naics = "332996" if code == "332996"
replace naics = "332999" if code == "332999"

replace naics = "333111" if code == "333111"
replace naics = "333112" if code == "333112"

replace naics = "33312" if code == "333120"

replace naics = "33313" if code == "333130"

replace naics = "333242" if code == "333242"
replace naics = "33324" if code == "33329A"
replace naics = "333314" if code == "333314"
replace naics = "333316" if code == "333316"
replace naics = "333318" if code == "333318"
replace naics = "333413" if code == "333413"
replace naics = "333414" if code == "333414"
replace naics = "333415" if code == "333415"
replace naics = "333511" if code == "333511"
replace naics = "333517" if code == "333517"
replace naics = "333514" if code == "333514"
replace naics = "33351" if code == "33351B"
replace naics = "333611" if code == "333611"
replace naics = "333612" if code == "333612"
replace naics = "333613" if code == "333613"
replace naics = "333618" if code == "333618"
replace naics = "333914" if code == "333914"
replace naics = "333912" if code == "333912"
replace naics = "33392" if code == "333920"
replace naics = "333991" if code == "333991"
replace naics = "33399" if code == "33399A" | code == "33399B"
replace naics = "333993" if code == "333993"
replace naics = "333994" if code == "333994"

replace naics = "334111" if code == "334111"
replace naics = "334112" if code == "334112"
replace naics = "334118" if code == "334118"

replace naics = "33421" if code == "334210"
replace naics = "33422" if code == "334220"
replace naics = "33429" if code == "334290"

replace naics = "334413" if code == "334413"
replace naics = "334418" if code == "334418"
replace naics = "33441" if code == "33441A"

replace naics = "334510" if code == "334510"
replace naics = "334511" if code == "334511"
replace naics = "334512" if code == "334512"
replace naics = "334513" if code == "334513"
replace naics = "334514" if code == "334514"
replace naics = "334515" if code == "334515"
replace naics = "334516" if code == "334516"
replace naics = "334517" if code == "334517"
replace naics = "334519" if code == "33451A"

replace naics = "3343" if code == "334300"
replace naics = "33461" if code == "334610"

replace naics = "33511" if code == "335110"
replace naics = "33512" if code == "335120"
replace naics = "33521" if code == "335210"
replace naics = "335220" if code == "335220"
replace naics = "335311" if code == "335311"
replace naics = "335312" if code == "335312"
replace naics = "335313" if code == "335313"
replace naics = "335314" if code == "335314"
replace naics = "335911" if code == "335911"
replace naics = "335912" if code == "335912"
replace naics = "33592" if code == "335920"
replace naics = "33593" if code == "335930"
replace naics = "335991" if code == "335991"
replace naics = "335999" if code == "335999"

replace naics = "336111" if code == "336111"

replace naics = "336112" if code == "336112"

replace naics = "33612" if code == "336120"

replace naics = "336211" if code == "336211"
replace naics = "336212" if code == "336212"
replace naics = "336213" if code == "336213"
replace naics = "336214" if code == "336214"
replace naics = "33631" if code == "336310"
replace naics = "33632" if code == "336320"
replace naics = "3363" if code == "3363A0"
replace naics = "33635" if code == "336350"
replace naics = "33636" if code == "336360"
replace naics = "33637" if code == "336370"
replace naics = "33639" if code == "336390"

replace naics = "336411" if code == "336411"
replace naics = "336412" if code == "336412"
replace naics = "336413" if code == "336413"
replace naics = "336414" if code == "336414"
replace naics = "33641" if code == "33641A"

replace naics = "3365" if code == "336500"
replace naics = "336611" if code == "336611"
replace naics = "336612" if code == "336612"
replace naics = "336991" if code == "336991"
replace naics = "336992" if code == "336992"
replace naics = "336999" if code == "336999"

replace naics = "33711" if code == "337110"
replace naics = "337121" if code == "337121"
replace naics = "337122" if code == "337122"
replace naics = "33712" if code == "33712N"
replace naics = "337127" if code == "337127"
replace naics = "33721" if code == "33721A"
replace naics = "337215" if code == "337215"
replace naics = "3379" if code == "337900"

replace naics = "339112" if code == "339112"
replace naics = "339113" if code == "339113"
replace naics = "339114" if code == "339114"
replace naics = "339115" if code == "339115"
replace naics = "339116" if code == "339116"

replace naics = "33991" if code == "339910"
replace naics = "33992" if code == "339920"
replace naics = "33993" if code == "339930"
replace naics = "33994" if code == "339940"
replace naics = "33995" if code == "339950"
replace naics = "33999" if code == "339990"

replace naics = "311111" if code == "311111"
replace naics = "311119" if code == "311119"
replace naics = "31121" if code == "311210"
replace naics = "311221" if code == "311221"
replace naics = "311224" if code == "311224"
replace naics = "311225" if code == "311225"
replace naics = "31123" if code == "311230"
replace naics = "3113" if code == "311300"
replace naics = "31141" if code == "311410"
replace naics = "31142" if code == "311420"
replace naics = "31151" if code == "31151A"
replace naics = "311513" if code == "311513"
replace naics = "311514" if code == "311514"
replace naics = "31152" if code == "311520"
replace naics = "31161" if code == "31161A"
replace naics = "311615" if code == "311615"
replace naics = "3117" if code == "311700"
replace naics = "31181" if code == "311810"
replace naics = "3118" if code == "3118A0"
replace naics = "31191" if code == "311910"
replace naics = "31192" if code == "311920"
replace naics = "31193" if code == "311930"
replace naics = "31194" if code == "311940"
replace naics = "31199" if code == "311990"

replace naics = "31211" if code == "312110"
replace naics = "31212" if code == "312120"
replace naics = "31213" if code == "312130"
replace naics = "31214" if code == "312140"

replace naics = "3122" if code == "312200"

replace naics = "3131" if code == "313100"
replace naics = "3132" if code == "313200"
replace naics = "3133" if code == "313300"
replace naics = "31411" if code == "314110"
replace naics = "31412" if code == "314120"
replace naics = "3149" if code == "314900"

replace naics = "315" if code == "315000"
replace naics = "316" if code == "316000"

replace naics = "32211" if code == "322110"
replace naics = "32212" if code == "322120"
replace naics = "32213" if code == "322130"
replace naics = "32221" if code == "322210"
replace naics = "32222" if code == "322220"
replace naics = "32223" if code == "322230"
replace naics = "322291" if code == "322291"
replace naics = "322299" if code == "322299"

replace naics = "32311" if code == "323110"
replace naics = "32312" if code == "323120"

replace naics = "32411" if code == "324110"
replace naics = "324121" if code == "324121"
replace naics = "324122" if code == "324122"
replace naics = "32419" if code == "324190"

replace naics = "32511" if code == "325110"
replace naics = "32512" if code == "325120"
replace naics = "32513" if code == "325130"
replace naics = "32518" if code == "325180"
replace naics = "32519" if code == "325190"

replace naics = "325211" if code == "325211"
replace naics = "3252" if code == "3252A0"

replace naics = "325411" if code == "325411"
replace naics = "325412" if code == "325412"
replace naics = "325413" if code == "325413"
replace naics = "325414" if code == "325414"

replace naics = "32531" if code == "325310"
replace naics = "32532" if code == "325320"
replace naics = "32551" if code == "325510"
replace naics = "32552" if code == "325520"
replace naics = "32561" if code == "325610"
replace naics = "32562" if code == "325620"
replace naics = "32591" if code == "325910"
replace naics = "3259" if code == "3259A0"

replace naics = "32611" if code == "326110"
replace naics = "32612" if code == "326120"
replace naics = "32613" if code == "326130"
replace naics = "32614" if code == "326140"
replace naics = "32615" if code == "326150"
replace naics = "32616" if code == "326160"
replace naics = "32619" if code == "326190"
replace naics = "32621" if code == "326210"
replace naics = "32622" if code == "326220"
replace naics = "32629" if code == "326290"

replace naics = "4231" if code == "423100"
replace naics = "4234" if code == "423400"
replace naics = "4236" if code == "423600"
replace naics = "4238" if code == "423800"
replace naics = "423" if code == "423A00"
replace naics = "4242" if code == "424200"
replace naics = "4244" if code == "424400"
replace naics = "4247" if code == "424700"
replace naics = "424" if code == "424A00"
replace naics = "425" if code == "425000"

replace naics = "441" if code == "441000"
replace naics = "445" if code == "445000"
replace naics = "452" if code == "452000"
replace naics = "444" if code == "444000"
replace naics = "446" if code == "446000"
replace naics = "447" if code == "447000"
replace naics = "448" if code == "448000"
replace naics = "454" if code == "454000"
replace naics = "453" if code == "4B0000"

replace naics = "481" if code == "481000"
replace naics = "482" if code == "482000"
replace naics = "483" if code == "483000"
replace naics = "484" if code == "484000"
replace naics = "485" if code == "485000"
replace naics = "486" if code == "486000"
replace naics = "487" if code == "48A000" // consolidating 487 and 488
replace naics = "492" if code == "492000"
replace naics = "493" if code == "493000"

replace naics = "51111" if code == "511110"
replace naics = "51112" if code == "511120"
replace naics = "51113" if code == "511130"
replace naics = "5111" if code == "5111A0"
replace naics = "51121" if code == "511200"
replace naics = "5121" if code == "512100"
replace naics = "5122" if code == "512200"
replace naics = "5151" if code == "515100"
replace naics = "5152" if code == "515200"
replace naics = "517311" if code == "517110"
replace naics = "517312" if code == "517210"
replace naics = "517" if code == "517A00"
replace naics = "5182" if code == "518200"
replace naics = "51913" if code == "519130"
replace naics = "5191" if code == "5191A0"

replace naics = "521" if code == "52A000" | code == "522A00" // consolidating codes 521 and 522
replace naics = "523" if code == "523A00"
replace naics = "5239" if code == "523900"
replace naics = "524113" if code == "524113"
replace naics = "5241" if code == "5241XX"
replace naics = "5242" if code == "524200"
replace naics = "525" if code == "525000"

replace naics = "531" if code == "531HST" | code == "531ORE"
replace naics = "5321" if code == "532100"
replace naics = "532" if code == "532A00"
replace naics = "5324" if code == "532400"
replace naics = "533" if code == "533000"

replace naics = "5411" if code == "541100"
replace naics = "5412" if code == "541200"
replace naics = "5413" if code == "541300"
replace naics = "54161" if code == "541610"
replace naics = "5416" if code == "5416A0"
replace naics = "5417" if code == "541700"
replace naics = "5418" if code == "541800"
replace naics = "5414" if code == "541400"
replace naics = "5419" if code == "5419A0"
replace naics = "54192" if code == "541920"
replace naics = "54194" if code == "541940"
replace naics = "541511" if code == "541511"
replace naics = "541512" if code == "541512"
replace naics = "54151" if code == "54151A"

replace naics = "55" if code == "550000"
expand 2 if code == "550000", gen(newv) // producing code 551
replace naics = "551" if newv==1
drop newv

replace naics = "5613" if code == "561300"
replace naics = "5617" if code == "561700"
replace naics = "5611" if code == "561100"
replace naics = "5612" if code == "561200"
replace naics = "5614" if code == "561400"
replace naics = "5615" if code == "561500"
replace naics = "5616" if code == "561600"
replace naics = "5619" if code == "561900"
replace naics = "562" if code == "562000"

replace naics = "6111" if code == "611100"
replace naics = "611" if code == "611A00" | code == "611B00"

replace naics = "6211" if code == "621100"
replace naics = "6212" if code == "621200"
replace naics = "6213" if code == "621300"
replace naics = "6214" if code == "621400"
replace naics = "6215" if code == "621500"
replace naics = "6216" if code == "621600"
replace naics = "6219" if code == "621900"
replace naics = "622" if code == "622000"
replace naics = "623" if code == "623A00" | code == "623B00"
replace naics = "6241" if code == "624100"
replace naics = "624" if code == "624A00"
replace naics = "6244" if code == "624400"

replace naics = "7111" if code == "711100"
replace naics = "7112" if code == "711200"
replace naics = "711" if code == "711A00"
replace naics = "7115" if code == "711500"
replace naics = "712" if code == "712000"
replace naics = "7131" if code == "713100"
replace naics = "7132" if code == "713200"
replace naics = "7139" if code == "713900"

replace naics = "721" if code == "721000"
replace naics = "722511" if code == "722110"
replace naics = "722513" if code == "722211"
replace naics = "722" if code == "722A00"

replace naics = "8111" if code == "811100"
replace naics = "8112" if code == "811200"
replace naics = "8113" if code == "811300"
replace naics = "8114" if code == "811400"
replace naics = "8121" if code == "812100"
replace naics = "8122" if code == "812200"
replace naics = "8123" if code == "812300"
replace naics = "8129" if code == "812900"
replace naics = "8131" if code == "813100"
replace naics = "813" if code == "813A00" | code == "813B00"
replace naics = "814" if code == "814000"

replace naics = "491" if code == "491000"
replace naics = "." if naics == ""


* aggregating commodities at the 2-, 3-, and 4-digit level

gen naics4 = substr(naics,1,4) if strlen(naics)>3
replace naics4 = "." if naics4 == ""

gen naics3 = substr(naics,1,3) if strlen(naics)>2
replace naics3 = "." if naics3 == ""

gen naics2 = substr(naics,1,2) if strlen(naics)>1
replace naics2 = "31" if naics2 == "32" | naics2 == "33" // consolidating manufacturing codes
replace naics2 = "44" if naics2 == "45" // consolidating retail trade codes
replace naics2 = "48" if naics2 == "49" // consolidating transportation & warehousing
replace naics2 = "." if naics2 == ""


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

gen n2_11 = n3_111 + n3_112

gen n3_211 = a_211000

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
gen n3_231 = n2_23 // generating code 231, equivalent to 2-digit code 23, in order to keep construction in analysis at 3-digit level

gen n4_3211 = a_321100
gen n4_3212 = a_321200
gen n4_3219 = a_321910 + a_3219A0
gen n3_321 = n4_3211 + n4_3212 + n4_3219

gen n4_3271 = a_327100
gen n4_3272 = a_327200
gen n4_3273 = a_327310 + a_327320 + a_327330 + a_327390
gen n4_3274 = a_327400
gen n4_3279 = a_327910 + a_327992 + a_327993 + a_327999
gen n3_327 = n4_3271 + n4_3272 + n4_3273 + n4_3274 + n4_3279

gen n4_3311 = a_331110
gen n4_3312 = a_331200
gen n4_3313 = a_331313 + a_331314 + a_33131B
gen n4_3314 = a_331410 + a_331420 + a_331490
gen n4_3315 = a_331510 + a_331520
gen n3_331 = n4_3311 + n4_3312 + n4_3313 + n4_3314 + n4_3315

gen n4_3321 = a_33211A + a_332114 + a_332119
gen n4_3322 = a_332200
gen n4_3323 = a_332310 + a_332320
gen n4_3324 = a_332410 + a_332420 + a_332430
gen n4_3325 = a_332500
gen n4_3326 = a_332600
gen n4_3327 = a_332710 + a_332720
gen n4_3328 = a_332800
gen n4_3329 = a_33291A + a_332913 + a_332991 + a_33299A + a_332996 + a_332999
gen n3_332 = n4_3321 + n4_3322 + n4_3323 + n4_3324 + n4_3325 + n4_3326 + n4_3327 + n4_3328 + n4_3329

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
gen n4_3343 = a_334300
gen n4_3346 = a_334610
gen n3_334 = n4_3341 + n4_3342 + n4_3344 + n4_3345 + n4_3343 + n4_3346

gen n4_3351 = a_335110 + a_335120
gen n4_3352 = a_335210 + a_335220
gen n4_3353 = a_335311 + a_335312 + a_335313 + a_335314
gen n4_3359 = a_335911 + a_335912 + a_335920 + a_335930 + a_335991 + a_335999
gen n3_335 = n4_3351 + n4_3352 + n4_3353 + n4_3359

gen n4_3361 = a_336111 + a_336112 + a_336120
gen n4_3362 = a_336211 + a_336212 + a_336213 + a_336214
gen n4_3363 = a_336310 + a_336320 + a_3363A0 + a_336350 + a_336360 + a_336370 + a_336390
gen n4_3364 = a_336411 + a_336412 + a_336413 + a_336414 + a_33641A
gen n4_3365 = a_336500
gen n4_3366 = a_336611 + a_336612
gen n4_3369 = a_336991 + a_336992 + a_336999
gen n3_336 = n4_3361 + n4_3362 + n4_3363 + n4_3364 + n4_3365 + n4_3366 + n4_3369

gen n4_3371 = a_337110 + a_337121 + a_337122 + a_33712N + a_337127
gen n4_3372 = a_33721A + a_337215
gen n4_3379 = a_337900
gen n3_337 = n4_3371 + n4_3372 + n4_3379

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

gen n4_3121 = a_312110 + a_312120 + a_312130 + a_312140
gen n4_3122 = a_312200
gen n3_312 = n4_3121 + n4_3122

gen n4_3131 = a_313100
gen n4_3132 = a_313200
gen n4_3133 = a_313300
gen n3_313 = n4_3131 + n4_3132 + n4_3133

gen n4_3141 = a_314110 + a_314120
gen n4_3149 = a_314900
gen n3_314 = n4_3141 + n4_3149

gen n3_315 = a_315000
gen n3_316 = a_316000

gen n2_31 = n3_311 + n3_312 + n3_313 + n3_314 + n3_315 + n3_316

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
gen n4_7225 = a_722110 + a_722211
gen n3_722 = a_722A00 + n4_7225
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

replace n3_312 = n3_312 + n3_316 // combining NAICS codes 312 and 316 to reflect CES combination
drop n3_316
replace n3_453 = n3_453 + n3_448 + n3_454 // consolidating remaining retail codes to reflect CES combinations
drop n3_448 n3_454
replace n3_523 = n3_523 + n3_525 // combining NAICS codes 523 and 525 to reflect CES combination
drop n3_525


* consolidating commodities by NAICS level (lvl)

drop if naics`lvl' == "."

keep code cdesc naics`lvl' n`lvl'_*

foreach v of varlist n`lvl'_* {
	bysort naics`lvl' : egen a_`v' = total(`v')
}


bysort naics`lvl' : keep if _n == 1

drop n`lvl'_*
rename a_* *


* formatting, saving

keep code cdesc naics`lvl' n`lvl'_*
rename naics`lvl' n`lvl'com

reshape long n`lvl'_, i(n`lvl'com) j(n`lvl'ind)
rename n`lvl'_ valimp
order n`lvl'ind n`lvl'com valimp
sort n`lvl'ind n`lvl'com
drop code cdesc

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

* cross-walking commodity NAICS codes

gen naics = ""

replace naics = "1111" if code == "1111A0" | code == "1111B0"
replace naics = "1112" if code == "111200"
replace naics = "1113" if code == "111300"
replace naics = "1114" if code == "111400"
replace naics = "1119" if code == "111900"

replace naics = "1121" if code == "1121A0"
replace naics = "11212" if code == "112120"
replace naics = "112" if code == "112A00"
replace naics = "1123" if code == "112300"

replace naics = "113" if code == "113000"
replace naics = "114" if code == "114000"
replace naics = "115" if code == "115000"

replace naics = "211" if code == "211000"

replace naics = "2121" if code == "212100"
replace naics = "2122" if code == "2122A0"
replace naics = "21223" if code == "212230"
replace naics = "21231" if code == "212310"
replace naics = "2123" if code == "2123A0"

replace naics = "213111" if code == "213111"
replace naics = "21311" if code == "21311A"

replace naics = "2211" if code == "221100"
replace naics = "2212" if code == "221200"
replace naics = "2213" if code == "221300"

replace naics = "23" if code == "233210" | code == "233262" | code == "2332A0" | code == "233240" | code == "2332C0" | code == "233230" | code == "2332D0" | code == "233411" | code == "233412" | code == "2334A0" | code == "230301" | code == "230302"
expand 2 if naics == "23", gen(newv) // producing code 231 (equivalent to 2-digit code 23, intended to keep construction in analysis at 3-digit level)
replace naics = "231" if newv==1
drop newv

replace naics = "3211" if code == "321100"
replace naics = "3212" if code == "321200"
replace naics = "32191" if code == "321910"
replace naics = "3219" if code == "3219A0"

replace naics = "3271" if code == "327100"
replace naics = "3272" if code == "327200"
replace naics = "32731" if code == "327310"
replace naics = "32732" if code == "327320"
replace naics = "32733" if code == "327330"
replace naics = "32739" if code == "327390"
replace naics = "3274" if code == "327400"
replace naics = "32791" if code == "327910"
replace naics = "327991" if code == "327991"
replace naics = "327992" if code == "327992"
replace naics = "327993" if code == "327993"
replace naics = "327999" if code == "327999"

replace naics = "3311" if code == "331110"
replace naics = "3312" if code == "331200"

replace naics = "331313" if code == "331313"
replace naics = "331314" if code == "331314"
replace naics = "33131" if code == "33131B"
replace naics = "331410" if code == "331410"
replace naics = "33142" if code == "331420"
replace naics = "33149" if code == "331490"
replace naics = "33151" if code == "331510"
replace naics = "33152" if code == "331520"

replace naics = "33211" if code == "33211A"
replace naics = "332114" if code == "332114"
replace naics = "332119" if code == "332119"
replace naics = "3322" if code == "332200"
replace naics = "33231" if code == "332310"
replace naics = "33232" if code == "332320"
replace naics = "33241" if code == "332410"
replace naics = "33242" if code == "332420"
replace naics = "33243" if code == "332430"
replace naics = "3325" if code == "332500"
replace naics = "3326" if code == "332600"
replace naics = "33271" if code == "332710"
replace naics = "33272" if code == "332720"
replace naics = "3328" if code == "332800"
replace naics = "33291" if code == "33291A"
replace naics = "332913" if code == "332913"
replace naics = "332991" if code == "332991"
replace naics = "33299" if code == "33299A"
replace naics = "332996" if code == "332996"
replace naics = "332999" if code == "332999"

replace naics = "333111" if code == "333111"
replace naics = "333112" if code == "333112"

replace naics = "33312" if code == "333120"

replace naics = "33313" if code == "333130"

replace naics = "333242" if code == "333242"
replace naics = "33324" if code == "33329A"
replace naics = "333314" if code == "333314"
replace naics = "333316" if code == "333316"
replace naics = "333318" if code == "333318"
replace naics = "333413" if code == "333413"
replace naics = "333414" if code == "333414"
replace naics = "333415" if code == "333415"
replace naics = "333511" if code == "333511"
replace naics = "333517" if code == "333517"
replace naics = "333514" if code == "333514"
replace naics = "33351" if code == "33351B"
replace naics = "333611" if code == "333611"
replace naics = "333612" if code == "333612"
replace naics = "333613" if code == "333613"
replace naics = "333618" if code == "333618"
replace naics = "333914" if code == "333914"
replace naics = "333912" if code == "333912"
replace naics = "33392" if code == "333920"
replace naics = "333991" if code == "333991"
replace naics = "33399" if code == "33399A" | code == "33399B"
replace naics = "333993" if code == "333993"
replace naics = "333994" if code == "333994"

replace naics = "334111" if code == "334111"
replace naics = "334112" if code == "334112"
replace naics = "334118" if code == "334118"

replace naics = "33421" if code == "334210"
replace naics = "33422" if code == "334220"
replace naics = "33429" if code == "334290"

replace naics = "334413" if code == "334413"
replace naics = "334418" if code == "334418"
replace naics = "33441" if code == "33441A"

replace naics = "334510" if code == "334510"
replace naics = "334511" if code == "334511"
replace naics = "334512" if code == "334512"
replace naics = "334513" if code == "334513"
replace naics = "334514" if code == "334514"
replace naics = "334515" if code == "334515"
replace naics = "334516" if code == "334516"
replace naics = "334517" if code == "334517"
replace naics = "334519" if code == "33451A"

replace naics = "3343" if code == "334300"
replace naics = "33461" if code == "334610"

replace naics = "33511" if code == "335110"
replace naics = "33512" if code == "335120"
replace naics = "33521" if code == "335210"
replace naics = "335220" if code == "335220"
replace naics = "335311" if code == "335311"
replace naics = "335312" if code == "335312"
replace naics = "335313" if code == "335313"
replace naics = "335314" if code == "335314"
replace naics = "335911" if code == "335911"
replace naics = "335912" if code == "335912"
replace naics = "33592" if code == "335920"
replace naics = "33593" if code == "335930"
replace naics = "335991" if code == "335991"
replace naics = "335999" if code == "335999"

replace naics = "336111" if code == "336111"

replace naics = "336112" if code == "336112"

replace naics = "33612" if code == "336120"

replace naics = "336211" if code == "336211"
replace naics = "336212" if code == "336212"
replace naics = "336213" if code == "336213"
replace naics = "336214" if code == "336214"
replace naics = "33631" if code == "336310"
replace naics = "33632" if code == "336320"
replace naics = "3363" if code == "3363A0"
replace naics = "33635" if code == "336350"
replace naics = "33636" if code == "336360"
replace naics = "33637" if code == "336370"
replace naics = "33639" if code == "336390"

replace naics = "336411" if code == "336411"
replace naics = "336412" if code == "336412"
replace naics = "336413" if code == "336413"
replace naics = "336414" if code == "336414"
replace naics = "33641" if code == "33641A"

replace naics = "3365" if code == "336500"
replace naics = "336611" if code == "336611"
replace naics = "336612" if code == "336612"
replace naics = "336991" if code == "336991"
replace naics = "336992" if code == "336992"
replace naics = "336999" if code == "336999"

replace naics = "33711" if code == "337110"
replace naics = "337121" if code == "337121"
replace naics = "337122" if code == "337122"
replace naics = "33712" if code == "33712N"
replace naics = "337127" if code == "337127"
replace naics = "33721" if code == "33721A"
replace naics = "337215" if code == "337215"
replace naics = "3379" if code == "337900"

replace naics = "339112" if code == "339112"
replace naics = "339113" if code == "339113"
replace naics = "339114" if code == "339114"
replace naics = "339115" if code == "339115"
replace naics = "339116" if code == "339116"

replace naics = "33991" if code == "339910"
replace naics = "33992" if code == "339920"
replace naics = "33993" if code == "339930"
replace naics = "33994" if code == "339940"
replace naics = "33995" if code == "339950"
replace naics = "33999" if code == "339990"

replace naics = "311111" if code == "311111"
replace naics = "311119" if code == "311119"
replace naics = "31121" if code == "311210"
replace naics = "311221" if code == "311221"
replace naics = "311224" if code == "311224"
replace naics = "311225" if code == "311225"
replace naics = "31123" if code == "311230"
replace naics = "3113" if code == "311300"
replace naics = "31141" if code == "311410"
replace naics = "31142" if code == "311420"
replace naics = "31151" if code == "31151A"
replace naics = "311513" if code == "311513"
replace naics = "311514" if code == "311514"
replace naics = "31152" if code == "311520"
replace naics = "31161" if code == "31161A"
replace naics = "311615" if code == "311615"
replace naics = "3117" if code == "311700"
replace naics = "31181" if code == "311810"
replace naics = "3118" if code == "3118A0"
replace naics = "31191" if code == "311910"
replace naics = "31192" if code == "311920"
replace naics = "31193" if code == "311930"
replace naics = "31194" if code == "311940"
replace naics = "31199" if code == "311990"

replace naics = "31211" if code == "312110"
replace naics = "31212" if code == "312120"
replace naics = "31213" if code == "312130"
replace naics = "31214" if code == "312140"

replace naics = "3122" if code == "312200"

replace naics = "3131" if code == "313100"
replace naics = "3132" if code == "313200"
replace naics = "3133" if code == "313300"
replace naics = "31411" if code == "314110"
replace naics = "31412" if code == "314120"
replace naics = "3149" if code == "314900"

replace naics = "315" if code == "315000"
replace naics = "316" if code == "316000"

replace naics = "32211" if code == "322110"
replace naics = "32212" if code == "322120"
replace naics = "32213" if code == "322130"
replace naics = "32221" if code == "322210"
replace naics = "32222" if code == "322220"
replace naics = "32223" if code == "322230"
replace naics = "322291" if code == "322291"
replace naics = "322299" if code == "322299"

replace naics = "32311" if code == "323110"
replace naics = "32312" if code == "323120"

replace naics = "32411" if code == "324110"
replace naics = "324121" if code == "324121"
replace naics = "324122" if code == "324122"
replace naics = "32419" if code == "324190"

replace naics = "32511" if code == "325110"
replace naics = "32512" if code == "325120"
replace naics = "32513" if code == "325130"
replace naics = "32518" if code == "325180"
replace naics = "32519" if code == "325190"

replace naics = "325211" if code == "325211"
replace naics = "3252" if code == "3252A0"

replace naics = "325411" if code == "325411"
replace naics = "325412" if code == "325412"
replace naics = "325413" if code == "325413"
replace naics = "325414" if code == "325414"

replace naics = "32531" if code == "325310"
replace naics = "32532" if code == "325320"
replace naics = "32551" if code == "325510"
replace naics = "32552" if code == "325520"
replace naics = "32561" if code == "325610"
replace naics = "32562" if code == "325620"
replace naics = "32591" if code == "325910"
replace naics = "3259" if code == "3259A0"

replace naics = "32611" if code == "326110"
replace naics = "32612" if code == "326120"
replace naics = "32613" if code == "326130"
replace naics = "32614" if code == "326140"
replace naics = "32615" if code == "326150"
replace naics = "32616" if code == "326160"
replace naics = "32619" if code == "326190"
replace naics = "32621" if code == "326210"
replace naics = "32622" if code == "326220"
replace naics = "32629" if code == "326290"

replace naics = "4231" if code == "423100"
replace naics = "4234" if code == "423400"
replace naics = "4236" if code == "423600"
replace naics = "4238" if code == "423800"
replace naics = "423" if code == "423A00"
replace naics = "4242" if code == "424200"
replace naics = "4244" if code == "424400"
replace naics = "4247" if code == "424700"
replace naics = "424" if code == "424A00"
replace naics = "425" if code == "425000"

replace naics = "441" if code == "441000"
replace naics = "445" if code == "445000"
replace naics = "452" if code == "452000"
replace naics = "444" if code == "444000"
replace naics = "446" if code == "446000"
replace naics = "447" if code == "447000"
replace naics = "448" if code == "448000"
replace naics = "454" if code == "454000"
replace naics = "453" if code == "4B0000"

replace naics = "481" if code == "481000"
replace naics = "482" if code == "482000"
replace naics = "483" if code == "483000"
replace naics = "484" if code == "484000"
replace naics = "485" if code == "485000"
replace naics = "486" if code == "486000"
replace naics = "487" if code == "48A000"
replace naics = "492" if code == "492000"
replace naics = "493" if code == "493000"

replace naics = "51111" if code == "511110"
replace naics = "51112" if code == "511120"
replace naics = "51113" if code == "511130"
replace naics = "5111" if code == "5111A0"
replace naics = "51121" if code == "511200"
replace naics = "5121" if code == "512100"
replace naics = "5122" if code == "512200"
replace naics = "5151" if code == "515100"
replace naics = "5152" if code == "515200"
replace naics = "517311" if code == "517110"
replace naics = "517312" if code == "517210"
replace naics = "517" if code == "517A00"
replace naics = "5182" if code == "518200"
replace naics = "51913" if code == "519130"
replace naics = "5191" if code == "5191A0"

replace naics = "521" if code == "52A000" | code == "522A00" // consolidating codes 521 and 522 
replace naics = "523" if code == "523A00"
replace naics = "5239" if code == "523900"
replace naics = "524113" if code == "524113"
replace naics = "5241" if code == "5241XX"
replace naics = "5242" if code == "524200"
replace naics = "525" if code == "525000"

replace naics = "531" if code == "531HST" | code == "531ORE"
replace naics = "5321" if code == "532100"
replace naics = "532" if code == "532A00"
replace naics = "5324" if code == "532400"
replace naics = "533" if code == "533000"

replace naics = "5411" if code == "541100"
replace naics = "5412" if code == "541200"
replace naics = "5413" if code == "541300"
replace naics = "54161" if code == "541610"
replace naics = "5416" if code == "5416A0"
replace naics = "5417" if code == "541700"
replace naics = "5418" if code == "541800"
replace naics = "5414" if code == "541400"
replace naics = "5419" if code == "5419A0"
replace naics = "54192" if code == "541920"
replace naics = "54194" if code == "541940"
replace naics = "541511" if code == "541511"
replace naics = "541512" if code == "541512"
replace naics = "54151" if code == "54151A"

replace naics = "55" if code == "550000"
replace naics = "55" if code == "550000"
expand 2 if code == "550000", gen(newv) // producing code 551
replace naics = "551" if newv==1
drop newv

replace naics = "5613" if code == "561300"
replace naics = "5617" if code == "561700"
replace naics = "5611" if code == "561100"
replace naics = "5612" if code == "561200"
replace naics = "5614" if code == "561400"
replace naics = "5615" if code == "561500"
replace naics = "5616" if code == "561600"
replace naics = "5619" if code == "561900"
replace naics = "562" if code == "562000"

replace naics = "6111" if code == "611100"
replace naics = "611" if code == "611A00" | code == "611B00"

replace naics = "6211" if code == "621100"
replace naics = "6212" if code == "621200"
replace naics = "6213" if code == "621300"
replace naics = "6214" if code == "621400"
replace naics = "6215" if code == "621500"
replace naics = "6216" if code == "621600"
replace naics = "6219" if code == "621900"
replace naics = "622" if code == "622000"
replace naics = "623" if code == "623A00" | code == "623B00"
replace naics = "6241" if code == "624100"
replace naics = "624" if code == "624A00"
replace naics = "6244" if code == "624400"

replace naics = "7111" if code == "711100"
replace naics = "7112" if code == "711200"
replace naics = "711" if code == "711A00"
replace naics = "7115" if code == "711500"
replace naics = "712" if code == "712000"
replace naics = "7131" if code == "713100"
replace naics = "7132" if code == "713200"
replace naics = "7139" if code == "713900"

replace naics = "721" if code == "721000"
replace naics = "722511" if code == "722110"
replace naics = "722513" if code == "722211"
replace naics = "722" if code == "722A00"

replace naics = "8111" if code == "811100"
replace naics = "8112" if code == "811200"
replace naics = "8113" if code == "811300"
replace naics = "8114" if code == "811400"
replace naics = "8121" if code == "812100"
replace naics = "8122" if code == "812200"
replace naics = "8123" if code == "812300"
replace naics = "8129" if code == "812900"
replace naics = "8131" if code == "813100"
replace naics = "813" if code == "813A00" | code == "813B00"
replace naics = "814" if code == "814000"

replace naics = "491" if code == "491000"
replace naics = "." if naics == ""


* aggregating commodities at the 2-, 3-, and 4-digit level

gen naics4 = substr(naics,1,4) if strlen(naics)>3
replace naics4 = "." if naics4 == ""

gen naics3 = substr(naics,1,3) if strlen(naics)>2
replace naics3 = "." if naics3 == ""

gen naics2 = substr(naics,1,2) if strlen(naics)>1
replace naics2 = "31" if naics2 == "32" | naics2 == "33" // consolidating manufacturing codes
replace naics2 = "44" if naics2 == "45" // consolidating retail trade codes
replace naics2 = "48" if naics2 == "49" // consolidating transportation & warehousing
replace naics2 = "." if naics2 == ""


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

gen n2_11 = n3_111 + n3_112

gen n3_211 = a_211000

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
gen n3_231 = n2_23 // generating code 231, equivalent to 2-digit code 23, in order to keep construction in analysis at 3-digit level

gen n4_3211 = a_321100
gen n4_3212 = a_321200
gen n4_3219 = a_321910 + a_3219A0
gen n3_321 = n4_3211 + n4_3212 + n4_3219

gen n4_3271 = a_327100
gen n4_3272 = a_327200
gen n4_3273 = a_327310 + a_327320 + a_327330 + a_327390
gen n4_3274 = a_327400
gen n4_3279 = a_327910 + a_327992 + a_327993 + a_327999
gen n3_327 = n4_3271 + n4_3272 + n4_3273 + n4_3274 + n4_3279

gen n4_3311 = a_331110
gen n4_3312 = a_331200
gen n4_3313 = a_331313 + a_331314 + a_33131B
gen n4_3314 = a_331410 + a_331420 + a_331490
gen n4_3315 = a_331510 + a_331520
gen n3_331 = n4_3311 + n4_3312 + n4_3313 + n4_3314 + n4_3315

gen n4_3321 = a_33211A + a_332114 + a_332119
gen n4_3322 = a_332200
gen n4_3323 = a_332310 + a_332320
gen n4_3324 = a_332410 + a_332420 + a_332430
gen n4_3325 = a_332500
gen n4_3326 = a_332600
gen n4_3327 = a_332710 + a_332720
gen n4_3328 = a_332800
gen n4_3329 = a_33291A + a_332913 + a_332991 + a_33299A + a_332996 + a_332999
gen n3_332 = n4_3321 + n4_3322 + n4_3323 + n4_3324 + n4_3325 + n4_3326 + n4_3327 + n4_3328 + n4_3329

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
gen n4_3343 = a_334300
gen n4_3346 = a_334610
gen n3_334 = n4_3341 + n4_3342 + n4_3344 + n4_3345 + n4_3343 + n4_3346

gen n4_3351 = a_335110 + a_335120
gen n4_3352 = a_335210 + a_335220
gen n4_3353 = a_335311 + a_335312 + a_335313 + a_335314
gen n4_3359 = a_335911 + a_335912 + a_335920 + a_335930 + a_335991 + a_335999
gen n3_335 = n4_3351 + n4_3352 + n4_3353 + n4_3359

gen n4_3361 = a_336111 + a_336112 + a_336120
gen n4_3362 = a_336211 + a_336212 + a_336213 + a_336214
gen n4_3363 = a_336310 + a_336320 + a_3363A0 + a_336350 + a_336360 + a_336370 + a_336390
gen n4_3364 = a_336411 + a_336412 + a_336413 + a_336414 + a_33641A
gen n4_3365 = a_336500
gen n4_3366 = a_336611 + a_336612
gen n4_3369 = a_336991 + a_336992 + a_336999
gen n3_336 = n4_3361 + n4_3362 + n4_3363 + n4_3364 + n4_3365 + n4_3366 + n4_3369

gen n4_3371 = a_337110 + a_337121 + a_337122 + a_33712N + a_337127
gen n4_3372 = a_33721A + a_337215
gen n4_3379 = a_337900
gen n3_337 = n4_3371 + n4_3372 + n4_3379

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

gen n4_3121 = a_312110 + a_312120 + a_312130 + a_312140
gen n4_3122 = a_312200
gen n3_312 = n4_3121 + n4_3122

gen n4_3131 = a_313100
gen n4_3132 = a_313200
gen n4_3133 = a_313300
gen n3_313 = n4_3131 + n4_3132 + n4_3133

gen n4_3141 = a_314110 + a_314120
gen n4_3149 = a_314900
gen n3_314 = n4_3141 + n4_3149

gen n3_315 = a_315000
gen n3_316 = a_316000

gen n2_31 = n3_311 + n3_312 + n3_313 + n3_314 + n3_315 + n3_316

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
gen n3_487 = a_48A000
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
gen n4_7225 = a_722110 + a_722211
gen n3_722 = a_722A00 + n4_7225
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

replace n3_312 = n3_312 + n3_316 // combining NAICS codes 312 and 316 to reflect CES combination
drop n3_316
replace n3_453 = n3_453 + n3_448 + n3_454 // consolidating remaining retail codes to reflect CES combinations
drop n3_448 n3_454
replace n3_523 = n3_523 + n3_525 // combining NAICS codes 523 and 525 to reflect CES combination
drop n3_525


* consolidating commodities by NAICS level (lvl)

drop if naics`lvl' == "."

keep code cdesc naics`lvl' n`lvl'_*

foreach v of varlist n`lvl'_* {
	bysort naics`lvl' : egen a_`v' = total(`v')
}


bysort naics`lvl' : keep if _n == 1

drop n`lvl'_*
rename a_* *


* formatting

keep code cdesc naics`lvl' n`lvl'_*
rename naics`lvl' n`lvl'com

reshape long n`lvl'_, i(n`lvl'com) j(n`lvl'ind)
rename n`lvl'_ valuse
order n`lvl'ind n`lvl'com valuse
sort n`lvl'ind n`lvl'com
drop code cdesc


** Merging Intermediate and Use data **

merge 1:1 n`lvl'com n`lvl'ind using "$data/matrix_cleaned.dta"
drop _merge

*capture drop if n2ind == 11 // dropping agricultural sector not included in CES

capture drop if n3ind == 814 // dropping private households, as omitted by CES
capture drop if n3ind == 491 // dropping postal service, as partially omitted by CES
*capture drop if n3ind == 111 | n3ind == 112 // dropping agricultural sectors not included in CES

rm "$data/matrix_cleaned.dta"

gen impshare = valimp / valuse // the imported fraction of this commodity by this industry

destring n`lvl'com, replace

replace impshare = 0 if impshare == .


bysort n`lvl'com : egen total_com_use = total(valuse)
bysort n`lvl'com : egen total_com_imp = total(valimp)

bysort n`lvl'ind : egen total_ind_use = total(valuse)
bysort n`lvl'ind : egen total_ind_imp = total(valimp)

gen ind_impshare = total_ind_imp / total_ind_use

gen com_impshare = total_com_imp / total_com_use // the imported fraction of this commodity among the pool of industries

gen com_indshare = valimp / total_com_imp // fraction of imports of this commodity going to this industry




