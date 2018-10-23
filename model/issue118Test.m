
%% Test Simulate Issue 118

m = model('issue118Test.model');
m = sstate(m);
m = solve(m);
d = sstatedb(m, 1:20);
d.x(0) = 5;
s = simulate(m, d, 1:20);

xData = s.x(1:20);
yData = s.y(1:20);
dxData = s.x(1:20)-s.x(0:19);
check.equal(d.x.RangeAsNumeric, (0:20)');
check.equal(d.y.RangeAsNumeric, (1:20)');
check.equal(s.x.RangeAsNumeric, (0:20)');
check.equal(s.y.RangeAsNumeric, (1:20)');
check.absTol(yData, dxData, 1e-12);


