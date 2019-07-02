
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

startDate = 1;
endDate = 40;
range = startDate : endDate;
ar = [1, -0.8];

d = struct( );
common = arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d.x = common + arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d.y = common + arf(Series(startDate-1, 0), ar, Series(range, @randn), range);
d.z = common + arf(Series(startDate-1, 0), ar, Series(range, @randn), range);

v = VAR({'x', 'y', 'z'});
v = estimate(v, d, range);


%% Test Sprintf

c = sprintf([v, v], 'Decimals=', 2);
assertClass(testCase, c, 'cell');
for i = 1 : 2
    assertSubstring(testCase, c{i}, 'x = ');
    assertSubstring(testCase, c{i}, 'y = ');
    assertSubstring(testCase, c{i}, 'z = ');
    assertSubstring(testCase, c{i}, '1.00*res');
end


%% Test Sprintf with YName Option

c = sprintf([v, v], 'Decimals=', 2, 'YNames=', {'a', 'b', 'c'});
assertClass(testCase, c, 'cell');
for i = 1 : 2
    assertSubstring(testCase, c{i}, 'a = ');
    assertSubstring(testCase, c{i}, 'b = ');
    assertSubstring(testCase, c{i}, 'c = ');
end


%% Test Sprintf with EName Option

c = sprintf([v, v], 'Decimals=', 2, 'ENames=', {'shock1', 'shock2', 'shock3'});
assertClass(testCase, c, 'cell');
for i = 1 : 2
    assertSubstring(testCase, c{i}, '1.00*shock1');
    assertSubstring(testCase, c{i}, '1.00*shock2');
    assertSubstring(testCase, c{i}, '1.00*shock3');
end

