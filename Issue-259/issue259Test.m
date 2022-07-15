
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

m = Model.fromFile('issue259Test.model', 'linear', true);
m = alter(m, 1000);
m.a = rand(1, 1000);


%% Test Solve

    m = solve(m, 'progress', true);


%% Test Simulate

    m = solve(m);
    m = steady(m);
    [s, info] = simulate(m, struct( ), 1:10, 'Progress', true);
    assertEqual(testCase, s.x.Data, repmat(m.a, 10, 1), 'AbsTol', 1e-10);
    assertEqual(testCase, 1, 1);

