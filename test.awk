/^start$/ {initflag =1}
NF ==2 && initflag == 1 {
    testname = $1
    pass[testname]=0
    tests[testname]=0
    flag = 1
}
NF ==1 && flag == 1 && /0|1/{
    pass[testname]+=$1
    tests[testname]++
}
END { for (test in tests)
             print "Passed " pass[test] " of " tests[test] " in section " test
}