! Copyright (C) 2004, 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: kernel-internals
USING: command-line errors io io-internals kernel math
namespaces parser words threads ;

: boot ( -- )
    init-namespaces
    cell \ cell set
    millis init-random
    init-io
    embedded? [ init-stdio ] unless
    init-error-handler
    init-threads
    default-cli-args
    [ parse-command-line ] try ;