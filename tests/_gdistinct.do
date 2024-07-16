/** Test script of _gdistinct.ado

This script the _gdistinct.ado function, as accessed via `egen distinct`
*/

cscript _gdistinct.ado

websuse query
local prefix `"`r(prefix)'"'
webuse set
webuse `"`schools.dta'"'

// test of one variable and no by
egen test1 = distinct(school)
generate int expected1 = 71
assert expected1 == test1