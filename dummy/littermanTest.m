
d = struct();

f1 = Armani([1, -0.85], [1, 0.7]);

d.x = 1 + reconstruct(f1, Series(qq(2020,1:40), @randn));
d.y = 2 + reconstruct(f1, Series(qq(2020,1:40), @randn));
d.z = 0 + reconstruct(f1, Series(qq(2020,1:40), @randn));

order = 2;
v = VAR(["x", "y", "z"], "order", order, "intercept", true);

l1 = dummy.Litterman(1, sqrt(40), 0);
l2 = BVAR.litterman(1, sqrt(40), 0);
s2 = BVAR.sumofcoeff(sqrt(40));
s1 = dummy.SumCoeff(sqrt(40));
m1 = dummy.UncMean([-1; 10; 3], sqrt(40));

v0 = estimate(v, d, qq(2020,1:40));
v1 = estimate(v, d, qq(2020,1:40), 'dummy', m1);


