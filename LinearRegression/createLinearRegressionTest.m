
% Set Up Once
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Create LinearRegression

g = LinearRegression( );
g.LhsNames = "a";
g.RhsNames = ["y", "z"];
g.Intercept = true;

g = defineDependent(g, "a", "Transform=", "diff");

g = addExplanatory(g, "a", "Shift=", -3);
g = addExplanatory(g, "y", "Shift=", -1);
g = addExplanatory(g, "y", "Shift=", +2, "Transform", "log");
g = addExplanatory(g, "z", "Transform=", "log", "Fixed=", 0.1);
g = addExplanatory(g, "z", "Shift=", -2, "Transform=", "difflog");
g = addExplanatory(g, "a", "Transform", "diff", 'Shift=', -1);
g = addExplanatory(g, "(1-y{+3})*(1+z{-2})");

g.LhsNames = "x";

rng(0);
numPages = 1;
d = struct( );
d.x = Series(qq(2001,1), rand(40, numPages));
d.y = Series(qq(2001,1), rand(40, numPages));
d.z = Series(qq(2001,1), rand(40, numPages));
%d.y(qq(2002,3), 2:3) = NaN;

estRange = qq(2002,1):qq(2007,4);
[g, e] = estimate(g, d, estRange, 'MissingObservations=', 'Error');

d3 = d & d & d;
d3.x(qq(2002,[2,4:6,9:11]), 1) = NaN;
d3.y(qq(2002,[3:4,15:16]), [1,2]) = NaN;

[ep, ey, ex, ee, einx] = createModelData(g, d, estRange);

pp = d.x;
XX = [ pp{-3}, d.y{-1}, log(d.y{+2}), log(d.z), diff(log(d.z{-2})), diff(pp{-1}) , (1-d.y{+3})*(1+d.z{-2})   1];

range = estRange;
s = simulate(g, e, range);
s0 = simulate(g, d, range);
ss = simulate(g, e, range, 'Dynamic=', false);
ec = e;
ec.x = clip(ec.x, -Inf, range(1)-1);
sc = simulate(g, ec, range);

plain = d.x;
plain0 = d.x;
plainS = d.x;
beta = g.Parameters;
Xs = [ plain{-3}, d.y{-1}, log(d.y{+2}), log(d.z), diff(log(d.z{-2})), diff(plain{-1}) , (1-d.y{+3})*(1+d.z{-2}),  1];
for t = range
    X = [ plain{-3}, d.y{-1}, log(d.y{+2}), log(d.z), diff(log(d.z{-2})), diff(plain{-1}) , (1-d.y{+3})*(1+d.z{-2}),  1];
    X0 = [ plain0{-3}, d.y{-1}, log(d.y{+2}), log(d.z), diff(log(d.z{-2})), diff(plain0{-1}) , (1-d.y{+3})*(1+d.z{-2}) ,  1];
    %X = [ plain{-3}, d.y{-1}, log(d.y{+2}), log(d.z), diff(log(d.z{-2})), diff(log(plain{-1})) ,  (1-d.y{+3})*(1+d.z{-2}), 1];
    %X0 = [ plain0{-3}, d.y{-1}, log(d.y{+2}), log(d.z), diff(log(d.z{-2})), diff(log(plain0{-1})) ,  (1-d.y{+3})*(1+d.z{-2}), 1];
    explan = transpose(X(t, :));
    explan0 = transpose(X0(t, :));
    explanS = transpose(Xs(t, :));
    depend = beta*explan + e.res_x(t);
    depend0 = beta*explan0;
    dependS = beta*explanS + e.res_x(t);
    plain(t) = plain(t-1) + depend;
    plain0(t) = plain0(t-1) + depend0;
    plainS(t) = plainS(t-1) + dependS;
end

g2 = defineNamesInDatabank(g, struct('x', 'XX', 'y', 'Y_0'));
e2 = struct( );
e2.XX = e.x;
e2.Y_0 = e.y;
e2.y = e.y;
e2.z = e.z;
e2.res_XX = e.res_x;
e2.fit_XX = e.fit_x;

s2 = simulate(g2, e2, range);

