
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test success

m1 = Model.fromSnippet("test1");

% test1>>>
% !variables x, y
% !parameters alpha=0.5, beta=0.8, std_epsilon=1, std_omega=0.5
% !parameters corr_epsilon__omega=-0.5
% !shocks epsilon, omega
% !equations x=alpha; y=beta;
% <<<test1

assertEqual(testCase, access(m1, "names"), ["x", "y", "epsilon", "omega", "alpha", "beta"]);
assertEqual(testCase, m1.alpha, 0.5);
assertEqual(testCase, m1.beta, 0.8);
assertEqual(testCase, m1.std_epsilon, 1);
assertEqual(testCase, m1.std_omega, 0.5);
assertEqual(testCase, m1.corr_epsilon__omega, -0.5);


%% Test failed

hasError = false;
try
    m2 = Model.fromSnippet("test2");
catch
    hasError = true;
end

assertTrue(testCase, hasError);

% test2>>>
% !variables x, y, std_zz
% !parameters alpha=0.5, beta=0.8, std_epsilon=1, std_omega=0.5
% !parameters corr_epsilon__omega=-0.5
% !shocks epsilon, omega
% !equations x=alpha; y=beta;
% <<<test2
