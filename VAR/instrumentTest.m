
% Set Up Once

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
range = qq(2000, 1):qq(2015, 4);
d = struct();
d.x = hpf2(cumsum(Series(range, @randn)));
d.y = hpf2(cumsum(Series(range, @randn)));
d.z = hpf2(cumsum(Series(range, @randn)));
d.a = hpf2(cumsum(Series(range, @randn)));
d.b = hpf2(cumsum(Series(range, @randn)));
d = databank.merge("horzcat", d, d);
v = VAR(["x", "y", "z"], "order", 2);
v = addInstrument(v, "xy", "x+y");

v = estimate(v, d, range);
this.TestData.range = range;
this.TestData.d = d;
this.TestData.VAR = v;


%% Test Vanilla

v = this.TestData.VAR;
d = this.TestData.d;
range = this.TestData.range;
filterRange = range(end)+(1:5);

d0 = d;
f0 = kalmanFilter(v, d0, filterRange, 'MeanOnly', true);


d1 = d;
d1.xy = f0.x + f0.y + 1;
f1 = kalmanFilter(v, d1, filterRange, 'MeanOnly', true);

