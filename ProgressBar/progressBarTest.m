
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Plain Vanilla

x = ProgressBar('Test');
for i = 1 : 73
    update(x, i/73)
end

