
*First open and run the adofile for cgmreg*

*Cleaning and setting data frame* 
destring Year, replace
drop if GauNumber==3 & Year==1933 & Reichsgau_y==. 

destring gauleiter_experience, replace
xtset GauNumber Year

rename Reichsgau_x Reichsgau

*Generation of age variable*
generate gauleiter_age = Year-gauleiter_birth_year

generate agesquared= gauleiter_age^2 

*Coding SS promotions*
generate non_SS_promotion=0
replace non_SS_promotion=1 if gauleiter_promotion_wide==1 & gauleiter_SS_promotion==0 
replace non_SS_promotion=. if gauleiter_promotion_wide==.

replace gauleiter_SS_promotion=. if gauleiter_promotion_wide==. 


*Coding SA promotions*
generate gauleiter_sa_promotion=0
replace gauleiter_sa_promotion=1 if gauleiter_promotion_wide==1  & gauleiter_SS_promotion==0 & gauleiter_promotion_minimal==0 
replace gauleiter_sa_promotion=. if gauleiter_promotion_wide==. 


*Generation of dummy for promotion in occupied territory"
generate promotion_occupied=0
replace promotion_occupied=1 if GauNumber==7 & Year==1940
replace promotion_occupied=1 if GauNumber==13 & Year==1943
replace promotion_occupied=1 if GauNumber==14 & Year==1944
replace promotion_occupied=1 if GauNumber==28 & Year==1942
replace promotion_occupied=1 if GauNumber==35 & Year==1941
replace promotion_occupied=1 if GauNumber==45 & Year==1941


*Promotions without those in occupied territory*
generate non_occupied_promotion = gauleiter_promotion_minimal
replace non_occupied_promotion=0 if promotion_occupied==1

*Log of new members*
generate logmembers= log(Newmembers)
replace logmembers=0 if Newmembers==0

*Table 1: Descriptive statitiscs *
xtsum gauleiter_promotion_wide gauleiter_promotion_minimal gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_entry_year gauleiter_WW1_service  gauleiter_entry_before_legal logmembers if BeschaftigeChange!=. & Reichsgau!=1 & GauNumber!=34

xtsum PropNewMembers gauleiter_entry_year  if  Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945



*Table 2: Regime-wide promotions employment*
cgmreg gauleiter_promotion_minimal BeschaftigeChange  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 
cgmreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
coefplot, keep( BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers)  xtitle (Effect on promotion likelihood) ylabel(, format(%9.1f)) xline(0) graphregion(color(white)) coeflabels(BeschaftigeChange="Change in employment" gauleiter_entry_before_legal= "Gauleiter Nazi Party entry before 1925" gauleiter_age=" Gauleiter age"  gauleiter_WW1_service="Gauleiter WW1 service"  logmembers="Log of new Nazi Party members" ) levels(99 95 90)



xtreg gauleiter_promotion_minimal  BeschaftigeChange  i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34
xtreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_before_legal i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34

xtreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34

xtreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34


* Table 2: before and after outbreak of WWII*
generate war=0
replace war=1 if Year>1938


cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
coefplot, keep( BeschaftigeChange war c.BeschaftigeChange#c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers)  xtitle (Effect on promotion likelihood) ylabel(, format(%9.1f)) xline(0) graphregion(color(white)) coeflabels(BeschaftigeChange="Change in employment (Peacetime)" war="War" c.BeschaftigeChange#c.war="War X change in employment" gauleiter_entry_before_legal= "Gauleiter Nazi Party entry before 1925" gauleiter_age=" Gauleiter age"  gauleiter_WW1_service="Gauleiter WW1 service"  logmembers="Log of new Nazi Party members" ) levels(99 95 90)

xtreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(BeschaftigeChange) over(war)
marginsplot,  level(90) ytitle (Marginal effect of change in employment) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)



*Table 2 : Pooled regression (dropping Gau-fixed effects)
cgmreg gauleiter_promotion_minimal BeschaftigeChange  i.Year , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 
cgmreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_before_legal i.Year , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


