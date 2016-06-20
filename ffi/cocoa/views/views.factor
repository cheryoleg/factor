! Copyright (C) 2006, 2009 Slava Pestov
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays cocoa core-graphics.types kernel math
sequences ;
IN: cocoa.views

CONSTANT: NSOpenGLPFAAllRenderers 1 ;
CONSTANT: NSOpenGLPFADoubleBuffer 5 ;
CONSTANT: NSOpenGLPFAStereo 6 ;
CONSTANT: NSOpenGLPFAAuxBuffers 7 ;
CONSTANT: NSOpenGLPFAColorSize 8 ;
CONSTANT: NSOpenGLPFAAlphaSize 11 ;
CONSTANT: NSOpenGLPFADepthSize 12 ;
CONSTANT: NSOpenGLPFAStencilSize 13 ;
CONSTANT: NSOpenGLPFAAccumSize 14 ;
CONSTANT: NSOpenGLPFAMinimumPolicy 51 ;
CONSTANT: NSOpenGLPFAMaximumPolicy 52 ;
CONSTANT: NSOpenGLPFAOffScreen 53 ;
CONSTANT: NSOpenGLPFAFullScreen 54 ;
CONSTANT: NSOpenGLPFASampleBuffers 55 ;
CONSTANT: NSOpenGLPFASamples 56 ;
CONSTANT: NSOpenGLPFAAuxDepthStencil 57 ;
CONSTANT: NSOpenGLPFAColorFloat  58 ;
CONSTANT: NSOpenGLPFAMultisample 59 ;
CONSTANT: NSOpenGLPFASupersample 60 ;
CONSTANT: NSOpenGLPFASampleAlpha 61 ;
CONSTANT: NSOpenGLPFARendererID 70 ;
CONSTANT: NSOpenGLPFASingleRenderer 71 ;
CONSTANT: NSOpenGLPFANoRecovery 72 ;
CONSTANT: NSOpenGLPFAAccelerated 73 ;
CONSTANT: NSOpenGLPFAClosestPolicy 74 ;
CONSTANT: NSOpenGLPFARobust 75 ;
CONSTANT: NSOpenGLPFABackingStore 76 ;
CONSTANT: NSOpenGLPFAMPSafe 78 ;
CONSTANT: NSOpenGLPFAWindow 80 ;
CONSTANT: NSOpenGLPFAMultiScreen 81 ;
CONSTANT: NSOpenGLPFACompliant 83 ;
CONSTANT: NSOpenGLPFAScreenMask 84 ;
CONSTANT: NSOpenGLPFAPixelBuffer 90 ;
CONSTANT: NSOpenGLPFAAllowOfflineRenderers 96 ;
CONSTANT: NSOpenGLPFAVirtualScreenCount 128 ;

CONSTANT: NSOpenGLCPSwapInterval 222 ;
CONSTANT: NSOpenGLCPSurfaceOpacity 236 ;

: <GLView> ( class dim pixel-format -- view )
    [ -> alloc ]
    [ [ 0 0 ] dip first2 <CGRect> ]
    [ handle>> ] tri*
    send\ initWithFrame:pixelFormat:
    dup 1 send\ setPostsBoundsChangedNotifications:
    dup 1 send\ setPostsFrameChangedNotifications: ;

: view-dim ( view -- dim )
    send\ bounds
    [ CGRect-w >fixnum ] [ CGRect-h >fixnum ] bi
    2array ;

: mouse-location ( view event -- loc )
    [
        send\ locationInWindow f send\ convertPoint:fromView:
        [ x>> ] [ y>> ] bi
    ] [ drop -> frame CGRect-h ] 2bi
    swap - [ >integer ] bi@ 2array ;
