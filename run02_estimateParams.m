%% Estimate parameters using numerical vs user supplied steady function

close all
clear

load mat/createModel.mat m
checkSteady(m);
m = solve(m);


%% Simulate random data from the model

rng(0);
T = 1000;
d = databank.forModel(m, 1:T, "shockFunc", @randn);
s = simulate(m, d, 1:T);


%% Extract databank with observables

h = databank.copy(s, "sourceNames", @(n) startsWith(n, "obs_"));


%% Create estimation specs

est = struct();
est.gamma = {0.3, 0.1, 0.9};
est.sigma = {0.8, 0.1, 0.9};
est.rho = {0.3, 0.1, 0.9};


%% Estimate parameters

tic();
[summary1, ~, ~, ~, mest1] = estimate(m, h, 1:T, est, "steady", true, "solver", "fminsearch");
time1 = toc();

tic();
[summary2, ~, ~, ~, mest2] = estimate(m, h, 1:T, est, "steady", {"userFunc", @steadyFunc}, "solver", "fminsearch"); % {"userFunc", @steadyFunc});
time2 = toc();

summary1
summary2

time1
time2

