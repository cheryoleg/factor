! Copyright (C) 2008, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors biassocs compiler.cfg.registers
compiler.cfg.stacks.finalize compiler.cfg.stacks.global
compiler.cfg.stacks.height compiler.cfg.stacks.local
compiler.cfg.utilities kernel math namespaces sequences ;
IN: compiler.cfg.stacks

: begin-stack-analysis ( -- )
    <bihash> locs>vregs set
    H{ } clone peek-sets set
    H{ } clone replace-sets set
    H{ } clone kill-sets set
    initial-height-state height-state set ;

: end-stack-analysis ( cfg -- )
    {
        compute-anticip-sets
        compute-live-sets
        compute-pending-sets
        compute-dead-sets
        compute-avail-sets
        finalize-stack-shuffling
    } apply-passes ;

: create-locs ( loc-class seq -- locs )
    [ swap new swap >>n ] with map <reversed> ;

: stack-locs ( loc-class n -- locs )
    iota create-locs ;

: (load-vregs) ( n loc-class -- vregs )
    swap stack-locs [ peek-loc ] map ;

: load-vregs ( n loc-class -- vregs )
    [ (load-vregs) ] [ new swap neg >>n inc-stack ] 2bi ;

: store-vregs ( vregs loc-class -- )
    over length stack-locs [ replace-loc ] 2each ;

! Utility
: ds-drop ( -- ) d: -1 inc-stack ;

: ds-peek ( -- vreg ) d: 0 peek-loc ;

: ds-pop ( -- vreg ) ds-peek ds-drop ;

: ds-push ( vreg -- )
    d: 1 inc-stack d: 0 replace-loc ;

: (2inputs) ( -- vreg1 vreg2 )
    2 ds-loc (load-vregs) first2 ;

: 2inputs ( -- vreg1 vreg2 )
    2 ds-loc load-vregs first2 ;

: 3inputs ( -- vreg1 vreg2 vreg3 )
    3 ds-loc load-vregs first3 ;

: binary-op ( quot -- )
    [ 2inputs ] dip call ds-push ; inline

: unary-op ( quot -- )
    [ ds-pop ] dip call ds-push ; inline

: adjust-d ( n -- )
    <ds-loc> height-state get swap adjust ;
