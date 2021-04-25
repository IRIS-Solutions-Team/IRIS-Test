
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model('test_steady_solver.model');
m.sgm = 1;
m.bet = 0.95;
m.alp = 0.5;
m.tau = -1;
m.dlt = 0.20;
m.z = 1;
m0 = steady(m, 'Solver', {'IRIS', 'Display', 'none'});

assertEqualTol = @(x, y) assert(abs(x-y)<1e-8);
assertStrInFile = @(file, c) assert(~isempty(strfind(file2char(file), c)));
assertStrNotInFile = @(file, c) assert(isempty(strfind(file2char(file), c)));


%% IRIS Solver or Optim Tbx Solver with Analytical Gradients
% This is by default. See the flag Analytical displayed under Jacob-Norm
% heading in the solver screen output.

delete test_steady_solver_ia
diary test_steady_solver_ia
m1 = steady(m, 'Solver', 'IRIS');
diary off

assertStrInFile('test_steady_solver_ia', 'Analytical');
assertStrNotInFile('test_steady_solver_ia', 'Forward-Diff');

%% IRIS Solver or Optim Tbx Solver with Numerical Gradients
% Set SpecifyObjectiveGradient=false in solver-specific options; no need to
% adjust option PrepareGradient= as long as it is @auto (default). See the
% falg Numerical displayed under Jacob-Norm.

delete test_steady_solver_in
diary test_steady_solver_in
m2 = steady(m, 'Solver', {'IRIS', 'JacobCalculation', 'ForwardDiff'});
diary off

assertEqualTol(m2.y, m0.y);
assertStrInFile('test_steady_solver_in', 'Forward-Diff');
assertStrNotInFile('test_steady_solver_in', 'Analytical');


%% User-Supplied Solver Expecting Gradients to Be Returned from Objective Function
% Context='Steady' means default for SpecifyObjectiveGradient=true; we need
% to set PrepareGradient=true when calling steady(_) because default is
% PrepareGradient=false for user supplied solvers.

opt = solver.Options( 'IRIS-Qnsd', ...
                      'JacobCalculation', 'Analytical' );
fn = @(fn, x) solver.algorithm.qnsd(fn, x, opt);

delete test_steady_solver_ua
diary test_steady_solver_ua
m3 = steady(m, 'Solver', fn);
diary off

assertEqual(testCase, m3.y, m0.y, 'RelTol', 1e-10);
assertStrInFile('test_steady_solver_ua', 'Analytical');
assertStrNotInFile('test_steady_solver_ua', 'Forward-Diff');


%% User-Supplied Solver Not Expecting Gradients to Be Returned from Objective Function
% Set option PrepareGradient=false. This is not critical though; if not set
% to false, steady state will be computed exactly the same way except
% some more overhead time will be wasted preparing analytical gradients (which are
% not used).

opt = solver.Options( 'IRIS-Qnsd', ...
                      'JacobCalculation', 'ForwardDiff' );

assertEqual(testCase, opt.JacobCalculation, "ForwardDiff");
fn = @(fn, x) solver.algorithm.qnsd(fn, x, opt);

delete test_steady_solver_un
diary test_steady_solver_un
m4 = steady(m, 'Solver', fn);
diary off

assertEqual(testCase, m4.y, m0.y, 'RelTol', 1e-10);
assertStrInFile('test_steady_solver_un', 'Forward-Diff');
assertStrNotInFile('test_steady_solver_un', 'Analytical');


%% Optimization Toolbox LSQNONLIN

m5 = steady(m, 'Solver', 'lsqnonlin');
assertEqual(testCase, m5.y, m0.y, 'RelTol', 1e-10);


%% Optimization Toolbox FSOLVE

m6 = steady(m, 'Solver', 'fsolve');
assertEqual(testCase, m6.y, m0.y, 'RelTol', 1e-10);


%% Optimization Toolbox FSOLVE with optimoptions

oo = optimoptions("fsolve", "SpecifyObjectiveGradient", true, "Display", "iter");
m7 = steady(m, 'solver', oo);
assertEqual(testCase, m7.y, m0.y, 'RelTol', 1e-10);

