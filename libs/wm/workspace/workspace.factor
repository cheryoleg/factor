
USING: kernel namespaces math sequences vars x ;

IN: wm.workspace

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

TUPLE: workspace windows ;

VAR: workspaces

VAR: current-workspace

: init-workspaces ( -- ) V{ } clone >workspaces ;

: add-workspace ( -- ) { } clone <workspace> workspaces> push ;

: mapped-windows ( -- seq ) root children [ mapped? ] subset ;

! : switch-to-workspace ( n -- )
! mapped-windows current-workspace> workspaces> nth set-workspace-windows
! mapped-windows [ unmap-window ] each
! dup workspaces> nth workspace-windows [ map-window ] each
! >current-workspace ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! This should go somewhere else

USING: kernel kernel-internals sequences assocs ;

: set-assoc-stack ( value key seq -- )
dupd [ key? ] find-last-with nip set-at ;

: set* ( val var -- ) namestack* set-assoc-stack ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: switch-to-workspace ( n -- )
mapped-windows current-workspace> workspaces> nth set-workspace-windows
mapped-windows [ unmap-window ] each
dup workspaces> nth workspace-windows [ map-window ] each
current-workspace set* ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: next-workspace ( -- )
current-workspace> 1+ dup workspaces> length <
[ switch-to-workspace ] [ drop ] if ;

: prev-workspace ( -- )
current-workspace> 1- dup 0 >=
[ switch-to-workspace ] [ drop ] if ;