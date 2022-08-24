
% Set Up Once

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
range = qq(2000, 1):qq(2015, 4);
d = struct();
d.x = hpf2(cumsum(Series(range, @randn)));
d.y = hpf2(cumsum(Series(range, @randn)));
d.z = hpf2(cumsum(Series(range, @randn)));
d.a = hpf2(cumsum(Series(range, @randn)));
d.b = hpf2(cumsum(Series(range, @randn)));
this.TestData.range = range;
this.TestData.d = d;




%% Test Estimate with Intercept

range = this.TestData.range;
nPer = length(range);
d = this.TestData.d;
v = VAR({'x', 'y', 'z'});
[v, vd] = estimate(v, d, range, 'Order', 2, 'Intercept', true);
assertNotEqual(this, v.K, zeros(3, 1));
assertEmpty(this, v.CovParameters);
assertNotEqual(this, v.AIC, v.AICc);




%% Test Estimate with CovParameters

range = this.TestData.range;
nPer = length(range);
d = this.TestData.d;
v = VAR({'x', 'y', 'z'});
[v, vd] = estimate(v, d, range, 'Order', 2, 'CovParameters', true, 'Intercept', false);
assertEqual(this, v.K, zeros(3, 1));
assertNotEmpty(this, v.CovParameters);
assertNotEqual(this, v.AIC, v.AICc);

