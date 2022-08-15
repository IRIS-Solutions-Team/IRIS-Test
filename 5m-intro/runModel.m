%% Read and simulate the model
% Save this file as `simpleSPBC.model`.


%% Clear workspace

clear;
drawnow();
close all;
clc;
%#ok<*NOPTS>


%% Load model file and create model object

m = Model.fromFile("simpleRBC.model");


%% Assign parameters

m.beta = 0.99;
m.gamma = 0.50;
m.delta = 0.03;
m.rho = 0.80;
m.a = 0.1;


%% Compute steady state
% * Calculate (stationary) steady state for given parameters
% * Make sure it is a valid steady state
% * Print a steady state table

m = steady(m);
checkSteady(m);


%% Show a steady state table

table(m, ["steadyLevel", "description"])


%% Compute first-order solution

m = solve(m) 


%% Set up input database for simulation
% * Create a steady-state database
% * Enter a productivity shock
% * Display the input time series for the shock on the screen

d0 = steadydb(m, 1:40)
d = d0;
d.ea(1) = 0.10;
d.ea{1:5}


%% Simulate model response to the shock

s = simulate( ...
    m, d, 1:40 ...
    ,"prependInput", true ...
);


%% Plot simulated paths against steady state

ch = databank.Chartpack();
ch.Range = 0:40;
ch.Autocaption = true;
ch.ShowFormulas = true;
add(ch, ["Y", "C", "K", "A", "400*r"]);

chartDb = databank.merge("horzcat", s, d0);
draw(ch, chartDb);

visual.hlegend("bottom", "Simulation", "Steady state");


