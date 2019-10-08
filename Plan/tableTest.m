
% Set Up

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model('tableTest.model', 'linear=', true);
m = solve(m);
m = steady(m);

p = Plan.forModel(m, qq(2001,1):qq(2004,4));
p = anticipate(p, false, {'ex', 'x'});
p = swap(p, p.Start+(0:1), {'x', 'ex'});
p = swap(p, p.Start+(2:3), {'x', 'ex'});
p = exogenize(p, p.Start, {'y', 'z'});
p = endogenize(p, p.Start, {'ey', 'ez'});
p = exogenize(p, p.Start+1, {'y'}, 'SwapId', 2);
p = endogenize(p, p.Start+1, {'ey'});

d = zerodb(m, qq(2001,1):qq(2004,4));
table(p, d)

