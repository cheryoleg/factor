! Copyright (C) 2005, 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: gadgets-scrolling
USING: arrays gadgets gadgets-theme gadgets-viewports
gadgets-sliders generic kernel math namespaces sequences
models ;

TUPLE: scroller viewport x y follows ;

: find-scroller ( gadget -- scroller/f )
    [ scroller? ] find-parent ;

: scroll-up-page scroller-y -1 swap slide-by-page ;

: scroll-down-page scroller-y 1 swap slide-by-page ;

: scroll-up-line scroller-y -1 swap slide-by-line ;

: scroll-down-line scroller-y 1 swap slide-by-line ;

: do-mouse-scroll ( scroller -- )
    scroll-direction get-global first2
    pick scroller-y slide-by-line
    swap scroller-x slide-by-line ;

scroller H{
    { T{ mouse-scroll } [ do-mouse-scroll ] }
} set-gestures

: viewport, ( -- )
    g control-model <viewport>
    g-> set-scroller-viewport @center grid, ;

: <scroller-model> ( -- model )
    0 0 0 0 <range> 0 0 0 0 <range> 2array <compose> ;

: x-model g control-model model-dependencies first ;

: y-model g control-model model-dependencies second ;

C: scroller ( gadget -- scroller )
    dup <scroller-model> <frame> delegate>control [
        [
            x-model <x-slider> g-> set-scroller-x @bottom grid,
            y-model <y-slider> g-> set-scroller-y @right grid,
            viewport,
        ] with-gadget
    ] keep t over set-gadget-root? dup faint-boundary ;

: scroll ( value scroller -- )
    [
        dup scroller-viewport rect-dim { 0 0 }
        rot scroller-viewport viewport-dim 4array flip
    ] keep
    2dup control-value = [ 2drop ] [ set-control-value ] if ;

: (scroll>rect) ( rect scroller -- )
    [
        scroller-value vneg offset-rect
        viewport-gap offset-rect
    ] keep
    [
        scroller-viewport 2rect-extent
        >r >r v- { 0 0 } vmin r> r> v- { 0 0 } vmax v+
    ] keep dup scroller-value rot v+ swap scroll ;

: relative-scroll-rect ( rect gadget scroller -- newrect )
    scroller-viewport gadget-child relative-loc offset-rect ;

: scroll>rect ( rect gadget -- )
    dup find-scroller dup [
        [ relative-scroll-rect ] keep
        [ set-scroller-follows ] keep
        relayout
    ] [
        3drop
    ] if ;

: (scroll>bottom) ( scroller -- )
    dup scroller-viewport viewport-dim { 0 1 } v* swap scroll ;

: scroll>bottom ( scroller -- )
    find-scroller [
        t over set-scroller-follows relayout-1
    ] when* ;

: scroll>top ( gadget -- )
    <zero-rect> swap scroll>rect ;

: scroll>gadget ( gadget -- )
    [ pref-dim ] keep scroll>rect ;

: update-scroller ( scroller follows -- )
    {
        { [ dup t eq? ] [ drop (scroll>bottom) ] }
        { [ dup ] [ swap (scroll>rect) ] }
        { [ t ] [ drop dup scroller-value swap scroll ] }
    } cond ;

M: scroller layout*
    dup delegate layout*
    dup scroller-follows
    [ update-scroller ] 2keep
    swap set-scroller-follows ;

M: scroller focusable-child*
    scroller-viewport ;

M: scroller model-changed
    f swap set-scroller-follows ;