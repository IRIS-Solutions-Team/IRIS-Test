

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

rng(0);

m = Model.fromFile( ...
    "credibility.model" ...
    , "growth", true ...
);

m.alp = 0.5;
m.sgm = 0.1;
m.bet = 0.99;
m.gam = 0.05;
m.del = 0.4;
m.the = 0.80;
m.kap = 4;
m.phi = 0;
m.tau = 3;
m.rho = 2;
m.psi = 0.9;
m.omg = 1;
m = steady(m);
checkSteady(m);
m = solve(m);
testCase.TestData.Model = m;

m = Model.fromFile( ...
    ["credibility.model", "credibility-measurement-trends.model"] ...
    , "growth", true ...
);

m.alp = 0.5;
m.sgm = 0.1;
m.bet = 0.99;
m.gam = 0.05;
m.del = 0.4;
m.the = 0.80;
m.kap = 4;
m.phi = 0;
m.tau = 3;
m.rho = 2;
m.psi = 0.9;
m.omg = 1;
m.A = 0;
m.B = 0;
m = steady(m);
checkSteady(m);
m = solve(m);
testCase.TestData.ModelDtrends = m;

nonlinOpt = { 
    'method','stacked', 'solver', ...
        {@auto, 'functionTolerance',1e-10, ...
        'maxIterations',1000}
};
testCase.TestData.NonlinOpt = nonlinOpt;




%% Test resimulate

m = testCase.TestData.Model;
nonlinOpt = testCase.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(5:6);
endgDates = startDate+(15:16);
p = Plan.forModel(m,range);
p = exogenize(p,exgDates,'y');
p = endogenize(p,endgDates,'ey');
d = steadydb(m,range);
d.y(exgDates) = d.y(exgDates)+rand(numel(exgDates),1)/10;

s1 = simulate(m,d,range,'plan',p, nonlinOpt{:});
s2 = simulate(m,s1,range,nonlinOpt{:});
x1 = lhsmrhs(m,s1,range(5:end));
x2 = lhsmrhs(m,s2,range(5:end));

assertEqual(testCase,s1.y(exgDates),d.y(exgDates),'AbsTol',1e-14);
assertEqual(testCase,s1.y(:),s2.y(:),'AbsTol',1e-8);
assertLessThan(testCase,maxabs(x1),1e-10);
assertLessThan(testCase,maxabs(x2),1e-10);




%% Test transition vs measurement

m = testCase.TestData.Model;
nonlinOpt = testCase.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(5:6);
endgDates = startDate+(15:16);

p1 = Plan.forModel(m,range);
p1 = exogenize(p1,exgDates,'y');
p1 = endogenize(p1,endgDates,'ey');
d1 = steadydb(m,range);
d1.y(exgDates) = d1.y(exgDates)+rand(length(exgDates),1)/10;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:});

p2 = Plan.forModel(m,range);
p2 = exogenize(p2,exgDates,'Y');
p2 = endogenize(p2,endgDates,'ey');
d2 = steadydb(m,range);
d2.Y(exgDates) = d1.y(exgDates);
s2 = simulate(m,d2,range,'plan',p2,nonlinOpt{:});

assertEqual(testCase,s1.y(exgDates),d1.y(exgDates),'AbsTol',1e-14);
assertEqual(testCase,s2.Y(exgDates),d2.Y(exgDates),'AbsTol',1e-14);
assertEqual(testCase,s1.y(:),s2.y(:),'AbsTol',1e-8);




%% Test long endog

m = testCase.TestData.Model;
nonlinOpt = testCase.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(5:6);
endgDates = startDate+(15:16);

N = 10;
p1 = Plan.forModel(m,range);
p1 = exogenize(p1,exgDates,'y');
p1 = endogenize(p1,endgDates,'ey');
d1 = steadydb(m,range);
d1.y(exgDates) = d1.y(exgDates)+rand(length(exgDates),1)/10;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:});
x1 = lhsmrhs(m,s1,range(5:N));

