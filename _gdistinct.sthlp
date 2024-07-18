{smcl}
{* *! version 18.0 07jul2018}{...}
{title:Title}

    {cmdab:distinct} is an {cmd:egen} function to compute the number of distinct
    observations of a {varlist}

{title:Syntax}

    [{help by} {varlist}:] {help egen} [{help type}] newvar = distinct({varlist}) [{help if}] [{help in}]

{title:Description}

    {cmdab:distinct} is an {cmd:egen} function that generates a new variable
    holding a count of the number of distinct observation of a given {varlist},
    optionally {help by} another {varlist}.

    When {help if} or {help in} is specified, the conditions apply both to counting the
    distinct values and to generating the new variable. The new variable will be
    {help missing} in observation excluded by the {help if} or {help in} condition.

    If the {help if} and {help in} conditions exclude one of the values of
    {varlist}, the value of the new variable will reflect that.

    When there are missing values in

{title:Examples}

    Suppose have person-level data for individuals in the US states Connecticut
    and Massachusetts. The data include which town a person lives in. To
    generate a new variable counting the total number of distinct towns in the
    data:

        egen N_towns = distinct(town)

    To seperately count the number of distinct towns by state:

        by state: egen N_towns_by_state = distinct(town)

    To count the distinct number of towns not named "Sharon" by state (there is a
    Sharon in each state):

        by state: egen N_not_sharon_by_state = distinct(town) if town != "Sharon"

    Note that {bf:N_not_sharon_by_state} will be {help missing} for observations
    where {bf:town} is "Sharon".


{title:Remarks}

    See {help distinct} for a definition of the adjective "distinct" in this
    context.

    A test script for {cmdab:egen distinct} is available at ...

{title:Author}

	Noah J. Case, District of Columbia, USA.
	noahcase119@gmail.com