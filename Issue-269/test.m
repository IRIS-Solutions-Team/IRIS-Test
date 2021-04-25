

close all
clear

m = model('simple_SPBC.model', 'Growth', true);

m.alpha = 1.03^(1/4);
m.beta = 0.985^(1/4);
m.gamma = 0.60;
m.delta = 0.03;
m.pi = 1.025^(1/4);
m.eta = 6;
m.k = 10;
m.psi = 0.25;

m.chi = 0.85;
m.xiw = 60;
m.xip = 300;
m.rhoa = 0.90;
m.rhoterm20 = 0.80;

m.rhor = 0.85;
m.kappap = 3.5;
m.kappan = 0;

m.Short_ = 0;
m.Long_ = 0;
m.Infl_ = 0;
m.Growth_ = 0;
m.Wage_ = 0;

m.std_Mp = 0;
m.std_Mw = 0;
m.std_Ea = 0.001;


m = steady(m);
checkSteady(m);
m = solve(m);

startDate = 1;
endDate = 40;
d = zerodb(m, startDate:endDate);
d.Ey(startDate) = log(1.01);
s = simulate(m, d, 1:40, 'Deviation', true, 'PrependInput', true ...
    , 'method', 'selective', 'progress', true, 'display', false);
