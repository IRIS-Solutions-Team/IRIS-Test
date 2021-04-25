
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test VAR with and without Small Sample Correction

order = 2;
intercept = true;
startFit = qq(1,1);
endFit = qq(20,4);

fitRange = startFit : endFit;
extRange = startFit-order : endFit;
numFitPeriods = numel(fitRange);
numExtPeriods = numel(extRange);

inputDb = struct( );
inputDb.x = Series(extRange, cumsum(randn(numExtPeriods, 1)));
inputDb.y = Series(extRange, cumsum(randn(numExtPeriods, 1)));
inputDb.z = Series(extRange, cumsum(randn(numExtPeriods, 1)));

v = VAR({'x', 'y', 'z'}, 'Order', order, 'Intercept', intercept);

%
% No small sample correction
% Omega = e' * e / numPeriods
%
[v0, outputDb0] = estimate( ...
    v, inputDb, extRange...
    , 'StartDate', 'Presample' ...
);

% The following use of fitRange and StartDate=Fitted is exactly equivalent
% to the previous run
%
%     [v0, outputDb0] = estimate( ...
%         v, inputDb, fitRange...
%         , 'StartDate', 'Fitted' ...
%     );

%
% Small sample correction
% Omega = e' * e / (numPeriods - numParams)
%
[v1, outputDb1] = estimate( ...
    v, inputDb, extRange...
    , 'StartDate', 'Presample' ...
    , 'SmallSampleCorrection', true ...
);

numParams = nnz(intercept) + 3*order;

res0 = databank.toDoubleArray(outputDb0, get(v0, 'ENames'), fitRange);
Omega0 = res0' * res0 / numFitPeriods;
assertEqual(testCase, get(v0, 'Omega'), Omega0, 'AbsTol', 1e-12);

res1 = databank.toDoubleArray(outputDb1, get(v1, 'ENames'), fitRange);
Omega1 = res1' * res1 / (numFitPeriods - numParams);
assertEqual(testCase, get(v1, 'Omega'), Omega1, 'AbsTol', 1e-12);

