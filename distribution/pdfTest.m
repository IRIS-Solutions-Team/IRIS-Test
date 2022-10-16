

x = ver();
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
testCase.TestData.statsCheck = contains([x.Name], 'Statistics and Machine Learning');

if ~testCase.TestData.statsCheck
    return
end



%% Test Normal

if ~testCase.TestData.statsCheck
    return
end

rng(0)
for i = 1 : 10
    t = distribution.Normal.fromMeanStd(randn, 10*rand);
    data = 10*randn(100, 1);
    expected = normpdf(data, t.Mean, t.Std);
    locallyCompare(t, data, expected)
end


%% Test LogNormal

if ~testCase.TestData.statsCheck
    return
end


rng(0)
for i = 1 : 10
    t = distribution.LogNormal.fromMuSigma(0.5+randn, 1+rand);
    data = 10*abs(randn(1, 100));
    expected = lognpdf(data, t.Mu, t.Sigma);
    locallyCompare(t, data, expected)
end


%% Test Beta

if ~testCase.TestData.statsCheck
    return
end

rng(0)
for i = 1 : 10
    t = distribution.Beta.fromAB(5*rand, 5*rand);
    data = 10*abs(randn(1, 100));
    expected = betapdf(data, t.A, t.B);
    locallyCompare(t, data, expected)
end


%% Test Gamma

if ~testCase.TestData.statsCheck
    return
end

rng(0)
for i = 1 : 10
    t = distribution.Gamma.fromAlphaBeta(0.5+abs(randn), 1+rand);
    data = 10*abs(randn(1, 100));
    expected = gampdf(data, t.Alpha, t.Beta);
    locallyCompare(t, data, expected)
end


%% Test ChiSquare

if ~testCase.TestData.statsCheck
    return
end

rng(0)
for i = 1 : 10
    t = distribution.ChiSquare.fromDegreesFreedom(3+10*rand);
    data = 10*abs(randn(1, 100));
    expected = chi2pdf(data, t.DegreesFreedom);
    locallyCompare(t, data, expected)
end


%% Test Student

if ~testCase.TestData.statsCheck
    return
end

rng(0)
for i = 1 : 10
    t = distribution.Student.standardized(3+10*rand);
    data = 0.5 + 10*abs(randn(1, 100));
    expected = tpdf(data, t.DegreesFreedom);
    locallyCompare(t, data, expected)
end


%
% Local Functions
%

function locallyCompare(t, data, expected)
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    actual = pdf(t, data);
    assertEqual(testCase, actual, expected, 'RelTol', 1e-10);
    actual = logPdf(t, data) + t.LogConstant;
    assertEqual(testCase, actual, log(expected), 'RelTol', 1e-10);
end%

