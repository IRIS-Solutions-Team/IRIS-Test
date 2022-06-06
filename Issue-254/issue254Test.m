
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test One Variant

m = Model.fromFile('issue254Test.model', 'linear', true);
m = solve(m);
m = steady(m);

assertEqual(testCase, beenSolved(m), true);
assertEqual(testCase, isnan(m), false);
assertEqual(testCase, m.x, -1);


%% Test Multiple Variants

nv = 10;
m = Model.fromFile('issue254Test.model', 'linear', true);
m = alter(m, nv);
m = solve(m);
m = steady(m);

assertEqual(testCase, beenSolved(m), true(1, nv));
assertEqual(testCase, isnan(m), false);
assertEqual(testCase, m.x, repmat(-1, 1, nv));


