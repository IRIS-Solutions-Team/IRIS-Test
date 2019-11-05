
% Set Up

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model('test.model', 'linear=', true);
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


%% Test Table with Databank

d = zerodb(m, qq(2001,1):qq(2004,4));
t = table(p, d);
assertEqual(this, size(t), [7, 6]);
assertEqual(this, t{:,1}, char({'x', 'y', 'z', 'ex', 'ey', 'ez', 'y'}));

