! Copyright (C) 2006, 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: generator
USING: arrays generic kernel kernel-internals math memory
namespaces sequences assocs ;

! A scratch register for computations
TUPLE: vreg n ;

C: vreg ( n reg-class -- vreg )
    [ set-delegate ] keep [ set-vreg-n ] keep ;

! Register classes
TUPLE: int-regs ;
TUPLE: float-regs size ;

: <int-vreg> ( n -- vreg ) T{ int-regs } <vreg> ;
: <float-vreg> ( n -- vreg ) T{ float-regs f 8 } <vreg> ;

! Temporary register for stack shuffling
TUPLE: temp-reg ;

: temp-reg T{ temp-reg T{ int-regs } } ;

: %move ( dst src -- )
    2dup = [
        2drop
    ] [
        2dup [ delegate class ] 2apply 2array {
            { { int-regs int-regs } [ %move-int>int ] }
            { { float-regs int-regs } [ %move-int>float ] }
            { { int-regs float-regs } [ %move-float>int ] }
        } case
    ] if ;

GENERIC: reg-size ( register-class -- n )

GENERIC: inc-reg-class ( register-class -- )

M: int-regs reg-size drop cell ;

: (inc-reg-class)
    dup class inc
    fp-shadows-int? [ reg-size stack-params +@ ] [ drop ] if ;

M: int-regs inc-reg-class
    (inc-reg-class) ;

M: float-regs reg-size float-regs-size ;

M: float-regs inc-reg-class
    dup (inc-reg-class)
    fp-shadows-int? [ reg-size 4 / int-regs +@ ] [ drop ] if ;

M: vreg v>operand dup vreg-n swap vregs nth ;

: reg-spec>class ( spec -- class )
    float eq?
    T{ float-regs f 8 } T{ int-regs } ? ;

: reg-class>spec ( class -- spec )
    delegate class
    H{ { int-regs f } { float-regs float } } at ;