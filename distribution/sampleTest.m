

%% Test Normal

rng(0)
t = distribution.Normal.fromMeanStd(-4, 0.2);
locallyCompare(t)


%% Test LogNormal

rng(0)
t = distribution.LogNormal.fromMuSigma(2.5, 0.5);
locallyCompare(t)


%% Test Beta

rng(0)
t = distribution.Beta.fromAB(2, 3);
locallyCompare(t)


%% Test Gamma

rng(0)
t = distribution.Gamma.fromAlphaBeta(2, 3);
locallyCompare(t)


%% Test ChiSquare

rng(0)
t = distribution.ChiSquare.fromDegreesFreedom(5);
locallyCompare(t)


%% Test Student

rng(0)
t = distribution.Student.fromLocationScale(4, -3, 1.8);
locallyCompare(t)


%% Test Uniform

rng(0)
t = distribution.Uniform.fromLowerUpper(-3, 10);
locallyCompare(t)


%
% Local Functions
%

function locallyCompare(t)
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    y1 = sample(t, 1, 1000000);
    y2 = sample(t, 1, 1000000, 'Stats');
    y3 = sample(t, 1, 1000000, 'Iris');
    assertEqual(testCase, mean(y1), t.Mean, 'RelTol', 1e-1);
    assertEqual(testCase, var(y1), t.Var, 'RelTol', 1e-1);
    assertEqual(testCase, mean(y2), t.Mean, 'RelTol', 1e-1);
    assertEqual(testCase, var(y2), t.Var, 'RelTol', 1e-1);
    assertEqual(testCase, mean(y3), t.Mean, 'RelTol', 1e-1);
    assertEqual(testCase, var(y3), t.Var, 'RelTol', 1e-1);
end%

