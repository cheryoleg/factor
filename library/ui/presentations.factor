! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: gadgets
USING: generic hashtables inspector io jedit kernel lists memory
namespaces parser prettyprint sequences styles vectors words ;

SYMBOL: commands

global [ 100 <vector> commands set ] bind

: define-command ( class name quot -- )
    3list commands get push ;

: applicable ( object -- )
    commands get >list
    [ car "predicate" word-prop call ] subset-with ;

DEFER: pane-eval

: command-menu ( pane -- menu )
    presented get dup applicable [
        3dup third [
            [ swap literal, % ] make-list , , \ pane-call ,
        ] make-list >r second r> cons
    ] map 2nip ;

: init-commands ( gadget pane -- )
    over presented paint-prop
    [ [ command-menu <menu> show-menu ] cons button-gestures ]
    [ 2drop ] ifte ;

: <styled-label> ( style text -- label )
    <label> swap alist>hash over set-gadget-paint ;

: <presentation> ( style text pane -- presentation )
    >r <styled-label> dup r> init-commands ;

object "Prettyprint" [ prettyprint ] define-command
object "Inspect" [ inspect ] define-command
object "References" [ references inspect ] define-command

\ word "See" [ see ] define-command
\ word "Execute" [ execute ] define-command
\ word "Usage" [ usage . ] define-command
\ word "jEdit" [ jedit ] define-command
