IN: scratchpad
USE: arithmetic
USE: test

[ 100 ] [ 100 100 gcd ] unit-test
[ 100 ] [ 1000 100 gcd ] unit-test
[ 100 ] [ 100 1000 gcd ] unit-test
[ 4 ] [ 132 64 gcd ] unit-test
[ 4 ] [ -132 64 gcd ] unit-test
[ 4 ] [ -132 -64 gcd ] unit-test
[ 4 ] [ 132 -64 gcd ] unit-test
[ 4 ] [ -132 -64 gcd ] unit-test

[ 100 ] [ 100 >bignum 100 >bignum gcd ] unit-test
[ 100 ] [ 1000 >bignum 100 >bignum gcd ] unit-test
[ 100 ] [ 100 >bignum 1000 >bignum gcd ] unit-test
[ 4 ] [ 132 >bignum 64 >bignum gcd ] unit-test
[ 4 ] [ -132 >bignum 64 >bignum gcd ] unit-test
[ 4 ] [ -132 >bignum -64 >bignum gcd ] unit-test
[ 4 ] [ 132 >bignum -64 >bignum gcd ] unit-test
[ 4 ] [ -132 >bignum -64 >bignum gcd ] unit-test