reg gauleiter_promotion_minimal  BeschaftigeChange  i.Year if Reichsgau!=1 & GauNumber!=34
reg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_before_legal i.Year if Reichsgau!=1 & GauNumber!=34

reg gauleiter_promotion_minimal BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year if Reichsgau!=1 & GauNumber!=34

reg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year  if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

reg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year  if Reichsgau!=1 & GauNumber!=34




*Figure in appendix: Interaction with year of entry* 
cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_entry_year c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(war) over(gauleiter_entry_year)
marginsplot,  level(90) ytitle (Effect of war on promotion likelihood)  xtitle(Year of entering the party) ylabel(, format(%9.1f)) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)

xtreg gauleiter_promotion_minimal  c.war##c.gauleiter_entry_year c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34


*_______________________________________________Appendices__________________________________________________*


*Appendix: Number of promotions over time*
bysort Year : egen year_sum_promotion = sum(gauleiter_promotion_minimal)
twoway (line year_sum_promotion Year),graphregion(color(white))legend (off) ytitle(Number of Gauleiter promotions) ylabel( 0 1 2 3 4, format(%9.0f)) xlabel(1936 1937 1938 1939 1940 1941 1942 1943 1944), if Year>1935 & Year<1945

bysort Year : egen year_sum_nonoc_promotion = sum(non_occupied_promotion)
twoway (line year_sum_nonoc_promotion Year),graphregion(color(white))legend (off) ytitle(Number of Gauleiter promotions) ylabel( 0 1 2 3 4, format(%9.0f)) xlabel(1936 1937 1938 1939 1940 1941 1942 1943 1944), if Year>1935 & Year<1945



xtset GauNumber Year



*Appendix: Results without promotions in occupied territories*
cgmreg non_occupied_promotion c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

xtreg non_occupied_promotion  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe, if Reichsgau!=1 & GauNumber!=34




*Apppendix: Excluding Berlin*
cgmreg  gauleiter_promotion_minimal BeschaftigeChange  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9
cgmreg  gauleiter_promotion_minimal BeschaftigeChange   gauleiter_entry_before_legal  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9
cgmreg  gauleiter_promotion_minimal BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9
cgmreg  gauleiter_promotion_minimal BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9
cgmreg  gauleiter_promotion_minimal c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9

xtreg gauleiter_promotion_minimal  BeschaftigeChange  i.Year, fe, if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9
xtreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_before_legal i.Year, fe, if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9

xtreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year, fe, if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9

xtreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe,   if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9

xtreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe,   if Reichsgau!=1 & GauNumber!=34 & GauNumber!=9




cgmreg non_occupied_promotion c.war##c.gauleiter_entry_year c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(war) over(gauleiter_entry_year)
marginsplot,  level(90) ytitle (Effect of war on promotion likelihood)  xtitle(Year of entering the party) ylabel(, format(%9.1f)) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)


cgmreg non_occupied_promotion c.war##c.BeschaftigeChange c.war##c.gauleiter_entry_year  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(war) over(gauleiter_entry_year)
marginsplot,  level(90) ytitle (Effect of war on promotion likelihood)  xtitle(Year of entering the party) ylabel(, format(%9.1f)) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)



*Appendix: Excluding negative employment growth*
sum BeschaftigeChange if war==0
sum BeschaftigeChange if war==1
cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & BeschaftigeChange>0


xtreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe,   if Reichsgau!=1 & GauNumber!=34 & BeschaftigeChange>0


*Appendix and Foot note: Execution*
sum gauleiter_executed if Year==1944
corr gauleiter_promotion_minimal  gauleiter_executed 
cgmreg gauleiter_promotion_minimal  gauleiter_executed c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  gauleiter_executed BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34 & war==0
xtreg gauleiter_promotion_minimal  gauleiter_executed BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe ,if Reichsgau!=1 & GauNumber!=34 & war==0

