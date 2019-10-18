! Copyright (C) 2006 Chris Double.
! See http://factorcode.org/license.txt for BSD license.
USING: test match namespaces arrays ;
IN: temporary

MATCH-VARS: ?a ?b ;

[ H{ { ?a 1 } { ?b 2 } } ] [
 { ?a ?b } { 1 2 } match
] unit-test

[ { 1 2 } ] [ 
  { 1 2 } 
  {
    { { ?a ?b } [ ?a ?b 2array ] }
  } match-cond
] unit-test

[ t ] [ 
  { 1 2 } 
  {
    { { 1 2 } [ t ] }
    { f [ f ] }
  } match-cond
] unit-test

[ t ] [ 
  { 1 3 } 
  {
    { { 1 2 } [ t ] }
    { { 1 3 } [ t ] }
  } match-cond
] unit-test

[ f ] [ 
  { 1 5 } 
  {
    { { 1 2 } [ t ] }
    { { 1 3 } [ t ] }
    { _       [ f ] }
  } match-cond
] unit-test

TUPLE: foo a b ;

{ 1 2 } [
  1 2 <foo> T{ foo f ?a ?b } match [
    ?a ?b
  ] bind
] unit-test

{ 1 2 } [
  1 2 <foo> \ ?a \ ?b <foo> match [
    ?a ?b
  ] bind
] unit-test

{ H{ { ?a ?a } } } [ 
  \ ?a \ ?a match 
] unit-test

[ "match" ] [ 
  "abcd" {
    { ?a [ "match" ] }
  } match-cond
] unit-test