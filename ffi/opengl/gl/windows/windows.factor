USING: alien alien.c-types alien.syntax kernel windows.types ;
in: opengl.gl.windows

library: gl

FUNCTION: HGLRC wglGetCurrentContext ( ) ;
FUNCTION: void* wglGetProcAddress ( c-string name ) ;

: gl-function-context ( -- context ) wglGetCurrentContext ; inline
: gl-function-address ( name -- address ) wglGetProcAddress ; inline
: gl-function-calling-convention ( -- str ) stdcall ; inline