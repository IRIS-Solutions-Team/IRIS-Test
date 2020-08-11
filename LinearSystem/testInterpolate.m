
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

try
    db = databank.fromCSV('testInterpolate.csv');
catch
    db = databank.fromFred({'CLVMNACSCAB1GQEA19->gdp_eu', 'CLVMNACSCAB1GQDE->gdp_ge'});
    range = databank.range(db, 'Frequency=', Frequency.QUARTERLY);
    databank.toCSV(db, 'testInterpolate.csv', range);
end

startYear = yy(2001);
endYear = yy(2018);
numYears = endYear - startYear + 1;

startQuarter = convert(startYear, Frequency.QUARTERLY);
endQuarter = convert(endYear, Frequency.QUARTERLY) + 3;
numQuarters = endQuarter - startQuarter + 1;

indicator = db.gdp_ge;
roc_indicator = roc(indicator);
series = convert(db.gdp_eu, Frequency.YEARLY, 'Method=', @sum);
indicatorYearly = convert(indicator, Frequency.YEARLY, 'Method=', @sum);
factor = nanmean(series(startYear:endYear)./indicatorYearly(startYear:endYear));
x0 = indicator(startQuarter+[-4;-3;-2;-1]);
x0 = x0*factor;

x = yearly(indicator, startYear:endYear);


%% Create LinearSystem Object

sigma = 0;
damp = 0;
known = 0;

z = [1, 1, 1, 1];

a = nan(4, 4, numYears);
b = nan(4, 4, numYears);
sigmav = repmat(eye(4, 4), numYears);
sigmaw = repmat(sigma, 1, numYears);

for i = 1 : numYears
    year = startYear + (i - 1);
    a0 = eye(4);
    a1 = zeros(4);
    temp = yearly(roc_indicator, year);
    a1(1, 4) = temp(1);
    for j = 2 : 4
        a0(j, j-1) = -temp(j);
    end
    inva0 = inv(a0);
    inva0a1 = inva0 * a1; %lusolve(a0, a1);
    a(:, :, i) = inva0a1;
    b(:, :, i) = inva0;
end

k = LinearSystem([4, 4, 4, 1, 0], numYears); 
k = steadySystem(k, 'NotNeeded');
k = timeVaryingSystem(k, 1:numYears, {a, b, zeros(4, 1), z, [ ], 0}, {eye(4), [ ]});
init = { x0, zeros(4) };
f = filter(k, series, startYear:endYear, 'Init=', init);
states = f.SmoothMean.Xi;
interp = Series(startQuarter, reshape(transpose(states(startYear:endYear)), [ ], 1));

assertEqual(this, series(startYear:endYear), sum(states(startYear:endYear),2), 'RelTol', 1e-10);

