
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test One Variant

m = Model('issue254Test.model', 'Linear=', true);
m = solve(m);
m = steady(m);

assertEqual(testCase, beenSolved(m), true);
assertEqual(testCase, isnan(m), false);
assertEqual(testCase, m.x, -1);


%% Test Multiple Variants

nv = 10;
m = Model('issue254Test.model', 'Linear=', true);
m = alter(m, nv);
m = solve(m);
m = steady(m);

assertEqual(testCase, beenSolved(m), repmat(true, 1, nv));
assertEqual(testCase, isnan(m), false);
assertEqual(testCase, m.x, repmat(-1, 1, nv));


