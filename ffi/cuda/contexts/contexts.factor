! (c)2010 Joe Groff bsd license
USING: alien.c-types alien.data continuations cuda cuda.ffi
cuda.libraries alien.destructors fry kernel namespaces ;
IN: cuda.contexts

: set-up-cuda-context ( -- )
    H{ } clone cuda-modules set-global
    H{ } clone cuda-functions set-global ; inline

: create-context ( device flags -- context )
    swap
    [ { CUcontext } ] 2dip
    '[ _ _ cuCtxCreate cuda-error ] with-out-parameters ; inline

: sync-context ( -- )
    cuCtxSynchronize cuda-error ; inline

: context-device ( -- n )
    { CUdevice } [ cuCtxGetDevice cuda-error ] with-out-parameters ; inline

: destroy-context ( context -- ) cuCtxDestroy cuda-error ; inline

: clean-up-context ( context -- )
    [ sync-context ] ignore-errors destroy-context ; inline

destructor: destroy-context
destructor: clean-up-context

: (with-cuda-context) ( context quot -- )
    swap '[ _ clean-up-context ] [ ] cleanup ; inline

: with-cuda-context ( device flags quot -- )
    [ set-up-cuda-context create-context ] dip (with-cuda-context) ; inline
