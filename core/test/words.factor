IN: temporary
USING: arrays errors generic assocs kernel math namespaces
sequences test words definitions parser quotations ;

[ 4 ] [
    "poo" "scratchpad" create [ 2 2 + ] define-compound
    "poo" "scratchpad" lookup execute
] unit-test

[ t ] [ t vocabs [ words [ word? and ] each ] each ] unit-test

DEFER: plist-test

[ t ] [
    \ plist-test t "sample-property" set-word-prop
    \ plist-test "sample-property" word-prop
] unit-test

[ f ] [
    \ plist-test f "sample-property" set-word-prop
    \ plist-test "sample-property" word-prop
] unit-test

[ f ] [ 5 compound? ] unit-test

"create-test" "scratchpad" create { 1 2 } "testing" set-word-prop
[ { 1 2 } ] [
    "create-test" "scratchpad" lookup "testing" word-prop
] unit-test

[
    [ t ] [ \ array? "array?" "arrays" lookup = ] unit-test

    "test-scope" "scratchpad" create drop
] with-scope

[ "test-scope" ] [
    "test-scope" "scratchpad" lookup word-name
] unit-test

[ t ] [ vocabs array? ] unit-test
[ t ] [ vocabs [ words [ word? ] all? ] all? ] unit-test

[ f ] [ gensym gensym = ] unit-test

[ f ] [ 123 compound? ] unit-test

: colon-def ;
[ t ] [ \ colon-def compound? ] unit-test

SYMBOL: a-symbol
[ f ] [ \ a-symbol compound? ] unit-test
[ t ] [ \ a-symbol symbol? ] unit-test

! See if redefining a generic as a colon def clears some
! word props.
GENERIC: testing
: testing ;

[ f ] [ \ testing generic? ] unit-test

[ f ] [ gensym interned? ] unit-test

: forgotten ;
: another-forgotten ;

[ f ] [ \ forgotten interned? ] unit-test

FORGET: forgotten

[ f ] [ \ another-forgotten interned? ] unit-test

FORGET: another-forgotten
: another-forgotten ;

[ t ] [ \ + interned? ] unit-test

! I forgot remove-crossref calls!
: fee ;
: foe fee ;
: fie foe ;

[ 0 ] [ \ fee crossref get at assoc-size ] unit-test
[ t ] [ \ foe crossref get at not ] unit-test

FORGET: foe

! xref should not retain references to gensyms
gensym [ * ] define-compound
[ t ] [ \ * usage [ interned? not ] subset empty? ] unit-test

DEFER: calls-a-gensym
\ calls-a-gensym gensym dup "x" set 1quotation define-compound
[ f ] [ "x" get crossref get at ] unit-test

! more xref buggery
[ f ] [
    GENERIC: xyzzle
    : a ; \ a
    M: integer xyzzle a ;
    FORGET: a
    M: object xyzzle ;
    crossref get at
] unit-test

! regression
GENERIC: freakish
: bar freakish ;
M: array freakish ;
[ t ] [ \ bar \ freakish usage member? ] unit-test

DEFER: x
[ t ] [ [ x ] catch third \ x eq? ] unit-test

[ ] [ "no-loc" "temporary" create drop ] unit-test
[ f ] [ "no-loc" "temporary" lookup where ] unit-test

[ ] [ "IN: temporary : no-loc-2 ;" eval ] unit-test
[ f ] [ "no-loc-2" "temporary" lookup where ] unit-test

[ ] [ "IN: temporary : test-last ( -- ) ;" eval ] unit-test
[ "test-last" ] [ word word-name ] unit-test