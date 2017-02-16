function Tests = linksTest( )
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
%{
Model>>>>>
!transition_variables
    x, y
!parameters
    rhox, mux, rhoy, muy
    one=1
!transition_shocks
    epsx, epsy
!transition_equations
    x = rhox*x{-1} + (1-rhox)*mux + epsx !! x = mux;
    y = rhoy*y{-1} + (1-rhoy)*muy + epsy !! y = muy;
!measurement_variables
    xx, yy
!measurement_equations
    xx = x;
    yy = y;
!links
    mux := one*muy;
    rhox := one*rhoy;
<<<<<Model
%}
parser.grabTextFromCaller('Model', 'linksTest.model');
m = model('linksTest.model', 'Linear=', true);
m.rhox = 0.50;
m.rhoy = 0.80;
m.mux = -2;
m.muy = 10;
m.std_epsx = 0.01;
m.std_epsy = 0.01;

range = 1 : 500;
rng('default');
rng(1);
d = struct( );
d.xx = m.mux + arf(tseries(0, 0), [1, -m.rhox], tseries(range, @randn)*m.std_epsx, range);
d.yy = m.muy + arf(tseries(0, 0), [1, -m.rhoy], tseries(range, @randn)*m.std_epsy, range);

%{
ModelMu>>>>>
!transition_variables
    x, y
!parameters
    rhox, mu, rhoy
!transition_shocks
    epsx, epsy
!transition_equations
    x = rhox*x{-1} + (1-rhox)*mu + epsx !! x = mu;
    y = rhoy*y{-1} + (1-rhoy)*mu + epsy !! y = mu;
!measurement_variables
    xx, yy
!measurement_equations
    xx = x;
    yy = y;
<<<<<ModelMu
%}
parser.grabTextFromCaller('ModelMu', 'linksTestMu.model');
mmu = model('linksTestMu.model', 'Linear=', true);
mmu.rhox = 0.50;
mmu.rhoy = 0.80;
mmu.mu = 4;
mmu.std_epsx = 0.01;
mmu.std_epsy = 0.01;

%{
ModelStdCorr>>>>>
!transition_variables
    x, y
!parameters
    rhox, mux, rhoy, muy
    one=1
!transition_shocks
    epsx, epsy
!transition_equations
    x = rhox*x{-1} + (1-rhox)*mux + epsx !! x = mux;
    y = rhoy*y{-1} + (1-rhoy)*muy + epsy !! y = muy;
!measurement_variables
    xx, yy
!measurement_equations
    xx = x;
    yy = y;
!links
    std_epsx := std_epsy*2/one;
    corr_epsy__epsx := std_epsy*0.1/one;
<<<<<ModelStdCorr
%}
parser.grabTextFromCaller('ModelStdCorr', 'linksTestStdCorr.model');
msc = model('linksTestStdCorr.model', 'Linear=', true);
msc.rhox = 0.50;
msc.rhoy = 0.80;
m.mux = -2;
m.muy = 10;
msc.std_epsx = 0.01;
msc.std_epsy = 0.01;


this.TestData.Model = m;
this.TestData.ModelMu = mmu;
this.TestData.ModelSc = msc;
this.TestData.Range = range;
this.TestData.InputData = d;
end




function testSolve(this)
m1 = this.TestData.Model;
m1 = solve(m1);
m1 = sstate(m1);
assertEqual(this, real(m1.rhox), real(m1.rhoy));
assertEqual(this, real(m1.mux), real(m1.muy));
assertEqual(this, real(m1.x), real(m1.y));
end




function testSolveLock(this)
m1 = this.TestData.Model;
m1 = disable(m1, '!links', 'mux', 'rhox');
m1 = solve(m1);
m1 = sstate(m1);
assertNotEqual(this, real(m1.rhox), real(m1.rhoy));
assertNotEqual(this, real(m1.mux), real(m1.muy));
assertNotEqual(this, real(m1.x), real(m1.y));

m1 = enable(m1, '!links', 'mux');
m1 = solve(m1);
m1 = sstate(m1);
assertNotEqual(this, real(m1.rhox), real(m1.rhoy));
assertEqual(this, real(m1.mux), real(m1.muy));
assertEqual(this, real(m1.x), real(m1.y));
end




function testEstimate(this)
m0 = this.TestData.Model;
d = this.TestData.InputData;
range = this.TestData.Range;
expStatus = isactive(m0, '!links');
m0 = disable(m0, '!links');
expStatus = structfun(@not, expStatus, 'UniformOutput', false);
actStatus = isactive(m0, '!links');
assertEqual(this, actStatus, expStatus);

m0 = solve(m0);
m0 = sstate(m0);

% Estimate without links.
E0 = struct( );
E0.mux = { NaN };
E0.muy = { NaN };
E0.rhox = { NaN, 0.05, 0.95 };
E0.rhoy = { NaN, 0.05, 0.95 };
oo = {'Display=', 'off'};
est0 = estimate(m0, d, range, E0, ...
    'OptimSet=', oo);
assertEqual(this, round(est0.mux, 1), m0.mux);
assertEqual(this, round(est0.muy, 1), m0.muy);
assertEqual(this, round(est0.rhox, 1), m0.rhox);
assertEqual(this, round(est0.rhoy, 1), m0.rhoy);

% Estimate with mu links enabled.
m1 = assign(m0, est0);
m1 = solve(m1);
m1 = sstate(m1);
m1 = enable(m1, '!links', 'mux');

E1 = struct( );
E1.muy = { NaN };
E1.rhox = { NaN, 0.05, 0.95 };
E1.rhoy = { NaN, 0.05, 0.95 };
est1 = estimate(m1, d, range, E1, ...
    'OptimSet=', oo);
assertEqual(this, round(est1.muy, 1), round((m0.muy+m0.mux)/2, 1));

% Estimate a model with mu explicitly restricted across equations.
m2 = this.TestData.ModelMu;
m2 = solve(m2);
m2 = sstate(m2);
E2 = struct( );
E2.mu = { NaN };
E2.rhox = { NaN, 0.05, 0.95 };
E2.rhoy = { NaN, 0.05, 0.95 };
est2 = estimate(m2, d, range, E2, ...
    'OptimSet=', oo);
assertEqual(this, round(est2.mu, 3), round(est1.muy, 3));
assertEqual(this, round(est2.rhoy, 3), round(est1.rhoy, 3));
assertEqual(this, round(est2.rhox, 3), round(est1.rhox, 3));
end




function testStdCorr(this)
m = this.TestData.ModelSc;
m = alter(m, 3);
m.std_epsy = [10, 20, 100];
m = refresh(m);
assertEqual(this, m.std_epsy, [10, 20, 100]);
assertEqual(this, m.std_epsx, [10, 20, 100]*2);
assertEqual(this, m.corr_epsx__epsy, [10, 20, 100]*0.1);
assertEqual(this, m.corr_epsy__epsx, [10, 20, 100]*0.1);
end

