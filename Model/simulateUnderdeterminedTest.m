
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

f = ModelSource;
f.FileName = "";
f.Code = join([ 
    "!variables x, y, z !shocks ex, ey, ez "
    "!equations x=x{-1}+ex+0.1*ey+0.1*ez; y=0.1*ex+ey+0.1*ez; z=0.1*ex+0.1*ey+ez;"
]);
m = Model(f, 'Linear', true);
m = solve(m);
m = steady(m);

m = alter(m, 2);

p = Plan.forModel(m, yy(1:10), 'Method', @auto);
p = exogenize(p, yy(1:3), "x");
p = endogenize(p, yy(1:3), ["ex", "ey", "ez"]);
p = assignSigma(p, yy(1:3), "ey", 2, 1.5);

range = yy(1:10);
d = steadydb(m, range);
d.x(yy(1:3), :) = 2;
s0 = simulate(m, d, range, 'Plan', p);

testCase.TestData.Model = m;
testCase.TestData.Plan = p;
testCase.TestData.Range = range;
testCase.TestData.SimDb = s0;

%% Test Multiple Variants At Once

m = testCase.TestData.Model;
p = testCase.TestData.Plan;
range = testCase.TestData.Range;
s0 = testCase.TestData.SimDb;

s2 = simulate(m, s0, range);
for n = reshape(string(databank.filter(s0, "Class", "Series")), 1, [ ])
    assertEqual(testCase, s0.(n).Data, s2.(n).Data);
end


%% Test Multiple Variants Individually

m = testCase.TestData.Model;
p = testCase.TestData.Plan;
range = testCase.TestData.Range;
s0 = testCase.TestData.SimDb;

m1 = m(1);
m2 = m(2);
m2.std_ey = 1.5;

p1 = Plan.forModel(m1, yy(1:10), 'Method', @auto);
p1 = exogenize(p1, yy(1:3), "x");
p1 = endogenize(p1, yy(1:3), ["ex", "ey", "ez"]);

range = yy(1:10);
d = steadydb(m1, range);
d.x(yy(1:3), :) = 2;
s1 = simulate(m1, d, range, 'Plan', p1);

for n = reshape(string(databank.filter(s0, "Class", "Series")), 1, [ ])
    assertEqual(testCase, s0.(n).Data(:, 1), s1.(n).Data);
end

p2 = Plan.forModel(m2, yy(1:10), 'Method', @auto);
p2 = exogenize(p2, yy(1:3), "x");
p2 = endogenize(p2, yy(1:3), ["ex", "ey", "ez"]);
p2 = assignSigma(p2, range, "ey", 1.5);

range = yy(1:10);
d = steadydb(m2, range);
d.x(yy(1:3), :) = 2;
s2 = simulate(m2, d, range, 'Plan', p2);

for n = reshape(string(databank.filter(s0, "Class", "Series")), 1, [ ])
    assertEqual(testCase, s0.(n).Data(:, 2), s2.(n).Data);
end

