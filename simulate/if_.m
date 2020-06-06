% saveAs=simulate/if_.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Scalar
    x = simulate.if(true, 1, true, 2, 3);
    assertEqual(testCase, x, 1);
    x = simulate.if(false, 1, true, 2, 3);
    assertEqual(testCase, x, 2);
    x = simulate.if(false, 1, false, 2, 3);
    assertEqual(testCase, x, 3);
    x = simulate.if(false, 1, false, 2, true, 3, 4);
    assertEqual(testCase, x, 3);


%% Test Vector
    x = simulate.if([false, false, true], [1, 2, 3], [true, false, true], [10, 20, 30], [100, 200, 300]);
    assertEqual(testCase, x, [10, 200, 3]);


%% Text Mixed
    x = simulate.if([false, false, true], 1, true, [10, 20, 30], NaN);
    assertEqual(testCase, x, [10, 20, 1]);
    x = simulate.if([false, false, true], 1, [false, false, false], [10, 20, 30], NaN);
    assertEqual(testCase, x, [NaN, NaN, 1]);
    x = simulate.if([true, false, true], 1, [false, true, true], [10, 20, 30], [100, 200, 300]);
    assertEqual(testCase, x, [1, 20, 1]);
    x = simulate.if([true, false, true], 1, [false, false, true], [10, 20, 30], [100, 200, 300]);
    assertEqual(testCase, x, [1, 200, 1]);
