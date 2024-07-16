*! version 1.0, 2024may31. Noah J. Case.

program define _gdistinct, nclass
    version 18.0

    gettoken type 0 : 0
    gettoken newvarname   0 : 0
    gettoken eqs  0 : 0    // known to be "="


    syntax varlist [if] [in], [BY(varlist)]
    marksample touse
    tempvar t1 t2
    if !missing("`by'") {
        bysort `by': egen byte `t1' = tag(`varlist') if `touse'
        bysort `by': egen `type' `t2' = total(`t1') if `touse'
    }

    else {
        egen byte `t1' = tag(`varlist') if `touse'
        egen `type' `t2' = total(`t1') if `touse'
    }

    assert !missing(`t2') & `t2' >= 0
    rename `t2' `newvarname'
end program
