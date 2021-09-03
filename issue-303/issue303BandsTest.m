
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d.x = Series(qq(2020,1:10), 1:10);;
d.lower = -Series(qq(2020, 1:10), @rand);
d.upper = Series(qq(2020, 1:10), @rand);

x = report.new('Bands test');

x.figure('Figure');
x.graph('Graph');
x.band('Bands', d.x, d.lower, d.upper);

[file, info] = x.publish('issue303BandsTest.pdf');


