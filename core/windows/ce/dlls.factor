USING: alien sequences ;
{
    { "advapi32" "\\windows\\coredll.dll" "stdcall" }
    { "gdi32"    "\\windows\\coredll.dll" "stdcall" }
    { "user32"   "\\windows\\coredll.dll" "stdcall" }
    { "kernel32" "\\windows\\coredll.dll" "stdcall" }
    { "winsock"  "\\windows\\ws2.dll" "stdcall" }
    { "mswsock"  "\\windows\\ws2.dll" "stdcall" }
    { "libc"     "\\windows\\coredll.dll" "cdecl"   }
    { "libm"     "\\windows\\coredll.dll" "cdecl"   }
    ! { "gl"       "libGLES_CM.dll"         "stdcall" }
    ! { "glu"      "libGLES_CM.dll"         "stdcall" }
    ! { "freetype" "libfreetype-6.dll"      "stdcall" }
} [ first3 add-library ] each

PROVIDE: core/windows/ce/dlls ;