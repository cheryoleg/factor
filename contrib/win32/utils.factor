USING: alien parser namespaces kernel syntax words math io prettyprint ;
IN: win32

: win32-error=0 0 = [ win32-error ] when ;
: win32-error>0 0 > [ win32-error ] when ;
: win32-error<0 0 < [ win32-error ] when ;
: win32-error<>0 0 = [ win32-error ] unless ;

: lo-word ( wparam -- lo ) HEX: ffff bitand ;
: hi-word ( wparam -- hi ) -16 shift ;

: hello-world
    f "Hello, world!" "First Application" MB_OK MessageBox win32-error drop ;

: msgbox ( str -- )
    f swap "DebugMsg" MB_OK MessageBox drop ;