assertEqual(testCase,s1.y(exgDates),d1.y(exgDates),'AbsTol',1e-14);
assertLessThan(testCase,maxabs(x1),1e-10);




%% Test long exog

m = testCase.TestData.Model;
nonlinOpt = testCase.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(15:16);
endgDates = startDate+(5:6);

N = 10;
p1 = Plan.forModel(m,range);
p1 = exogenize(p1,exgDates,'y');
p1 = endogenize(p1,endgDates,'ey');
d1 = steadydb(m,range);
d1.y(exgDates) = d1.y(exgDates)+rand(length(exgDates),1)/10;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:});
x1 = lhsmrhs(m,s1,range(5:N));

assertEqual(testCase,s1.y(exgDates),d1.y(exgDates),'AbsTol',1e-14);
assertLessThan(testCase,maxabs(x1),1e-10);




%% Test deviation

m = testCase.TestData.Model;
nonlinOpt = testCase.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;
range = range(1:6);

exgDates = startDate+(0:4);
endgDates = startDate+(0:4);

x = rand(length(exgDates),1)/10;

p1 = Plan.forModel(m,range);
p1 = exogenize(p1,exgDates,'p');
p1 = endogenize(p1,endgDates,'epi');
d1 = steadydb(m,range);
d1.p(exgDates) = d1.p(exgDates) + x;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:});

assertEqual(testCase,s1.p(exgDates),d1.p(exgDates),'AbsTol',1e-13);

p2 = Plan.forModel(m,range);
p2 = exogenize(p2,exgDates,'p');
p2 = endogenize(p2,endgDates,'epi');
d2 = zerodb(m,range);
d2.p(exgDates) = d2.p(exgDates) + x;
s2 = simulate(m,d2,range,'plan',p2,nonlinOpt{:},'deviation',true);
assertEqual(testCase,s2.p(exgDates),d2.p(exgDates),'AbsTol',1e-13);


%% Test resimulate trends

m = testCase.TestData.ModelDtrends;
nonlinOpt = testCase.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

dd0 = get(m, 'sstateLevel+dtLevel');
m.A = 1;
m.B = 2;
m = solve(m);
m = steady(m);

dd = get(m, 'sstateLevel+dtLevel');
assertEqual(testCase, dd.R, dd0.R+m.A+m.B);
assertEqual(testCase, dd.PI, dd0.PI+m.B);

exgDates = startDate+(5:6);
endgDates = startDate+(5:6);
p = Plan.forModel(m,range);
p = exogenize(p,exgDates,["R", "PI"]);
p = endogenize(p,endgDates,["er", "epi"]);
d = steadydb(m,range);
d.R(exgDates) = d.R(exgDates)+rand(length(exgDates),1)*0.1;
d.PI(exgDates) = d.PI(exgDates)+rand(length(exgDates),1)*0.1;

s1 = simulate(m,d,range,'plan',p,nonlinOpt{:});
s2 = simulate(m,s1,range,nonlinOpt{:});
x1 = lhsmrhs(m,s1,range(5:end));
x2 = lhsmrhs(m,s2,range(5:end));

assertEqual(testCase,s1.R(exgDates),d.R(exgDates),'AbsTol',1e-8);
assertEqual(testCase,s1.PI(exgDates),d.PI(exgDates),'AbsTol',1e-8);
assertEqual(testCase,s1.R(:),s2.R(:),'AbsTol',1e-8);
assertEqual(testCase,s1.PI(:),s2.PI(:),'AbsTol',1e-8);
assertEqual(testCase,s1.pi(range)+m.B,s2.PI(range),'AbsTol',1e-8);
assertEqual(testCase,s1.r(range)+m.A+m.B,s2.R(range),'AbsTol',1e-8);
assertLessThan(testCase,maxabs(x1(2,:)+m.B),1e-10);
assertLessThan(testCase,maxabs(x2(2,:)+m.B),1e-10);
assertLessThan(testCase,maxabs(x1(3,:)+m.A+m.B),1e-10);
assertLessThan(testCase,maxabs(x2(3,:)+m.A+m.B),1e-10);

