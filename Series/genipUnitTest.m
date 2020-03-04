
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

lowRange = yy(2001):yy(2100);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
testRange = qq(lowRange(1), 1) : highEnd;
x = 100*Series(lowRange, exp(cumsum(randn(numel(lowRange), 1)/100)));
y = 100*Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/100)));

testCase.TestData.LowRange = lowRange;
testCase.TestData.HighRange = highRange;
testCase.TestData.TestRange = testRange;
testCase.TestData.LowSeries = x;
testCase.TestData.Indicator = y;



                                                                           
%% Mean Rate Test

lowRange = yy(2001):yy(2020);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
x = Series(lowRange, exp(cumsum(randn(numel(lowRange), 1)/10)));
y = Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/40)));
dy = roc(y);

%
% Run genip
%
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @mean ...
    , 'Indicator=', y ...
);

%
% Test output series
%
zy = convert(zq, Frequency.YEARLY);
assertEqual(testCase, getData(zy, lowRange), getData(x, lowRange), 'AbsTol', 1e-7);

% 
% Test aggregation matrix
%
Z = info.LinearSystem.SystemMatrices{4};
x__ = dy(info.HighRange(1));
assertEqual(testCase, Z(:, :, 2), [1/4, 1/4, 1/4, 1/4; 0, 0, -x__, 1]);

%
% Test transition matrix
%
T = info.LinearSystem.SystemMatrices{1};
T(end, end, :) = 0;
numPeriods = numel(info.HighRange);
assertEqual(testCase, T(:, :, 2:end), repmat(diag(ones(1, 3), 1), 1, 1, numPeriods), 'AbsTol', 1e-10);

tempRange = highRange(9:end);
xi1 = retrieveColumns(info.OutputData.SmoothMean.Xi, 1);
xi2 = retrieveColumns(info.OutputData.SmoothMean.Xi, 2);
xi3 = retrieveColumns(info.OutputData.SmoothMean.Xi, 3);
xi4 = retrieveColumns(info.OutputData.SmoothMean.Xi, 4);
assertEqual(testCase, getData(xi4, tempRange-1), getData(xi3, tempRange), 'AbsTol', 1e-7); 
assertEqual(testCase, getData(xi4, tempRange-2), getData(xi2, tempRange), 'AbsTol', 1e-7); 
assertEqual(testCase, getData(xi4, tempRange-3), getData(xi1, tempRange), 'AbsTol', 1e-7); 

%
% Test default versus explicit Range=
%
[zq2, kalmanObject2] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @mean ...
    , 'Indicator=', y ...
    , 'Range=', lowRange ...
);
assertEqual(testCase, zq.Data, zq2.Data, 'AbsTol', 1e-10);



                                                                           
%% Mean Level Test

lowRange = yy(2001):yy(2100);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
numLowPeriods = numel(lowRange);
x = Series(lowRange, randn(numel(lowRange), 1));
ind = Series(highRange, randn(numel(highRange), 1));

[z0, info0] = genip( ...
    x, Frequency.QUARTERLY, 'Level', @mean ...
    , 'TransitionConstant=', 0 ...
);

[z1, info1] = genip( ...
    x, Frequency.QUARTERLY, 'Level', @mean ...
    , 'Indicator=', ind ...
    , 'TransitionConstant=', 0 ...
);

[z2, info2] = genip( ...
    x, Frequency.QUARTERLY, 'Level', @mean ...
    , 'Indicator=', ind ...
    , 'StdIndicator=', 0.5 ...
    , 'TransitionConstant=', 0 ...
);

assertEqual(testCase, getData(convert(z0, 1), lowRange), getData(x, lowRange), 'AbsTol', 1e-7);
assertEqual(testCase, getData(convert(z1, 1), lowRange), getData(x, lowRange), 'AbsTol', 1e-7);
[~, r0] = acf([ind, z0]);
[~, r1] = acf([ind, z1]);
[~, r2] = acf([ind, z2]);
assertGreaterThan(testCase, r1(2, 1), 0);
assertGreaterThan(testCase, r1(2, 1), 3*max(0, r0(2, 1)));
assertGreaterThan(testCase, r1(2, 1), r2(2, 1));
T = [0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1; 0, 0, 0, 0];
assertEqual(testCase, info0.LinearSystem.SystemMatrices{1}(:, :, 2:end), repmat(T, 1, 1, 4*numLowPeriods));
assertEqual(testCase, info1.LinearSystem.SystemMatrices{1}(:, :, 2:end), repmat(T, 1, 1, 4*numLowPeriods));




                                                                           
%% Mean Diff Test

lowRange = yy(2001):yy(2020);
numLowPeriods = numel(lowRange);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
x = Series(lowRange, randn(numel(lowRange), 1));
ind = Series(highRange, randn(numel(highRange), 1));
dind = diff(ind);

