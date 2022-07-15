
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

try
    db = databank.fromCSV('testInterpolate.csv');
catch
    db = databank.fromFred.data({'CLVMNACSCAB1GQEA19->gdp_eu', 'CLVMNACSCAB1GQDE->gdp_ge'});
    range = databank.range(db, 'Frequency', Frequency.QUARTERLY);
    databank.toCSV(db, 'testInterpolate.csv', range);
end

indicator = db.gdp_ge;
series = convert(db.gdp_eu, Frequency.YEARLY, 'Method', @sum);

startYear = yy(2001);
endYear = yy(2018);
numYears = endYear - startYear + 1;

startQuarter = convert(startYear, Frequency.QUARTERLY);
endQuarter = convert(endYear, Frequency.QUARTERLY) + 3;
numQuarters = endQuarter - startQuarter + 1;

roc_indicator = roc(indicator);
indicatorYearly = convert(indicator, Frequency.YEARLY, 'Method', @sum);
factor = nanmean(series(startYear:endYear)./indicatorYearly(startYear:endYear));
x0 = factor * indicator(startQuarter+[-4,-3,-2,-1]);

observed = convert(series, Frequency.QUARTERLY, 'Method', 'WriteToEnd');

T = zeros(4, 4, numQuarters);
T(4, 4, :) = roc_indicator(startQuarter:endQuarter);
T(1, 2, :) = 1;
T(2, 3, :) = 1;
T(3, 4, :) = 1;

R = [0; 0; 0; 1];
k = zeros(4, 1);
Z = ones(1, 4);
H = zeros(1, 0);
d = zeros(1, 1);

OmegaV = 1;
OmegaW = [ ];

m = LinearSystem([4, 4, 1, 1, 0], numQuarters);
m = steadySystem(m, 'NotNeeded');
m = timeVaryingSystem(m, 1:numQuarters, {T, R, k, Z, H, d}, {OmegaV, OmegaW});

if ~verLessThan('matlab', '9.9')
    outputData = kalmanFilter(m, observed, startQuarter:endQuarter, 'initials', {x0, zeros(4)});
    interp = outputData.SmoothMean.Xi{startQuarter:endQuarter, 4};

    interpYearly = convert(interp, Frequency.YEARLY, 'Method', @sum);
    assertEqual(this, series(startYear:endYear), interpYearly(startYear:endYear), 'RelTol', 1e-10);
end