cgmreg gauleiter_promotion_minimal  gauleiter_executed BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34 & war==1
xtreg gauleiter_promotion_minimal  gauleiter_executed BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe ,if Reichsgau!=1 & GauNumber!=34 & war==1




cgmreg  non_occupied_promotion gauleiter_executed BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34 & war==0

cgmreg non_occupied_promotion  gauleiter_executed BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34 & war==1

*Appendix : Split sample

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & war==0
xtreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34 & war==0

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & war==1
xtreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34 & war==1


*Appendix: interaction of war with WW1 experience*
cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war c.gauleiter_WW1_service##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

xtreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age c.gauleiter_WW1_service##c.war  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34




*Appendix: Use of Gauleiter rather than Gau fixed effects*
encode Gauleiter_x, gen(Gauleiter_num)

cgmreg gauleiter_promotion_minimal BeschaftigeChange  i.Year i.Gauleiter_num , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 
cgmreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_before_legal i.Year i.Gauleiter_num , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.Gauleiter_num , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.Gauleiter_num , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year  i.Gauleiter_num  , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


xtreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year  i.Gauleiter_num if Reichsgau!=1 & GauNumber!=34

reg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year  i.Gauleiter_num if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age   logmembers i.Year  i.Gauleiter_num  , cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

xtreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  logmembers i.Year  i.Gauleiter_num if Reichsgau!=1 & GauNumber!=34

reg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age   logmembers i.Year  i.Gauleiter_num if Reichsgau!=1 & GauNumber!=34





*Appendix: Coal analysis


encode Bergbaubezirk, gen(n_berbau)

generate changecoal= (ton_coal_production-l.ton_coal_production)/l.ton_coal_production
replace changecoal= 0 if ton_coal_production==0 & l.ton_coal_production==0
replace changecoal=. if Year==1945

cgmreg gauleiter_promotion_minimal  changecoal  i.Year i.GauNumber, cluster( n_berbau Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  changecoal gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( n_berbau Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  c.changecoal##c.war   gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( n_berbau Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(changecoal) over(war)
marginsplot,  level(90) ytitle (Effect of coal production growth on promotion likelihoood) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)


cgmreg gauleiter_promotion_minimal  c.changecoal##c.war  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(BeschaftigeChange) over(war)
marginsplot,  level(90) ytitle (Effect of employment growth on promotion likelihoood) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)


cgmreg gauleiter_promotion_minimal  changecoal  BeschaftigeChange   i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34
xtreg gauleiter_promotion_minimal  changecoal  BeschaftigeChange    i.Year, fe, if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  changecoal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34
xtreg gauleiter_promotion_minimal  changecoal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe ,if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  changecoal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34
xtreg gauleiter_promotion_minimal  changecoal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe ,if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  c.changecoal##c.war   c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(BeschaftigeChange) over(war)
marginsplot,  level(90) ytitle (Effect of employment growth on promotion likelihoood) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)

xtreg gauleiter_promotion_minimal  c.changecoal##c.war   c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year, fe,if Reichsgau!=1 & GauNumber!=34



cgmreg gauleiter_promotion_minimal  c.changecoal##c.war c.war##c.BeschaftigeChange c.war##c.gauleiter_entry_year gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(war) over(gauleiter_entry_year)
marginsplot,  level(90) ytitle (Effect of war on promotion likelihood)  xtitle(Year of entering the party) ylabel(, format(%9.1f)) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)

*________________________________Analyses in footnotes*_____________________________________*

*Foot note: War from 1940 and onwards*
generate war4=0
replace war4=1 if Year>1939

cgmreg gauleiter_promotion_minimal  c.war4##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

*Foot note split sample*
cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & war==0

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & war==1


*Foot note: Interacting entry before legal with war*
cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_entry_before_legal   BeschaftigeChange gauleiter_age  gauleiter_WW1_service   logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_entry_before_legal  c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service   logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(gauleiter_entry_before_lega) over(war)
marginsplot,  level(90) ytitle (Effect of entry before legalization on promotion likelihood)  xtitle(War status) xlabel ( 0 "Peace" 1 "War") yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))ylabel(, format(%9.1f)) graphregion(color(white))legend (off)



cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_entry_year  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(war) over(gauleiter_entry_year)
marginsplot,  level(90) ytitle (Effect of war on promotion likelihood)  xtitle(Year of entering the Party) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))ylabel(, format(%9.1f)) graphregion(color(white))legend (off)



cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_entry_year c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(war) over(gauleiter_entry_year)
marginsplot,  level(90) ytitle (Effect of war on promotion likelihood)  xtitle(Year of entering the Party) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)


*Foot note: Controlling for lagged promotions* 

cgmreg gauleiter_promotion_minimal  l.gauleiter_promotion_minimal BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion l.gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal l.gauleiter_promotion_minimal  TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion l.gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34

cgmreg gauleiter_promotion_minimal l.gauleiter_promotion_minimal c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion l.gauleiter_SS_promotion c.war##c.BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if  Reichsgau!=1  & GauNumber!=34

cgmreg gauleiter_promotion_minimal l.gauleiter_promotion_minimal c.war##c.TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion l.gauleiter_SS_promotion c.war##c.TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal l.gauleiter_promotion_minimal logmembers gauleiter_age BeschaftigeChange   gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( GauNumber Year),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945


cgmreg gauleiter_promotion_minimal l.gauleiter_promotion_minimal  logmembers c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34  



*Foot note: Loyalty as year of entry into the Nazi Party* 


*Loyalty and performance models all promotions all years*


*Regime-wide promotions*
cgmreg gauleiter_promotion_minimal BeschaftigeChange  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 
cgmreg gauleiter_promotion_minimal BeschaftigeChange gauleiter_entry_year  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_year i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg gauleiter_promotion_minimal   c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service   gauleiter_entry_year  i.Year i.GauNumber, cluster( AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34  

cgmreg gauleiter_promotion_minimal    gauleiter_age  gauleiter_WW1_service   gauleiter_entry_year i.Year i.GauNumber, cluster( AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34  & Year>1936 & Year<1945
cgmreg gauleiter_promotion_minimal   BeschaftigeChange gauleiter_age  gauleiter_WW1_service   gauleiter_entry_year logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34  & Year>1936 & Year<1945

cgmreg gauleiter_promotion_minimal    c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service   logmembers gauleiter_entry_year i.Year i.GauNumber, cluster( AreanumberBeschaftige  Year),if Reichsgau!=1 & GauNumber!=34  



*_______________________ Other analyses: Not in paper________________________________________________*



*Over time, year of entering the Nazi Party 
cgmreg gauleiter_promotion_minimal  c.gauleiter_entry_year##i.Year  c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(gauleiter_entry_year) over(i.Year)
marginsplot,  level(90) ytitle (Effect of pre-1925 membership on promotion likelihood)  xtitle(Year) ylabel(, format(%9.1f)) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)




*Over time pre-1925
cgmreg gauleiter_promotion_minimal  c.gauleiter_entry_before_legal##i.Year  c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(gauleiter_entry_before_legal) over(i.Year)
marginsplot,  level(90) ytitle (Effect of pre-1925 membership on promotion likelihood)  xtitle(Year) ylabel(, format(%9.1f)) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)




*Use of 1923 coup partipant status as measure of loyalty*
cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_putsch logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg gauleiter_promotion_minimal  c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_putsch  logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_putsch c.war##c.BeschaftigeChange   gauleiter_age  gauleiter_WW1_service   logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(gauleiter_putsch) over(war)
marginsplot,  level(90) ytitle (Effect of 1923 coup on promotion likelihoood) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)

*All promotions*
cgmreg gauleiter_promotion_wide  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_promotion_wide c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg non_SS_promotion  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  non_SS_promotion c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_sa_promotion BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_sa_promotion c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


cgmreg gauleiter_SS_promotion BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg gauleiter_SS_promotion gauleiter_sa_promotion c.BeschaftigeChange##c.war gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


