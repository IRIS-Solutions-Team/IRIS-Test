
m = model('evalTest.model', 'Linear=', true);

% Define System Priors

s = systempriors(m);
s = prior(s, 'max(.a, .b)', [ ], 'Lower=', 0, 'Upper=', 1);
s = prior(s, 'corr[x,y,0]', logdist.normal(0.5, 0.1));
s = prior(s, '.x', logdist.normal(0, 0.2));

m = solve(m);
m = sstate(m);

[p, c, x] = eval(s, m);

