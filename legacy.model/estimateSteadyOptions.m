
% Set up once

m = model('estimateSteadyOptions.model');
m.a = 1;
m.b = 2;
m.c = 0.5;
m.d = 1.5;

m = sstate(m);
m = solve(m);

rng(0);
range = 1:80;
ex = Series(range, @randn);
ey = Series(range, @randn);
ez = Series(range, @randn);

d = struct( );
d.obs_x = m.a * exp(ex);
d.obs_y = m.b * exp(ey);
d.obs_z = d.obs_x^m.c * d.obs_y^m.d * exp(ez);

est = struct( );
est.a = {0.5, 0.1, 3};
est.b = {0.5, 0.1, 3};
est.c = {0.5, 0.1, 2};
est.d = {0.5, 0.1, 2};


%% Test Estimation with Steady State

steadySolverOptions = { 'lsqnonlin'
                        'tolX'; 1e-16
                        'tolFun'; 1e-16
                        'MaxFunEvals'; 1e5
                        'MaxIter'; 1e5
                        'Display'; 'Off' };

steadyOptions = { 'Growth'; false
                  'Blocks'; true
                  'Solver'; steadySolverOptions };

p0 = estimate(m, d, range, est, 'Steady', true);
p1 = estimate(m, d, range, est, 'Steady', steadyOptions);

check.absTol(p0, p1, 1e-6)
check.absTol(p0.a, 1.16, 1e-2)
check.absTol(p0.b, 1.84, 1e-2)
check.absTol(p0.c, 0.46, 1e-2)
check.absTol(p0.d, 1.44, 1e-2)


%% Test Estimation with Failed Steady State

steadySolverOptions = { 'lsqnonlin'
                        'tolX'; 1e-16
                        'tolFun'; 1
                        'MaxFunEvals'; 1
                        'MaxIter'; 1e5
                        'Display'; 'Off' };

steadyOptions = { 'Growth'; false
                  'Blocks'; true
                  'Solver'; steadySolverOptions };

p2 = estimate(m, d, range, est, 'Steady', steadyOptions, 'NoSolution', 'Penalty');

check.absTol(p2.a, 0.50, 1e-2)
check.absTol(p2.b, 0.50, 1e-2)
check.absTol(p2.c, 0.50, 1e-2)
check.absTol(p2.d, 0.50, 1e-2)

errorID = '';
try
    p3 = estimate(m, d, range, est, 'Steady', steadyOptions, 'NoSolution', 'Error');
catch err
    errorID = err.identifier;
end

check.equal(errorID, 'IrisToolbox:Model:Failed')

