

drawnow();
close all
clear
mkdir mat

m = Model.fromFile("model-source/solow.model");

m.gamma = 0.5;
m.sigma = 0.6;
m.rho = 0.8;

m0 = m;
m0 = steady(m0);
checkSteady(m0);

m1 = m;
m1 = steady(m1, "userFunc", @steadyFunc);
checkSteady(m1);

m2 = m0;
m2.k = m0.k * 0.95;
m2 = steady(m2, "exogenize", ["k"], "endogenize", ["sigma"]);
checkSteady(m2);

m3 = m0;
m3.k = m0.k * 0.95;
m3 = steady(m3, "userFunc", @steadyInvFunc);
checkSteady(m3);

m = m0;
checkSteady(m);
m = solve(m);

save mat/createModel.mat m

