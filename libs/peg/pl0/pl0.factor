! Copyright (C) 2007 Chris Double.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel arrays strings math.parser sequences
peg peg.ebnf peg.parsers memoize namespaces math ;
IN: peg.pl0

! Grammar for PL/0 based on http://en.wikipedia.org/wiki/PL/0

: pl0 ( string -- obj ) EBNF{{

block       =  { "CONST" ident "=" number { "," ident "=" number }* ";" }?
               { "VAR" ident { "," ident }* ";" }?
               { "PROCEDURE" ident ";" { block ";" }? }* statement
statement   =  {  ident ":=" expression
                | "CALL" ident
                | "BEGIN" statement { ";" statement }* "END"
                | "IF" condition "THEN" statement
                | "WHILE" condition "DO" statement }?
condition   =  { "ODD" expression }
             | { expression ("=" | "#" | "<=" | "<" | ">=" | ">") expression }
expression  = {"+" | "-"}? term { {"+" | "-"} term }*
term        = factor { {"*" | "/"} factor }*
factor      = ident | number | "(" expression ")"
ident       = (([a-zA-Z])+)   => [[ >string ]]
number      = ([0-9])+        => [[ string>number ]]
program     = { block "." }
}} ;
