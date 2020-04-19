
% Set Up 

assertEqual = @(x, y) assert(isequal(x, y));
assertNotEqual = @(x, y) assert(~isequal(x, y));

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
msx = model('linksTestStdCorr.model', 'Linear=', true);
msx.rhox = 0.50;
msx.rhoy = 0.80;
m.mux = -2;
m.muy = 10;
msx.std_epsx = 0.01;
msx.std_epsy = 0.01;


testData.Model = m;
testData.ModelMu = mmu;
testData.ModelSx = msx;
testData.Range = range;
testData.InputData = d;

isOptim = ~isempty(ver('optim'));


%% Test Solve

m1 = testData.Model;
m1 = solve(m1);
m1 = sstate(m1);
assertEqual(real(m1.rhox), real(m1.rhoy));
assertEqual(real(m1.mux), real(m1.muy));
assertEqual(real(m1.x), real(m1.y));




%% Test Solve with Lock

m1 = testData.Model;
m1 = deactivateLink(m1, {'mux', 'rhox'});
m1 = solve(m1);
m1 = sstate(m1);
assertNotEqual(real(m1.rhox), real(m1.rhoy));
assertNotEqual(real(m1.mux), real(m1.muy));
assertNotEqual(real(m1.x), real(m1.y));

m1 = activateLink(m1, 'mux');
m1 = solve(m1);
m1 = sstate(m1);
assertNotEqual(real(m1.rhox), real(m1.rhoy));
assertEqual(real(m1.mux), real(m1.muy));
assertEqual(real(m1.x), real(m1.y));




%% Test Estimate

m0 = testData.Model;
d = testData.InputData;
range = testData.Range;
expStatus = isLinkActive(m0);
m0 = deactivateLink(m0, @all);
expStatus = structfun(@not, expStatus, 'UniformOutput', false);
actStatus = isLinkActive(m0);
assertEqual(actStatus, expStatus);

m0 = solve(m0);
m0 = sstate(m0);

% Estimate without links.
if isOptim
    E0 = struct( );
    E0.mux = { NaN };
    E0.muy = { NaN };
    E0.rhox = { NaN, 0.05, 0.95 };
    E0.rhoy = { NaN, 0.05, 0.95 };
    oo = {'Display=', 'off'};
    est0 = estimate(m0, d, range, E0, ...
        'OptimSet=', oo);
    assertEqual(round(est0.mux, 1), m0.mux);
    assertEqual(round(est0.muy, 1), m0.muy);
    assertEqual(round(est0.rhox, 1), m0.rhox);
    assertEqual(round(est0.rhoy, 1), m0.rhoy);
end

% Estimate with mu links active
if isOptim
    m1 = assign(m0, est0);
    m1 = solve(m1);
    m1 = sstate(m1);
    m1 = activateLink(m1, 'mux');
    E1 = struct( );
    E1.muy = { NaN };
    E1.rhox = { NaN, 0.05, 0.95 };
    E1.rhoy = { NaN, 0.05, 0.95 };
    est1 = estimate(m1, d, range, E1, ...
        'OptimSet=', oo);
    assertEqual(round(est1.muy, 1), round((m0.muy+m0.mux)/2, 1));
end

% Estimate a model with mu explicitly restricted across equations.
if isOptim
    m2 = testData.ModelMu;
    m2 = solve(m2);
    m2 = sstate(m2);
    E2 = struct( );
    E2.mu = { NaN };
    E2.rhox = { NaN, 0.05, 0.95 };
    E2.rhoy = { NaN, 0.05, 0.95 };
    est2 = estimate(m2, d, range, E2, ...
        'OptimSet=', oo);
    assertEqual(round(est2.mu, 3), round(est1.muy, 3));
    assertEqual(round(est2.rhoy, 3), round(est1.rhoy, 3));
    assertEqual(round(est2.rhox, 3), round(est1.rhox, 3));
end


%% Test StdCorr

m = testData.ModelSx;
m = alter(m, 3);
m.std_epsy = [10, 20, 100];
m = refresh(m);
assertEqual(m.std_epsy, [10, 20, 100]);
assertEqual(m.std_epsx, [10, 20, 100]*2);
assertEqual(m.corr_epsx__epsy, [10, 20, 100]*0.1);
assertEqual(m.corr_epsy__epsx, [10, 20, 100]*0.1);

