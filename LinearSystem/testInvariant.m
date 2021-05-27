
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

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

if ~verLessThan('matlab', '9.9')
    [TT, RR, kk, ZZ, HH, dd, UU, ZZb, inxV, inxW, numUnit, inxInit] = getIthKalmanSystem(b, 1, 2);


    data = filter(b, x, filterRange);

    y = data.SmoothMean.Y(filterRange, :);
    xi = data.SmoothMean.Xi(filterRange, :);
    v = data.SmoothMean.V(filterRange, :);
    w = data.SmoothMean.W(filterRange, :);
    assertEqual(this, y, sum(xi, 2) + w, 'AbsTol', 1e-10);
end

%% Test Time Varying

if ~verLessThan('matlab', '9.9')
    b1 = b;

    T1 = diag([0.99, 0]);
    %b1 = timeVaryingSystem(b1, 21, {T1}, { });
    b1 = timeVaryingSystem(b1, 16, { }, {[ ], 20});

    [data1, nondata1] = filter(b1, x, filterRange, 'Init', {zeros(2, 1), zeros(2, 2)});

    y1 = data1.SmoothMean.Y(filterRange, :);
    xi1 = data1.SmoothMean.Xi(filterRange, :);
    v1 = data1.SmoothMean.V(filterRange, :);
    w1 = data1.SmoothMean.W(filterRange, :);
    assertEqual(this, y1, sum(xi1, 2) + w1, 'AbsTol', 1e-10);
end

