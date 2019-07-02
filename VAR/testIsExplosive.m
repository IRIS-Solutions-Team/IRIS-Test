
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

startDate = 1;
endDate = 40;
range = startDate : endDate;
ar = [1, -0.7];

rng(0);
d = struct( );
d.x = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d.y = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d.z = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);


%% Test IsExplosive on Stationary

d1 = d;
v = VAR({'x', 'y', 'z'});
v = estimate(v, d1, range);

flag = isexplosive(v);
assertEqual(testCase, flag, false);


%% Test IsStationary on Stationary

d1 = d;
v = VAR({'x', 'y', 'z'});
v = estimate(v, d1, range);

flag = isstationary(v);
assertEqual(testCase, flag, true);


%% Test IsExplosive on Nonstationary

ar = [1, -1.2];
common = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d2 = d;
d2.x = common + d2.x;
d2.y = common + d2.y;
d2.z = common + d2.z;

v = VAR({'x', 'y', 'z'});
v = estimate(v, d2, range);

flag = isexplosive(v);
assertEqual(testCase, flag, true);


%% Test IsStationary on Nonstationary

ar = [1, -1.2];
common = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d2 = d;
d2.x = common + d2.x;
d2.y = common + d2.y;
d2.z = common + d2.z;

v = VAR({'x', 'y', 'z'});
v = estimate(v, d2, range);

flag = isstationary(v);
assertEqual(testCase, flag, false);


%% Test IsExplosive on Nonstationary with Tolerance

ar = [1, -1.2];
common = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d2 = d;
d2.x = common + d2.x;
d2.y = common + d2.y;
d2.z = common + d2.z;

v = VAR({'x', 'y', 'z'});
v = estimate(v, d2, range);

flag = isexplosive(v, 'Tolerance=', 1000);
assertEqual(testCase, flag, false);

