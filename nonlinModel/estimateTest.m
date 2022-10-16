
% Set Up

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
m0 = Model.fromFile('simple_SPBC.model', 'growth', true) ;

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
m1 = steady(m1);
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
assertEqual(testCase, chksstate(m, 'error', false, 'warning', false), false) ;
assertEqual(testCase, issolved(s), true) ;
assertEqual(testCase, chksstate(s, 'error', false, 'warning', false), true) ;

%}
%% Test estimate

if isOptim
    m = m1;

    E = struct();
    E.chi = {NaN,  0.5,  0.95,  distribution.Normal.fromMeanStd(0.85, 0.025)};
    E.xiw = {NaN,  30,  1000,  distribution.Normal.fromMeanStd(60, 50)};
    E.xip = {NaN,  30,  1000,  distribution.Normal.fromMeanStd(300, 50)};
    E.rhor = {NaN,  0.10,  0.95,  distribution.Beta.fromMeanStd(0.85, 0.05)};
    E.kappap = {NaN,  1.5,  10,  distribution.Normal.fromMeanStd(3.5, 1)};
    E.kappan = {NaN,  0,  1, distribution.Normal.fromMeanStd(0, 0.2)};
    E.std_Ep = {0.01,  0.001,  0.10,  distribution.InvGamma.fromMeanStd(0.01, Inf)};
    E.std_Ew = {0.01,  0.001,  0.10,  distribution.InvGamma.fromMeanStd(0.01, Inf)};
    E.std_Ea = {0.001,  0.0001,  0.01,  distribution.InvGamma.fromMeanStd(0.001, Inf)};
    E.std_Er = {0.005,  0.001,  0.10,  distribution.InvGamma.fromMeanStd(0.005, Inf)};
    E.corr_Er__Ep = {0,  -0.9,  0.9,  distribution.Normal.fromMeanStd(0, 0.5)};

    filteropt = { ...
        'outlik', {'Short_', 'Infl_', 'Growth_', 'Wage_'}, ...
        'relative', true, ...
        };

    [est, pos, C, ~, ~, ~, delta, Pdelta] = ...
        estimate(m, d, starthist:endhist, E, ...
        'filter', filteropt, 'optimset', {'display', 'iter'}, ...
        'tolx', 1e-8, 'tolfun', 1e-8, ...
        ...'evallik', false, ...
        'steady', false, 'solve', true, 'noSolution', 'penalty', ...
        'summary', 'struct', ...
        'checkSteady', false); %also test some default options

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

[~, ~, info1] = kalmanFilter(m, d, starthist:endhist, ...
    'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'});
minusLogLik2 = loglik(m, d, starthist:endhist, ...
    'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

assertEqual(testCase, info1.MinusLogLik, minusLogLik2);


%% Test Fast loglik

m = m1;

chi = 0.7 : 0.01 : 0.9;

m0 = m;
obj0 = [];
for x = chi
    m0.chi = x;
    m0 = solve(m0);
    obj0(end+1) = loglik(m0, d, starthist:endhist, ...
        'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'});   
end


mm = alter(m, length(chi));
mm.chi = chi;
checkSteady(mm);
mm = solve(mm);
obj1 = loglik(mm, d, starthist:endhist, ...
    'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

loglik(m, d, starthist:endhist, ...
    'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'}, ...
    'persist', true);

obj2 = [];
for x = chi
    m.chi = x;
    checkSteady(m);
    m = solve(m);
    obj2(end+1) = loglik(m);
end

assertEqual(testCase, obj1, obj0);
assertEqual(testCase, obj1, obj2);


%% Test loglik Decomposition

m = m1;

obj1 = loglik(m, d, starthist:endhist, ...
    'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

obj2 = loglik(m, d, starthist:endhist, ...
    'outlik', {'Short_', 'Wage_', 'Infl_', 'Growth_'}, ...
    'returnObjFuncContribs', true);

assertEqual(testCase, obj1, sum(obj2), 'AbsTol', 1e-12);