[z0, info0] = genip( ...
    x, Frequency.QUARTERLY, 'Diff', @mean ...
    , 'TransitionConstant=', 0 ...
);

[z1, info1] = genip( ...
    x, Frequency.QUARTERLY, 'Diff', @mean ...
    , 'TransitionConstant=', 0 ...
    , 'Indicator=', ind ...
);

[~, r0] = acf([dind, diff(z0)]);
[~, r1] = acf([dind, diff(z1)]);

assertEqual(testCase, getData(convert(z0, 1), lowRange), getData(x, lowRange), 'AbsTol', 1e-7);
assertEqual(testCase, getData(convert(z1, 1), lowRange), getData(x, lowRange), 'AbsTol', 1e-7);
[~, r0] = acf([dind, diff(z0)]);
[~, r1] = acf([dind, diff(z1)]);
assertGreaterThan(testCase, r1(2, 1), 0);
assertGreaterThan(testCase, r1(2, 1), 5*abs(r0(2, 1)));
T = [0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1; 0, 0, 0, 1];
assertEqual(testCase, info0.LinearSystem.SystemMatrices{1}(:, :, 2:end), repmat(T, 1, 1, 4*numLowPeriods));
assertEqual(testCase, info1.LinearSystem.SystemMatrices{1}(:, :, 2:end), repmat(T, 1, 1, 4*numLowPeriods));



                                                                           
%% Mean DiffDiff Test

lowRange = yy(2001):yy(2020);
numLowPeriods = numel(lowRange);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
x = Series(lowRange, randn(numel(lowRange), 1));
ind = Series(highRange, randn(numel(highRange), 1));
ddind = diff(diff(ind));

[z0, info0] = genip( ...
    x, Frequency.QUARTERLY, 'DiffDiff', @mean ...
    , 'TransitionConstant=', 0 ...
);
[z1, info1] = genip( ...
    x, Frequency.QUARTERLY, 'DiffDiff', @mean ...
    , 'TransitionConstant=', 0 ...
    , 'Indicator=', ind ...
);

assertEqual(testCase, getData(convert(z0, 1), lowRange), getData(x, lowRange), 'AbsTol', 1e-7);
assertEqual(testCase, getData(convert(z1, 1), lowRange), getData(x, lowRange), 'AbsTol', 1e-7);
[~, r0] = acf([ddind, diff(diff(z0))]);
[~, r1] = acf([ddind, diff(diff(z1))]);
assertGreaterThan(testCase, r1(2, 1), 0);
assertGreaterThan(testCase, r1(2, 1), 5*abs(r0(2, 1)));
T = [0, 1, 0, 0; 0, 0, 1 0; 0, 0, 0, 1; 0, 0, -1, 2];
assertEqual(testCase, info0.LinearSystem.SystemMatrices{1}(:, :, 2:end), repmat(T, 1, 1, 4*numLowPeriods));
assertEqual(testCase, info1.LinearSystem.SystemMatrices{1}(:, :, 2:end), repmat(T, 1, 1, 4*numLowPeriods));



                                                                           
%% Average Test

lowRange = yy(2001):yy(2020);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
x = Series(lowRange, exp(cumsum(randn(numel(lowRange), 1)/40)));
y = Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/40)));

[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @mean ...
    , 'Indicator=', y ...
);

%
% Test output series
%
zy = convert(zq, Frequency.YEARLY, 'Method=', @mean);
assertEqual(testCase, getData(zy, lowRange), getData(x, lowRange), 'AbsTol', 1e-7);

%
% Test aggregation matrix
%
Z = info.LinearSystem.SystemMatrices{4};
assertEqual(testCase, Z(1, :, 2), [1, 1, 1, 1]/4);

% 
% Test indicator measurement
%
Z__ = reshape(Z(2, 3, 2:end), [ ], 1);
assertEqual(testCase, getDataFromTo(roc(y), highStart+4, highEnd), -Z__, 'AbsTol', 1e-10);



                                                                           
%% Last Test

lowRange = yy(2001):yy(2020);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
x = Series(lowRange, exp(cumsum(randn(numel(lowRange), 1)/40)));
y = Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/40)));

%
% Run genip
%
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', 'Last' ...
    , 'Indicator=', y ...
);

%
% Test output series
%
zy = convert(zq, Frequency.YEARLY, 'Method=', 'Last');
assertEqual(testCase, getData(zy, lowRange), getData(x, lowRange), 'AbsTol', 1e-7);

%
% Test aggregation matrix
%
Z = info.LinearSystem.SystemMatrices{4};
assertEqual(testCase, Z(1, :, 2), [0, 0, 0, 1]);

