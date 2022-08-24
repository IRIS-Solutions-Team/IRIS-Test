

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test loading legacy tseries objects

warning off MATLAB:unknownElementsNowStruc
load ua_processed_data.mat
warning on MATLAB:unknownElementsNowStruc

for n = textual.fields(dfm)
    assertTrue(testCase, isa(dfm.(n), 'Series'));
end

for n = textual.fields(dfq)
    assertTrue(testCase, isa(dfq.(n), 'Series'));
end

for n = textual.fields(dfy)
    assertTrue(testCase, isa(dfy.(n), 'Series'));
end

