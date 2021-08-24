%% Simulate Simple Shock Responses
%
% Simulate a simple shock both as deviations from control and in full
% levels, and report the simulation results.

%% Clear Workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IrisT version.

close all
clear
%#ok<*VUNUS> 


%% Load Solved Model Object
%
% Load the solved model object built in <read_model.html read_model>. Run
% `read_model` at least once before running this m-file.

load mat/createModel.mat m


%% Define Dates
%
% Define the start and end dates as plain numbered periods here.

startDate = 1;
endDate = 40;

%
% Alternatively, use the IrisT functions `yy()`, `hh()`, `qq()`, or `mm()`,
% `ww()`, or `dd()` to create and use proper dates (with yearly,
% half-yearly, quarterly, monthly, weekly, or daily frequency,
% respectively). For instance,
%
%    startdate = qq(2010,1);
%    enddate = startdate + 39;
%


%% Simulate Consumption Demand Shock
%
% Simulate the shock as deviations from control (e.g. from the steady state
% or balanced-growth path). To this end, set the option `Deviation=true`.
% Both the input and output database are then interpreted as deviations
% from control:
%
% * the deviations for linearised variables are defined as 
% $x_t - x_t$: 
% hence, 0 means the variable is on its steady state.
% * the deviations for log-linearised variables are defined as 
% $x_t / \bar x_t$: 
% hence, 1 means the variable is on its steady state, or 1.05 means
% it is 5 % above it.
%
% The function `zerodb( )` finds the maximum lag in the model, and creates
% the input database accordingly so that it includes all necessary initial
% conditions.

d = zerodb(m, startDate:endDate);
d.Ey(startDate) = log(1.01);
s = simulate(m, d, 1:40, 'deviation', true, 'prependInput', true)


%% Report Simulation Results
%
% Use the `databank.Chartpack( )` object to create a quick report of simulation
% results.  Note how we use the `Transform` property to plot percent
% deviations of individual variables.
%

ch = databank.Chartpack();
ch.Range = startDate-1 : startDate+19;
ch.Transform = @(x) 100*(x-1);
ch.Round = 8;

ch < "Inflation, Q/Q PA // Pp Deviations: dP^4 ";
ch < "Policy rate, PA // Pp Deviations: R^4 ";
ch < "Output // Pct Level Deviations: Y ";
ch < "Hours Worked // Pct Level Deviations: N ";
ch < "Real Wage // Pct Level Deviations: W/P ";
ch < "Capital Price // Pct Level Deviations: Pk"; 

draw(ch, s);
visual.heading("Consumption Demand Shock -- Deviations from Control");


%% Simulate shock in full levels
%
% Instead of deviations from control, simulate now the same shocks in full
% levels. To that end, create an input dabase with the steady state
% (balanced-growth path) using `steadydb( )`, and keep the option
% `Deviation=false` (default). When reporting the results, plot both the
% simulated shock against the steady-state (balanced-growth path) database.
%

d = steadydb(m, startDate:endDate);
d.Ey(startDate) = log(1.01);
s = simulate(m, d, 1:40, 'prependInput', true);

tempDb = databank.merge("horzcat", s, d);
draw(ch, tempDb);
visual.heading('Consumption Demand Shock -- Full Levels');