% 
% Test size of transition matrix
%
Z__ = reshape(Z(2, 3, 2:end), [ ], 1);
assertEqual(testCase, getDataFromTo(roc(y), highStart+4, highEnd), -Z__, 'AbsTol', 1e-10);




                                                                           
%% User Supplied Aggregation Test

lowRange = yy(2001):yy(2020);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
x = Series(lowRange, exp(cumsum(randn(numel(lowRange), 1)/40)));
y = Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/40)));

aggregation = randn(1, 4);
aggregation = aggregation / sum(aggregation, 2);
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', aggregation ...
    , 'Indicator=', y ...
);

%
% Test output series
%
zy = convert(zq, Frequency.YEARLY, 'Method=', aggregation);
assertEqual(testCase, getData(zy, lowRange), getData(x, lowRange), 'AbsTol', 1e-7);

%
% Test aggregation matrix
%
Z = info.LinearSystem.SystemMatrices{4};
assertEqual(testCase, Z(1, :, 2), aggregation, 'AbsTol', 1e-10);



                                                                           
%% Replicate Indicator

lowRange = yy(2001):yy(2100);
highStart = qq(lowRange(1)-1, 1);
highEnd = qq(lowRange(end), 4);
highRange = highStart:highEnd;
testRange = qq(lowRange(1), 1) : highEnd;
y = 100*Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/100)));

%
% Aggregation=sum
%
x = convert(y, Frequency.YEARLY, 'Method=', @sum);
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @sum ...
    , 'Range=', lowRange ...
    , 'Indicator=', y ...
    , 'StdIndicator=', 1e-3 ...
);
assertEqual(testCase, getData(zq, testRange), getData(y, testRange), 'RelTol', 1e-7);

%
% Aggregation=mean (average)
%
x = convert(y, Frequency.YEARLY, 'Method=', 'mean');
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @mean ...
    , 'Indicator=', y...
    , 'Range=', lowRange ...
);
assertEqual(testCase, getData(zq, testRange), getData(y, testRange), 'RelTol', 1e-7);

%
% Aggregation=last 
%
x = convert(y, Frequency.YEARLY, 'Method=', 'last');
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', 'Last' ...
    , 'Indicator=', y ...
    , 'Range=', lowRange ...
);
assertEqual(testCase, getData(zq, testRange), getData(y, testRange), 'RelTol', 1e-7);

%
% Aggregation=[...]
%
aggregation = 0.5 + 0.5*rand(1, 4);
x = convert(y, Frequency.YEARLY, 'Method=', aggregation);
[zq, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', aggregation ...
    , 'Indicator=', y ...
    , 'Range=', lowRange ...
);
assertEqual(testCase, getData(zq, testRange), getData(y, testRange), 'RelTol', 1e-7);



                                                                           
%% Conditioning Quarterly

lowRange = testCase.TestData.LowRange;
highRange = testCase.TestData.HighRange;
testRange = testCase.TestData.TestRange;
x = testCase.TestData.LowSeries;
y = testCase.TestData.Indicator;
condRange = highRange(end-20:end-13);

x = convert(y, Frequency.YEARLY);
[z, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @mean ...
    , 'Indicator=', y ...
    , 'HighRate=', clip(roc(y), condRange) ...
);
assertEqual(testCase, getData(roc(z), condRange), getData(roc(y), condRange), 'AbsTol', 1e-7);

x = convert(y, Frequency.YEARLY);
[z, info] = genip( ...
    x, Frequency.QUARTERLY, 'Rate', @mean ...
    , 'Indicator=', y ...
    , 'HighDiff=', clip(diff(y), condRange) ...
);
assertEqual(testCase, getData(diff(z), condRange), getData(diff(y), condRange), 'AbsTol', 1e-7);



                                                                           
%% Conditioning Monthly

lowRange = testCase.TestData.LowRange;
highStart = mm(lowRange(1)-1, 1);
highEnd = mm(lowRange(end), 12);
highRange = highStart:highEnd;
testRange = mm(lowRange(1), 1) : highEnd;
condRange = highRange(end-40:end-13);
y = 100*Series(highStart:highEnd, exp(cumsum(randn(numel(highRange), 1)/100)));

x = convert(y, Frequency.YEARLY);
[z, info] = genip( ...
    x, Frequency.MONTHLY, 'Rate', @mean ...
    , 'Indicator=', y ...
    , 'HighRate=', clip(roc(y), condRange) ...
);
assertEqual(testCase, getData(roc(z), condRange), getData(roc(y), condRange), 'AbsTol', 1e-7);

x = convert(y, Frequency.YEARLY);
[z, info] = genip( ...
    x, Frequency.MONTHLY, 'Rate', @mean ...
    , 'Indicator=', y ...
    , 'HighDiff=', clip(diff(y), condRange) ...
);
assertEqual(testCase, getData(diff(z), condRange), getData(diff(y), condRange), 'AbsTol', 1e-7);


