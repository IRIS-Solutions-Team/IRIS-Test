
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

%% Test get

m = m0;

actual = get(m, 'exList') ;
expected = {'Ey', 'Ep', 'Ea', 'Er', 'Ew'} ;
Assert.equal(actual, expected) ;

actual = get(m, 'yList');
expected = {'Short', 'Infl', 'Growth', 'Wage'} ;
Assert.equal(actual, expected) ;

actual = get(m, 'eyList');
expected = {'Mp', 'Mw'};
Assert.equal(actual, expected) ;

actual = get(m, 'pList') ;
expected = {'alpha', 'beta', 'gamma', 'delta', 'k', 'pi', 'eta', 'psi', ...
    'chi', 'xiw', 'xip', 'rhoa', 'rhor', 'kappap', 'kappan', 'Short_', ...
    'Infl_', 'Growth_', 'Wage_'} ;
Assert.equal(actual, expected) ;

actual = get(m, 'stdList') ;
expected = {'std_Mp', 'std_Mw', 'std_Ey', 'std_Ep', 'std_Ea', 'std_Er', ...
    'std_Ew'} ;
Assert.equal(actual, expected) ;

%% Test isname

m = m0;
Assert.equal(isname(m, 'alpha'), true) ;
Assert.equal(isname(m, 'alph'), false) ;


%% Test isnan 

m = m0;
Assert.equal(isnan(m), true) ;


%% Test issolved

m = m0;
s = m1;
Assert.equal(issolved(model( )), logical.empty(1, 0));
Assert.equal(issolved(m), false) ;
Assert.equal(issolved(s), true) ;


%% Test alter

m = m0;
Assert.equal(length(alter(m, 3)), 3) ;
Assert.equal(length(m([1, 1, 1])), 3) ;


%% Test chksstate

m = m0;
s = m1;
Assert.equal(issolved(model( )), logical.empty(1, 0)) ;
Assert.equal(issolved(m), false) ;
Assert.equal(chksstate(m, 'error=', false, 'warning=', false), false) ;
Assert.equal(issolved(s), true) ;
Assert.equal(chksstate(s, 'error=', false, 'warning=', false), true) ;

%}
%% Test estimate

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
    Assert.relTol(actual, expected, 1e-3) ;
end

fNames = fields(cmp.delta) ;
for ii = 1 : numel(fNames)
    actual = delta.(fNames{ii}) ;
    expected = cmp.delta.(fNames{ii}) ;
    Assert.relTol(actual, expected, 1e-2) ;
end
Assert.relTol(double(Pdelta), double(cmp.Pdelta), 1e-3) ;

%% Test loglik

m = m1;

[~, ~, V1, Delta1, Pe1] = filter(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});
[~, V2, ~, Pe2, Delta2] = loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

Assert.equal(V1, V2);
Assert.equal(Delta1, Delta2);
Assert.equal(Pe1, Pe2);


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

Assert.equal(obj1, obj2);


%% Test loglik Decomposition

m = m1;

obj1 = loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'});

obj2 = loglik(m, d, starthist:endhist, ...
    'outOfLik=', {'Short_', 'Wage_', 'Infl_', 'Growth_'}, ...
    'objDecomp=', true);

Assert.absTol(obj1, obj2(1), 1e-12);
Assert.absTol(obj2(1), sum(obj2(2:end)), 1e-12);
