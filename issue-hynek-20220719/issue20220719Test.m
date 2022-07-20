
%% Test chicken model

m = Model.fromFile('ChickenModel.mod','Growth',true);
m = alter(m,3);
m.Beta = 0.97;
m.Gamma = 0.65;
m.Sigma = 1.5;
m.Delta = 0.2;
m.rho = 0.6;
m.dA_ss = [1.04 1.0 1.04];

m = steady(m);
checkSteady(m);

table(m, {'SteadyLevel', 'SteadyChange', 'Form', 'Description'})

