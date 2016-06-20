! Copyright (C) 2003, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel namespaces ;
IN: prettyprint.config

! Configuration
symbol: tab-size
symbol: margin
symbol: nesting-limit
symbol: length-limit
symbol: line-limit
symbol: number-base
symbol: string-limit?
symbol: boa-tuples?
symbol: c-object-pointers?

4 tab-size set-global
64 margin set-global
15 nesting-limit set-global
100 length-limit set-global
10 number-base set-global
t string-limit? set-global

: with-short-limits ( quot -- )
    H{
        { line-limit 1 }
        { length-limit 15 }
        { nesting-limit 2 }
        { string-limit? t }
        { boa-tuples? t }
        { c-object-pointers? f }
    } clone swap with-variables ; inline

: without-limits ( quot -- )
    H{
        { nesting-limit f }
        { length-limit f }
        { line-limit f }
        { string-limit? f }
        { c-object-pointers? f }
    } clone swap with-variables ; inline
