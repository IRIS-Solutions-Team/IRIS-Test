% Read and simulate the model
% Save this file as `run_my_model.m`.

% Clear workspace
clear;
close all;
clc;
%#ok<*NOPTS>

% Load model file 4nd create model object
m = Model('my_simple_rbc.model');

% Assign parameters
m.beta = 0.99;
m.gamma = 0.50;
m.delta = 0.03;
m.rho = 0.80;
m.a = 0.1;

% Compute steady state and make sure it really is a valid steady state
m = sstate(m);
chksstate(m);

% Compute first-order solution
m = solve(m) 

% Set up input database for simulation
% * Create a steady-state database
% * Enter a productivity shock
% * Display the input time series for the shock on the screen
d = sstatedb(m, 1:40)
d.ea(1) = 0.10;
d.ea{1:5}

% Simulate model response to the shock
s = simulate(m, d, 1:40, 'AppendPresample=', true)

% Plot simulated paths
dbplot(s, 0:40, ...
    {'Y', 'C', 'K', 'A', '400*r'}, ...
    'ZeroLine=', true);
