
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once

m = Model.fromSnippet("test", "growth", true);

% test>>>
% !variables x
% !equations x = x{-1} + 0.5;
% <<<test

testCase.TestData.Model = m;


%% Test with pseudoinv 

m = testCase.TestData.Model;
m = steady(m, "solver", {"Newton", "pseudoinvWhenSingular", true});
assertTrue(testCase, isfinite(real(m.x)));
assertTrue(testCase, isfinite(imag(m.x)));


%% Test without pseudoinv 

m = testCase.TestData.Model;
lastwarn('');
m = steady(m, "solver", {"Newton", "pseudoinvWhenSingular", false});

assertNotEmpty(testCase, lastwarn());

