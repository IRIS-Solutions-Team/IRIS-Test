
% Set Up Once

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
range = qq(2000,1):qq(2015,4);
d = struct();
d.x = hpf2(cumsum(Series(range, @randn)));
d.y = hpf2(cumsum(Series(range, @randn)));
d.z = hpf2(cumsum(Series(range, @randn)));
d.a = hpf2(cumsum(Series(range, @randn)));
d.b = hpf2(cumsum(Series(range, @randn)));
d = databank.merge("horzcat", d, d);
v = VAR(["x", "y", "z"]);
v = estimate(v, d, range, 'order', 2);
this.TestData.range = range;
this.TestData.d = d;
this.TestData.VAR = v;


%% Test VAR Smoother Mean Only

v = this.TestData.VAR;
d = this.TestData.d;
range = this.TestData.range;
filterRange = range(3):range(end)+5;
inputDatabank = d;
inputDatabank.z(range(3:end)) = NaN;

[~, f] = filter(v, inputDatabank, filterRange, 'MeanOnly', true);
assertEqual(this, f.x(range), d.x(range), 'AbsTol', 1e-10);
assertEqual(this, f.y(range), d.y(range), 'AbsTol', 1e-10);
assertTrue(this, all(all(isfinite(f.z(range)))));

f2 = kalmanFilter(v, inputDatabank, filterRange, 'MeanOnly', true);
assertEqual(this, f2.x(range), d.x(range), 'AbsTol', 1e-10);
assertEqual(this, f2.y(range), d.y(range), 'AbsTol', 1e-10);
assertTrue(this, all(all(isfinite(f2.z(range)))));


%% Test SVAR Smoother Mean Only

v = this.TestData.VAR;
d = this.TestData.d;
range = this.TestData.range;
filterRange = range(3:end);
inputDatabank = d;
inputDatabank.z(range(3:end)) = NaN;
v = SVAR(v, [ ], 'Method', 'Chol');

[~, f] = filter(v, inputDatabank, filterRange, 'MeanOnly', true);
assertEqual(this, f.x(range), d.x(range), 'AbsTol', 1e-10);
assertEqual(this, f.y(range), d.y(range), 'AbsTol', 1e-10);
assertTrue(this, all(all(isfinite(f.z(range)))));

f2 = kalmanFilter(v, inputDatabank, filterRange, 'MeanOnly', true);
assertEqual(this, f2.x(range), d.x(range), 'AbsTol', 1e-10);
assertEqual(this, f2.y(range), d.y(range), 'AbsTol', 1e-10);
assertTrue(this, all(all(isfinite(f2.z(range)))));


%% Test Smoother with Ahead

v = this.TestData.VAR;
v = v(1);
d = this.TestData.d;
d = databank.retrieveColumns(d, 1);

range = this.TestData.range;
filterDatabank = d;
filterRange = range(3:end);

[~, g] = filter( v, filterDatabank, filterRange, ...
                'MeanOnly', true, 'Ahead', 4, 'Output', 'Pred' );

testDate = range(10);
simulateDatabank = databank.clip(d, -Inf, testDate-1);
s = simulate(v, simulateDatabank, testDate+(0:3));

for name = ["x", "y", "z"]
    filterSeries = g.(name);
    simulateSeries = s.(name);
    assertEqual(this, filterSeries(testDate, 1), simulateSeries(testDate), 'AbsTol', 1e-10);
    assertEqual(this, filterSeries(testDate+1, 2), simulateSeries(testDate+1), 'AbsTol', 1e-10);
    assertEqual(this, filterSeries(testDate+2, 3), simulateSeries(testDate+2), 'AbsTol', 1e-10);
    assertEqual(this, filterSeries(testDate+3, 4), simulateSeries(testDate+3), 'AbsTol', 1e-10);
end

g2 = kalmanFilter( v, filterDatabank, filterRange, ...
                'MeanOnly', true, 'Ahead', 4, 'Output', 'Pred' );

testDate = range(10);
simulateDatabank = databank.clip(d, -Inf, testDate-1);
s = simulate(v, simulateDatabank, testDate+(0:3));

for name = ["x", "y", "z"]
    filterSeries = g2.(name);
    simulateSeries = s.(name);
    assertEqual(this, filterSeries(testDate, 1), simulateSeries(testDate), 'AbsTol', 1e-10);
    assertEqual(this, filterSeries(testDate+1, 2), simulateSeries(testDate+1), 'AbsTol', 1e-10);
    assertEqual(this, filterSeries(testDate+2, 3), simulateSeries(testDate+2), 'AbsTol', 1e-10);
    assertEqual(this, filterSeries(testDate+3, 4), simulateSeries(testDate+3), 'AbsTol', 1e-10);
end


%% Test Conditional Forecast

v = this.TestData.VAR;
v = v(1);
d = this.TestData.d;
d = databank.retrieveColumns(d, 1);
range = this.TestData.range;

v1 = estimate(v, d, range, 'order', 2, 'diff', true);

ff = kalmanFilter(v, d, range(3:end));
fa = kalmanFilter(v, d, range(3:end), "initials", "asymptotic");

dx = struct();
dx.x = d.x;
fax = kalmanFilter(v, dx, range(3:end), "initials", "asymptotic");

