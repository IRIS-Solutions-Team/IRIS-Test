function Tests = exogenizeTest()
Tests = functiontests(localfunctions) ;
end




function setupOnce(this) %#ok<*DEFNU>
rng(0);
m = model('credibility.model');
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
m = sstate(m,'display','none','blocks',true,'growth',true);
chksstate(m);
m = solve(m);
this.TestData.Model = m;

m = model({'credibility.model', 'credibility_dtrends.model'});
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
m = sstate(m,'display','none','blocks',true,'growth',true);
chksstate(m);
m = solve(m);
this.TestData.ModelDtrends = m;

nonlinOpt = {'method','selective','tolerance',1e-10, ...
    'maxIter',1000,'display',0};
this.TestData.NonlinOpt = nonlinOpt;
end




function testResimulate(this)
m = this.TestData.Model;
nonlinOpt = this.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(5:6);
endgDates = startDate+(15:16);
p = plan(m,range);
p = exogenize(p,exgDates,'y');
p = endogenize(p,endgDates,'ey');
d = sstatedb(m,range);
d.y(exgDates) = d.y(exgDates)+rand(length(exgDates),1)/10;

s1 = simulate(m,d,range,'plan',p,nonlinOpt{:});
s2 = simulate(m,s1,range,nonlinOpt{:});
x1 = lhsmrhs(m,s1,range(5:end));
x2 = lhsmrhs(m,s2,range(5:end));

assertEqual(this,s1.y(exgDates),d.y(exgDates),'AbsTol',1e-14);
assertEqual(this,s1.y(:),s2.y(:),'AbsTol',1e-8);
assertLessThan(this,maxabs(x1),1e-10);
assertLessThan(this,maxabs(x2),1e-10);
end 




function testTransitionVsMeasurement(this)
m = this.TestData.Model;
nonlinOpt = this.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(5:6);
endgDates = startDate+(15:16);

p1 = plan(m,range);
p1 = exogenize(p1,exgDates,'y');
p1 = endogenize(p1,endgDates,'ey');
d1 = sstatedb(m,range);
d1.y(exgDates) = d1.y(exgDates)+rand(length(exgDates),1)/10;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:});

p2 = plan(m,range);
p2 = exogenize(p2,exgDates,'Y');
p2 = endogenize(p2,endgDates,'ey');
d2 = sstatedb(m,range);
d2.Y(exgDates) = d1.y(exgDates);
s2 = simulate(m,d2,range,'plan',p2,nonlinOpt{:});

assertEqual(this,s1.y(exgDates),d1.y(exgDates),'AbsTol',1e-14);
assertEqual(this,s2.Y(exgDates),d2.Y(exgDates),'AbsTol',1e-14);
assertEqual(this,s1.y(:),s2.y(:),'AbsTol',1e-8);
end 




function testLongEndg(this)
m = this.TestData.Model;
nonlinOpt = this.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(5:6);
endgDates = startDate+(15:16);

N = 10;
p1 = plan(m,range);
p1 = exogenize(p1,exgDates,'y');
p1 = endogenize(p1,endgDates,'ey');
d1 = sstatedb(m,range);
d1.y(exgDates) = d1.y(exgDates)+rand(length(exgDates),1)/10;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:},'nonlinPer',N);
x1 = lhsmrhs(m,s1,range(5:N));

assertEqual(this,s1.y(exgDates),d1.y(exgDates),'AbsTol',1e-14);
assertLessThan(this,maxabs(x1),1e-10);
end




function testLongExg(this)
m = this.TestData.Model;
nonlinOpt = this.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

exgDates = startDate+(15:16);
endgDates = startDate+(5:6);

N = 10;
p1 = plan(m,range);
p1 = exogenize(p1,exgDates,'y');
p1 = endogenize(p1,endgDates,'ey');
d1 = sstatedb(m,range);
d1.y(exgDates) = d1.y(exgDates)+rand(length(exgDates),1)/10;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:},'nonlinPer',N);
x1 = lhsmrhs(m,s1,range(5:N));

assertEqual(this,s1.y(exgDates),d1.y(exgDates),'AbsTol',1e-14);
assertLessThan(this,maxabs(x1),1e-10);
end 




function testDeviation(this)
m = this.TestData.Model;
nonlinOpt = this.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;
range = range(1:6);

exgDates = startDate+(0:4);
endgDates = startDate+(0:4);

x = rand(length(exgDates),1)/10;

p1 = plan(m,range);
p1 = exogenize(p1,exgDates,'p');
p1 = endogenize(p1,endgDates,'epi');
d1 = sstatedb(m,range);
d1.p(exgDates) = d1.p(exgDates) + x;
s1 = simulate(m,d1,range,'plan',p1,nonlinOpt{:},'anticipate',false);

assertEqual(this,s1.p(exgDates),d1.p(exgDates),'AbsTol',1e-13);

p2 = p1;
d2 = zerodb(m,range);
d2.p(exgDates) = d2.p(exgDates) + x;
s2 = simulate(m,d2,range,'plan',p2,nonlinOpt{:}, ...
    'anticipate',false,'deviation',true);

assertEqual(this,s2.p(exgDates),d2.p(exgDates),'AbsTol',1e-13);
assertEqual(this,s1.epi(:),s2.epi(:),'AbsTol',1e-13);
end




function testResimulateDtrends(this)
m = this.TestData.ModelDtrends;
nonlinOpt = this.TestData.NonlinOpt;
startDate = qq(2000,1);
endDate = startDate+19;
range = startDate : endDate;

dd0 = get(m, 'sstateLevel+dtLevel');
m.A = 1;
m.B = 2;
dd = get(m, 'sstateLevel+dtLevel');
assertEqual(this, dd.R, dd0.R+m.A+m.B);
assertEqual(this, dd.PI, dd0.PI+m.B);

exgDates = startDate+(5:6);
endgDates = startDate+(5:6);
p = plan(m,range);
p = exogenize(p,exgDates,'R, PI');
p = endogenize(p,endgDates,'er, epi');
d = sstatedb(m,range);
d.R(exgDates) = d.R(exgDates)+rand(length(exgDates),1)*0.1;
d.PI(exgDates) = d.PI(exgDates)+rand(length(exgDates),1)*0.1;

s1 = simulate(m,d,range,'plan',p,nonlinOpt{:});
s2 = simulate(m,s1,range,nonlinOpt{:});
x1 = lhsmrhs(m,s1,range(5:end));
x2 = lhsmrhs(m,s2,range(5:end));

assertEqual(this,s1.R(exgDates),d.R(exgDates),'AbsTol',1e-8);
assertEqual(this,s1.PI(exgDates),d.PI(exgDates),'AbsTol',1e-8);
assertEqual(this,s1.R(:),s2.R(:),'AbsTol',1e-8);
assertEqual(this,s1.PI(:),s2.PI(:),'AbsTol',1e-8);
assertEqual(this,s1.pi(range)+m.B,s2.PI(range),'AbsTol',1e-8);
assertEqual(this,s1.r(range)+m.A+m.B,s2.R(range),'AbsTol',1e-8);
assertLessThan(this,maxabs(x1(2,:)+m.B),1e-10);
assertLessThan(this,maxabs(x2(2,:)+m.B),1e-10);
assertLessThan(this,maxabs(x1(3,:)+m.A+m.B),1e-10);
assertLessThan(this,maxabs(x2(3,:)+m.A+m.B),1e-10);
end 
