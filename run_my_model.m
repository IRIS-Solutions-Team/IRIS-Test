
% Read and simulate the model. Save this file as `run_my_model.m`.

% Housekeeping.
clear;
close all;
clc;

% Load model file and create a model object.
m = Model('my_simple_rbc.model');

% Assign parameters.
m.beta = 0.99;
m.gamma = 0.50;
m.delta = 0.03;
m.rho = 0.80;
m.a = 0.1;

% Find steady state and make sure it really is a valid steady state.
m = sstate(m);
chksstate(m);

% Solve the model.
m = solve(m);
disp(m);

% Create an input database for simulation, enter a shock, and display the
% input time series for the shock on the screen.
d = zerodb(m, 1:40);
d.ea(1) = 0.10;
disp(d.ea{1:5});

% Simulate model in shock-minus-control mode.
s = simulate(m, d, 1:40, 'Deviation=', true, 'AppendPresample=', true);
disp(s);

% Plot simulated paths.
dbplot(s, 0:40, {'Y', 'C', 'K', 'A', '400*r'}, 'ZeroLine=', true);