*Interacting war with doctorate*
cgmreg gauleiter_promotion_minimal c.war##c.gauleiter_doctorate c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
margins, dydx(gauleiter_doctorate) over(war)
marginsplot,  level(90) ytitle (Effect of doctorate on promotion likelihoood) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)

*Doctorate no interaction*
cgmreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service gauleiter_doctorate  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

*Without outlying observation*
cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & BeschaftigeChange <0.45


cgmreg gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34 & BeschaftigeChange <0.45
margins, dydx(BeschaftigeChange) over(war)
marginsplot,  level(90) ytitle (Marginal effect of change in employment) xlabel ( 0 "Peace" 1 "War") xtitle(Status) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)



*Use of panel corrected standard errors indstead of double clustering*
xtpcse gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34
xtpcse gauleiter_promotion_minimal  c.war##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34
xtpcse gauleiter_promotion_minimal  c.war##c.gauleiter_entry_year c.war##c.BeschaftigeChange  gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34




*Promotions within the SS* 

* Employment*
cgmreg  gauleiter_SS_promotion  BeschaftigeChange  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

xtreg  gauleiter_SS_promotion  BeschaftigeChange  i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34
xtreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_entry_before_legal i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34

xtreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age  gauleiter_WW1_service gauleiter_doctorate  gauleiter_entry_before_legal i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34

xtreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34


*Employment and war*

cgmreg  gauleiter_SS_promotion c.war##c.BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal logmembers  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if  Reichsgau!=1  & GauNumber!=34
xtreg  gauleiter_SS_promotion c.war##c.BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal logmembers  i.Year i.GauNumber if  Reichsgau!=1  & GauNumber!=34


* Analysis with deviations in agricultural delivery* 
cgmreg  gauleiter_SS_promotion  TotalIndexDev   i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34

cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34


cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34

xtreg  gauleiter_SS_promotion  TotalIndexDev   i.Year i.GauNumber if  GauNumber!=34 
xtreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_entry_before_legal i.Year i.GauNumber if  GauNumber!=34 

xtreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service   gauleiter_entry_before_legal i.Year i.GauNumber  if  GauNumber!=34

xtreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service   gauleiter_entry_before_legal logmembers i.Year i.GauNumber  if  GauNumber!=34


cgmreg  gauleiter_SS_promotion c.war##c.TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal logmembers i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Reichsgau!=1 & GauNumber!=34
xtreg  gauleiter_SS_promotion c.war##c.TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal logmembers i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34



*What is SS promotions driven by*
cgmreg  gauleiter_SS_promotion RogIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion WeizIndexDev gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion GerIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion HaferIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34




* SS promotions*
cgmreg  gauleiter_SS_promotion  BeschaftigeChange  i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_entry_year i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_year i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

xtreg  gauleiter_SS_promotion  BeschaftigeChange  i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34
xtreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_entry_year i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34

xtreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_year i.Year i.GauNumber if Reichsgau!=1 & GauNumber!=34



cgmreg  gauleiter_SS_promotion  TotalIndexDev   i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_entry_year  i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34

cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_year  i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34

xtreg  gauleiter_SS_promotion  TotalIndexDev   i.Year i.GauNumber  if  GauNumber!=34
xtreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_entry_year i.Year i.GauNumber  if  GauNumber!=34

xtreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service  gauleiter_entry_year i.Year i.GauNumber  if  GauNumber!=34

*What is SS promotions driven by*
cgmreg  gauleiter_SS_promotion RogIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_year i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion WeizIndexDev gauleiter_age gauleiter_WW1_service gauleiter_entry_year i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion GerIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_year i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34
cgmreg  gauleiter_SS_promotion HaferIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_year  i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  GauNumber!=34


*War and WWII experience*
cgmreg gauleiter_promotion_minimal  c.war##c.gauleiter_WW1_service   BeschaftigeChange gauleiter_age   gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion c.war##c.gauleiter_WW1_service  BeschaftigeChange gauleiter_age  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if  Reichsgau!=1  & GauNumber!=34
 
