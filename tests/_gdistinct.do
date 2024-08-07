/** Test script of _gdistinct.ado

This script the _gdistinct.ado function, as accessed via `egen distinct`.

Be sure that the directory where _gdistinct.ado is stored is on your adopath.
*/

cscript _gdistinct.ado
version 18.0

webuse query
local prefix `"`r(prefix)'"'
webuse set
webuse `"schools.dta"'

// test of one variable and no by
egen testnoby = distinct(school)
generate int expectednoby = 71
assert expectednoby == testnoby

// test of the above but with different types
egen double testnobydouble = distinct(school)
assert expectednoby == testnobydouble
assert "`:type testnobydouble'" == "double"

egen long testnobylong = distinct(school)
assert expectednoby == testnobylong
assert "`:type testnobylong'" == "long"

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

// test of missing values in the byvars
preserve
    replace district = "" if school == "Yale Elementary School"
    bysort district: egen int testbymissok = distinct(school), bymissok
    bysort district: egen int testbymiss = distinct(school)

    generate int expectedbymissok = ///
        cond(district == "College Station", 18, ///
        cond(district == "Richardson", 53, ///
        cond(district == "", 1, /*unreachable*/ .)))
    generate int expectedbymiss = ///
        cond(district == "College Station", 18, ///
        cond(district == "Richardson", 53, ///
        cond(district == "", 0, /*unreachable*/ .)))

    assert testbymissok == expectedbymissok
    assert testbymiss == expectedbymiss
restore

// test of missing in the vars
preserve
    replace school = "" if ///
        inlist(school, "Yale Elementary School", "Wallace Elementary School")
    bysort district: egen int testmiss = distinct(school)
    generate int expectedmiss = ///
        cond(district == "College Station", 18, ///
        cond(district == "Richardson", 52, /*unreachable*/ .))

    assert testmiss == expectedmiss
restore

// test that error-handling code works
rcof "egen testjsyntaxerror = distinct(school), bymissok" == 198

webuse set `"`prefix'"'
