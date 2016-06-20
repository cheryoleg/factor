! Copyright (C) 2008, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: assocs arrays namespaces sequences kernel definitions
math effects accessors words fry classes.algebra
compiler.units stack-checker.values stack-checker.visitor
stack-checker.errors ;
IN: stack-checker.state

symbol: terminated?

symbol: input-count
symbol: inner-d-index

defer: commit-literals

symbol: (meta-d)
symbol: (meta-r)

: meta-d ( -- stack ) commit-literals (meta-d) get ;

: meta-r ( -- stack ) (meta-r) get ;

symbol: literals

: (push-literal) ( obj -- )
    dup <literal> make-known
    [ nip (meta-d) get push ] [ #push, ] 2bi ;

: commit-literals ( -- )
    literals get [ [ (push-literal) ] each ] [ delete-all ] bi ;

: current-stack-height ( -- n )
    meta-d length input-count get - ;

: current-effect ( -- effect )
    input-count get "x" <array>
    meta-d length "x" <array>
    terminated? get <terminated-effect> ;

: check-effect ( required-effect -- )
    [ current-effect ] dip 2dup effect<= [ 2drop ] [ effect-error ] if ;

: init-inference ( -- )
    terminated? off
    V{ } clone (meta-d) set
    V{ } clone literals set
    0 input-count set
    0 inner-d-index set ;