cgmreg gauleiter_promotion_minimal c.war##c.gauleiter_WW1_service  TotalIndexDev gauleiter_age  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion c.war##c.gauleiter_WW1_service TotalIndexDev  gauleiter_age  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Reichsgau!=1 & GauNumber!=34


*Alternative coding of the war*
generate war2=0
replace war2=1 if Year>1941

cgmreg gauleiter_promotion_minimal  c.war2##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion c.war2##c.BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if  Reichsgau!=1  & GauNumber!=34

cgmreg gauleiter_promotion_minimal c.war2##c.TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if  Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion c.war2##c.TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Reichsgau!=1 & GauNumber!=34


generate war3=0
replace war3=1 if Year>1940

cgmreg gauleiter_promotion_minimal  c.war3##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34

generate war4=0
replace war4=1 if Year>1939

cgmreg gauleiter_promotion_minimal  c.war4##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34


generate notborman=0
replace notborman=1 if Year==1939

cgmreg gauleiter_promotion_minimal  c.notborman##c.BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Reichsgau!=1 & GauNumber!=34



*_______________________________________________________________________*

*Additional tests*


*  Membership growth*
cgmreg gauleiter_promotion_minimal  PropNewMembers i.Year i.GauNumber, cluster( GauNumber Year),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945
xtreg gauleiter_promotion_minimal  PropNewMembers i.Year i.GauNumber, cluster( GauNumber ),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945

cgmreg gauleiter_promotion_minimal  PropNewMembers gauleiter_entry_before_legal i.Year i.GauNumber, cluster( GauNumber Year),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945
xtreg gauleiter_promotion_minimal  PropNewMembers gauleiter_entry_before_legal i.Year i.GauNumber, cluster( GauNumber ),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945

cgmreg gauleiter_promotion_minimal  PropNewMembers gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( GauNumber Year),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945
xtreg gauleiter_promotion_minimal  PropNewMembers gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( GauNumber ),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945


generate jordanpromotion=0
replace jordanpromotion=1 if GauNumber==10 & Year==1937
cgmreg gauleiter_promotion_minimal  PropNewMembers gauleiter_entry_before_legal gauleiter_WW1_service gauleiter_age i.Year i.GauNumber, cluster( GauNumber Year),if Reichsgau!=1 & GauNumber!=34 & Year>1936 & Year<1945 & jordanpromotion==0



*Running separate regressions* 
*Before: employment*

cgmreg gauleiter_promotion_wide BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year), if Year<1939 & Reichsgau!=1 & GauNumber!=34
cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age  gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Year<1939 & Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Year<1939 & Reichsgau!=1  & GauNumber!=34


*After: Employment*
cgmreg gauleiter_promotion_wide BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year), if Year>1938 & Reichsgau!=1 & GauNumber!=34
cgmreg gauleiter_promotion_minimal  BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year), if Year>1938 & Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion BeschaftigeChange gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster( AreanumberBeschaftige Year),if Year>1938 & Reichsgau!=1 & GauNumber!=34



*Before: grain*
cgmreg gauleiter_promotion_wide TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Year<1939 & Reichsgau!=1 & GauNumber!=34
cgmreg gauleiter_promotion_minimal TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Year<1939 & Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Year<1939 & Reichsgau!=1 & GauNumber!=34



*After: grain*
cgmreg gauleiter_promotion_wide TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Year>1938 & Reichsgau!=1 & GauNumber!=34
cgmreg gauleiter_promotion_minimal TotalIndexDev gauleiter_age gauleiter_WW1_service  gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Year>1938 & Reichsgau!=1 & GauNumber!=34
cgmreg  gauleiter_SS_promotion TotalIndexDev  gauleiter_age gauleiter_WW1_service gauleiter_entry_before_legal i.Year i.GauNumber, cluster(Landesbauernschaft_number Year), if Year>1938 & Reichsgau!=1 & GauNumber!=34




