
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    m = Model('issue257Test.model', 'Linear', true);
    m = solve(m);


%% Test Vanilla
    d = zerodb(m, 0:5);
    d.e(-2:5) = [0; 0; rand(6, 1)];
    s = simulate(m, d, 0:5, 'Deviation', true);

    assertEqual(testCase, s.x(0:5), d.e(0:5));
    assertEqual(testCase, s.y(0:5), d.e(0:5)-d.e(-1:4));
    assertEqual(testCase, s.z(0:5), d.e(0:5)-d.e(-2:3));


%% Test Initial Condition
    d = zerodb(m, 0:5);
    d.x(-2:-1) = rand(2, 1);
    d.e(-2:5) = [0; 0; rand(6, 1)];
    s = simulate(m, d, 0:5, 'Deviation', true);
    d.e(-2:-1) = d.x(-2:-1);

    assertEqual(testCase, s.x(0:5), d.e(0:5));
    assertEqual(testCase, s.y(0:5), d.e(0:5)-d.e(-1:4));
    assertEqual(testCase, s.z(0:5), d.e(0:5)-d.e(-2:3));


%% Test Filter Y
    d = struct( );
    d.y = Series(0:5, @rand);
    d.z = Series( );
    m.std_u = 0;
    [~, f] = filter(m, d, 0:5, 'MeanOnly', true);

    assertEqual(testCase, getData(diff(f.x), 0:5), d.y(0:5), 'AbsTol', 1e-10);


%% Test Filter Z
    d = struct( );
    d.z = Series(0:5, @rand);
    d.y = Series( );
    m.std_v = 0;
    [~, f] = filter(m, d, 0:5, 'MeanOnly', true);

    assertEqual(testCase, getData(diff(f.x, -2), 0:5), d.z(0:5), 'AbsTol', 1e-10);

