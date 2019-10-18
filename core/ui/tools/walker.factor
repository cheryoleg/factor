! Copyright (C) 2006, 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: gadgets-walker
USING: arrays errors gadgets gadgets-buttons assocs
gadgets-listener gadgets-panes gadgets-scrolling gadgets-text
gadgets-tracks gadgets-workspace generic hashtables
interpreter io kernel kernel-internals listener math models
namespaces sequences shells threads vectors quotations
prettyprint gadgets-traceback inspector ;

: <quotation-display> ( quot -- gadget )
    [ [ first2 callframe. ] when* ]
    "Current quotation" <labelled-pane> ;

TUPLE: walker-gadget model quot ns ;

: update-stacks ( walker -- )
    meta-interp get
    over walker-gadget-model set-model
    callframe get callframe-scan get 2array
    swap walker-gadget-quot set-model ;

: with-walker ( gadget quot -- )
    swap dup walker-gadget-ns
    [ slip update-stacks ] bind ; inline

: walker-active? ( walker -- ? )
    meta-interp swap walker-gadget-ns key? ;

: walker-command ( gadget quot -- )
    over walker-active? [ with-walker ] [ 2drop ] if ; inline

: com-step [ step ] walker-command ;
: com-into [ step-in ] walker-command ;
: com-out [ step-out ] walker-command ;
: com-back [ step-back ] walker-command ;

: init-walker-models ( walker -- )
    f <model> over set-walker-gadget-quot
    f <model> over set-walker-gadget-model
    H{ } clone swap set-walker-gadget-ns ;

: reset-walker ( walker -- )
    dup walker-gadget-ns clear-assoc
    [ V{ } clone meta-history set ] with-walker ;

C: walker-gadget ( -- gadget )
    dup init-walker-models [
        toolbar,
        g walker-gadget-quot <quotation-display> 1/4 track,
        g walker-gadget-model <traceback-gadget> 3/4 track,
    ] { 0 1 } build-track
    dup reset-walker ;

M: walker-gadget call-tool* ( continuation walker -- )
    [ restore ] with-walker ;

: com-inspect ( walker -- )
    dup walker-active? [
        meta-interp swap walker-gadget-ns at
        [ inspect ] curry call-listener
    ] [
        drop
    ] if ;

: com-continue ( walker -- )
    dup [ step-all ] walker-command reset-walker ;

: com-abandon ( walker -- )
    dup [ abandon ] walker-command reset-walker ;

: walker-help "ui-walker" help-window ;

\ walker-help H{ { +nullary+ t } } define-command

walker-gadget "toolbar" f {
    { T{ key-down f { A+ } "s" } com-step }
    { T{ key-down f { A+ } "i" } com-into }
    { T{ key-down f { A+ } "o" } com-out }
    { T{ key-down f { A+ } "b" } com-back }
    { T{ key-down f { A+ } "c" } com-continue }
    { T{ key-down f f "F1" } walker-help }
} define-command-map

walker-gadget "other" f {
    { T{ key-down f { A+ } "a" } com-abandon }
    { T{ key-down f { A+ } "n" } com-inspect }
} define-command-map

[ walker-gadget call-tool stop ] break-hook set-global

IN: tools

: walk ( quot -- ) [ break ] swap append call ;