! From http://www.ffconsultancy.com/ocaml/maze/index.html
REQUIRES: libs/canvas ;
USING: sequences namespaces math opengl arrays gadgets 
gadgets-theme kernel canvas ;
IN: maze

: line-width 8 ;

SYMBOL: visited

: unvisited? ( cell -- ? ) first2 visited get ?nth ?nth ;

: ?set-nth ( elt i seq -- )
    2dup bounds-check? [ set-nth ] [ 3drop ] if ;

: visit ( cell -- ) f swap first2 visited get ?nth ?set-nth ;

: choices ( cell -- seq )
    { { -1 0 } { 1 0 } { 0 -1 } { 0 1 } }
    [ v+ ] map-with
    [ unvisited? ] subset ;

: random-neighbour ( cell -- newcell ) choices random ;

: vertex ( pair -- )
    first2 [ 0.5 + line-width * ] 2apply glVertex2d ;

: (draw-maze) ( cell -- )
    dup vertex
    glEnd
    GL_POINTS [ dup vertex ] do-state
    GL_LINE_STRIP glBegin
    dup vertex
    dup visit
    dup random-neighbour dup [
        (draw-maze) (draw-maze)
    ] [
        2drop
        glEnd
        GL_LINE_STRIP glBegin
    ] if ;

: draw-maze ( n -- )
    line-width 2 - glLineWidth
    line-width 2 - glPointSize
    1.0 1.0 1.0 1.0 glColor4d
    dup [ drop t <array> ] map-with visited set
    GL_LINE_STRIP glBegin
    { 0 0 } dup vertex (draw-maze)
    glEnd ;

TUPLE: maze ;

C: maze ( -- gadget ) dup delegate>canvas ;

: n ( gadget -- n ) rect-dim first2 min line-width /i ;

M: maze layout* delete-canvas-dlist ;

M: maze draw-gadget* [ n draw-maze ] draw-canvas ;

M: maze pref-dim* drop { 400 400 } ;

: maze-window <maze> "Maze" open-window ;

PROVIDE: demos/maze ;

MAIN: demos/maze maze-window ;