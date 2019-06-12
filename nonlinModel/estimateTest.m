
% Set Up

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
m0 = model('simple_SPBC.model') ;

m0.alpha = 1.03^(1/4);
m0.beta = 0.985^(1/4);
m0.gamma = 0.60;
m0.delta = 0.03;
m0.pi = 1.025^(1/4);
m0.eta = 6;
m0.k = 10;
m0.psi = 0.25;
m0.chi = 0.85;
m0.xiw = 60;
m0.xip = 300;
m0.rhoa = 0.90;
m0.rhor = 0.85;
m0.kappap = 3.5;
m0.kappan = 0;
m0.Short_ = 0;
m0.Infl_ = 0;
m0.Growth_ = 0;
m0.Wage_ = 0;
m0.std_Mp = 0;
m0.std_Mw = 0;
m0.std_Ea = 0.001;

m1 = m0;
m1 = sstate(m1, 'growth=', true, 'blocks=', true, 'display=', 'off');
m1 = solve(m1);

load nonlinModelData.mat d starthist endhist;
starthist = DateWrapper(starthist);
endhist = DateWrapper(endhist);

isOptim = ~isempty(ver('optim'));

%% Test get

m = m0;

actual = get(m, 'exList') ;
expected = {'Ey', 'Ep', 'Ea', 'Er', 'Ew'} ;
assertEqual(testCase, actual, expected) ;

actual = get(m, 'yList');
expected = {'Short', 'Infl', 'Growth', 'Wage'} ;
assertEqual(testCase, actual, expected) ;

actual = get(m, 'eyList');
expected = {'Mp', 'Mw'};
assertEqual(testCase, actual, expected) ;

actual = get(m, 'pList') ;
expected = {'alpha', 'beta', 'gamma', 'delta', 'k', 'pi', 'eta', 'psi', ...
    'chi', 'xiw', 'xip', 'rhoa', 'rhor', 'kappap', 'kappan', 'Short_', ...
    'Infl_', 'Growth_', 'Wage_'} ;
assertEqual(testCase, actual, expected) ;

actual = get(m, 'stdList') ;
expected = { 'std_Mp', 'std_Mw', 'std_Ey', 'std_Ep', 'std_Ea', 'std_Er', ...
             'std_Ew' } ;
assertEqual(testCase, actual, expected) ;


%% Test isname

m = m0;
assertEqual(testCase, isname(m, 'alpha'), true) ;
assertEqual(testCase, isname(m, 'alph'), false) ;


%% Test isnan 

m = m0;
assertEqual(testCase, isnan(m), true) ;


%% Test issolved

m = m0;
s = m1;
assertEqual(testCase, issolved(model( )), logical.empty(1, 0));
assertEqual(testCase, issolved(m), false) ;
assertEqual(testCase, issolved(s), true) ;


%% Test alter

m = m0;
assertEqual(testCase, length(alter(m, 3)), 3) ;
assertEqual(testCase, length(m([1, 1, 1])), 3) ;


%% Test chksstate

m = m0;
s = m1;
assertEqual(testCase, issolved(model( )), logical.empty(1, 0)) ;
assertEqual(testCase, issolved(m), false) ;
assertEqual(testCase, chksstate(m, 'error=', false, 'warning=', false), false) ;
assertEqual(testCase, issolved(s), true) ;
assertEqual(testCase, chksstate(s, 'error=', false, 'warning=', false), true) ;

%}
%% Test estimate

if isOptim
    m = m1;

    E = struct();
    E.chi = {NaN,  0.5,  0.95,  logdist.normal(0.85, 0.025)};
    E.xiw = {NaN,  30,  1000,  logdist.normal(60, 50)};
    E.xip = {NaN,  30,  1000,  logdist.normal(300, 50)};
    E.rhor = {NaN,  0.10,  0.95,  logdist.beta(0.85, 0.05)};
    E.kappap = {NaN,  1.5,  10,  logdist.normal(3.5, 1)};
    E.kappan = {NaN,  0,  1, logdist.normal(0, 0.2)};
    E.std_Ep = {0.01,  0.001,  0.10,  logdist.invgamma(0.01, Inf)};
    E.std_Ew = {0.01,  0.001,  0.10,  logdist.invgamma(0.01, Inf)};
    E.std_Ea = {0.001,  0.0001,  0.01,  logdist.invgamma(0.001, Inf)};
    E.std_Er = {0.005,  0.001,  0.10,  logdist.invgamma(0.005, Inf)};
    E.corr_Er__Ep = {0,  -0.9,  0.9,  logdist.normal(0, 0.5)};

    filteropt = { ...
        'outoflik=', {'Short_', 'Infl_', 'Growth_', 'Wage_'}, ...
        'relative=', true, ...
        };

    [est, pos, C, ~, ~, ~, delta, Pdelta] = ...
        estimate(m, d, starthist:endhist, E, ...
        'filter=', filteropt, 'optimset=', {'display=', 'off'}, ...
        'tolx=', 1e-8, 'tolfun=', 1e-8, ...
        ...'evallik=', false, ...
        'sstate=', false, 'solve=', true, 'nosolution=', 'penalty', ...
        'chksstate=', false); %also test some default options

    cmp = load('nonlinModelEstimation.mat') ;
    pNames = fields(est) ;
    for iName = 1 : numel(pNames)
        actual = est.(pNames{iName}) ;
        expected = cmp.est.(pNames{iName}) ;
        assertEqual(testCase, actual, expected, 'RelTol', 1e-3) ;
    end

    fNames = fields(cmp.delta) ;
    for ii = 1 : numel(fNames)
        actual = delta.(fNames{ii}) ;
        expected = cmp.delta.(fNames{ii}) ;
        assertEqual(testCase, actual, expected, 'RelTol', 1e-2) ;
    end
    assertEqual(testCase, double(Pdelta), double(cmp.Pdelta), 'RelTol', 1e-3) ;
end

%% Test loglik

m = m1;

[~, ~, V1, Delta1, Pe1] = filter(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});
[~, V2, ~, Pe2, Delta2] = loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

assertEqual(testCase, V1, V2);
assertEqual(testCase, Delta1, Delta2);
assertEqual(testCase, Pe1, Pe2);


%% Test Fast loglik

m = m1;

chi = 0.7 : 0.01 : 0.9;
mm = alter(m, length(chi));
mm.chi = chi;
chksstate(mm);
mm = solve(mm);
obj1 = loglik(mm, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

obj2 = nan(size(chi));
loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'}, ...
    'persist=', true);
for i = 1 : length(chi)
    m.chi = chi(i);
    chksstate(m);
    m = solve(m);
    obj2(i) = loglik(m);
end

assertEqual(testCase, obj1, obj2);


%% Test loglik Decomposition

m = m1;

obj1 = loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

obj2 = loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'}, ...
    'objDecomp=', true);

assertEqual(testCase, obj1, obj2(1), 'AbsTol', 1e-12);
assertEqual(testCase, obj2(1), sum(obj2(2:end)), 'AbsTol', 1e-12);

