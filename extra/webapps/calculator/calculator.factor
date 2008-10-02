! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: furnace.actions furnace.redirection
http.server.dispatchers html.forms validators urls accessors
math ;
IN: webapps.calculator

TUPLE: calculator < dispatcher ;

: <calculator-action> ( -- action )
    <page-action>

    [
        { { "z" [ [ v-number ] v-optional ] } } validate-params
    ] >>init

    { calculator "calculator" } >>template

    [
        {
            { "x" [ v-number ] }
            { "y" [ v-number ] }
        } validate-params

        URL" $calculator" "x" value "y" value + "z" set-query-param
        <redirect>
    ] >>submit ;

: <calculator> ( -- responder )
    calculator new-dispatcher
        <calculator-action> >>default ;

! Deployment example
USING: db.sqlite furnace.alloy namespaces http.server ;

: calculator-db ( -- params db ) "calculator.db" sqlite-db ;

: run-calculator ( -- )
    <calculator>
        calculator-db <alloy>
        main-responder set-global
    8080 httpd ;

MAIN: run-calculator
