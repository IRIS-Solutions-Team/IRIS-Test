
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

    m = Model('issue260Test.model', 'Linear=', true);
    m.a = 0.8;
    m.b = -0.5;
    m.ss_x = 10;
    m.ss_y = -100;
    m.std_shock_x = 0.1;
    m.std_shock_y = 0.1;
    m = solve(m);
    m = steady(m);
    d = steadydb(m, 1:100, 'ShockFunc', @randn);
    s = simulate(m, d, 1:100);


%% Test Filter

    [~, f] = filter(m, s, 1:100, 'MeanOnly=', true);
    assertEqual(testCase, f.shock_x(2:100), s.shock_x(2:100), 'AbsTol', 1e-10);
    assertEqual(testCase, f.shock_y(2:100), s.shock_y(2:100), 'AbsTol', 1e-10);


%% Test Diffloglik

    [mll, grad, hess, v] = diffloglik(m, s, 1:100, ["a", "b"]);
    [mll1, grad1, hess1, v1] = diffloglik(m, s, 1:100, "a");
    [mll2, grad2, hess2, v2] = diffloglik(m, s, 1:100, "b");
    assertEqual(testCase, hess(1, 1), hess1, 'AbsTol', 1e-10);
    assertEqual(testCase, hess(2, 2), hess2, 'AbsTol', 1e-10);



%% Test Diffloglik Relative False

    [mll, grad, hess, v] = diffloglik(m, s, 1:100, ["a", "b"], 'Relative=', false);
    [mll1, grad1, hess1, v1] = diffloglik(m, s, 1:100, "a", 'Relative=', false);
    [mll2, grad2, hess2, v2] = diffloglik(m, s, 1:100, "b", 'Relative=', false);
    assertEqual(testCase, hess(1, 1), hess1, 'AbsTol', 1e-10);
    assertEqual(testCase, hess(2, 2), hess2, 'AbsTol', 1e-10);
    assertEqual(testCase, v, 1);
    assertEqual(testCase, v1, 1);
    assertEqual(testCase, v2, 1);

    
%% Test Diffloglik Progress

    [mll, grad, hess, v] = diffloglik(m, s, 1:100, ["a", "b"], 'Progress=', true);

