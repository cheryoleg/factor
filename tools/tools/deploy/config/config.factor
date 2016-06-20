! Copyright (C) 2007, 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: assocs combinators.smart hashtables kernel math namespaces
sequences vocabs ;
IN: tools.deploy.config

symbol: deploy-name

symbol: deploy-ui?
symbol: deploy-console?
symbol: deploy-math?
symbol: deploy-unicode?
symbol: deploy-threads?
symbol: deploy-help?

symbol: deploy-io

CONSTANT: deploy-io-options
    {
        { 1 "Level 1 - No input/output" }
        { 2 "Level 2 - Basic ANSI C streams" }
        { 3 "Level 3 - Non-blocking streams and networking" }
    } ;

: strip-io? ( -- ? ) deploy-io get 1 = ;

: native-io? ( -- ? ) deploy-io get 3 = ;

symbol: deploy-reflection

CONSTANT: deploy-reflection-options
    {
        { 1 "Level 1 - No reflection" }
        { 2 "Level 2 - Retain word names" }
        { 3 "Level 3 - Prettyprinter" }
        { 4 "Level 4 - Debugger" }
        { 5 "Level 5 - Parser" }
        { 6 "Level 6 - Full environment" }
    } ;

: strip-word-names? ( -- ? ) deploy-reflection get 2 < ;
: strip-prettyprint? ( -- ? ) deploy-reflection get 3 < ;
: strip-debugger? ( -- ? ) deploy-reflection get 4 < ;
: strip-dictionary? ( -- ? ) deploy-reflection get 5 < ;
: strip-globals? ( -- ? ) deploy-reflection get 6 < ;

symbol: deploy-word-props?
symbol: deploy-word-defs?
symbol: deploy-c-types?

symbol: deploy-vm
symbol: deploy-image

: default-config ( vocab -- assoc )
    vocab-name deploy-name associate H{
        { deploy-ui?                f }
        { deploy-console?           t }
        { deploy-io                 3 }
        { deploy-reflection         1 }
        { deploy-threads?           t }
        { deploy-help?              f }
        { deploy-unicode?           f }
        { deploy-math?              t }
        { deploy-word-props?        f }
        { deploy-word-defs?         f }
        { deploy-c-types?           f }
        ! default value for deploy.macosx
        { "stop-after-last-window?" t }
    } assoc-union ;

symbol: deploy-directory
"resource:" deploy-directory set-global

: config>profile ( config -- profile )
    {
        [ deploy-math? of "math" f ? ]
        [ deploy-threads? of "threads" f ? ]
        [ drop "compiler" ]
        [ deploy-help? of "help" f ? ]
        [ deploy-io of 3 = "io" f ? ]
        [ deploy-ui? of "ui" f ? ]
        [ deploy-unicode? of "unicode" f ? ]
    } cleave>array sift ;
