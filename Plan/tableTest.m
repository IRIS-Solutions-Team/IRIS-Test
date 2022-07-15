
% Set Up

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile('test.model', 'linear', true);
m = solve(m);
m = steady(m);

p = Plan.forModel(m, qq(2001,1):qq(2004,4));
p = anticipate(p, false, {'ex', 'x'});
p = swap(p, p.Start+(0:1), {'x', 'ex'});
p = swap(p, p.Start+(2:3), {'x', 'ex'});
p = exogenize(p, p.Start, {'y', 'z'});
p = endogenize(p, p.Start, {'ey', 'ez'});
p = exogenize(p, p.Start+1, {'y'}, 'SwapLink', 2);
p = endogenize(p, p.Start+1, {'ey'});


%% Test Table with Databank

d = databank.forModel(m, qq(2001,1):qq(2004,4), "deviation", true);
t = table(p, d);
assertEqual(this, size(t), [7, 7]);
assertEqual(this, t{:, 1}, ["x"; "y"; "z"; "ex"; "ey"; "ez"; "y"]);
assertEqual(this, t{:, 3}, int16([-1;-1;-1;-1;-1;-1;2]));
