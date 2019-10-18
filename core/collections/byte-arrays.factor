! Copyright (C) 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: byte-arrays
USING: kernel kernel-internals alien sequences
sequences-internals ;

M: byte-array clone (clone) ;
M: byte-array length array-capacity ;
M: byte-array nth bounds-check nth-unsafe ;
M: byte-array set-nth bounds-check set-nth-unsafe ;
M: byte-array nth-unsafe swap alien-unsigned-1 ;
M: byte-array set-nth-unsafe swap set-alien-unsigned-1 ;
: >byte-array ( seq -- byte-array ) B{ } clone-like ; inline
M: byte-array like drop dup byte-array? [ >byte-array ] unless ;
M: byte-array new drop <byte-array> ;

M: byte-array equal?
    over byte-array? [ sequence= ] [ 2drop f ] if ;