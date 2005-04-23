! Copyright (C) 2004, 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: alien
USING: assembler errors generic inference kernel lists math
namespaces sequences stdio strings words ;

! ! ! WARNING ! ! !
! Reloading this file into a running Factor instance on Win32
! or Unix with FFI I/O will bomb the runtime, since I/O words
! would become uncompiled, and FFI calls can only be made from
! compiled code.

! USAGE:
! 
! Command line parameters given to the runtime specify libraries
! to load.
!
! -libraries:<foo>:name=<soname> -- define a library <foo>, to be
! loaded from the <soname> DLL.
!
! -libraries:<foo>:abi=stdcall -- define a library using the
! stdcall ABI. This ABI is usually used on Win32. Any other abi
! parameter, or a missing abi parameter indicates the cdecl ABI
! should be used, which is common on Unix.

SYMBOL: #cleanup ( unwind stack by parameter )

SYMBOL: #unbox ( move top of datastack to C stack )

! for register parameter passing; move top of C stack to a
! register. no-op on x86, generates code on PowerPC.
SYMBOL: #parameter

! for increasing stack space on PowerPC; unused on x86.
SYMBOL: #parameters

SYMBOL: #box ( move EAX to datastack )

! These are set in the alien-invoke dataflow IR node.
SYMBOL: alien-returns
SYMBOL: alien-parameters

: set-alien-returns ( returns node -- )
    [ dup alien-returns set ] bind
    "void" = [
        [ object ] produce-d 1 0 node-outputs
    ] unless ;

: set-alien-parameters ( parameters node -- )
    [ dup alien-parameters set ] bind
    [ drop object ] map dup dup ensure-d
    length 0 node-inputs consume-d ;

: ensure-dlsym ( symbol library -- ) load-dll dlsym drop ;

: alien-invoke-node ( returns params function library -- )
    #! We should fail if the library does not exist, so that
    #! compilation does not keep trying to compile FFI words
    #! over and over again if the library is not loaded.
    2dup ensure-dlsym
    cons \ alien-invoke dataflow,
    [ set-alien-parameters ] keep
    set-alien-returns ;

DEFER: alien-invoke

: infer-alien-invoke ( -- )
    \ alien-invoke "infer-effect" word-prop car ensure-d
    pop-literal
    pop-literal >r
    pop-literal
    pop-literal -rot
    r> swap alien-invoke-node ;

: alien-global-node ( type name library -- )
    2dup ensure-dlsym
    cons \ alien-global dataflow,
    set-alien-returns ;

DEFER: alien-global

: infer-alien-global ( -- )
    \ alien-global "infer-effect" word-prop car ensure-d
    pop-literal
    pop-literal
    pop-literal -rot
    alien-global-node ;

: parameters [ alien-parameters get reverse ] bind ;

: stack-space ( parameters -- n )
    0 swap [ c-size cell align + ] each ;

: unbox-parameter ( n parameter -- )
    c-type [ "unboxer" get ] bind cons #unbox swons , ;

: linearize-parameters ( node -- count )
    #! Generate code for boxing a list of C types, then generate
    #! code for moving these parameters to register on
    #! architectures where parameters are passed in registers
    #! (PowerPC).
    #!
    #! Return amount stack must be unwound by.
    parameters
    dup stack-space
    dup #parameters swons , >r
    dup 0 swap [ dupd unbox-parameter 1 + ] each drop
    length [ #parameter swons ] project % r> ;

: linearize-returns ( returns -- )
    [ alien-returns get ] bind dup "void" = [
        drop
    ] [
        c-type [ "boxer" get ] bind #box swons ,
    ] ifte ;

: linearize-alien-invoke ( node -- )
    dup linearize-parameters >r
    dup [ node-param get ] bind \ alien-invoke swons ,
    dup [ node-param get cdr library-abi "stdcall" = ] bind
    r> swap [ drop ] [ #cleanup swons , ] ifte
    linearize-returns ;

\ alien-invoke [ linearize-alien-invoke ] "linearizer" set-word-prop

: linearize-alien-global ( node -- )
    dup [ node-param get ] bind \ alien-global swons ,
    linearize-returns ;

\ alien-global [ linearize-alien-global ] "linearizer" set-word-prop

TUPLE: alien-error lib ;

C: alien-error ( lib -- ) [ set-alien-error-lib ] keep ;

M: alien-error error. ( error -- )
    [
        "C library interface words cannot be interpreted. " ,
        "Either the compiler is disabled, " ,
        "or the ``" , alien-error-lib ,
        "'' library is missing." ,
    ] make-string print ;

: alien-invoke ( ... returns library function parameters -- ... )
    #! Call a C library function.
    #! 'returns' is a type spec, and 'parameters' is a list of
    #! type specs. 'library' is an entry in the "libraries"
    #! namespace.
    rot <alien-error> throw ;

\ alien-invoke [ [ string string string general-list ] [ ] ]
"infer-effect" set-word-prop

\ alien-invoke [ infer-alien-invoke ] "infer" set-word-prop

: alien-global ( type library name -- value )
    #! Fetch the value of C global variable.
    #! 'type' is a type spec. 'library' is an entry in the
    #! "libraries" namespace.
    swap <alien-error> throw ;

\ alien-global [ [ string string string ] [ object ] ]
"infer-effect" set-word-prop

\ alien-global [ infer-alien-global ] "infer" set-word-prop

global [
    "libraries" get [ <namespace> "libraries" set ] unless
] bind
