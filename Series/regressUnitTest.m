% saveAs=Series/regressUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once

d = struct();
d.x = Series(qq(2020,1), rand(10000,1));
d.y = Series(qq(2020,1), rand(10000,1));
d.z = Series(qq(2020,1), rand(10000,1));
d.e = Series(qq(2020,1), 0.1*randn(10000,1));

d.a = 1;
d.b = -1;
d.c = 0.5;

d.lhs = d.a*d.x + d.b*d.y + d.c*d.z + d.e;

range = getRange(d.x);
range1 = range(1:5000);
range2 = range(5001:end);
d.lhsw = [ 
    0.5*d.a*d.x{range1} + 0.5*d.b*d.y{range1} + 0.5*d.c*d.z{range1} + d.e{range1}
    d.a*d.x{range2} + d.b*d.y{range2} + d.c*d.z{range2} + d.e{range2}
];

d.w = Series();
d.w(range1) = 1;
d.w(range2) = 3;


%% Test vanilla   

est = regress(d.lhs, [d.x, d.y, d.z]);
assertEqual(testCase, round(est(1), 1), round(d.a, 1));
assertEqual(testCase, round(est(2), 1), round(d.b, 1));
assertEqual(testCase, round(est(3), 1), round(d.c, 1));


%% Test dates   

est = regress(d.lhs, [d.x, d.y, d.z]);
est1 = regress(d.lhs, [d.x, d.y, d.z], 'dates', Inf);
est2 = regress(d.lhs, [d.x, d.y, d.z], 'dates', qq(2020,1)+(0:5000));

assertEqual(testCase, est, est1);
assertNotEqual(testCase, round(est(1), 5), round(est2(1), 5));
assertNotEqual(testCase, round(est(2), 5), round(est2(2), 5));
assertNotEqual(testCase, round(est(3), 5), round(est2(3), 5));


%% Test weights   

estw1 = regress(d.lhsw, [d.x, d.y, d.z]);
estw2 = regress(d.lhsw, [d.x, d.y, d.z], 'weights', d.w);
assertGreaterThan(testCase, abs(estw1(1)-d.a), abs(estw2(1)-d.a));
assertGreaterThan(testCase, abs(estw1(2)-d.b), abs(estw2(2)-d.b));
assertGreaterThan(testCase, abs(estw1(3)-d.c), abs(estw2(3)-d.c));

