IN: scratchpad
USE: hashtables
USE: namespaces
USE: generic
USE: test
USE: kernel
USE: math
USE: words
USE: lists

TRAITS: test-traits
C: test-traits ;

[ t ] [ <test-traits> test-traits? ] unit-test
[ f ] [ "hello" test-traits? ] unit-test
[ f ] [ <namespace> test-traits? ] unit-test

GENERIC: foo

M: test-traits foo drop 12 ;

TRAITS: another-test
C: another-test ;

M: another-test foo drop 13 ;

[ 12 ] [ <test-traits> foo ] unit-test
[ 13 ] [ <another-test> foo ] unit-test

TRAITS: quux
C: quux ;

M: quux foo "foo" swap hash ;

[
    "Hi"
] [
    <quux> [
        "Hi" "foo" set
    ] extend foo
] unit-test

TRAITS: ctr-test
C: ctr-test [ 5 "x" set ] extend ;

[
    5
] [
    <ctr-test> [ "x" get ] bind
] unit-test

TRAITS: del1
C: del1 ;

GENERIC: super
M: del1 super drop 5 ;

TRAITS: del2
C: del2 ( delegate -- del2 ) [ delegate set ] extend ;

[ 5 ] [ <del1> <del2> super ] unit-test

GENERIC: class-of

M: fixnum class-of drop "fixnum" ;
M: word   class-of drop "word"   ;
M: cons   class-of drop "cons"   ;

[ "fixnum" ] [ 5 class-of ] unit-test
[ "cons" ] [ [ 1 2 3 ] class-of ] unit-test
[ "word" ] [ \ class-of class-of ] unit-test
[ 3.4 class-of ] unit-test-fails

GENERIC: foobar
M: object foobar drop "Hello world" ;
M: fixnum foobar drop "Goodbye cruel world" ;

[ "Hello world" ] [ 4 foobar foobar ] unit-test
[ "Goodbye cruel world" ] [ 4 foobar ] unit-test

GENERIC: bool>str
M: t bool>str drop "true" ;
M: f bool>str drop "false" ;

: str>bool
    [
        [ "true" | t ]
        [ "false" | f ]
    ] assoc ;

[ t ] [ t bool>str str>bool ] unit-test
[ f ] [ f bool>str str>bool ] unit-test
