! Copyright (C) 2005, 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io ;
IN: io.streams.plain

mixin: plain-writer

M: plain-writer stream-nl
    char: \n swap stream-write1 ;
