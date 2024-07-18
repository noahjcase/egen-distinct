/** Test script of _gdistinct.ado

This script the _gdistinct.ado function, as accessed via `egen distinct`
*/

cscript _gdistinct.ado

webuse query
local prefix `"`r(prefix)'"'
webuse set
webuse `"schools.dta"'

// test of one variable and no by
egen testnoby = distinct(school)
generate int expectednoby = 71
assert expectednoby == testnoby

// test of one variable and a by
bysort district: egen testby = distinct(school)
generate int expectednby = ///
    cond(district == "Richardson", 54, ///
    cond(district == "College Station", 18, /*unreachable*/ .))
assert expectednby == testby

// test of two variables and no by
egen testmultivar = distinct(district level)
generate byte expectedmultivar = 7
assert testmultivar == expectedmultivar

// test of if
bysort district: egen testif = distinct(level) if level != "Elementary school"
generate byte expectedif = ///
    cond(district == "Richardson", 2, ///
    cond(district == "College Station", 3, /*unreachable*/ .a))
replace expectedif = . if level == "Elementary school"
assert testif == expectedif

// test of in
egen testin = distinct(school) in 1/130
generate byte expectedin = cond(_n <= 130, 19, .)
assert testin == expectedin

webuse set `"`prefix'"'