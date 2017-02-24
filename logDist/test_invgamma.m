
assertEqualTol = @(x, y) assert(abs(x/y-1)<1e-8);

%% Test Regular Case

m = 1;
s = 0.2;
f = logdist.invgamma(m, s);
a = f([ ], 'a');
b = f([ ], 'b');

f1 = logdist.invgamma(NaN, NaN, a, b);
m1 = f1([ ], 'mean');
s1 = f1([ ], 'std');

assertEqualTol(m, m1);
assertEqualTol(s, s1);
