
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test steadydb
    m = solve(steady(Model.fromFile('selectiveWithLogVariablesTest.model')));
    d = steadydb(m, 1:5);
    s = simulate(m, d, 1:5, 'method', 'selective');
    assertEqual(testCase, d.y(1:5), s.y(1:5), 'AbsTol', 1e-8);


%% Test zerodb
    m = solve(steady(Model.fromFile('selectiveWithLogVariablesTest.model')));
    d = zerodb(m, 1:5);
    s = simulate(m, d, 1:5, 'method', 'selective', 'deviation', true);
    assertEqual(testCase, d.y(1:5), s.y(1:5), 'AbsTol', 1e-8);

