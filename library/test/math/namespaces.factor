IN: scratchpad
USE: namespaces
USE: test
USE: math

5 "x" set

[ 6 ] [ 1 "x" +@ "x" get ] unit-test
[ 5 ] [ 1 "x" -@ "x" get ] unit-test
[ 10 ] [ 2 "x" *@ "x" get ] unit-test
[ 2 ] [ 5 "x" /@ "x" get ] unit-test
[ 1 ] [ "x" pred@ "x" get ] unit-test
[ 2 ] [ "x" succ@ "x" get ] unit-test
[ 7 ] [ -3 "x" set 10 "x" rem@ "x" get ] unit-test 
[ -3 ] [ -3 "x" set 10 "x" mod@ "x" get ] unit-test 
