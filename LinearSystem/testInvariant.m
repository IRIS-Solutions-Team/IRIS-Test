
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

startData = 1;
endData = 40;
dataRange = startData:endData;
x = Series(dataRange, @randn)/10;
x = arf(x, [1, -0.9], x, startData+1:endData);
startFilter = startData;
endFilter = endData;
filterRange = startFilter:endFilter;
numPeriods = numel(filterRange);

b = LinearSystem([2, 2, 2, 1, 1], numPeriods);

T = diag([0.9, 0.5]);
R = eye(2);
k = zeros(2, 1);

Z = [1, 1];
H = 1;
d = 0;

stdV = [0.5; 1];
stdW = [0.1];
OmegaV = diag(stdV.^2);
OmegaW = diag(stdW.^2);

b = steadySystem(b, {T, R, k, Z, H, d}, {OmegaV, OmegaW});


%% Test Invariant

    [TT, RR, kk, ZZ, HH, dd, UU, ZZb, inxV, inxW, numUnit, inxInit] = getIthKalmanSystem(b, 1, 2);


    [data, b, info] = kalmanFilter(b, x, filterRange);

    y = data.SmoothMean.Y(filterRange, :);
    xi = data.SmoothMean.Xi(filterRange, :);
    v = data.SmoothMean.V(filterRange, :);
    w = data.SmoothMean.W(filterRange, :);
    assertEqual(testCase, y, sum(xi, 2) + w, 'AbsTol', 1e-10);


%% Test time invariant output arguments

    [data, b, info] = kalmanFilter(b, x, filterRange);
    [data2, b2, info2] = kalmanFilter(b, x, filterRange, "relative", true);
    c = b.CovarianceMatrices{1}(:, :, 1);
    c2 = b2.CovarianceMatrices{1}(:, :, 1);
    assertEqual(testCase, c2, c*info2.VarScale, 'absTol', 1e-8);


%% Test time varying

    b1 = b;

    T1 = diag([0.99, 0]);
    %b1 = timeVaryingSystem(b1, 21, {T1}, { });
    b1 = timeVaryingSystem(b1, 16, { }, {[ ], 20});

    [data1, b1, info1] = kalmanFilter(b1, x, filterRange, 'initials', {zeros(2, 1), zeros(2, 2)});

    y1 = data1.SmoothMean.Y(filterRange, :);
    xi1 = data1.SmoothMean.Xi(filterRange, :);
    v1 = data1.SmoothMean.V(filterRange, :);
    w1 = data1.SmoothMean.W(filterRange, :);
    assertEqual(testCase, y1, sum(xi1, 2) + w1, 'AbsTol', 1e-10);

    [data2, b2, info2] = kalmanFilter(b1, x, filterRange, "initials", {zeros(2, 1), zeros(2, 2)}, "relative", true);

